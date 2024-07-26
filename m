Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0C41494CD;
	Fri, 26 Jul 2024 20:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026297; cv=none; b=hGrRAzztW076izODkxgTFHZ9h1MhPcxCl0zgL+rcf9i5YMa9LC1RKSFa1Wglfqr5EH1U3+O8tURoDuj89mVHmJpS7hPRQJLrVCQOlxHhYfOpMUND33CBLTJ1Y2oN+xwyFd9QD/pSFI8CYbpaZdLu6tvbiIylWJXs0LGLX2E8xM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026297; c=relaxed/simple;
	bh=bnlXMXLn7XPMRFAmuCRD1hYkCui1/Iq+C4A5mNFxAxo=;
	h=Date:To:From:Subject:Message-Id; b=ZZFXfxyTpR0YjWsm9u9IfHC6z5bIv1Vtj/gKTlztiGhQMgZ2hgh4nErjRwOZZb7x1uKTrQeUZvpx6m+h2tqxhA06/FgZ843ouDFXw2I1dss1rTjVx1JxM5XPR7MpW+Jt3zg44q6FPWr9jmwxyY+ZY7o/vjzkbtnEYh/x4CpbSj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZapahxOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZapahxOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AC9C32782;
	Fri, 26 Jul 2024 20:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026296;
	bh=bnlXMXLn7XPMRFAmuCRD1hYkCui1/Iq+C4A5mNFxAxo=;
	h=Date:To:From:Subject:From;
	b=ZapahxOirk+pM7ep3mL8nYLO6CQMLJaQ7JxOPz70Mgq+5t1vAhjAQH1a9CHJ507j0
	 LqlWpJh33pgKWEgZv8gmFWxD9NX/J7jR5kKITDWZlelFIA5m8lPCNcICRR1/I9GxsT
	 cN4dEl1e6eISvMlzmXIYZDM3soLGj9djGWH1Hrrw=
Date: Fri, 26 Jul 2024 13:38:16 -0700
To: mm-commits@vger.kernel.org,yaoxt.fnst@fujitsu.com,vbabka@suse.cz,stable@vger.kernel.org,david@redhat.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-fix-pcp-count-race-between-drain_pages_zone-vs-__rmqueue_pcplist.patch removed from -mm tree
Message-Id: <20240726203816.C2AC9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix pcp->count race between drain_pages_zone() vs __rmqueue_pcplist()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-pcp-count-race-between-drain_pages_zone-vs-__rmqueue_pcplist.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/page_alloc: fix pcp->count race between drain_pages_zone() vs __rmqueue_pcplist()
Date: Tue, 23 Jul 2024 14:44:28 +0800

It's expected that no page should be left in pcp_list after calling
zone_pcp_disable() in offline_pages().  Previously, it's observed that
offline_pages() gets stuck [1] due to some pages remaining in pcp_list.

Cause:
There is a race condition between drain_pages_zone() and __rmqueue_pcplist()
involving the pcp->count variable. See below scenario:

         CPU0                              CPU1
    ----------------                    ---------------
                                      spin_lock(&pcp->lock);
                                      __rmqueue_pcplist() {
zone_pcp_disable() {
                                        /* list is empty */
                                        if (list_empty(list)) {
                                          /* add pages to pcp_list */
                                          alloced = rmqueue_bulk()
  mutex_lock(&pcp_batch_high_lock)
  ...
  __drain_all_pages() {
    drain_pages_zone() {
      /* read pcp->count, it's 0 here */
      count = READ_ONCE(pcp->count)
      /* 0 means nothing to drain */
                                          /* update pcp->count */
                                          pcp->count += alloced << order;
      ...
                                      ...
                                      spin_unlock(&pcp->lock);

In this case, after calling zone_pcp_disable() though, there are still some
pages in pcp_list. And these pages in pcp_list are neither movable nor
isolated, offline_pages() gets stuck as a result.

Solution:
Expand the scope of the pcp->lock to also protect pcp->count in
drain_pages_zone(), to ensure no pages are left in the pcp list after
zone_pcp_disable()

[1] https://lore.kernel.org/linux-mm/6a07125f-e720-404c-b2f9-e55f3f166e85@fujitsu.com/

Link: https://lkml.kernel.org/r/20240723064428.1179519-1-lizhijian@fujitsu.com
Fixes: 4b23a68f9536 ("mm/page_alloc: protect PCP lists with a spinlock")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reported-by: Yao Xingtao <yaoxt.fnst@fujitsu.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-pcp-count-race-between-drain_pages_zone-vs-__rmqueue_pcplist
+++ a/mm/page_alloc.c
@@ -2343,16 +2343,20 @@ void drain_zone_pages(struct zone *zone,
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
 	struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
-	int count = READ_ONCE(pcp->count);
-
-	while (count) {
-		int to_drain = min(count, pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
-		count -= to_drain;
+	int count;
 
+	do {
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		count = pcp->count;
+		if (count) {
+			int to_drain = min(count,
+				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
+
+			free_pcppages_bulk(zone, to_drain, pcp, 0);
+			count -= to_drain;
+		}
 		spin_unlock(&pcp->lock);
-	}
+	} while (count);
 }
 
 /*
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are



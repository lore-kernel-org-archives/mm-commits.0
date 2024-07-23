Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C062913BAD5;
	Tue, 23 Jul 2024 23:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721778130; cv=none; b=L2CgSct8Fz3HvFoVeH0KnVSTNKbEHNDnXUVJ6lwb/m4GlOsoiEKEe/7FRJnUZ4wR8IB7+XCEQaEwm3euuI+h2jg0Uo8+z59DTV3YRJzdu6UDTBG7LghYaxkNaIkwAKaNK1b3RkMaGB8alFZ6k8cDbc/NUfeo2b8/yrgJKjdzXfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721778130; c=relaxed/simple;
	bh=Rs4LiG21LvaC+228rMu8nD6v4wr0Ti8neyhdM1Yppu4=;
	h=Date:To:From:Subject:Message-Id; b=NMGCihyRa0+7tmjBTqAiLAmMcMD/KQt3REp1oxwxG8krQaFZWM3zxk+TQ0EEShmpPToQRtmwsr4bEneQZetkGp7W5fNHYAorAu72Gx+A3u0S77byVMyR7GWNWvTJdXfSAYBTXP/o9qrZKKpLVb/t7nNsApZ8ezS7TF1Iidl9VSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FqJdwF7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FqJdwF7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD18C4AF09;
	Tue, 23 Jul 2024 23:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721778130;
	bh=Rs4LiG21LvaC+228rMu8nD6v4wr0Ti8neyhdM1Yppu4=;
	h=Date:To:From:Subject:From;
	b=FqJdwF7F/hf+YoYPHnYacENKoAoW4vydRmhJ+nQDfyp4RuGwGijZD4WPjOUsdk8k8
	 Jni7mo5GyC7tFWAdOa0e9y9MgYgmAmbtM3tBSSg4hChg+U6kRyQxu5Y9hlaGZxqV7z
	 2Vles0aQ7K/9FfBae3MOgXRRSe8bI6dimbgy04So=
Date: Tue, 23 Jul 2024 16:42:09 -0700
To: mm-commits@vger.kernel.org,yaoxt.fnst@fujitsu.com,vbabka@suse.cz,stable@vger.kernel.org,david@redhat.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-pcp-count-race-between-drain_pages_zone-vs-__rmqueue_pcplist.patch added to mm-hotfixes-unstable branch
Message-Id: <20240723234210.3DD18C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix pcp->count race between drain_pages_zone() vs __rmqueue_pcplist()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-pcp-count-race-between-drain_pages_zone-vs-__rmqueue_pcplist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-pcp-count-race-between-drain_pages_zone-vs-__rmqueue_pcplist.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-page_alloc-fix-pcp-count-race-between-drain_pages_zone-vs-__rmqueue_pcplist.patch


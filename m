Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88777D3F0
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103967; cv=none; b=De3AEKdTfvOCK+D/l4fi7z4yI7Qmx73mZtBOKQGfdgQpUzfK1v3I946XcsGRoK2k8nYxPI/tNLYAboMworz9HcMJqm10ZR6lBvLqS47Q5y+n9mWPteZ3NzqKAhHKdxnlvLszI6OQdJ7+cl1twMmNMGI3XKD5QDyxxjE5oQb99wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103967; c=relaxed/simple;
	bh=4COVOBi2wSe0wH0il6Z3dPWYQGOTEJcctQf792C41LE=;
	h=Date:To:From:Subject:Message-Id; b=DA/mzcPzBjLdZ2D2MGzC584fS6qRiFuArc668cbqFP1TtKJZ3143cfvK+xPzyiR051ZF39yHLuAZxIzLz5WnQmAAlsuRAMA78Xcjnq3VYgDkGj/rGvk0WKScXYZaryche82WSqbuPKPIphWnx32Y6mmMMyWobTITtH+A4gHx8F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WHy9f7Yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WHy9f7Yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC97BC113CD;
	Fri, 26 Apr 2024 03:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103967;
	bh=4COVOBi2wSe0wH0il6Z3dPWYQGOTEJcctQf792C41LE=;
	h=Date:To:From:Subject:From;
	b=WHy9f7Yt6HP9UKGtiQ3XgSvQ88sFONfVriVMiNQe3HJdy478W238mbRyXpe1HFRQi
	 x1K2LudggNTrdHxlS6M0kvgYP+JmcCTXIhqqLZf4lpoShhwN93S+4MtISJObWy4vJX
	 d9lDXgmzXja3JRngtaNiWiohaBdszrwS2I4N3YLU=
Date: Thu, 25 Apr 2024 20:59:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-batch-vmstat-updates-in-expand.patch removed from -mm tree
Message-Id: <20240426035927.AC97BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: batch vmstat updates in expand()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-batch-vmstat-updates-in-expand.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: batch vmstat updates in expand()
Date: Wed, 27 Mar 2024 15:01:11 -0400

expand() currently updates vmstat for every subpage.  This is unnecessary,
since they're all of the same zone and migratetype.

Count added pages locally, then do a single vmstat update.

Link: https://lkml.kernel.org/r/20240327190111.GC7597@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-batch-vmstat-updates-in-expand
+++ a/mm/page_alloc.c
@@ -1335,6 +1335,7 @@ static inline void expand(struct zone *z
 	int low, int high, int migratetype)
 {
 	unsigned long size = 1 << high;
+	unsigned long nr_added = 0;
 
 	while (high > low) {
 		high--;
@@ -1350,9 +1351,11 @@ static inline void expand(struct zone *z
 		if (set_page_guard(zone, &page[size], high))
 			continue;
 
-		add_to_free_list(&page[size], zone, high, migratetype, false);
+		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
+		nr_added += size;
 	}
+	account_freepages(zone, nr_added, migratetype);
 }
 
 static void check_new_page_bad(struct page *page)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



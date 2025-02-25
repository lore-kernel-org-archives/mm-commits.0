Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D276A33EC
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 02:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740450498; cv=none; b=t6pSmpTmtjsXMmSZMtYZaS0Fj+dhT2SCszn+6xqQqZhig8l9BNv9/HOuWm3IeuCbYO5a0tIhh/T2NQVUXG1DBYsPpKd6PAsQuDjMiKR5tv6SxJsUa9A1DGRmiaovO3HxYxuGJ1Qntt5Z+kFiRdzaUWkz6BLnJCQ5WrUP0P2kWoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740450498; c=relaxed/simple;
	bh=56adwnc3ewMMZkpQ4xNwaviiNqOYHZ83kV31tZHo+I0=;
	h=Date:To:From:Subject:Message-Id; b=UADImqEOdisRGPocYjVCx7F8xu13ES3t6Py3aJ4LId9/Hb3slvOlL8FqxFQoT7Qo5m6WZyDwFRh3ko+Vc86Ph3jrcsz7VlPxHNVXiB5jm0bOLnWQbmoA+FiOkHFGSJ20cjWg4E9YKAprLLM+vkKa7Hadu7okCLCrZpc3hgexM5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iMJS/67D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iMJS/67D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4472DC4CED6;
	Tue, 25 Feb 2025 02:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740450498;
	bh=56adwnc3ewMMZkpQ4xNwaviiNqOYHZ83kV31tZHo+I0=;
	h=Date:To:From:Subject:From;
	b=iMJS/67DrbpbHciKKojQAxF/reoQQabcG6ckafzEQ4/R3xgmXTUFXfHUA2p9JqhUV
	 ebyffZiTPA/dCIwD+wrKBLXUWPF0mYNvRgVR6QO0ah/RTNZG3uhpUZ41cD0cu3n2f0
	 q100AHG5BYXP71+oOu5QZTUriau2R5q1APojFCac=
Date: Mon, 24 Feb 2025 18:28:17 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch added to mm-unstable branch
Message-Id: <20250225022818.4472DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: remove remnants of unlocked migratetype updates
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch

This patch will later appear in the mm-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: remove remnants of unlocked migratetype updates
Date: Mon, 24 Feb 2025 19:08:25 -0500

The freelist hygiene patches made migratetype accesses fully protected
under the zone->lock.  Remove remnants of handling the race conditions
that existed before from the MIGRATE_HIGHATOMIC code.

Link: https://lkml.kernel.org/r/20250225001023.1494422-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   50 ++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates
+++ a/mm/page_alloc.c
@@ -1991,20 +1991,10 @@ static inline bool boost_watermark(struc
 static struct page *
 try_to_steal_block(struct zone *zone, struct page *page,
 		   int current_order, int order, int start_type,
-		   unsigned int alloc_flags)
+		   int block_type, unsigned int alloc_flags)
 {
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
-	int block_type;
-
-	block_type = get_pageblock_migratetype(page);
-
-	/*
-	 * This can happen due to races and we want to prevent broken
-	 * highatomic accounting.
-	 */
-	if (is_migrate_highatomic(block_type))
-		return NULL;
 
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
@@ -2179,33 +2169,22 @@ static bool unreserve_highatomic_pageblo
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
-			int mt;
+			unsigned long size;
 
 			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
 			if (!page)
 				continue;
 
-			mt = get_pageblock_migratetype(page);
 			/*
-			 * In page freeing path, migratetype change is racy so
-			 * we can counter several free pages in a pageblock
-			 * in this loop although we changed the pageblock type
-			 * from highatomic to ac->migratetype. So we should
-			 * adjust the count once.
+			 * It should never happen but changes to
+			 * locking could inadvertently allow a per-cpu
+			 * drain to add pages to MIGRATE_HIGHATOMIC
+			 * while unreserving so be safe and watch for
+			 * underflows.
 			 */
-			if (is_migrate_highatomic(mt)) {
-				unsigned long size;
-				/*
-				 * It should never happen but changes to
-				 * locking could inadvertently allow a per-cpu
-				 * drain to add pages to MIGRATE_HIGHATOMIC
-				 * while unreserving so be safe and watch for
-				 * underflows.
-				 */
-				size = max(pageblock_nr_pages, 1UL << order);
-				size = min(size, zone->nr_reserved_highatomic);
-				zone->nr_reserved_highatomic -= size;
-			}
+			size = max(pageblock_nr_pages, 1UL << order);
+			size = min(size, zone->nr_reserved_highatomic);
+			zone->nr_reserved_highatomic -= size;
 
 			/*
 			 * Convert to ac->migratetype and avoid the normal
@@ -2217,10 +2196,12 @@ static bool unreserve_highatomic_pageblo
 			 * may increase.
 			 */
 			if (order < pageblock_order)
-				ret = move_freepages_block(zone, page, mt,
+				ret = move_freepages_block(zone, page,
+							   MIGRATE_HIGHATOMIC,
 							   ac->migratetype);
 			else {
-				move_to_free_list(page, zone, order, mt,
+				move_to_free_list(page, zone, order,
+						  MIGRATE_HIGHATOMIC,
 						  ac->migratetype);
 				change_pageblock_range(page, order,
 						       ac->migratetype);
@@ -2294,7 +2275,8 @@ __rmqueue_fallback(struct zone *zone, in
 
 		page = get_page_from_free_area(area, fallback_mt);
 		page = try_to_steal_block(zone, page, current_order, order,
-					  start_migratetype, alloc_flags);
+					  start_migratetype, fallback_mt,
+					  alloc_flags);
 		if (page)
 			goto got_one;
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch
mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch
mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch
mm-page_alloc-dont-steal-single-pages-from-biggest-buddy.patch
mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch
mm-page_alloc-group-fallback-functions-together.patch


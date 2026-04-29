Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2723A3803DD
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477072; cv=none; b=ZidWyz7Ry9VqFuZUZ7AUxq3+zTMaAygo/YaY5qexvt/yv558SHGVpcjhfjTQdRo0m66Np2fHiAzzzGo2tfnZ7OfDyEizwd6YHw87RcOz0lnsnrG9+XX9gag3RVtYJEt8RTSE4ITWRa+HGvIsjT5wZqXiHA1kBHOiIfJ1qSe/q18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477072; c=relaxed/simple;
	bh=raCMh0BTaiye+wT1/VhlwO3b57CKmslBVDFxrO2PJPo=;
	h=Date:To:From:Subject:Message-Id; b=sLXNh/k+QcvGO3V/d/T4j5C6kBiBKQy+FwXhu0yBMmqax6iqXyrsrs+yJaJXOTn/bzywH9PWuK9R5btVA0zxU9Yz4MKtBTHqSUyAJpAwO2nByNxxkks05+55s1tnZLh3JHMoFgZOKEmCcmnrP3+l3QGRs3LTo8Yghk/K89jsaHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wJpUds23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wJpUds23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8249C19425;
	Wed, 29 Apr 2026 15:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777477071;
	bh=raCMh0BTaiye+wT1/VhlwO3b57CKmslBVDFxrO2PJPo=;
	h=Date:To:From:Subject:From;
	b=wJpUds23yS34Rr/zauSCSPc2RM74oxGl3Li8+bMMEO3XSUr6cySGP2olroSD1k75I
	 ala9Q1Y2O0zQb1/j05a8WZYBQdVCSqyGAZtHWFxQiqdytGTBBClTMm6m0FwoxYPnKA
	 wRV2PJ1X8SXpxP1t30M3ehf2xaThHV2mbb7wxY/4=
Date: Wed, 29 Apr 2026 08:37:51 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zone-lock-guard-in-set_migratetype_isolate.patch added to mm-new branch
Message-Id: <20260429153751.B8249C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zone lock guard in set_migratetype_isolate()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-zone-lock-guard-in-set_migratetype_isolate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zone-lock-guard-in-set_migratetype_isolate.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in set_migratetype_isolate()
Date: Wed, 29 Apr 2026 12:02:09 +0000

Use spinlock_irqsave scoped lock guard in set_migratetype_isolate() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup.  The scoped variant is used to keep dump_page() outside the
locked section to avoid a lockdep splat.

Link: https://lore.kernel.org/6883351ad7f74d20875fff30e0e3214a089cea97.1777462630.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   60 ++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 34 deletions(-)

--- a/mm/page_isolation.c~mm-use-zone-lock-guard-in-set_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -167,48 +167,40 @@ static int set_migratetype_isolate(struc
 {
 	struct zone *zone = page_zone(page);
 	struct page *unmovable;
-	unsigned long flags;
 	unsigned long check_unmovable_start, check_unmovable_end;
 
 	if (PageUnaccepted(page))
 		accept_page(page);
 
-	spin_lock_irqsave(&zone->lock, flags);
-
-	/*
-	 * We assume the caller intended to SET migrate type to isolate.
-	 * If it is already set, then someone else must have raced and
-	 * set it before us.
-	 */
-	if (is_migrate_isolate_page(page)) {
-		spin_unlock_irqrestore(&zone->lock, flags);
-		return -EBUSY;
-	}
-
-	/*
-	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
-	 * We just check MOVABLE pages.
-	 *
-	 * Pass the intersection of [start_pfn, end_pfn) and the page's pageblock
-	 * to avoid redundant checks.
-	 */
-	check_unmovable_start = max(page_to_pfn(page), start_pfn);
-	check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
-				  end_pfn);
-
-	unmovable = has_unmovable_pages(check_unmovable_start, check_unmovable_end,
-			mode);
-	if (!unmovable) {
-		if (!pageblock_isolate_and_move_free_pages(zone, page)) {
-			spin_unlock_irqrestore(&zone->lock, flags);
+	scoped_guard(spinlock_irqsave, &zone->lock) {
+		/*
+		 * We assume the caller intended to SET migrate type to
+		 * isolate. If it is already set, then someone else must have
+		 * raced and set it before us.
+		 */
+		if (is_migrate_isolate_page(page))
 			return -EBUSY;
+
+		/*
+		 * FIXME: Now, memory hotplug doesn't call shrink_slab() by
+		 * itself. We just check MOVABLE pages.
+		 *
+		 * Pass the intersection of [start_pfn, end_pfn) and the page's
+		 * pageblock to avoid redundant checks.
+		 */
+		check_unmovable_start = max(page_to_pfn(page), start_pfn);
+		check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
+					  end_pfn);
+
+		unmovable = has_unmovable_pages(check_unmovable_start,
+				check_unmovable_end, mode);
+		if (!unmovable) {
+			if (!pageblock_isolate_and_move_free_pages(zone, page))
+				return -EBUSY;
+			zone->nr_isolate_pageblock++;
+			return 0;
 		}
-		zone->nr_isolate_pageblock++;
-		spin_unlock_irqrestore(&zone->lock, flags);
-		return 0;
 	}
-
-	spin_unlock_irqrestore(&zone->lock, flags);
 	if (mode == PB_ISOLATE_MODE_MEM_OFFLINE) {
 		/*
 		 * printk() with zone->lock held will likely trigger a
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch
mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-set_migratetype_isolate.patch
mm-use-zone-lock-guard-in-take_page_off_buddy.patch
mm-use-zone-lock-guard-in-put_page_back_buddy.patch
mm-use-zone-lock-guard-in-free_pcppages_bulk.patch
mm-use-zone-lock-guard-in-__offline_isolated_pages.patch


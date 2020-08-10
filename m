Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E30C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAEF0206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027222;
	bh=T3JZaYdZAoWULah76Mcimf3m6vheBIgKAV9ykZeQY6I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LwcdfcbSFQMpXmq1xBK/OrrAoVSXfrmh5fjUWYmcKlWFFRgeW2nRtTJ9/VISdI6BD
	 HZlEV9uxsy2dqXDRmFbSQm9d58ujJjebOwoapHa79Dhb1sdgbyAMtk8fib24t08KCL
	 Uk53XQdPH6Rq9Ox69hXZF8G+s+vSg6piLZSJWkB8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHJCkW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCkV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA5C72065D;
        Mon, 10 Aug 2020 02:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027221;
        bh=T3JZaYdZAoWULah76Mcimf3m6vheBIgKAV9ykZeQY6I=;
        h=Date:From:To:Subject:From;
        b=MdrKijuSPF5mvI9WD3Rtyc808JbFeCYE8gYHJYPkbF4xDhtzAi7KjB9MEzhP+nhIt
         8zuBld+ht47MafbtNk/2ZBIhOw6+PLGQ7Dfk4R1BrGmZj0FBzNiV9yF8SISk6nQSwj
         Du5KU9ZbQcE4VJZGfosyL3FtPksCGfQToimQnE90=
Date:   Sun, 09 Aug 2020 19:40:20 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-fix-memalloc_nocma_save-restore-apis.patch removed from -mm
 tree
Message-ID: <20200810024020.OQINlqEC-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-memalloc_nocma_save-restore-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc: fix memalloc_nocma_{save/restore} APIs

Currently, memalloc_nocma_{save/restore} API that prevents CMA area
in page allocation is implemented by using current_gfp_context(). However,
there are two problems of this implementation.

First, this doesn't work for allocation fastpath. In the fastpath,
original gfp_mask is used since current_gfp_context() is introduced in
order to control reclaim and it is on slowpath. So, CMA area can be
allocated through the allocation fastpath even if
memalloc_nocma_{save/restore} APIs are used. Currently, there is just
one user for these APIs and it has a fallback method to prevent actual
problem.
Second, clearing __GFP_MOVABLE in current_gfp_context() has a side effect
to exclude the memory on the ZONE_MOVABLE for allocation target.

To fix these problems, this patch changes the implementation to exclude
CMA area in page allocation. Main point of this change is using the
alloc_flags. alloc_flags is mainly used to control allocation so it fits
for excluding CMA area in allocation.

Link: http://lkml.kernel.org/r/1595468942-29687-1-git-send-email-iamjoonsoo.kim@lge.com
Fixes: d7fefcc8de91 (mm/cma: add PF flag to force non cma alloc)
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    8 +-------
 mm/page_alloc.c          |   31 +++++++++++++++++++++----------
 2 files changed, 22 insertions(+), 17 deletions(-)

--- a/include/linux/sched/mm.h~mm-page_alloc-fix-memalloc_nocma_save-restore-apis
+++ a/include/linux/sched/mm.h
@@ -175,12 +175,10 @@ static inline bool in_vfork(struct task_
  * Applies per-task gfp context to the given allocation flags.
  * PF_MEMALLOC_NOIO implies GFP_NOIO
  * PF_MEMALLOC_NOFS implies GFP_NOFS
- * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely(current->flags &
-		     (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA))) {
+	if (unlikely(current->flags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS))) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
@@ -189,10 +187,6 @@ static inline gfp_t current_gfp_context(
 			flags &= ~(__GFP_IO | __GFP_FS);
 		else if (current->flags & PF_MEMALLOC_NOFS)
 			flags &= ~__GFP_FS;
-#ifdef CONFIG_CMA
-		if (current->flags & PF_MEMALLOC_NOCMA)
-			flags &= ~__GFP_MOVABLE;
-#endif
 	}
 	return flags;
 }
--- a/mm/page_alloc.c~mm-page_alloc-fix-memalloc_nocma_save-restore-apis
+++ a/mm/page_alloc.c
@@ -2785,7 +2785,7 @@ __rmqueue(struct zone *zone, unsigned in
 	 * allocating from CMA when over half of the zone's free memory
 	 * is in the CMA area.
 	 */
-	if (migratetype == MIGRATE_MOVABLE &&
+	if (alloc_flags & ALLOC_CMA &&
 	    zone_page_state(zone, NR_FREE_CMA_PAGES) >
 	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
 		page = __rmqueue_cma_fallback(zone, order);
@@ -2796,7 +2796,7 @@ __rmqueue(struct zone *zone, unsigned in
 retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
-		if (migratetype == MIGRATE_MOVABLE)
+		if (alloc_flags & ALLOC_CMA)
 			page = __rmqueue_cma_fallback(zone, order);
 
 		if (!page && __rmqueue_fallback(zone, order, migratetype,
@@ -3687,6 +3687,20 @@ alloc_flags_nofragment(struct zone *zone
 	return alloc_flags;
 }
 
+static inline unsigned int current_alloc_flags(gfp_t gfp_mask,
+					unsigned int alloc_flags)
+{
+#ifdef CONFIG_CMA
+	unsigned int pflags = current->flags;
+
+	if (!(pflags & PF_MEMALLOC_NOCMA) &&
+			gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
+
+#endif
+	return alloc_flags;
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -4333,10 +4347,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-#ifdef CONFIG_CMA
-	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
-#endif
+	alloc_flags = current_alloc_flags(gfp_mask, alloc_flags);
+
 	return alloc_flags;
 }
 
@@ -4637,7 +4649,7 @@ retry:
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = reserve_flags;
+		alloc_flags = current_alloc_flags(gfp_mask, reserve_flags);
 
 	/*
 	 * Reset the nodemask and zonelist iterators if memory policies can be
@@ -4714,7 +4726,7 @@ retry:
 
 	/* Avoid allocations with no watermarks from looping endlessly */
 	if (tsk_is_oom_victim(current) &&
-	    (alloc_flags == ALLOC_OOM ||
+	    (alloc_flags & ALLOC_OOM ||
 	     (gfp_mask & __GFP_NOMEMALLOC)))
 		goto nopage;
 
@@ -4806,8 +4818,7 @@ static inline bool prepare_alloc_pages(g
 	if (should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
-		*alloc_flags |= ALLOC_CMA;
+	*alloc_flags = current_alloc_flags(gfp_mask, *alloc_flags);
 
 	return true;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmscan-make-active-inactive-ratio-as-1-1-for-anon-lru.patch
mm-vmscan-protect-the-workingset-on-anonymous-lru.patch
mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch
mm-swapcache-support-to-handle-the-shadow-entries.patch
mm-swap-implement-workingset-detection-for-anonymous-lru.patch
mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch
mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch
mm-gup-restrict-cma-region-by-using-allocation-scope-api.patch
mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch
mm-gup-use-a-standard-migration-target-allocation-callback.patch


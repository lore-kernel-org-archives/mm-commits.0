Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965B2C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F592078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266081;
	bh=LGWC63abO/tW0gScTj81otFZjo9kYuf2jV/Q6I79ktk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1WU+PA7J8PAlJoIeyyDhywToew4b2aAjjR1sl906RA/rcwiSFr8Ou5PzwnCxsRq+3
	 yjtKGrh10jHhQbRW7A51HhNSGk3Eu4LXTObuyMMId173hQDsnkyNofAGArjRedroaW
	 ASKi4emtZm30QXkitmAsAWeFptYD1CpQzxAqzXd8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHLVBV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVBU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9903520838;
        Wed, 12 Aug 2020 21:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266079;
        bh=LGWC63abO/tW0gScTj81otFZjo9kYuf2jV/Q6I79ktk=;
        h=Date:From:To:Subject:From;
        b=RZC/ieHVUGfCfIPuCxgsD9icIi0SWGx4BVR48/w+nEXFEeUSAW1Fr+YZ2p0Kdl6RZ
         QiBMTaQdKo6l2YiVCfmIwgQbWUuunAhjBhQ/ShcTLf+9omuJ+kIcVa5ATKVUT6Wwga
         ugTMwelsVcmEo1ekPGskPzrZxpF9G0b4jo/hqjRk=
Date:   Wed, 12 Aug 2020 14:01:19 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 mm-vmscan-protect-the-workingset-on-anonymous-lru.patch removed from -mm
 tree
Message-ID: <20200812210119.7qaTfgUFz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: protect the workingset on anonymous LRU
has been removed from the -mm tree.  Its filename was
     mm-vmscan-protect-the-workingset-on-anonymous-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/vmscan: protect the workingset on anonymous LRU

In current implementation, newly created or swap-in anonymous page is
started on active list.  Growing active list results in rebalancing
active/inactive list so old pages on active list are demoted to inactive
list.  Hence, the page on active list isn't protected at all.

Following is an example of this situation.

Assume that 50 hot pages on active list.  Numbers denote the number of
pages on active/inactive list (active | inactive).

1. 50 hot pages on active list
50(h) | 0

2. workload: 50 newly created (used-once) pages
50(uo) | 50(h)

3. workload: another 50 newly created (used-once) pages
50(uo) | 50(uo), swap-out 50(h)

This patch tries to fix this issue.  Like as file LRU, newly created or
swap-in anonymous pages will be inserted to the inactive list.  They are
promoted to active list if enough reference happens.  This simple
modification changes the above example as following.

1. 50 hot pages on active list
50(h) | 0

2. workload: 50 newly created (used-once) pages
50(h) | 50(uo)

3. workload: another 50 newly created (used-once) pages
50(h) | 50(uo), swap-out 50(uo)

As you can see, hot pages on active list would be protected.

Note that, this implementation has a drawback that the page cannot be
promoted and will be swapped-out if re-access interval is greater than the
size of inactive list but less than the size of total(active+inactive). 
To solve this potential issue, following patch will apply workingset
detection similar to the one that's already applied to file LRU.

Link: http://lkml.kernel.org/r/1595490560-15117-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h    |    2 +-
 kernel/events/uprobes.c |    2 +-
 mm/huge_memory.c        |    2 +-
 mm/khugepaged.c         |    2 +-
 mm/memory.c             |    9 ++++-----
 mm/migrate.c            |    2 +-
 mm/swap.c               |   13 +++++++------
 mm/swapfile.c           |    2 +-
 mm/userfaultfd.c        |    2 +-
 mm/vmscan.c             |    4 +---
 10 files changed, 19 insertions(+), 21 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/include/linux/swap.h
@@ -352,7 +352,7 @@ extern void deactivate_page(struct page
 extern void mark_page_lazyfree(struct page *page);
 extern void swap_setup(void);
 
-extern void lru_cache_add_active_or_unevictable(struct page *page,
+extern void lru_cache_add_inactive_or_unevictable(struct page *page,
 						struct vm_area_struct *vma);
 
 /* linux/mm/vmscan.c */
--- a/kernel/events/uprobes.c~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/kernel/events/uprobes.c
@@ -184,7 +184,7 @@ static int __replace_page(struct vm_area
 	if (new_page) {
 		get_page(new_page);
 		page_add_new_anon_rmap(new_page, vma, addr, false);
-		lru_cache_add_active_or_unevictable(new_page, vma);
+		lru_cache_add_inactive_or_unevictable(new_page, vma);
 	} else
 		/* no new page, just dec_mm_counter for old_page */
 		dec_mm_counter(mm, MM_ANONPAGES);
--- a/mm/huge_memory.c~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/mm/huge_memory.c
@@ -640,7 +640,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		page_add_new_anon_rmap(page, vma, haddr, true);
-		lru_cache_add_active_or_unevictable(page, vma);
+		lru_cache_add_inactive_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
 		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
--- a/mm/khugepaged.c~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/mm/khugepaged.c
@@ -1173,7 +1173,7 @@ static void collapse_huge_page(struct mm
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address, true);
-	lru_cache_add_active_or_unevictable(new_page, vma);
+	lru_cache_add_inactive_or_unevictable(new_page, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache_pmd(vma, address, pmd);
--- a/mm/memory.c~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/mm/memory.c
@@ -2715,7 +2715,7 @@ static vm_fault_t wp_page_copy(struct vm
 		 */
 		ptep_clear_flush_notify(vma, vmf->address, vmf->pte);
 		page_add_new_anon_rmap(new_page, vma, vmf->address, false);
-		lru_cache_add_active_or_unevictable(new_page, vma);
+		lru_cache_add_inactive_or_unevictable(new_page, vma);
 		/*
 		 * We call the notify macro here because, when using secondary
 		 * mmu page tables (such as kvm shadow page tables), we want the
@@ -3266,10 +3266,9 @@ vm_fault_t do_swap_page(struct vm_fault
 	/* ksm created a completely new copy */
 	if (unlikely(page != swapcache && swapcache)) {
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
-		lru_cache_add_active_or_unevictable(page, vma);
+		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
 		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
-		activate_page(page);
 	}
 
 	swap_free(entry);
@@ -3414,7 +3413,7 @@ static vm_fault_t do_anonymous_page(stru
 
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, vmf->address, false);
-	lru_cache_add_active_or_unevictable(page, vma);
+	lru_cache_add_inactive_or_unevictable(page, vma);
 setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
 
@@ -3672,7 +3671,7 @@ vm_fault_t alloc_set_pte(struct vm_fault
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
-		lru_cache_add_active_or_unevictable(page, vma);
+		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
 		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
 		page_add_file_rmap(page, false);
--- a/mm/migrate.c~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/mm/migrate.c
@@ -2830,7 +2830,7 @@ static void migrate_vma_insert_page(stru
 	inc_mm_counter(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, addr, false);
 	if (!is_zone_device_page(page))
-		lru_cache_add_active_or_unevictable(page, vma);
+		lru_cache_add_inactive_or_unevictable(page, vma);
 	get_page(page);
 
 	if (flush) {
--- a/mm/swap.c~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/mm/swap.c
@@ -476,23 +476,24 @@ void lru_cache_add(struct page *page)
 EXPORT_SYMBOL(lru_cache_add);
 
 /**
- * lru_cache_add_active_or_unevictable
+ * lru_cache_add_inactive_or_unevictable
  * @page:  the page to be added to LRU
  * @vma:   vma in which page is mapped for determining reclaimability
  *
- * Place @page on the active or unevictable LRU list, depending on its
+ * Place @page on the inactive or unevictable LRU list, depending on its
  * evictability.  Note that if the page is not evictable, it goes
  * directly back onto it's zone's unevictable list, it does NOT use a
  * per cpu pagevec.
  */
-void lru_cache_add_active_or_unevictable(struct page *page,
+void lru_cache_add_inactive_or_unevictable(struct page *page,
 					 struct vm_area_struct *vma)
 {
+	bool unevictable;
+
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
-	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
-		SetPageActive(page);
-	else if (!TestSetPageMlocked(page)) {
+	unevictable = (vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED;
+	if (unlikely(unevictable) && !TestSetPageMlocked(page)) {
 		/*
 		 * We use the irq-unsafe __mod_zone_page_stat because this
 		 * counter is not modified from interrupt context, and the pte
--- a/mm/swapfile.c~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/mm/swapfile.c
@@ -1915,7 +1915,7 @@ static int unuse_pte(struct vm_area_stru
 		page_add_anon_rmap(page, vma, addr, false);
 	} else { /* ksm created a completely new copy */
 		page_add_new_anon_rmap(page, vma, addr, false);
-		lru_cache_add_active_or_unevictable(page, vma);
+		lru_cache_add_inactive_or_unevictable(page, vma);
 	}
 	swap_free(entry);
 	/*
--- a/mm/userfaultfd.c~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/mm/userfaultfd.c
@@ -123,7 +123,7 @@ static int mcopy_atomic_pte(struct mm_st
 
 	inc_mm_counter(dst_mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
-	lru_cache_add_active_or_unevictable(page, dst_vma);
+	lru_cache_add_inactive_or_unevictable(page, dst_vma);
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
--- a/mm/vmscan.c~mm-vmscan-protect-the-workingset-on-anonymous-lru
+++ a/mm/vmscan.c
@@ -998,8 +998,6 @@ static enum page_references page_check_r
 		return PAGEREF_RECLAIM;
 
 	if (referenced_ptes) {
-		if (PageSwapBacked(page))
-			return PAGEREF_ACTIVATE;
 		/*
 		 * All mapped pages start out with page table
 		 * references from the instantiating fault, so we need
@@ -1022,7 +1020,7 @@ static enum page_references page_check_r
 		/*
 		 * Activate file-backed executable pages after first usage.
 		 */
-		if (vm_flags & VM_EXEC)
+		if ((vm_flags & VM_EXEC) && !PageSwapBacked(page))
 			return PAGEREF_ACTIVATE;
 
 		return PAGEREF_KEEP;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch


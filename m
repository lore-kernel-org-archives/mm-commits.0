From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-charge-swapin-pages-on-instantiation.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:20:30 -0700
Message-ID: <20200604172030.WEJg9r3eH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbgFDRUc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, aquini@redhat.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: charge swapin pages on instantiation
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-charge-swapin-pages-on-instantiation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: charge swapin pages on instantiation

Right now, users that are otherwise memory controlled can easily escape
their containment and allocate significant amounts of memory that they're
not being charged for.  That's because swap readahead pages are not being
charged until somebody actually faults them into their page table.  This
can be exploited with MADV_WILLNEED, which triggers arbitrary readahead
allocations without charging the pages.

There are additional problems with the delayed charging of swap pages:

1. To implement refault/workingset detection for anonymous pages, we
   need to have a target LRU available at swapin time, but the LRU is not
   determinable until the page has been charged.

2. To implement per-cgroup LRU locking, we need page->mem_cgroup to be
   stable when the page is isolated from the LRU; otherwise, the locks
   change under us.  But swapcache gets charged after it's already on the
   LRU, and even if we cannot isolate it ourselves (since charging is not
   exactly optional).

The previous patch ensured we always maintain cgroup ownership records for
swap pages.  This patch moves the swapcache charging point from the fault
handler to swapin time to fix all of the above problems.

v2: simplify swapin error checking (Joonsoo)

[hughd@google.com: fix livelock in __read_swap_cache_async()]
  Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2005212246080.8458@eggly.anvils
Link: http://lkml.kernel.org/r/20200508183105.225460-17-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |   15 +++++-
 mm/shmem.c      |   14 +++---
 mm/swap_state.c |   99 ++++++++++++++++++++++++++--------------------
 mm/swapfile.c   |    6 --
 4 files changed, 75 insertions(+), 59 deletions(-)

--- a/mm/memory.c~mm-memcontrol-charge-swapin-pages-on-instantiation
+++ a/mm/memory.c
@@ -3125,9 +3125,20 @@ vm_fault_t do_swap_page(struct vm_fault
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
 							vmf->address);
 			if (page) {
+				int err;
+
 				__SetPageLocked(page);
 				__SetPageSwapBacked(page);
 				set_page_private(page, entry.val);
+
+				/* Tell memcg to use swap ownership records */
+				SetPageSwapCache(page);
+				err = mem_cgroup_charge(page, vma->vm_mm,
+							GFP_KERNEL, false);
+				ClearPageSwapCache(page);
+				if (err)
+					goto out_page;
+
 				lru_cache_add_anon(page);
 				swap_readpage(page, true);
 			}
@@ -3189,10 +3200,6 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_page;
 	}
 
-	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, true)) {
-		ret = VM_FAULT_OOM;
-		goto out_page;
-	}
 	cgroup_throttle_swaprate(page, GFP_KERNEL);
 
 	/*
--- a/mm/shmem.c~mm-memcontrol-charge-swapin-pages-on-instantiation
+++ a/mm/shmem.c
@@ -623,13 +623,15 @@ static int shmem_add_to_page_cache(struc
 	page->mapping = mapping;
 	page->index = index;
 
-	error = mem_cgroup_charge(page, charge_mm, gfp, PageSwapCache(page));
-	if (error) {
-		if (!PageSwapCache(page) && PageTransHuge(page)) {
-			count_vm_event(THP_FILE_FALLBACK);
-			count_vm_event(THP_FILE_FALLBACK_CHARGE);
+	if (!PageSwapCache(page)) {
+		error = mem_cgroup_charge(page, charge_mm, gfp, false);
+		if (error) {
+			if (PageTransHuge(page)) {
+				count_vm_event(THP_FILE_FALLBACK);
+				count_vm_event(THP_FILE_FALLBACK_CHARGE);
+			}
+			goto error;
 		}
-		goto error;
 	}
 	cgroup_throttle_swaprate(page, gfp);
 
--- a/mm/swapfile.c~mm-memcontrol-charge-swapin-pages-on-instantiation
+++ a/mm/swapfile.c
@@ -1901,11 +1901,6 @@ static int unuse_pte(struct vm_area_stru
 	if (unlikely(!page))
 		return -ENOMEM;
 
-	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, true)) {
-		ret = -ENOMEM;
-		goto out_nolock;
-	}
-
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte_same_as_swp(*pte, swp_entry_to_pte(entry)))) {
 		ret = 0;
@@ -1931,7 +1926,6 @@ static int unuse_pte(struct vm_area_stru
 	activate_page(page);
 out:
 	pte_unmap_unlock(pte, ptl);
-out_nolock:
 	if (page != swapcache) {
 		unlock_page(page);
 		put_page(page);
--- a/mm/swap_state.c~mm-memcontrol-charge-swapin-pages-on-instantiation
+++ a/mm/swap_state.c
@@ -360,12 +360,13 @@ struct page *__read_swap_cache_async(swp
 			struct vm_area_struct *vma, unsigned long addr,
 			bool *new_page_allocated)
 {
-	struct page *found_page = NULL, *new_page = NULL;
 	struct swap_info_struct *si;
-	int err;
+	struct page *page;
+
 	*new_page_allocated = false;
 
-	do {
+	for (;;) {
+		int err;
 		/*
 		 * First check the swap cache.  Since this is normally
 		 * called after lookup_swap_cache() failed, re-calling
@@ -373,12 +374,12 @@ struct page *__read_swap_cache_async(swp
 		 */
 		si = get_swap_device(entry);
 		if (!si)
-			break;
-		found_page = find_get_page(swap_address_space(entry),
-					   swp_offset(entry));
+			return NULL;
+		page = find_get_page(swap_address_space(entry),
+				     swp_offset(entry));
 		put_swap_device(si);
-		if (found_page)
-			break;
+		if (page)
+			return page;
 
 		/*
 		 * Just skip read ahead for unused swap slot.
@@ -389,54 +390,66 @@ struct page *__read_swap_cache_async(swp
 		 * else swap_off will be aborted if we return NULL.
 		 */
 		if (!__swp_swapcount(entry) && swap_slot_cache_enabled)
-			break;
+			return NULL;
 
 		/*
-		 * Get a new page to read into from swap.
+		 * Get a new page to read into from swap.  Allocate it now,
+		 * before marking swap_map SWAP_HAS_CACHE, when -EEXIST will
+		 * cause any racers to loop around until we add it to cache.
 		 */
-		if (!new_page) {
-			new_page = alloc_page_vma(gfp_mask, vma, addr);
-			if (!new_page)
-				break;		/* Out of memory */
-		}
+		page = alloc_page_vma(gfp_mask, vma, addr);
+		if (!page)
+			return NULL;
 
 		/*
 		 * Swap entry may have been freed since our caller observed it.
 		 */
 		err = swapcache_prepare(entry);
-		if (err == -EEXIST) {
-			/*
-			 * We might race against get_swap_page() and stumble
-			 * across a SWAP_HAS_CACHE swap_map entry whose page
-			 * has not been brought into the swapcache yet.
-			 */
-			cond_resched();
-			continue;
-		} else if (err)		/* swp entry is obsolete ? */
+		if (!err)
 			break;
 
-		/* May fail (-ENOMEM) if XArray node allocation failed. */
-		__SetPageLocked(new_page);
-		__SetPageSwapBacked(new_page);
-		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
-		if (likely(!err)) {
-			/* Initiate read into locked page */
-			SetPageWorkingset(new_page);
-			lru_cache_add_anon(new_page);
-			*new_page_allocated = true;
-			return new_page;
-		}
-		__ClearPageLocked(new_page);
+		put_page(page);
+		if (err != -EEXIST)
+			return NULL;
+
 		/*
-		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
-		 * clear SWAP_HAS_CACHE flag.
+		 * We might race against __delete_from_swap_cache(), and
+		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
+		 * has not yet been cleared.  Or race against another
+		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
+		 * in swap_map, but not yet added its page to swap cache.
 		 */
-		put_swap_page(new_page, entry);
-	} while (err != -ENOMEM);
+		cond_resched();
+	}
 
-	if (new_page)
-		put_page(new_page);
-	return found_page;
+	/*
+	 * The swap entry is ours to swap in. Prepare the new page.
+	 */
+
+	__SetPageLocked(page);
+	__SetPageSwapBacked(page);
+
+	/* May fail (-ENOMEM) if XArray node allocation failed. */
+	if (add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL)) {
+		put_swap_page(page, entry);
+		goto fail_unlock;
+	}
+
+	if (mem_cgroup_charge(page, NULL, gfp_mask, false)) {
+		delete_from_swap_cache(page);
+		goto fail_unlock;
+	}
+
+	/* Caller will initiate read into locked page */
+	SetPageWorkingset(page);
+	lru_cache_add_anon(page);
+	*new_page_allocated = true;
+	return page;
+
+fail_unlock:
+	unlock_page(page);
+	put_page(page);
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

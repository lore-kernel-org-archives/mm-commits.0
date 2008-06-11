From: akpm@linux-foundation.org
Subject: - vmscan-define-page_file_cache-function.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:00 -0700
Message-ID: <200806111946.m5BJk0ne014539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbYFKTqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: define page_file_cache() function
has been removed from the -mm tree.  Its filename was
     vmscan-define-page_file_cache-function.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: define page_file_cache() function
From: Rik van Riel <riel@redhat.com>

Define page_file_cache() function to answer the question: is page backed
by a file?

Originally part of Rik van Riel's split-lru patch.  Extracted to make
available for other, independent reclaim patches.

Moved inline function to linux/mm_inline.h where it will be needed by
subsequent "split LRU" and "noreclaim" patches.

Unfortunately this needs to use a page flag, since the PG_swapbacked state
needs to be preserved all the way to the point where the page is last
removed from the LRU.  Trying to derive the status from other info in the
page resulted in wrong VM statistics in earlier split VM patchsets.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h  |   24 ++++++++++++++++++++++++
 include/linux/page-flags.h |    2 ++
 mm/memory.c                |    3 +++
 mm/migrate.c               |    2 ++
 mm/page_alloc.c            |    4 ++++
 mm/shmem.c                 |    1 +
 mm/swap_state.c            |    3 +++
 7 files changed, 39 insertions(+)

diff -puN include/linux/mm_inline.h~vmscan-define-page_file_cache-function include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~vmscan-define-page_file_cache-function
+++ a/include/linux/mm_inline.h
@@ -1,3 +1,26 @@
+#ifndef LINUX_MM_INLINE_H
+#define LINUX_MM_INLINE_H
+
+/**
+ * page_file_cache - should the page be on a file LRU or anon LRU?
+ * @page: the page to test
+ *
+ * Returns !0 if @page is page cache page backed by a regular filesystem,
+ * or 0 if @page is anonymous, tmpfs or otherwise ram or swap backed.
+ *
+ * We would like to get this info without a page flag, but the state
+ * needs to survive until the page is last deleted from the LRU, which
+ * could be as far down as __page_cache_release.
+ */
+static inline int page_file_cache(struct page *page)
+{
+	if (PageSwapBacked(page))
+		return 0;
+
+	/* The page is page cache backed by a normal filesystem. */
+	return 2;
+}
+
 static inline void
 add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
 {
@@ -49,3 +72,4 @@ del_page_from_lru(struct zone *zone, str
 	__dec_zone_state(zone, NR_INACTIVE + l);
 }
 
+#endif
diff -puN include/linux/page-flags.h~vmscan-define-page_file_cache-function include/linux/page-flags.h
--- a/include/linux/page-flags.h~vmscan-define-page_file_cache-function
+++ a/include/linux/page-flags.h
@@ -93,6 +93,7 @@ enum pageflags {
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_buddy,		/* Page is free, on buddy lists */
+	PG_swapbacked,		/* Page is backed by RAM/swap */
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 	PG_uncached,		/* Page has been mapped as uncached */
 #endif
@@ -176,6 +177,7 @@ PAGEFLAG(SavePinned, savepinned);			/* X
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
+PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
 __PAGEFLAG(SlobPage, slob_page)
 __PAGEFLAG(SlobFree, slob_free)
diff -puN mm/memory.c~vmscan-define-page_file_cache-function mm/memory.c
--- a/mm/memory.c~vmscan-define-page_file_cache-function
+++ a/mm/memory.c
@@ -1804,6 +1804,7 @@ gotten:
 		ptep_clear_flush(vma, address, page_table);
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
+		SetPageSwapBacked(new_page);
 		lru_cache_add_active(new_page);
 		page_add_new_anon_rmap(new_page, vma, address);
 
@@ -2272,6 +2273,7 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 	inc_mm_counter(mm, anon_rss);
+	SetPageSwapBacked(page);
 	lru_cache_add_active(page);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
@@ -2413,6 +2415,7 @@ static int __do_fault(struct mm_struct *
 		set_pte_at(mm, address, page_table, entry);
 		if (anon) {
                         inc_mm_counter(mm, anon_rss);
+			SetPageSwapBacked(page);
                         lru_cache_add_active(page);
                         page_add_new_anon_rmap(page, vma, address);
 		} else {
diff -puN mm/migrate.c~vmscan-define-page_file_cache-function mm/migrate.c
--- a/mm/migrate.c~vmscan-define-page_file_cache-function
+++ a/mm/migrate.c
@@ -572,6 +572,8 @@ static int move_to_new_page(struct page 
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
+	if (PageSwapBacked(page))
+		SetPageSwapBacked(newpage);
 
 	mapping = page_mapping(page);
 	if (!mapping)
diff -puN mm/page_alloc.c~vmscan-define-page_file_cache-function mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-define-page_file_cache-function
+++ a/mm/page_alloc.c
@@ -246,6 +246,7 @@ static void bad_page(struct page *page)
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
+			1 << PG_swapbacked |
 			1 << PG_buddy );
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
@@ -477,6 +478,8 @@ static inline int free_pages_check(struc
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageSwapBacked(page))
+		__ClearPageSwapBacked(page);
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
@@ -627,6 +630,7 @@ static int prep_new_page(struct page *pa
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+			1 << PG_swapbacked |
 			1 << PG_buddy ))))
 		bad_page(page);
 
diff -puN mm/shmem.c~vmscan-define-page_file_cache-function mm/shmem.c
--- a/mm/shmem.c~vmscan-define-page_file_cache-function
+++ a/mm/shmem.c
@@ -1387,6 +1387,7 @@ repeat:
 				goto failed;
 			}
 
+			SetPageSwapBacked(filepage);
 			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
diff -puN mm/swap_state.c~vmscan-define-page_file_cache-function mm/swap_state.c
--- a/mm/swap_state.c~vmscan-define-page_file_cache-function
+++ a/mm/swap_state.c
@@ -74,6 +74,7 @@ int add_to_swap_cache(struct page *page,
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
 	BUG_ON(PagePrivate(page));
+	BUG_ON(!PageSwapBacked(page));
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 		page_cache_get(page);
@@ -303,6 +304,7 @@ struct page *read_swap_cache_async(swp_e
 		 * May fail (-ENOMEM) if radix-tree node allocation failed.
 		 */
 		SetPageLocked(new_page);
+		SetPageSwapBacked(new_page);
 		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
 		if (!err) {
 			/*
@@ -312,6 +314,7 @@ struct page *read_swap_cache_async(swp_e
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}
+		ClearPageSwapBacked(new_page);
 		ClearPageLocked(new_page);
 		swap_free(entry);
 	} while (err != -ENOMEM);
_

Patches currently in -mm which might be from riel@redhat.com are

ntp-let-update_persistent_clock-sleep.patch
access_process_vm-device-memory-infrastructure.patch
access_process_vm-device-memory-infrastructure-fix.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
vmscan-define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-split-lru-lists-into-anon-file-sets-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-add-some-sanity-checks-to-get_scan_ratio.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
vmscan-more-aggressively-use-lumpy-reclaim.patch
vmscan-pageflag-helpers-for-configed-out-flags.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-cull-non-reclaimable-pages-in-fault-path.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl-fix.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch
make-mm-rmapc-anon_vma_cachep-static.patch


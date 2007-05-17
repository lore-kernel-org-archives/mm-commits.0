From: akpm@linux-foundation.org
Subject: + add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch added to -mm tree
Date: Thu, 17 May 2007 12:43:29 -0700
Message-ID: <200705171943.l4HJhTMV031342@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399AbXEQTqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com


The patch titled
     Rename GFP_HIGH_MOVABLE to GFP_HIGHUSER_MOVABLE
has been added to the -mm tree.  Its filename is
     add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Rename GFP_HIGH_MOVABLE to GFP_HIGHUSER_MOVABLE
From: Mel Gorman <mel@csn.ul.ie>

__GFP_HIGH are used to flag allocations that can access emergency pools. 
GFP_HIGH_MOVABLE has little to do with __GFP_HIGH and the name is misleading. 
This patch renames GFP_HIGH_MOVABLE to GFP_HIGHUSER_MOVABLE so that it is
clearer.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c          |    6 +++---
 include/linux/gfp.h |    2 +-
 mm/memory.c         |    5 +++--
 mm/mempolicy.c      |    5 +++--
 mm/migrate.c        |    3 ++-
 mm/swap_state.c     |    3 ++-
 6 files changed, 14 insertions(+), 10 deletions(-)

diff -puN fs/inode.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable fs/inode.c
--- a/fs/inode.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable
+++ a/fs/inode.c
@@ -145,7 +145,7 @@ static struct inode *alloc_inode(struct 
 		mapping->a_ops = &empty_aops;
  		mapping->host = inode;
 		mapping->flags = 0;
-		mapping_set_gfp_mask(mapping, GFP_HIGH_MOVABLE);
+		mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 		mapping->assoc_mapping = NULL;
 		mapping->backing_dev_info = &default_backing_dev_info;
 
@@ -520,8 +520,8 @@ repeat:
  *	@sb: superblock
  *
  *	Allocates a new inode for given superblock. The default gfp_mask
- *	for allocations related to inode->i_mapping is GFP_HIGH_MOVABLE. If
- *	HIGHMEM pages are unsuitable or it is known that pages allocated
+ *	for allocations related to inode->i_mapping is GFP_HIGHUSER_MOVABLE.
+ *	If HIGHMEM pages are unsuitable or it is known that pages allocated
  *	for the page cache are not reclaimable or migratable,
  *	mapping_set_gfp_mask() must be called with suitable flags on the
  *	newly created inode's mapping
diff -puN include/linux/gfp.h~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable include/linux/gfp.h
--- a/include/linux/gfp.h~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable
+++ a/include/linux/gfp.h
@@ -70,7 +70,7 @@ struct vm_area_struct;
 #define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_HIGHUSER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | \
 			 __GFP_HIGHMEM)
-#define GFP_HIGH_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
+#define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 				 __GFP_HARDWALL | __GFP_HIGHMEM | \
 				 __GFP_MOVABLE)
 
diff -puN mm/hugetlb.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable mm/hugetlb.c
diff -puN mm/memory.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable mm/memory.c
--- a/mm/memory.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable
+++ a/mm/memory.c
@@ -1746,7 +1746,7 @@ gotten:
 		if (!new_page)
 			goto oom;
 	} else {
-		new_page = alloc_page_vma(GFP_HIGH_MOVABLE, vma, address);
+		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 		if (!new_page)
 			goto oom;
 		cow_user_page(new_page, old_page, address, vma);
@@ -2392,7 +2392,8 @@ static int __do_fault(struct mm_struct *
 				fdata.type = VM_FAULT_OOM;
 				goto out;
 			}
-			page = alloc_page_vma(GFP_HIGH_MOVABLE, vma, address);
+			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
+								vma, address);
 			if (!page) {
 				fdata.type = VM_FAULT_OOM;
 				goto out;
diff -puN mm/mempolicy.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable mm/mempolicy.c
--- a/mm/mempolicy.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable
+++ a/mm/mempolicy.c
@@ -594,7 +594,7 @@ static void migrate_page_add(struct page
 
 static struct page *new_node_page(struct page *page, unsigned long node, int **x)
 {
-	return alloc_pages_node(node, GFP_HIGH_MOVABLE, 0);
+	return alloc_pages_node(node, GFP_HIGHUSER_MOVABLE, 0);
 }
 
 /*
@@ -710,7 +710,8 @@ static struct page *new_vma_page(struct 
 {
 	struct vm_area_struct *vma = (struct vm_area_struct *)private;
 
-	return alloc_page_vma(GFP_HIGH_MOVABLE, vma, page_address_in_vma(page, vma));
+	return alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
+					page_address_in_vma(page, vma));
 }
 #else
 
diff -puN mm/migrate.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable mm/migrate.c
--- a/mm/migrate.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable
+++ a/mm/migrate.c
@@ -761,7 +761,8 @@ static struct page *new_page_node(struct
 
 	*result = &pm->status;
 
-	return alloc_pages_node(pm->node, GFP_HIGH_MOVABLE | GFP_THISNODE, 0);
+	return alloc_pages_node(pm->node,
+				GFP_HIGHUSER_MOVABLE | GFP_THISNODE, 0);
 }
 
 /*
diff -puN mm/page_alloc.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable mm/page_alloc.c
diff -puN /dev/null /dev/null
diff -puN mm/swap_state.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable mm/swap_state.c
--- a/mm/swap_state.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable
+++ a/mm/swap_state.c
@@ -334,7 +334,8 @@ struct page *read_swap_cache_async(swp_e
 		 * Get a new page to read into from swap.
 		 */
 		if (!new_page) {
-			new_page = alloc_page_vma(GFP_HIGH_MOVABLE, vma, addr);
+			new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
+								vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
 		}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix-alloc_zeroed_user_highpage-on-m68knommu.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
dont-group-high-order-atomic-allocations-remove-unused-parameter-to-allocflags_to_migratetype.patch
mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch

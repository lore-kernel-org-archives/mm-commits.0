From: akpm@linux-foundation.org
Subject: + update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch added to -mm tree
Date: Tue, 29 May 2007 14:57:01 -0700
Message-ID: <200705292157.l4TLv102012608@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbXE2V5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org


The patch titled
     Update page->order at an appropriate time when tracking PAGE_OWNER
has been added to the -mm tree.  Its filename is
     update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update page->order at an appropriate time when tracking PAGE_OWNER
From: mel@skynet.ie (Mel Gorman)

PAGE_OWNER tracks free pages by setting page->order to -1.  However, it is
set during __free_pages() which is not the only free path as
__pagevec_free() and free_compound_page() do not go through __free_pages().
 This leads to a situation where free pages are visible in /proc/page_owner
which is confusing and might be interpreted as a memory leak.

This patch sets page->owner when PageBuddy is set.  It also prints a
warning to the kernel log if a free page is found that does not appear free
to PAGE_OWNER.  This should be considered a fix to
page-owner-tracking-leak-detector.patch.

This only applies to -mm as PAGE_OWNER is not in mainline.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    8 ++++++++
 mm/page_alloc.c     |    6 +++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/proc/proc_misc.c~update-page-order-at-an-appropriate-time-when-tracking-page_owner fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~update-page-order-at-an-appropriate-time-when-tracking-page_owner
+++ a/fs/proc/proc_misc.c
@@ -769,8 +769,16 @@ read_page_owner(struct file *file, char 
 		if (!pfn_valid(pfn))
 			continue;
 		page = pfn_to_page(pfn);
+
+		/* Catch situations where free pages have a bad ->order  */
+		if (page->order >= 0 && PageBuddy(page))
+			printk(KERN_WARNING
+				"PageOwner info inaccurate for PFN %lu\n",
+				pfn);
+
 		if (page->order >= 0)
 			break;
+
 		next_idx++;
 	}
 
diff -puN mm/page_alloc.c~update-page-order-at-an-appropriate-time-when-tracking-page_owner mm/page_alloc.c
--- a/mm/page_alloc.c~update-page-order-at-an-appropriate-time-when-tracking-page_owner
+++ a/mm/page_alloc.c
@@ -308,6 +308,9 @@ static inline void set_page_order(struct
 {
 	set_page_private(page, order);
 	__SetPageBuddy(page);
+#ifdef CONFIG_PAGE_OWNER
+		page->order = -1;
+#endif
 }
 
 static inline void rmv_page_order(struct page *page)
@@ -1726,9 +1729,6 @@ fastcall void __free_pages(struct page *
 			free_hot_page(page);
 		else
 			__free_pages_ok(page, order);
-#ifdef CONFIG_PAGE_OWNER
-		page->order = -1;
-#endif
 	}
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch
add-debugging-aid-for-memory-initialisation-problems.patch

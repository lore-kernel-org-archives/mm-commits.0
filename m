From: akpm@linux-foundation.org
Subject: + vmscan-move-isolate_lru_page-to-vmscanc.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:18:28 -0700
Message-ID: <200806090618.m596ISa7006592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769AbYFIGTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, Lee.Schermerhorn@hp.com, riel@redhat.com


The patch titled
     vmscan: move isolate_lru_page() to vmscan.c
has been added to the -mm tree.  Its filename is
     vmscan-move-isolate_lru_page-to-vmscanc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: move isolate_lru_page() to vmscan.c
From: Nick Piggin <npiggin@suse.de>


isolate_lru_page logically belongs to be in vmscan.c than migrate.c.

It is tough, because we don't need that function without memory migration
so there is a valid argument to have it in migrate.c. However a subsequent
patch needs to make use of it in the core mm, so we can happily move it
to vmscan.c.

Also, make the function a little more generic by not requiring that it
adds an isolated page to a given list. Callers can do that.

	Note that we now have '__isolate_lru_page()', that does
	something quite different, visible outside of vmscan.c
	for use with memory controller.  Methinks we need to
	rationalize these names/purposes.	--lts

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

---

V1 -> V2 [lts]:
+  fix botched merge -- add back "get_page_unless_zero()"

  From: Nick Piggin <npiggin@suse.de>
  To: Linux Memory Management <linux-mm@kvack.org>
  Subject: [patch 1/4] mm: move and rework isolate_lru_page
  Date:	Mon, 12 Mar 2007 07:38:44 +0100 (CET)

Index: linux-2.6.26-rc2-mm1/include/linux/migrate.h
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    3 --
 mm/internal.h           |    2 +
 mm/mempolicy.c          |    9 +++++--
 mm/migrate.c            |   34 ++--------------------------
 mm/vmscan.c             |   45 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 57 insertions(+), 36 deletions(-)

diff -puN include/linux/migrate.h~move-isolate_lru_page-to-vmscanc include/linux/migrate.h
--- a/include/linux/migrate.h~move-isolate_lru_page-to-vmscanc
+++ a/include/linux/migrate.h
@@ -25,7 +25,6 @@ static inline int vma_migratable(struct 
 	return 1;
 }
 
-extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
 extern int putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -42,8 +41,6 @@ extern int migrate_vmas(struct mm_struct
 static inline int vma_migratable(struct vm_area_struct *vma)
 					{ return 0; }
 
-static inline int isolate_lru_page(struct page *p, struct list_head *list)
-					{ return -ENOSYS; }
 static inline int putback_lru_pages(struct list_head *l) { return 0; }
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private) { return -ENOSYS; }
diff -puN mm/internal.h~move-isolate_lru_page-to-vmscanc mm/internal.h
--- a/mm/internal.h~move-isolate_lru_page-to-vmscanc
+++ a/mm/internal.h
@@ -37,6 +37,8 @@ static inline void __put_page(struct pag
 	atomic_dec(&page->_count);
 }
 
+extern int isolate_lru_page(struct page *page);
+
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 
 /*
diff -puN mm/mempolicy.c~move-isolate_lru_page-to-vmscanc mm/mempolicy.c
--- a/mm/mempolicy.c~move-isolate_lru_page-to-vmscanc
+++ a/mm/mempolicy.c
@@ -93,6 +93,8 @@
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
 
+#include "internal.h"
+
 /* Internal flags */
 #define MPOL_MF_DISCONTIG_OK (MPOL_MF_INTERNAL << 0)	/* Skip checks for continuous vmas */
 #define MPOL_MF_INVERT (MPOL_MF_INTERNAL << 1)		/* Invert check for nodemask */
@@ -758,8 +760,11 @@ static void migrate_page_add(struct page
 	/*
 	 * Avoid migrating a page that is shared with others.
 	 */
-	if ((flags & MPOL_MF_MOVE_ALL) || page_mapcount(page) == 1)
-		isolate_lru_page(page, pagelist);
+	if ((flags & MPOL_MF_MOVE_ALL) || page_mapcount(page) == 1) {
+		if (!isolate_lru_page(page)) {
+			list_add_tail(&page->lru, pagelist);
+		}
+	}
 }
 
 static struct page *new_node_page(struct page *page, unsigned long node, int **x)
diff -puN mm/migrate.c~move-isolate_lru_page-to-vmscanc mm/migrate.c
--- a/mm/migrate.c~move-isolate_lru_page-to-vmscanc
+++ a/mm/migrate.c
@@ -37,36 +37,6 @@
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
 
 /*
- * Isolate one page from the LRU lists. If successful put it onto
- * the indicated list with elevated page count.
- *
- * Result:
- *  -EBUSY: page not on LRU list
- *  0: page removed from LRU list and added to the specified list.
- */
-int isolate_lru_page(struct page *page, struct list_head *pagelist)
-{
-	int ret = -EBUSY;
-
-	if (PageLRU(page)) {
-		struct zone *zone = page_zone(page);
-
-		spin_lock_irq(&zone->lru_lock);
-		if (PageLRU(page) && get_page_unless_zero(page)) {
-			ret = 0;
-			ClearPageLRU(page);
-			if (PageActive(page))
-				del_page_from_active_list(zone, page);
-			else
-				del_page_from_inactive_list(zone, page);
-			list_add_tail(&page->lru, pagelist);
-		}
-		spin_unlock_irq(&zone->lru_lock);
-	}
-	return ret;
-}
-
-/*
  * migrate_prep() needs to be called before we start compiling a list of pages
  * to be migrated using isolate_lru_page().
  */
@@ -903,7 +873,9 @@ static int do_move_pages(struct mm_struc
 				!migrate_all)
 			goto put_and_set;
 
-		err = isolate_lru_page(page, &pagelist);
+		err = isolate_lru_page(page);
+		if (!err)
+			list_add_tail(&page->lru, &pagelist);
 put_and_set:
 		/*
 		 * Either remove the duplicate refcount from
diff -puN mm/vmscan.c~move-isolate_lru_page-to-vmscanc mm/vmscan.c
--- a/mm/vmscan.c~move-isolate_lru_page-to-vmscanc
+++ a/mm/vmscan.c
@@ -834,6 +834,51 @@ static unsigned long clear_active_flags(
 	return nr_active;
 }
 
+/**
+ * isolate_lru_page - tries to isolate a page from its LRU list
+ * @page: page to isolate from its LRU list
+ *
+ * Isolates a @page from an LRU list, clears PageLRU and adjusts the
+ * vmstat statistic corresponding to whatever LRU list the page was on.
+ *
+ * Returns 0 if the page was removed from an LRU list.
+ * Returns -EBUSY if the page was not on an LRU list.
+ *
+ * The returned page will have PageLRU() cleared.  If it was found on
+ * the active list, it will have PageActive set.  That flag may need
+ * to be cleared by the caller before letting the page go.
+ *
+ * The vmstat statistic corresponding to the list on which the page was
+ * found will be decremented.
+ *
+ * Restrictions:
+ * (1) Must be called with an elevated refcount on the page. This is a
+ *     fundamentnal difference from isolate_lru_pages (which is called
+ *     without a stable reference).
+ * (2) the lru_lock must not be held.
+ * (3) interrupts must be enabled.
+ */
+int isolate_lru_page(struct page *page)
+{
+	int ret = -EBUSY;
+
+	if (PageLRU(page)) {
+		struct zone *zone = page_zone(page);
+
+		spin_lock_irq(&zone->lru_lock);
+		if (PageLRU(page) && get_page_unless_zero(page)) {
+			ret = 0;
+			ClearPageLRU(page);
+			if (PageActive(page))
+				del_page_from_active_list(zone, page);
+			else
+				del_page_from_inactive_list(zone, page);
+		}
+		spin_unlock_irq(&zone->lru_lock);
+	}
+	return ret;
+}
+
 /*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
powerpc-lockless-get_user_pages_fast-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch


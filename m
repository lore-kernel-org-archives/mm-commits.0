From: akpm@linux-foundation.org
Subject: - vmscan-move-isolate_lru_page-to-vmscanc.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:28 -0700
Message-ID: <200810202032.m9KKWSWQ010406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbYJTUdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:33:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, Lee.Schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: move isolate_lru_page() to vmscan.c
has been removed from the -mm tree.  Its filename was
     vmscan-move-isolate_lru_page-to-vmscanc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: move isolate_lru_page() to vmscan.c
From: Nick Piggin <npiggin@suse.de>

On large memory systems, the VM can spend way too much time scanning
through pages that it cannot (or should not) evict from memory.  Not only
does it use up CPU time, but it also provokes lock contention and can
leave large systems under memory presure in a catatonic state.

This patch series improves VM scalability by:

1) putting filesystem backed, swap backed and unevictable pages
   onto their own LRUs, so the system only scans the pages that it
   can/should evict from memory

2) switching to two handed clock replacement for the anonymous LRUs,
   so the number of pages that need to be scanned when the system
   starts swapping is bound to a reasonable number

3) keeping unevictable pages off the LRU completely, so the
   VM does not waste CPU time scanning them. ramfs, ramdisk,
   SHM_LOCKED shared memory segments and mlock()ed VMA pages
   are keept on the unevictable list.


This patch:

isolate_lru_page logically belongs to be in vmscan.c than migrate.c.

It is tough, because we don't need that function without memory migration
so there is a valid argument to have it in migrate.c.  However a
subsequent patch needs to make use of it in the core mm, so we can happily
move it to vmscan.c.

Also, make the function a little more generic by not requiring that it
adds an isolated page to a given list.  Callers can do that.

	Note that we now have '__isolate_lru_page()', that does
	something quite different, visible outside of vmscan.c
	for use with memory controller.  Methinks we need to
	rationalize these names/purposes.	--lts

[akpm@linux-foundation.org: fix mm/memory_hotplug.c build]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    3 --
 mm/internal.h           |    2 +
 mm/memory_hotplug.c     |    3 +-
 mm/mempolicy.c          |    9 +++++--
 mm/migrate.c            |   34 ++--------------------------
 mm/vmscan.c             |   45 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 59 insertions(+), 37 deletions(-)

diff -puN include/linux/migrate.h~vmscan-move-isolate_lru_page-to-vmscanc include/linux/migrate.h
--- a/include/linux/migrate.h~vmscan-move-isolate_lru_page-to-vmscanc
+++ a/include/linux/migrate.h
@@ -7,7 +7,6 @@
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
 #ifdef CONFIG_MIGRATION
-extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
 extern int putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -21,8 +20,6 @@ extern int migrate_vmas(struct mm_struct
 		const nodemask_t *from, const nodemask_t *to,
 		unsigned long flags);
 #else
-static inline int isolate_lru_page(struct page *p, struct list_head *list)
-					{ return -ENOSYS; }
 static inline int putback_lru_pages(struct list_head *l) { return 0; }
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private) { return -ENOSYS; }
diff -puN mm/internal.h~vmscan-move-isolate_lru_page-to-vmscanc mm/internal.h
--- a/mm/internal.h~vmscan-move-isolate_lru_page-to-vmscanc
+++ a/mm/internal.h
@@ -39,6 +39,8 @@ static inline void __put_page(struct pag
 	atomic_dec(&page->_count);
 }
 
+extern int isolate_lru_page(struct page *page);
+
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 
 /*
diff -puN mm/memory_hotplug.c~vmscan-move-isolate_lru_page-to-vmscanc mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~vmscan-move-isolate_lru_page-to-vmscanc
+++ a/mm/memory_hotplug.c
@@ -658,8 +658,9 @@ do_migrate_range(unsigned long start_pfn
 		 * We can skip free pages. And we can only deal with pages on
 		 * LRU.
 		 */
-		ret = isolate_lru_page(page, &source);
+		ret = isolate_lru_page(page);
 		if (!ret) { /* Success */
+			list_add_tail(&page->lru, &source);
 			move_pages--;
 		} else {
 			/* Becasue we don't have big zone->lock. we should
diff -puN mm/mempolicy.c~vmscan-move-isolate_lru_page-to-vmscanc mm/mempolicy.c
--- a/mm/mempolicy.c~vmscan-move-isolate_lru_page-to-vmscanc
+++ a/mm/mempolicy.c
@@ -93,6 +93,8 @@
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
 
+#include "internal.h"
+
 /* Internal flags */
 #define MPOL_MF_DISCONTIG_OK (MPOL_MF_INTERNAL << 0)	/* Skip checks for continuous vmas */
 #define MPOL_MF_INVERT (MPOL_MF_INTERNAL << 1)		/* Invert check for nodemask */
@@ -762,8 +764,11 @@ static void migrate_page_add(struct page
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
diff -puN mm/migrate.c~vmscan-move-isolate_lru_page-to-vmscanc mm/migrate.c
--- a/mm/migrate.c~vmscan-move-isolate_lru_page-to-vmscanc
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
@@ -914,7 +884,9 @@ static int do_move_pages(struct mm_struc
 				!migrate_all)
 			goto put_and_set;
 
-		err = isolate_lru_page(page, &pagelist);
+		err = isolate_lru_page(page);
+		if (!err)
+			list_add_tail(&page->lru, &pagelist);
 put_and_set:
 		/*
 		 * Either remove the duplicate refcount from
diff -puN mm/vmscan.c~vmscan-move-isolate_lru_page-to-vmscanc mm/vmscan.c
--- a/mm/vmscan.c~vmscan-move-isolate_lru_page-to-vmscanc
+++ a/mm/vmscan.c
@@ -844,6 +844,51 @@ static unsigned long clear_active_flags(
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
reiser4.patch
likeliness-accounting-change-and-cleanup.patch


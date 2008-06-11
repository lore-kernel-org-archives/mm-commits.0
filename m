From: akpm@linux-foundation.org
Subject: - vmscan-mlocked-pages-statistics.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:40 -0700
Message-ID: <200806111946.m5BJkerU014607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbYFKTrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: mlocked pages statistics
has been removed from the -mm tree.  Its filename was
     vmscan-mlocked-pages-statistics.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: mlocked pages statistics
From: Nick Piggin <npiggin@suse.de>

Add NR_MLOCK zone page state, which provides a (conservative) count of
mlocked pages (actually, the number of mlocked pages moved off the LRU).

Reworked by lts to fit in with the modified mlock page support in the
Reclaim Scalability series.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |   24 +++++++++++++++---------
 fs/proc/proc_misc.c    |    6 ++++++
 include/linux/mmzone.h |    5 +++++
 mm/internal.h          |   14 +++++++++++---
 mm/mlock.c             |   22 ++++++++++++++++++----
 mm/vmstat.c            |    3 +++
 6 files changed, 58 insertions(+), 16 deletions(-)

diff -puN drivers/base/node.c~vmscan-mlocked-pages-statistics drivers/base/node.c
--- a/drivers/base/node.c~vmscan-mlocked-pages-statistics
+++ a/drivers/base/node.c
@@ -69,6 +69,9 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Inactive(file): %8lu kB\n"
 #ifdef CONFIG_NORECLAIM_LRU
 		       "Node %d Noreclaim:      %8lu kB\n"
+#ifdef CONFIG_NORECLAIM_MLOCK
+		       "Node %d Mlocked:        %8lu kB\n"
+#endif
 #endif
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
@@ -91,16 +94,19 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(i.totalram),
 		       nid, K(i.freeram),
 		       nid, K(i.totalram - i.freeram),
-		       nid, node_page_state(nid, NR_ACTIVE_ANON) +
-				node_page_state(nid, NR_ACTIVE_FILE),
-		       nid, node_page_state(nid, NR_INACTIVE_ANON) +
-				node_page_state(nid, NR_INACTIVE_FILE),
-		       nid, node_page_state(nid, NR_ACTIVE_ANON),
-		       nid, node_page_state(nid, NR_INACTIVE_ANON),
-		       nid, node_page_state(nid, NR_ACTIVE_FILE),
-		       nid, node_page_state(nid, NR_INACTIVE_FILE),
+		       nid, K(node_page_state(nid, NR_ACTIVE_ANON) +
+				node_page_state(nid, NR_ACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_INACTIVE_ANON) +
+				node_page_state(nid, NR_INACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_ACTIVE_ANON)),
+		       nid, K(node_page_state(nid, NR_INACTIVE_ANON)),
+		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
 #ifdef CONFIG_NORECLAIM_LRU
-		       nid, node_page_state(nid, NR_NORECLAIM),
+		       nid, K(node_page_state(nid, NR_NORECLAIM)),
+#ifdef CONFIG_NORECLAIM_MLOCK
+		       nid, K(node_page_state(nid, NR_MLOCK)),
+#endif
 #endif
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
diff -puN fs/proc/proc_misc.c~vmscan-mlocked-pages-statistics fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~vmscan-mlocked-pages-statistics
+++ a/fs/proc/proc_misc.c
@@ -181,6 +181,9 @@ static int meminfo_read_proc(char *page,
 		"Inactive(file): %8lu kB\n"
 #ifdef CONFIG_NORECLAIM_LRU
 		"Noreclaim:      %8lu kB\n"
+#ifdef CONFIG_NORECLAIM_MLOCK
+		"Mlocked:        %8lu kB\n"
+#endif
 #endif
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
@@ -219,6 +222,9 @@ static int meminfo_read_proc(char *page,
 		K(inactive_file),
 #ifdef CONFIG_NORECLAIM_LRU
 		K(global_page_state(NR_NORECLAIM)),
+#ifdef CONFIG_NORECLAIM_MLOCK
+		K(global_page_state(NR_MLOCK)),
+#endif
 #endif
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
diff -puN include/linux/mmzone.h~vmscan-mlocked-pages-statistics include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-mlocked-pages-statistics
+++ a/include/linux/mmzone.h
@@ -90,6 +90,11 @@ enum zone_stat_item {
 #else
 	NR_NORECLAIM = NR_ACTIVE_FILE, /* avoid compiler errors in dead code */
 #endif
+#ifdef CONFIG_NORECLAIM_MLOCK
+	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
+#else
+	NR_MLOCK = NR_ACTIVE_FILE,	/* avoid compier errors... */
+#endif
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
diff -puN mm/internal.h~vmscan-mlocked-pages-statistics mm/internal.h
--- a/mm/internal.h~vmscan-mlocked-pages-statistics
+++ a/mm/internal.h
@@ -112,7 +112,8 @@ static inline int is_mlocked_vma(struct 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
 		return 0;
 
-	SetPageMlocked(page);
+	if (!TestSetPageMlocked(page))
+		inc_zone_page_state(page, NR_MLOCK);
 	return 1;
 }
 
@@ -139,12 +140,19 @@ static inline void clear_page_mlock(stru
 
 /*
  * mlock_migrate_page - called only from migrate_page_copy() to
- * migrate the Mlocked page flag
+ * migrate the Mlocked page flag; update statistics.
  */
 static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 {
-	if (TestClearPageMlocked(page))
+	if (TestClearPageMlocked(page)) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		__dec_zone_page_state(page, NR_MLOCK);
 		SetPageMlocked(newpage);
+		__inc_zone_page_state(newpage, NR_MLOCK);
+		local_irq_restore(flags);
+	}
 }
 
 
diff -puN mm/mlock.c~vmscan-mlocked-pages-statistics mm/mlock.c
--- a/mm/mlock.c~vmscan-mlocked-pages-statistics
+++ a/mm/mlock.c
@@ -56,6 +56,7 @@ void __clear_page_mlock(struct page *pag
 {
 	VM_BUG_ON(!PageLocked(page));	/* for LRU islolate/putback */
 
+	dec_zone_page_state(page, NR_MLOCK);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
 	} else {
@@ -76,8 +77,11 @@ void mlock_vma_page(struct page *page)
 {
 	BUG_ON(!PageLocked(page));
 
-	if (!TestSetPageMlocked(page) && !isolate_lru_page(page))
+	if (!TestSetPageMlocked(page)) {
+		inc_zone_page_state(page, NR_MLOCK);
+		if (!isolate_lru_page(page))
 			putback_lru_page(page);
+	}
 }
 
 /*
@@ -102,9 +106,19 @@ static void munlock_vma_page(struct page
 {
 	BUG_ON(!PageLocked(page));
 
-	if (TestClearPageMlocked(page) && !isolate_lru_page(page)) {
-		try_to_unlock(page);
-		putback_lru_page(page);
+	if (TestClearPageMlocked(page)) {
+		dec_zone_page_state(page, NR_MLOCK);
+		if (!isolate_lru_page(page)) {
+			try_to_unlock(page);	/* maybe relock the page */
+			putback_lru_page(page);
+		}
+		/*
+		 * Else we lost the race.  let try_to_unmap() deal with it.
+		 * At least we get the page state and mlock stats right.
+		 * However, page is still on the noreclaim list.  We'll fix
+		 * that up when the page is eventually freed or we scan the
+		 * noreclaim list.
+		 */
 	}
 }
 
diff -puN mm/vmstat.c~vmscan-mlocked-pages-statistics mm/vmstat.c
--- a/mm/vmstat.c~vmscan-mlocked-pages-statistics
+++ a/mm/vmstat.c
@@ -609,6 +609,9 @@ static const char * const vmstat_text[] 
 #ifdef CONFIG_NORECLAIM_LRU
 	"nr_noreclaim",
 #endif
+#ifdef CONFIG_NORECLAIM_MLOCK
+	"nr_mlock",
+#endif
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
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
hugetlb-override-default-huge-page-size-ia64-build.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch


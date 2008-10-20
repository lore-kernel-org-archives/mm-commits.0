From: akpm@linux-foundation.org
Subject: - vmstat-mlocked-pages-statistics.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:13 -0700
Message-ID: <200810202033.m9KKXDWS010575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537AbYJTUd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmstat: mlocked pages statistics
has been removed from the -mm tree.  Its filename was
     vmstat-mlocked-pages-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstat: mlocked pages statistics
From: Nick Piggin <npiggin@suse.de>

Add NR_MLOCK zone page state, which provides a (conservative) count of
mlocked pages (actually, the number of mlocked pages moved off the LRU).

Reworked by lts to fit in with the modified mlock page support in the
Reclaim Scalability series.

[kosaki.motohiro@jp.fujitsu.com: fix incorrect Mlocked field of /proc/meminfo]
[lee.schermerhorn@hp.com: mlocked-pages: add event counting with statistics]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    4 ++-
 fs/proc/proc_misc.c    |    2 +
 include/linux/mmzone.h |    2 +
 include/linux/vmstat.h |    4 +++
 mm/internal.h          |   16 ++++++++++++---
 mm/mlock.c             |   41 ++++++++++++++++++++++++++++++++++-----
 mm/vmstat.c            |    5 ++++
 7 files changed, 65 insertions(+), 9 deletions(-)

diff -puN drivers/base/node.c~vmstat-mlocked-pages-statistics drivers/base/node.c
--- a/drivers/base/node.c~vmstat-mlocked-pages-statistics
+++ a/drivers/base/node.c
@@ -71,7 +71,8 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
 #ifdef CONFIG_UNEVICTABLE_LRU
-		       "Node %d Noreclaim:      %8lu kB\n"
+		       "Node %d Unevictable:    %8lu kB\n"
+		       "Node %d Mlocked:        %8lu kB\n"
 #endif
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
@@ -104,6 +105,7 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
 #ifdef CONFIG_UNEVICTABLE_LRU
 		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
+		       nid, K(node_page_state(nid, NR_MLOCK)),
 #endif
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
diff -puN fs/proc/proc_misc.c~vmstat-mlocked-pages-statistics fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~vmstat-mlocked-pages-statistics
+++ a/fs/proc/proc_misc.c
@@ -176,6 +176,7 @@ static int meminfo_read_proc(char *page,
 		"Inactive(file): %8lu kB\n"
 #ifdef CONFIG_UNEVICTABLE_LRU
 		"Unevictable:    %8lu kB\n"
+		"Mlocked:        %8lu kB\n"
 #endif
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
@@ -217,6 +218,7 @@ static int meminfo_read_proc(char *page,
 		K(pages[LRU_INACTIVE_FILE]),
 #ifdef CONFIG_UNEVICTABLE_LRU
 		K(pages[LRU_UNEVICTABLE]),
+		K(global_page_state(NR_MLOCK)),
 #endif
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
diff -puN include/linux/mmzone.h~vmstat-mlocked-pages-statistics include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmstat-mlocked-pages-statistics
+++ a/include/linux/mmzone.h
@@ -88,8 +88,10 @@ enum zone_stat_item {
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
 #ifdef CONFIG_UNEVICTABLE_LRU
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
+	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 #else
 	NR_UNEVICTABLE = NR_ACTIVE_FILE, /* avoid compiler errors in dead code */
+	NR_MLOCK = NR_ACTIVE_FILE,
 #endif
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
diff -puN include/linux/vmstat.h~vmstat-mlocked-pages-statistics include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-mlocked-pages-statistics
+++ a/include/linux/vmstat.h
@@ -45,6 +45,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
 		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
 		UNEVICTABLE_PGRESCUED,	/* rescued from noreclaim list */
+		UNEVICTABLE_PGMLOCKED,
+		UNEVICTABLE_PGMUNLOCKED,
+		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
+		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
 #endif
 		NR_VM_EVENT_ITEMS
 };
diff -puN mm/internal.h~vmstat-mlocked-pages-statistics mm/internal.h
--- a/mm/internal.h~vmstat-mlocked-pages-statistics
+++ a/mm/internal.h
@@ -101,7 +101,10 @@ static inline int is_mlocked_vma(struct 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
 		return 0;
 
-	SetPageMlocked(page);
+	if (!TestSetPageMlocked(page)) {
+		inc_zone_page_state(page, NR_MLOCK);
+		count_vm_event(UNEVICTABLE_PGMLOCKED);
+	}
 	return 1;
 }
 
@@ -128,12 +131,19 @@ static inline void clear_page_mlock(stru
 
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
 
 
diff -puN mm/mlock.c~vmstat-mlocked-pages-statistics mm/mlock.c
--- a/mm/mlock.c~vmstat-mlocked-pages-statistics
+++ a/mm/mlock.c
@@ -60,6 +60,8 @@ void __clear_page_mlock(struct page *pag
 		return;
 	}
 
+	dec_zone_page_state(page, NR_MLOCK);
+	count_vm_event(UNEVICTABLE_PGCLEARED);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
 	} else {
@@ -69,6 +71,9 @@ void __clear_page_mlock(struct page *pag
 		lru_add_drain_all();
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
+		else if (PageUnevictable(page))
+			count_vm_event(UNEVICTABLE_PGSTRANDED);
+
 	}
 }
 
@@ -80,8 +85,12 @@ void mlock_vma_page(struct page *page)
 {
 	BUG_ON(!PageLocked(page));
 
-	if (!TestSetPageMlocked(page) && !isolate_lru_page(page))
-		putback_lru_page(page);
+	if (!TestSetPageMlocked(page)) {
+		inc_zone_page_state(page, NR_MLOCK);
+		count_vm_event(UNEVICTABLE_PGMLOCKED);
+		if (!isolate_lru_page(page))
+			putback_lru_page(page);
+	}
 }
 
 /*
@@ -106,9 +115,31 @@ static void munlock_vma_page(struct page
 {
 	BUG_ON(!PageLocked(page));
 
-	if (TestClearPageMlocked(page) && !isolate_lru_page(page)) {
-		try_to_munlock(page);
-		putback_lru_page(page);
+	if (TestClearPageMlocked(page)) {
+		dec_zone_page_state(page, NR_MLOCK);
+		if (!isolate_lru_page(page)) {
+			int ret = try_to_munlock(page);
+			/*
+			 * did try_to_unlock() succeed or punt?
+			 */
+			if (ret == SWAP_SUCCESS || ret == SWAP_AGAIN)
+				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
+
+			putback_lru_page(page);
+		} else {
+			/*
+			 * We lost the race.  let try_to_unmap() deal
+			 * with it.  At least we get the page state and
+			 * mlock stats right.  However, page is still on
+			 * the noreclaim list.  We'll fix that up when
+			 * the page is eventually freed or we scan the
+			 * noreclaim list.
+			 */
+			if (PageUnevictable(page))
+				count_vm_event(UNEVICTABLE_PGSTRANDED);
+			else
+				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
+		}
 	}
 }
 
diff -puN mm/vmstat.c~vmstat-mlocked-pages-statistics mm/vmstat.c
--- a/mm/vmstat.c~vmstat-mlocked-pages-statistics
+++ a/mm/vmstat.c
@@ -625,6 +625,7 @@ static const char * const vmstat_text[] 
 	"nr_active_file",
 #ifdef CONFIG_UNEVICTABLE_LRU
 	"nr_unevictable",
+	"nr_mlock",
 #endif
 	"nr_anon_pages",
 	"nr_mapped",
@@ -684,6 +685,10 @@ static const char * const vmstat_text[] 
 	"unevictable_pgs_culled",
 	"unevictable_pgs_scanned",
 	"unevictable_pgs_rescued",
+	"unevictable_pgs_mlocked",
+	"unevictable_pgs_munlocked",
+	"unevictable_pgs_cleared",
+	"unevictable_pgs_stranded",
 #endif
 #endif
 };
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch


From: akpm@linux-foundation.org
Subject: - unevictable-lru-infrastructure.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:49 -0700
Message-ID: <200810202032.m9KKWnrL010486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbYJTUln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, benjkidwell@yahoo.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com


The patch titled
     Unevictable LRU Infrastructure
has been removed from the -mm tree.  Its filename was
     unevictable-lru-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Unevictable LRU Infrastructure
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

When the system contains lots of mlocked or otherwise unevictable pages,
the pageout code (kswapd) can spend lots of time scanning over these
pages.  Worse still, the presence of lots of unevictable pages can confuse
kswapd into thinking that more aggressive pageout modes are required,
resulting in all kinds of bad behaviour.

Infrastructure to manage pages excluded from reclaim--i.e., hidden from
vmscan.  Based on a patch by Larry Woodman of Red Hat.  Reworked to
maintain "unevictable" pages on a separate per-zone LRU list, to "hide"
them from vmscan.

Kosaki Motohiro added the support for the memory controller unevictable
lru list.

Pages on the unevictable list have both PG_unevictable and PG_lru set. 
Thus, PG_unevictable is analogous to and mutually exclusive with
PG_active--it specifies which LRU list the page is on.

The unevictable infrastructure is enabled by a new mm Kconfig option
[CONFIG_]UNEVICTABLE_LRU.

A new function 'page_evictable(page, vma)' in vmscan.c tests whether or
not a page may be evictable.  Subsequent patches will add the various
!evictable tests.  We'll want to keep these tests light-weight for use in
shrink_active_list() and, possibly, the fault path.

To avoid races between tasks putting pages [back] onto an LRU list and
tasks that might be moving the page from non-evictable to evictable state,
the new function 'putback_lru_page()' -- inverse to 'isolate_lru_page()'
-- tests the "evictability" of a page after placing it on the LRU, before
dropping the reference.  If the page has become unevictable,
putback_lru_page() will redo the 'putback', thus moving the page to the
unevictable list.  This way, we avoid "stranding" evictable pages on the
unevictable list.

[akpm@linux-foundation.org: fix fallout from out-of-order merge]
[riel@redhat.com: fix UNEVICTABLE_LRU and !PROC_PAGE_MONITOR build]
[nishimura@mxp.nes.nec.co.jp: remove redundant mapping check]
[kosaki.motohiro@jp.fujitsu.com: unevictable-lru-infrastructure: putback_lru_page()/unevictable page handling rework]
[kosaki.motohiro@jp.fujitsu.com: kill unnecessary lock_page() in vmscan.c]
[kosaki.motohiro@jp.fujitsu.com: revert migration change of unevictable lru infrastructure]
[kosaki.motohiro@jp.fujitsu.com: revert to unevictable-lru-infrastructure-kconfig-fix.patch]
[kosaki.motohiro@jp.fujitsu.com: restore patch failure of vmstat-unevictable-and-mlocked-pages-vm-events.patch]
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Debugged-by: Benjamin Kidwell <benjkidwell@yahoo.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 
 include/linux/mm_inline.h  |   23 +++--
 include/linux/mmzone.h     |   24 +++++
 include/linux/page-flags.h |   22 ++++-
 include/linux/pagevec.h    |    1 
 include/linux/swap.h       |   12 ++
 mm/Kconfig                 |   11 ++
 mm/internal.h              |   26 ++++++
 mm/memcontrol.c            |   73 ++++++++++-------
 mm/mempolicy.c             |    2 
 mm/migrate.c               |   31 +++----
 mm/swap.c                  |   42 ++++++++-
 mm/vmscan.c                |  149 +++++++++++++++++++++++++++++++----
 13 files changed, 345 insertions(+), 73 deletions(-)

diff -puN include/linux/memcontrol.h~unevictable-lru-infrastructure include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~unevictable-lru-infrastructure
+++ a/include/linux/memcontrol.h
@@ -34,9 +34,9 @@ extern int mem_cgroup_charge(struct page
 				gfp_t gfp_mask);
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
+extern void mem_cgroup_move_lists(struct page *page, enum lru_list lru);
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
-extern void mem_cgroup_move_lists(struct page *page, bool active);
 extern int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask);
 
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
diff -puN include/linux/mm_inline.h~unevictable-lru-infrastructure include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~unevictable-lru-infrastructure
+++ a/include/linux/mm_inline.h
@@ -91,11 +91,16 @@ del_page_from_lru(struct zone *zone, str
 	enum lru_list l = LRU_BASE;
 
 	list_del(&page->lru);
-	if (PageActive(page)) {
-		__ClearPageActive(page);
-		l += LRU_ACTIVE;
+	if (PageUnevictable(page)) {
+		__ClearPageUnevictable(page);
+		l = LRU_UNEVICTABLE;
+	} else {
+		if (PageActive(page)) {
+			__ClearPageActive(page);
+			l += LRU_ACTIVE;
+		}
+		l += page_is_file_cache(page);
 	}
-	l += page_is_file_cache(page);
 	__dec_zone_state(zone, NR_LRU_BASE + l);
 }
 
@@ -110,9 +115,13 @@ static inline enum lru_list page_lru(str
 {
 	enum lru_list lru = LRU_BASE;
 
-	if (PageActive(page))
-		lru += LRU_ACTIVE;
-	lru += page_is_file_cache(page);
+	if (PageUnevictable(page))
+		lru = LRU_UNEVICTABLE;
+	else {
+		if (PageActive(page))
+			lru += LRU_ACTIVE;
+		lru += page_is_file_cache(page);
+	}
 
 	return lru;
 }
diff -puN include/linux/mmzone.h~unevictable-lru-infrastructure include/linux/mmzone.h
--- a/include/linux/mmzone.h~unevictable-lru-infrastructure
+++ a/include/linux/mmzone.h
@@ -86,6 +86,11 @@ enum zone_stat_item {
 	NR_ACTIVE_ANON,		/*  "     "     "   "       "         */
 	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
+#ifdef CONFIG_UNEVICTABLE_LRU
+	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
+#else
+	NR_UNEVICTABLE = NR_ACTIVE_FILE, /* avoid compiler errors in dead code */
+#endif
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
@@ -128,10 +133,18 @@ enum lru_list {
 	LRU_ACTIVE_ANON = LRU_BASE + LRU_ACTIVE,
 	LRU_INACTIVE_FILE = LRU_BASE + LRU_FILE,
 	LRU_ACTIVE_FILE = LRU_BASE + LRU_FILE + LRU_ACTIVE,
-	NR_LRU_LISTS };
+#ifdef CONFIG_UNEVICTABLE_LRU
+	LRU_UNEVICTABLE,
+#else
+	LRU_UNEVICTABLE = LRU_ACTIVE_FILE, /* avoid compiler errors in dead code */
+#endif
+	NR_LRU_LISTS
+};
 
 #define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
 
+#define for_each_evictable_lru(l) for (l = 0; l <= LRU_ACTIVE_FILE; l++)
+
 static inline int is_file_lru(enum lru_list l)
 {
 	return (l == LRU_INACTIVE_FILE || l == LRU_ACTIVE_FILE);
@@ -142,6 +155,15 @@ static inline int is_active_lru(enum lru
 	return (l == LRU_ACTIVE_ANON || l == LRU_ACTIVE_FILE);
 }
 
+static inline int is_unevictable_lru(enum lru_list l)
+{
+#ifdef CONFIG_UNEVICTABLE_LRU
+	return (l == LRU_UNEVICTABLE);
+#else
+	return 0;
+#endif
+}
+
 struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
diff -puN include/linux/page-flags.h~unevictable-lru-infrastructure include/linux/page-flags.h
--- a/include/linux/page-flags.h~unevictable-lru-infrastructure
+++ a/include/linux/page-flags.h
@@ -94,6 +94,9 @@ enum pageflags {
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_buddy,		/* Page is free, on buddy lists */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
+#ifdef CONFIG_UNEVICTABLE_LRU
+	PG_unevictable,		/* Page is "unevictable"  */
+#endif
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 	PG_uncached,		/* Page has been mapped as uncached */
 #endif
@@ -182,6 +185,7 @@ PAGEFLAG(Referenced, referenced) TESTCLE
 PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
 PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
 PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
+	TESTCLEARFLAG(Active, active)
 __PAGEFLAG(Slab, slab)
 PAGEFLAG(Checked, checked)		/* Used by some filesystems */
 PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
@@ -225,6 +229,15 @@ PAGEFLAG(SwapCache, swapcache)
 PAGEFLAG_FALSE(SwapCache)
 #endif
 
+#ifdef CONFIG_UNEVICTABLE_LRU
+PAGEFLAG(Unevictable, unevictable) __CLEARPAGEFLAG(Unevictable, unevictable)
+	TESTCLEARFLAG(Unevictable, unevictable)
+#else
+PAGEFLAG_FALSE(Unevictable) TESTCLEARFLAG_FALSE(Unevictable)
+	SETPAGEFLAG_NOOP(Unevictable) CLEARPAGEFLAG_NOOP(Unevictable)
+	__CLEARPAGEFLAG_NOOP(Unevictable)
+#endif
+
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 PAGEFLAG(Uncached, uncached)
 #else
@@ -340,9 +353,16 @@ static inline void __ClearPageTail(struc
 
 #endif /* !PAGEFLAGS_EXTENDED */
 
+#ifdef CONFIG_UNEVICTABLE_LRU
+#define __PG_UNEVICTABLE (1 << PG_unevictable)
+#else
+#define __PG_UNEVICTABLE 0
+#endif
+
 #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
 			 1 << PG_buddy | 1 << PG_writeback | \
-			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
+			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
+			 __PG_UNEVICTABLE)
 
 /*
  * Flags checked in bad_page().  Pages on the free list should not have
diff -puN include/linux/pagevec.h~unevictable-lru-infrastructure include/linux/pagevec.h
--- a/include/linux/pagevec.h~unevictable-lru-infrastructure
+++ a/include/linux/pagevec.h
@@ -101,7 +101,6 @@ static inline void __pagevec_lru_add_act
 	____pagevec_lru_add(pvec, LRU_ACTIVE_FILE);
 }
 
-
 static inline void pagevec_lru_add_file(struct pagevec *pvec)
 {
 	if (pagevec_count(pvec))
diff -puN include/linux/swap.h~unevictable-lru-infrastructure include/linux/swap.h
--- a/include/linux/swap.h~unevictable-lru-infrastructure
+++ a/include/linux/swap.h
@@ -180,6 +180,8 @@ extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void swap_setup(void);
 
+extern void add_page_to_unevictable_list(struct page *page);
+
 /**
  * lru_cache_add: add a page to the page lists
  * @page: the page to add
@@ -228,6 +230,16 @@ static inline int zone_reclaim(struct zo
 }
 #endif
 
+#ifdef CONFIG_UNEVICTABLE_LRU
+extern int page_evictable(struct page *page, struct vm_area_struct *vma);
+#else
+static inline int page_evictable(struct page *page,
+						struct vm_area_struct *vma)
+{
+	return 1;
+}
+#endif
+
 extern int kswapd_run(int nid);
 
 #ifdef CONFIG_MMU
diff -puN mm/Kconfig~unevictable-lru-infrastructure mm/Kconfig
--- a/mm/Kconfig~unevictable-lru-infrastructure
+++ a/mm/Kconfig
@@ -209,5 +209,16 @@ config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
 
+config UNEVICTABLE_LRU
+	bool "Add LRU list to track non-evictable pages"
+	default y
+	depends on MMU
+	help
+	  Keeps unevictable pages off of the active and inactive pageout
+	  lists, so kswapd will not waste CPU time or have its balancing
+	  algorithms thrown off by scanning these pages.  Selecting this
+	  will use one page flag and increase the code size a little,
+	  say Y unless you know what you are doing.
+
 config MMU_NOTIFIER
 	bool
diff -puN mm/internal.h~unevictable-lru-infrastructure mm/internal.h
--- a/mm/internal.h~unevictable-lru-infrastructure
+++ a/mm/internal.h
@@ -39,8 +39,15 @@ static inline void __put_page(struct pag
 	atomic_dec(&page->_count);
 }
 
+/*
+ * in mm/vmscan.c:
+ */
 extern int isolate_lru_page(struct page *page);
+extern void putback_lru_page(struct page *page);
 
+/*
+ * in mm/page_alloc.c
+ */
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 
 /*
@@ -54,6 +61,25 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
+#ifdef CONFIG_UNEVICTABLE_LRU
+/*
+ * unevictable_migrate_page() called only from migrate_page_copy() to
+ * migrate unevictable flag to new page.
+ * Note that the old page has been isolated from the LRU lists at this
+ * point so we don't need to worry about LRU statistics.
+ */
+static inline void unevictable_migrate_page(struct page *new, struct page *old)
+{
+	if (TestClearPageUnevictable(old))
+		SetPageUnevictable(new);
+}
+#else
+static inline void unevictable_migrate_page(struct page *new, struct page *old)
+{
+}
+#endif
+
+
 /*
  * FLATMEM and DISCONTIGMEM configurations use alloc_bootmem_node,
  * so all functions starting at paging_init should be marked __init
diff -puN mm/memcontrol.c~unevictable-lru-infrastructure mm/memcontrol.c
--- a/mm/memcontrol.c~unevictable-lru-infrastructure
+++ a/mm/memcontrol.c
@@ -160,9 +160,10 @@ struct page_cgroup {
 	struct mem_cgroup *mem_cgroup;
 	int flags;
 };
-#define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
-#define PAGE_CGROUP_FLAG_ACTIVE (0x2)	/* page is active in this cgroup */
-#define PAGE_CGROUP_FLAG_FILE	(0x4)	/* page is file system backed */
+#define PAGE_CGROUP_FLAG_CACHE	   (0x1)	/* charged as cache */
+#define PAGE_CGROUP_FLAG_ACTIVE    (0x2)	/* page is active in this cgroup */
+#define PAGE_CGROUP_FLAG_FILE	   (0x4)	/* page is file system backed */
+#define PAGE_CGROUP_FLAG_UNEVICTABLE (0x8)	/* page is unevictableable */
 
 static int page_cgroup_nid(struct page_cgroup *pc)
 {
@@ -292,10 +293,14 @@ static void __mem_cgroup_remove_list(str
 {
 	int lru = LRU_BASE;
 
-	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
-		lru += LRU_ACTIVE;
-	if (pc->flags & PAGE_CGROUP_FLAG_FILE)
-		lru += LRU_FILE;
+	if (pc->flags & PAGE_CGROUP_FLAG_UNEVICTABLE)
+		lru = LRU_UNEVICTABLE;
+	else {
+		if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+			lru += LRU_ACTIVE;
+		if (pc->flags & PAGE_CGROUP_FLAG_FILE)
+			lru += LRU_FILE;
+	}
 
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
 
@@ -308,10 +313,14 @@ static void __mem_cgroup_add_list(struct
 {
 	int lru = LRU_BASE;
 
-	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
-		lru += LRU_ACTIVE;
-	if (pc->flags & PAGE_CGROUP_FLAG_FILE)
-		lru += LRU_FILE;
+	if (pc->flags & PAGE_CGROUP_FLAG_UNEVICTABLE)
+		lru = LRU_UNEVICTABLE;
+	else {
+		if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+			lru += LRU_ACTIVE;
+		if (pc->flags & PAGE_CGROUP_FLAG_FILE)
+			lru += LRU_FILE;
+	}
 
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	list_add(&pc->lru, &mz->lists[lru]);
@@ -319,21 +328,31 @@ static void __mem_cgroup_add_list(struct
 	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, true);
 }
 
-static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
+static void __mem_cgroup_move_lists(struct page_cgroup *pc, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
-	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
-	int file = pc->flags & PAGE_CGROUP_FLAG_FILE;
-	int lru = LRU_FILE * !!file + !!from;
+	int active    = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
+	int file      = pc->flags & PAGE_CGROUP_FLAG_FILE;
+	int unevictable = pc->flags & PAGE_CGROUP_FLAG_UNEVICTABLE;
+	enum lru_list from = unevictable ? LRU_UNEVICTABLE :
+				(LRU_FILE * !!file + !!active);
 
-	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+	if (lru == from)
+		return;
 
-	if (active)
-		pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
-	else
+	MEM_CGROUP_ZSTAT(mz, from) -= 1;
+
+	if (is_unevictable_lru(lru)) {
 		pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
+		pc->flags |= PAGE_CGROUP_FLAG_UNEVICTABLE;
+	} else {
+		if (is_active_lru(lru))
+			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
+		else
+			pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
+		pc->flags &= ~PAGE_CGROUP_FLAG_UNEVICTABLE;
+	}
 
-	lru = LRU_FILE * !!file + !!active;
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	list_move(&pc->lru, &mz->lists[lru]);
 }
@@ -351,7 +370,7 @@ int task_in_mem_cgroup(struct task_struc
 /*
  * This routine assumes that the appropriate zone's lru lock is already held
  */
-void mem_cgroup_move_lists(struct page *page, bool active)
+void mem_cgroup_move_lists(struct page *page, enum lru_list lru)
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
@@ -374,7 +393,7 @@ void mem_cgroup_move_lists(struct page *
 	if (pc) {
 		mz = page_cgroup_zoneinfo(pc);
 		spin_lock_irqsave(&mz->lru_lock, flags);
-		__mem_cgroup_move_lists(pc, active);
+		__mem_cgroup_move_lists(pc, lru);
 		spin_unlock_irqrestore(&mz->lru_lock, flags);
 	}
 	unlock_page_cgroup(page);
@@ -472,12 +491,10 @@ unsigned long mem_cgroup_isolate_pages(u
 		/*
 		 * TODO: play better with lumpy reclaim, grabbing anything.
 		 */
-		if (PageActive(page) && !active) {
-			__mem_cgroup_move_lists(pc, true);
-			continue;
-		}
-		if (!PageActive(page) && active) {
-			__mem_cgroup_move_lists(pc, false);
+		if (PageUnevictable(page) ||
+		    (PageActive(page) && !active) ||
+		    (!PageActive(page) && active)) {
+			__mem_cgroup_move_lists(pc, page_lru(page));
 			continue;
 		}
 
diff -puN mm/mempolicy.c~unevictable-lru-infrastructure mm/mempolicy.c
--- a/mm/mempolicy.c~unevictable-lru-infrastructure
+++ a/mm/mempolicy.c
@@ -2202,7 +2202,7 @@ static void gather_stats(struct page *pa
 	if (PageSwapCache(page))
 		md->swapcache++;
 
-	if (PageActive(page))
+	if (PageActive(page) || PageUnevictable(page))
 		md->active++;
 
 	if (PageWriteback(page))
diff -puN mm/migrate.c~unevictable-lru-infrastructure mm/migrate.c
--- a/mm/migrate.c~unevictable-lru-infrastructure
+++ a/mm/migrate.c
@@ -53,14 +53,9 @@ int migrate_prep(void)
 	return 0;
 }
 
-static inline void move_to_lru(struct page *page)
-{
-	lru_cache_add_lru(page, page_lru(page));
-	put_page(page);
-}
-
 /*
- * Add isolated pages on the list back to the LRU.
+ * Add isolated pages on the list back to the LRU under page lock
+ * to avoid leaking evictable pages back onto unevictable list.
  *
  * returns the number of pages put back.
  */
@@ -72,7 +67,7 @@ int putback_lru_pages(struct list_head *
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		list_del(&page->lru);
-		move_to_lru(page);
+		putback_lru_page(page);
 		count++;
 	}
 	return count;
@@ -354,8 +349,11 @@ static void migrate_page_copy(struct pag
 		SetPageReferenced(newpage);
 	if (PageUptodate(page))
 		SetPageUptodate(newpage);
-	if (PageActive(page))
+	if (TestClearPageActive(page)) {
+		VM_BUG_ON(PageUnevictable(page));
 		SetPageActive(newpage);
+	} else
+		unevictable_migrate_page(newpage, page);
 	if (PageChecked(page))
 		SetPageChecked(newpage);
 	if (PageMappedToDisk(page))
@@ -376,7 +374,6 @@ static void migrate_page_copy(struct pag
 #ifdef CONFIG_SWAP
 	ClearPageSwapCache(page);
 #endif
-	ClearPageActive(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
 	page->mapping = NULL;
@@ -555,6 +552,10 @@ static int fallback_migrate_page(struct 
  *
  * The new page will have replaced the old page if this function
  * is successful.
+ *
+ * Return value:
+ *   < 0 - error code
+ *  == 0 - success
  */
 static int move_to_new_page(struct page *newpage, struct page *page)
 {
@@ -617,9 +618,10 @@ static int unmap_and_move(new_page_t get
 	if (!newpage)
 		return -ENOMEM;
 
-	if (page_count(page) == 1)
+	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
 		goto move_newpage;
+	}
 
 	charge = mem_cgroup_prepare_migration(page, newpage);
 	if (charge == -ENOMEM) {
@@ -693,7 +695,6 @@ rcu_unlock:
 		rcu_read_unlock();
 
 unlock:
-
 	unlock_page(page);
 
 	if (rc != -EAGAIN) {
@@ -704,17 +705,19 @@ unlock:
  		 * restored.
  		 */
  		list_del(&page->lru);
- 		move_to_lru(page);
+		putback_lru_page(page);
 	}
 
 move_newpage:
 	if (!charge)
 		mem_cgroup_end_migration(newpage);
+
 	/*
 	 * Move the new page to the LRU. If migration was not successful
 	 * then this will free the page.
 	 */
-	move_to_lru(newpage);
+	putback_lru_page(newpage);
+
 	if (result) {
 		if (rc)
 			*result = rc;
diff -puN mm/swap.c~unevictable-lru-infrastructure mm/swap.c
--- a/mm/swap.c~unevictable-lru-infrastructure
+++ a/mm/swap.c
@@ -115,7 +115,7 @@ static void pagevec_move_tail(struct pag
 			zone = pagezone;
 			spin_lock(&zone->lru_lock);
 		}
-		if (PageLRU(page) && !PageActive(page)) {
+		if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 			int lru = page_is_file_cache(page);
 			list_move_tail(&page->lru, &zone->lru[lru].list);
 			pgmoved++;
@@ -136,7 +136,7 @@ static void pagevec_move_tail(struct pag
 void  rotate_reclaimable_page(struct page *page)
 {
 	if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
-	    PageLRU(page)) {
+	    !PageUnevictable(page) && PageLRU(page)) {
 		struct pagevec *pvec;
 		unsigned long flags;
 
@@ -157,7 +157,7 @@ void activate_page(struct page *page)
 	struct zone *zone = page_zone(page);
 
 	spin_lock_irq(&zone->lru_lock);
-	if (PageLRU(page) && !PageActive(page)) {
+	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_cache(page);
 		int lru = LRU_BASE + file;
 		del_page_from_lru_list(zone, page, lru);
@@ -166,7 +166,7 @@ void activate_page(struct page *page)
 		lru += LRU_ACTIVE;
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
-		mem_cgroup_move_lists(page, true);
+		mem_cgroup_move_lists(page, lru);
 
 		zone->recent_rotated[!!file]++;
 		zone->recent_scanned[!!file]++;
@@ -183,7 +183,8 @@ void activate_page(struct page *page)
  */
 void mark_page_accessed(struct page *page)
 {
-	if (!PageActive(page) && PageReferenced(page) && PageLRU(page)) {
+	if (!PageActive(page) && !PageUnevictable(page) &&
+			PageReferenced(page) && PageLRU(page)) {
 		activate_page(page);
 		ClearPageReferenced(page);
 	} else if (!PageReferenced(page)) {
@@ -211,13 +212,38 @@ void __lru_cache_add(struct page *page, 
 void lru_cache_add_lru(struct page *page, enum lru_list lru)
 {
 	if (PageActive(page)) {
+		VM_BUG_ON(PageUnevictable(page));
 		ClearPageActive(page);
+	} else if (PageUnevictable(page)) {
+		VM_BUG_ON(PageActive(page));
+		ClearPageUnevictable(page);
 	}
 
-	VM_BUG_ON(PageLRU(page) || PageActive(page));
+	VM_BUG_ON(PageLRU(page) || PageActive(page) || PageUnevictable(page));
 	__lru_cache_add(page, lru);
 }
 
+/**
+ * add_page_to_unevictable_list - add a page to the unevictable list
+ * @page:  the page to be added to the unevictable list
+ *
+ * Add page directly to its zone's unevictable list.  To avoid races with
+ * tasks that might be making the page evictable, through eg. munlock,
+ * munmap or exit, while it's not on the lru, we want to add the page
+ * while it's locked or otherwise "invisible" to other tasks.  This is
+ * difficult to do when using the pagevec cache, so bypass that.
+ */
+void add_page_to_unevictable_list(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+
+	spin_lock_irq(&zone->lru_lock);
+	SetPageUnevictable(page);
+	SetPageLRU(page);
+	add_page_to_lru_list(zone, page, LRU_UNEVICTABLE);
+	spin_unlock_irq(&zone->lru_lock);
+}
+
 /*
  * Drain pages out of the cpu's pagevecs.
  * Either "cpu" is the current CPU, and preemption has already been
@@ -316,6 +342,7 @@ void release_pages(struct page **pages, 
 
 		if (PageLRU(page)) {
 			struct zone *pagezone = page_zone(page);
+
 			if (pagezone != zone) {
 				if (zone)
 					spin_unlock_irqrestore(&zone->lru_lock,
@@ -392,6 +419,7 @@ void ____pagevec_lru_add(struct pagevec 
 {
 	int i;
 	struct zone *zone = NULL;
+	VM_BUG_ON(is_unevictable_lru(lru));
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
@@ -403,6 +431,8 @@ void ____pagevec_lru_add(struct pagevec 
 			zone = pagezone;
 			spin_lock_irq(&zone->lru_lock);
 		}
+		VM_BUG_ON(PageActive(page));
+		VM_BUG_ON(PageUnevictable(page));
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 		if (is_active_lru(lru))
diff -puN mm/vmscan.c~unevictable-lru-infrastructure mm/vmscan.c
--- a/mm/vmscan.c~unevictable-lru-infrastructure
+++ a/mm/vmscan.c
@@ -470,6 +470,79 @@ int remove_mapping(struct address_space 
 	return 0;
 }
 
+/**
+ * putback_lru_page - put previously isolated page onto appropriate LRU list
+ * @page: page to be put back to appropriate lru list
+ *
+ * Add previously isolated @page to appropriate LRU list.
+ * Page may still be unevictable for other reasons.
+ *
+ * lru_lock must not be held, interrupts must be enabled.
+ */
+#ifdef CONFIG_UNEVICTABLE_LRU
+void putback_lru_page(struct page *page)
+{
+	int lru;
+	int active = !!TestClearPageActive(page);
+
+	VM_BUG_ON(PageLRU(page));
+
+redo:
+	ClearPageUnevictable(page);
+
+	if (page_evictable(page, NULL)) {
+		/*
+		 * For evictable pages, we can use the cache.
+		 * In event of a race, worst case is we end up with an
+		 * unevictable page on [in]active list.
+		 * We know how to handle that.
+		 */
+		lru = active + page_is_file_cache(page);
+		lru_cache_add_lru(page, lru);
+	} else {
+		/*
+		 * Put unevictable pages directly on zone's unevictable
+		 * list.
+		 */
+		lru = LRU_UNEVICTABLE;
+		add_page_to_unevictable_list(page);
+	}
+	mem_cgroup_move_lists(page, lru);
+
+	/*
+	 * page's status can change while we move it among lru. If an evictable
+	 * page is on unevictable list, it never be freed. To avoid that,
+	 * check after we added it to the list, again.
+	 */
+	if (lru == LRU_UNEVICTABLE && page_evictable(page, NULL)) {
+		if (!isolate_lru_page(page)) {
+			put_page(page);
+			goto redo;
+		}
+		/* This means someone else dropped this page from LRU
+		 * So, it will be freed or putback to LRU again. There is
+		 * nothing to do here.
+		 */
+	}
+
+	put_page(page);		/* drop ref from isolate */
+}
+
+#else /* CONFIG_UNEVICTABLE_LRU */
+
+void putback_lru_page(struct page *page)
+{
+	int lru;
+	VM_BUG_ON(PageLRU(page));
+
+	lru = !!TestClearPageActive(page) + page_is_file_cache(page);
+	lru_cache_add_lru(page, lru);
+	mem_cgroup_move_lists(page, lru);
+	put_page(page);
+}
+#endif /* CONFIG_UNEVICTABLE_LRU */
+
+
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -503,6 +576,12 @@ static unsigned long shrink_page_list(st
 
 		sc->nr_scanned++;
 
+		if (unlikely(!page_evictable(page, NULL))) {
+			unlock_page(page);
+			putback_lru_page(page);
+			continue;
+		}
+
 		if (!sc->may_swap && page_mapped(page))
 			goto keep_locked;
 
@@ -602,7 +681,7 @@ static unsigned long shrink_page_list(st
 		 * possible for a page to have PageDirty set, but it is actually
 		 * clean (all its buffers are clean).  This happens if the
 		 * buffers were written out directly, with submit_bh(). ext3
-		 * will do this, as well as the blockdev mapping. 
+		 * will do this, as well as the blockdev mapping.
 		 * try_to_release_page() will discover that cleanness and will
 		 * drop the buffers and mark the page clean - it can be freed.
 		 *
@@ -650,6 +729,7 @@ activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (PageSwapCache(page) && vm_swap_full())
 			remove_exclusive_swap_page_ref(page);
+		VM_BUG_ON(PageActive(page));
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
@@ -699,6 +779,14 @@ int __isolate_lru_page(struct page *page
 	if (mode != ISOLATE_BOTH && (!page_is_file_cache(page) != !file))
 		return ret;
 
+	/*
+	 * When this function is being called for lumpy reclaim, we
+	 * initially look into all LRU pages, active, inactive and
+	 * unevictable; only give shrink_page_list evictable pages.
+	 */
+	if (PageUnevictable(page))
+		return ret;
+
 	ret = -EBUSY;
 	if (likely(get_page_unless_zero(page))) {
 		/*
@@ -810,7 +898,7 @@ static unsigned long isolate_lru_pages(u
 				/* else it is being freed elsewhere */
 				list_move(&cursor_page->lru, src);
 			default:
-				break;
+				break;	/* ! on LRU or wrong list */
 			}
 		}
 	}
@@ -870,8 +958,9 @@ static unsigned long clear_active_flags(
  * Returns -EBUSY if the page was not on an LRU list.
  *
  * The returned page will have PageLRU() cleared.  If it was found on
- * the active list, it will have PageActive set.  That flag may need
- * to be cleared by the caller before letting the page go.
+ * the active list, it will have PageActive set.  If it was found on
+ * the unevictable list, it will have the PageUnevictable bit set. That flag
+ * may need to be cleared by the caller before letting the page go.
  *
  * The vmstat statistic corresponding to the list on which the page was
  * found will be decremented.
@@ -892,11 +981,10 @@ int isolate_lru_page(struct page *page)
 
 		spin_lock_irq(&zone->lru_lock);
 		if (PageLRU(page) && get_page_unless_zero(page)) {
-			int lru = LRU_BASE;
+			int lru = page_lru(page);
 			ret = 0;
 			ClearPageLRU(page);
 
-			lru += page_is_file_cache(page) + !!PageActive(page);
 			del_page_from_lru_list(zone, page, lru);
 		}
 		spin_unlock_irq(&zone->lru_lock);
@@ -1008,11 +1096,20 @@ static unsigned long shrink_inactive_lis
 		 * Put back any unfreeable pages.
 		 */
 		while (!list_empty(&page_list)) {
+			int lru;
 			page = lru_to_page(&page_list);
 			VM_BUG_ON(PageLRU(page));
-			SetPageLRU(page);
 			list_del(&page->lru);
-			add_page_to_lru_list(zone, page, page_lru(page));
+			if (unlikely(!page_evictable(page, NULL))) {
+				spin_unlock_irq(&zone->lru_lock);
+				putback_lru_page(page);
+				spin_lock_irq(&zone->lru_lock);
+				continue;
+			}
+			SetPageLRU(page);
+			lru = page_lru(page);
+			add_page_to_lru_list(zone, page, lru);
+			mem_cgroup_move_lists(page, lru);
 			if (PageActive(page) && scan_global_lru(sc)) {
 				int file = !!page_is_file_cache(page);
 				zone->recent_rotated[file]++;
@@ -1107,6 +1204,11 @@ static void shrink_active_list(unsigned 
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
 
+		if (unlikely(!page_evictable(page, NULL))) {
+			putback_lru_page(page);
+			continue;
+		}
+
 		/* page_referenced clears PageReferenced */
 		if (page_mapping_inuse(page) &&
 		    page_referenced(page, 0, sc->mem_cgroup))
@@ -1140,7 +1242,7 @@ static void shrink_active_list(unsigned 
 		ClearPageActive(page);
 
 		list_move(&page->lru, &zone->lru[lru].list);
-		mem_cgroup_move_lists(page, false);
+		mem_cgroup_move_lists(page, lru);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
@@ -1286,7 +1388,7 @@ static unsigned long shrink_zone(int pri
 
 	get_scan_ratio(zone, sc, percent);
 
-	for_each_lru(l) {
+	for_each_evictable_lru(l) {
 		if (scan_global_lru(sc)) {
 			int file = is_file_lru(l);
 			int scan;
@@ -1318,7 +1420,7 @@ static unsigned long shrink_zone(int pri
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
-		for_each_lru(l) {
+		for_each_evictable_lru(l) {
 			if (nr[l]) {
 				nr_to_scan = min(nr[l],
 					(unsigned long)sc->swap_cluster_max);
@@ -1875,8 +1977,8 @@ static unsigned long shrink_all_zones(un
 		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
 			continue;
 
-		for_each_lru(l) {
-			/* For pass = 0 we don't shrink the active list */
+		for_each_evictable_lru(l) {
+			/* For pass = 0, we don't shrink the active list */
 			if (pass == 0 &&
 				(l == LRU_ACTIVE || l == LRU_ACTIVE_FILE))
 				continue;
@@ -2213,3 +2315,24 @@ int zone_reclaim(struct zone *zone, gfp_
 	return ret;
 }
 #endif
+
+#ifdef CONFIG_UNEVICTABLE_LRU
+/*
+ * page_evictable - test whether a page is evictable
+ * @page: the page to test
+ * @vma: the VMA in which the page is or will be mapped, may be NULL
+ *
+ * Test whether page is evictable--i.e., should be placed on active/inactive
+ * lists vs unevictable list.
+ *
+ * Reasons page might not be evictable:
+ * TODO - later patches
+ */
+int page_evictable(struct page *page, struct vm_area_struct *vma)
+{
+
+	/* TODO:  test page [!]evictable conditions */
+
+	return 1;
+}
+#endif
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch


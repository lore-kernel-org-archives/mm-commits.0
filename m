From: akpm@linux-foundation.org
Subject: - vmscan-noreclaim-lru-infrastructure.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:21 -0700
Message-ID: <200806111946.m5BJkLS7014577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbYFKTqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: Noreclaim LRU Infrastructure
has been removed from the -mm tree.  Its filename was
     vmscan-noreclaim-lru-infrastructure.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: Noreclaim LRU Infrastructure
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Infrastructure to manage pages excluded from reclaim--i.e., hidden from
vmscan.  Based on a patch by Larry Woodman of Red Hat.  Reworked to
maintain "nonreclaimable" pages on a separate per-zone LRU list, to "hide"
them from vmscan.

Kosaki Motohiro added the support for the memory controller noreclaim lru
list.

Pages on the noreclaim list have both PG_noreclaim and PG_lru set.  Thus,
PG_noreclaim is analogous to and mutually exclusive with PG_active--it
specifies which LRU list the page is on.

The noreclaim infrastructure is enabled by a new mm Kconfig option
[CONFIG_]NORECLAIM_LRU.

A new function 'page_reclaimable(page, vma)' in vmscan.c tests whether or
not a page is reclaimable.  Subsequent patches will add the various
!reclaimable tests.  We'll want to keep these tests light-weight for use
in shrink_active_list() and, possibly, the fault path.

To avoid races between tasks putting pages [back] onto an LRU list and
tasks that might be moving the page from nonreclaimable to reclaimable
state, one should test reclaimability under page lock and place
nonreclaimable pages directly on the noreclaim list before dropping the
lock.  Otherwise, we risk "stranding" reclaimable pages on the noreclaim
list.  It's OK to use the pagevec caches for reclaimable pages.  The new
function 'putback_lru_page()'--inverse to 'isolate_lru_page()'--handles
this transition, including potential page truncation while the page is
unlocked.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 
 include/linux/mm_inline.h  |   13 +-
 include/linux/mmzone.h     |   24 ++++-
 include/linux/page-flags.h |   13 ++
 include/linux/pagevec.h    |    1 
 include/linux/swap.h       |   12 ++
 mm/Kconfig                 |   10 ++
 mm/internal.h              |   26 +++++
 mm/memcontrol.c            |   73 +++++++++------
 mm/mempolicy.c             |    2 
 mm/migrate.c               |   68 +++++++++-----
 mm/page_alloc.c            |    9 +
 mm/swap.c                  |   52 +++++++++--
 mm/vmscan.c                |  164 ++++++++++++++++++++++++++++++-----
 14 files changed, 382 insertions(+), 87 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-noreclaim-lru-infrastructure include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-noreclaim-lru-infrastructure
+++ a/include/linux/memcontrol.h
@@ -36,7 +36,7 @@ extern int mem_cgroup_cache_charge(struc
 					gfp_t gfp_mask);
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
-extern void mem_cgroup_move_lists(struct page *page, bool active);
+extern void mem_cgroup_move_lists(struct page *page, enum lru_list lru);
 extern int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask);
 
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
diff -puN include/linux/mm_inline.h~vmscan-noreclaim-lru-infrastructure include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~vmscan-noreclaim-lru-infrastructure
+++ a/include/linux/mm_inline.h
@@ -89,11 +89,16 @@ del_page_from_lru(struct zone *zone, str
 	enum lru_list l = LRU_INACTIVE_ANON;
 
 	list_del(&page->lru);
-	if (PageActive(page)) {
-		__ClearPageActive(page);
-		l += LRU_ACTIVE;
+	if (PageNoreclaim(page)) {
+		__ClearPageNoreclaim(page);
+		l = LRU_NORECLAIM;
+	} else {
+		 if (PageActive(page)) {
+			__ClearPageActive(page);
+			l += LRU_ACTIVE;
+		}
+		l += page_file_cache(page);
 	}
-	l += page_file_cache(page);
 	__dec_zone_state(zone, NR_INACTIVE_ANON + l);
 }
 
diff -puN include/linux/mmzone.h~vmscan-noreclaim-lru-infrastructure include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-noreclaim-lru-infrastructure
+++ a/include/linux/mmzone.h
@@ -85,6 +85,11 @@ enum zone_stat_item {
 	NR_ACTIVE_ANON,		/*  "     "     "   "       "           */
 	NR_INACTIVE_FILE,	/*  "     "     "   "       "           */
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "           */
+#ifdef CONFIG_NORECLAIM_LRU
+	NR_NORECLAIM,	/*  "     "     "   "       "         */
+#else
+	NR_NORECLAIM = NR_ACTIVE_FILE, /* avoid compiler errors in dead code */
+#endif
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
@@ -124,10 +129,18 @@ enum lru_list {
 	LRU_ACTIVE_ANON = LRU_BASE + LRU_ACTIVE,
 	LRU_INACTIVE_FILE = LRU_BASE + LRU_FILE,
 	LRU_ACTIVE_FILE = LRU_BASE + LRU_FILE + LRU_ACTIVE,
-	NR_LRU_LISTS };
+#ifdef CONFIG_NORECLAIM_LRU
+	LRU_NORECLAIM,
+#else
+	LRU_NORECLAIM = LRU_ACTIVE_FILE, /* avoid compiler errors in dead code */
+#endif
+	NR_LRU_LISTS
+};
 
 #define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
 
+#define for_each_reclaimable_lru(l) for (l = 0; l <= LRU_ACTIVE_FILE; l++)
+
 static inline int is_file_lru(enum lru_list l)
 {
 	return (l == LRU_INACTIVE_FILE || l == LRU_ACTIVE_FILE);
@@ -138,6 +151,15 @@ static inline int is_active_lru(enum lru
 	return (l == LRU_ACTIVE_ANON || l == LRU_ACTIVE_FILE);
 }
 
+static inline int is_noreclaim_lru(enum lru_list l)
+{
+#ifdef CONFIG_NORECLAIM_LRU
+	return l == LRU_NORECLAIM;
+#else
+	return 0;
+#endif
+}
+
 enum lru_list page_lru(struct page *page);
 
 struct per_cpu_pages {
diff -puN include/linux/page-flags.h~vmscan-noreclaim-lru-infrastructure include/linux/page-flags.h
--- a/include/linux/page-flags.h~vmscan-noreclaim-lru-infrastructure
+++ a/include/linux/page-flags.h
@@ -94,6 +94,9 @@ enum pageflags {
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_buddy,		/* Page is free, on buddy lists */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
+#ifdef CONFIG_NORECLAIM_LRU
+	PG_noreclaim,		/* Page is "non-reclaimable"  */
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
 
+#ifdef CONFIG_NORECLAIM_LRU
+PAGEFLAG(Noreclaim, noreclaim) __CLEARPAGEFLAG(Noreclaim, noreclaim)
+	TESTCLEARFLAG(Noreclaim, noreclaim)
+#else
+PAGEFLAG_FALSE(Noreclaim) TESTCLEARFLAG_FALSE(Noreclaim)
+	SETPAGEFLAG_NOOP(Noreclaim) CLEARPAGEFLAG_NOOP(Noreclaim)
+	__CLEARPAGEFLAG_NOOP(Noreclaim)
+#endif
+
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 PAGEFLAG(Uncached, uncached)
 #else
diff -puN include/linux/pagevec.h~vmscan-noreclaim-lru-infrastructure include/linux/pagevec.h
--- a/include/linux/pagevec.h~vmscan-noreclaim-lru-infrastructure
+++ a/include/linux/pagevec.h
@@ -101,7 +101,6 @@ static inline void __pagevec_lru_add_act
 	____pagevec_lru_add(pvec, LRU_ACTIVE_FILE);
 }
 
-
 static inline void pagevec_lru_add_file(struct pagevec *pvec)
 {
 	if (pagevec_count(pvec))
diff -puN include/linux/swap.h~vmscan-noreclaim-lru-infrastructure include/linux/swap.h
--- a/include/linux/swap.h~vmscan-noreclaim-lru-infrastructure
+++ a/include/linux/swap.h
@@ -180,6 +180,8 @@ extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void swap_setup(void);
 
+extern void add_page_to_noreclaim_list(struct page *page);
+
 /**
  * lru_cache_add: add a page to the page lists
  * @page: the page to add
@@ -228,6 +230,16 @@ static inline int zone_reclaim(struct zo
 }
 #endif
 
+#ifdef CONFIG_NORECLAIM_LRU
+extern int page_reclaimable(struct page *page, struct vm_area_struct *vma);
+#else
+static inline int page_reclaimable(struct page *page,
+						struct vm_area_struct *vma)
+{
+	return 1;
+}
+#endif
+
 extern int kswapd_run(int nid);
 
 #ifdef CONFIG_MMU
diff -puN mm/Kconfig~vmscan-noreclaim-lru-infrastructure mm/Kconfig
--- a/mm/Kconfig~vmscan-noreclaim-lru-infrastructure
+++ a/mm/Kconfig
@@ -208,3 +208,13 @@ config NR_QUICK
 config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
+
+config NORECLAIM_LRU
+	bool "Add LRU list to track non-reclaimable pages (EXPERIMENTAL, 64BIT only)"
+	depends on EXPERIMENTAL && 64BIT
+	help
+	  Supports tracking of non-reclaimable pages off the [in]active lists
+	  to avoid excessive reclaim overhead on large memory systems.  Pages
+	  may be non-reclaimable because:  they are locked into memory, they
+	  are anonymous pages for which no swap space exists, or they are anon
+	  pages that are expensive to unmap [long anon_vma "related vma" list.]
diff -puN mm/internal.h~vmscan-noreclaim-lru-infrastructure mm/internal.h
--- a/mm/internal.h~vmscan-noreclaim-lru-infrastructure
+++ a/mm/internal.h
@@ -39,8 +39,15 @@ static inline void __put_page(struct pag
 	atomic_dec(&page->_count);
 }
 
+/*
+ * in mm/vmscan.c:
+ */
 extern int isolate_lru_page(struct page *page);
+extern int putback_lru_page(struct page *page);
 
+/*
+ * in mm/page_alloc.c
+ */
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 
 /*
@@ -54,6 +61,25 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
+#ifdef CONFIG_NORECLAIM_LRU
+/*
+ * noreclaim_migrate_page() called only from migrate_page_copy() to
+ * migrate noreclaim flag to new page.
+ * Note that the old page has been isolated from the LRU lists at this
+ * point so we don't need to worry about LRU statistics.
+ */
+static inline void noreclaim_migrate_page(struct page *new, struct page *old)
+{
+	if (TestClearPageNoreclaim(old))
+		SetPageNoreclaim(new);
+}
+#else
+static inline void noreclaim_migrate_page(struct page *new, struct page *old)
+{
+}
+#endif
+
+
 /*
  * FLATMEM and DISCONTIGMEM configurations use alloc_bootmem_node,
  * so all functions starting at paging_init should be marked __init
diff -puN mm/memcontrol.c~vmscan-noreclaim-lru-infrastructure mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-noreclaim-lru-infrastructure
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
+#define PAGE_CGROUP_FLAG_NORECLAIM (0x8)	/* page is noreclaimable page */
 
 static int page_cgroup_nid(struct page_cgroup *pc)
 {
@@ -283,10 +284,14 @@ static void __mem_cgroup_remove_list(str
 {
 	int lru = LRU_BASE;
 
-	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
-		lru += LRU_ACTIVE;
-	if (pc->flags & PAGE_CGROUP_FLAG_FILE)
-		lru += LRU_FILE;
+	if (pc->flags & PAGE_CGROUP_FLAG_NORECLAIM)
+		lru = LRU_NORECLAIM;
+	else {
+		if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+			lru += LRU_ACTIVE;
+		if (pc->flags & PAGE_CGROUP_FLAG_FILE)
+			lru += LRU_FILE;
+	}
 
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
 
@@ -299,10 +304,14 @@ static void __mem_cgroup_add_list(struct
 {
 	int lru = LRU_BASE;
 
-	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
-		lru += LRU_ACTIVE;
-	if (pc->flags & PAGE_CGROUP_FLAG_FILE)
-		lru += LRU_FILE;
+	if (pc->flags & PAGE_CGROUP_FLAG_NORECLAIM)
+		lru = LRU_NORECLAIM;
+	else {
+		if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+			lru += LRU_ACTIVE;
+		if (pc->flags & PAGE_CGROUP_FLAG_FILE)
+			lru += LRU_FILE;
+	}
 
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	list_add(&pc->lru, &mz->lists[lru]);
@@ -310,21 +319,31 @@ static void __mem_cgroup_add_list(struct
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
+	int noreclaim = pc->flags & PAGE_CGROUP_FLAG_NORECLAIM;
+	enum lru_list from = noreclaim ? LRU_NORECLAIM :
+				(LRU_FILE * !!file + !!active);
 
-	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+	if (lru == from)
+		return;
 
-	if (active)
-		pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
-	else
+	MEM_CGROUP_ZSTAT(mz, from) -= 1;
+
+	if (is_noreclaim_lru(lru)) {
 		pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
+		pc->flags |= PAGE_CGROUP_FLAG_NORECLAIM;
+	} else {
+		if (is_active_lru(lru))
+			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
+		else
+			pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
+		pc->flags &= ~PAGE_CGROUP_FLAG_NORECLAIM;
+	}
 
-	lru = LRU_FILE * !!file + !!active;
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	list_move(&pc->lru, &mz->lists[lru]);
 }
@@ -342,7 +361,7 @@ int task_in_mem_cgroup(struct task_struc
 /*
  * This routine assumes that the appropriate zone's lru lock is already held
  */
-void mem_cgroup_move_lists(struct page *page, bool active)
+void mem_cgroup_move_lists(struct page *page, enum lru_list lru)
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
@@ -362,7 +381,7 @@ void mem_cgroup_move_lists(struct page *
 	if (pc) {
 		mz = page_cgroup_zoneinfo(pc);
 		spin_lock_irqsave(&mz->lru_lock, flags);
-		__mem_cgroup_move_lists(pc, active);
+		__mem_cgroup_move_lists(pc, lru);
 		spin_unlock_irqrestore(&mz->lru_lock, flags);
 	}
 	unlock_page_cgroup(page);
@@ -460,12 +479,10 @@ unsigned long mem_cgroup_isolate_pages(u
 		/*
 		 * TODO: play better with lumpy reclaim, grabbing anything.
 		 */
-		if (PageActive(page) && !active) {
-			__mem_cgroup_move_lists(pc, true);
-			continue;
-		}
-		if (!PageActive(page) && active) {
-			__mem_cgroup_move_lists(pc, false);
+		if (PageNoreclaim(page) ||
+		    (PageActive(page) && !active) ||
+		    (!PageActive(page) && active)) {
+			__mem_cgroup_move_lists(pc, page_lru(page));
 			continue;
 		}
 
diff -puN mm/mempolicy.c~vmscan-noreclaim-lru-infrastructure mm/mempolicy.c
--- a/mm/mempolicy.c~vmscan-noreclaim-lru-infrastructure
+++ a/mm/mempolicy.c
@@ -2199,7 +2199,7 @@ static void gather_stats(struct page *pa
 	if (PageSwapCache(page))
 		md->swapcache++;
 
-	if (PageActive(page))
+	if (PageActive(page) || PageNoreclaim(page))
 		md->active++;
 
 	if (PageWriteback(page))
diff -puN mm/migrate.c~vmscan-noreclaim-lru-infrastructure mm/migrate.c
--- a/mm/migrate.c~vmscan-noreclaim-lru-infrastructure
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
+ * to avoid leaking reclaimable pages back onto noreclaim list.
  *
  * returns the number of pages put back.
  */
@@ -72,7 +67,9 @@ int putback_lru_pages(struct list_head *
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		list_del(&page->lru);
-		move_to_lru(page);
+		lock_page(page);
+		if (putback_lru_page(page))
+			unlock_page(page);
 		count++;
 	}
 	return count;
@@ -346,8 +343,11 @@ static void migrate_page_copy(struct pag
 		SetPageReferenced(newpage);
 	if (PageUptodate(page))
 		SetPageUptodate(newpage);
-	if (PageActive(page))
+	if (TestClearPageActive(page)) {
+		VM_BUG_ON(PageNoreclaim(page));
 		SetPageActive(newpage);
+	} else
+		noreclaim_migrate_page(newpage, page);
 	if (PageChecked(page))
 		SetPageChecked(newpage);
 	if (PageMappedToDisk(page))
@@ -376,7 +376,6 @@ static void migrate_page_copy(struct pag
 		mem_cgroup_uncharge_page(page);
 	}
 #endif
-	ClearPageActive(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
 	page->mapping = NULL;
@@ -555,10 +554,15 @@ static int fallback_migrate_page(struct 
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
 	struct address_space *mapping;
+	int unlock = 1;
 	int rc;
 
 	/*
@@ -593,10 +597,16 @@ static int move_to_new_page(struct page 
 
 	if (!rc) {
 		remove_migration_ptes(page, newpage);
+		/*
+		 * Put back on LRU while holding page locked to
+		 * handle potential race with, e.g., munlock()
+		 */
+		unlock = putback_lru_page(newpage);
 	} else
 		newpage->mapping = NULL;
 
-	unlock_page(newpage);
+	if (unlock)
+		unlock_page(newpage);
 
 	return rc;
 }
@@ -613,18 +623,19 @@ static int unmap_and_move(new_page_t get
 	struct page *newpage = get_new_page(page, private, &result);
 	int rcu_locked = 0;
 	int charge = 0;
+	int unlock = 1;
 
 	if (!newpage)
 		return -ENOMEM;
 
 	if (page_count(page) == 1)
 		/* page was freed from under us. So we are done. */
-		goto move_newpage;
+		goto end_migration;
 
 	charge = mem_cgroup_prepare_migration(page, newpage);
 	if (charge == -ENOMEM) {
 		rc = -ENOMEM;
-		goto move_newpage;
+		goto end_migration;
 	}
 	/* prepare cgroup just returns 0 or -ENOMEM */
 	BUG_ON(charge);
@@ -632,7 +643,7 @@ static int unmap_and_move(new_page_t get
 	rc = -EAGAIN;
 	if (TestSetPageLocked(page)) {
 		if (!force)
-			goto move_newpage;
+			goto end_migration;
 		lock_page(page);
 	}
 
@@ -694,8 +705,6 @@ rcu_unlock:
 
 unlock:
 
-	unlock_page(page);
-
 	if (rc != -EAGAIN) {
  		/*
  		 * A page that has been migrated has all references
@@ -704,17 +713,30 @@ unlock:
  		 * restored.
  		 */
  		list_del(&page->lru);
- 		move_to_lru(page);
+		if (!page->mapping) {
+			VM_BUG_ON(page_count(page) != 1);
+			unlock_page(page);
+			put_page(page);		/* just free the old page */
+			goto end_migration;
+		} else
+			unlock = putback_lru_page(page);
 	}
 
-move_newpage:
+	if (unlock)
+		unlock_page(page);
+
+end_migration:
 	if (!charge)
 		mem_cgroup_end_migration(newpage);
-	/*
-	 * Move the new page to the LRU. If migration was not successful
-	 * then this will free the page.
-	 */
-	move_to_lru(newpage);
+
+	if (!newpage->mapping) {
+		/*
+		 * Migration failed or was never attempted.
+		 * Free the newpage.
+		 */
+		VM_BUG_ON(page_count(newpage) != 1);
+		put_page(newpage);
+	}
 	if (result) {
 		if (rc)
 			*result = rc;
diff -puN mm/page_alloc.c~vmscan-noreclaim-lru-infrastructure mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-noreclaim-lru-infrastructure
+++ a/mm/page_alloc.c
@@ -241,6 +241,9 @@ static void bad_page(struct page *page)
 			1 << PG_private |
 			1 << PG_locked	|
 			1 << PG_active	|
+#ifdef CONFIG_NORECLAIM_LRU
+			1 << PG_noreclaim	|
+#endif
 			1 << PG_dirty	|
 			1 << PG_reclaim |
 			1 << PG_slab    |
@@ -474,6 +477,9 @@ static inline int free_pages_check(struc
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+#ifdef CONFIG_NORECLAIM_LRU
+			1 << PG_noreclaim |
+#endif
 			1 << PG_buddy ))))
 		bad_page(page);
 	if (PageDirty(page))
@@ -625,6 +631,9 @@ static int prep_new_page(struct page *pa
 			1 << PG_private	|
 			1 << PG_locked	|
 			1 << PG_active	|
+#ifdef CONFIG_NORECLAIM_LRU
+			1 << PG_noreclaim	|
+#endif
 			1 << PG_dirty	|
 			1 << PG_slab    |
 			1 << PG_swapcache |
diff -puN mm/swap.c~vmscan-noreclaim-lru-infrastructure mm/swap.c
--- a/mm/swap.c~vmscan-noreclaim-lru-infrastructure
+++ a/mm/swap.c
@@ -106,9 +106,13 @@ enum lru_list page_lru(struct page *page
 {
 	enum lru_list lru = LRU_BASE;
 
-	if (PageActive(page))
-		lru += LRU_ACTIVE;
-	lru += page_file_cache(page);
+	if (PageNoreclaim(page))
+		lru = LRU_NORECLAIM;
+	else {
+		if (PageActive(page))
+			lru += LRU_ACTIVE;
+		lru += page_file_cache(page);
+	}
 
 	return lru;
 }
@@ -133,7 +137,8 @@ static void pagevec_move_tail(struct pag
 			zone = pagezone;
 			spin_lock(&zone->lru_lock);
 		}
-		if (PageLRU(page) && !PageActive(page)) {
+		if (PageLRU(page) && !PageActive(page) &&
+					!PageNoreclaim(page)) {
 			int lru = page_file_cache(page);
 			list_move_tail(&page->lru, &zone->list[lru]);
 			pgmoved++;
@@ -154,7 +159,7 @@ static void pagevec_move_tail(struct pag
 void  rotate_reclaimable_page(struct page *page)
 {
 	if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
-	    PageLRU(page)) {
+	    !PageNoreclaim(page) && PageLRU(page)) {
 		struct pagevec *pvec;
 		unsigned long flags;
 
@@ -175,7 +180,7 @@ void activate_page(struct page *page)
 	struct zone *zone = page_zone(page);
 
 	spin_lock_irq(&zone->lru_lock);
-	if (PageLRU(page) && !PageActive(page)) {
+	if (PageLRU(page) && !PageActive(page) && !PageNoreclaim(page)) {
 		int file = page_file_cache(page);
 		int lru = LRU_BASE + file;
 		del_page_from_lru_list(zone, page, lru);
@@ -184,7 +189,7 @@ void activate_page(struct page *page)
 		lru += LRU_ACTIVE;
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
-		mem_cgroup_move_lists(page, true);
+		mem_cgroup_move_lists(page, lru);
 
 		if (file) {
 			zone->recent_scanned_file++;
@@ -207,7 +212,8 @@ void activate_page(struct page *page)
  */
 void mark_page_accessed(struct page *page)
 {
-	if (!PageActive(page) && PageReferenced(page) && PageLRU(page)) {
+	if (!PageActive(page) && !PageNoreclaim(page) &&
+			PageReferenced(page) && PageLRU(page)) {
 		activate_page(page);
 		ClearPageReferenced(page);
 	} else if (!PageReferenced(page)) {
@@ -235,13 +241,38 @@ void __lru_cache_add(struct page *page, 
 void lru_cache_add_lru(struct page *page, enum lru_list lru)
 {
 	if (PageActive(page)) {
+		VM_BUG_ON(PageNoreclaim(page));
 		ClearPageActive(page);
+	} else if (PageNoreclaim(page)) {
+		VM_BUG_ON(PageActive(page));
+		ClearPageNoreclaim(page);
 	}
 
-	VM_BUG_ON(PageLRU(page) || PageActive(page));
+	VM_BUG_ON(PageLRU(page) || PageActive(page) || PageNoreclaim(page));
 	__lru_cache_add(page, lru);
 }
 
+/**
+ * add_page_to_noreclaim_list
+ * @page:  the page to be added to the noreclaim list
+ *
+ * Add page directly to its zone's noreclaim list.  To avoid races with
+ * tasks that might be making the page reclaimble while it's not on the
+ * lru, we want to add the page while it's locked or otherwise "invisible"
+ * to other tasks.  This is difficult to do when using the pagevec cache,
+ * so bypass that.
+ */
+void add_page_to_noreclaim_list(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+
+	spin_lock_irq(&zone->lru_lock);
+	SetPageNoreclaim(page);
+	SetPageLRU(page);
+	add_page_to_lru_list(zone, page, LRU_NORECLAIM);
+	spin_unlock_irq(&zone->lru_lock);
+}
+
 /*
  * Drain pages out of the cpu's pagevecs.
  * Either "cpu" is the current CPU, and preemption has already been
@@ -339,6 +370,7 @@ void release_pages(struct page **pages, 
 
 		if (PageLRU(page)) {
 			struct zone *pagezone = page_zone(page);
+
 			if (pagezone != zone) {
 				if (zone)
 					spin_unlock_irqrestore(&zone->lru_lock,
@@ -415,6 +447,7 @@ void ____pagevec_lru_add(struct pagevec 
 {
 	int i;
 	struct zone *zone = NULL;
+	VM_BUG_ON(is_noreclaim_lru(lru));
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
@@ -426,6 +459,7 @@ void ____pagevec_lru_add(struct pagevec 
 			zone = pagezone;
 			spin_lock_irq(&zone->lru_lock);
 		}
+		VM_BUG_ON(PageActive(page) || PageNoreclaim(page));
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 		if (is_active_lru(lru))
diff -puN mm/vmscan.c~vmscan-noreclaim-lru-infrastructure mm/vmscan.c
--- a/mm/vmscan.c~vmscan-noreclaim-lru-infrastructure
+++ a/mm/vmscan.c
@@ -447,6 +447,73 @@ int remove_mapping(struct address_space 
 	return 0;
 }
 
+/**
+ * putback_lru_page
+ * @page to be put back to appropriate lru list
+ *
+ * Add previously isolated @page to appropriate LRU list.
+ * Page may still be non-reclaimable for other reasons.
+ *
+ * lru_lock must not be held, interrupts must be enabled.
+ * Must be called with page locked.
+ *
+ * return 1 if page still locked [not truncated], else 0
+ */
+int putback_lru_page(struct page *page)
+{
+	int lru;
+	int ret = 1;
+
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(PageLRU(page));
+
+	lru = !!TestClearPageActive(page);
+	ClearPageNoreclaim(page);	/* for page_reclaimable() */
+
+	if (unlikely(!page->mapping)) {
+		/*
+		 * page truncated.  drop lock as put_page() will
+		 * free the page.
+		 */
+		VM_BUG_ON(page_count(page) != 1);
+		unlock_page(page);
+		ret = 0;
+	} else if (page_reclaimable(page, NULL)) {
+		/*
+		 * For reclaimable pages, we can use the cache.
+		 * In event of a race, worst case is we end up with a
+		 * non-reclaimable page on [in]active list.
+		 * We know how to handle that.
+		 */
+		lru += page_file_cache(page);
+		lru_cache_add_lru(page, lru);
+		mem_cgroup_move_lists(page, lru);
+	} else {
+		/*
+		 * Put non-reclaimable pages directly on zone's noreclaim
+		 * list.
+		 */
+		add_page_to_noreclaim_list(page);
+		mem_cgroup_move_lists(page, LRU_NORECLAIM);
+	}
+
+	put_page(page);		/* drop ref from isolate */
+	return ret;		/* ret => "page still locked" */
+}
+
+/*
+ * Cull page that shrink_*_list() has detected to be non-reclaimable
+ * under page lock to close races with other tasks that might be making
+ * the page reclaimable.  Avoid stranding a reclaimable page on the
+ * noreclaim list.
+ */
+static inline void cull_nonreclaimable_page(struct page *page)
+{
+	lock_page(page);
+	if (putback_lru_page(page))
+		unlock_page(page);
+}
+
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -480,6 +547,12 @@ static unsigned long shrink_page_list(st
 
 		sc->nr_scanned++;
 
+		if (unlikely(!page_reclaimable(page, NULL))) {
+			if (putback_lru_page(page))
+				unlock_page(page);
+			continue;
+		}
+
 		if (!sc->may_swap && page_mapped(page))
 			goto keep_locked;
 
@@ -576,7 +649,7 @@ static unsigned long shrink_page_list(st
 		 * possible for a page to have PageDirty set, but it is actually
 		 * clean (all its buffers are clean).  This happens if the
 		 * buffers were written out directly, with submit_bh(). ext3
-		 * will do this, as well as the blockdev mapping. 
+		 * will do this, as well as the blockdev mapping.
 		 * try_to_release_page() will discover that cleanness and will
 		 * drop the buffers and mark the page clean - it can be freed.
 		 *
@@ -624,6 +697,7 @@ activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (PageSwapCache(page) && vm_swap_full())
 			remove_exclusive_swap_page_ref(page);
+		VM_BUG_ON(PageActive(page));
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
@@ -673,6 +747,14 @@ int __isolate_lru_page(struct page *page
 	if (mode != ISOLATE_BOTH && (!page_file_cache(page) != !file))
 		return ret;
 
+	/*
+	 * Non-reclaimable pages shouldn't make it onto either the active
+	 * nor the inactive list. However, when doing lumpy reclaim of
+	 * higher order pages we can still run into them.
+	 */
+	if (PageNoreclaim(page))
+		return ret;
+
 	ret = -EBUSY;
 	if (likely(get_page_unless_zero(page))) {
 		/*
@@ -784,7 +866,7 @@ static unsigned long isolate_lru_pages(u
 				/* else it is being freed elsewhere */
 				list_move(&cursor_page->lru, src);
 			default:
-				break;
+				break;	/* ! on LRU or wrong list */
 			}
 		}
 	}
@@ -844,8 +926,9 @@ static unsigned long clear_active_flags(
  * Returns -EBUSY if the page was not on an LRU list.
  *
  * The returned page will have PageLRU() cleared.  If it was found on
- * the active list, it will have PageActive set.  That flag may need
- * to be cleared by the caller before letting the page go.
+ * the active list, it will have PageActive set.  If it was found on
+ * the noreclaim list, it will have the PageNoreclaim bit set. That flag
+ * may need to be cleared by the caller before letting the page go.
  *
  * The vmstat statistic corresponding to the list on which the page was
  * found will be decremented.
@@ -870,7 +953,13 @@ int isolate_lru_page(struct page *page)
 			ret = 0;
 			ClearPageLRU(page);
 
+			/* Calculate the LRU list for normal pages ... */
 			lru += page_file_cache(page) + !!PageActive(page);
+
+			/* ... except NoReclaim, which has its own list. */
+			if (PageNoreclaim(page))
+				lru = LRU_NORECLAIM;
+
 			del_page_from_lru_list(zone, page, lru);
 		}
 		spin_unlock_irq(&zone->lru_lock);
@@ -985,19 +1074,27 @@ static unsigned long shrink_inactive_lis
 			int lru = LRU_BASE;
 			page = lru_to_page(&page_list);
 			VM_BUG_ON(PageLRU(page));
-			SetPageLRU(page);
 			list_del(&page->lru);
-			if (page_file_cache(page))
-				lru += LRU_FILE;
-			if (scan_global_lru(sc)) {
+			if (unlikely(!page_reclaimable(page, NULL))) {
+				spin_unlock_irq(&zone->lru_lock);
+				cull_nonreclaimable_page(page);
+				spin_lock_irq(&zone->lru_lock);
+				continue;
+			} else {
 				if (page_file_cache(page))
-					zone->recent_rotated_file++;
-				else
-					zone->recent_rotated_anon++;
+					lru += LRU_FILE;
+				if (scan_global_lru(sc)) {
+					if (page_file_cache(page))
+						zone->recent_rotated_file++;
+					else
+						zone->recent_rotated_anon++;
+				}
+				if (PageActive(page))
+					lru += LRU_ACTIVE;
 			}
-			if (PageActive(page))
-				lru += LRU_ACTIVE;
+			SetPageLRU(page);
 			add_page_to_lru_list(zone, page, lru);
+			mem_cgroup_move_lists(page, lru);
 			if (!pagevec_add(&pvec, page)) {
 				spin_unlock_irq(&zone->lru_lock);
 				__pagevec_release(&pvec);
@@ -1091,6 +1188,12 @@ static void shrink_active_list(unsigned 
 		cond_resched();
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
+
+		if (unlikely(!page_reclaimable(page, NULL))) {
+			cull_nonreclaimable_page(page);
+			continue;
+		}
+
 		if (page_referenced(page, 0, sc->mem_cgroup)) {
 			if (file) {
 				/* Referenced file pages stay active. */
@@ -1133,7 +1236,7 @@ static void shrink_active_list(unsigned 
 		ClearPageActive(page);
 
 		list_move(&page->lru, &zone->list[lru]);
-		mem_cgroup_move_lists(page, false);
+		mem_cgroup_move_lists(page, lru);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_INACTIVE_ANON + lru,
@@ -1165,7 +1268,7 @@ static void shrink_active_list(unsigned 
 		VM_BUG_ON(!PageActive(page));
 
 		list_move(&page->lru, &zone->list[lru]);
-		mem_cgroup_move_lists(page, true);
+		mem_cgroup_move_lists(page, lru);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_INACTIVE_ANON + lru,
@@ -1303,7 +1406,7 @@ static unsigned long shrink_zone(int pri
 
 	get_scan_ratio(zone, sc, percent);
 
-	for_each_lru(l) {
+	for_each_reclaimable_lru(l) {
 		if (scan_global_lru(sc)) {
 			int file = is_file_lru(l);
 			int scan;
@@ -1334,7 +1437,7 @@ static unsigned long shrink_zone(int pri
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
-		for_each_lru(l) {
+		for_each_reclaimable_lru(l) {
 			if (nr[l]) {
 				nr_to_scan = min(nr[l],
 					(unsigned long)sc->swap_cluster_max);
@@ -1889,8 +1992,8 @@ static unsigned long shrink_all_zones(un
 		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
 			continue;
 
-		for_each_lru(l) {
-			/* For pass = 0 we don't shrink the active list */
+		for_each_reclaimable_lru(l) {
+			/* For pass = 0, we don't shrink the active list */
 			if (pass == 0 &&
 				(l == LRU_ACTIVE_ANON || l == LRU_ACTIVE_FILE))
 				continue;
@@ -2227,3 +2330,26 @@ int zone_reclaim(struct zone *zone, gfp_
 	return ret;
 }
 #endif
+
+#ifdef CONFIG_NORECLAIM_LRU
+/*
+ * page_reclaimable - test whether a page is reclaimable
+ * @page: the page to test
+ * @vma: the VMA in which the page is or will be mapped, may be NULL
+ *
+ * Test whether page is reclaimable--i.e., should be placed on active/inactive
+ * lists vs noreclaim list.
+ *
+ * Reasons page might not be reclaimable:
+ * TODO - later patches
+ */
+int page_reclaimable(struct page *page, struct vm_area_struct *vma)
+{
+
+	VM_BUG_ON(PageNoreclaim(page));
+
+	/* TODO:  test page [!]reclaimable conditions */
+
+	return 1;
+}
+#endif
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch


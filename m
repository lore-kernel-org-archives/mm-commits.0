From: akpm@linux-foundation.org
Subject: + mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
 added to -mm tree
Date: Tue, 02 Feb 2016 14:42:17 -0800
Message-ID: <56b130c9.N4Euldm3WfwoXU1S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbcBBWmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:42:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: do not touch page->mem_cgroup of live pages
has been added to the -mm tree.  Its filename is
     mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: migrate: do not touch page->mem_cgroup of live pages

Changing a page's memcg association complicates dealing with the page, so
we want to limit this as much as possible.  Page migration e.g.  does not
have to do that.  Just like page cache replacement, it can forcibly charge
a replacement page, and then uncharge the old page when it gets freed. 
Temporarily overcharging the cgroup by a single page is not an issue in
practice, and charging is so cheap nowadays that this is much preferrable
to the headache of messing with live pages.

The only place that still changes the page->mem_cgroup binding of live
pages is when pages move along with a task to another cgroup.  But that
path isolates the page from the LRU, takes the page lock, and the move
lock (lock_page_memcg()).  That means page->mem_cgroup is always stable in
callers that have the page isolated from the LRU or locked.  Lighter
unlocked paths, like writeback accounting, can use lock_page_memcg().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 include/linux/mm.h         |    9 ---------
 mm/filemap.c               |    2 +-
 mm/memcontrol.c            |   13 +++++++------
 mm/migrate.c               |   14 ++++++++------
 mm/shmem.c                 |    2 +-
 6 files changed, 19 insertions(+), 25 deletions(-)

diff -puN include/linux/memcontrol.h~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages
+++ a/include/linux/memcontrol.h
@@ -300,7 +300,7 @@ void mem_cgroup_cancel_charge(struct pag
 void mem_cgroup_uncharge(struct page *page);
 void mem_cgroup_uncharge_list(struct list_head *page_list);
 
-void mem_cgroup_replace_page(struct page *oldpage, struct page *newpage);
+void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
 
 struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct zone *);
@@ -580,7 +580,7 @@ static inline void mem_cgroup_uncharge_l
 {
 }
 
-static inline void mem_cgroup_replace_page(struct page *old, struct page *new)
+static inline void mem_cgroup_migrate(struct page *old, struct page *new)
 {
 }
 
diff -puN include/linux/mm.h~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages
+++ a/include/linux/mm.h
@@ -904,20 +904,11 @@ static inline struct mem_cgroup *page_me
 {
 	return page->mem_cgroup;
 }
-
-static inline void set_page_memcg(struct page *page, struct mem_cgroup *memcg)
-{
-	page->mem_cgroup = memcg;
-}
 #else
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
 	return NULL;
 }
-
-static inline void set_page_memcg(struct page *page, struct mem_cgroup *memcg)
-{
-}
 #endif
 
 /*
diff -puN mm/filemap.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages mm/filemap.c
--- a/mm/filemap.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages
+++ a/mm/filemap.c
@@ -558,7 +558,7 @@ int replace_page_cache_page(struct page
 			__inc_zone_page_state(new, NR_SHMEM);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 		unlock_page_memcg(memcg);
-		mem_cgroup_replace_page(old, new);
+		mem_cgroup_migrate(old, new);
 		radix_tree_preload_end();
 		if (freepage)
 			freepage(old);
diff -puN mm/memcontrol.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages mm/memcontrol.c
--- a/mm/memcontrol.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages
+++ a/mm/memcontrol.c
@@ -4457,7 +4457,7 @@ static int mem_cgroup_move_account(struc
 	VM_BUG_ON(compound && !PageTransHuge(page));
 
 	/*
-	 * Prevent mem_cgroup_replace_page() from looking at
+	 * Prevent mem_cgroup_migrate() from looking at
 	 * page->mem_cgroup of its source page while we change it.
 	 */
 	ret = -EBUSY;
@@ -5486,16 +5486,17 @@ void mem_cgroup_uncharge_list(struct lis
 }
 
 /**
- * mem_cgroup_replace_page - migrate a charge to another page
- * @oldpage: currently charged page
- * @newpage: page to transfer the charge to
+ * mem_cgroup_migrate - charge a page's replacement
+ * @oldpage: currently circulating page
+ * @newpage: replacement page
  *
- * Migrate the charge from @oldpage to @newpage.
+ * Charge @newpage as a replacement page for @oldpage. @oldpage will
+ * be uncharged upon free.
  *
  * Both pages must be locked, @newpage->mapping must be set up.
  * Either or both pages might be on the LRU already.
  */
-void mem_cgroup_replace_page(struct page *oldpage, struct page *newpage)
+void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 {
 	struct mem_cgroup *memcg;
 	unsigned int nr_pages;
diff -puN mm/migrate.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages mm/migrate.c
--- a/mm/migrate.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages
+++ a/mm/migrate.c
@@ -326,12 +326,13 @@ int migrate_page_move_mapping(struct add
 			return -EAGAIN;
 
 		/* No turning back from here */
-		set_page_memcg(newpage, page_memcg(page));
 		newpage->index = page->index;
 		newpage->mapping = page->mapping;
 		if (PageSwapBacked(page))
 			SetPageSwapBacked(newpage);
 
+		mem_cgroup_migrate(page, newpage);
+
 		return MIGRATEPAGE_SUCCESS;
 	}
 
@@ -373,12 +374,13 @@ int migrate_page_move_mapping(struct add
 	 * Now we know that no one else is looking at the page:
 	 * no turning back from here.
 	 */
-	set_page_memcg(newpage, page_memcg(page));
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
 	if (PageSwapBacked(page))
 		SetPageSwapBacked(newpage);
 
+	mem_cgroup_migrate(page, newpage);
+
 	get_page(newpage);	/* add cache reference */
 	if (PageSwapCache(page)) {
 		SetPageSwapCache(newpage);
@@ -458,9 +460,11 @@ int migrate_huge_page_move_mapping(struc
 		return -EAGAIN;
 	}
 
-	set_page_memcg(newpage, page_memcg(page));
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
+
+	mem_cgroup_migrate(page, newpage);
+
 	get_page(newpage);
 
 	radix_tree_replace_slot(pslot, newpage);
@@ -775,7 +779,6 @@ static int move_to_new_page(struct page
 	 * page is freed; but stats require that PageAnon be left as PageAnon.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		set_page_memcg(page, NULL);
 		if (!PageAnon(page))
 			page->mapping = NULL;
 	}
@@ -1842,8 +1845,7 @@ fail_putback:
 	}
 
 	mlock_migrate_page(new_page, page);
-	set_page_memcg(new_page, page_memcg(page));
-	set_page_memcg(page, NULL);
+	mem_cgroup_migrate(page, newpage);
 	page_remove_rmap(page, true);
 	set_page_owner_migrate_reason(new_page, MR_NUMA_MISPLACED);
 
diff -puN mm/shmem.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages mm/shmem.c
--- a/mm/shmem.c~mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages
+++ a/mm/shmem.c
@@ -1116,7 +1116,7 @@ static int shmem_replace_page(struct pag
 		 */
 		oldpage = newpage;
 	} else {
-		mem_cgroup_replace_page(oldpage, newpage);
+		mem_cgroup_migrate(oldpage, newpage);
 		lru_cache_add_anon(newpage);
 		*pagep = newpage;
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
documentation-cgroup-v2-add-memorystat-sock-description.patch
mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
mm-simplify-lock_page_memcg.patch
mm-remove-unnecessary-uses-of-lock_page_memcg.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch


From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch removed from
 -mm tree
Date: Wed, 16 Mar 2016 12:56:52 -0700
Message-ID: <56e9ba84.U/kJ3zcIn/hvQK9F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935107AbcCPT4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gthelen@google.com, hughd@google.com, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: do not touch page->mem_cgroup of live pages
has been removed from the -mm tree.  Its filename was
     mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix build]
[vdavydov@virtuozzo.com: fix lockdep splat]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 include/linux/mm.h         |    9 ---------
 mm/filemap.c               |    2 +-
 mm/memcontrol.c            |   13 +++++++------
 mm/migrate.c               |   15 +++++++++------
 mm/shmem.c                 |    2 +-
 6 files changed, 20 insertions(+), 25 deletions(-)

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
@@ -905,20 +905,11 @@ static inline struct mem_cgroup *page_me
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
@@ -577,7 +577,7 @@ int replace_page_cache_page(struct page
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
 
@@ -373,7 +374,6 @@ int migrate_page_move_mapping(struct add
 	 * Now we know that no one else is looking at the page:
 	 * no turning back from here.
 	 */
-	set_page_memcg(newpage, page_memcg(page));
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
 	if (PageSwapBacked(page))
@@ -428,6 +428,8 @@ int migrate_page_move_mapping(struct add
 	}
 	local_irq_enable();
 
+	mem_cgroup_migrate(page, newpage);
+
 	return MIGRATEPAGE_SUCCESS;
 }
 
@@ -458,9 +460,9 @@ int migrate_huge_page_move_mapping(struc
 		return -EAGAIN;
 	}
 
-	set_page_memcg(newpage, page_memcg(page));
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
+
 	get_page(newpage);
 
 	radix_tree_replace_slot(pslot, newpage);
@@ -468,6 +470,9 @@ int migrate_huge_page_move_mapping(struc
 	page_unfreeze_refs(page, expected_count - 1);
 
 	spin_unlock_irq(&mapping->tree_lock);
+
+	mem_cgroup_migrate(page, newpage);
+
 	return MIGRATEPAGE_SUCCESS;
 }
 
@@ -775,7 +780,6 @@ static int move_to_new_page(struct page
 	 * page is freed; but stats require that PageAnon be left as PageAnon.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		set_page_memcg(page, NULL);
 		if (!PageAnon(page))
 			page->mapping = NULL;
 	}
@@ -1842,8 +1846,7 @@ fail_putback:
 	}
 
 	mlock_migrate_page(new_page, page);
-	set_page_memcg(new_page, page_memcg(page));
-	set_page_memcg(page, NULL);
+	mem_cgroup_migrate(page, new_page);
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

mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch


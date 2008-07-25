From: akpm@linux-foundation.org
Subject: - memcg-better-migration-handling.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:40 -0700
Message-ID: <200807252258.m6PMweIM003308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYGYW7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, cl@linux-foundation.org, hugh@veritas.com, lizf@cn.fujitsu.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: better migration handling
has been removed from the -mm tree.  Its filename was
     memcg-better-migration-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: better migration handling
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch changes page migration under memory controller to use a
different algorithm.  (thanks to Christoph for new idea.)

Before:
 - page_cgroup is migrated from an old page to a new page.
After:
 - a new page is accounted , no reuse of page_cgroup.

Pros:

 - We can avoid compliated lock depndencies and races in migration.

Cons:

 - new param to mem_cgroup_charge_common().

 - mem_cgroup_getref() is added for handling ref_cnt ping-pong.

This version simplifies complicated lock dependency in page migraiton
under memory resource controller.

  new refcnt sequence is following.

a mapped page:
  prepage_migration() ..... +1 to NEW page
  try_to_unmap()      ..... all refs to OLD page is gone.
  move_pages()        ..... +1 to NEW page if page cache.
  remap...            ..... all refs from *map* is added to NEW one.
  end_migration()     ..... -1 to New page.

  page's mapcount + (page_is_cache) refs are added to NEW one.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 +--
 mm/memcontrol.c            |  128 +++++++++++++++++------------------
 mm/migrate.c               |   22 ++++--
 3 files changed, 86 insertions(+), 75 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-better-migration-handling include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-better-migration-handling
+++ a/include/linux/memcontrol.h
@@ -50,9 +50,10 @@ extern struct mem_cgroup *mem_cgroup_fro
 #define mm_match_cgroup(mm, cgroup)	\
 	((cgroup) == mem_cgroup_from_task((mm)->owner))
 
-extern int mem_cgroup_prepare_migration(struct page *page);
+extern int
+mem_cgroup_prepare_migration(struct page *page, struct page *newpage);
 extern void mem_cgroup_end_migration(struct page *page);
-extern void mem_cgroup_page_migration(struct page *page, struct page *newpage);
+extern int mem_cgroup_getref(struct page *page);
 
 /*
  * For memory reclaim.
@@ -112,7 +113,8 @@ static inline int task_in_mem_cgroup(str
 	return 1;
 }
 
-static inline int mem_cgroup_prepare_migration(struct page *page)
+static inline int
+mem_cgroup_prepare_migration(struct page *page, struct page *newpage)
 {
 	return 0;
 }
@@ -121,8 +123,7 @@ static inline void mem_cgroup_end_migrat
 {
 }
 
-static inline void
-mem_cgroup_page_migration(struct page *page, struct page *newpage)
+static inline void mem_cgroup_getref(struct page *page)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-better-migration-handling mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-better-migration-handling
+++ a/mm/memcontrol.c
@@ -524,7 +524,8 @@ unsigned long mem_cgroup_isolate_pages(u
  * < 0 if the cgroup is over its limit
  */
 static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask, enum charge_type ctype)
+				gfp_t gfp_mask, enum charge_type ctype,
+				struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *mem;
 	struct page_cgroup *pc;
@@ -569,16 +570,21 @@ retry:
 	 * thread group leader migrates. It's possible that mm is not
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
-	if (!mm)
-		mm = &init_mm;
+	if (!memcg) {
+		if (!mm)
+			mm = &init_mm;
 
-	rcu_read_lock();
-	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	/*
-	 * For every charge from the cgroup, increment reference count
-	 */
-	css_get(&mem->css);
-	rcu_read_unlock();
+		rcu_read_lock();
+		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+		/*
+		 * For every charge from the cgroup, increment reference count
+		 */
+		css_get(&mem->css);
+		rcu_read_unlock();
+	} else {
+		mem = memcg;
+		css_get(&memcg->css);
+	}
 
 	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
 		if (!(gfp_mask & __GFP_WAIT))
@@ -648,7 +654,7 @@ err:
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_MAPPED);
+				MEM_CGROUP_CHARGE_TYPE_MAPPED, NULL);
 }
 
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
@@ -657,7 +663,22 @@ int mem_cgroup_cache_charge(struct page 
 	if (!mm)
 		mm = &init_mm;
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_CACHE);
+				MEM_CGROUP_CHARGE_TYPE_CACHE, NULL);
+}
+
+int mem_cgroup_getref(struct page *page)
+{
+	struct page_cgroup *pc;
+
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
+	lock_page_cgroup(page);
+	pc = page_get_page_cgroup(page);
+	VM_BUG_ON(!pc);
+	pc->ref_cnt++;
+	unlock_page_cgroup(page);
+	return 0;
 }
 
 /*
@@ -707,65 +728,39 @@ unlock:
 }
 
 /*
- * Returns non-zero if a page (under migration) has valid page_cgroup member.
- * Refcnt of page_cgroup is incremented.
+ * Before starting migration, account against new page.
  */
-int mem_cgroup_prepare_migration(struct page *page)
+int mem_cgroup_prepare_migration(struct page *page, struct page *newpage)
 {
 	struct page_cgroup *pc;
+	struct mem_cgroup *mem = NULL;
+	enum charge_type ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
+	int ret = 0;
 
 	if (mem_cgroup_subsys.disabled)
 		return 0;
 
 	lock_page_cgroup(page);
 	pc = page_get_page_cgroup(page);
-	if (pc)
-		pc->ref_cnt++;
+	if (pc) {
+		mem = pc->mem_cgroup;
+		css_get(&mem->css);
+		if (pc->flags & PAGE_CGROUP_FLAG_CACHE)
+			ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
+	}
 	unlock_page_cgroup(page);
-	return pc != NULL;
-}
-
-void mem_cgroup_end_migration(struct page *page)
-{
-	mem_cgroup_uncharge_page(page);
+	if (mem) {
+		ret = mem_cgroup_charge_common(newpage, NULL, GFP_KERNEL,
+			ctype, mem);
+		css_put(&mem->css);
+	}
+	return ret;
 }
 
-/*
- * We know both *page* and *newpage* are now not-on-LRU and PG_locked.
- * And no race with uncharge() routines because page_cgroup for *page*
- * has extra one reference by mem_cgroup_prepare_migration.
- */
-void mem_cgroup_page_migration(struct page *page, struct page *newpage)
+/* remove redundant charge */
+void mem_cgroup_end_migration(struct page *newpage)
 {
-	struct page_cgroup *pc;
-	struct mem_cgroup_per_zone *mz;
-	unsigned long flags;
-
-	lock_page_cgroup(page);
-	pc = page_get_page_cgroup(page);
-	if (!pc) {
-		unlock_page_cgroup(page);
-		return;
-	}
-
-	mz = page_cgroup_zoneinfo(pc);
-	spin_lock_irqsave(&mz->lru_lock, flags);
-	__mem_cgroup_remove_list(mz, pc);
-	spin_unlock_irqrestore(&mz->lru_lock, flags);
-
-	page_assign_page_cgroup(page, NULL);
-	unlock_page_cgroup(page);
-
-	pc->page = newpage;
-	lock_page_cgroup(newpage);
-	page_assign_page_cgroup(newpage, pc);
-
-	mz = page_cgroup_zoneinfo(pc);
-	spin_lock_irqsave(&mz->lru_lock, flags);
-	__mem_cgroup_add_list(mz, pc);
-	spin_unlock_irqrestore(&mz->lru_lock, flags);
-
-	unlock_page_cgroup(newpage);
+	mem_cgroup_uncharge_page(newpage);
 }
 
 /*
@@ -795,12 +790,19 @@ static void mem_cgroup_force_empty_list(
 		page = pc->page;
 		get_page(page);
 		spin_unlock_irqrestore(&mz->lru_lock, flags);
-		mem_cgroup_uncharge_page(page);
-		put_page(page);
-		if (--count <= 0) {
-			count = FORCE_UNCHARGE_BATCH;
+		/*
+		 * Check if this page is on LRU. !LRU page can be found
+		 * if it's under page migration.
+		 */
+		if (PageLRU(page)) {
+			mem_cgroup_uncharge_page(page);
+			put_page(page);
+			if (--count <= 0) {
+				count = FORCE_UNCHARGE_BATCH;
+				cond_resched();
+			}
+		} else
 			cond_resched();
-		}
 		spin_lock_irqsave(&mz->lru_lock, flags);
 	}
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
diff -puN mm/migrate.c~memcg-better-migration-handling mm/migrate.c
--- a/mm/migrate.c~memcg-better-migration-handling
+++ a/mm/migrate.c
@@ -358,6 +358,10 @@ static int migrate_page_move_mapping(str
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
 
 	write_unlock_irq(&mapping->tree_lock);
+	if (!PageSwapCache(newpage)) {
+		mem_cgroup_uncharge_page(page);
+		mem_cgroup_getref(newpage);
+	}
 
 	return 0;
 }
@@ -611,7 +615,6 @@ static int move_to_new_page(struct page 
 		rc = fallback_migrate_page(mapping, newpage, page);
 
 	if (!rc) {
-		mem_cgroup_page_migration(page, newpage);
 		remove_migration_ptes(page, newpage);
 	} else
 		newpage->mapping = NULL;
@@ -641,6 +644,14 @@ static int unmap_and_move(new_page_t get
 		/* page was freed from under us. So we are done. */
 		goto move_newpage;
 
+	charge = mem_cgroup_prepare_migration(page, newpage);
+	if (charge == -ENOMEM) {
+		rc = -ENOMEM;
+		goto move_newpage;
+	}
+	/* prepare cgroup just returns 0 or -ENOMEM */
+	BUG_ON(charge);
+
 	rc = -EAGAIN;
 	if (TestSetPageLocked(page)) {
 		if (!force)
@@ -692,19 +703,14 @@ static int unmap_and_move(new_page_t get
 		goto rcu_unlock;
 	}
 
-	charge = mem_cgroup_prepare_migration(page);
 	/* Establish migration ptes or remove ptes */
 	try_to_unmap(page, 1);
 
 	if (!page_mapped(page))
 		rc = move_to_new_page(newpage, page);
 
-	if (rc) {
+	if (rc)
 		remove_migration_ptes(page, page);
-		if (charge)
-			mem_cgroup_end_migration(page);
-	} else if (charge)
- 		mem_cgroup_end_migration(newpage);
 rcu_unlock:
 	if (rcu_locked)
 		rcu_read_unlock();
@@ -725,6 +731,8 @@ unlock:
 	}
 
 move_newpage:
+	if (!charge)
+		mem_cgroup_end_migration(newpage);
 	/*
 	 * Move the new page to the LRU. If migration was not successful
 	 * then this will free the page.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch


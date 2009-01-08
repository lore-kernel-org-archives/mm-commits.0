From: akpm@linux-foundation.org
Subject: - memcg-simple-migration-handling.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:04 -0800
Message-ID: <200901082248.n08Mm4In027448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761262AbZAHWsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: simple migration handling
has been removed from the -mm tree.  Its filename was
     memcg-simple-migration-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: simple migration handling
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, management of "charge" under page migration is done under following
manner. (Assume migrate page contents from oldpage to newpage)

 before
  - "newpage" is charged before migration.
 at success.
  - "oldpage" is uncharged at somewhere(unmap, radix-tree-replace)
 at failure
  - "newpage" is uncharged.
  - "oldpage" is charged if necessary (*1)

But (*1) is not reliable....because of GFP_ATOMIC.

This patch tries to change behavior as following by charge/commit/cancel ops.

 before
  - charge PAGE_SIZE (no target page)
 success
  - commit charge against "newpage".
 failure
  - commit charge against "oldpage".
    (PCG_USED bit works effectively to avoid double-counting)
  - if "oldpage" is obsolete, cancel charge of PAGE_SIZE.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   19 ++----
 mm/memcontrol.c            |  108 ++++++++++++++++-------------------
 mm/migrate.c               |   42 ++++---------
 3 files changed, 73 insertions(+), 96 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-simple-migration-handling include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-simple-migration-handling
+++ a/include/linux/memcontrol.h
@@ -29,8 +29,6 @@ struct mm_struct;
 
 extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
-extern int mem_cgroup_charge_migrate_fixup(struct page *page,
-				struct mm_struct *mm, gfp_t gfp_mask);
 /* for swap handling */
 extern int mem_cgroup_try_charge(struct mm_struct *mm,
 		gfp_t gfp_mask, struct mem_cgroup **ptr);
@@ -60,8 +58,9 @@ extern struct mem_cgroup *mem_cgroup_fro
 	((cgroup) == mem_cgroup_from_task((mm)->owner))
 
 extern int
-mem_cgroup_prepare_migration(struct page *page, struct page *newpage);
-extern void mem_cgroup_end_migration(struct page *page);
+mem_cgroup_prepare_migration(struct page *page, struct mem_cgroup **ptr);
+extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
+	struct page *oldpage, struct page *newpage);
 
 /*
  * For memory reclaim.
@@ -94,12 +93,6 @@ static inline int mem_cgroup_cache_charg
 	return 0;
 }
 
-static inline int mem_cgroup_charge_migrate_fixup(struct page *page,
-					struct mm_struct *mm, gfp_t gfp_mask)
-{
-	return 0;
-}
-
 static inline int mem_cgroup_try_charge(struct mm_struct *mm,
 				gfp_t gfp_mask, struct mem_cgroup **ptr)
 {
@@ -144,12 +137,14 @@ static inline int task_in_mem_cgroup(str
 }
 
 static inline int
-mem_cgroup_prepare_migration(struct page *page, struct page *newpage)
+mem_cgroup_prepare_migration(struct page *page, struct mem_cgroup **ptr)
 {
 	return 0;
 }
 
-static inline void mem_cgroup_end_migration(struct page *page)
+static inline void mem_cgroup_end_migration(struct mem_cgroup *mem,
+					struct page *oldpage,
+					struct page *newpage)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-simple-migration-handling mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simple-migration-handling
+++ a/mm/memcontrol.c
@@ -627,34 +627,6 @@ int mem_cgroup_newpage_charge(struct pag
 				MEM_CGROUP_CHARGE_TYPE_MAPPED, NULL);
 }
 
-/*
- * same as mem_cgroup_newpage_charge(), now.
- * But what we assume is different from newpage, and this is special case.
- * treat this in special function. easy for maintenance.
- */
-
-int mem_cgroup_charge_migrate_fixup(struct page *page,
-				struct mm_struct *mm, gfp_t gfp_mask)
-{
-	if (mem_cgroup_subsys.disabled)
-		return 0;
-
-	if (PageCompound(page))
-		return 0;
-
-	if (page_mapped(page) || (page->mapping && !PageAnon(page)))
-		return 0;
-
-	if (unlikely(!mm))
-		mm = &init_mm;
-
-	return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_MAPPED, NULL);
-}
-
-
-
-
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
@@ -697,7 +669,6 @@ int mem_cgroup_cache_charge(struct page 
 				MEM_CGROUP_CHARGE_TYPE_SHMEM, NULL);
 }
 
-
 void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
 {
 	struct page_cgroup *pc;
@@ -782,13 +753,13 @@ void mem_cgroup_uncharge_cache_page(stru
 }
 
 /*
- * Before starting migration, account against new page.
+ * Before starting migration, account PAGE_SIZE to mem_cgroup that the old
+ * page belongs to.
  */
-int mem_cgroup_prepare_migration(struct page *page, struct page *newpage)
+int mem_cgroup_prepare_migration(struct page *page, struct mem_cgroup **ptr)
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
-	enum charge_type ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
 	int ret = 0;
 
 	if (mem_cgroup_subsys.disabled)
@@ -799,42 +770,67 @@ int mem_cgroup_prepare_migration(struct 
 	if (PageCgroupUsed(pc)) {
 		mem = pc->mem_cgroup;
 		css_get(&mem->css);
-		if (PageCgroupCache(pc)) {
-			if (page_is_file_cache(page))
-				ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
-			else
-				ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-		}
 	}
 	unlock_page_cgroup(pc);
+
 	if (mem) {
-		ret = mem_cgroup_charge_common(newpage, NULL,
-					GFP_HIGHUSER_MOVABLE,
-					ctype, mem);
+		ret = mem_cgroup_try_charge(NULL, GFP_HIGHUSER_MOVABLE, &mem);
 		css_put(&mem->css);
 	}
+	*ptr = mem;
 	return ret;
 }
 
 /* remove redundant charge if migration failed*/
-void mem_cgroup_end_migration(struct page *newpage)
+void mem_cgroup_end_migration(struct mem_cgroup *mem,
+		struct page *oldpage, struct page *newpage)
 {
+	struct page *target, *unused;
+	struct page_cgroup *pc;
+	enum charge_type ctype;
+
+	if (!mem)
+		return;
+
+	/* at migration success, oldpage->mapping is NULL. */
+	if (oldpage->mapping) {
+		target = oldpage;
+		unused = NULL;
+	} else {
+		target = newpage;
+		unused = oldpage;
+	}
+
+	if (PageAnon(target))
+		ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
+	else if (page_is_file_cache(target))
+		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
+	else
+		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
+
+	/* unused page is not on radix-tree now. */
+	if (unused && ctype != MEM_CGROUP_CHARGE_TYPE_MAPPED)
+		__mem_cgroup_uncharge_common(unused, ctype);
+
+	pc = lookup_page_cgroup(target);
 	/*
-	 * At success, page->mapping is not NULL.
-	 * special rollback care is necessary when
-	 * 1. at migration failure. (newpage->mapping is cleared in this case)
-	 * 2. the newpage was moved but not remapped again because the task
-	 *    exits and the newpage is obsolete. In this case, the new page
-	 *    may be a swapcache. So, we just call mem_cgroup_uncharge_page()
-	 *    always for avoiding mess. The  page_cgroup will be removed if
-	 *    unnecessary. File cache pages is still on radix-tree. Don't
-	 *    care it.
+	 * __mem_cgroup_commit_charge() check PCG_USED bit of page_cgroup.
+	 * So, double-counting is effectively avoided.
+	 */
+	__mem_cgroup_commit_charge(mem, pc, ctype);
+
+	/*
+	 * Both of oldpage and newpage are still under lock_page().
+	 * Then, we don't have to care about race in radix-tree.
+	 * But we have to be careful that this page is unmapped or not.
+	 *
+	 * There is a case for !page_mapped(). At the start of
+	 * migration, oldpage was mapped. But now, it's zapped.
+	 * But we know *target* page is not freed/reused under us.
+	 * mem_cgroup_uncharge_page() does all necessary checks.
 	 */
-	if (!newpage->mapping)
-		__mem_cgroup_uncharge_common(newpage,
-				MEM_CGROUP_CHARGE_TYPE_FORCE);
-	else if (PageAnon(newpage))
-		mem_cgroup_uncharge_page(newpage);
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
+		mem_cgroup_uncharge_page(target);
 }
 
 /*
diff -puN mm/migrate.c~memcg-simple-migration-handling mm/migrate.c
--- a/mm/migrate.c~memcg-simple-migration-handling
+++ a/mm/migrate.c
@@ -121,20 +121,6 @@ static void remove_migration_pte(struct 
 	if (!is_migration_entry(entry) || migration_entry_to_page(entry) != old)
 		goto out;
 
-	/*
-	 * Yes, ignore the return value from a GFP_ATOMIC mem_cgroup_charge.
-	 * Failure is not an option here: we're now expected to remove every
-	 * migration pte, and will cause crashes otherwise.  Normally this
-	 * is not an issue: mem_cgroup_prepare_migration bumped up the old
-	 * page_cgroup count for safety, that's now attached to the new page,
-	 * so this charge should just be another incrementation of the count,
-	 * to keep in balance with rmap.c's mem_cgroup_uncharging.  But if
-	 * there's been a force_empty, those reference counts may no longer
-	 * be reliable, and this charge can actually fail: oh well, we don't
-	 * make the situation any worse by proceeding as if it had succeeded.
-	 */
-	mem_cgroup_charge_migrate_fixup(new, mm, GFP_ATOMIC);
-
 	get_page(new);
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
 	if (is_write_migration_entry(entry))
@@ -378,9 +364,6 @@ static void migrate_page_copy(struct pag
 	anon = PageAnon(page);
 	page->mapping = NULL;
 
-	if (!anon) /* This page was removed from radix-tree. */
-		mem_cgroup_uncharge_cache_page(page);
-
 	/*
 	 * If any waiters have accumulated on the new page then
 	 * wake them up.
@@ -614,6 +597,7 @@ static int unmap_and_move(new_page_t get
 	struct page *newpage = get_new_page(page, private, &result);
 	int rcu_locked = 0;
 	int charge = 0;
+	struct mem_cgroup *mem;
 
 	if (!newpage)
 		return -ENOMEM;
@@ -623,24 +607,26 @@ static int unmap_and_move(new_page_t get
 		goto move_newpage;
 	}
 
-	charge = mem_cgroup_prepare_migration(page, newpage);
-	if (charge == -ENOMEM) {
-		rc = -ENOMEM;
-		goto move_newpage;
-	}
 	/* prepare cgroup just returns 0 or -ENOMEM */
-	BUG_ON(charge);
-
 	rc = -EAGAIN;
+
 	if (!trylock_page(page)) {
 		if (!force)
 			goto move_newpage;
 		lock_page(page);
 	}
 
+	/* charge against new page */
+	charge = mem_cgroup_prepare_migration(page, &mem);
+	if (charge == -ENOMEM) {
+		rc = -ENOMEM;
+		goto unlock;
+	}
+	BUG_ON(charge);
+
 	if (PageWriteback(page)) {
 		if (!force)
-			goto unlock;
+			goto uncharge;
 		wait_on_page_writeback(page);
 	}
 	/*
@@ -693,7 +679,9 @@ static int unmap_and_move(new_page_t get
 rcu_unlock:
 	if (rcu_locked)
 		rcu_read_unlock();

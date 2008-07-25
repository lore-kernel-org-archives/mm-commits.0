From: akpm@linux-foundation.org
Subject: - memcg-remove-refcnt-from-page_cgroup.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:45 -0700
Message-ID: <200807252258.m6PMwjCw003311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYGYW7h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, ebiederm@xmission.com, hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@val


The patch titled
     memcg: remove refcnt from page_cgroup
has been removed from the -mm tree.  Its filename was
     memcg-remove-refcnt-from-page_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove refcnt from page_cgroup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

memcg: performance improvements

Patch Description
 1/5 ... remove refcnt fron page_cgroup patch (shmem handling is fixed)
 2/5 ... swapcache handling patch
 3/5 ... add helper function for shmem's memory reclaim patch
 4/5 ... optimize by likely/unlikely ppatch
 5/5 ... remove redundunt check patch (shmem handling is fixed.)

Unix bench result.

== 2.6.26-rc2-mm1 + memory resource controller
Execl Throughput                           2915.4 lps   (29.6 secs, 3 samples)
C Compiler Throughput                      1019.3 lpm   (60.0 secs, 3 samples)
Shell Scripts (1 concurrent)               5796.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)               1097.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               565.3 lpm   (60.0 secs, 3 samples)
File Read 1024 bufsize 2000 maxblocks    1022128.0 KBps  (30.0 secs, 3 samples)
File Write 1024 bufsize 2000 maxblocks   544057.0 KBps  (30.0 secs, 3 samples)
File Copy 1024 bufsize 2000 maxblocks    346481.0 KBps  (30.0 secs, 3 samples)
File Read 256 bufsize 500 maxblocks      319325.0 KBps  (30.0 secs, 3 samples)
File Write 256 bufsize 500 maxblocks     148788.0 KBps  (30.0 secs, 3 samples)
File Copy 256 bufsize 500 maxblocks       99051.0 KBps  (30.0 secs, 3 samples)
File Read 4096 bufsize 8000 maxblocks    2058917.0 KBps  (30.0 secs, 3 samples)
File Write 4096 bufsize 8000 maxblocks   1606109.0 KBps  (30.0 secs, 3 samples)
File Copy 4096 bufsize 8000 maxblocks    854789.0 KBps  (30.0 secs, 3 samples)
Dc: sqrt(2) to 99 decimal places         126145.2 lpm   (30.0 secs, 3 samples)


                     INDEX VALUES
TEST                                        BASELINE     RESULT      INDEX

Execl Throughput                                43.0     2915.4      678.0
File Copy 1024 bufsize 2000 maxblocks         3960.0   346481.0      875.0
File Copy 256 bufsize 500 maxblocks           1655.0    99051.0      598.5
File Copy 4096 bufsize 8000 maxblocks         5800.0   854789.0     1473.8
Shell Scripts (8 concurrent)                     6.0     1097.7     1829.5
                                                                 =========
     FINAL SCORE                                                     991.3

== 2.6.26-rc2-mm1 + this set ==
Execl Throughput                           3012.9 lps   (29.9 secs, 3 samples)
C Compiler Throughput                       981.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (1 concurrent)               5872.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)               1120.3 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               578.0 lpm   (60.0 secs, 3 samples)
File Read 1024 bufsize 2000 maxblocks    1003993.0 KBps  (30.0 secs, 3 samples)
File Write 1024 bufsize 2000 maxblocks   550452.0 KBps  (30.0 secs, 3 samples)
File Copy 1024 bufsize 2000 maxblocks    347159.0 KBps  (30.0 secs, 3 samples)
File Read 256 bufsize 500 maxblocks      314644.0 KBps  (30.0 secs, 3 samples)
File Write 256 bufsize 500 maxblocks     151852.0 KBps  (30.0 secs, 3 samples)
File Copy 256 bufsize 500 maxblocks      101000.0 KBps  (30.0 secs, 3 samples)
File Read 4096 bufsize 8000 maxblocks    2033256.0 KBps  (30.0 secs, 3 samples)
File Write 4096 bufsize 8000 maxblocks   1611814.0 KBps  (30.0 secs, 3 samples)
File Copy 4096 bufsize 8000 maxblocks    847979.0 KBps  (30.0 secs, 3 samples)
Dc: sqrt(2) to 99 decimal places         128148.7 lpm   (30.0 secs, 3 samples)


                     INDEX VALUES
TEST                                        BASELINE     RESULT      INDEX

Execl Throughput                                43.0     3012.9      700.7
File Copy 1024 bufsize 2000 maxblocks         3960.0   347159.0      876.7
File Copy 256 bufsize 500 maxblocks           1655.0   101000.0      610.3
File Copy 4096 bufsize 8000 maxblocks         5800.0   847979.0     1462.0
Shell Scripts (8 concurrent)                     6.0     1120.3     1867.2
                                                                 =========
     FINAL SCORE                                                    1004.6





This patch:

Remove refcnt from page_cgroup().

After this,

 * A page is charged only when !page_mapped() && no page_cgroup is assigned.
	* Anon page is newly mapped.
	* File page is added to mapping->tree.

 * A page is uncharged only when
	* Anon page is fully unmapped.
	* File page is removed from LRU.

There is no change in behavior from user's view.

This patch also removes unnecessary calls in rmap.c which was used only for
refcnt mangement.

[akpm@linux-foundation.org: fix warning]
[hugh@veritas.com: fix shmem_unuse_inode charging]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +--
 mm/filemap.c               |    6 -
 mm/memcontrol.c            |  109 ++++++++++++++++++++---------------
 mm/migrate.c               |    3 
 mm/rmap.c                  |   14 ----
 mm/shmem.c                 |   35 +++++++----
 6 files changed, 97 insertions(+), 80 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-refcnt-from-page_cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-refcnt-from-page_cgroup
+++ a/include/linux/memcontrol.h
@@ -35,6 +35,7 @@ extern int mem_cgroup_charge(struct page
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
 extern void mem_cgroup_uncharge_page(struct page *page);
+extern void mem_cgroup_uncharge_cache_page(struct page *page);
 extern void mem_cgroup_move_lists(struct page *page, bool active);
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
@@ -53,7 +54,6 @@ extern struct mem_cgroup *mem_cgroup_fro
 extern int
 mem_cgroup_prepare_migration(struct page *page, struct page *newpage);
 extern void mem_cgroup_end_migration(struct page *page);
-extern int mem_cgroup_getref(struct page *page);
 
 /*
  * For memory reclaim.
@@ -98,6 +98,10 @@ static inline void mem_cgroup_uncharge_p
 {
 }
 
+static inline void mem_cgroup_uncharge_cache_page(struct page *page)
+{
+}
+
 static inline void mem_cgroup_move_lists(struct page *page, bool active)
 {
 }
@@ -123,10 +127,6 @@ static inline void mem_cgroup_end_migrat
 {
 }
 
-static inline void mem_cgroup_getref(struct page *page)
-{
-}
-
 static inline int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem)
 {
 	return 0;
diff -puN mm/filemap.c~memcg-remove-refcnt-from-page_cgroup mm/filemap.c
--- a/mm/filemap.c~memcg-remove-refcnt-from-page_cgroup
+++ a/mm/filemap.c
@@ -115,7 +115,7 @@ void __remove_from_page_cache(struct pag
 {
 	struct address_space *mapping = page->mapping;
 
-	mem_cgroup_uncharge_page(page);
+	mem_cgroup_uncharge_cache_page(page);
 	radix_tree_delete(&mapping->page_tree, page->index);
 	page->mapping = NULL;
 	mapping->nrpages--;
@@ -474,12 +474,12 @@ int add_to_page_cache(struct page *page,
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 		} else
-			mem_cgroup_uncharge_page(page);
+			mem_cgroup_uncharge_cache_page(page);
 
 		write_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
 	} else
-		mem_cgroup_uncharge_page(page);
+		mem_cgroup_uncharge_cache_page(page);
 out:
 	return error;
 }
diff -puN mm/memcontrol.c~memcg-remove-refcnt-from-page_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-refcnt-from-page_cgroup
+++ a/mm/memcontrol.c
@@ -166,7 +166,6 @@ struct page_cgroup {
 	struct list_head lru;		/* per cgroup LRU list */
 	struct page *page;
 	struct mem_cgroup *mem_cgroup;
-	int ref_cnt;			/* cached, mapped, migrating */
 	int flags;
 };
 #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
@@ -185,6 +184,7 @@ static enum zone_type page_cgroup_zid(st
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
+	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
 };
 
 /*
@@ -552,9 +552,7 @@ retry:
 	 */
 	if (pc) {
 		VM_BUG_ON(pc->page != page);
-		VM_BUG_ON(pc->ref_cnt <= 0);
-
-		pc->ref_cnt++;
+		VM_BUG_ON(!pc->mem_cgroup);
 		unlock_page_cgroup(page);
 		goto done;
 	}
@@ -570,10 +568,7 @@ retry:
 	 * thread group leader migrates. It's possible that mm is not
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
-	if (!memcg) {
-		if (!mm)
-			mm = &init_mm;
-
+	if (likely(!memcg)) {
 		rcu_read_lock();
 		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
 		/*
@@ -609,7 +604,6 @@ retry:
 		}
 	}
 
-	pc->ref_cnt = 1;
 	pc->mem_cgroup = mem;
 	pc->page = page;
 	/*
@@ -653,6 +647,17 @@ err:
 
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
+	/*
+	 * If already mapped, we don't have to account.
+	 * If page cache, page->mapping has address_space.
+	 * But page->mapping may have out-of-use anon_vma pointer,
+	 * detecit it by PageAnon() check. newly-mapped-anon's page->mapping
+	 * is NULL.
+  	 */
+	if (page_mapped(page) || (page->mapping && !PageAnon(page)))
+		return 0;
+	if (unlikely(!mm))
+		mm = &init_mm;
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_MAPPED, NULL);
 }
@@ -660,32 +665,17 @@ int mem_cgroup_charge(struct page *page,
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
-	if (!mm)
+	if (unlikely(!mm))
 		mm = &init_mm;
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_CACHE, NULL);
 }
 
-int mem_cgroup_getref(struct page *page)
-{
-	struct page_cgroup *pc;
-
-	if (mem_cgroup_subsys.disabled)
-		return 0;
-
-	lock_page_cgroup(page);
-	pc = page_get_page_cgroup(page);
-	VM_BUG_ON(!pc);
-	pc->ref_cnt++;
-	unlock_page_cgroup(page);
-	return 0;
-}
-
 /*
- * Uncharging is always a welcome operation, we never complain, simply
- * uncharge.
+ * uncharge if !page_mapped(page)
  */
-void mem_cgroup_uncharge_page(struct page *page)
+static void
+__mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem;
@@ -704,29 +694,41 @@ void mem_cgroup_uncharge_page(struct pag
 		goto unlock;
 
 	VM_BUG_ON(pc->page != page);
-	VM_BUG_ON(pc->ref_cnt <= 0);
 
-	if (--(pc->ref_cnt) == 0) {
-		mz = page_cgroup_zoneinfo(pc);
-		spin_lock_irqsave(&mz->lru_lock, flags);
-		__mem_cgroup_remove_list(mz, pc);
-		spin_unlock_irqrestore(&mz->lru_lock, flags);
+	if ((ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
+	    && ((pc->flags & PAGE_CGROUP_FLAG_CACHE)
+		|| page_mapped(page)))
+		goto unlock;
 
-		page_assign_page_cgroup(page, NULL);
-		unlock_page_cgroup(page);
+	mz = page_cgroup_zoneinfo(pc);
+	spin_lock_irqsave(&mz->lru_lock, flags);
+	__mem_cgroup_remove_list(mz, pc);
+	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
-		mem = pc->mem_cgroup;
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
-		css_put(&mem->css);
+	page_assign_page_cgroup(page, NULL);
+	unlock_page_cgroup(page);
 
-		kmem_cache_free(page_cgroup_cache, pc);
-		return;
-	}
+	mem = pc->mem_cgroup;
+	res_counter_uncharge(&mem->res, PAGE_SIZE);
+	css_put(&mem->css);
 
+	kmem_cache_free(page_cgroup_cache, pc);
+	return;
 unlock:
 	unlock_page_cgroup(page);
 }
 
+void mem_cgroup_uncharge_page(struct page *page)
+{
+	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_MAPPED);
+}
+
+void mem_cgroup_uncharge_cache_page(struct page *page)
+{
+	VM_BUG_ON(page_mapped(page));
+	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
+}
+
 /*
  * Before starting migration, account against new page.
  */
@@ -757,15 +759,29 @@ int mem_cgroup_prepare_migration(struct 
 	return ret;
 }
 
-/* remove redundant charge */
+/* remove redundant charge if migration failed*/
 void mem_cgroup_end_migration(struct page *newpage)
 {
-	mem_cgroup_uncharge_page(newpage);
+	/*
+	 * At success, page->mapping is not NULL.
+	 * special rollback care is necessary when
+	 * 1. at migration failure. (newpage->mapping is cleared in this case)
+	 * 2. the newpage was moved but not remapped again because the task
+	 *    exits and the newpage is obsolete. In this case, the new page
+	 *    may be a swapcache. So, we just call mem_cgroup_uncharge_page()
+	 *    always for avoiding mess. The  page_cgroup will be removed if
+	 *    unnecessary. File cache pages is still on radix-tree. Don't
+	 *    care it.
+	 */
+	if (!newpage->mapping)
+		__mem_cgroup_uncharge_common(newpage,
+					 MEM_CGROUP_CHARGE_TYPE_FORCE);
+	else if (PageAnon(newpage))
+		mem_cgroup_uncharge_page(newpage);
 }
 
 /*
  * This routine traverse page_cgroup in given list and drop them all.
- * This routine ignores page_cgroup->ref_cnt.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
  */
 #define FORCE_UNCHARGE_BATCH	(128)
@@ -795,7 +811,8 @@ static void mem_cgroup_force_empty_list(
 		 * if it's under page migration.
 		 */
 		if (PageLRU(page)) {
-			mem_cgroup_uncharge_page(page);
+			__mem_cgroup_uncharge_common(page,
+					MEM_CGROUP_CHARGE_TYPE_FORCE);
 			put_page(page);
 			if (--count <= 0) {
 				count = FORCE_UNCHARGE_BATCH;
diff -puN mm/migrate.c~memcg-remove-refcnt-from-page_cgroup mm/migrate.c
--- a/mm/migrate.c~memcg-remove-refcnt-from-page_cgroup
+++ a/mm/migrate.c
@@ -359,8 +359,7 @@ static int migrate_page_move_mapping(str
 
 	write_unlock_irq(&mapping->tree_lock);
 	if (!PageSwapCache(newpage)) {
-		mem_cgroup_uncharge_page(page);
-		mem_cgroup_getref(newpage);
+		mem_cgroup_uncharge_cache_page(page);
 	}
 
 	return 0;
diff -puN mm/rmap.c~memcg-remove-refcnt-from-page_cgroup mm/rmap.c
--- a/mm/rmap.c~memcg-remove-refcnt-from-page_cgroup
+++ a/mm/rmap.c
@@ -576,14 +576,8 @@ void page_add_anon_rmap(struct page *pag
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	if (atomic_inc_and_test(&page->_mapcount))
 		__page_set_anon_rmap(page, vma, address);
-	else {
+	else
 		__page_check_anon_rmap(page, vma, address);
-		/*
-		 * We unconditionally charged during prepare, we uncharge here
-		 * This takes care of balancing the reference counts
-		 */
-		mem_cgroup_uncharge_page(page);
-	}
 }
 
 /**
@@ -614,12 +608,6 @@ void page_add_file_rmap(struct page *pag
 {
 	if (atomic_inc_and_test(&page->_mapcount))
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
-	else
-		/*
-		 * We unconditionally charged during prepare, we uncharge here
-		 * This takes care of balancing the reference counts
-		 */
-		mem_cgroup_uncharge_page(page);
 }
 
 #ifdef CONFIG_DEBUG_VM
diff -puN mm/shmem.c~memcg-remove-refcnt-from-page_cgroup mm/shmem.c
--- a/mm/shmem.c~memcg-remove-refcnt-from-page_cgroup
+++ a/mm/shmem.c
@@ -922,20 +922,26 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
-	/* Precharge page while we can wait, compensate afterwards */
+	/* Precharge page using GFP_KERNEL while we can wait */
 	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
 	if (error)
 		goto out;
 	error = radix_tree_preload(GFP_KERNEL);
-	if (error)
-		goto uncharge;
+	if (error) {
+		mem_cgroup_uncharge_cache_page(page);
+		goto out;
+	}
 	error = 1;
 
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, idx, NULL);
-	if (ptr && ptr->val == entry.val)
+	if (ptr && ptr->val == entry.val) {
 		error = add_to_page_cache(page, inode->i_mapping,
 						idx, GFP_NOWAIT);
+		/* does mem_cgroup_uncharge_cache_page on error */
+	} else	/* we must compensate for our precharge above */
+		mem_cgroup_uncharge_cache_page(page);
+
 	if (error == -EEXIST) {
 		struct page *filepage = find_get_page(inode->i_mapping, idx);
 		error = 1;
@@ -961,8 +967,6 @@ found:
 		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
 	radix_tree_preload_end();
-uncharge:
-	mem_cgroup_uncharge_page(page);
 out:
 	unlock_page(page);
 	page_cache_release(page);
@@ -1319,7 +1323,7 @@ repeat:
 					page_cache_release(swappage);
 					goto failed;
 				}
-				mem_cgroup_uncharge_page(swappage);
+				mem_cgroup_uncharge_cache_page(swappage);
 			}
 			page_cache_release(swappage);
 			goto repeat;
@@ -1358,6 +1362,8 @@ repeat:
 		}
 
 		if (!filepage) {
+			int ret;
+
 			spin_unlock(&info->lock);
 			filepage = shmem_alloc_page(gfp, info, idx);
 			if (!filepage) {
@@ -1386,10 +1392,18 @@ repeat:
 				swap = *entry;
 				shmem_swp_unmap(entry);
 			}
-			if (error || swap.val || 0 != add_to_page_cache_lru(
-					filepage, mapping, idx, GFP_NOWAIT)) {
+			ret = error || swap.val;
+			if (ret)
+				mem_cgroup_uncharge_cache_page(filepage);
+			else
+				ret = add_to_page_cache_lru(filepage, mapping,
+						idx, GFP_NOWAIT);
+			/*
+			 * At add_to_page_cache_lru() failure, uncharge will
+			 * be done automatically.
+			 */
+			if (ret) {
 				spin_unlock(&info->lock);
-				mem_cgroup_uncharge_page(filepage);
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
 				shmem_free_blocks(inode, 1);
@@ -1398,7 +1412,6 @@ repeat:
 					goto failed;
 				goto repeat;
 			}
-			mem_cgroup_uncharge_page(filepage);
 			info->flags |= SHMEM_PAGEIN;
 		}
 
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


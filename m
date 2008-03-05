From: akpm@linux-foundation.org
Subject: - memcg-remove-mem_cgroup_uncharge.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:26 -0800
Message-ID: <200803050745.m257jQhv021592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764275AbYCEHqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: remove mem_cgroup_uncharge
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_uncharge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove mem_cgroup_uncharge
From: Hugh Dickins <hugh@veritas.com>

Nothing uses mem_cgroup_uncharge apart from mem_cgroup_uncharge_page, (a
trivial wrapper around it) and mem_cgroup_end_migration (which does the same
as mem_cgroup_uncharge_page).  And it often ends up having to lock just to let
its caller unlock.  Remove it (but leave the silly locking until a later
patch).

Moved mem_cgroup_cache_charge next to mem_cgroup_charge in memcontrol.h.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   20 +++++++-------------
 mm/memcontrol.c            |   23 ++++++++---------------
 2 files changed, 15 insertions(+), 28 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-mem_cgroup_uncharge include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_uncharge
+++ a/include/linux/memcontrol.h
@@ -35,7 +35,8 @@ extern void mm_free_cgroup(struct mm_str
 extern struct page_cgroup *page_get_page_cgroup(struct page *page);
 extern int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
-extern void mem_cgroup_uncharge(struct page_cgroup *pc);
+extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
+					gfp_t gfp_mask);
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_move_lists(struct page *page, bool active);
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
@@ -45,8 +46,6 @@ extern unsigned long mem_cgroup_isolate_
 					struct mem_cgroup *mem_cont,
 					int active);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
-extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
-					gfp_t gfp_mask);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
 #define mm_match_cgroup(mm, cgroup)	\
@@ -92,14 +91,16 @@ static inline struct page_cgroup *page_g
 	return NULL;
 }
 
-static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
-					gfp_t gfp_mask)
+static inline int mem_cgroup_charge(struct page *page,
+					struct mm_struct *mm, gfp_t gfp_mask)
 {
 	return 0;
 }
 
-static inline void mem_cgroup_uncharge(struct page_cgroup *pc)
+static inline int mem_cgroup_cache_charge(struct page *page,
+					struct mm_struct *mm, gfp_t gfp_mask)
 {
+	return 0;
 }
 
 static inline void mem_cgroup_uncharge_page(struct page *page)
@@ -110,13 +111,6 @@ static inline void mem_cgroup_move_lists
 {
 }
 
-static inline int mem_cgroup_cache_charge(struct page *page,
-						struct mm_struct *mm,
-						gfp_t gfp_mask)
-{
-	return 0;
-}
-
 static inline int mm_match_cgroup(struct mm_struct *mm, struct mem_cgroup *mem)
 {
 	return 1;
diff -puN mm/memcontrol.c~memcg-remove-mem_cgroup_uncharge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_uncharge
+++ a/mm/memcontrol.c
@@ -697,20 +697,22 @@ int mem_cgroup_cache_charge(struct page 
 
 /*
  * Uncharging is always a welcome operation, we never complain, simply
- * uncharge. This routine should be called with lock_page_cgroup held
+ * uncharge.
  */
-void mem_cgroup_uncharge(struct page_cgroup *pc)
+void mem_cgroup_uncharge_page(struct page *page)
 {
+	struct page_cgroup *pc;
 	struct mem_cgroup *mem;
 	struct mem_cgroup_per_zone *mz;
-	struct page *page;
 	unsigned long flags;
 
 	/*
 	 * Check if our page_cgroup is valid
 	 */
+	lock_page_cgroup(page);
+	pc = page_get_page_cgroup(page);
 	if (!pc)
-		return;
+		goto unlock;
 
 	if (atomic_dec_and_test(&pc->ref_cnt)) {
 		page = pc->page;
@@ -731,12 +733,8 @@ void mem_cgroup_uncharge(struct page_cgr
 		}
 		lock_page_cgroup(page);
 	}
-}
 
-void mem_cgroup_uncharge_page(struct page *page)
-{
-	lock_page_cgroup(page);
-	mem_cgroup_uncharge(page_get_page_cgroup(page));
+unlock:
 	unlock_page_cgroup(page);
 }
 
@@ -759,12 +757,7 @@ int mem_cgroup_prepare_migration(struct 
 
 void mem_cgroup_end_migration(struct page *page)
 {
-	struct page_cgroup *pc;
-
-	lock_page_cgroup(page);
-	pc = page_get_page_cgroup(page);
-	mem_cgroup_uncharge(pc);
-	unlock_page_cgroup(page);
+	mem_cgroup_uncharge_page(page);
 }
 /*
  * We know both *page* and *newpage* are now not-on-LRU and Pg_locked.
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch


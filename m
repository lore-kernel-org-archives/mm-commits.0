From: akpm@linux-foundation.org
Subject: + memcg-remove-mem_cgroup_uncharge.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:52:44 -0800
Message-ID: <200802280352.m1S3qiRR014223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754940AbYB1DxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:53:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: remove mem_cgroup_uncharge
has been added to the -mm tree.  Its filename is
     memcg-remove-mem_cgroup_uncharge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
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
memcg-mm_match_cgroup-not-vm_match_cgroup.patch
memcg-move_lists-on-page-not-page_cgroup.patch
memcg-page_cache_release-not-__free_page.patch
memcg-when-do_swaps-do_wp_page-fails.patch
memcg-fix-vm_bug_on-from-page-migration.patch
memcg-bad-page-if-page_cgroup-when-free.patch
memcg-mem_cgroup_charge-never-null.patch
memcg-remove-mem_cgroup_uncharge.patch
memcg-memcontrol-whitespace-cleanups.patch
memcg-memcontrol-uninlined-and-static.patch
memcg-remove-clear_page_cgroup-and-atomics.patch
memcg-css_put-after-remove_list.patch
memcg-fix-mem_cgroup_move_lists-locking.patch
memcg-simplify-force_empty-and-move_lists.patch
memcg-fix-oops-on-null-lru-list.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

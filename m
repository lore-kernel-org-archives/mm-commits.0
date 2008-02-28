From: akpm@linux-foundation.org
Subject: + memcg-mm_match_cgroup-not-vm_match_cgroup.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:52:30 -0800
Message-ID: <200802280352.m1S3qUBC014202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755089AbYB1Dwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:52:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: mm_match_cgroup not vm_match_cgroup
has been added to the -mm tree.  Its filename is
     memcg-mm_match_cgroup-not-vm_match_cgroup.patch

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
Subject: memcg: mm_match_cgroup not vm_match_cgroup
From: Hugh Dickins <hugh@veritas.com>

vm_match_cgroup is a perverse name for a macro to match mm with cgroup: rename
it mm_match_cgroup, matching mm_init_cgroup and mm_free_cgroup.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |    2 +-
 mm/rmap.c                  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-mm_match_cgroup-not-vm_match_cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-mm_match_cgroup-not-vm_match_cgroup
+++ a/include/linux/memcontrol.h
@@ -48,7 +48,7 @@ extern int mem_cgroup_cache_charge(struc
 					gfp_t gfp_mask);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
-#define vm_match_cgroup(mm, cgroup)	\
+#define mm_match_cgroup(mm, cgroup)	\
 	((cgroup) == rcu_dereference((mm)->mem_cgroup))
 
 extern int mem_cgroup_prepare_migration(struct page *page);
@@ -118,7 +118,7 @@ static inline int mem_cgroup_cache_charg
 	return 0;
 }
 
-static inline int vm_match_cgroup(struct mm_struct *mm, struct mem_cgroup *mem)
+static inline int mm_match_cgroup(struct mm_struct *mm, struct mem_cgroup *mem)
 {
 	return 1;
 }
diff -puN mm/memcontrol.c~memcg-mm_match_cgroup-not-vm_match_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mm_match_cgroup-not-vm_match_cgroup
+++ a/mm/memcontrol.c
@@ -399,7 +399,7 @@ int task_in_mem_cgroup(struct task_struc
 	int ret;
 
 	task_lock(task);
-	ret = task->mm && vm_match_cgroup(task->mm, mem);
+	ret = task->mm && mm_match_cgroup(task->mm, mem);
 	task_unlock(task);
 	return ret;
 }
diff -puN mm/rmap.c~memcg-mm_match_cgroup-not-vm_match_cgroup mm/rmap.c
--- a/mm/rmap.c~memcg-mm_match_cgroup-not-vm_match_cgroup
+++ a/mm/rmap.c
@@ -321,7 +321,7 @@ static int page_referenced_anon(struct p
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && !vm_match_cgroup(vma->vm_mm, mem_cont))
+		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
 		referenced += page_referenced_one(page, vma, &mapcount);
 		if (!mapcount)
@@ -382,7 +382,7 @@ static int page_referenced_file(struct p
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && !vm_match_cgroup(vma->vm_mm, mem_cont))
+		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
 		if ((vma->vm_flags & (VM_LOCKED|VM_MAYSHARE))
 				  == (VM_LOCKED|VM_MAYSHARE)) {
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

From: akpm@linux-foundation.org
Subject: - memcg-mm_match_cgroup-not-vm_match_cgroup.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:07 -0800
Message-ID: <200803050745.m257j7vV021568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764430AbYCEHqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: mm_match_cgroup not vm_match_cgroup
has been removed from the -mm tree.  Its filename was
     memcg-mm_match_cgroup-not-vm_match_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: mm_match_cgroup not vm_match_cgroup
From: Hugh Dickins <hugh@veritas.com>

vm_match_cgroup is a perverse name for a macro to match mm with cgroup: rename
it mm_match_cgroup, matching mm_init_cgroup and mm_free_cgroup.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: David Rientjes <rientjes@google.com>
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


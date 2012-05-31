From: akpm@linux-foundation.org
Subject: [merged] kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:26 -0700
Message-ID: <20120531191426.745EEA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33996 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab2EaTO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:29 -0400
Received: by lbbgp10 with SMTP id gp10so85745lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, lizf@cn.fujitsu.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: cgroup: push rcu read locking from css_is_ancestor() to callsite
has been removed from the -mm tree.  Its filename was
     kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: kernel: cgroup: push rcu read locking from css_is_ancestor() to callsite

Library functions should not grab locks when the callsites can do it, even
if the lock nests like the rcu read-side lock does.

Push the rcu_read_lock() from css_is_ancestor() to its single user,
mem_cgroup_same_or_subtree() in preparation for another user that may
already hold the rcu read-side lock.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   20 ++++++++++----------
 mm/memcontrol.c |   14 +++++++++-----
 2 files changed, 19 insertions(+), 15 deletions(-)

diff -puN kernel/cgroup.c~kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite kernel/cgroup.c
--- a/kernel/cgroup.c~kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite
+++ a/kernel/cgroup.c
@@ -5132,7 +5132,7 @@ EXPORT_SYMBOL_GPL(css_depth);
  * @root: the css supporsed to be an ancestor of the child.
  *
  * Returns true if "root" is an ancestor of "child" in its hierarchy. Because
- * this function reads css->id, this use rcu_dereference() and rcu_read_lock().
+ * this function reads css->id, the caller must hold rcu_read_lock().
  * But, considering usual usage, the csses should be valid objects after test.
  * Assuming that the caller will do some action to the child if this returns
  * returns true, the caller must take "child";s reference count.
@@ -5144,18 +5144,18 @@ bool css_is_ancestor(struct cgroup_subsy
 {
 	struct css_id *child_id;
 	struct css_id *root_id;
-	bool ret = true;
 
-	rcu_read_lock();
 	child_id  = rcu_dereference(child->id);
+	if (!child_id)
+		return false;
 	root_id = rcu_dereference(root->id);
-	if (!child_id
-	    || !root_id
-	    || (child_id->depth < root_id->depth)
-	    || (child_id->stack[root_id->depth] != root_id->id))
-		ret = false;
-	rcu_read_unlock();
-	return ret;
+	if (!root_id)
+		return false;
+	if (child_id->depth < root_id->depth)
+		return false;
+	if (child_id->stack[root_id->depth] != root_id->id)
+		return false;
+	return true;
 }
 
 void free_css_id(struct cgroup_subsys *ss, struct cgroup_subsys_state *css)
diff -puN mm/memcontrol.c~kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite mm/memcontrol.c
--- a/mm/memcontrol.c~kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite
+++ a/mm/memcontrol.c
@@ -1152,12 +1152,16 @@ struct lruvec *mem_cgroup_lru_move_lists
 static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 		struct mem_cgroup *memcg)
 {
-	if (root_memcg != memcg) {
-		return (root_memcg->use_hierarchy &&
-			css_is_ancestor(&memcg->css, &root_memcg->css));
-	}
+	bool ret;
 
-	return true;
+	if (root_memcg == memcg)
+		return true;
+	if (!root_memcg->use_hierarchy)
+		return false;
+	rcu_read_lock();
+	ret = css_is_ancestor(&memcg->css, &root_memcg->css);
+	rcu_read_unlock();
+	return ret;
 }
 
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-slab-remove-duplicate-check.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch


From: akpm@linux-foundation.org
Subject: + kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch added to -mm tree
Date: Thu, 26 Apr 2012 14:37:44 -0700
Message-ID: <20120426213744.C4D00A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61060 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2DZVhq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 17:37:46 -0400
Received: by qabg24 with SMTP id g24so31834qab.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 14:37:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, lizf@cn.fujitsu.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: kernel: cgroup: push rcu read locking from css_is_ancestor() to callsite
has been added to the -mm tree.  Its filename is
     kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch

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
@@ -1161,12 +1161,16 @@ struct lruvec *mem_cgroup_lru_move_lists
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
Subject: Subject: kernel: cgroup: push rcu read locking from css_is_ancestor() to callsite

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-fix-up-the-vmscan-stat-in-vmstat.patch
mm-fix-null-ptr-dereference-in-migrate_pages.patch
mm-fix-null-ptr-dereference-in-move_pages.patch
linux-next.patch
mm-remove-swap-token-code.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
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
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch


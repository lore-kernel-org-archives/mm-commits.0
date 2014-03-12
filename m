From: akpm@linux-foundation.org
Subject: + memcg-get_mem_cgroup_from_mm.patch added to -mm tree
Date: Wed, 12 Mar 2014 14:04:01 -0700
Message-ID: <5320cbc1.G3/o8ZkBCawqUCCe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaCLVEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 17:04:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: + memcg-get_mem_cgroup_from_mm.patch added to -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 14:04:01 -0700


The patch titled
     Subject: memcg: get_mem_cgroup_from_mm()
has been added to the -mm tree.  Its filename is
     memcg-get_mem_cgroup_from_mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-get_mem_cgroup_from_mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-get_mem_cgroup_from_mm.patch

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
Subject: memcg: get_mem_cgroup_from_mm()

Instead of returning NULL from try_get_mem_cgroup_from_mm() when the mm
owner is exiting, just return root_mem_cgroup.  This makes sense for all
callsites and gets rid of some of them having to fallback manually.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~memcg-get_mem_cgroup_from_mm mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get_mem_cgroup_from_mm
+++ a/mm/memcontrol.c
@@ -1071,7 +1071,7 @@ struct mem_cgroup *mem_cgroup_from_task(
 	return mem_cgroup_from_css(task_css(p, mem_cgroup_subsys_id));
 }
 
-struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg = NULL;
 
@@ -1079,7 +1079,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	do {
 		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 		if (unlikely(!memcg))
-			break;
+			memcg = root_mem_cgroup;
 	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
@@ -1475,7 +1475,7 @@ bool task_in_mem_cgroup(struct task_stru
 
 	p = find_lock_task_mm(task);
 	if (p) {
-		curr = try_get_mem_cgroup_from_mm(p->mm);
+		curr = get_mem_cgroup_from_mm(p->mm);
 		task_unlock(p);
 	} else {
 		/*
@@ -1489,8 +1489,6 @@ bool task_in_mem_cgroup(struct task_stru
 			css_get(&curr->css);
 		rcu_read_unlock();
 	}
-	if (!curr)
-		return false;
 	/*
 	 * We should check use_hierarchy of "memcg" not "curr". Because checking
 	 * use_hierarchy of "curr" here make this function true if hierarchy is
@@ -3649,15 +3647,7 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 	if (!current->mm || current->memcg_kmem_skip_account)
 		return true;
 
-	memcg = try_get_mem_cgroup_from_mm(current->mm);
-
-	/*
-	 * very rare case described in mem_cgroup_from_task. Unfortunately there
-	 * isn't much we can do without complicating this too much, and it would
-	 * be gfp-dependent anyway. Just let it go
-	 */
-	if (unlikely(!memcg))
-		return true;
+	memcg = get_mem_cgroup_from_mm(current->mm);
 
 	if (!memcg_can_account_kmem(memcg)) {
 		css_put(&memcg->css);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
lib-radix_tree-tree-node-interface-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
debugging-keep-track-of-page-owners.patch


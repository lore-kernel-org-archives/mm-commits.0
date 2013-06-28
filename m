From: akpm@linux-foundation.org
Subject: + memcg-kmem-fix-reference-count-handling-on-the-error-path.patch added to -mm tree
Date: Fri, 28 Jun 2013 16:00:26 -0700
Message-ID: <51ce158a.HEuEyNa/zj1ELuQ3%akpm__2869.02991724691$1372460443$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3F1XA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 19:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, lizefan@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, glommer@openvz.org, mhocko@suse.cz

Subject: + memcg-kmem-fix-reference-count-handling-on-the-error-path.patch added to -mm tree
To: mhocko@suse.cz,glommer@openvz.org,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,lizefan@huawei.com,stable@vger.kernel.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 16:00:26 -0700


The patch titled
     Subject: memcg, kmem: fix reference count handling on the error path
has been added to the -mm tree.  Its filename is
     memcg-kmem-fix-reference-count-handling-on-the-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, kmem: fix reference count handling on the error path

mem_cgroup_css_online calls mem_cgroup_put if memcg_init_kmem fails.  This
is not correct because only memcg_propagate_kmem takes an additional
reference while mem_cgroup_sockets_init is allowed to fail as well
(although no current implementation fails) but it doesn't take any
reference.  This all suggests that it should be memcg_propagate_kmem that
should clean up after itself so this patch moves mem_cgroup_put over
there.

Unfortunately this is not that easy (as pointed out by Li Zefan) because
memcg_kmem_mark_dead marks the group dead (KMEM_ACCOUNTED_DEAD) if it is
marked active (KMEM_ACCOUNTED_ACTIVE) which is the case even if
memcg_propagate_kmem fails so the additional reference is dropped in that
case in kmem_cgroup_destroy which means that the reference would be
dropped two times.

The easiest way then would be to simply remove mem_cgrroup_put from
mem_cgroup_css_online and rely on kmem_cgroup_destroy doing the right
thing.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.8]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-kmem-fix-reference-count-handling-on-the-error-path mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-kmem-fix-reference-count-handling-on-the-error-path
+++ a/mm/memcontrol.c
@@ -6345,14 +6345,6 @@ mem_cgroup_css_online(struct cgroup *con
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
 	mutex_unlock(&memcg_create_mutex);
-	if (error) {
-		/*
-		 * We call put now because our (and parent's) refcnts
-		 * are already in place. mem_cgroup_put() will internally
-		 * call __mem_cgroup_free, so return directly
-		 */
-		mem_cgroup_put(memcg);
-	}
 	return error;
 }
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
memcg-update-todo-list-in-documentation.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix.patch
mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix.patch
mm-pageblock-remove-get-set_pageblock_flags.patch
mm-hugetlb-remove-hugetlb_prefault.patch
mm-hugetlb-use-already-exist-interface-huge_page_shift.patch
mm-correctly-update-zone-managed_pages-fix-fix.patch
mm-correctly-update-zone-managed_pages-fix-fix-fix.patch
memcg-kconfig-info-update.patch
mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-unicore32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-parisc-prepare-for-killing-free_all_bootmem_node.patch
mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
memcg-clean-up-memcg-nodeinfo.patch
mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
memcg-do-not-account-memory-used-for-cache-creation.patch
mm-page_alloc-fix-doc-for-numa_zonelist_order.patch
mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
revert-memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-kmem-fix-reference-count-handling-on-the-error-path.patch
memcg-use-css_get-in-sock_update_memcg.patch
memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-for-swap-memcg.patch
memcg-dont-need-to-get-a-reference-to-the-parent.patch
memcg-kill-memcg-refcnt.patch
memcg-dont-need-to-free-memcg-via-rcu-or-workqueue.patch
drop_caches-add-some-documentation-and-info-messsge.patch
fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid.patch
kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch
kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch
kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch
staging-lustre-replace-num_physpages-with-totalram_pages.patch


From: akpm@linux-foundation.org
Subject: + memcg-show-real-limit-under-hierarchy-mode.patch added to -mm tree
Date: Mon, 15 Dec 2008 16:03:48 -0800
Message-ID: <200812160003.mBG03mXO029194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbYLPAEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 19:04:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     memcg: show real limit under hierarchy mode
has been added to the -mm tree.  Its filename is
     memcg-show-real-limit-under-hierarchy-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: show real limit under hierarchy mode
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Show "real" limit of memcg.  This helps my debugging and maybe useful for
users.

While testing hierarchy like this

	mount -t cgroup none /cgroup -t memory
	mkdir /cgroup/A
	set use_hierarchy==1 to "A"
	mkdir /cgroup/A/01
	mkdir /cgroup/A/01/02
	mkdir /cgroup/A/01/03
	mkdir /cgroup/A/01/03/04
	mkdir /cgroup/A/08
	mkdir /cgroup/A/08/01
	....
and set each own limit to them, "real" limit of each memcg is unclear.
This patch shows real limit by checking all ancestors.

Changelog: (v1) -> (v2)
	- remove "if" and use "min(a,b)"

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN mm/memcontrol.c~memcg-show-real-limit-under-hierarchy-mode mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-show-real-limit-under-hierarchy-mode
+++ a/mm/memcontrol.c
@@ -1777,6 +1777,34 @@ static int mem_cgroup_write(struct cgrou
 	return ret;
 }
 
+static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
+		unsigned long long *mem_limit, unsigned long long *memsw_limit)
+{
+	struct cgroup *cgroup;
+	unsigned long long min_limit, min_memsw_limit, tmp;
+
+	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
+	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+	cgroup = memcg->css.cgroup;
+	if (!memcg->use_hierarchy)
+		goto out;
+
+	while (cgroup->parent) {
+		cgroup = cgroup->parent;
+		memcg = mem_cgroup_from_cont(cgroup);
+		if (!memcg->use_hierarchy)
+			break;
+		tmp = res_counter_read_u64(&memcg->res, RES_LIMIT);
+		min_limit = min(min_limit, tmp);
+		tmp = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+		min_memsw_limit = min(min_memsw_limit, tmp);
+	}
+out:
+	*mem_limit = min_limit;
+	*memsw_limit = min_memsw_limit;
+	return;
+}
+
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *mem;
@@ -1850,6 +1878,13 @@ static int mem_control_stat_show(struct 
 		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
 
 	}
+	{
+		unsigned long long limit, memsw_limit;
+		memcg_get_hierarchical_limit(mem_cont, &limit, &memsw_limit);
+		cb->fill(cb, "hierarchical_memory_limit", limit);
+		if (do_swap_account)
+			cb->fill(cb, "hierarchical_memsw_limit", memsw_limit);
+	}
 
 #ifdef CONFIG_DEBUG_VM
 	cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

clocksource-pass-clocksource-to-read-callback-fix.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
devcgroup-use-list_for_each_entry_rcu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
memcg-explain-details-and-test-document-fix.patch
memcg-dont-trigger-oom-at-page-migration.patch
memcg-remove-mem_cgroup_try_charge.patch
memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch
memcg-fix-swap-accounting-leak-v3.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch


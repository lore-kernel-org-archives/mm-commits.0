From: akpm@linux-foundation.org
Subject: - quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:27:43 -0800
Message-ID: <200812032027.mB3KRhCm027517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759038AbYLCU2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:28:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, cmm@us.ibm.com, hch@lst.de, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix
has been removed from the -mm tree.  Its filename was
     quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix.patch

This patch was dropped because of rejects against linux-next

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

fs/dquot.c:1391: error: redefinition of '__kcrctab_dquot_reserve_space'
fs/dquot.c:1352: error: previous definition of '__kcrctab_dquot_reserve_space' was here
fs/dquot.c:1391: error: redefinition of '__kstrtab_dquot_reserve_space'
fs/dquot.c:1352: error: previous definition of '__kstrtab_dquot_reserve_space' was here
fs/dquot.c:1391: error: redefinition of '__ksymtab_dquot_reserve_space'
fs/dquot.c:1352: error: previous definition of '__ksymtab_dquot_reserve_space' was here
fs/dquot.c:2101: error: redefinition of '__kcrctab_vfs_dq_quota_on_remount'
fs/dquot.c:1974: error: previous definition of '__kcrctab_vfs_dq_quota_on_remount' was here
fs/dquot.c:2101: error: redefinition of '__kstrtab_vfs_dq_quota_on_remount'
fs/dquot.c:1974: error: previous definition of '__kstrtab_vfs_dq_quota_on_remount' was here
fs/dquot.c:2101: error: redefinition of '__ksymtab_vfs_dq_quota_on_remount'
fs/dquot.c:1974: error: previous definition of '__ksymtab_vfs_dq_quota_on_remount' was here

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@ucw.cz>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/dquot.c~quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix fs/dquot.c
--- a/fs/dquot.c~quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix
+++ a/fs/dquot.c
@@ -1388,7 +1388,7 @@ int dquot_claim_space(struct inode *inod
 	inode_add_bytes(inode, number);
 	return ret;
 }
-EXPORT_SYMBOL(dquot_reserve_space);
+EXPORT_SYMBOL(dquot_claim_space);
 
 /*
  * Release reserved quota space
@@ -1971,7 +1971,7 @@ static int vfs_quota_on_remount(struct s
 
 	return ret;
 }
-EXPORT_SYMBOL(vfs_dq_quota_on_remount);
+EXPORT_SYMBOL(vfs_quota_on_remount);
 
 int vfs_quota_on_path(struct super_block *sb, int type, int format_id,
 		      struct path *path)
@@ -2277,6 +2277,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return err;
 }
+EXPORT_SYMBOL(vfs_set_dqinfo);
 
 struct quotactl_ops vfs_quotactl_ops = {
 	.quota_on	= vfs_quota_on,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
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
quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix.patch
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
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
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
memcg-explain-details-and-test-document.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch


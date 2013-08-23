From: akpm@linux-foundation.org
Subject: [merged] memcg-get-rid-of-swapaccount-leftovers.patch removed
 from -mm tree
Date: Fri, 23 Aug 2013 12:06:19 -0700
Message-ID: <5217b2ab.zsGbv9ouiKWkdGR3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3HWTGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 15:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gergely@risko.hu, mhocko@suse.cz

Subject: [merged] memcg-get-rid-of-swapaccount-leftovers.patch removed from -mm tree
To: mhocko@suse.cz,gergely@risko.hu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 12:06:19 -0700


The patch titled
     Subject: memcg: get rid of swapaccount leftovers
has been removed from the -mm tree.  Its filename was
     memcg-get-rid-of-swapaccount-leftovers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: get rid of swapaccount leftovers

swapaccount kernel parameter without any values has been removed by
a2c8990a ("memsw: remove noswapaccount kernel parameter") but it seems
that we didn't get rid of all the left overs.

Make sure that menuconfig help text and kernel-parameters.txt are clear
about value for the paramter and remove the stalled comment which is not
very much useful on its own.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Gergely Risko <gergely@risko.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +-
 init/Kconfig                        |    2 +-
 mm/memcontrol.c                     |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~memcg-get-rid-of-swapaccount-leftovers Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~memcg-get-rid-of-swapaccount-leftovers
+++ a/Documentation/kernel-parameters.txt
@@ -2953,7 +2953,7 @@ bytes respectively. Such letter suffixes
 			improve throughput, but will also increase the
 			amount of memory reserved for use by the client.
 
-	swapaccount[=0|1]
+	swapaccount=[0|1]
 			[KNL] Enable accounting of swap in memory resource
 			controller if no parameter or 1 is given or disable
 			it if 0 is given (See Documentation/cgroups/memory.txt)
diff -puN init/Kconfig~memcg-get-rid-of-swapaccount-leftovers init/Kconfig
--- a/init/Kconfig~memcg-get-rid-of-swapaccount-leftovers
+++ a/init/Kconfig
@@ -955,7 +955,7 @@ config MEMCG_SWAP_ENABLED
 	  Memory Resource Controller Swap Extension comes with its price in
 	  a bigger memory consumption. General purpose distribution kernels
 	  which want to enable the feature but keep it disabled by default
-	  and let the user enable it by swapaccount boot command line
+	  and let the user enable it by swapaccount=1 boot command line
 	  parameter should have this option unselected.
 	  For those who want to have the feature enabled by default should
 	  select this option (if, for some reason, they need to disable it
diff -puN mm/memcontrol.c~memcg-get-rid-of-swapaccount-leftovers mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get-rid-of-swapaccount-leftovers
+++ a/mm/memcontrol.c
@@ -6969,7 +6969,6 @@ struct cgroup_subsys mem_cgroup_subsys =
 #ifdef CONFIG_MEMCG_SWAP
 static int __init enable_swap_account(char *s)
 {
-	/* consider enabled if no parameter or 1 is given */
 	if (!strcmp(s, "1"))
 		really_do_swap_account = 1;
 	else if (!strcmp(s, "0"))
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
watchdog-update-watchdog_tresh-properly-fix.patch
mm-fix-potential-null-pointer-dereference.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch
mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-enhance-memcg-iterator-to-support-predicates-fix.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
memcg-trivial-cleanups.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch
memcg-remove-memcg_nr_file_mapped.patch
memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
memcg-add-per-cgroup-writeback-pages-accounting.patch
memcg-document-cgroup-dirty-writeback-memory-statistics.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch
mm-kconfig-add-mmu-dependency-for-migration.patch


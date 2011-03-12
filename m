From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch removed from -mm tree
Date: Fri, 11 Mar 2011 16:50:27 -0800
Message-ID: <201103120050.p2C0oRdW005653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab1CLAvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 19:51:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, gthelen@google.com, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@g


The patch titled
     memcg: use native word to represent dirtyable pages
has been removed from the -mm tree.  Its filename was
     memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: use native word to represent dirtyable pages
From: Johannes Weiner <hannes@cmpxchg.org>

The memory cgroup dirty info calculation currently uses a signed 64-bit
type to represent the amount of dirtyable memory in pages.

This can instead be changed to an unsigned word, which will allow the
formula to function correctly with up to 160G of LRU pages on a 32-bit
system, assuming 4k pages.  That should be plenty even when taking racy
folding of the per-cpu counters into account.

This fixes a compilation error on 32-bit systems as this code tries to do
64-bit division.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Dave Young <hidave.darkstar@gmail.com>
Reviewed-by: Greg Thelen <gthelen@google.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages
+++ a/mm/memcontrol.c
@@ -1217,9 +1217,10 @@ static void __mem_cgroup_dirty_param(str
 bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 			   struct dirty_info *info)
 {
-	s64 available_mem;
 	struct vm_dirty_param dirty_param;
+	unsigned long available_mem;
 	struct mem_cgroup *memcg;
+	s64 value;
 
 	if (mem_cgroup_disabled())
 		return false;
@@ -1233,11 +1234,11 @@ bool mem_cgroup_dirty_info(unsigned long
 	__mem_cgroup_dirty_param(&dirty_param, memcg);
 	rcu_read_unlock();
 
-	available_mem = mem_cgroup_page_stat(MEMCG_NR_DIRTYABLE_PAGES);
-	if (available_mem < 0)
+	value = mem_cgroup_page_stat(MEMCG_NR_DIRTYABLE_PAGES);
+	if (value < 0)
 		return false;
 
-	available_mem = min((unsigned long)available_mem, sys_available_mem);
+	available_mem = min((unsigned long)value, sys_available_mem);
 
 	if (dirty_param.dirty_bytes)
 		info->dirty_thresh =
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

thp-fix-page_referenced-to-modify-mapcount-vm_flags-only-if-page-is-found.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-free-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-simplify-code-of-swapc.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-keep-only-one-charge-cancelling-function-fix.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
memcg-fix-leak-on-wrong-lru-with-fuse.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch


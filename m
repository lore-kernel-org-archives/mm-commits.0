From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 13:55:14 -0700
Message-ID: <5230d8b2.7QGB0PPCNK8PezHM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3IKUzP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:55:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, js1304@gmail.com, cl@linux.com, adobriyan@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,adobriyan@gmail.com,cl@linux.com,js1304@gmail.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:55:14 -0700


The patch titled
     Subject: vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix
has been removed from the -mm tree.  Its filename was
     vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch

This patch was dropped because it was folded into vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix

fix UP build

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/vmstat.h~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix
+++ a/include/linux/vmstat.h
@@ -198,7 +198,7 @@ extern void __inc_zone_state(struct zone
 extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
-void cpu_vm_stats_fold(int);
+void cpu_vm_stats_fold(int cpu);
 void refresh_zone_stat_thresholds(void);
 
 void drain_zonestat(struct zone *zone, struct per_cpu_pageset *);
@@ -255,6 +255,7 @@ static inline void __dec_zone_page_state
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
 static inline void refresh_zone_stat_thresholds(void) { }
+static inline void cpu_vm_stats_fold(int cpu) { }
 
 static inline void drain_zonestat(struct zone *zone,
 			struct per_cpu_pageset *pset) { }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
swap-make-swap-discard-async.patch
swap-make-cluster-allocation-per-cpu.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch


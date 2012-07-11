From: akpm@linux-foundation.org
Subject: [folded] memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch removed from -mm tree
Date: Wed, 11 Jul 2012 13:57:49 -0700
Message-ID: <20120711205751.8AC0420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:52243 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030192Ab2GKU5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 16:57:54 -0400
Received: by bkcjc3 with SMTP id jc3so84148bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 13:57:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, qiuxishi@huawei.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch

This patch was dropped because it was folded into memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix

add pglist_data.kswapd locking comments

Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmscan.c            |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix
+++ a/include/linux/mmzone.h
@@ -693,7 +693,7 @@ typedef struct pglist_data {
 					     range, including holes */
 	int node_id;
 	wait_queue_head_t kswapd_wait;
-	struct task_struct *kswapd;
+	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
 } pg_data_t;
diff -puN mm/vmscan.c~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix mm/vmscan.c
--- a/mm/vmscan.c~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix
+++ a/mm/vmscan.c
@@ -2956,7 +2956,8 @@ int kswapd_run(int nid)
 }
 
 /*
- * Called by memory hotplug when all memory in a node is offlined.
+ * Called by memory hotplug when all memory in a node is offlined.  Caller must
+ * hold lock_memory_hotplug().
  */
 void kswapd_stop(int nid)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
resource-make-sure-requested-range-intersects-root-range-fix.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


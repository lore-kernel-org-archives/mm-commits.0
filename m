From: akpm@linux-foundation.org
Subject: [folded-merged] acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:45:43 -0800
Message-ID: <20130222234544.27AA35A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:63426 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab3BVXpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:45:45 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so120701yhr.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:45:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, laijs@cn.fujitsu.com, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi, memory-hotplug: parse SRAT before memblock is ready fix
has been removed from the -mm tree.  Its filename was
     acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix.patch

This patch was dropped because it was folded into acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: acpi, memory-hotplug: parse SRAT before memblock is ready fix

alnoconfig complains:
arch/x86/kernel/setup.c: In function `setup_arch':
arch/x86/kernel/setup.c:917: error: implicit declaration of function `early_parse_srat'

because early_parse_srat is not declared for !CONFIG_ACPI. Moreover it
is defined only for CONFIG_ACPI_NUMA.

I am not sure what is the correct way to fix this but I guess that
providing an empty definition for !CONFIG_ACPI_NUMA is OK.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acpi.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN include/linux/acpi.h~acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix include/linux/acpi.h
--- a/include/linux/acpi.h~acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix
+++ a/include/linux/acpi.h
@@ -94,7 +94,6 @@ int acpi_boot_init (void);
 void acpi_boot_table_init (void);
 int acpi_mps_check (void);
 int acpi_numa_init (void);
-void __init early_parse_srat(void);
 
 int acpi_table_init (void);
 int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
@@ -486,6 +485,14 @@ static inline bool acpi_driver_match_dev
 
 #endif	/* !CONFIG_ACPI */
 
+#ifdef CONFIG_ACPI_NUMA
+void __init early_parse_srat(void);
+#else
+static inline void early_parse_srat(void)
+{
+}
+#endif
+
 #ifdef CONFIG_ACPI
 void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-fast-hierarchy-aware-child-test-fix-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
mm-refactor-inactive_file_is_low-to-use-get_lru_size.patch
memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init.patch
memcg-move-memcg_stock-initialization-to-mem_cgroup_init.patch
memcg-cleanup-mem_cgroup_init-comment.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch


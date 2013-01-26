From: akpm@linux-foundation.org
Subject: + acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch added to -mm tree
Date: Fri, 25 Jan 2013 16:41:00 -0800
Message-ID: <20130126004101.4352A31C210@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:64128 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3AZAlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 19:41:03 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so96683ghb.3
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 16:41:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com


The patch titled
     Subject: acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix
has been added to the -mm tree.  Its filename is
     acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix

clean up code, fix build warning

Cc: "Brown, Len" <len.brown@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat.c |   93 ++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 44 deletions(-)

diff -puN arch/x86/mm/srat.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix
+++ a/arch/x86/mm/srat.c
@@ -142,50 +142,8 @@ static inline int save_add_info(void) {r
 #endif
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-extern struct movablemem_map movablemem_map;
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-
-/* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
-int __init
-acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
+static void __init handle_movablemem(int node, u64 start, u64 end)
 {
-	u64 start, end;
-	u32 hotpluggable;
-	int node, pxm;
-
-	if (srat_disabled())
-		goto out_err;
-	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity))
-		goto out_err_bad_srat;
-	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
-		goto out_err;
-	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
-	if (hotpluggable && !save_add_info())
-		goto out_err;
-
-	start = ma->base_address;
-	end = start + ma->length;
-	pxm = ma->proximity_domain;
-	if (acpi_srat_revision <= 1)
-		pxm &= 0xff;
-
-	node = setup_node(pxm);
-	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
-		goto out_err_bad_srat;
-	}
-
-	if (numa_add_memblk(node, start, end) < 0)
-		goto out_err_bad_srat;
-
-	node_set(node, numa_nodes_parsed);
-
-	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
-	       node, pxm,
-	       (unsigned long long) start, (unsigned long long) end - 1,
-	       hotpluggable ? "Hot Pluggable": "");
-
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	int overlap;
 	unsigned long start_pfn, end_pfn;
 
@@ -229,7 +187,54 @@ acpi_numa_memory_affinity_init(struct ac
 			 */
 			insert_movablemem_map(start_pfn, end_pfn);
 	}
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+}
+#else		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+static inline void handle_movablemem(int node, u64 start, u64 end)
+{
+}
+#endif		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
+/* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
+int __init
+acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
+{
+	u64 start, end;
+	u32 hotpluggable;
+	int node, pxm;
+
+	if (srat_disabled())
+		goto out_err;
+	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity))
+		goto out_err_bad_srat;
+	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
+		goto out_err;
+	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
+	if (hotpluggable && !save_add_info())
+		goto out_err;
+
+	start = ma->base_address;
+	end = start + ma->length;
+	pxm = ma->proximity_domain;
+	if (acpi_srat_revision <= 1)
+		pxm &= 0xff;
+
+	node = setup_node(pxm);
+	if (node < 0) {
+		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
+		goto out_err_bad_srat;
+	}
+
+	if (numa_add_memblk(node, start, end) < 0)
+		goto out_err_bad_srat;
+
+	node_set(node, numa_nodes_parsed);
+
+	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
+	       node, pxm,
+	       (unsigned long long) start, (unsigned long long) end - 1,
+	       hotpluggable ? "Hot Pluggable": "");
+
+	handle_movablemem(node, start, end);
 
 	return 0;
 out_err_bad_srat:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
userns-improve-uid-gid-map-collision-detection-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
mutex-use-spin_lock-instead-of-arch_spin_lock-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


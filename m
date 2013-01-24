From: akpm@linux-foundation.org
Subject: + cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch added to -mm tree
Date: Wed, 23 Jan 2013 16:00:50 -0800
Message-ID: <20130124005214.153435A41E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35864 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3AXAwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 19:52:25 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so926872vbi.3
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 16:52:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com


The patch titled
     Subject: cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix
has been added to the -mm tree.  Its filename is
     cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch

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
Subject: cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix

numa_clear_node() and numa_set_node() can no longer be __cpuinit.

WARNING: vmlinux.o(.text+0x222702): Section mismatch in reference from the function check_and_unmap_cpu_on_node() to the function .cpuinit.text:numa_clear_node()
The function check_and_unmap_cpu_on_node() references
the function __cpuinit numa_clear_node().
This is often because check_and_unmap_cpu_on_node lacks a __cpuinit 
annotation or the annotation of numa_clear_node is wrong.


Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/numa.h |    4 ++--
 arch/x86/mm/numa.c          |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/numa.h~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix arch/x86/include/asm/numa.h
--- a/arch/x86/include/asm/numa.h~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix
+++ a/arch/x86/include/asm/numa.h
@@ -59,8 +59,8 @@ static inline int numa_cpu_node(int cpu)
 #endif
 
 #ifdef CONFIG_NUMA
-extern void __cpuinit numa_set_node(int cpu, int node);
-extern void __cpuinit numa_clear_node(int cpu);
+extern void numa_set_node(int cpu, int node);
+extern void numa_clear_node(int cpu);
 extern void __init init_cpu_to_node(void);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
diff -puN arch/x86/mm/numa.c~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix
+++ a/arch/x86/mm/numa.c
@@ -78,7 +78,7 @@ EXPORT_SYMBOL(node_to_cpumask_map);
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
-void __cpuinit numa_set_node(int cpu, int node)
+void numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
@@ -100,7 +100,7 @@ void __cpuinit numa_set_node(int cpu, in
 	set_cpu_numa_node(cpu, node);
 }
 
-void __cpuinit numa_clear_node(int cpu)
+void numa_clear_node(int cpu)
 {
 	numa_set_node(cpu, NUMA_NO_NODE);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
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
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
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
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
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
aio-smoosh-struct-kiocb-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


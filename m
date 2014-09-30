From: akpm@linux-foundation.org
Subject: +
 revert-x86-sched-add-new-topology-for-multi-numa-node-cpus.patch added to
 -mm tree
Date: Tue, 30 Sep 2014 12:22:04 -0700
Message-ID: <542b02dc.w6cm+VL4zf1nA75+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaI3TWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 15:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@linux.intel.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "x86, sched: Add new topology for multi-NUMA-node CPUs"
has been added to the -mm tree.  Its filename is
     revert-x86-sched-add-new-topology-for-multi-numa-node-cpus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-x86-sched-add-new-topology-for-multi-numa-node-cpus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-x86-sched-add-new-topology-for-multi-numa-node-cpus.patch

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
Subject: revert "x86, sched: Add new topology for multi-NUMA-node CPUs"

Revert

: commit cebf15eb09a2fd2fa73ee4faa9c4d2f813cf0f09
: Author: Dave Hansen <dave.hansen@linux.intel.com>
: Date:   Thu Sep 18 12:33:34 2014 -0700
: 
:     x86, sched: Add new topology for multi-NUMA-node CPUs

Due to mysterious loss of 75% of my CPU power.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smpboot.c |   55 +++++-------------------------------
 1 file changed, 9 insertions(+), 46 deletions(-)

diff -puN arch/x86/kernel/smpboot.c~revert-x86-sched-add-new-topology-for-multi-numa-node-cpus arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~revert-x86-sched-add-new-topology-for-multi-numa-node-cpus
+++ a/arch/x86/kernel/smpboot.c
@@ -266,19 +266,11 @@ void smp_store_cpu_info(int id)
 }
 
 static bool
-topology_same_node(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
-{
-	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
-
-	return (cpu_to_node(cpu1) == cpu_to_node(cpu2));
-}
-
-static bool
 topology_sane(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o, const char *name)
 {
 	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
 
-	return !WARN_ONCE(!topology_same_node(c, o),
+	return !WARN_ONCE(cpu_to_node(cpu1) != cpu_to_node(cpu2),
 		"sched: CPU #%d's %s-sibling CPU #%d is not on the same node! "
 		"[node: %d != %d]. Ignoring dependency.\n",
 		cpu1, name, cpu2, cpu_to_node(cpu1), cpu_to_node(cpu2));
@@ -319,42 +311,15 @@ static bool match_llc(struct cpuinfo_x86
 	return false;
 }
 
-/*
- * Unlike the other levels, we do not enforce keeping a
- * multicore group inside a NUMA node.  If this happens, we will
- * discard the MC level of the topology later.
- */
-static bool match_die(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	if (c->phys_proc_id == o->phys_proc_id)
-		return true;
-	return false;
-}
+	if (c->phys_proc_id == o->phys_proc_id) {
+		if (cpu_has(c, X86_FEATURE_AMD_DCM))
+			return true;
 
-static struct sched_domain_topology_level numa_inside_package_topology[] = {
-#ifdef CONFIG_SCHED_SMT
-	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
-#endif
-#ifdef CONFIG_SCHED_MC
-	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
-#endif
-	{ NULL, },
-};
-/*
- * set_sched_topology() sets the topology internal to a CPU.  The
- * NUMA topologies are layered on top of it to build the full
- * system topology.
- *
- * If NUMA nodes are observed to occur within a CPU package, this
- * function should be called.  It forces the sched domain code to
- * only use the SMT level for the CPU portion of the topology.
- * This essentially falls back to relying on NUMA information
- * from the SRAT table to describe the entire system topology
- * (except for hyperthreads).
- */
-static void primarily_use_numa_for_topology(void)
-{
-	set_sched_topology(numa_inside_package_topology);
+		return topology_sane(c, o, "mc");
+	}
+	return false;
 }
 
 void set_cpu_sibling_map(int cpu)
@@ -393,7 +358,7 @@ void set_cpu_sibling_map(int cpu)
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		o = &cpu_data(i);
 
-		if ((i == cpu) || (has_mp && match_die(c, o))) {
+		if ((i == cpu) || (has_mp && match_mc(c, o))) {
 			link_mask(core, cpu, i);
 
 			/*
@@ -415,8 +380,6 @@ void set_cpu_sibling_map(int cpu)
 			} else if (i != cpu && !c->booted_cores)
 				c->booted_cores = cpu_data(i).booted_cores;
 		}
-		if (match_die(c, o) == !topology_same_node(c, o))
-			primarily_use_numa_for_topology();
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch
mm.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private-fix.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
mm-debugc-use-pr_emerg.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
revert-x86-sched-add-new-topology-for-multi-numa-node-cpus.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


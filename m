From: akpm@linux-foundation.org
Subject: + revert-x86-remove-the-static-256k-node_to_cpumask_map.patch added to -mm tree
Date: Fri, 06 Jun 2008 03:54:19 -0700
Message-ID: <200806061054.m56AsJoa027037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755379AbYFFKyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 06:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, travis@sgi.com


The patch titled
     revert "x86: remove the static 256k node_to_cpumask_map"
has been added to the -mm tree.  Its filename is
     revert-x86-remove-the-static-256k-node_to_cpumask_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "x86: remove the static 256k node_to_cpumask_map"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit a9ad585c8a18f7ba754b85f5786976609b9d7d29
Author: Mike Travis <travis@sgi.com>
Date:   Mon May 12 21:21:12 2008 +0200

    x86: remove the static 256k node_to_cpumask_map
    
      * Consolidate node_to_cpumask operations and remove the 256k
        byte node_to_cpumask_map.  This is done by allocating the
        node_to_cpumask_map array after the number of possible nodes
        (nr_node_ids) is known.
    
      * Debug printouts when CONFIG_DEBUG_PER_CPU_MAPS is active have
        been increased.  It now shows faults when calling node_to_cpumask()
        and node_to_cpumask_ptr().
    
    For inclusion into sched-devel/latest tree.
    
    Based on:
    	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c    |  132 +----------------------------------
 arch/x86/mm/numa_64.c      |    6 +
 include/asm-x86/topology.h |   25 ++----
 3 files changed, 19 insertions(+), 144 deletions(-)

diff -puN arch/x86/kernel/setup.c~revert-x86-remove-the-static-256k-node_to_cpumask_map arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~revert-x86-remove-the-static-256k-node_to_cpumask_map
+++ a/arch/x86/kernel/setup.c
@@ -35,16 +35,6 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu
 /* map cpu index to node index */
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
-
-/* which logical CPUs are on which nodes */
-cpumask_t *node_to_cpumask_map;
-EXPORT_SYMBOL(node_to_cpumask_map);
-
-/* setup node_to_cpumask_map */
-static void __init setup_node_to_cpumask_map(void);
-
-#else
-static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
 #if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
@@ -191,15 +181,11 @@ void __init setup_per_cpu_areas(void)
 
 	}
 
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
-		NR_CPUS, nr_cpu_ids, nr_node_ids);
+	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d\n", NR_CPUS, nr_cpu_ids);
 
 	/* Setup percpu data maps */
 	setup_per_cpu_maps();
 
-	/* Setup node to cpumask map */
-	setup_node_to_cpumask_map();
-
 	/* Setup cpumask_of_cpu map */
 	setup_cpumask_of_cpu();
 }
@@ -220,35 +206,6 @@ void __cpuinit amd_enable_pci_ext_cfg(st
 #endif
 
 #ifdef X86_64_NUMA
-
-/*
- * Allocate node_to_cpumask_map based on number of available nodes
- * Requires node_possible_map to be valid.
- *
- * Note: node_to_cpumask() is not valid until after this is done.
- */
-static void __init setup_node_to_cpumask_map(void)
-{
-	unsigned int node, num = 0;
-	cpumask_t *map;
-
-	/* setup nr_node_ids if not done yet */
-	if (nr_node_ids == MAX_NUMNODES) {
-		for_each_node_mask(node, node_possible_map)
-			num = node;
-		nr_node_ids = num + 1;
-	}
-
-	/* allocate the map */
-	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
-
-	Dprintk(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
-		map, nr_node_ids);
-
-	/* node_to_cpumask() will now work */
-	node_to_cpumask_map = map;
-}
-
 void __cpuinit numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
@@ -271,8 +228,6 @@ void __cpuinit numa_clear_node(int cpu)
 	numa_set_node(cpu, NUMA_NO_NODE);
 }
 
-#ifndef CONFIG_DEBUG_PER_CPU_MAPS
-
 void __cpuinit numa_add_cpu(int cpu)
 {
 	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
@@ -282,44 +237,9 @@ void __cpuinit numa_remove_cpu(int cpu)
 {
 	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
 }
+#endif /* CONFIG_NUMA */
 
-#else /* CONFIG_DEBUG_PER_CPU_MAPS */
-
-/*
- * --------- debug versions of the numa functions ---------
- */
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
-{
-	int node = cpu_to_node(cpu);
-	cpumask_t *mask;
-	char buf[64];
-
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_ERR "node_to_cpumask_map NULL\n");
-		dump_stack();
-		return;
-	}
-
-	mask = &node_to_cpumask_map[node];
-	if (enable)
-		cpu_set(cpu, *mask);
-	else
-		cpu_clear(cpu, *mask);
-
-	cpulist_scnprintf(buf, sizeof(buf), *mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
- }
-
-void __cpuinit numa_add_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 1);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 0);
-}
+#if defined(CONFIG_DEBUG_PER_CPU_MAPS) && defined(CONFIG_X86_64)
 
 int cpu_to_node(int cpu)
 {
@@ -333,10 +253,6 @@ int cpu_to_node(int cpu)
 }
 EXPORT_SYMBOL(cpu_to_node);
 
-/*
- * Same function as cpu_to_node() but used if called before the
- * per_cpu areas are setup.
- */
 int early_cpu_to_node(int cpu)
 {
 	if (early_per_cpu_ptr(x86_cpu_to_node_map))
@@ -345,47 +261,9 @@ int early_cpu_to_node(int cpu)
 	if (!per_cpu_offset(cpu)) {
 		printk(KERN_WARNING
 			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
-		dump_stack();
+			dump_stack();
 		return NUMA_NO_NODE;
 	}
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
-
-/*
- * Returns a pointer to the bitmask of CPUs on Node 'node'.
- */
-cpumask_t *_node_to_cpumask_ptr(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
-			node);
-		dump_stack();
-		return &cpu_online_map;
-	}
-	return &node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(_node_to_cpumask_ptr);
-
-/*
- * Returns a bitmask of CPUs on Node 'node'.
- */
-cpumask_t node_to_cpumask(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"node_to_cpumask(%d): no node_to_cpumask_map!\n", node);
-		dump_stack();
-		return cpu_online_map;
-	}
-	return node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(node_to_cpumask);
-
-/*
- * --------- end of debug versions of the numa functions ---------
- */
-
-#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
-
-#endif /* X86_64_NUMA */
+#endif
diff -puN arch/x86/mm/numa_64.c~revert-x86-remove-the-static-256k-node_to_cpumask_map arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~revert-x86-remove-the-static-256k-node_to_cpumask_map
+++ a/arch/x86/mm/numa_64.c
@@ -35,6 +35,9 @@ s16 apicid_to_node[MAX_LOCAL_APIC] __cpu
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
+cpumask_t node_to_cpumask_map[MAX_NUMNODES] __read_mostly;
+EXPORT_SYMBOL(node_to_cpumask_map);
+
 int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
@@ -557,6 +560,9 @@ void __init numa_initmem_init(unsigned l
 	node_set(0, node_possible_map);
 	for (i = 0; i < NR_CPUS; i++)
 		numa_set_node(i, 0);
+	/* cpumask_of_cpu() may not be available during early startup */
+	memset(&node_to_cpumask_map[0], 0, sizeof(node_to_cpumask_map[0]));
+	cpu_set(0, node_to_cpumask_map[0]);
 	e820_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
 }
diff -puN include/asm-x86/topology.h~revert-x86-remove-the-static-256k-node_to_cpumask_map include/asm-x86/topology.h
--- a/include/asm-x86/topology.h~revert-x86-remove-the-static-256k-node_to_cpumask_map
+++ a/include/asm-x86/topology.h
@@ -57,16 +57,10 @@ static inline int cpu_to_node(int cpu)
 }
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
-/* Returns a bitmask of CPUs on Node 'node'. */
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return node_to_cpumask_map[node];
-}
-
 #else /* CONFIG_X86_64 */
 
 /* Mappings between node number and cpus on that node. */
-extern cpumask_t *node_to_cpumask_map;
+extern cpumask_t node_to_cpumask_map[];
 
 /* Mappings between logical cpu number and node number */
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
@@ -110,6 +104,7 @@ static inline cpumask_t node_to_cpumask(
 }
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
+#endif /* CONFIG_X86_64 */
 
 /* Replace default node_to_cpumask_ptr with optimized version */
 #define node_to_cpumask_ptr(v, node)		\
@@ -118,7 +113,12 @@ static inline cpumask_t node_to_cpumask(
 #define node_to_cpumask_ptr_next(v, node)	\
 			   v = _node_to_cpumask_ptr(node)
 
-#endif /* CONFIG_X86_64 */
+/* Returns the number of the first CPU on Node 'node'. */
+static inline int node_to_first_cpu(int node)
+{
+	node_to_cpumask_ptr(mask, node);
+	return first_cpu(*mask);
+}
 
 /*
  * Returns the number of the node containing Node 'node'. This
@@ -204,15 +204,6 @@ static inline int node_to_first_cpu(int 
 
 #include <asm-generic/topology.h>
 
-#ifdef CONFIG_NUMA
-/* Returns the number of the first CPU on Node 'node'. */
-static inline int node_to_first_cpu(int node)
-{
-	node_to_cpumask_ptr(mask, node);
-	return first_cpu(*mask);
-}
-#endif
-
 extern cpumask_t cpu_coregroup_map(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series.patch
rtc-class-driver-for-ppc_md-rtc-functions.patch
proc-calculate-the-correct-proc-pid-link-count.patch
linux-next.patch
next-remove-localversion.patch
linux-next-fixup.patch
linux-next-rtc-fix.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
drivers-net-usb-kawethc-fix-printk-warning.patch
mtd-unbork.patch
revert-x86-remove-the-static-256k-node_to_cpumask_map.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
lguest-use-cpu-capability-accessors.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning-checkpatch-fixes.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-leds.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
pci-introduce-pci_slot.patch
acpi-pci-slot-detection-driver.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix-2.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage-fix.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl-fix.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
forcedeth-msi-interrupts-uninlining.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
oprofile-multiplexing-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


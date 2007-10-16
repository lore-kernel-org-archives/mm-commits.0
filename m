From: akpm@linux-foundation.org
Subject: - git-mips-fixup.patch removed from -mm tree
Date: Mon, 15 Oct 2007 19:06:40 -0700
Message-ID: <200710160206.l9G26eQG003854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbXJPCGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 22:06:43 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l9G26e9j014880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 15 Oct 2007 19:06:41 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-mips-fixup
has been removed from the -mm tree.  Its filename was
     git-mips-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-mips-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/smp.c                |    4 ----
 arch/mips/mips-boards/generic/time.c  |    6 ------
 arch/mips/mm/c-r4k.c                  |    4 ----
 arch/mips/mm/pg-r4k.c                 |   12 ------------
 arch/mips/pmc-sierra/yosemite/setup.c |    9 ---------
 arch/mips/sgi-ip22/ip22-time.c        |    7 -------
 drivers/net/jazzsonic.c               |    7 -------
 7 files changed, 49 deletions(-)

diff -puN arch/mips/kernel/smp.c~git-mips-fixup arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c~git-mips-fixup
+++ a/arch/mips/kernel/smp.c
@@ -457,11 +457,7 @@ void flush_tlb_kernel_range(unsigned lon
 		.addr2 = end,
 	};
 
-<<<<<<< HEAD/arch/mips/kernel/smp.c
-	on_each_cpu(flush_tlb_kernel_range_ipi, &fd, 1, 1);
-=======
 	on_each_cpu(flush_tlb_kernel_range_ipi, (void *)&fd, 1, 1);
->>>>>>> /arch/mips/kernel/smp.c
 }
 
 static void flush_tlb_page_ipi(void *info)
diff -puN arch/mips/mips-boards/generic/time.c~git-mips-fixup arch/mips/mips-boards/generic/time.c
--- a/arch/mips/mips-boards/generic/time.c~git-mips-fixup
+++ a/arch/mips/mips-boards/generic/time.c
@@ -142,13 +142,7 @@ void __init plat_time_init(void)
         cpu_khz = est_freq / 1000;
 
 	mips_scroll_message();
-<<<<<<< HEAD/arch/mips/mips-boards/generic/time.c
-#ifdef CONFIG_I8253		/* Only Malta has a PIT */
 	setup_pit_timer();
-#endif
-=======
-	setup_pit_timer();
->>>>>>> /arch/mips/mips-boards/generic/time.c
 }
 
 //static irqreturn_t mips_perf_interrupt(int irq, void *dev_id)
diff -puN arch/mips/mm/c-r4k.c~git-mips-fixup arch/mips/mm/c-r4k.c
--- a/arch/mips/mm/c-r4k.c~git-mips-fixup
+++ a/arch/mips/mm/c-r4k.c
@@ -456,11 +456,7 @@ static inline void local_r4k_flush_cache
 			r4k_blast_scache_page(addr);
 	}
 	if (exec) {
-<<<<<<< HEAD/arch/mips/mm/c-r4k.c
-		if (vaddr && cpu_has_vtag_icache && mm == current->active_mm) {
-=======
 		if (vaddr && cpu_has_vtag_icache) {
->>>>>>> /arch/mips/mm/c-r4k.c
 			int cpu = smp_processor_id();
 
 			if (cpu_context(cpu, mm) != 0)
diff -puN arch/mips/mm/pg-r4k.c~git-mips-fixup arch/mips/mm/pg-r4k.c
--- a/arch/mips/mm/pg-r4k.c~git-mips-fixup
+++ a/arch/mips/mm/pg-r4k.c
@@ -527,17 +527,6 @@ dest = label();
 	build_jr_ra();
 
 	BUG_ON(epc > copy_page_array + ARRAY_SIZE(copy_page_array));
-<<<<<<< HEAD/arch/mips/mm/pg-r4k.c
-
-	pr_info("Synthesized copy page handler (%u instructions).\n",
-		(unsigned int)(epc - copy_page_array));
-
-	pr_debug("\t.set push\n");
-	pr_debug("\t.set noreorder\n");
-	for (i = 0; i < (epc - copy_page_array); i++)
-		pr_debug("\t.word 0x%08x\n", copy_page_array[i]);
-	pr_debug("\t.set pop\n");
-=======
 
 	pr_info("Synthesized copy page handler (%u instructions).\n",
 		(unsigned int)(epc - copy_page_array));
@@ -576,5 +565,4 @@ struct page * ____alloc_zeroed_user_high
 	smp_wmb();
 
 	return page;
->>>>>>> /arch/mips/mm/pg-r4k.c
 }
diff -puN arch/mips/mm/tlbex.c~git-mips-fixup arch/mips/mm/tlbex.c
diff -puN arch/mips/pmc-sierra/yosemite/setup.c~git-mips-fixup arch/mips/pmc-sierra/yosemite/setup.c
--- a/arch/mips/pmc-sierra/yosemite/setup.c~git-mips-fixup
+++ a/arch/mips/pmc-sierra/yosemite/setup.c
@@ -100,21 +100,12 @@ int rtc_mips_set_time(unsigned long tim)
 	struct rtc_time tm;
 	unsigned long flags;
 
-<<<<<<< HEAD/arch/mips/pmc-sierra/yosemite/setup.c
-	/*
-	 * Convert to a more useful format -- note months count from 0
-	 * and years from 1900
-	 */
-	rtc_time_to_tm(tim, &tm);
-	tm.tm_year += 1900;
-=======
 	/*
 	 * Convert to a more useful format -- note months count from 0
 	 * and years from 1900
 	 */
 	rtc_time_to_tm(sec, &tm);
 	tm.tm_year += 1900;
->>>>>>> /arch/mips/pmc-sierra/yosemite/setup.c
 	tm.tm_mon += 1;
 
 	spin_lock_irqsave(&rtc_lock, flags);
diff -puN arch/mips/sgi-ip22/ip22-time.c~git-mips-fixup arch/mips/sgi-ip22/ip22-time.c
--- a/arch/mips/sgi-ip22/ip22-time.c~git-mips-fixup
+++ a/arch/mips/sgi-ip22/ip22-time.c
@@ -173,15 +173,8 @@ __init void plat_time_init(void)
 		(int) (r4k_tick % (500000 / HZ)));
 
 	mips_hpt_frequency = r4k_tick * HZ;
-<<<<<<< HEAD/arch/mips/sgi-ip22/ip22-time.c
-
-	if (ip22_is_fullhouse())
-		setup_pit_timer();
-=======
-
 	if (ip22_is_fullhouse)
 		setup_pit_timer();
->>>>>>> /arch/mips/sgi-ip22/ip22-time.c
 }
 
 /* Generic SGI handler for (spurious) 8254 interrupts */
diff -puN drivers/net/jazzsonic.c~git-mips-fixup drivers/net/jazzsonic.c
--- a/drivers/net/jazzsonic.c~git-mips-fixup
+++ a/drivers/net/jazzsonic.c
@@ -211,13 +211,6 @@ static int __init jazz_sonic_probe(struc
 	int i;
 	DECLARE_MAC_BUF(mac);
 
-<<<<<<< HEAD/drivers/net/jazzsonic.c
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
-=======
->>>>>>> /drivers/net/jazzsonic.c
 	dev = alloc_etherdev(sizeof(struct sonic_local));
 	if (!dev)
 		return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
revert-gregkh-driver-spi-convert-from-class_device-to-device-for-spi.patch
git-dvb.patch
applesmc-for-mac-pro-2-x-quad-core-fix.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-jg-warning-fixes.patch
git-jg-misc-powernow-fix.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
git-md-accel-fixup.patch
git-mips-fixup.patch
forcedeth-power-down-phy-when-interface-is-down-checkpatch-fixes.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
git-nfs-fixup.patch
git-nfs-vs-git-unionfs.patch
git-nfsd-fixup.patch
git-sched.patch
git-scsi-misc-fixup.patch
qla2xxx-printk-fixes.patch
git-block.patch
git-block-fixup.patch
sparc-support-for-new-termios-checkpatch-fixes.patch
git-unionfs.patch
git-v9fs-fixup.patch
git-watchdog-fixup.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-ath5k-broke.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
asm-i386-ioh-fix-constness.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
git-xfs.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-sparc64-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
fs-restore-nobh-checkpatch-fixes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
writeback-dont-propagate-aop_writepage_activate.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
uml-clocksource-support-fix.patch
uml-tickless-support-fix.patch
uml-fix-stub-address-calculations-checkpatch-fixes.patch
uml-arch-um-drivers-formatting-checkpatch-fixes.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
f_dupfd_cloexec-implementation-fix-2.patch
ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch
drivers-char-ip2-fix-used-uninitd-bug-checkpatch-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
lockdep-annotate-kprobes-irq-fiddling-fix.patch
ecryptfs-printk-warning-fixes.patch
rtc-cmos-probe-cleanup-checkpatch-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
fbcon-logo-disable-logo-at-boot-fix.patch
fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes.patch
md-software-raid-autodetect-dev-list-not-array.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
pnp-use-dev_info-dev_err-etc-in-core-fix.patch
pnp-add-debug-message-for-adding-new-device-fix-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

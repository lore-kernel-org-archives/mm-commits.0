From: akpm@linux-foundation.org
Subject: - taskstats-add-context-switch-counters-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:57:35 -0700
Message-ID: <200707092157.l69Lvasv014716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41793 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478AbXGIV6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:58:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com, muvarov@ru.mvista.com, nagar@watson.ibm.com, mm-commits@vger.kernel.org


The patch titled
     taskstats-add-context-switch-counters-fix
has been removed from the -mm tree.  Its filename was
     taskstats-add-context-switch-counters-fix.patch

This patch was dropped because it was folded into taskstats-add-context-switch-counters.patch

------------------------------------------------------
Subject: taskstats-add-context-switch-counters-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c          |   10 +++++-----
 Documentation/accounting/taskstats-struct.txt |    2 +-
 fs/proc/array.c                               |    6 ++++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff -puN Documentation/accounting/getdelays.c~taskstats-add-context-switch-counters-fix Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~taskstats-add-context-switch-counters-fix
+++ a/Documentation/accounting/getdelays.c
@@ -49,7 +49,7 @@ char name[100];
 int dbg;
 int print_delays;
 int print_io_accounting;
-int print_task_context_switch_rates;
+int print_task_context_switch_counts;
 __u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
@@ -205,7 +205,7 @@ void print_delayacct(struct taskstats *t
 	       "count", "delay total", t->swapin_count, t->swapin_delay_total);
 }
 
-void task_context_switch_rates(struct taskstats *t)
+void task_context_switch_counts(struct taskstats *t)
 {
 	printf("\n\nTask   %15s%15s\n"
 	       "       %15lu%15lu\n",
@@ -259,7 +259,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'q':
 			printf("printing task/process context switch rates\n");
-			print_task_context_switch_rates = 1;
+			print_task_context_switch_counts = 1;
 			break;
 		case 'w':
 			logfile = strdup(optarg);
@@ -402,8 +402,8 @@ int main(int argc, char *argv[])
 							print_delayacct((struct taskstats *) NLA_DATA(na));
 						if (print_io_accounting)
 							print_ioacct((struct taskstats *) NLA_DATA(na));
-						if (print_task_context_switch_rates)
-							task_context_switch_rates((struct taskstats *) NLA_DATA(na));
+						if (print_task_context_switch_counts)
+							task_context_switch_counts((struct taskstats *) NLA_DATA(na));
 						if (fd) {
 							if (write(fd, NLA_DATA(na), na->nla_len) < 0) {
 								err(1,"write error\n");
diff -puN Documentation/accounting/taskstats-struct.txt~taskstats-add-context-switch-counters-fix Documentation/accounting/taskstats-struct.txt
--- a/Documentation/accounting/taskstats-struct.txt~taskstats-add-context-switch-counters-fix
+++ a/Documentation/accounting/taskstats-struct.txt
@@ -22,7 +22,7 @@ There are three different groups of fiel
     /* Extended accounting fields end */
     Their values are collected if CONFIG_TASK_XACCT is set.
 
-4) Per-task and per-thread context switch rates statistics
+4) Per-task and per-thread context switch count statistics
 
 Future extension should add fields to the end of the taskstats struct, and
 should not change the relative position of each field within the struct.
diff -puN fs/proc/array.c~taskstats-add-context-switch-counters-fix fs/proc/array.c
--- a/fs/proc/array.c~taskstats-add-context-switch-counters-fix
+++ a/fs/proc/array.c
@@ -290,7 +290,9 @@ static inline char *task_cap(struct task
 			    cap_t(p->cap_permitted),
 			    cap_t(p->cap_effective));
 }
-static inline char *task_context_switch_rates(struct task_struct *p, char *buffer)
+
+static inline char *task_context_switch_counts(struct task_struct *p,
+						char *buffer)
 {
 	return buffer + sprintf(buffer, "voluntary_ctxt_switches:\t%lu\n"
 			    "nonvoluntary_ctxt_switches:\t%lu\n",
@@ -316,7 +318,7 @@ int proc_pid_status(struct task_struct *
 #if defined(CONFIG_S390)
 	buffer = task_show_regs(task, buffer);
 #endif
-	buffer = task_context_switch_rates(task, buffer);
+	buffer = task_context_switch_counts(task, buffer);
 	return buffer - orig;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-acpi.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
revert-saa7134-fix-thread-shutdown-handling.patch
git-dvb.patch
git-dvb-saa7134-tvaudio-fix.patch
git-gfs2-nmw.patch
git-infiniband.patch
git-input.patch
serio_raw_read-warning-fix.patch
tsdev-fix-broken-usecto-millisecs-conversion.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-leds.patch
led_colour_show-warning-fix.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-md-accel.patch
git-mips-fixup.patch
git-mtd.patch
mtd-onenand-build-fix.patch
git-ubi.patch
git-netdev-all.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-battery-vs-git-acpi.patch
git-ioat-vs-git-md-accel.patch
revert-gregkh-pci-pci_bridge-device.patch
fix-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
pci-x-pci-express-read-control-interfaces-fix.patch
revert-acpi-change-for-scsi.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
restore-acpi-change-for-scsi.patch
git-scsi-misc-vs-greg-sysfs-stuff.patch
aacraid-rename-check_reset.patch
git-scsi-target-fixup.patch
splicec-revert-git-selinux-changes-so-that-git-block-will-apply.patch
git-block-fixup.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-show-unhandled-signals.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
i386-add-cpu_relax-to-cmos_lock.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
x86_64-add-ioapic-nmi-support.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
git-newsetup-fixup.patch
git-xfs.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-kgdb-fixup.patch
kgdb-warning-fix.patch
kgdb-kconfig-fix.patch
kgdb-use-new-style-interrupt-flags.patch
kgdb-section-fix.patch
kgdb_skipexception-warning-fix.patch
kgdb-ia64-fixes.patch
kgdb-bust-on-ia64.patch
kgdb-build-fix-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-zonelist-order-selection-logic.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
fix-alpha-isa-support.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mpu401-warning-fixes.patch
vdso-print-fatal-signals.patch
o_cloexec-for-scm_rights.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each.patch
ext3-ext4-orphan-list-check-on-destroy_inode.patch
taskstats-add-context-switch-counters.patch
taskstats-add-context-switch-counters-fix.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
audit-add-tty-input-auditing-fix-2.patch
revert-vanishing-ioctl-handler-debugging.patch
binfmt_elf-warning-fix.patch
dirty_writeback_centisecs_handler-cleanup.patch
diskquota-32bit-quota-tools-on-64bit-architectures-fix-fix.patch
sys_time-speedup-build-fixes.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
hfs-refactor-ascii-to-unicode-conversion-routine-fix.patch
sprint_symbol-cleanup.patch
replace-obscure-constructs-in-fs-block_devc-fix.patch
bd_claim_by_disk-fix-warning.patch
uninline-check_signature.patch
uninline-check_signature-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
spi-master-driver-for-xilinx-virtex-fix.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
rtc-add-rtc-m41t80-driver-take-2-fix.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch
rtc-driver-for-ds1216-chips-fix.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
lguest-the-host-code.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code-fix.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-iommu-floppy-workaround-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
cfs-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockdep-various-fixes-checkpatch.patch
lockstat-measure-lock-bouncing-checkpatch.patch
reiser4.patch
reiser4-fix.patch
git-block-vs-reiser4.patch
allow-page_owner-to-be-set-on-any-architecture-fix.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch

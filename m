From: akpm@linux-foundation.org
Subject: + taskstats-add-context-switch-counters-fix.patch added to -mm tree
Date: Tue, 05 Jun 2007 23:38:49 -0700
Message-ID: <200706060638.l566cnjg011046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965110AbXFFGjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 02:39:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com, muvarov@ru.mvista.com, nagar@watson.ibm.com


The patch titled
     taskstats-add-context-switch-counters-fix
has been added to the -mm tree.  Its filename is
     taskstats-add-context-switch-counters-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

document-acked-by.patch
git-acpi.patch
git-acpi-tickh-needs-hrtimerh.patch
git-acpi-add-exports.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-input-fixup.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
git-md-accel.patch
git-md-accel-fixup.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
git-xfs.patch
git-cryptodev.patch
git-xtensa.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-allow-tunable-policy-for-system-init-fix.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each-fix.patch
ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
taskstats-add-context-switch-counters-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
lguest-the-net-driver-include-fix.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
audit-rework-execve-audit-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch

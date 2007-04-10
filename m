From: akpm@linux-foundation.org
Subject: + revert-gregkh-driver-sysfs-crash-debugging.patch added to -mm tree
Date: Tue, 10 Apr 2007 13:43:47 -0700
Message-ID: <200704102043.l3AKhlcI016831@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030591AbXDJUnv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 16:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, htejun@gmail.com


The patch titled
     revert gregkh-driver-sysfs-crash-debugging
has been added to the -mm tree.  Its filename is
     revert-gregkh-driver-sysfs-crash-debugging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert gregkh-driver-sysfs-crash-debugging
From: Andrew Morton <akpm@linux-foundation.org>

It gets tangled up with Tejun's stuff

Cc: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c   |    1 -
 arch/x86_64/kernel/traps.c |    1 -
 fs/sysfs/file.c            |   14 --------------
 include/linux/sysfs.h      |    6 ------
 4 files changed, 22 deletions(-)

diff -puN arch/i386/kernel/traps.c~revert-gregkh-driver-sysfs-crash-debugging arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~revert-gregkh-driver-sysfs-crash-debugging
+++ a/arch/i386/kernel/traps.c
@@ -425,7 +425,6 @@ void die(const char * str, struct pt_reg
 #endif
 		if (nl)
 			printk("\n");
-		sysfs_printk_last_file();
 		if (notify_die(DIE_OOPS, str, regs, err,
 					current->thread.trap_no, SIGSEGV) !=
 				NOTIFY_STOP) {
diff -puN arch/x86_64/kernel/traps.c~revert-gregkh-driver-sysfs-crash-debugging arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~revert-gregkh-driver-sysfs-crash-debugging
+++ a/arch/x86_64/kernel/traps.c
@@ -533,7 +533,6 @@ void __kprobes __die(const char * str, s
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
-	sysfs_printk_last_file();
 	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
 	show_registers(regs);
 	/* Executive summary in case the oops scrolled away */
diff -puN fs/sysfs/file.c~revert-gregkh-driver-sysfs-crash-debugging fs/sysfs/file.c
--- a/fs/sysfs/file.c~revert-gregkh-driver-sysfs-crash-debugging
+++ a/fs/sysfs/file.c
@@ -8,7 +8,6 @@
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
-#include <linux/limits.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 
@@ -17,13 +16,6 @@
 #define to_subsys(k) container_of(k,struct subsystem,kset.kobj)
 #define to_sattr(a) container_of(a,struct subsys_attribute,attr)
 
-/* used in crash dumps to help with debugging */
-static char last_sysfs_file[PATH_MAX];
-void sysfs_printk_last_file(void)
-{
-	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
-}
-
 /*
  * Subsystem file operations.
  * These operations allow subsystems to have files that can be 
@@ -291,12 +283,6 @@ static int sysfs_open_file(struct inode 
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error = 0;
-	char *p;
-
-	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
-		   sizeof(last_sysfs_file));
-	if (p)
-		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	if (!kobj || !attr)
 		goto Einval;
diff -puN include/linux/sysfs.h~revert-gregkh-driver-sysfs-crash-debugging include/linux/sysfs.h
--- a/include/linux/sysfs.h~revert-gregkh-driver-sysfs-crash-debugging
+++ a/include/linux/sysfs.h
@@ -125,7 +125,6 @@ void sysfs_remove_file_from_group(struct
 		const struct attribute *attr, const char *group);
 
 void sysfs_notify(struct kobject * k, char *dir, char *attr);
-void sysfs_printk_last_file(void);
 
 
 extern int sysfs_make_shadowed_dir(struct kobject *kobj,
@@ -241,11 +240,6 @@ static inline int __must_check sysfs_ini
 	return 0;
 }
 
-static inline void sysfs_printk_last_file(void)
-{
-	;
-}
-
 #endif /* CONFIG_SYSFS */
 
 #endif /* _SYSFS_H_ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86_64-early-quirks-fix-early_qrk-section-tag.patch
i386-irqbalance_disable-section-fix.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-avr32.patch
git-avr32-fixup.patch
revert-gregkh-driver-sysfs-crash-debugging.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
git-ocfs2.patch
git-parisc.patch
git-r8169-fixup.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-fix-amd64-agp-aperture-validation.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
xfs-clean-up-shrinker-games.patch
pktgen-add-try_to_freeze.patch
acpi-thermal-fix-mod_timer-interval.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
undo-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch

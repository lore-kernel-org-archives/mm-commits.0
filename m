From: akpm@osdl.org
Subject: + add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch added to -mm tree
Date: Thu, 11 Jan 2007 16:44:48 -0800
Message-ID: <200701120045.l0C0jPVV008209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48097 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbXALAph (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 19:45:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, tytso@mit.edu


The patch titled
     add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2
has been added to the -mm tree.  Its filename is
     add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2
From: Andrew Morton <akpm@osdl.org>

kernel/built-in.o:(.data+0x44e8): undefined reference to `proc_dointvec_taint'

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/sysctl.c~add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2 kernel/sysctl.c
--- a/kernel/sysctl.c~add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2
+++ a/kernel/sysctl.c
@@ -151,6 +151,8 @@ static int sysctl_ipc_data(ctl_table *ta
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
+static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
 static ctl_table root_table[];
@@ -174,8 +176,6 @@ extern ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
-static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
-			       void __user *buffer, size_t *lenp, loff_t *ppos);
 
 static void *get_uts(ctl_table *table, int write)
 {
@@ -347,6 +347,7 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+#ifdef CONFIG_PROC_SYSCTL
 	{
 		.ctl_name	= KERN_TAINTED,
 		.procname	= "tainted",
@@ -355,6 +356,7 @@ static ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_taint,
 	},
+#endif
 	{
 		.ctl_name	= KERN_CAP_BSET,
 		.procname	= "cap-bound",
@@ -1983,9 +1985,8 @@ static int proc_dointvec_taint(ctl_table
 {
 	int op;
 
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	}
 
 	op = OP_OR;
 	return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
nfs-fix-race-in-nfs_release_page.patch
fd_zero-build-fix.patch
blockdev-direct_io-fix-signedness-bug.patch
submitchecklist-update.patch
tlclk-bug-fix-misc-fixes-tidy.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled-tidy.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
agpgart-allow-drm-populated-agp-memory-types-tidy.patch
cifs-sprintf-fix.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
libata-piix3-support-warning-fix.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-missing-include.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls-fix.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
r8169-warning-fixes.patch
git-scsi-rc-fixes.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-fixup.patch
git-block-atomicity-fix.patch
nokia-e70-is-an-unusual-device.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch
remove-invalidate_inode_pages.patch
add-an-rcu-version-of-list-splicing-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
vmi-versus-hrtimers.patch
gtod-persistent-clock-support-i386.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
debugging-feature-proc-timer_list-warning-fix.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
user-ns-implement-user-ns-unshare-tidy.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

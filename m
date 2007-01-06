From: akpm@osdl.org
Subject: - down_write-preserve-local-irqs.patch removed from -mm tree
Date: Fri, 05 Jan 2007 16:09:10 -0800
Message-ID: <200701060009.l0609cnM011039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44498 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbXAFAKJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 19:10:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, 76306.1226@compuserve.com, agalanin@mera.ru, ard@telegraafnet.nl, ebiederm@xmission.com, greg@kroah.com, take@libero.it, yanmin.zhang@intel.com, yinghai.lu@amd.com, mm-commits@vger.kernel.org


The patch titled
     down_write()/down_read(): preserve local irqs
has been removed from the -mm tree.  Its filename was
     down_write-preserve-local-irqs.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: down_write()/down_read(): preserve local irqs
From: Andrew Morton <akpm@osdl.org>

Various people have reported machines failing to boot since pci_bus_sem was
switched from a spinlock to an rwsem.

The reason for this is that these people had "ide=" on the kernel commandline,
and ide_setup() can end up calling PCI functions which do
down_read(&pci_bus_sem).


Ard has worked out the call tree:

init/main.c         start_kernel
kernel/params.c      parse_args("Booting kernel"
kernel/params.c       parse_one
drivers/ide/ide.c      ide_setup
drivers/ide/ide.c       init_ide_data
drivers/ide/ide.c        init_hwif_default
include/asm-i386/ide.h    ide_default_io_base(index)
drivers/pci/search.c       pci_find_device
drivers/pci/search.c        pci_find_subsys
                             down_read(&pci_bus_sem);


down_read() will unconditionally enable interrupts and some early interrupt
(source unknown) comes in and whacks the machine, apparently because the LDT
isn't set up yet.


Cc: Ard -kwaak- van Breemen <ard@telegraafnet.nl>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Chuck Ebbert <76306.1226@compuserve.com>
Cc: Yinghai Lu <yinghai.lu@amd.com>
Cc: <take@libero.it>
Cc: <agalanin@mera.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/rwsem-spinlock.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff -puN lib/rwsem-spinlock.c~down_write-preserve-local-irqs lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c~down_write-preserve-local-irqs
+++ a/lib/rwsem-spinlock.c
@@ -129,13 +129,14 @@ void fastcall __sched __down_read(struct
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
+	unsigned long flags;
 
-	spin_lock_irq(&sem->wait_lock);
+	spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
 		/* granted */
 		sem->activity++;
-		spin_unlock_irq(&sem->wait_lock);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
 		goto out;
 	}
 
@@ -150,7 +151,7 @@ void fastcall __sched __down_read(struct
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irq(&sem->wait_lock);
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	/* wait to be given the lock */
 	for (;;) {
@@ -195,13 +196,14 @@ void fastcall __sched __down_write_neste
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
+	unsigned long flags;
 
-	spin_lock_irq(&sem->wait_lock);
+	spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
 		/* granted */
 		sem->activity = -1;
-		spin_unlock_irq(&sem->wait_lock);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
 		goto out;
 	}
 
@@ -216,7 +218,7 @@ void fastcall __sched __down_write_neste
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irq(&sem->wait_lock);
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	/* wait to be given the lock */
 	for (;;) {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix.patch
pci-prevent-down_read-when-pci_devices-is-empty-fix.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
ip2-warning-fix.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled-tidy.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
sound-hda-detect-alc883-on-msi-k9a-platinum-motherboards.patch
cifs-sprintf-fix.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-missing-include.patch
ubiioc-needs-schedh.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
r8169-warning-fixes.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-atomicity-fix.patch
nokia-e70-is-an-unusual-device.patch
sisusb_con-warning-fixes.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
fix-fake-numa-for-x86_64-machines-with-big-io-hole.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
bluetooth-blacklist-lenovo-r60e.patch
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
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
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
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
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

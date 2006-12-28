From: akpm@osdl.org
Subject: + pci-avoid-taking-pci_bus_sem-early-in-boot.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:52:24 -0800
Message-ID: <200612282352.kBSNqO69016601@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43303 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbWL1Xwp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:52:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, 76306.1226@compuserve.com, agalanin@mera.ru, ard@telegraafnet.nl, ebiederm@xmission.com, greg@kroah.com, take@libero.it, yanmin.zhang@intel.com, yinghai.lu@amd.com


The patch titled
     pci-avoid-taking-pci_bus_sem-early-in-boot
has been added to the -mm tree.  Its filename is
     pci-avoid-taking-pci_bus_sem-early-in-boot.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci-avoid-taking-pci_bus_sem-early-in-boot
From: Andrew Morton <akpm@osdl.org>

Various people have reported machines failing to boot since pci_bus_sem was
switched from a spinlock to an rwsem.

The reason for this is that these people had "ide=" on the kernel command
line, and ide_setup() can end up calling PCI functions which do
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

Fix that by avoiding taking the semaphore in the PCI code in this situation.

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

 drivers/pci/search.c |   10 ++++++++++
 1 files changed, 10 insertions(+)

diff -puN drivers/pci/search.c~pci-avoid-taking-pci_bus_sem-early-in-boot drivers/pci/search.c
--- a/drivers/pci/search.c~pci-avoid-taking-pci_bus_sem-early-in-boot
+++ a/drivers/pci/search.c
@@ -259,6 +259,16 @@ pci_get_subsys(unsigned int vendor, unsi
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
+	/*
+	 * pci_get_subsys() can be called on the ide_setup() path, super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect that situation
+	 * and bail out early.
+	 */
+	if (unlikely(list_empty(pci_devices)))
+		return NULL;
+
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 
_

Patches currently in -mm which might be from akpm@osdl.org are

cpuset-procfs-warning-fix.patch
lockdep-printk-warning-fix.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-agpgart.patch
cifs-sprintf-fix.patch
git-cpufreq.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-iee1394-printk-warning-fix.patch
git-ieee1394-build-fix.patch
git-ieee1394-build-fix-2.patch
git-ieee1394-build-fix-3.patch
git-input.patch
git-libata-all.patch
git-libata-all-fixup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
git-ubi-build-fix.patch
git-ubi-mtd_read-arg-fix.patch
ubi-missing-include.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
add-i386-idle-notifier-take-3-fix.patch
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
schedule_on_each_cpu-use-preempt_disable.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
spi-controller-driver-for-omap-microwire-tidy.patch
vmi-versus-hrtimers.patch
gtod-persistent-clock-support-i386.patch
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
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
fsaio-filesystem-aio-read-tidy.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
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
pci-avoid-taking-pci_bus_sem-early-in-boot.patch


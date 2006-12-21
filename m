From: akpm@osdl.org
Subject: + increase-cardbus_mem_size.patch added to -mm tree
Date: Wed, 20 Dec 2006 23:58:42 -0800
Message-ID: <200612210758.kBL7wgpQ019964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47088 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422827AbWLUH6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 02:58:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, daniel.ritz@gmx.ch, linux@dominikbrodowski.net, mrechberger@gmail.com, torvalds@osdl.org


The patch titled
     increase CARDBUS_MEM_SIZE
has been added to the -mm tree.  Its filename is
     increase-cardbus_mem_size.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: increase CARDBUS_MEM_SIZE
From: Andrew Morton <akpm@osdl.org>

Linus sayeth:

Google knows everything, and finds, on MS own site no less:

  "Windows 2000 default resources:

   One 4K memory window

   One 2 MB memory window

   Two 256-byte I/O windows"

which is clearly utterly bogus and insufficient. But Microsoft apparently 
realized this, and:

  "Windows XP default resources:

   Because one memory window of 4K and one window of 2 MB are not 
   sufficient for CardBus controllers in many configurations, Windows XP 
   allocates larger memory windows to CardBus controllers where possible. 
   However, resource windows are static (that is, the operating system 
   does not dynamically allocate larger memory windows if new devices 
   appear.) Under Windows XP, CardBus controllers will be assigned the 
   following resources:

   One 4K memory window, as in Windows 2000

   64 MB memory, if that amount of memory is available. If 64 MB is not 
   available the controller will receive 32 MB; if 32 MB is not available, 
   the controller will receive 16 MB; if 16 MB is not available, the 
   bridge will receive 8 MB; and so on down to a minimum assignment of 1 
   MB in configurations where memory is too constrained for the operating 
   system to provide a larger window.

   Two 256-byte I/O windows"

So I think we have our answer. Windows uses one 4k window, and one 64MB 
window. And they are no more dynamic than we are (we _could_ try to do it 
dynamically, but let's face it, it's fairly painful to dynamically expand 
PCI bus resources - you may need to reprogram everything up to the root, 
so it would be absolutely crazy to do that unless you have some serious 
masochistic tendencies).

So let's just increase our default value to 64M too.

Cc: Markus Rechberger <mrechberger@gmail.com>
Cc: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/setup-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/setup-bus.c~increase-cardbus_mem_size drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~increase-cardbus_mem_size
+++ a/drivers/pci/setup-bus.c
@@ -41,7 +41,7 @@
  * have a P2P bridge below a cardbus bridge, we need 4K.
  */
 #define CARDBUS_IO_SIZE		(256)
-#define CARDBUS_MEM_SIZE	(32*1024*1024)
+#define CARDBUS_MEM_SIZE	(64*1024*1024)
 
 static void __devinit
 pbus_assign_resources_sorted(struct pci_bus *bus)
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
try_to_free_buffers-dont-clear-pte-dirty-bits.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
schedule_timeout-improve-warning-message.patch
relay-remove-inlining.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
arm-systemh-build-fix.patch
cifs-sprintf-fix.patch
git-drm.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
driver-for-silan-sc92031-netdev.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-disable-multithreaded-probing.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
funsoft-is-bust-on-sparc.patch
nokia-e70-is-an-unusual-device.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
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
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
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
increase-cardbus_mem_size.patch


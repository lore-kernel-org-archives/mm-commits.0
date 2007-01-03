From: akpm@osdl.org
Subject: + kblockd-use-flush_work.patch added to -mm tree
Date: Tue, 02 Jan 2007 16:19:40 -0800
Message-ID: <200701030019.l030Jf9O002345@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48649 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXACAUN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 19:20:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, axboe@suse.de, dhowells@redhat.com, macro@linux-mips.org, nickpiggin@yahoo.com.au, oleg@tv-sign.ru


The patch titled
     kblockd: use flush_work
has been added to the -mm tree.  Its filename is
     kblockd-use-flush_work.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kblockd: use flush_work
From: Andrew Morton <akpm@osdl.org>

Switch the kblockd flushing from a global flush to a more specific
flush_work().

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jens Axboe <axboe@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/as-iosched.c     |    2 +-
 block/ll_rw_blk.c      |    8 ++++----
 include/linux/blkdev.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN block/as-iosched.c~kblockd-use-flush_work block/as-iosched.c
--- a/block/as-iosched.c~kblockd-use-flush_work
+++ a/block/as-iosched.c
@@ -1306,7 +1306,7 @@ static void as_exit_queue(elevator_t *e)
 	struct as_data *ad = e->elevator_data;
 
 	del_timer_sync(&ad->antic_timer);
-	kblockd_flush();
+	kblockd_flush_work(&ad->antic_work);
 
 	BUG_ON(!list_empty(&ad->fifo_list[REQ_SYNC]));
 	BUG_ON(!list_empty(&ad->fifo_list[REQ_ASYNC]));
diff -puN block/ll_rw_blk.c~kblockd-use-flush_work block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~kblockd-use-flush_work
+++ a/block/ll_rw_blk.c
@@ -1712,7 +1712,7 @@ EXPORT_SYMBOL(blk_stop_queue);
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->unplug_timer);
-	kblockd_flush();
+	kblockd_flush_work(&q->unplug_work);
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -3629,11 +3629,11 @@ int kblockd_schedule_work(struct work_st
 
 EXPORT_SYMBOL(kblockd_schedule_work);
 
-void kblockd_flush(void)
+void kblockd_flush_work(struct work_struct *work)
 {
-	flush_workqueue(kblockd_workqueue);
+	flush_work(kblockd_workqueue, work);
 }
-EXPORT_SYMBOL(kblockd_flush);
+EXPORT_SYMBOL(kblockd_flush_work);
 
 int __init blk_dev_init(void)
 {
diff -puN include/linux/blkdev.h~kblockd-use-flush_work include/linux/blkdev.h
--- a/include/linux/blkdev.h~kblockd-use-flush_work
+++ a/include/linux/blkdev.h
@@ -854,7 +854,7 @@ static inline void put_dev_sector(Sector
 
 struct work_struct;
 int kblockd_schedule_work(struct work_struct *work);
-void kblockd_flush(void);
+void kblockd_flush_work(struct work_struct *work);
 
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
 	MODULE_ALIAS("block-major-" __stringify(major) "-" __stringify(minor))
_

Patches currently in -mm which might be from akpm@osdl.org are

start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix.patch
pci-prevent-down_read-when-pci_devices-is-empty-fix.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
sound-hda-detect-alc883-on-msi-k9a-platinum-motherboards.patch
git-agpgart.patch
cifs-sprintf-fix.patch
git-cpufreq.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
git-libata-all-fixup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
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
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
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
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
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

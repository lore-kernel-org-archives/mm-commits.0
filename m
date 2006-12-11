From: akpm@osdl.org
Subject: + lumpy-reclaim-v2-tidy.patch added to -mm tree
Date: Mon, 11 Dec 2006 15:28:44 -0800
Message-ID: <200612112328.kBBNSioN012458@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbWLKX3W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 18:29:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, a.p.zijlstra@chello.nl, apw@shadowen.org


The patch titled
     lumpy-reclaim-v2-tidy
has been added to the -mm tree.  Its filename is
     lumpy-reclaim-v2-tidy.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lumpy-reclaim-v2-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/swap.h |    3 ++-
 mm/vmscan.c          |   35 +++++++++++++++++++++--------------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff -puN include/linux/swap.h~lumpy-reclaim-v2-tidy include/linux/swap.h
--- a/include/linux/swap.h~lumpy-reclaim-v2-tidy
+++ a/include/linux/swap.h
@@ -186,7 +186,8 @@ extern int rotate_reclaimable_page(struc
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
-extern unsigned long try_to_free_pages(struct zone **, int, gfp_t);
+extern unsigned long try_to_free_pages(struct zone **zones, int order,
+					gfp_t gfp_mask);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
diff -puN mm/vmscan.c~lumpy-reclaim-v2-tidy mm/vmscan.c
--- a/mm/vmscan.c~lumpy-reclaim-v2-tidy
+++ a/mm/vmscan.c
@@ -605,12 +605,12 @@ keep:
 }
 
 /*
- * Attempt to remove the specified page from its LRU.  Only take this
- * page if it is of the appropriate PageActive status.  Pages which
- * are being freed elsewhere are also ignored.
+ * Attempt to remove the specified page from its LRU.  Only take this page if it
+ * is of the appropriate PageActive status.  Pages which are being freed
+ * elsewhere are also ignored.
  *
- * @page:	page to consider
- * @active:	active/inactive flag only take pages of this type
+ * page:	page to consider
+ * active:	active/inactive flag only take pages of this type
  *
  * returns 0 on success, -ve errno on failure.
  */
@@ -648,6 +648,7 @@ int __isolate_lru_page(struct page *page
  * @src:	The LRU list to pull pages off.
  * @dst:	The temp list to put pages on to.
  * @scanned:	The number of pages that were scanned.
+ * @order:	The caller's attempted allocation order
  *
  * returns how many pages were moved onto *@dst.
  */
@@ -656,12 +657,16 @@ static unsigned long isolate_lru_pages(u
 		unsigned long *scanned, int order)
 {
 	unsigned long nr_taken = 0;
-	struct page *page, *tmp;
-	unsigned long scan, pfn, end_pfn, page_pfn;
-	int active;
-	int zone_id;
+	unsigned long scan;
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
+		struct page *page;
+		unsigned long pfn;
+		unsigned long end_pfn;
+		unsigned long page_pfn;
+		int active;
+		int zone_id;
+
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
 
@@ -696,24 +701,26 @@ static unsigned long isolate_lru_pages(u
 		pfn = page_pfn & ~((1 << order) - 1);
 		end_pfn = pfn + (1 << order);
 		for (; pfn < end_pfn; pfn++) {
+			struct page *cursor_page;
+
 			if (unlikely(pfn == page_pfn))
 				continue;
 			if (unlikely(!pfn_valid(pfn)))
 				break;
 
-			tmp = __pfn_to_page(pfn);
-			if (unlikely(page_zone_id(tmp) != zone_id))
+			cursor_page = __pfn_to_page(pfn);
+			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
 			scan++;
-			switch (__isolate_lru_page(tmp, active)) {
+			switch (__isolate_lru_page(cursor_page, active)) {
 			case 0:
-				list_move(&tmp->lru, dst);
+				list_move(&cursor_page->lru, dst);
 				nr_taken++;
 				break;
 
 			case -EBUSY:
 				/* else it is being freed elsewhere */
-				list_move(&tmp->lru, src);
+				list_move(&cursor_page->lru, src);
 			default:
 				break;
 			}
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
x86-smp-export-smp_num_siblings-for-oprofile.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
alsa-workqueue-fixes.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input-vs-git-alsa.patch
git-libata-all-fixup.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-mtd-build-fix.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-net.patch
net-use-bitrev8.patch
netpoll-fix-local_bh_enable-warning.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
revert-git-block.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-tidy.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
ecryptfs-public-key-packet-management-slab-fix.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
lockdep-fix-possible-races-while-disabling-lock-debugging-fix.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
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
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
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
squash-ipc-warnings.patch
squash-udf-warnings.patch


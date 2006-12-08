From: akpm@osdl.org
Subject: - io-accounting-read-accounting.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:16 -0800
Message-ID: <200612081105.kB8B5GVr018627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425384AbWLHLGF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:06:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, balbir@in.ibm.com, csturtiv@sgi.com, guillaume.thouvenin@bull.net, jlan@sgi.com, nagar@watson.ibm.com, tee@sgi.com, mm-commits@vger.kernel.org


The patch titled
     io-accounting: read accounting
has been removed from the -mm tree.  Its filename was
     io-accounting-read-accounting.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: io-accounting: read accounting
From: Andrew Morton <akpm@osdl.org>

Account for the number of storage-level byte reads which this process caused
to happen.

This is a bit trickier due to the need to handle ->readpages.  It's OK if the
filesystem is using all the generic stuff, but if the filesystem is going it
alone then more work is needed.

Perhaps all this should have been done at the submit_bio level.  But that
would subvert things like NFS, and NFS is an open question at this stage.

We don't account for things like filesystem metadata reads yet.

Cc: Jay Lan <jlan@sgi.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Chris Sturtivant <csturtiv@sgi.com>
Cc: Tony Ernst <tee@sgi.com>
Cc: Guillaume Thouvenin <guillaume.thouvenin@bull.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/mpage.c              |    2 ++
 fs/namei.c              |    2 +-
 fs/splice.c             |    4 ++--
 include/linux/pagemap.h |   11 ++++++++++-
 mm/filemap.c            |   13 +++++++------
 mm/readahead.c          |    2 +-
 6 files changed, 23 insertions(+), 11 deletions(-)

diff -puN fs/mpage.c~io-accounting-read-accounting fs/mpage.c
--- a/fs/mpage.c~io-accounting-read-accounting
+++ a/fs/mpage.c
@@ -19,6 +19,7 @@
 #include <linux/bio.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/blkdev.h>
 #include <linux/highmem.h>
 #include <linux/prefetch.h>
@@ -402,6 +403,7 @@ mpage_readpages(struct address_space *ma
 		list_del(&page->lru);
 		if (!add_to_page_cache(page, mapping,
 					page->index, GFP_KERNEL)) {
+			task_io_account_read(PAGE_CACHE_SIZE);
 			bio = do_mpage_readpage(bio, page,
 					nr_pages - page_idx,
 					&last_block_in_bio, &map_bh,
diff -puN fs/namei.c~io-accounting-read-accounting fs/namei.c
--- a/fs/namei.c~io-accounting-read-accounting
+++ a/fs/namei.c
@@ -2725,7 +2725,7 @@ retry:
 	 * OTOH it's obviously correct and should make the page up-to-date.
 	 */
 	if (!PageUptodate(page)) {
-		err = mapping->a_ops->readpage(NULL, page);
+		err = do_readpage(mapping, NULL, page);
 		if (err != AOP_TRUNCATED_PAGE)
 			wait_on_page_locked(page);
 	} else {
diff -puN fs/splice.c~io-accounting-read-accounting fs/splice.c
--- a/fs/splice.c~io-accounting-read-accounting
+++ a/fs/splice.c
@@ -403,7 +403,7 @@ __generic_file_splice_read(struct file *
 			/*
 			 * need to read in the page
 			 */
-			error = mapping->a_ops->readpage(in, page);
+			error = do_readpage(mapping, in, page);
 			if (unlikely(error)) {
 				/*
 				 * We really should re-lookup the page here,
@@ -625,7 +625,7 @@ find_page:
 		 */
 		if (!PageUptodate(page)) {
 			if (this_len < PAGE_CACHE_SIZE) {
-				ret = mapping->a_ops->readpage(file, page);
+				ret = do_readpage(mapping, file, page);
 				if (unlikely(ret))
 					goto out;
 
diff -puN include/linux/pagemap.h~io-accounting-read-accounting include/linux/pagemap.h
--- a/include/linux/pagemap.h~io-accounting-read-accounting
+++ a/include/linux/pagemap.h
@@ -9,9 +9,11 @@
 #include <linux/list.h>
 #include <linux/highmem.h>
 #include <linux/compiler.h>
-#include <asm/uaccess.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/gfp.h>
 
+#include <asm/uaccess.h>
+
 /*
  * Bits in mapping->flags.  The lower __GFP_BITS_SHIFT bits are the page
  * allocation mode flags.
@@ -232,4 +234,11 @@ static inline void fault_in_pages_readab
 	}
 }
 
+static inline int do_readpage(struct address_space *mapping, struct file *file,
+				struct page *page)
+{
+	task_io_account_read(PAGE_CACHE_SIZE);
+	return mapping->a_ops->readpage(file, page);
+}
+
 #endif /* _LINUX_PAGEMAP_H */
diff -puN mm/filemap.c~io-accounting-read-accounting mm/filemap.c
--- a/mm/filemap.c~io-accounting-read-accounting
+++ a/mm/filemap.c
@@ -990,7 +990,7 @@ page_not_up_to_date:
 
 readpage:
 		/* Start the actual read. The read will unlock the page. */
-		error = mapping->a_ops->readpage(filp, page);
+		error = do_readpage(mapping, filp, page);
 
 		if (unlikely(error)) {
 			if (error == AOP_TRUNCATED_PAGE) {
@@ -1311,7 +1311,7 @@ static int fastcall page_cache_read(stru
 
 		ret = add_to_page_cache_lru(page, mapping, offset, GFP_KERNEL);
 		if (ret == 0)
-			ret = mapping->a_ops->readpage(file, page);
+			ret = do_readpage(mapping, file, page);
 		else if (ret == -EEXIST)
 			ret = 0; /* losing race to add is OK */
 
@@ -1483,7 +1483,7 @@ page_not_uptodate:
 		goto success;
 	}
 
-	error = mapping->a_ops->readpage(file, page);
+	error = do_readpage(mapping, file, page);
 	if (!error) {
 		wait_on_page_locked(page);
 		if (PageUptodate(page))
@@ -1514,7 +1514,7 @@ page_not_uptodate:
 		goto success;
 	}
 	ClearPageError(page);
-	error = mapping->a_ops->readpage(file, page);
+	error = do_readpage(mapping, file, page);
 	if (!error) {
 		wait_on_page_locked(page);
 		if (PageUptodate(page))
@@ -1604,7 +1604,7 @@ page_not_uptodate:
 		goto success;
 	}
 
-	error = mapping->a_ops->readpage(file, page);
+	error = do_readpage(mapping, file, page);
 	if (!error) {
 		wait_on_page_locked(page);
 		if (PageUptodate(page))
@@ -1634,7 +1634,7 @@ page_not_uptodate:
 	}
 
 	ClearPageError(page);
-	error = mapping->a_ops->readpage(file, page);
+	error = do_readpage(mapping, file, page);
 	if (!error) {
 		wait_on_page_locked(page);
 		if (PageUptodate(page))
@@ -1774,6 +1774,7 @@ repeat:
 		}
 		page = cached_page;
 		cached_page = NULL;
+		task_io_account_read(PAGE_CACHE_SIZE);
 		err = filler(data, page);
 		if (err < 0) {
 			page_cache_release(page);
diff -puN mm/readahead.c~io-accounting-read-accounting mm/readahead.c
--- a/mm/readahead.c~io-accounting-read-accounting
+++ a/mm/readahead.c
@@ -178,7 +178,7 @@ static int read_pages(struct address_spa
 		list_del(&page->lru);
 		if (!add_to_page_cache(page, mapping,
 					page->index, GFP_KERNEL)) {
-			mapping->a_ops->readpage(filp, page);
+			do_readpage(mapping, filp, page);
 			if (!pagevec_add(&lru_pvec, page))
 				__pagevec_lru_add(&lru_pvec);
 		} else
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-command-line-options.patch
proc_misc-build-fix.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
alsa-workqueue-fixes.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
platform_driver_probe-can-save-codespace-save-codespace.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-input-vs-git-alsa.patch
kbuild-fix-rr-is-now-default.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-mtd-ssfdc-build-fix.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
pci-legacy-resource-fix-tidy.patch
git-s390.patch
s390-workqueue-fixes.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy-tidy-2.patch
touchkit-ps-2-touchscreen-driver.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
congestion-wait-dont-wait-when-there-are-no-pages-under-writeback.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
workqueue-tweaks.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
implement-flush_work.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
bridge-avoid-using-noautorel-workqueues.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
bug-test-1.patch
sched-add-option-to-serialize-load-balancing-fix.patch
kernel-schedc-whitespace-cleanups-more.patch
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
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
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
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
zeromap_pte_range-debug.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch


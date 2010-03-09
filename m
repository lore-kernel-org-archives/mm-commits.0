From: akpm@linux-foundation.org
Subject: [merged] include-linux-fsh-convert-fmode_-constants-to-hex.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:01 -0800
Message-ID: <201003091904.o29J41if031009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755822Ab0CITER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eparis@redhat.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/fs.h: convert FMODE_* constants to hex
has been removed from the -mm tree.  Its filename was
     include-linux-fsh-convert-fmode_-constants-to-hex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/fs.h: convert FMODE_* constants to hex
From: Andrew Morton <akpm@linux-foundation.org>

It was tolerable until Eric went and added 8388608.

Cc: Eric Paris <eparis@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/fs.h~include-linux-fsh-convert-fmode_-constants-to-hex include/linux/fs.h
--- a/include/linux/fs.h~include-linux-fsh-convert-fmode_-constants-to-hex
+++ a/include/linux/fs.h
@@ -60,24 +60,24 @@ struct inodes_stat_t {
  */
 
 /* file is open for reading */
-#define FMODE_READ		((__force fmode_t)1)
+#define FMODE_READ		((__force fmode_t)0x1)
 /* file is open for writing */
-#define FMODE_WRITE		((__force fmode_t)2)
+#define FMODE_WRITE		((__force fmode_t)0x2)
 /* file is seekable */
-#define FMODE_LSEEK		((__force fmode_t)4)
+#define FMODE_LSEEK		((__force fmode_t)0x4)
 /* file can be accessed using pread */
-#define FMODE_PREAD		((__force fmode_t)8)
+#define FMODE_PREAD		((__force fmode_t)0x8)
 /* file can be accessed using pwrite */
-#define FMODE_PWRITE		((__force fmode_t)16)
+#define FMODE_PWRITE		((__force fmode_t)0x10)
 /* File is opened for execution with sys_execve / sys_uselib */
-#define FMODE_EXEC		((__force fmode_t)32)
+#define FMODE_EXEC		((__force fmode_t)0x20)
 /* File is opened with O_NDELAY (only set for block devices) */
-#define FMODE_NDELAY		((__force fmode_t)64)
+#define FMODE_NDELAY		((__force fmode_t)0x40)
 /* File is opened with O_EXCL (only set for block devices) */
-#define FMODE_EXCL		((__force fmode_t)128)
+#define FMODE_EXCL		((__force fmode_t)0x80)
 /* File is opened using open(.., 3, ..) and is writeable only for ioctls
    (specialy hack for floppy.c) */
-#define FMODE_WRITE_IOCTL	((__force fmode_t)256)
+#define FMODE_WRITE_IOCTL	((__force fmode_t)0x100)
 
 /*
  * Don't update ctime and mtime.
@@ -85,10 +85,10 @@ struct inodes_stat_t {
  * Currently a special hack for the XFS open_by_handle ioctl, but we'll
  * hopefully graduate it to a proper O_CMTIME flag supported by open(2) soon.
  */
-#define FMODE_NOCMTIME		((__force fmode_t)2048)
+#define FMODE_NOCMTIME		((__force fmode_t)0x800)
 
 /* Expect random access pattern */
-#define FMODE_RANDOM		((__force fmode_t)4096)
+#define FMODE_RANDOM		((__force fmode_t)0x1000)
 
 /*
  * The below are the various read and write types that we support. Some of
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
add-generic-sys_ipc-wrapper-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


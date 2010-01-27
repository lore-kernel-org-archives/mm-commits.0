From: akpm@linux-foundation.org
Subject: + include-linux-fsh-convert-fmode_-constants-to-hex.patch added to -mm tree
Date: Tue, 26 Jan 2010 17:16:16 -0800
Message-ID: <201001270116.o0R1GGTx002525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753725Ab0A0BQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 20:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, eparis@redhat.com, fengguang.wu@intel.com


The patch titled
     include/linux/fs.h: convert FMODE_* constants to hex
has been added to the -mm tree.  Its filename is
     include-linux-fsh-convert-fmode_-constants-to-hex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -85,13 +85,13 @@ struct inodes_stat_t {
  * Currently a special hack for the XFS open_by_handle ioctl, but we'll
  * hopefully graduate it to a proper O_CMTIME flag supported by open(2) soon.
  */
-#define FMODE_NOCMTIME		((__force fmode_t)2048)
+#define FMODE_NOCMTIME		((__force fmode_t)0x800)
 
 /* Expect random access pattern */
 #define FMODE_RANDOM		((__force fmode_t)0x1000)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
-#define FMODE_NONOTIFY		((__force fmode_t)8388608)
+#define FMODE_NONOTIFY		((__force fmode_t)0x800000)
 
 /*
  * The below are the various read and write types that we support. Some of
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes.patch
exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


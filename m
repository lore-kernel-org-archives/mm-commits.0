From: akpm@linux-foundation.org
Subject: [merged] fs-compat_ioctlc-suppress-two-warnings.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:39 -0800
Message-ID: <201003091907.o29J7dFO031354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756018Ab0CITWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amwang@redhat.com, arnd@arndb.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/compat_ioctl.c: suppress two warnings
has been removed from the -mm tree.  Its filename was
     fs-compat_ioctlc-suppress-two-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/compat_ioctl.c: suppress two warnings
From: Andrew Morton <akpm@linux-foundation.org>

fs/compat_ioctl.c: In function 'do_ioctl_trans':
fs/compat_ioctl.c:534: warning: 'karg' may be used uninitialized in this function
fs/compat_ioctl.c:533: warning: 'kcmd' may be used uninitialized in this function
fs/compat_ioctl.c:656: warning: 'ret' may be used uninitialized in this function

Reduces text size by 44 bytes.

If someone calls one of these functions with an unexpected argument, the
code's buggy as-is.

Amerigo Wang <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/compat_ioctl.c~fs-compat_ioctlc-suppress-two-warnings fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~fs-compat_ioctlc-suppress-two-warnings
+++ a/fs/compat_ioctl.c
@@ -545,7 +545,7 @@ static int mt_ioctl_trans(unsigned int f
 		kcmd = MTIOCPOS;
 		karg = &pos;
 		break;
-	case MTIOCGET32:
+	default:	/* MTIOCGET32 */
 		kcmd = MTIOCGET;
 		karg = &get;
 		break;
@@ -663,7 +663,7 @@ static int raw_ioctl(unsigned fd, unsign
 
         switch (cmd) {
         case RAW_SETBIND:
-        case RAW_GETBIND: {
+	default: {	/* RAW_GETBIND */
                 struct raw_config_request req;
                 mm_segment_t oldfs = get_fs();
 
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


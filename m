From: akpm@linux-foundation.org
Subject: + reiser4-broke.patch added to -mm tree
Date: Tue, 09 Mar 2010 17:30:37 -0800
Message-ID: <201003100156.o2A1utcJ018278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551Ab0CJB5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 20:57:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, edward.shishkin@gmail.com


The patch titled
     reiser4-broke
has been added to the -mm tree.  Its filename is
     reiser4-broke.patch

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
Subject: reiser4-broke
From: Andrew Morton <akpm@linux-foundation.org>

fs/reiser4/plugin/inode_ops.c: In function 'reiser4_setattr_common':
fs/reiser4/plugin/inode_ops.c:456: error: implicit declaration of function 'vfs_dq_transfer'
fs/reiser4/plugin/inode_ops.c: In function 'do_create_vfs_child':
fs/reiser4/plugin/inode_ops.c:596: error: implicit declaration of function 'vfs_dq_alloc_inode'
fs/reiser4/plugin/inode_ops.c:597: error: implicit declaration of function 'vfs_dq_drop'
fs/reiser4/plugin/inode_ops.c:611: error: implicit declaration of function 'vfs_dq_free_inode'

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/reiser4/Kconfig~reiser4-broke fs/reiser4/Kconfig
--- a/fs/reiser4/Kconfig~reiser4-broke
+++ a/fs/reiser4/Kconfig
@@ -1,6 +1,7 @@
 config REISER4_FS
 	tristate "Reiser4 (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	depends on BROKEN
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	select LZO_COMPRESS
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-generic-sys_ipc-wrapper-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


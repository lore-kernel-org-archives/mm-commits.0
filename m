From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-cx23885-needs-kfifo-conversion.patch removed from -mm tree
Date: Mon, 15 Mar 2010 13:39:21 -0700
Message-ID: <201003152039.o2FKdMGr021287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932138Ab0COUj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 16:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/cx23885 needs kfifo conversion
has been removed from the -mm tree.  Its filename was
     drivers-media-video-cx23885-needs-kfifo-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/cx23885 needs kfifo conversion
From: Andrew Morton <akpm@linux-foundation.org>

linux-next:

drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_irq_handler':
drivers/media/video/cx23885/cx23888-ir.c:597: error: implicit declaration of function 'kfifo_put'
drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_rx_read':
drivers/media/video/cx23885/cx23888-ir.c:660: error: implicit declaration of function 'kfifo_get'
drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_probe':
drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1172: warning: assignment makes pointer from integer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1178: warning: assignment makes pointer from integer without a cast

Cc: Stefani Seibold <stefani@seibold.net>
DESC
drivers/media/video/cx23885: needs kfifo updates
EDESC

linux-next again.

Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx231xx/Kconfig |    1 +
 drivers/media/video/cx23885/Kconfig |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/media/video/cx231xx/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion drivers/media/video/cx231xx/Kconfig
--- a/drivers/media/video/cx231xx/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion
+++ a/drivers/media/video/cx231xx/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_CX231XX
 	tristate "Conexant cx231xx USB video capture support"
 	depends on VIDEO_DEV && I2C && INPUT
+	depends on BROKEN
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_IR
diff -puN drivers/media/video/cx23885/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion drivers/media/video/cx23885/Kconfig
--- a/drivers/media/video/cx23885/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion
+++ a/drivers/media/video/cx23885/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_CX23885
 	tristate "Conexant cx23885 (2388x successor) support"
 	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on BROKEN
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TUNER
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
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


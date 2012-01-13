From: akpm@linux-foundation.org
Subject: [merged] drivers-video-nvidia-nvidiac-fix-warning.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:02 -0800
Message-ID: <20120113203202.997941E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36212 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075Ab2AMUcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:03 -0500
Received: by mail-yw0-f74.google.com with SMTP id j52so101798yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/nvidia/nvidia.c: fix warning
has been removed from the -mm tree.  Its filename was
     drivers-video-nvidia-nvidiac-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/video/nvidia/nvidia.c: fix warning

drivers/video/nvidia/nvidia.c:1602: warning: return from incompatible pointer type

Fix the int/bool confusion in there.

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/nvidia/nvidia.c~drivers-video-nvidia-nvidiac-fix-warning drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~drivers-video-nvidia-nvidiac-fix-warning
+++ a/drivers/video/nvidia/nvidia.c
@@ -81,7 +81,7 @@ static int vram __devinitdata = 0;
 static int bpp __devinitdata = 8;
 static int reverse_i2c __devinitdata;
 #ifdef CONFIG_MTRR
-static int nomtrr __devinitdata = 0;
+static bool nomtrr __devinitdata = false;
 #endif
 #ifdef CONFIG_PMAC_BACKLIGHT
 static int backlight __devinitdata = 1;
@@ -1509,7 +1509,7 @@ static int __devinit nvidiafb_setup(char
 			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
-			nomtrr = 1;
+			nomtrr = true;
 #endif
 		} else if (!strncmp(this_opt, "fpdither:", 9)) {
 			fpdither = simple_strtol(this_opt+9, NULL, 0);
@@ -1599,7 +1599,7 @@ MODULE_PARM_DESC(bpp, "pixel width in bi
 module_param(reverse_i2c, int, 0);
 MODULE_PARM_DESC(reverse_i2c, "reverse port assignment of the i2c bus");
 #ifdef CONFIG_MTRR
-module_param(nomtrr, bool, 0);
+module_param(nomtrr, bool, false);
 MODULE_PARM_DESC(nomtrr, "Disables MTRR support (0 or 1=disabled) "
 		 "(default=0)");
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


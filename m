From: akpm@linux-foundation.org
Subject: - fbdev-change-asm-uaccessh-to-linux-uaccessh.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:37 -0700
Message-ID: <200710162043.l9GKhbka016065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964867AbXJPVSm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:18:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: change asm/uaccess.h to linux/uaccess.h
has been removed from the -mm tree.  Its filename was
     fbdev-change-asm-uaccessh-to-linux-uaccessh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: change asm/uaccess.h to linux/uaccess.h
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch replaces <asm/uaccess.h> with <linux/uaccess.h> after the
checkpatch.pl hint.  The include of <asm/uaccess.h> is removed if the driver
does not use it.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/amifb.c                  |    2 +-
 drivers/video/arcfb.c                  |    2 +-
 drivers/video/atafb.c                  |    2 +-
 drivers/video/aty/aty128fb.c           |    2 +-
 drivers/video/aty/atyfb_base.c         |    2 +-
 drivers/video/aty/mach64_cursor.c      |    1 -
 drivers/video/aty/radeon_base.c        |    2 +-
 drivers/video/backlight/cr_bllcd.c     |    1 -
 drivers/video/backlight/progear_bl.c   |    1 -
 drivers/video/clps711xfb.c             |    2 +-
 drivers/video/console/fbcon.c          |    1 -
 drivers/video/console/softcursor.c     |    1 -
 drivers/video/cyber2000fb.c            |    1 -
 drivers/video/epson1355fb.c            |    2 +-
 drivers/video/fb_defio.c               |    1 -
 drivers/video/fb_sys_fops.c            |    2 +-
 drivers/video/fbcmap.c                 |    3 +--
 drivers/video/hecubafb.c               |    2 +-
 drivers/video/imsttfb.c                |    2 +-
 drivers/video/imxfb.c                  |    1 -
 drivers/video/kyro/fbdev.c             |    2 +-
 drivers/video/matrox/matroxfb_base.c   |    2 +-
 drivers/video/matrox/matroxfb_crtc2.c  |    2 +-
 drivers/video/matrox/matroxfb_g450.c   |    1 -
 drivers/video/matrox/matroxfb_maven.c  |    1 -
 drivers/video/neofb.c                  |    1 -
 drivers/video/pnx4008/pnxrgbfb.c       |    1 -
 drivers/video/ps3fb.c                  |    2 +-
 drivers/video/pvr2fb.c                 |    2 +-
 drivers/video/pxafb.c                  |    1 -
 drivers/video/sa1100fb.c               |    1 -
 drivers/video/savage/savagefb_driver.c |    1 -
 drivers/video/sis/sis_main.c           |    2 +-
 drivers/video/sstfb.c                  |    2 +-
 drivers/video/vermilion/vermilion.c    |    1 -
 drivers/video/vfb.c                    |    1 -
 36 files changed, 19 insertions(+), 37 deletions(-)

diff -puN drivers/video/amifb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/amifb.c
--- a/drivers/video/amifb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/amifb.c
@@ -52,7 +52,7 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/amigahw.h>
diff -puN drivers/video/arcfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/arcfb.c
--- a/drivers/video/arcfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/arcfb.c
@@ -48,7 +48,7 @@
 #include <linux/arcfb.h>
 #include <linux/platform_device.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define floor8(a) (a&(~0x07))
 #define floorXres(a,xres) (a&(~(xres - 1)))
diff -puN drivers/video/atafb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/atafb.c
--- a/drivers/video/atafb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/atafb.c
@@ -58,7 +58,7 @@
 #include <linux/interrupt.h>
 
 #include <asm/setup.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/io.h>
diff -puN drivers/video/aty/aty128fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/aty/aty128fb.c
@@ -56,7 +56,7 @@
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/pci.h>
diff -puN drivers/video/aty/atyfb_base.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/aty/atyfb_base.c
@@ -68,7 +68,7 @@
 #include <linux/backlight.h>
 
 #include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <video/mach64.h>
 #include "atyfb.h"
diff -puN drivers/video/aty/mach64_cursor.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/aty/mach64_cursor.c
--- a/drivers/video/aty/mach64_cursor.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/aty/mach64_cursor.c
@@ -8,7 +8,6 @@
 #include <linux/string.h>
 
 #include <asm/io.h>
-#include <asm/uaccess.h>
 
 #ifdef __sparc__
 #include <asm/fbio.h>
diff -puN drivers/video/aty/radeon_base.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/aty/radeon_base.c
@@ -69,7 +69,7 @@
 #include <linux/device.h>
 
 #include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #ifdef CONFIG_PPC_OF
 
diff -puN drivers/video/backlight/cr_bllcd.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/backlight/cr_bllcd.c
--- a/drivers/video/backlight/cr_bllcd.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -36,7 +36,6 @@
 #include <linux/backlight.h>
 #include <linux/lcd.h>
 #include <linux/pci.h>
-#include <asm/uaccess.h>
 
 /* The LVDS- and panel power controls sits on the
  * GPIO port of the ISA bridge.
diff -puN drivers/video/backlight/progear_bl.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/backlight/progear_bl.c
--- a/drivers/video/backlight/progear_bl.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/backlight/progear_bl.c
@@ -23,7 +23,6 @@
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/pci.h>
-#include <asm/uaccess.h>
 
 #define PMU_LPCR               0xB0
 #define SB_MPS1                0x61
diff -puN drivers/video/clps711xfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/clps711xfb.c
--- a/drivers/video/clps711xfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/clps711xfb.c
@@ -29,7 +29,7 @@
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware/clps7111.h>
 #include <asm/arch/syspld.h>
diff -puN drivers/video/console/fbcon.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/console/fbcon.c
@@ -78,7 +78,6 @@
 #include <asm/fb.h>
 #include <asm/irq.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 #ifdef CONFIG_ATARI
 #include <asm/atariints.h>
 #endif
diff -puN drivers/video/console/softcursor.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/console/softcursor.c
--- a/drivers/video/console/softcursor.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/console/softcursor.c
@@ -15,7 +15,6 @@
 #include <linux/fb.h>
 #include <linux/slab.h>
 
-#include <asm/uaccess.h>
 #include <asm/io.h>
 
 #include "fbcon.h"
diff -puN drivers/video/cyber2000fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/cyber2000fb.c
--- a/drivers/video/cyber2000fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/cyber2000fb.c
@@ -50,7 +50,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #ifdef __arm__
 #include <asm/mach-types.h>
diff -puN drivers/video/epson1355fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/epson1355fb.c
--- a/drivers/video/epson1355fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/epson1355fb.c
@@ -57,7 +57,7 @@
 
 #include <asm/types.h>
 #include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <video/epson1355.h>
 
diff -puN drivers/video/fb_defio.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/fb_defio.c
@@ -19,7 +19,6 @@
 #include <linux/interrupt.h>
 #include <linux/fb.h>
 #include <linux/list.h>
-#include <asm/uaccess.h>
 
 /* to support deferred IO */
 #include <linux/rmap.h>
diff -puN drivers/video/fb_sys_fops.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/fb_sys_fops.c
--- a/drivers/video/fb_sys_fops.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/fb_sys_fops.c
@@ -11,7 +11,7 @@
  */
 #include <linux/fb.h>
 #include <linux/module.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 ssize_t fb_sys_read(struct fb_info *info, char __user *buf, size_t count,
 		    loff_t *ppos)
diff -puN drivers/video/fbcmap.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/fbcmap.c
--- a/drivers/video/fbcmap.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/fbcmap.c
@@ -15,8 +15,7 @@
 #include <linux/module.h>
 #include <linux/fb.h>
 #include <linux/slab.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static u16 red2[] __read_mostly = {
     0x0000, 0xaaaa
diff -puN drivers/video/hecubafb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/hecubafb.c
@@ -45,7 +45,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/list.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /* Apollo controller specific defines */
 #define APOLLO_START_NEW_IMG	0xA0
diff -puN drivers/video/imsttfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/imsttfb.c
--- a/drivers/video/imsttfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/imsttfb.c
@@ -29,7 +29,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #if defined(CONFIG_PPC)
 #include <linux/nvram.h>
diff -puN drivers/video/imxfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/imxfb.c
@@ -34,7 +34,6 @@
 
 #include <asm/hardware.h>
 #include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/arch/imxfb.h>
 
 /*
diff -puN drivers/video/kyro/fbdev.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/kyro/fbdev.c
--- a/drivers/video/kyro/fbdev.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/kyro/fbdev.c
@@ -21,7 +21,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
diff -puN drivers/video/matrox/matroxfb_base.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -113,7 +113,7 @@
 #include "matroxfb_g450.h"
 #include <linux/matroxfb.h>
 #include <linux/interrupt.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #ifdef CONFIG_PPC_PMAC
 #include <asm/machdep.h>
diff -puN drivers/video/matrox/matroxfb_crtc2.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -15,7 +15,7 @@
 #include "matroxfb_misc.h"
 #include "matroxfb_DAC1064.h"
 #include <linux/matroxfb.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /* **************************************************** */
 
diff -puN drivers/video/matrox/matroxfb_g450.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/matrox/matroxfb_g450.c
--- a/drivers/video/matrox/matroxfb_g450.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/matrox/matroxfb_g450.c
@@ -17,7 +17,6 @@
 #include "matroxfb_DAC1064.h"
 #include "g450_pll.h"
 #include <linux/matroxfb.h>
-#include <asm/uaccess.h>
 #include <asm/div64.h>
 
 #include "matroxfb_g450.h"
diff -puN drivers/video/matrox/matroxfb_maven.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/matrox/matroxfb_maven.c
--- a/drivers/video/matrox/matroxfb_maven.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/matrox/matroxfb_maven.c
@@ -18,7 +18,6 @@
 #include <linux/i2c.h>
 #include <linux/matroxfb.h>
 #include <asm/div64.h>
-#include <asm/uaccess.h>
 
 #define MAVEN_I2CID	(0x1B)
 
diff -puN drivers/video/neofb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/neofb.c
--- a/drivers/video/neofb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/neofb.c
@@ -72,7 +72,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
diff -puN drivers/video/pnx4008/pnxrgbfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/pnx4008/pnxrgbfb.c
--- a/drivers/video/pnx4008/pnxrgbfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/pnx4008/pnxrgbfb.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/uaccess.h>
 #include "sdum.h"
 #include "fbcommon.h"
 
diff -puN drivers/video/ps3fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/ps3fb.c
@@ -34,7 +34,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <asm/time.h>
diff -puN drivers/video/pvr2fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/pvr2fb.c
--- a/drivers/video/pvr2fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/pvr2fb.c
@@ -72,7 +72,7 @@
 #endif
 
 #ifdef CONFIG_SH_STORE_QUEUES
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/cpu/sq.h>
 #endif
 
diff -puN drivers/video/pxafb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/pxafb.c
@@ -43,7 +43,6 @@
 #include <asm/hardware.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/uaccess.h>
 #include <asm/div64.h>
 #include <asm/arch/pxa-regs.h>
 #include <asm/arch/bitfield.h>
diff -puN drivers/video/sa1100fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/sa1100fb.c
--- a/drivers/video/sa1100fb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/sa1100fb.c
@@ -178,7 +178,6 @@
 #include <asm/hardware.h>
 #include <asm/io.h>
 #include <asm/mach-types.h>
-#include <asm/uaccess.h>
 #include <asm/arch/assabet.h>
 #include <asm/arch/shannon.h>
 
diff -puN drivers/video/savage/savagefb_driver.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/savage/savagefb_driver.c
--- a/drivers/video/savage/savagefb_driver.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/savage/savagefb_driver.c
@@ -57,7 +57,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
diff -puN drivers/video/sis/sis_main.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/sis/sis_main.c
@@ -58,7 +58,7 @@
 #include <linux/capability.h>
 #include <linux/fs.h>
 #include <linux/types.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/io.h>
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
diff -puN drivers/video/sstfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/sstfb.c
--- a/drivers/video/sstfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/sstfb.c
@@ -88,7 +88,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <video/sstfb.h>
 
 
diff -puN drivers/video/vermilion/vermilion.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/vermilion/vermilion.c
--- a/drivers/video/vermilion/vermilion.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/vermilion/vermilion.c
@@ -39,7 +39,6 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <linux/mmzone.h>
-#include <asm/uaccess.h>
 
 /* #define VERMILION_DEBUG */
 
diff -puN drivers/video/vfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh drivers/video/vfb.c
--- a/drivers/video/vfb.c~fbdev-change-asm-uaccessh-to-linux-uaccessh
+++ a/drivers/video/vfb.c
@@ -21,7 +21,6 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 
-#include <asm/uaccess.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch

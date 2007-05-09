From: akpm@linux-foundation.org
Subject: - savagefb-vga-state-save-and-restore.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:48 -0700
Message-ID: <200705090300.l4930maj010609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032912AbXEIDAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     savagefb: VGA state save and restore
has been removed from the -mm tree.  Its filename was
     savagefb-vga-state-save-and-restore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: savagefb: VGA state save and restore
From: "Antonino A. Daplas" <adaplas@gmail.com>

Allow the saving and restoration of VGA text mode.  The state is saved on the
first open and restored on the last close. Because of the VGA registers are
linearly mapped to the MMIO space, MMIO access is used which is not limited to
X86 platforms nor to the primary display device.

An echo 0 > /sys/class/vtconsole/vtcon1/bind will convert the display from
graphics to text mode.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Makefile                 |    2 -
 drivers/video/savage/savagefb.h        |   10 ++++-
 drivers/video/savage/savagefb_driver.c |   39 +++++++++++++++++++++++
 3 files changed, 48 insertions(+), 3 deletions(-)

diff -puN drivers/video/Makefile~savagefb-vga-state-save-and-restore drivers/video/Makefile
--- a/drivers/video/Makefile~savagefb-vga-state-save-and-restore
+++ a/drivers/video/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_FB_ATY128)		  += aty/ macmo
 obj-$(CONFIG_FB_RADEON)		  += aty/
 obj-$(CONFIG_FB_SIS)		  += sis/
 obj-$(CONFIG_FB_KYRO)             += kyro/
-obj-$(CONFIG_FB_SAVAGE)		  += savage/
+obj-$(CONFIG_FB_SAVAGE)		  += savage/ vgastate.o
 obj-$(CONFIG_FB_GEODE)		  += geode/
 obj-$(CONFIG_FB_MBX)		  += mbx/
 obj-$(CONFIG_FB_I810)             += vgastate.o
diff -puN drivers/video/savage/savagefb.h~savagefb-vga-state-save-and-restore drivers/video/savage/savagefb.h
--- a/drivers/video/savage/savagefb.h~savagefb-vga-state-save-and-restore
+++ a/drivers/video/savage/savagefb.h
@@ -15,6 +15,8 @@
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
 #include <linux/i2c-algo-bit.h>
+#include <linux/mutex.h>
+#include <video/vga.h>
 #include "../edid.h"
 
 #ifdef SAVAGEFB_DEBUG
@@ -189,8 +191,12 @@ struct savagefb_par {
 	struct savagefb_i2c_chan chan;
 	struct savage_reg state;
 	struct savage_reg save;
+	struct savage_reg initial;
+	struct vgastate vgastate;
+	struct mutex open_lock;
 	unsigned char   *edid;
 	u32 pseudo_palette[16];
+	u32 open_count;
 	int paletteEnabled;
 	int pm_state;
 	int display_type;
@@ -203,7 +209,7 @@ struct savagefb_par {
 	int clock[4];
 	int MCLK, REFCLK, LCDclk;
 	struct {
-		u8   __iomem *vbase;
+		void   __iomem *vbase;
 		u32    pbase;
 		u32    len;
 #ifdef CONFIG_MTRR
@@ -212,7 +218,7 @@ struct savagefb_par {
 	} video;
 
 	struct {
-		volatile u8  __iomem *vbase;
+		void  __iomem *vbase;
 		u32           pbase;
 		u32           len;
 	} mmio;
diff -puN drivers/video/savage/savagefb_driver.c~savagefb-vga-state-save-and-restore drivers/video/savage/savagefb_driver.c
--- a/drivers/video/savage/savagefb_driver.c~savagefb-vga-state-save-and-restore
+++ a/drivers/video/savage/savagefb_driver.c
@@ -1623,8 +1623,46 @@ static void savagefb_restore_state(struc
 	savagefb_blank(FB_BLANK_UNBLANK, info);
 }
 
+static int savagefb_open(struct fb_info *info, int user)
+{
+	struct savagefb_par *par = info->par;
+
+	mutex_lock(&par->open_lock);
+
+	if (!par->open_count) {
+		memset(&par->vgastate, 0, sizeof(par->vgastate));
+		par->vgastate.flags = VGA_SAVE_CMAP | VGA_SAVE_FONTS |
+			VGA_SAVE_MODE;
+		par->vgastate.vgabase = par->mmio.vbase + 0x8000;
+		save_vga(&par->vgastate);
+		savage_get_default_par(par, &par->initial);
+	}
+
+	par->open_count++;
+	mutex_unlock(&par->open_lock);
+	return 0;
+}
+
+static int savagefb_release(struct fb_info *info, int user)
+{
+	struct savagefb_par *par = info->par;
+
+	mutex_lock(&par->open_lock);
+
+	if (par->open_count == 1) {
+		savage_set_default_par(par, &par->initial);
+		restore_vga(&par->vgastate);
+	}
+
+	par->open_count--;
+	mutex_unlock(&par->open_lock);
+	return 0;
+}
+
 static struct fb_ops savagefb_ops = {
 	.owner          = THIS_MODULE,
+	.fb_open        = savagefb_open,
+	.fb_release     = savagefb_release,
 	.fb_check_var   = savagefb_check_var,
 	.fb_set_par     = savagefb_set_par,
 	.fb_setcolreg   = savagefb_setcolreg,
@@ -2173,6 +2211,7 @@ static int __devinit savagefb_probe(stru
 	if (!info)
 		return -ENOMEM;
 	par = info->par;
+	mutex_init(&par->open_lock);
 	err = pci_enable_device(dev);
 	if (err)
 		goto failed_enable;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch

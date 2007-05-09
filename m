From: akpm@linux-foundation.org
Subject: - nvidiafb-vga-state-save-and-restore.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:44 -0700
Message-ID: <200705090300.l4930iZj010601@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032894AbXEIDAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: VGA state save and restore
has been removed from the -mm tree.  Its filename was
     nvidiafb-vga-state-save-and-restore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb: VGA state save and restore
From: "Antonino A. Daplas" <adaplas@gmail.com>

Allow the saving and restoration of VGA text mode.  The state is saved on the
first open and restored on the last close.  Because of the non-linear mapping
of the VGA registers to the MMIO space, this will be done only on X86
platforms where the device is the primary display.

An echo 0 > /sys/class/vtconsole/vtcon1/bind will convert the display from
graphics to text mode.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Makefile         |    2 
 drivers/video/nvidia/nv_type.h |    6 ++
 drivers/video/nvidia/nvidia.c  |   74 ++++++++++++++++++++++++++++++-
 3 files changed, 80 insertions(+), 2 deletions(-)

diff -puN drivers/video/Makefile~nvidiafb-vga-state-save-and-restore drivers/video/Makefile
--- a/drivers/video/Makefile~nvidiafb-vga-state-save-and-restore
+++ a/drivers/video/Makefile
@@ -32,7 +32,7 @@ obj-$(CONFIG_FB_PM3)		  += pm3fb.o
 
 obj-$(CONFIG_FB_MATROX)		  += matrox/
 obj-$(CONFIG_FB_RIVA)		  += riva/ vgastate.o
-obj-$(CONFIG_FB_NVIDIA)		  += nvidia/
+obj-$(CONFIG_FB_NVIDIA)		  += nvidia/ vgastate.o
 obj-$(CONFIG_FB_ATY)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_RADEON)		  += aty/
diff -puN drivers/video/nvidia/nv_type.h~nvidiafb-vga-state-save-and-restore drivers/video/nvidia/nv_type.h
--- a/drivers/video/nvidia/nv_type.h~nvidiafb-vga-state-save-and-restore
+++ a/drivers/video/nvidia/nv_type.h
@@ -5,6 +5,8 @@
 #include <linux/types.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
+#include <linux/mutex.h>
+#include <video/vga.h>
 
 #define NV_ARCH_04  0x04
 #define NV_ARCH_10  0x10
@@ -93,7 +95,10 @@ struct riva_regs {
 struct nvidia_par {
 	RIVA_HW_STATE SavedReg;
 	RIVA_HW_STATE ModeReg;
+	RIVA_HW_STATE initial_state;
 	RIVA_HW_STATE *CurrentState;
+	struct vgastate vgastate;
+	struct mutex open_lock;
 	u32 pseudo_palette[16];
 	struct pci_dev *pci_dev;
 	u32 Architecture;
@@ -141,6 +146,7 @@ struct nvidia_par {
 	int BlendingPossible;
 	u32 paletteEnabled;
 	u32 forceCRTC;
+	u32 open_count;
 	u8 DDCBase;
 #ifdef CONFIG_MTRR
 	struct {
diff -puN drivers/video/nvidia/nvidia.c~nvidiafb-vga-state-save-and-restore drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nvidiafb-vga-state-save-and-restore
+++ a/drivers/video/nvidia/nvidia.c
@@ -949,8 +949,80 @@ static int nvidiafb_blank(int blank, str
 	return 0;
 }
 
+/*
+ * Because the VGA registers are not mapped linearly in its MMIO space,
+ * restrict VGA register saving and restore to x86 only, where legacy VGA IO
+ * access is legal. Consequently, we must also check if the device is the
+ * primary display.
+ */
+#ifdef CONFIG_X86
+static void save_vga_x86(struct nvidia_par *par)
+{
+	struct resource *res= &par->pci_dev->resource[PCI_ROM_RESOURCE];
+
+	if (res && res->flags & IORESOURCE_ROM_SHADOW) {
+		memset(&par->vgastate, 0, sizeof(par->vgastate));
+		par->vgastate.flags = VGA_SAVE_MODE | VGA_SAVE_FONTS |
+			VGA_SAVE_CMAP;
+		save_vga(&par->vgastate);
+	}
+}
+
+static void restore_vga_x86(struct nvidia_par *par)
+{
+	struct resource *res= &par->pci_dev->resource[PCI_ROM_RESOURCE];
+
+	if (res && res->flags & IORESOURCE_ROM_SHADOW)
+		restore_vga(&par->vgastate);
+}
+#else
+#define save_vga_x86(x) do {} while (0)
+#define restore_vga_x86(x) do {} while (0)
+#endif /* X86 */
+
+static int nvidiafb_open(struct fb_info *info, int user)
+{
+	struct nvidia_par *par = info->par;
+
+	mutex_lock(&par->open_lock);
+
+	if (!par->open_count) {
+		save_vga_x86(par);
+		nvidia_save_vga(par, &par->initial_state);
+	}
+
+	par->open_count++;
+	mutex_unlock(&par->open_lock);
+	return 0;
+}
+
+static int nvidiafb_release(struct fb_info *info, int user)
+{
+	struct nvidia_par *par = info->par;
+	int err = 0;
+
+	mutex_lock(&par->open_lock);
+
+	if (!par->open_count) {
+		err = -EINVAL;
+		goto done;
+	}
+
+	if (par->open_count == 1) {
+		nvidia_write_regs(par, &par->initial_state);
+		restore_vga_x86(par);
+	}
+
+	par->open_count--;
+done:
+	mutex_unlock(&par->open_lock);
+	return 0;
+}
+
 static struct fb_ops nvidia_fb_ops = {
 	.owner          = THIS_MODULE,
+	.fb_open        = nvidiafb_open,
+	.fb_release     = nvidiafb_release,
 	.fb_check_var   = nvidiafb_check_var,
 	.fb_set_par     = nvidiafb_set_par,
 	.fb_setcolreg   = nvidiafb_setcolreg,
@@ -1208,7 +1280,7 @@ static int __devinit nvidiafb_probe(stru
 
 	par = info->par;
 	par->pci_dev = pd;
-
+	mutex_init(&par->open_lock);
 	info->pixmap.addr = kzalloc(8 * 1024, GFP_KERNEL);
 
 	if (info->pixmap.addr == NULL)
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

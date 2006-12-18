From: akpm@osdl.org
Subject: + fbdev-driver-for-s3-trio-virge-cleanups.patch added to -mm tree
Date: Mon, 18 Dec 2006 15:42:40 -0800
Message-ID: <200612182342.kBINge2Z016602@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59701 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbWLRXqB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 18:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, santiago@crfreenet.org


The patch titled
     drivers/video/{s3fb,svgalib}.c: possible cleanups
has been added to the -mm tree.  Its filename is
     fbdev-driver-for-s3-trio-virge-cleanups.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/video/{s3fb,svgalib}.c: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

- CodingStyle:
  - opening braces of functions at the beginning of the next line
  - C99 struct initializers

- make the following needlessly global functions static:
  - s3fb.c: s3fb_settile()
  - s3fb.c: s3fb_tilecopy()
  - s3fb.c: s3fb_tilefill()
  - s3fb.c: s3fb_tileblit()
  - s3fb.c: s3fb_tilecursor()
  - s3fb.c: s3fb_init()
  - svgalib.c: svga_regset_size()

- #if 0 the following unused global functions:
  - svga_wseq_multi()
  - svga_dump_var()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/s3fb.c    |   29 +++++++++++++++++------------
 drivers/video/svgalib.c |   11 +++++------
 include/linux/svga.h    |    4 ----
 3 files changed, 22 insertions(+), 22 deletions(-)

diff -puN drivers/video/s3fb.c~fbdev-driver-for-s3-trio-virge-cleanups drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~fbdev-driver-for-s3-trio-virge-cleanups
+++ a/drivers/video/s3fb.c
@@ -161,7 +161,8 @@ MODULE_PARM_DESC(mtrr, "Enable write-com
 
 /* Set font in text (tileblit) mode */
 
-void s3fb_settile(struct fb_info *info, struct fb_tilemap *map) {
+static void s3fb_settile(struct fb_info *info, struct fb_tilemap *map)
+{
 	const u8 *font = map->data;
 	u8* fb = (u8 *) info->screen_base;
 	int i, c;
@@ -185,7 +186,8 @@ void s3fb_settile(struct fb_info *info, 
 
 /* Copy area in text (tileblit) mode */
 
-void s3fb_tilecopy(struct fb_info *info, struct fb_tilearea *area) {
+static void s3fb_tilecopy(struct fb_info *info, struct fb_tilearea *area)
+{
 	int dx, dy;
 //	int colstride = 4;
 	int colstride = 2;
@@ -222,7 +224,8 @@ void s3fb_tilecopy(struct fb_info *info,
 
 /* Fill area in text (tileblit) mode */
 
-void s3fb_tilefill(struct fb_info *info, struct fb_tilerect *rect) {
+static void s3fb_tilefill(struct fb_info *info, struct fb_tilerect *rect)
+{
 	int dx, dy;
 //	int colstride = 8;
 	int colstride = 4;
@@ -244,7 +247,8 @@ void s3fb_tilefill(struct fb_info *info,
 
 /* Write text in text (tileblit) mode */
 
-void s3fb_tileblit(struct fb_info *info, struct fb_tileblit *blit) {
+static void s3fb_tileblit(struct fb_info *info, struct fb_tileblit *blit)
+{
 	int dx, dy, i;
 //	int colstride = 8;
 	int colstride = 4;
@@ -270,7 +274,8 @@ void s3fb_tileblit(struct fb_info *info,
 
 /* Set cursor in text (tileblit) mode */
 
-void s3fb_tilecursor(struct fb_info *info, struct fb_tilecursor *cursor) {
+static void s3fb_tilecursor(struct fb_info *info, struct fb_tilecursor *cursor)
+{
 	u8 cs = 0x0d;
 	u8 ce = 0x0e;
 	u16 pos =  cursor->sx + (info->var.xoffset /  8)
@@ -1183,12 +1188,12 @@ static struct pci_device_id s3_devices[]
 MODULE_DEVICE_TABLE(pci, s3_devices);
 
 static struct pci_driver s3fb_pci_driver = {
-	name:"s3fb",
-	id_table:s3_devices,
-	probe:s3_pci_probe,
-	remove:__devexit_p(s3_pci_remove),
-//	suspend:s3_pci_suspend,
-//	resume:s3_pci_resume,
+	.name		= "s3fb",
+	.id_table	= s3_devices,
+	.probe		= s3_pci_probe,
+	.remove		= __devexit_p(s3_pci_remove),
+//	.suspend	= s3_pci_suspend,
+//	.resume		= s3_pci_resume,
 };
 
 /* Parse user speficied options */
@@ -1228,7 +1233,7 @@ static void __exit s3fb_cleanup(void)
 
 /* Driver Initialisation */
 
-int __init s3fb_init(void)
+static int __init s3fb_init(void)
 {
 
 #ifndef MODULE
diff -puN drivers/video/svgalib.c~fbdev-driver-for-s3-trio-virge-cleanups drivers/video/svgalib.c
--- a/drivers/video/svgalib.c~fbdev-driver-for-s3-trio-virge-cleanups
+++ a/drivers/video/svgalib.c
@@ -42,8 +42,8 @@ void svga_wcrt_multi(const struct vga_re
 	}
 }
 
+#if 0
 /* Write a sequence register value spread across multiple registers */
-
 void svga_wseq_multi(const struct vga_regset *regset, u32 value) {
 
 	u8 regval, bitval, bitnum;
@@ -62,8 +62,9 @@ void svga_wseq_multi(const struct vga_re
 		regset ++;
 	}
 }
+#endif  /*  0  */
 
-unsigned int svga_regset_size(const struct vga_regset *regset)
+static unsigned int svga_regset_size(const struct vga_regset *regset)
 {
 	u8 count = 0;
 
@@ -163,6 +164,7 @@ void svga_set_textmode_vga_regs(void)
 	vga_w(NULL, VGA_ATT_W, 0x20);
 }
 
+#if 0
 void svga_dump_var(struct fb_var_screeninfo *var, int node)
 {
 	pr_debug("fb%d: var.vmode         : 0x%X\n", node, var->vmode);
@@ -180,6 +182,7 @@ void svga_dump_var(struct fb_var_screeni
 	pr_debug("fb%d: var.sync          : 0x%X\n", node, var->sync);
 	pr_debug("fb%d: var.pixclock      : %d\n\n", node, var->pixclock);
 }
+#endif  /*  0  */
 
 /* ------------------------------------------------------------------------- */
 
@@ -433,9 +436,7 @@ int svga_match_format(const struct svga_
 }
 
 
-EXPORT_SYMBOL(svga_wseq_multi);
 EXPORT_SYMBOL(svga_wcrt_multi);
-EXPORT_SYMBOL(svga_regset_size);
 
 EXPORT_SYMBOL(svga_set_default_gfx_regs);
 EXPORT_SYMBOL(svga_set_default_atc_regs);
@@ -443,8 +444,6 @@ EXPORT_SYMBOL(svga_set_default_seq_regs)
 EXPORT_SYMBOL(svga_set_default_crt_regs);
 EXPORT_SYMBOL(svga_set_textmode_vga_regs);
 
-EXPORT_SYMBOL(svga_dump_var);
-
 EXPORT_SYMBOL(svga_compute_pll);
 EXPORT_SYMBOL(svga_check_timings);
 EXPORT_SYMBOL(svga_set_timings);
diff -puN include/linux/svga.h~fbdev-driver-for-s3-trio-virge-cleanups include/linux/svga.h
--- a/include/linux/svga.h~fbdev-driver-for-s3-trio-virge-cleanups
+++ a/include/linux/svga.h
@@ -91,8 +91,6 @@ static inline void svga_wcrt_mask(u8 ind
 
 
 void svga_wcrt_multi(const struct vga_regset *regset, u32 value);
-void svga_wseq_multi(const struct vga_regset *regset, u32 value);
-unsigned int svga_regset_size(const struct vga_regset *regset);
 
 void svga_set_default_gfx_regs(void);
 void svga_set_default_atc_regs(void);
@@ -100,8 +98,6 @@ void svga_set_default_seq_regs(void);
 void svga_set_default_crt_regs(void);
 void svga_set_textmode_vga_regs(void);
 
-void svga_dump_var(struct fb_var_screeninfo *var, int node);
-
 int svga_compute_pll(const struct svga_pll *pll, u32 f_wanted, u16 *m, u16 *n, u16 *r, int node);
 int svga_check_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, int node);
 void svga_set_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, u32 hmul, u32 hdiv, u32 vmul, u32 vdiv, int node);
_

Patches currently in -mm which might be from bunk@stusta.de are

make-kernel-printkcignore_loglevel_setup-static.patch
fs-sysv-proper-prototypes-for-2-functions.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
acpi-make-code-static.patch
git-alsa.patch
proper-prototype-for-drivers-base-initcdriver_init.patch
usbvision-possible-cleanups.patch
git-gfs2-nmw.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch


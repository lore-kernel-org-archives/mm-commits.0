From: akpm@linux-foundation.org
Subject: + cirrusfb-remove-typedefs.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:42 -0700
Message-ID: <200708272223.l7RMNgbc031671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757787AbXH0WXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     cirrusfb: remove typedefs
has been added to the -mm tree.  Its filename is
     cirrusfb-remove-typedefs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cirrusfb: remove typedefs
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch replaces "typedef enum" with "enum type" constructs.  Using the
typedef is error for the checkpatch.pl script.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-remove-typedefs drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-remove-typedefs
+++ a/drivers/video/cirrusfb.c
@@ -110,7 +110,7 @@
  */
 
 /* board types */
-typedef enum {
+enum cirrus_board {
 	BT_NONE = 0,
 	BT_SD64,
 	BT_PICCOLO,
@@ -120,12 +120,12 @@ typedef enum {
 	BT_ALPINE,	/* GD543x/4x */
 	BT_GD5480,
 	BT_LAGUNA,	/* GD546x */
-} cirrusfb_board_t;
+};
 
 /*
  * per-board-type information, used for enumerating and abstracting
  * chip-specific information
- * NOTE: MUST be in the same order as cirrusfb_board_t in order to
+ * NOTE: MUST be in the same order as enum cirrus_board in order to
  * use direct indexing on this array
  * NOTE: '__initdata' cannot be used as some of this info
  * is required at runtime.  Maybe separate into an init-only and
@@ -361,10 +361,10 @@ struct cirrusfb_regs {
 };
 
 #ifdef CIRRUSFB_DEBUG
-typedef enum {
+enum cirrusfb_dbg_reg_class {
 	CRT,
 	SEQ
-} cirrusfb_dbg_reg_class_t;
+};
 #endif		/* CIRRUSFB_DEBUG */
 
 /* info about board */
@@ -375,7 +375,7 @@ struct cirrusfb_info {
 	u8 __iomem *regbase;
 	u8 __iomem *mem;
 	unsigned long size;
-	cirrusfb_board_t btype;
+	enum cirrus_board btype;
 	unsigned char SFR;	/* Shadow of special function register */
 
 	unsigned long fbmem_phys;
@@ -571,7 +571,7 @@ static void bestclock(long freq, long *b
 static void cirrusfb_dump(void);
 static void cirrusfb_dbg_reg_dump(caddr_t regbase);
 static void cirrusfb_dbg_print_regs(caddr_t regbase,
-				    cirrusfb_dbg_reg_class_t reg_class, ...);
+				    enum cirrusfb_dbg_reg_class reg_class, ...);
 static void cirrusfb_dbg_print_byte(const char *name, unsigned char val);
 #endif /* CIRRUSFB_DEBUG */
 
@@ -2449,7 +2449,7 @@ static int cirrusfb_register(struct cirr
 {
 	struct fb_info *info;
 	int err;
-	cirrusfb_board_t btype;
+	enum cirrus_board btype;
 
 	DPRINTK("ENTER\n");
 
@@ -2517,7 +2517,7 @@ static int cirrusfb_pci_register(struct 
 {
 	struct cirrusfb_info *cinfo;
 	struct fb_info *info;
-	cirrusfb_board_t btype;
+	enum cirrus_board btype;
 	unsigned long board_addr, board_size;
 	int ret;
 
@@ -2537,11 +2537,11 @@ static int cirrusfb_pci_register(struct 
 	cinfo = info->par;
 	cinfo->info = info;
 	cinfo->pdev = pdev;
-	cinfo->btype = btype = (cirrusfb_board_t) ent->driver_data;
+	cinfo->btype = btype = (enum cirrus_board) ent->driver_data;
 
-	DPRINTK(" Found PCI device, base address 0 is 0x%lx, btype set to %d\n",
+	DPRINTK(" Found PCI device, base address 0 is 0x%x, btype set to %d\n",
 		pdev->resource[0].start, btype);
-	DPRINTK(" base address 1 is 0x%lx\n", pdev->resource[1].start);
+	DPRINTK(" base address 1 is 0x%x\n", pdev->resource[1].start);
 
 	if (isPReP) {
 		pci_write_config_dword(pdev, PCI_BASE_ADDRESS_0, 0x00000000);
@@ -2647,7 +2647,7 @@ static int cirrusfb_zorro_register(struc
 {
 	struct cirrusfb_info *cinfo;
 	struct fb_info *info;
-	cirrusfb_board_t btype;
+	enum cirrus_board btype;
 	struct zorro_dev *z2 = NULL;
 	unsigned long board_addr, board_size, size;
 	int ret;
@@ -3353,7 +3353,7 @@ void cirrusfb_dbg_print_byte(const char 
 
 static
 void cirrusfb_dbg_print_regs(caddr_t regbase,
-			     cirrusfb_dbg_reg_class_t reg_class, ...)
+			     enum cirrusfb_dbg_reg_class reg_class, ...)
 {
 	va_list list;
 	unsigned char val = 0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
git-arm-master.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch

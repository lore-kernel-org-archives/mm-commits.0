From: akpm@linux-foundation.org
Subject: - cirrusfb-remove-typedefs.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:51 -0700
Message-ID: <200710162043.l9GKhpKv016088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39446 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758095AbXJPVIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: remove typedefs
has been removed from the -mm tree.  Its filename was
     cirrusfb-remove-typedefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 14 insertions(+), 14 deletions(-)

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
cyber2000fb-checkpatch-fixes.patch

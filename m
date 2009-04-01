From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-add-mmio-registers-for-laguna-chipsets.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:30 -0700
Message-ID: <200904011842.n31IgUtr009740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764279AbZDATEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: add mmio registers for Laguna chipsets
has been removed from the -mm tree.  Its filename was
     cirrusfb-add-mmio-registers-for-laguna-chipsets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: add mmio registers for Laguna chipsets
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The Laguna chipsets use special registers which are available through the
mmio area.  The cirrusfb driver does not use memory mapped registers for
the PCI cards.

Add the memory mapped area for Laguna chipsets and add basic usage of the
special Laguna registers after SVGALIB code.

This gives readable console at 16bpp on the GD-5465 (Laguna AGP).  The
8bpp and 32bpp depths are still broken.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff -puN drivers/video/cirrusfb.c~cirrusfb-add-mmio-registers-for-laguna-chipsets drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-add-mmio-registers-for-laguna-chipsets
+++ a/drivers/video/cirrusfb.c
@@ -327,6 +327,7 @@ enum cirrusfb_dbg_reg_class {
 /* info about board */
 struct cirrusfb_info {
 	u8 __iomem *regbase;
+	u8 __iomem *laguna_mmio;
 	enum cirrus_board btype;
 	unsigned char SFR;	/* Shadow of special function register */
 
@@ -699,6 +700,7 @@ static int cirrusfb_set_par_foo(struct f
 	int yres, vdispend, vsyncstart, vsyncend, vtotal;
 	long freq;
 	int nom, den, div;
+	unsigned int control, format, threshold;
 
 	dev_dbg(info->device, "Requested mode: %dx%dx%d\n",
 	       var->xres, var->yres, var->bits_per_pixel);
@@ -866,6 +868,23 @@ static int cirrusfb_set_par_foo(struct f
 			cirrusfb_set_mclk_as_source(info, divMCLK);
 		}
 	}
+	if (cinfo->btype == BT_LAGUNA) {
+		long pcifc = fb_readl(cinfo->laguna_mmio + 0x3fc);
+		unsigned char tile = fb_readb(cinfo->laguna_mmio + 0x407);
+		unsigned short tile_control;
+
+		tile_control = fb_readw(cinfo->laguna_mmio + 0x2c4);
+		fb_writew(tile_control & ~0x80, cinfo->laguna_mmio + 0x2c4);
+
+		fb_writel(pcifc | 0x10000000l, cinfo->laguna_mmio + 0x3fc);
+		fb_writeb(tile & 0x3f, cinfo->laguna_mmio + 0x407);
+		control = fb_readw(cinfo->laguna_mmio + 0x402);
+		threshold = fb_readw(cinfo->laguna_mmio + 0xea);
+		control &= ~0x6800;
+		format = 0;
+		threshold &= 0xffe0;
+		threshold &= 0x3fbf;
+	}
 	if (nom) {
 		tmp = den << 1;
 		if (div != 0)
@@ -1035,6 +1054,7 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_LAGUNA:
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) | 0x01);
+			threshold |= 0x10;
 			break;
 
 		default:
@@ -1146,6 +1166,9 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_LAGUNA:
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) & ~0x01);
+			control |= 0x2000;
+			format |= 0x1400;
+			threshold |= 0x10;
 			break;
 
 		default:
@@ -1220,6 +1243,9 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_LAGUNA:
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) & ~0x01);
+			control |= 0x6000;
+			format |= 0x3400;
+			threshold |= 0x20;
 			break;
 
 		default:
@@ -1327,6 +1353,12 @@ static int cirrusfb_set_par_foo(struct f
 	/* graphics cursor attributes: nothing special */
 	vga_wseq(regbase, CL_SEQR12, 0x0);
 
+	if (cinfo->btype == BT_LAGUNA) {
+		/* no tiles */
+		fb_writew(control | 0x1000, cinfo->laguna_mmio + 0x402);
+		fb_writew(format, cinfo->laguna_mmio + 0xc0);
+		fb_writew(threshold, cinfo->laguna_mmio + 0xea);
+	}
 	/* finally, turn on everything - turn off "FullBandwidth" bit */
 	/* also, set "DotClock%2" bit where requested */
 	tmp = 0x01;
@@ -2000,7 +2032,10 @@ static void get_pci_addrs(const struct p
 static void cirrusfb_pci_unmap(struct fb_info *info)
 {
 	struct pci_dev *pdev = to_pci_dev(info->device);
+	struct cirrusfb_info *cinfo = info->par;
 
+	if (cinfo->laguna_mmio == NULL)
+		iounmap(cinfo->laguna_mmio);
 	iounmap(info->screen_base);
 #if 0 /* if system didn't claim this region, we would... */
 	release_mem_region(0xA0000, 65535);
@@ -2180,6 +2215,7 @@ static int __devinit cirrusfb_pci_regist
 		get_pci_addrs(pdev, &board_addr, &info->fix.mmio_start);
 		/* FIXME: this forces VGA.  alternatives? */
 		cinfo->regbase = NULL;
+		cinfo->laguna_mmio = ioremap(info->fix.mmio_start, 0x1000);
 	}
 
 	dev_dbg(info->device, "Board address: 0x%lx, register address: 0x%lx\n",
@@ -2234,6 +2270,8 @@ err_release_regions:
 #endif
 	pci_release_regions(pdev);
 err_release_fb:
+	if (cinfo->laguna_mmio == NULL)
+		iounmap(cinfo->laguna_mmio);
 	framebuffer_release(info);
 err_disable:
 err_out:
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch


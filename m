From: akpm@osdl.org
Subject: - mbxfb-add-more-registers-bits.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:39 -0800
Message-ID: <200612082013.kB8KDdng003108@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59751 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946824AbWLHUO0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raph@8d.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mbxfb: Add more registers bits 	access macros
has been removed from the -mm tree.  Its filename was
     mbxfb-add-more-registers-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mbxfb: Add more registers bits 	access macros
From: Raphael Assenat <raph@8d.com>

This patch adds register bits access macros for chip's Video Plane, Scaling
and interrupt registers.

Signed-off-by: Raphael Assenat <raph@8d.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/mbx/reg_bits.h |  114 ++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 2 deletions(-)

diff -puN drivers/video/mbx/reg_bits.h~mbxfb-add-more-registers-bits drivers/video/mbx/reg_bits.h
--- a/drivers/video/mbx/reg_bits.h~mbxfb-add-more-registers-bits
+++ a/drivers/video/mbx/reg_bits.h
@@ -242,6 +242,67 @@
 #define GPLUT_LUTDATA	Fld(24,0)
 #define Gplut_Lutdata(x)	((x) << FShft(GPLUT_LUTDATA))
 
+/* VSCTRL - Video Surface Control Register */
+#define VSCTRL_VPIXFMT		Fld(4,27)
+#define VSCTRL_VPIXFMT_YUV12	((0x9) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_VPIXFMT_UY0VY1	((0xc) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_VPIXFMT_VY0UY1	((0xd) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_VPIXFMT_Y0UY1V	((0xe) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_VPIXFMT_Y0VY1U	((0xf) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_GAMMA_EN		(1 << 26)
+#define VSCTRL_CSC_EN		(1 << 25)
+#define VSCTRL_COSITED		(1 << 22)
+#define VSCTRL_VSWIDTH		Fld(11,11)
+#define Vsctrl_Width(Pixels) /* Video Width [1-2048] */ \
+			(((Pixels) - 1) << FShft(VSCTRL_VSWIDTH))
+#define VSCTRL_VSHEIGHT		Fld(11,0)
+#define Vsctrl_Height(Pixels) /* Video Height [1-2048] */ \
+			(((Pixels) - 1) << FShft(VSCTRL_VSHEIGHT))
+
+/* VBBASE - Video Blending Base Register */
+#define VBBASE_GLALPHA		Fld(8,24)
+#define Vbbase_Glalpha(x)	((x) << FShft(VBBASE_GLALPHA))
+
+#define VBBASE_COLKEY		Fld(24,0)
+#define Vbbase_Colkey(x)	((x) << FShft(VBBASE_COLKEY))
+
+/* VCMSK - Video Color Key Mask Register */
+#define VCMSK_COLKEY_M		Fld(24,0)
+#define Vcmsk_colkey_m(x)	((x) << FShft(VCMSK_COLKEY_M))
+
+/* VSCADR - Video Stream Control Rddress Register */
+#define VSCADR_STR_EN		(1 << 31)
+#define VSCADR_COLKEY_EN	(1 << 30)
+#define VSCADR_COLKEYSRC	(1 << 29)
+#define VSCADR_BLEND_M		Fld(2,27)
+#define VSCADR_BLEND_NONE	((0x0) << FShft(VSCADR_BLEND_M))
+#define VSCADR_BLEND_INV	((0x1) << FShft(VSCADR_BLEND_M))
+#define VSCADR_BLEND_GLOB	((0x2) << FShft(VSCADR_BLEND_M))
+#define VSCADR_BLEND_PIX	((0x3) << FShft(VSCADR_BLEND_M))
+#define VSCADR_BLEND_POS	Fld(2,24)
+#define VSCADR_BLEND_GFX	((0x0) << FShft(VSCADR_BLEND_POS))
+#define VSCADR_BLEND_VID	((0x1) << FShft(VSCADR_BLEND_POS))
+#define VSCADR_BLEND_CUR	((0x2) << FShft(VSCADR_BLEND_POS))
+#define VSCADR_VBASE_ADR	Fld(23,0)
+#define Vscadr_Vbase_Adr(x)	((x) << FShft(VSCADR_VBASE_ADR))
+
+/* VUBASE - Video U Base Register */
+#define VUBASE_UVHALFSTR	(1 << 31)
+#define VUBASE_UBASE_ADR	Fld(24,0)
+#define Vubase_Ubase_Adr(x)	((x) << FShft(VUBASE_UBASE_ADR))
+
+/* VVBASE - Video V Base Register */
+#define VVBASE_VBASE_ADR	Fld(24,0)
+#define Vvbase_Vbase_Adr(x)	((x) << FShft(VVBASE_VBASE_ADR))
+
+/* VSADR - Video Stride Address Register */
+#define VSADR_SRCSTRIDE		Fld(10,22)
+#define Vsadr_Srcstride(x)	((x) << FShft(VSADR_SRCSTRIDE))
+#define VSADR_XSTART		Fld(11,11)
+#define Vsadr_Xstart(x)		((x) << FShft(VSADR_XSTART))
+#define VSADR_YSTART		Fld(11,0)
+#define Vsadr_Ystart(x)		((x) << FShft(VSADR_YSTART))
+
 /* HCCTRL - Hardware Cursor Register fields */
 #define HCCTRL_CUR_EN	(1 << 31)
 #define HCCTRL_COLKEY_EN	(1 << 29)
@@ -394,6 +455,30 @@
 #define DMCTRL_BURSTLEN	Fld(6,0)
 #define Dmctrl_Burstlen(x)	((x) << FShft(DMCTRL_BURSTLEN))
 
+/* DINTRS - Display Interrupt Status Register */
+#define DINTRS_CUR_OR_S		(1 << 18)
+#define DINTRS_STR2_OR_S	(1 << 17)
+#define DINTRS_STR1_OR_S	(1 << 16)
+#define DINTRS_CUR_UR_S		(1 << 6)
+#define DINTRS_STR2_UR_S	(1 << 5)
+#define DINTRS_STR1_UR_S	(1 << 4)
+#define DINTRS_VEVENT1_S	(1 << 3)
+#define DINTRS_VEVENT0_S	(1 << 2)
+#define DINTRS_HBLNK1_S		(1 << 1)
+#define DINTRS_HBLNK0_S		(1 << 0)
+
+/* DINTRE - Display Interrupt Enable Register */
+#define DINTRE_CUR_OR_EN	(1 << 18)
+#define DINTRE_STR2_OR_EN	(1 << 17)
+#define DINTRE_STR1_OR_EN	(1 << 16)
+#define DINTRE_CUR_UR_EN	(1 << 6)
+#define DINTRE_STR2_UR_EN	(1 << 5)
+#define DINTRE_STR1_UR_EN	(1 << 4)
+#define DINTRE_VEVENT1_EN	(1 << 3)
+#define DINTRE_VEVENT0_EN	(1 << 2)
+#define DINTRE_HBLNK1_EN	(1 << 1)
+#define DINTRE_HBLNK0_EN	(1 << 0)
+
 
 /* DLSTS - display load status register */
 #define DLSTS_RLD_ADONE	(1 << 23)
@@ -403,16 +488,41 @@
 #define DLLCTRL_RLD_ADRLN	Fld(8,24)
 #define Dllctrl_Rld_Adrln(x)	((x) << FShft(DLLCTRL_RLD_ADRLN))
 
+/* CLIPCTRL - Clipping Control Register */
+#define CLIPCTRL_HSKIP		Fld(11,16)
+#define Clipctrl_Hskip		((x) << FShft(CLIPCTRL_HSKIP))
+#define CLIPCTRL_VSKIP		Fld(11,0)
+#define Clipctrl_Vskip		((x) << FShft(CLIPCTRL_VSKIP))
+
 /* SPOCTRL - Scale Pitch/Order Control Register */
 #define SPOCTRL_H_SC_BP		(1 << 31)
 #define SPOCTRL_V_SC_BP		(1 << 30)
 #define SPOCTRL_HV_SC_OR	(1 << 29)
 #define SPOCTRL_VS_UR_C		(1 << 27)
-#define SPOCTRL_VORDER	Fld(2,16)
+#define SPOCTRL_VORDER		Fld(2,16)
 #define SPOCTRL_VORDER_1TAP	((0x0) << FShft(SPOCTRL_VORDER))
 #define SPOCTRL_VORDER_2TAP	((0x1) << FShft(SPOCTRL_VORDER))
 #define SPOCTRL_VORDER_4TAP	((0x3) << FShft(SPOCTRL_VORDER))
-#define SPOCTRL_VPITCH	Fld(16,0)
+#define SPOCTRL_VPITCH		Fld(16,0)
 #define Spoctrl_Vpitch(x)	((x) << FShft(SPOCTRL_VPITCH))
 
+/* SVCTRL - Scale Vertical Control Register */
+#define SVCTRL_INITIAL1		Fld(16,16)
+#define Svctrl_Initial1(x)	((x) << FShft(SVCTRL_INITIAL1))
+#define SVCTRL_INITIAL2		Fld(16,0)
+#define Svctrl_Initial2(x)	((x) << FShft(SVCTRL_INITIAL2))
+
+/* SHCTRL - Scale Horizontal Control Register */
+#define SHCTRL_HINITIAL		Fld(16,16)
+#define Shctrl_Hinitial(x)	((x) << FShft(SHCTRL_HINITIAL))
+#define SHCTRL_HDECIM		(1 << 15)
+#define SHCTRL_HPITCH		Fld(15,0)
+#define Shctrl_Hpitch(x)	((x) << FShft(SHCTRL_HPITCH))
+
+/* SSSIZE - Scale Surface Size Register */
+#define SSSIZE_SC_WIDTH		Fld(11,16)
+#define Sssize_Sc_Width(x)	((x) << FShft(SSSIZE_SC_WIDTH))
+#define SSSIZE_SC_HEIGHT	Fld(11,0)
+#define Sssize_Sc_Height(x)	((x) << FShft(SSSIZE_SC_HEIGHT))
+
 #endif /* __REG_BITS_2700G_ */
_

Patches currently in -mm which might be from raph@8d.com are

mbxfb-add-more-registers-bits.patch
mbxfb-add-more-registers-to-debugfs.patch
mbxfb-add-yuv-video-overlay-support.patch
mbxfb-document-the-new-ioctl.patch


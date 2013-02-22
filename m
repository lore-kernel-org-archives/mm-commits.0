From: akpm@linux-foundation.org
Subject: [merged] video-s3c-fb-remove-unnecessary-brackets.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:37 -0800
Message-ID: <20130222203837.A51A531C208@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:58299 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:38 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so103730ghb.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, FlorianSchandinat@gmx.de, kyungmin.park@samsung.com, t.figa@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: s3c-fb: remove unnecessary brackets
has been removed from the -mm tree.  Its filename was
     video-s3c-fb-remove-unnecessary-brackets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: video: s3c-fb: remove unnecessary brackets

Remove unnecessary brackets and the duplicated VIDTCON2 definition.

Also, header comment is modified, because EXYNOS series is supported and
<mach/regs-fb.h> is not available.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/samsung_fimd.h |  199 ++++++++++++++++-----------------
 1 file changed, 97 insertions(+), 102 deletions(-)

diff -puN include/video/samsung_fimd.h~video-s3c-fb-remove-unnecessary-brackets include/video/samsung_fimd.h
--- a/include/video/samsung_fimd.h~video-s3c-fb-remove-unnecessary-brackets
+++ a/include/video/samsung_fimd.h
@@ -8,12 +8,8 @@
  * S3C Platform - new-style fimd and framebuffer register definitions
  *
  * This is the register set for the fimd and new style framebuffer interface
- * found from the S3C2443 onwards into the S3C2416, S3C2450 and the
- * S3C64XX series such as the S3C6400 and S3C6410.
- *
- * The file does not contain the cpu specific items which are based on
- * whichever architecture is selected, it only contains the core of the
- * register set. See <mach/regs-fb.h> to get the specifics.
+ * found from the S3C2443 onwards into the S3C2416, S3C2450, the
+ * S3C64XX series such as the S3C6400 and S3C6410, and EXYNOS series.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -22,10 +18,10 @@
 
 /* VIDCON0 */
 
-#define VIDCON0					(0x00)
+#define VIDCON0					0x00
 #define VIDCON0_INTERLACE			(1 << 29)
 #define VIDCON0_VIDOUT_MASK			(0x7 << 26)
-#define VIDCON0_VIDOUT_SHIFT			(26)
+#define VIDCON0_VIDOUT_SHIFT			26
 #define VIDCON0_VIDOUT_RGB			(0x0 << 26)
 #define VIDCON0_VIDOUT_TV			(0x1 << 26)
 #define VIDCON0_VIDOUT_I80_LDI0			(0x2 << 26)
@@ -35,7 +31,7 @@
 #define VIDCON0_VIDOUT_WB_I80_LDI1		(0x7 << 26)
 
 #define VIDCON0_L1_DATA_MASK			(0x7 << 23)
-#define VIDCON0_L1_DATA_SHIFT			(23)
+#define VIDCON0_L1_DATA_SHIFT			23
 #define VIDCON0_L1_DATA_16BPP			(0x0 << 23)
 #define VIDCON0_L1_DATA_18BPP16			(0x1 << 23)
 #define VIDCON0_L1_DATA_18BPP9			(0x2 << 23)
@@ -44,7 +40,7 @@
 #define VIDCON0_L1_DATA_16BPP8			(0x5 << 23)
 
 #define VIDCON0_L0_DATA_MASK			(0x7 << 20)
-#define VIDCON0_L0_DATA_SHIFT			(20)
+#define VIDCON0_L0_DATA_SHIFT			20
 #define VIDCON0_L0_DATA_16BPP			(0x0 << 20)
 #define VIDCON0_L0_DATA_18BPP16			(0x1 << 20)
 #define VIDCON0_L0_DATA_18BPP9			(0x2 << 20)
@@ -53,7 +49,7 @@
 #define VIDCON0_L0_DATA_16BPP8			(0x5 << 20)
 
 #define VIDCON0_PNRMODE_MASK			(0x3 << 17)
-#define VIDCON0_PNRMODE_SHIFT			(17)
+#define VIDCON0_PNRMODE_SHIFT			17
 #define VIDCON0_PNRMODE_RGB			(0x0 << 17)
 #define VIDCON0_PNRMODE_BGR			(0x1 << 17)
 #define VIDCON0_PNRMODE_SERIAL_RGB		(0x2 << 17)
@@ -61,14 +57,14 @@
 
 #define VIDCON0_CLKVALUP			(1 << 16)
 #define VIDCON0_CLKVAL_F_MASK			(0xff << 6)
-#define VIDCON0_CLKVAL_F_SHIFT			(6)
-#define VIDCON0_CLKVAL_F_LIMIT			(0xff)
+#define VIDCON0_CLKVAL_F_SHIFT			6
+#define VIDCON0_CLKVAL_F_LIMIT			0xff
 #define VIDCON0_CLKVAL_F(_x)			((_x) << 6)
 #define VIDCON0_VLCKFREE			(1 << 5)
 #define VIDCON0_CLKDIR				(1 << 4)
 
 #define VIDCON0_CLKSEL_MASK			(0x3 << 2)
-#define VIDCON0_CLKSEL_SHIFT			(2)
+#define VIDCON0_CLKSEL_SHIFT			2
 #define VIDCON0_CLKSEL_HCLK			(0x0 << 2)
 #define VIDCON0_CLKSEL_LCD			(0x1 << 2)
 #define VIDCON0_CLKSEL_27M			(0x3 << 2)
@@ -76,13 +72,13 @@
 #define VIDCON0_ENVID				(1 << 1)
 #define VIDCON0_ENVID_F				(1 << 0)
 
-#define VIDCON1					(0x04)
+#define VIDCON1					0x04
 #define VIDCON1_LINECNT_MASK			(0x7ff << 16)
-#define VIDCON1_LINECNT_SHIFT			(16)
+#define VIDCON1_LINECNT_SHIFT			16
 #define VIDCON1_LINECNT_GET(_v)			(((_v) >> 16) & 0x7ff)
 #define VIDCON1_FSTATUS_EVEN			(1 << 15)
 #define VIDCON1_VSTATUS_MASK			(0x3 << 13)
-#define VIDCON1_VSTATUS_SHIFT			(13)
+#define VIDCON1_VSTATUS_SHIFT			13
 #define VIDCON1_VSTATUS_VSYNC			(0x0 << 13)
 #define VIDCON1_VSTATUS_BACKPORCH		(0x1 << 13)
 #define VIDCON1_VSTATUS_ACTIVE			(0x2 << 13)
@@ -98,12 +94,12 @@
 
 /* VIDCON2 */
 
-#define VIDCON2					(0x08)
+#define VIDCON2					0x08
 #define VIDCON2_EN601				(1 << 23)
 #define VIDCON2_TVFMTSEL_SW			(1 << 14)
 
 #define VIDCON2_TVFMTSEL1_MASK			(0x3 << 12)
-#define VIDCON2_TVFMTSEL1_SHIFT			(12)
+#define VIDCON2_TVFMTSEL1_SHIFT			12
 #define VIDCON2_TVFMTSEL1_RGB			(0x0 << 12)
 #define VIDCON2_TVFMTSEL1_YUV422		(0x1 << 12)
 #define VIDCON2_TVFMTSEL1_YUV444		(0x2 << 12)
@@ -115,74 +111,73 @@
  * Might not be present in the S3C6410 documentation,
  * but tests prove it's there almost for sure; shouldn't hurt in any case.
  */
-#define PRTCON					(0x0c)
+#define PRTCON					0x0c
 #define PRTCON_PROTECT				(1 << 11)
 
 /* VIDTCON0 */
 
-#define VIDTCON0				(0x10)
+#define VIDTCON0				0x10
 #define VIDTCON0_VBPDE_MASK			(0xff << 24)
-#define VIDTCON0_VBPDE_SHIFT			(24)
-#define VIDTCON0_VBPDE_LIMIT			(0xff)
+#define VIDTCON0_VBPDE_SHIFT			24
+#define VIDTCON0_VBPDE_LIMIT			0xff
 #define VIDTCON0_VBPDE(_x)			((_x) << 24)
 
 #define VIDTCON0_VBPD_MASK			(0xff << 16)
-#define VIDTCON0_VBPD_SHIFT			(16)
-#define VIDTCON0_VBPD_LIMIT			(0xff)
+#define VIDTCON0_VBPD_SHIFT			16
+#define VIDTCON0_VBPD_LIMIT			0xff
 #define VIDTCON0_VBPD(_x)			((_x) << 16)
 
 #define VIDTCON0_VFPD_MASK			(0xff << 8)
-#define VIDTCON0_VFPD_SHIFT			(8)
-#define VIDTCON0_VFPD_LIMIT			(0xff)
+#define VIDTCON0_VFPD_SHIFT			8
+#define VIDTCON0_VFPD_LIMIT			0xff
 #define VIDTCON0_VFPD(_x)			((_x) << 8)
 
 #define VIDTCON0_VSPW_MASK			(0xff << 0)
-#define VIDTCON0_VSPW_SHIFT			(0)
-#define VIDTCON0_VSPW_LIMIT			(0xff)
+#define VIDTCON0_VSPW_SHIFT			0
+#define VIDTCON0_VSPW_LIMIT			0xff
 #define VIDTCON0_VSPW(_x)			((_x) << 0)
 
 /* VIDTCON1 */
 
-#define VIDTCON1				(0x14)
+#define VIDTCON1				0x14
 #define VIDTCON1_VFPDE_MASK			(0xff << 24)
-#define VIDTCON1_VFPDE_SHIFT			(24)
-#define VIDTCON1_VFPDE_LIMIT			(0xff)
+#define VIDTCON1_VFPDE_SHIFT			24
+#define VIDTCON1_VFPDE_LIMIT			0xff
 #define VIDTCON1_VFPDE(_x)			((_x) << 24)
 
 #define VIDTCON1_HBPD_MASK			(0xff << 16)
-#define VIDTCON1_HBPD_SHIFT			(16)
-#define VIDTCON1_HBPD_LIMIT			(0xff)
+#define VIDTCON1_HBPD_SHIFT			16
+#define VIDTCON1_HBPD_LIMIT			0xff
 #define VIDTCON1_HBPD(_x)			((_x) << 16)
 
 #define VIDTCON1_HFPD_MASK			(0xff << 8)
-#define VIDTCON1_HFPD_SHIFT			(8)
-#define VIDTCON1_HFPD_LIMIT			(0xff)
+#define VIDTCON1_HFPD_SHIFT			8
+#define VIDTCON1_HFPD_LIMIT			0xff
 #define VIDTCON1_HFPD(_x)			((_x) << 8)
 
 #define VIDTCON1_HSPW_MASK			(0xff << 0)
-#define VIDTCON1_HSPW_SHIFT			(0)
-#define VIDTCON1_HSPW_LIMIT			(0xff)
+#define VIDTCON1_HSPW_SHIFT			0
+#define VIDTCON1_HSPW_LIMIT			0xff
 #define VIDTCON1_HSPW(_x)			((_x) << 0)
 
-#define VIDTCON2				(0x18)
-#define VIDTCON2				(0x18)
+#define VIDTCON2				0x18
 #define VIDTCON2_LINEVAL_E(_x)			((((_x) & 0x800) >> 11) << 23)
 #define VIDTCON2_LINEVAL_MASK			(0x7ff << 11)
-#define VIDTCON2_LINEVAL_SHIFT			(11)
-#define VIDTCON2_LINEVAL_LIMIT			(0x7ff)
+#define VIDTCON2_LINEVAL_SHIFT			11
+#define VIDTCON2_LINEVAL_LIMIT			0x7ff
 #define VIDTCON2_LINEVAL(_x)			(((_x) & 0x7ff) << 11)
 
 #define VIDTCON2_HOZVAL_E(_x)			((((_x) & 0x800) >> 11) << 22)
 #define VIDTCON2_HOZVAL_MASK			(0x7ff << 0)
-#define VIDTCON2_HOZVAL_SHIFT			(0)
-#define VIDTCON2_HOZVAL_LIMIT			(0x7ff)
+#define VIDTCON2_HOZVAL_SHIFT			0
+#define VIDTCON2_HOZVAL_LIMIT			0x7ff
 #define VIDTCON2_HOZVAL(_x)			(((_x) & 0x7ff) << 0)
 
 /* WINCONx */
 
 #define WINCON(_win)				(0x20 + ((_win) * 4))
 #define WINCONx_CSCWIDTH_MASK			(0x3 << 26)
-#define WINCONx_CSCWIDTH_SHIFT			(26)
+#define WINCONx_CSCWIDTH_SHIFT			26
 #define WINCONx_CSCWIDTH_WIDE			(0x0 << 26)
 #define WINCONx_CSCWIDTH_NARROW			(0x3 << 26)
 #define WINCONx_ENLOCAL				(1 << 22)
@@ -195,14 +190,14 @@
 #define WINCONx_WSWP				(1 << 15)
 #define WINCONx_YCbCr				(1 << 13)
 #define WINCONx_BURSTLEN_MASK			(0x3 << 9)
-#define WINCONx_BURSTLEN_SHIFT			(9)
+#define WINCONx_BURSTLEN_SHIFT			9
 #define WINCONx_BURSTLEN_16WORD			(0x0 << 9)
 #define WINCONx_BURSTLEN_8WORD			(0x1 << 9)
 #define WINCONx_BURSTLEN_4WORD			(0x2 << 9)
 #define WINCONx_ENWIN				(1 << 0)
 
 #define WINCON0_BPPMODE_MASK			(0xf << 2)
-#define WINCON0_BPPMODE_SHIFT			(2)
+#define WINCON0_BPPMODE_SHIFT			2
 #define WINCON0_BPPMODE_1BPP			(0x0 << 2)
 #define WINCON0_BPPMODE_2BPP			(0x1 << 2)
 #define WINCON0_BPPMODE_4BPP			(0x2 << 2)
@@ -215,7 +210,7 @@
 #define WINCON1_LOCALSEL_CAMIF			(1 << 23)
 #define WINCON1_BLD_PIX				(1 << 6)
 #define WINCON1_BPPMODE_MASK			(0xf << 2)
-#define WINCON1_BPPMODE_SHIFT			(2)
+#define WINCON1_BPPMODE_SHIFT			2
 #define WINCON1_BPPMODE_1BPP			(0x0 << 2)
 #define WINCON1_BPPMODE_2BPP			(0x1 << 2)
 #define WINCON1_BPPMODE_4BPP			(0x2 << 2)
@@ -234,7 +229,7 @@
 #define WINCON1_ALPHA_SEL			(1 << 1)
 
 /* S5PV210 */
-#define SHADOWCON				(0x34)
+#define SHADOWCON				0x34
 #define SHADOWCON_WINx_PROTECT(_win)		(1 << (10 + (_win)))
 /* DMA channels (all windows) */
 #define SHADOWCON_CHx_ENABLE(_win)		(1 << (_win))
@@ -243,52 +238,52 @@
 
 /* VIDOSDx */
 
-#define VIDOSD_BASE				(0x40)
+#define VIDOSD_BASE				0x40
 #define VIDOSDxA_TOPLEFT_X_E(_x)		((((_x) & 0x800) >> 11) << 23)
 #define VIDOSDxA_TOPLEFT_X_MASK			(0x7ff << 11)
-#define VIDOSDxA_TOPLEFT_X_SHIFT		(11)
-#define VIDOSDxA_TOPLEFT_X_LIMIT		(0x7ff)
+#define VIDOSDxA_TOPLEFT_X_SHIFT		11
+#define VIDOSDxA_TOPLEFT_X_LIMIT		0x7ff
 #define VIDOSDxA_TOPLEFT_X(_x)			(((_x) & 0x7ff) << 11)
 
 #define VIDOSDxA_TOPLEFT_Y_E(_x)		((((_x) & 0x800) >> 11) << 22)
 #define VIDOSDxA_TOPLEFT_Y_MASK			(0x7ff << 0)
-#define VIDOSDxA_TOPLEFT_Y_SHIFT		(0)
-#define VIDOSDxA_TOPLEFT_Y_LIMIT		(0x7ff)
+#define VIDOSDxA_TOPLEFT_Y_SHIFT		0
+#define VIDOSDxA_TOPLEFT_Y_LIMIT		0x7ff
 #define VIDOSDxA_TOPLEFT_Y(_x)			(((_x) & 0x7ff) << 0)
 
 #define VIDOSDxB_BOTRIGHT_X_E(_x)		((((_x) & 0x800) >> 11) << 23)
 #define VIDOSDxB_BOTRIGHT_X_MASK		(0x7ff << 11)
-#define VIDOSDxB_BOTRIGHT_X_SHIFT		(11)
-#define VIDOSDxB_BOTRIGHT_X_LIMIT		(0x7ff)
+#define VIDOSDxB_BOTRIGHT_X_SHIFT		11
+#define VIDOSDxB_BOTRIGHT_X_LIMIT		0x7ff
 #define VIDOSDxB_BOTRIGHT_X(_x)			(((_x) & 0x7ff) << 11)
 
 #define VIDOSDxB_BOTRIGHT_Y_E(_x)		((((_x) & 0x800) >> 11) << 22)
 #define VIDOSDxB_BOTRIGHT_Y_MASK		(0x7ff << 0)
-#define VIDOSDxB_BOTRIGHT_Y_SHIFT		(0)
-#define VIDOSDxB_BOTRIGHT_Y_LIMIT		(0x7ff)
+#define VIDOSDxB_BOTRIGHT_Y_SHIFT		0
+#define VIDOSDxB_BOTRIGHT_Y_LIMIT		0x7ff
 #define VIDOSDxB_BOTRIGHT_Y(_x)			(((_x) & 0x7ff) << 0)
 
 /* For VIDOSD[1..4]C */
 #define VIDISD14C_ALPHA0_R(_x)			((_x) << 20)
 #define VIDISD14C_ALPHA0_G_MASK			(0xf << 16)
-#define VIDISD14C_ALPHA0_G_SHIFT		(16)
-#define VIDISD14C_ALPHA0_G_LIMIT		(0xf)
+#define VIDISD14C_ALPHA0_G_SHIFT		16
+#define VIDISD14C_ALPHA0_G_LIMIT		0xf
 #define VIDISD14C_ALPHA0_G(_x)			((_x) << 16)
 #define VIDISD14C_ALPHA0_B_MASK			(0xf << 12)
-#define VIDISD14C_ALPHA0_B_SHIFT		(12)
-#define VIDISD14C_ALPHA0_B_LIMIT		(0xf)
+#define VIDISD14C_ALPHA0_B_SHIFT		12
+#define VIDISD14C_ALPHA0_B_LIMIT		0xf
 #define VIDISD14C_ALPHA0_B(_x)			((_x) << 12)
 #define VIDISD14C_ALPHA1_R_MASK			(0xf << 8)
-#define VIDISD14C_ALPHA1_R_SHIFT		(8)
-#define VIDISD14C_ALPHA1_R_LIMIT		(0xf)
+#define VIDISD14C_ALPHA1_R_SHIFT		8
+#define VIDISD14C_ALPHA1_R_LIMIT		0xf
 #define VIDISD14C_ALPHA1_R(_x)			((_x) << 8)
 #define VIDISD14C_ALPHA1_G_MASK			(0xf << 4)
-#define VIDISD14C_ALPHA1_G_SHIFT		(4)
-#define VIDISD14C_ALPHA1_G_LIMIT		(0xf)
+#define VIDISD14C_ALPHA1_G_SHIFT		4
+#define VIDISD14C_ALPHA1_G_LIMIT		0xf
 #define VIDISD14C_ALPHA1_G(_x)			((_x) << 4)
 #define VIDISD14C_ALPHA1_B_MASK			(0xf << 0)
-#define VIDISD14C_ALPHA1_B_SHIFT		(0)
-#define VIDISD14C_ALPHA1_B_LIMIT		(0xf)
+#define VIDISD14C_ALPHA1_B_SHIFT		0
+#define VIDISD14C_ALPHA1_B_LIMIT		0xf
 #define VIDISD14C_ALPHA1_B(_x)			((_x) << 0)
 
 /* Video buffer addresses */
@@ -300,22 +295,22 @@
 
 #define VIDW_BUF_SIZE_OFFSET_E(_x)		((((_x) & 0x2000) >> 13) << 27)
 #define VIDW_BUF_SIZE_OFFSET_MASK		(0x1fff << 13)
-#define VIDW_BUF_SIZE_OFFSET_SHIFT		(13)
-#define VIDW_BUF_SIZE_OFFSET_LIMIT		(0x1fff)
+#define VIDW_BUF_SIZE_OFFSET_SHIFT		13
+#define VIDW_BUF_SIZE_OFFSET_LIMIT		0x1fff
 #define VIDW_BUF_SIZE_OFFSET(_x)		(((_x) & 0x1fff) << 13)
 
 #define VIDW_BUF_SIZE_PAGEWIDTH_E(_x)		((((_x) & 0x2000) >> 13) << 26)
 #define VIDW_BUF_SIZE_PAGEWIDTH_MASK		(0x1fff << 0)
-#define VIDW_BUF_SIZE_PAGEWIDTH_SHIFT		(0)
-#define VIDW_BUF_SIZE_PAGEWIDTH_LIMIT		(0x1fff)
+#define VIDW_BUF_SIZE_PAGEWIDTH_SHIFT		0
+#define VIDW_BUF_SIZE_PAGEWIDTH_LIMIT		0x1fff
 #define VIDW_BUF_SIZE_PAGEWIDTH(_x)		(((_x) & 0x1fff) << 0)
 
 /* Interrupt controls and status */
 
-#define VIDINTCON0				(0x130)
+#define VIDINTCON0				0x130
 #define VIDINTCON0_FIFOINTERVAL_MASK		(0x3f << 20)
-#define VIDINTCON0_FIFOINTERVAL_SHIFT		(20)
-#define VIDINTCON0_FIFOINTERVAL_LIMIT		(0x3f)
+#define VIDINTCON0_FIFOINTERVAL_SHIFT		20
+#define VIDINTCON0_FIFOINTERVAL_LIMIT		0x3f
 #define VIDINTCON0_FIFOINTERVAL(_x)		((_x) << 20)
 
 #define VIDINTCON0_INT_SYSMAINCON		(1 << 19)
@@ -323,7 +318,7 @@
 #define VIDINTCON0_INT_I80IFDONE		(1 << 17)
 
 #define VIDINTCON0_FRAMESEL0_MASK		(0x3 << 15)
-#define VIDINTCON0_FRAMESEL0_SHIFT		(15)
+#define VIDINTCON0_FRAMESEL0_SHIFT		15
 #define VIDINTCON0_FRAMESEL0_BACKPORCH		(0x0 << 15)
 #define VIDINTCON0_FRAMESEL0_VSYNC		(0x1 << 15)
 #define VIDINTCON0_FRAMESEL0_ACTIVE		(0x2 << 15)
@@ -338,7 +333,7 @@
 
 #define VIDINTCON0_INT_FRAME			(1 << 12)
 #define VIDINTCON0_FIFIOSEL_MASK		(0x7f << 5)
-#define VIDINTCON0_FIFIOSEL_SHIFT		(5)
+#define VIDINTCON0_FIFIOSEL_SHIFT		5
 #define VIDINTCON0_FIFIOSEL_WINDOW0		(0x1 << 5)
 #define VIDINTCON0_FIFIOSEL_WINDOW1		(0x2 << 5)
 #define VIDINTCON0_FIFIOSEL_WINDOW2		(0x10 << 5)
@@ -346,7 +341,7 @@
 #define VIDINTCON0_FIFIOSEL_WINDOW4		(0x40 << 5)
 
 #define VIDINTCON0_FIFOLEVEL_MASK		(0x7 << 2)
-#define VIDINTCON0_FIFOLEVEL_SHIFT		(2)
+#define VIDINTCON0_FIFOLEVEL_SHIFT		2
 #define VIDINTCON0_FIFOLEVEL_TO25PC		(0x0 << 2)
 #define VIDINTCON0_FIFOLEVEL_TO50PC		(0x1 << 2)
 #define VIDINTCON0_FIFOLEVEL_TO75PC		(0x2 << 2)
@@ -354,46 +349,46 @@
 #define VIDINTCON0_FIFOLEVEL_FULL		(0x4 << 2)
 
 #define VIDINTCON0_INT_FIFO_MASK		(0x3 << 0)
-#define VIDINTCON0_INT_FIFO_SHIFT		(0)
+#define VIDINTCON0_INT_FIFO_SHIFT		0
 #define VIDINTCON0_INT_ENABLE			(1 << 0)
 
-#define VIDINTCON1				(0x134)
+#define VIDINTCON1				0x134
 #define VIDINTCON1_INT_I180			(1 << 2)
 #define VIDINTCON1_INT_FRAME			(1 << 1)
 #define VIDINTCON1_INT_FIFO			(1 << 0)
 
 /* Window colour-key control registers */
-#define WKEYCON					(0x140)	/* 6410,V210 */
+#define WKEYCON					0x140
 
-#define WKEYCON0				(0x00)
-#define WKEYCON1				(0x04)
+#define WKEYCON0				0x00
+#define WKEYCON1				0x04
 
 #define WxKEYCON0_KEYBL_EN			(1 << 26)
 #define WxKEYCON0_KEYEN_F			(1 << 25)
 #define WxKEYCON0_DIRCON			(1 << 24)
 #define WxKEYCON0_COMPKEY_MASK			(0xffffff << 0)
-#define WxKEYCON0_COMPKEY_SHIFT			(0)
-#define WxKEYCON0_COMPKEY_LIMIT			(0xffffff)
+#define WxKEYCON0_COMPKEY_SHIFT			0
+#define WxKEYCON0_COMPKEY_LIMIT			0xffffff
 #define WxKEYCON0_COMPKEY(_x)			((_x) << 0)
 #define WxKEYCON1_COLVAL_MASK			(0xffffff << 0)
-#define WxKEYCON1_COLVAL_SHIFT			(0)
-#define WxKEYCON1_COLVAL_LIMIT			(0xffffff)
+#define WxKEYCON1_COLVAL_SHIFT			0
+#define WxKEYCON1_COLVAL_LIMIT			0xffffff
 #define WxKEYCON1_COLVAL(_x)			((_x) << 0)
 
 /* Dithering control */
-#define DITHMODE				(0x170)
+#define DITHMODE				0x170
 #define DITHMODE_R_POS_MASK			(0x3 << 5)
-#define DITHMODE_R_POS_SHIFT			(5)
+#define DITHMODE_R_POS_SHIFT			5
 #define DITHMODE_R_POS_8BIT			(0x0 << 5)
 #define DITHMODE_R_POS_6BIT			(0x1 << 5)
 #define DITHMODE_R_POS_5BIT			(0x2 << 5)
 #define DITHMODE_G_POS_MASK			(0x3 << 3)
-#define DITHMODE_G_POS_SHIFT			(3)
+#define DITHMODE_G_POS_SHIFT			3
 #define DITHMODE_G_POS_8BIT			(0x0 << 3)
 #define DITHMODE_G_POS_6BIT			(0x1 << 3)
 #define DITHMODE_G_POS_5BIT			(0x2 << 3)
 #define DITHMODE_B_POS_MASK			(0x3 << 1)
-#define DITHMODE_B_POS_SHIFT			(1)
+#define DITHMODE_B_POS_SHIFT			1
 #define DITHMODE_B_POS_8BIT			(0x0 << 1)
 #define DITHMODE_B_POS_6BIT			(0x1 << 1)
 #define DITHMODE_B_POS_5BIT			(0x2 << 1)
@@ -403,18 +398,18 @@
 #define WINxMAP(_win)				(0x180 + ((_win) * 4))
 #define WINxMAP_MAP				(1 << 24)
 #define WINxMAP_MAP_COLOUR_MASK			(0xffffff << 0)
-#define WINxMAP_MAP_COLOUR_SHIFT		(0)
-#define WINxMAP_MAP_COLOUR_LIMIT		(0xffffff)
+#define WINxMAP_MAP_COLOUR_SHIFT		0
+#define WINxMAP_MAP_COLOUR_LIMIT		0xffffff
 #define WINxMAP_MAP_COLOUR(_x)			((_x) << 0)
 
 /* Winodw palette control */
-#define WPALCON					(0x1A0)
+#define WPALCON					0x1A0
 #define WPALCON_PAL_UPDATE			(1 << 9)
 #define WPALCON_W4PAL_16BPP_A555		(1 << 8)
 #define WPALCON_W3PAL_16BPP_A555		(1 << 7)
 #define WPALCON_W2PAL_16BPP_A555		(1 << 6)
 #define WPALCON_W1PAL_MASK			(0x7 << 3)
-#define WPALCON_W1PAL_SHIFT			(3)
+#define WPALCON_W1PAL_SHIFT			3
 #define WPALCON_W1PAL_25BPP_A888		(0x0 << 3)
 #define WPALCON_W1PAL_24BPP			(0x1 << 3)
 #define WPALCON_W1PAL_19BPP_A666		(0x2 << 3)
@@ -423,7 +418,7 @@
 #define WPALCON_W1PAL_16BPP_A555		(0x5 << 3)
 #define WPALCON_W1PAL_16BPP_565			(0x6 << 3)
 #define WPALCON_W0PAL_MASK			(0x7 << 0)
-#define WPALCON_W0PAL_SHIFT			(0)
+#define WPALCON_W0PAL_SHIFT			0
 #define WPALCON_W0PAL_25BPP_A888		(0x0 << 0)
 #define WPALCON_W0PAL_24BPP			(0x1 << 0)
 #define WPALCON_W0PAL_19BPP_A666		(0x2 << 0)
@@ -433,7 +428,7 @@
 #define WPALCON_W0PAL_16BPP_565			(0x6 << 0)
 
 /* Blending equation control */
-#define BLENDCON				(0x260)
+#define BLENDCON				0x260
 #define BLENDCON_NEW_MASK			(1 << 0)
 #define BLENDCON_NEW_8BIT_ALPHA_VALUE		(1 << 0)
 #define BLENDCON_NEW_4BIT_ALPHA_VALUE		(0 << 0)
@@ -460,8 +455,8 @@
 */
 
 /* FIMD Version 8 register offset definitions */
-#define FIMD_V8_VIDTCON0	(0x20010)
-#define FIMD_V8_VIDTCON1	(0x20014)
-#define FIMD_V8_VIDTCON2	(0x20018)
-#define FIMD_V8_VIDTCON3	(0x2001C)
-#define FIMD_V8_VIDCON1		(0x20004)
+#define FIMD_V8_VIDTCON0	0x20010
+#define FIMD_V8_VIDTCON1	0x20014
+#define FIMD_V8_VIDTCON2	0x20018
+#define FIMD_V8_VIDTCON3	0x2001C
+#define FIMD_V8_VIDCON1		0x20004
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


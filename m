From: akpm@linux-foundation.org
Subject: [merged] matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:04 -0700
Message-ID: <200909232003.n8NK34Re018474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296AbZIWUKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, krzysztof.h1@poczta.fm, vandrove@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     matroxfb: get rid of unneeded macros ACCESS_FBINFO and MINFO
has been removed from the -mm tree.  Its filename was
     matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: matroxfb: get rid of unneeded macros ACCESS_FBINFO and MINFO
From: Jean Delvare <khali@linux-fr.org>

With multihead support always enabled, these macros are no longer needed
and make the code harder to read.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/g450_pll.c         |   24 
 drivers/video/matrox/i2c-matroxfb.c     |    6 
 drivers/video/matrox/matroxfb_DAC1064.c |  378 ++++++-------
 drivers/video/matrox/matroxfb_Ti3026.c  |   96 +--
 drivers/video/matrox/matroxfb_accel.c   |   86 +--
 drivers/video/matrox/matroxfb_base.c    |  604 +++++++++++-----------
 drivers/video/matrox/matroxfb_base.h    |   27 
 drivers/video/matrox/matroxfb_crtc2.c   |  130 ++--
 drivers/video/matrox/matroxfb_g450.c    |   80 +-
 drivers/video/matrox/matroxfb_maven.c   |   38 -
 drivers/video/matrox/matroxfb_misc.c    |  210 +++----
 drivers/video/matrox/matroxfb_misc.h    |    2 
 12 files changed, 838 insertions(+), 843 deletions(-)

diff -puN drivers/video/matrox/g450_pll.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/g450_pll.c
--- a/drivers/video/matrox/g450_pll.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/g450_pll.c
@@ -30,7 +30,7 @@ static unsigned int g450_mnp2vco(CPMINFO
 
 	m = ((mnp >> 16) & 0x0FF) + 1;
 	n = ((mnp >>  7) & 0x1FE) + 4;
-	return (ACCESS_FBINFO(features).pll.ref_freq * n + (m >> 1)) / m;
+	return (minfo->features.pll.ref_freq * n + (m >> 1)) / m;
 }
 
 unsigned int g450_mnp2f(CPMINFO unsigned int mnp) {
@@ -90,7 +90,7 @@ static unsigned int g450_nextpll(CPMINFO
 		} else {
 			m--;
 		}
-        	n = ((tvco * (m+1) + ACCESS_FBINFO(features).pll.ref_freq) / (ACCESS_FBINFO(features).pll.ref_freq * 2)) - 2;
+		n = ((tvco * (m+1) + minfo->features.pll.ref_freq) / (minfo->features.pll.ref_freq * 2)) - 2;
 	} while (n < 0x03 || n > 0x7A);
 	return (m << 16) | (n << 8) | p;
 }
@@ -333,7 +333,7 @@ static int __g450_setclk(WPMINFO unsigne
 				matroxfb_DAC_out(PMINFO M1064_XPIXCLKCTRL, tmp);
 				/* DVI PLL preferred for frequencies up to
 				   panel link max, standard PLL otherwise */
-				if (fout >= MINFO->max_pixel_clock_panellink)
+				if (fout >= minfo->max_pixel_clock_panellink)
 					tmp = 0;
 				else tmp =
 					M1064_XDVICLKCTRL_DVIDATAPATHSEL |
@@ -363,20 +363,20 @@ static int __g450_setclk(WPMINFO unsigne
 				}
 				mga_outb(M_MISC_REG, misc);
 			}
-			pi = &ACCESS_FBINFO(limits.pixel);
-			ci = &ACCESS_FBINFO(cache.pixel);
+			pi = &minfo->limits.pixel;
+			ci = &minfo->cache.pixel;
 			break;
 		case M_SYSTEM_PLL:
 			{
 				u_int32_t opt;
 
-				pci_read_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, &opt);
+				pci_read_config_dword(minfo->pcidev, PCI_OPTION_REG, &opt);
 				if (!(opt & 0x20)) {
-					pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, opt | 0x20);
+					pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, opt | 0x20);
 				}
 			}
-			pi = &ACCESS_FBINFO(limits.system);
-			ci = &ACCESS_FBINFO(cache.system);
+			pi = &minfo->limits.system;
+			ci = &minfo->cache.system;
 			break;
 		case M_VIDEO_PLL:
 			{
@@ -395,8 +395,8 @@ static int __g450_setclk(WPMINFO unsigne
 				pixel_vco = g450_mnp2vco(PMINFO mnp);
 				matroxfb_DAC_unlock_irqrestore(flags);
 			}
-			pi = &ACCESS_FBINFO(limits.video);
-			ci = &ACCESS_FBINFO(cache.video);
+			pi = &minfo->limits.video;
+			ci = &minfo->cache.video;
 			break;
 		default:
 			return -EINVAL;
@@ -475,7 +475,7 @@ static int __g450_setclk(WPMINFO unsigne
 			mnp = g450_findworkingpll(PMINFO pll, mnparray, mnpcount);
 			g450_addcache(ci, mnparray[0], mnp);
 		}
-		updatehwstate_clk(&ACCESS_FBINFO(hw), mnp, pll);
+		updatehwstate_clk(&minfo->hw, mnp, pll);
 		matroxfb_DAC_unlock_irqrestore(flags);
 		return mnp;
 	}
diff -puN drivers/video/matrox/i2c-matroxfb.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/i2c-matroxfb.c
--- a/drivers/video/matrox/i2c-matroxfb.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/i2c-matroxfb.c
@@ -112,7 +112,7 @@ static int i2c_bus_reg(struct i2c_bit_ad
 	i2c_set_adapdata(&b->adapter, b);
 	b->adapter.class = class;
 	b->adapter.algo_data = &b->bac;
-	b->adapter.dev.parent = &ACCESS_FBINFO(pcidev)->dev;
+	b->adapter.dev.parent = &minfo->pcidev->dev;
 	b->bac = matrox_i2c_algo_template;
 	b->bac.data = b;
 	err = i2c_bit_add_bus(&b->adapter);
@@ -153,7 +153,7 @@ static void* i2c_matroxfb_probe(struct m
 	matroxfb_DAC_out(PMINFO DAC_XGENIOCTRL, 0x00);
 	matroxfb_DAC_unlock_irqrestore(flags);
 
-	switch (ACCESS_FBINFO(chip)) {
+	switch (minfo->chip) {
 		case MGA_2064:
 		case MGA_2164:
 			err = i2c_bus_reg(&m2info->ddc1, minfo,
@@ -168,7 +168,7 @@ static void* i2c_matroxfb_probe(struct m
 	}
 	if (err)
 		goto fail_ddc1;
-	if (ACCESS_FBINFO(devflags.dualhead)) {
+	if (minfo->devflags.dualhead) {
 		err = i2c_bus_reg(&m2info->ddc2, minfo,
 				  DDC2_DATA, DDC2_CLK,
 				  "DDC:fb%u #1", I2C_CLASS_DDC);
diff -puN drivers/video/matrox/matroxfb_DAC1064.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_DAC1064.c
--- a/drivers/video/matrox/matroxfb_DAC1064.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_DAC1064.c
@@ -85,19 +85,19 @@ static void DAC1064_setpclk(WPMINFO unsi
 
 	DBG(__func__)
 
-	DAC1064_calcclock(PMINFO fout, ACCESS_FBINFO(max_pixel_clock), &m, &n, &p);
-	ACCESS_FBINFO(hw).DACclk[0] = m;
-	ACCESS_FBINFO(hw).DACclk[1] = n;
-	ACCESS_FBINFO(hw).DACclk[2] = p;
+	DAC1064_calcclock(PMINFO fout, minfo->max_pixel_clock, &m, &n, &p);
+	minfo->hw.DACclk[0] = m;
+	minfo->hw.DACclk[1] = n;
+	minfo->hw.DACclk[2] = p;
 }
 
 static void DAC1064_setmclk(WPMINFO int oscinfo, unsigned long fmem) {
 	u_int32_t mx;
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
-	if (ACCESS_FBINFO(devflags.noinit)) {
+	if (minfo->devflags.noinit) {
 		/* read MCLK and give up... */
 		hw->DACclk[3] = inDAC1064(PMINFO DAC1064_XSYSPLLM);
 		hw->DACclk[4] = inDAC1064(PMINFO DAC1064_XSYSPLLN);
@@ -105,7 +105,7 @@ static void DAC1064_setmclk(WPMINFO int 
 		return;
 	}
 	mx = hw->MXoptionReg | 0x00000004;
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, mx);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, mx);
 	mx &= ~0x000000BB;
 	if (oscinfo & DAC1064_OPT_GDIV1)
 		mx |= 0x00000008;
@@ -120,9 +120,9 @@ static void DAC1064_setmclk(WPMINFO int 
 
 		/* powerup system PLL, select PCI clock */
 		mx |= 0x00000020;
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, mx);
+		pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, mx);
 		mx &= ~0x00000004;
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, mx);
+		pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, mx);
 
 		/* !!! you must not access device if MCLK is not running !!!
 		   Doing so cause immediate PCI lockup :-( Maybe they should
@@ -131,7 +131,7 @@ static void DAC1064_setmclk(WPMINFO int 
 		   perfect... */
 		/* (bit 2 of PCI_OPTION_REG must be 0... and bits 0,1 must not
 		   select PLL... because of PLL can be stopped at this time) */
-		DAC1064_calcclock(PMINFO fmem, ACCESS_FBINFO(max_pixel_clock), &m, &n, &p);
+		DAC1064_calcclock(PMINFO fmem, minfo->max_pixel_clock, &m, &n, &p);
 		outDAC1064(PMINFO DAC1064_XSYSPLLM, hw->DACclk[3] = m);
 		outDAC1064(PMINFO DAC1064_XSYSPLLN, hw->DACclk[4] = n);
 		outDAC1064(PMINFO DAC1064_XSYSPLLP, hw->DACclk[5] = p);
@@ -147,9 +147,9 @@ static void DAC1064_setmclk(WPMINFO int 
 		/* select specified system clock source */
 		mx |= oscinfo & DAC1064_OPT_SCLK_MASK;
 	}
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, mx);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, mx);
 	mx &= ~0x00000004;
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, mx);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, mx);
 	hw->MXoptionReg = mx;
 }
 
@@ -157,19 +157,19 @@ static void DAC1064_setmclk(WPMINFO int 
 static void g450_set_plls(WPMINFO2) {
 	u_int32_t c2_ctl;
 	unsigned int pxc;
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 	int pixelmnp;
 	int videomnp;
 	
 	c2_ctl = hw->crtc2.ctl & ~0x4007;	/* Clear PLL + enable for CRTC2 */
 	c2_ctl |= 0x0001;			/* Enable CRTC2 */
 	hw->DACreg[POS1064_XPWRCTRL] &= ~0x02;	/* Stop VIDEO PLL */
-	pixelmnp = ACCESS_FBINFO(crtc1).mnp;
-	videomnp = ACCESS_FBINFO(crtc2).mnp;
+	pixelmnp = minfo->crtc1.mnp;
+	videomnp = minfo->crtc2.mnp;
 	if (videomnp < 0) {
 		c2_ctl &= ~0x0001;			/* Disable CRTC2 */
 		hw->DACreg[POS1064_XPWRCTRL] &= ~0x10;	/* Powerdown CRTC2 */
-	} else if (ACCESS_FBINFO(crtc2).pixclock == ACCESS_FBINFO(features).pll.ref_freq) {
+	} else if (minfo->crtc2.pixclock == minfo->features.pll.ref_freq) {
 		c2_ctl |=  0x4002;	/* Use reference directly */
 	} else if (videomnp == pixelmnp) {
 		c2_ctl |=  0x0004;	/* Use pixel PLL */
@@ -200,11 +200,11 @@ static void g450_set_plls(WPMINFO2) {
 		mga_outl(0x3C10, c2_ctl);
 	}
 
-	pxc = ACCESS_FBINFO(crtc1).pixclock;
-	if (pxc == 0 || ACCESS_FBINFO(outputs[2]).src == MATROXFB_SRC_CRTC2) {
-		pxc = ACCESS_FBINFO(crtc2).pixclock;
+	pxc = minfo->crtc1.pixclock;
+	if (pxc == 0 || minfo->outputs[2].src == MATROXFB_SRC_CRTC2) {
+		pxc = minfo->crtc2.pixclock;
 	}
-	if (ACCESS_FBINFO(chip) == MGA_G550) {
+	if (minfo->chip == MGA_G550) {
 		if (pxc < 45000) {
 			hw->DACreg[POS1064_XPANMODE] = 0x00;	/* 0-50 */
 		} else if (pxc < 55000) {
@@ -246,17 +246,17 @@ static void g450_set_plls(WPMINFO2) {
 #endif
 
 void DAC1064_global_init(WPMINFO2) {
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	hw->DACreg[POS1064_XMISCCTRL] &= M1064_XMISCCTRL_DAC_WIDTHMASK;
 	hw->DACreg[POS1064_XMISCCTRL] |= M1064_XMISCCTRL_LUT_EN;
 	hw->DACreg[POS1064_XPIXCLKCTRL] = M1064_XPIXCLKCTRL_PLL_UP | M1064_XPIXCLKCTRL_EN | M1064_XPIXCLKCTRL_SRC_PLL;
 #ifdef CONFIG_FB_MATROX_G
-	if (ACCESS_FBINFO(devflags.g450dac)) {
+	if (minfo->devflags.g450dac) {
 		hw->DACreg[POS1064_XPWRCTRL] = 0x1F;	/* powerup everything */
 		hw->DACreg[POS1064_XOUTPUTCONN] = 0x00;	/* disable outputs */
 		hw->DACreg[POS1064_XMISCCTRL] |= M1064_XMISCCTRL_DAC_EN;
-		switch (ACCESS_FBINFO(outputs[0]).src) {
+		switch (minfo->outputs[0].src) {
 			case MATROXFB_SRC_CRTC1:
 			case MATROXFB_SRC_CRTC2:
 				hw->DACreg[POS1064_XOUTPUTCONN] |= 0x01;	/* enable output; CRTC1/2 selection is in CRTC2 ctl */
@@ -265,12 +265,12 @@ void DAC1064_global_init(WPMINFO2) {
 				hw->DACreg[POS1064_XMISCCTRL] &= ~M1064_XMISCCTRL_DAC_EN;
 				break;
 		}
-		switch (ACCESS_FBINFO(outputs[1]).src) {
+		switch (minfo->outputs[1].src) {
 			case MATROXFB_SRC_CRTC1:
 				hw->DACreg[POS1064_XOUTPUTCONN] |= 0x04;
 				break;
 			case MATROXFB_SRC_CRTC2:
-				if (ACCESS_FBINFO(outputs[1]).mode == MATROXFB_OUTPUT_MODE_MONITOR) {
+				if (minfo->outputs[1].mode == MATROXFB_OUTPUT_MODE_MONITOR) {
 					hw->DACreg[POS1064_XOUTPUTCONN] |= 0x08;
 				} else {
 					hw->DACreg[POS1064_XOUTPUTCONN] |= 0x0C;
@@ -280,7 +280,7 @@ void DAC1064_global_init(WPMINFO2) {
 				hw->DACreg[POS1064_XPWRCTRL] &= ~0x01;		/* Poweroff DAC2 */
 				break;
 		}
-		switch (ACCESS_FBINFO(outputs[2]).src) {
+		switch (minfo->outputs[2].src) {
 			case MATROXFB_SRC_CRTC1:
 				hw->DACreg[POS1064_XOUTPUTCONN] |= 0x20;
 				break;
@@ -303,30 +303,30 @@ void DAC1064_global_init(WPMINFO2) {
 	} else
 #endif
 	{
-		if (ACCESS_FBINFO(outputs[1]).src == MATROXFB_SRC_CRTC1) {
+		if (minfo->outputs[1].src == MATROXFB_SRC_CRTC1) {
 			hw->DACreg[POS1064_XPIXCLKCTRL] = M1064_XPIXCLKCTRL_PLL_UP | M1064_XPIXCLKCTRL_EN | M1064_XPIXCLKCTRL_SRC_EXT;
 			hw->DACreg[POS1064_XMISCCTRL] |= GX00_XMISCCTRL_MFC_MAFC | G400_XMISCCTRL_VDO_MAFC12;
-		} else if (ACCESS_FBINFO(outputs[1]).src == MATROXFB_SRC_CRTC2) {
+		} else if (minfo->outputs[1].src == MATROXFB_SRC_CRTC2) {
 			hw->DACreg[POS1064_XMISCCTRL] |= GX00_XMISCCTRL_MFC_MAFC | G400_XMISCCTRL_VDO_C2_MAFC12;
-		} else if (ACCESS_FBINFO(outputs[2]).src == MATROXFB_SRC_CRTC1)
+		} else if (minfo->outputs[2].src == MATROXFB_SRC_CRTC1)
 			hw->DACreg[POS1064_XMISCCTRL] |= GX00_XMISCCTRL_MFC_PANELLINK | G400_XMISCCTRL_VDO_MAFC12;
 		else
 			hw->DACreg[POS1064_XMISCCTRL] |= GX00_XMISCCTRL_MFC_DIS;
 
-		if (ACCESS_FBINFO(outputs[0]).src != MATROXFB_SRC_NONE)
+		if (minfo->outputs[0].src != MATROXFB_SRC_NONE)
 			hw->DACreg[POS1064_XMISCCTRL] |= M1064_XMISCCTRL_DAC_EN;
 	}
 }
 
 void DAC1064_global_restore(WPMINFO2) {
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	outDAC1064(PMINFO M1064_XPIXCLKCTRL, hw->DACreg[POS1064_XPIXCLKCTRL]);
 	outDAC1064(PMINFO M1064_XMISCCTRL, hw->DACreg[POS1064_XMISCCTRL]);
-	if (ACCESS_FBINFO(devflags.accelerator) == FB_ACCEL_MATROX_MGAG400) {
+	if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG400) {
 		outDAC1064(PMINFO 0x20, 0x04);
-		outDAC1064(PMINFO 0x1F, ACCESS_FBINFO(devflags.dfp_type));
-		if (ACCESS_FBINFO(devflags.g450dac)) {
+		outDAC1064(PMINFO 0x1F, minfo->devflags.dfp_type);
+		if (minfo->devflags.g450dac) {
 			outDAC1064(PMINFO M1064_XSYNCCTRL, 0xCC);
 			outDAC1064(PMINFO M1064_XPWRCTRL, hw->DACreg[POS1064_XPWRCTRL]);
 			outDAC1064(PMINFO M1064_XPANMODE, hw->DACreg[POS1064_XPANMODE]);
@@ -336,18 +336,18 @@ void DAC1064_global_restore(WPMINFO2) {
 }
 
 static int DAC1064_init_1(WPMINFO struct my_timming* m) {
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
 	memcpy(hw->DACreg, MGA1064_DAC, sizeof(MGA1064_DAC_regs));
-	switch (ACCESS_FBINFO(fbcon).var.bits_per_pixel) {
+	switch (minfo->fbcon.var.bits_per_pixel) {
 		/* case 4: not supported by MGA1064 DAC */
 		case 8:
 			hw->DACreg[POS1064_XMULCTRL] = M1064_XMULCTRL_DEPTH_8BPP | M1064_XMULCTRL_GRAPHICS_PALETIZED;
 			break;
 		case 16:
-			if (ACCESS_FBINFO(fbcon).var.green.length == 5)
+			if (minfo->fbcon.var.green.length == 5)
 				hw->DACreg[POS1064_XMULCTRL] = M1064_XMULCTRL_DEPTH_15BPP_1BPP | M1064_XMULCTRL_GRAPHICS_PALETIZED;
 			else
 				hw->DACreg[POS1064_XMULCTRL] = M1064_XMULCTRL_DEPTH_16BPP | M1064_XMULCTRL_GRAPHICS_PALETIZED;
@@ -361,7 +361,7 @@ static int DAC1064_init_1(WPMINFO struct
 		default:
 			return 1;	/* unsupported depth */
 	}
-	hw->DACreg[POS1064_XVREFCTRL] = ACCESS_FBINFO(features.DAC1064.xvrefctrl);
+	hw->DACreg[POS1064_XVREFCTRL] = minfo->features.DAC1064.xvrefctrl;
 	hw->DACreg[POS1064_XGENCTRL] &= ~M1064_XGENCTRL_SYNC_ON_GREEN_MASK;
 	hw->DACreg[POS1064_XGENCTRL] |= (m->sync & FB_SYNC_ON_GREEN)?M1064_XGENCTRL_SYNC_ON_GREEN:M1064_XGENCTRL_NO_SYNC_ON_GREEN;
 	hw->DACreg[POS1064_XCURADDL] = 0;
@@ -372,11 +372,11 @@ static int DAC1064_init_1(WPMINFO struct
 }
 
 static int DAC1064_init_2(WPMINFO struct my_timming* m) {
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
-	if (ACCESS_FBINFO(fbcon).var.bits_per_pixel > 16) {	/* 256 entries */
+	if (minfo->fbcon.var.bits_per_pixel > 16) {	/* 256 entries */
 		int i;
 
 		for (i = 0; i < 256; i++) {
@@ -384,8 +384,8 @@ static int DAC1064_init_2(WPMINFO struct
 			hw->DACpal[i * 3 + 1] = i;
 			hw->DACpal[i * 3 + 2] = i;
 		}
-	} else if (ACCESS_FBINFO(fbcon).var.bits_per_pixel > 8) {
-		if (ACCESS_FBINFO(fbcon).var.green.length == 5) {	/* 0..31, 128..159 */
+	} else if (minfo->fbcon.var.bits_per_pixel > 8) {
+		if (minfo->fbcon.var.green.length == 5) {	/* 0..31, 128..159 */
 			int i;
 
 			for (i = 0; i < 32; i++) {
@@ -414,7 +414,7 @@ static int DAC1064_init_2(WPMINFO struct
 }
 
 static void DAC1064_restore_1(WPMINFO2) {
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	CRITFLAGS
 
@@ -453,12 +453,12 @@ static void DAC1064_restore_2(WPMINFO2) 
 #ifdef DEBUG
 	dprintk(KERN_DEBUG "DAC1064regs ");
 	for (i = 0; i < sizeof(MGA1064_DAC_regs); i++) {
-		dprintk("R%02X=%02X ", MGA1064_DAC_regs[i], ACCESS_FBINFO(hw).DACreg[i]);
+		dprintk("R%02X=%02X ", MGA1064_DAC_regs[i], minfo->hw.DACreg[i]);
 		if ((i & 0x7) == 0x7) dprintk(KERN_DEBUG "continuing... ");
 	}
 	dprintk(KERN_DEBUG "DAC1064clk ");
 	for (i = 0; i < 6; i++)
-		dprintk("C%02X=%02X ", i, ACCESS_FBINFO(hw).DACclk[i]);
+		dprintk("C%02X=%02X ", i, minfo->hw.DACclk[i]);
 	dprintk("\n");
 #endif
 }
@@ -475,7 +475,7 @@ static int m1064_compute(void* out, stru
 		CRITBEGIN
 
 		for (i = 0; i < 3; i++)
-			outDAC1064(PMINFO M1064_XPIXPLLCM + i, ACCESS_FBINFO(hw).DACclk[i]);
+			outDAC1064(PMINFO M1064_XPIXPLLCM + i, minfo->hw.DACclk[i]);
 		for (tmout = 500000; tmout; tmout--) {
 			if (inDAC1064(PMINFO M1064_XPIXPLLSTAT) & 0x40)
 				break;
@@ -519,7 +519,7 @@ static struct matrox_altout g450out = {
 
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
 static int MGA1064_init(WPMINFO struct my_timming* m) {
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
@@ -541,7 +541,7 @@ static int MGA1064_init(WPMINFO struct m
 
 #ifdef CONFIG_FB_MATROX_G
 static int MGAG100_init(WPMINFO struct my_timming* m) {
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
@@ -567,15 +567,15 @@ static void MGA1064_ramdac_init(WPMINFO2
 
 	DBG(__func__)
 
-	/* ACCESS_FBINFO(features.DAC1064.vco_freq_min) = 120000; */
-	ACCESS_FBINFO(features.pll.vco_freq_min) = 62000;
-	ACCESS_FBINFO(features.pll.ref_freq)	 = 14318;
-	ACCESS_FBINFO(features.pll.feed_div_min) = 100;
-	ACCESS_FBINFO(features.pll.feed_div_max) = 127;
-	ACCESS_FBINFO(features.pll.in_div_min)	 = 1;
-	ACCESS_FBINFO(features.pll.in_div_max)	 = 31;
-	ACCESS_FBINFO(features.pll.post_shift_max) = 3;
-	ACCESS_FBINFO(features.DAC1064.xvrefctrl) = DAC1064_XVREFCTRL_EXTERNAL;
+	/* minfo->features.DAC1064.vco_freq_min = 120000; */
+	minfo->features.pll.vco_freq_min = 62000;
+	minfo->features.pll.ref_freq	 = 14318;
+	minfo->features.pll.feed_div_min = 100;
+	minfo->features.pll.feed_div_max = 127;
+	minfo->features.pll.in_div_min	 = 1;
+	minfo->features.pll.in_div_max	 = 31;
+	minfo->features.pll.post_shift_max = 3;
+	minfo->features.DAC1064.xvrefctrl = DAC1064_XVREFCTRL_EXTERNAL;
 	/* maybe cmdline MCLK= ?, doc says gclk=44MHz, mclk=66MHz... it was 55/83 with old values */
 	DAC1064_setmclk(PMINFO DAC1064_OPT_MDIV2 | DAC1064_OPT_GDIV3 | DAC1064_OPT_SCLK_PLL, 133333);
 }
@@ -638,7 +638,7 @@ static void MGAG100_setPixClock(CPMINFO 
 
 	DBG(__func__)
 
-	DAC1064_calcclock(PMINFO freq, ACCESS_FBINFO(max_pixel_clock), &m, &n, &p);
+	DAC1064_calcclock(PMINFO freq, minfo->max_pixel_clock, &m, &n, &p);
 	MGAG100_progPixClock(PMINFO flags, m, n, p);
 }
 #endif
@@ -648,30 +648,30 @@ static int MGA1064_preinit(WPMINFO2) {
 	static const int vxres_mystique[] = { 512,        640, 768,  800,  832,  960,
 					     1024, 1152, 1280,      1600, 1664, 1920,
 					     2048,    0};
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
-	/* ACCESS_FBINFO(capable.cfb4) = 0; ... preinitialized by 0 */
-	ACCESS_FBINFO(capable.text) = 1;
-	ACCESS_FBINFO(capable.vxres) = vxres_mystique;
+	/* minfo->capable.cfb4 = 0; ... preinitialized by 0 */
+	minfo->capable.text = 1;
+	minfo->capable.vxres = vxres_mystique;
 
-	ACCESS_FBINFO(outputs[0]).output = &m1064;
-	ACCESS_FBINFO(outputs[0]).src = ACCESS_FBINFO(outputs[0]).default_src;
-	ACCESS_FBINFO(outputs[0]).data = MINFO;
-	ACCESS_FBINFO(outputs[0]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
+	minfo->outputs[0].output = &m1064;
+	minfo->outputs[0].src = minfo->outputs[0].default_src;
+	minfo->outputs[0].data = minfo;
+	minfo->outputs[0].mode = MATROXFB_OUTPUT_MODE_MONITOR;
 
-	if (ACCESS_FBINFO(devflags.noinit))
+	if (minfo->devflags.noinit)
 		return 0;	/* do not modify settings */
 	hw->MXoptionReg &= 0xC0000100;
 	hw->MXoptionReg |= 0x00094E20;
-	if (ACCESS_FBINFO(devflags.novga))
+	if (minfo->devflags.novga)
 		hw->MXoptionReg &= ~0x00000100;
-	if (ACCESS_FBINFO(devflags.nobios))
+	if (minfo->devflags.nobios)
 		hw->MXoptionReg &= ~0x40000000;
-	if (ACCESS_FBINFO(devflags.nopciretry))
+	if (minfo->devflags.nopciretry)
 		hw->MXoptionReg |=  0x20000000;
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, hw->MXoptionReg);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 	mga_setr(M_SEQ_INDEX, 0x01, 0x20);
 	mga_outl(M_CTLWTST, 0x00000000);
 	udelay(200);
@@ -692,14 +692,14 @@ static void MGA1064_reset(WPMINFO2) {
 #ifdef CONFIG_FB_MATROX_G
 static void g450_mclk_init(WPMINFO2) {
 	/* switch all clocks to PCI source */
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, ACCESS_FBINFO(hw).MXoptionReg | 4);
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION3_REG, ACCESS_FBINFO(values).reg.opt3 & ~0x00300C03);
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, ACCESS_FBINFO(hw).MXoptionReg);
-	
-	if (((ACCESS_FBINFO(values).reg.opt3 & 0x000003) == 0x000003) ||
-	    ((ACCESS_FBINFO(values).reg.opt3 & 0x000C00) == 0x000C00) ||
-	    ((ACCESS_FBINFO(values).reg.opt3 & 0x300000) == 0x300000)) {
-		matroxfb_g450_setclk(PMINFO ACCESS_FBINFO(values.pll.video), M_VIDEO_PLL);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg | 4);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION3_REG, minfo->values.reg.opt3 & ~0x00300C03);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg);
+
+	if (((minfo->values.reg.opt3 & 0x000003) == 0x000003) ||
+	    ((minfo->values.reg.opt3 & 0x000C00) == 0x000C00) ||
+	    ((minfo->values.reg.opt3 & 0x300000) == 0x300000)) {
+		matroxfb_g450_setclk(PMINFO minfo->values.pll.video, M_VIDEO_PLL);
 	} else {
 		unsigned long flags;
 		unsigned int pwr;
@@ -709,53 +709,53 @@ static void g450_mclk_init(WPMINFO2) {
 		outDAC1064(PMINFO M1064_XPWRCTRL, pwr);
 		matroxfb_DAC_unlock_irqrestore(flags);
 	}
-	matroxfb_g450_setclk(PMINFO ACCESS_FBINFO(values.pll.system), M_SYSTEM_PLL);
+	matroxfb_g450_setclk(PMINFO minfo->values.pll.system, M_SYSTEM_PLL);
 	
 	/* switch clocks to their real PLL source(s) */
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, ACCESS_FBINFO(hw).MXoptionReg | 4);
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION3_REG, ACCESS_FBINFO(values).reg.opt3);
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, ACCESS_FBINFO(hw).MXoptionReg);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg | 4);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION3_REG, minfo->values.reg.opt3);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg);
 
 }
 
 static void g450_memory_init(WPMINFO2) {
 	/* disable memory refresh */
-	ACCESS_FBINFO(hw).MXoptionReg &= ~0x001F8000;
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, ACCESS_FBINFO(hw).MXoptionReg);
+	minfo->hw.MXoptionReg &= ~0x001F8000;
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg);
 	
 	/* set memory interface parameters */
-	ACCESS_FBINFO(hw).MXoptionReg &= ~0x00207E00;
-	ACCESS_FBINFO(hw).MXoptionReg |= 0x00207E00 & ACCESS_FBINFO(values).reg.opt;
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, ACCESS_FBINFO(hw).MXoptionReg);
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION2_REG, ACCESS_FBINFO(values).reg.opt2);
+	minfo->hw.MXoptionReg &= ~0x00207E00;
+	minfo->hw.MXoptionReg |= 0x00207E00 & minfo->values.reg.opt;
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION2_REG, minfo->values.reg.opt2);
 	
-	mga_outl(M_CTLWTST, ACCESS_FBINFO(values).reg.mctlwtst);
+	mga_outl(M_CTLWTST, minfo->values.reg.mctlwtst);
 	
 	/* first set up memory interface with disabled memory interface clocks */
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_MEMMISC_REG, ACCESS_FBINFO(values).reg.memmisc & ~0x80000000U);
-	mga_outl(M_MEMRDBK, ACCESS_FBINFO(values).reg.memrdbk);
-	mga_outl(M_MACCESS, ACCESS_FBINFO(values).reg.maccess);
+	pci_write_config_dword(minfo->pcidev, PCI_MEMMISC_REG, minfo->values.reg.memmisc & ~0x80000000U);
+	mga_outl(M_MEMRDBK, minfo->values.reg.memrdbk);
+	mga_outl(M_MACCESS, minfo->values.reg.maccess);
 	/* start memory clocks */
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_MEMMISC_REG, ACCESS_FBINFO(values).reg.memmisc | 0x80000000U);
+	pci_write_config_dword(minfo->pcidev, PCI_MEMMISC_REG, minfo->values.reg.memmisc | 0x80000000U);
 
 	udelay(200);
 	
-	if (ACCESS_FBINFO(values).memory.ddr && (!ACCESS_FBINFO(values).memory.emrswen || !ACCESS_FBINFO(values).memory.dll)) {
-		mga_outl(M_MEMRDBK, ACCESS_FBINFO(values).reg.memrdbk & ~0x1000);
+	if (minfo->values.memory.ddr && (!minfo->values.memory.emrswen || !minfo->values.memory.dll)) {
+		mga_outl(M_MEMRDBK, minfo->values.reg.memrdbk & ~0x1000);
 	}
-	mga_outl(M_MACCESS, ACCESS_FBINFO(values).reg.maccess | 0x8000);
+	mga_outl(M_MACCESS, minfo->values.reg.maccess | 0x8000);
 	
 	udelay(200);
 	
-	ACCESS_FBINFO(hw).MXoptionReg |= 0x001F8000 & ACCESS_FBINFO(values).reg.opt;
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, ACCESS_FBINFO(hw).MXoptionReg);
+	minfo->hw.MXoptionReg |= 0x001F8000 & minfo->values.reg.opt;
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg);
 	
 	/* value is written to memory chips only if old != new */
 	mga_outl(M_PLNWT, 0);
 	mga_outl(M_PLNWT, ~0);
 	
-	if (ACCESS_FBINFO(values).reg.mctlwtst != ACCESS_FBINFO(values).reg.mctlwtst_core) {
-		mga_outl(M_CTLWTST, ACCESS_FBINFO(values).reg.mctlwtst_core);
+	if (minfo->values.reg.mctlwtst != minfo->values.reg.mctlwtst_core) {
+		mga_outl(M_CTLWTST, minfo->values.reg.mctlwtst_core);
 	}
 	
 }
@@ -765,17 +765,17 @@ static void g450_preinit(WPMINFO2) {
 	u_int8_t curctl;
 	u_int8_t c1ctl;
 	
-	/* ACCESS_FBINFO(hw).MXoptionReg = minfo->values.reg.opt; */
-	ACCESS_FBINFO(hw).MXoptionReg &= 0xC0000100;
-	ACCESS_FBINFO(hw).MXoptionReg |= 0x00000020;
-	if (ACCESS_FBINFO(devflags.novga))
-		ACCESS_FBINFO(hw).MXoptionReg &= ~0x00000100;
-	if (ACCESS_FBINFO(devflags.nobios))
-		ACCESS_FBINFO(hw).MXoptionReg &= ~0x40000000;
-	if (ACCESS_FBINFO(devflags.nopciretry))
-		ACCESS_FBINFO(hw).MXoptionReg |=  0x20000000;
-	ACCESS_FBINFO(hw).MXoptionReg |= ACCESS_FBINFO(values).reg.opt & 0x03400040;
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, ACCESS_FBINFO(hw).MXoptionReg);
+	/* minfo->hw.MXoptionReg = minfo->values.reg.opt; */
+	minfo->hw.MXoptionReg &= 0xC0000100;
+	minfo->hw.MXoptionReg |= 0x00000020;
+	if (minfo->devflags.novga)
+		minfo->hw.MXoptionReg &= ~0x00000100;
+	if (minfo->devflags.nobios)
+		minfo->hw.MXoptionReg &= ~0x40000000;
+	if (minfo->devflags.nopciretry)
+		minfo->hw.MXoptionReg |=  0x20000000;
+	minfo->hw.MXoptionReg |= minfo->values.reg.opt & 0x03400040;
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg);
 
 	/* Init system clocks */
 		
@@ -812,7 +812,7 @@ static int MGAG100_preinit(WPMINFO2) {
 	static const int vxres_g100[] = {  512,        640, 768,  800,  832,  960,
                                           1024, 1152, 1280,      1600, 1664, 1920,
                                           2048, 0};
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
         u_int32_t reg50;
 #if 0
@@ -822,68 +822,68 @@ static int MGAG100_preinit(WPMINFO2) {
 	DBG(__func__)
 
 	/* there are some instabilities if in_div > 19 && vco < 61000 */
-	if (ACCESS_FBINFO(devflags.g450dac)) {
-		ACCESS_FBINFO(features.pll.vco_freq_min) = 130000;	/* my sample: >118 */
+	if (minfo->devflags.g450dac) {
+		minfo->features.pll.vco_freq_min = 130000;	/* my sample: >118 */
 	} else {
-		ACCESS_FBINFO(features.pll.vco_freq_min) = 62000;
+		minfo->features.pll.vco_freq_min = 62000;
 	}
-	if (!ACCESS_FBINFO(features.pll.ref_freq)) {
-		ACCESS_FBINFO(features.pll.ref_freq)	 = 27000;
+	if (!minfo->features.pll.ref_freq) {
+		minfo->features.pll.ref_freq	 = 27000;
 	}
-	ACCESS_FBINFO(features.pll.feed_div_min) = 7;
-	ACCESS_FBINFO(features.pll.feed_div_max) = 127;
-	ACCESS_FBINFO(features.pll.in_div_min)	 = 1;
-	ACCESS_FBINFO(features.pll.in_div_max)	 = 31;
-	ACCESS_FBINFO(features.pll.post_shift_max) = 3;
-	ACCESS_FBINFO(features.DAC1064.xvrefctrl) = DAC1064_XVREFCTRL_G100_DEFAULT;
-	/* ACCESS_FBINFO(capable.cfb4) = 0; ... preinitialized by 0 */
-	ACCESS_FBINFO(capable.text) = 1;
-	ACCESS_FBINFO(capable.vxres) = vxres_g100;
-	ACCESS_FBINFO(capable.plnwt) = ACCESS_FBINFO(devflags.accelerator) == FB_ACCEL_MATROX_MGAG100
-			? ACCESS_FBINFO(devflags.sgram) : 1;
+	minfo->features.pll.feed_div_min = 7;
+	minfo->features.pll.feed_div_max = 127;
+	minfo->features.pll.in_div_min	 = 1;
+	minfo->features.pll.in_div_max	 = 31;
+	minfo->features.pll.post_shift_max = 3;
+	minfo->features.DAC1064.xvrefctrl = DAC1064_XVREFCTRL_G100_DEFAULT;
+	/* minfo->capable.cfb4 = 0; ... preinitialized by 0 */
+	minfo->capable.text = 1;
+	minfo->capable.vxres = vxres_g100;
+	minfo->capable.plnwt = minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG100
+			? minfo->devflags.sgram : 1;
 
 #ifdef CONFIG_FB_MATROX_G
-	if (ACCESS_FBINFO(devflags.g450dac)) {
-		ACCESS_FBINFO(outputs[0]).output = &g450out;
+	if (minfo->devflags.g450dac) {
+		minfo->outputs[0].output = &g450out;
 	} else
 #endif
 	{
-		ACCESS_FBINFO(outputs[0]).output = &m1064;
+		minfo->outputs[0].output = &m1064;
 	}
-	ACCESS_FBINFO(outputs[0]).src = ACCESS_FBINFO(outputs[0]).default_src;
-	ACCESS_FBINFO(outputs[0]).data = MINFO;
-	ACCESS_FBINFO(outputs[0]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
+	minfo->outputs[0].src = minfo->outputs[0].default_src;
+	minfo->outputs[0].data = minfo;
+	minfo->outputs[0].mode = MATROXFB_OUTPUT_MODE_MONITOR;
 
-	if (ACCESS_FBINFO(devflags.g450dac)) {
+	if (minfo->devflags.g450dac) {
 		/* we must do this always, BIOS does not do it for us
 		   and accelerator dies without it */
 		mga_outl(0x1C0C, 0);
 	}
-	if (ACCESS_FBINFO(devflags.noinit))
+	if (minfo->devflags.noinit)
 		return 0;
-	if (ACCESS_FBINFO(devflags.g450dac)) {
+	if (minfo->devflags.g450dac) {
 		g450_preinit(PMINFO2);
 		return 0;
 	}
 	hw->MXoptionReg &= 0xC0000100;
 	hw->MXoptionReg |= 0x00000020;
-	if (ACCESS_FBINFO(devflags.novga))
+	if (minfo->devflags.novga)
 		hw->MXoptionReg &= ~0x00000100;
-	if (ACCESS_FBINFO(devflags.nobios))
+	if (minfo->devflags.nobios)
 		hw->MXoptionReg &= ~0x40000000;
-	if (ACCESS_FBINFO(devflags.nopciretry))
+	if (minfo->devflags.nopciretry)
 		hw->MXoptionReg |=  0x20000000;
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, hw->MXoptionReg);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 	DAC1064_setmclk(PMINFO DAC1064_OPT_MDIV2 | DAC1064_OPT_GDIV3 | DAC1064_OPT_SCLK_PCI, 133333);
 
-	if (ACCESS_FBINFO(devflags.accelerator) == FB_ACCEL_MATROX_MGAG100) {
-		pci_read_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION2_REG, &reg50);
+	if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG100) {
+		pci_read_config_dword(minfo->pcidev, PCI_OPTION2_REG, &reg50);
 		reg50 &= ~0x3000;
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION2_REG, reg50);
+		pci_write_config_dword(minfo->pcidev, PCI_OPTION2_REG, reg50);
 
 		hw->MXoptionReg |= 0x1080;
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, hw->MXoptionReg);
-		mga_outl(M_CTLWTST, ACCESS_FBINFO(values).reg.mctlwtst);
+		pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
+		mga_outl(M_CTLWTST, minfo->values.reg.mctlwtst);
 		udelay(100);
 		mga_outb(0x1C05, 0x00);
 		mga_outb(0x1C05, 0x80);
@@ -893,68 +893,68 @@ static int MGAG100_preinit(WPMINFO2) {
 		udelay(100);
 		reg50 &= ~0xFF;
 		reg50 |=  0x07;
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION2_REG, reg50);
+		pci_write_config_dword(minfo->pcidev, PCI_OPTION2_REG, reg50);
 		/* it should help with G100 */
 		mga_outb(M_GRAPHICS_INDEX, 6);
 		mga_outb(M_GRAPHICS_DATA, (mga_inb(M_GRAPHICS_DATA) & 3) | 4);
 		mga_setr(M_EXTVGA_INDEX, 0x03, 0x81);
 		mga_setr(M_EXTVGA_INDEX, 0x04, 0x00);
-		mga_writeb(ACCESS_FBINFO(video.vbase), 0x0000, 0xAA);
-		mga_writeb(ACCESS_FBINFO(video.vbase), 0x0800, 0x55);
-		mga_writeb(ACCESS_FBINFO(video.vbase), 0x4000, 0x55);
+		mga_writeb(minfo->video.vbase, 0x0000, 0xAA);
+		mga_writeb(minfo->video.vbase, 0x0800, 0x55);
+		mga_writeb(minfo->video.vbase, 0x4000, 0x55);
 #if 0
-		if (mga_readb(ACCESS_FBINFO(video.vbase), 0x0000) != 0xAA) {
+		if (mga_readb(minfo->video.vbase, 0x0000) != 0xAA) {
 			hw->MXoptionReg &= ~0x1000;
 		}
 #endif
 		hw->MXoptionReg |= 0x00078020;
-	} else if (ACCESS_FBINFO(devflags.accelerator) == FB_ACCEL_MATROX_MGAG200) {
-		pci_read_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION2_REG, &reg50);
+	} else if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG200) {
+		pci_read_config_dword(minfo->pcidev, PCI_OPTION2_REG, &reg50);
 		reg50 &= ~0x3000;
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION2_REG, reg50);
+		pci_write_config_dword(minfo->pcidev, PCI_OPTION2_REG, reg50);
 
-		if (ACCESS_FBINFO(devflags.memtype) == -1)
-			hw->MXoptionReg |= ACCESS_FBINFO(values).reg.opt & 0x1C00;
+		if (minfo->devflags.memtype == -1)
+			hw->MXoptionReg |= minfo->values.reg.opt & 0x1C00;
 		else
-			hw->MXoptionReg |= (ACCESS_FBINFO(devflags.memtype) & 7) << 10;
-		if (ACCESS_FBINFO(devflags.sgram))
+			hw->MXoptionReg |= (minfo->devflags.memtype & 7) << 10;
+		if (minfo->devflags.sgram)
 			hw->MXoptionReg |= 0x4000;
-		mga_outl(M_CTLWTST, ACCESS_FBINFO(values).reg.mctlwtst);
-		mga_outl(M_MEMRDBK, ACCESS_FBINFO(values).reg.memrdbk);
+		mga_outl(M_CTLWTST, minfo->values.reg.mctlwtst);
+		mga_outl(M_MEMRDBK, minfo->values.reg.memrdbk);
 		udelay(200);
 		mga_outl(M_MACCESS, 0x00000000);
 		mga_outl(M_MACCESS, 0x00008000);
 		udelay(100);
-		mga_outw(M_MEMRDBK, ACCESS_FBINFO(values).reg.memrdbk);
+		mga_outw(M_MEMRDBK, minfo->values.reg.memrdbk);
 		hw->MXoptionReg |= 0x00078020;
 	} else {
-		pci_read_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION2_REG, &reg50);
+		pci_read_config_dword(minfo->pcidev, PCI_OPTION2_REG, &reg50);
 		reg50 &= ~0x00000100;
 		reg50 |=  0x00000000;
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION2_REG, reg50);
+		pci_write_config_dword(minfo->pcidev, PCI_OPTION2_REG, reg50);
 
-		if (ACCESS_FBINFO(devflags.memtype) == -1)
-			hw->MXoptionReg |= ACCESS_FBINFO(values).reg.opt & 0x1C00;
+		if (minfo->devflags.memtype == -1)
+			hw->MXoptionReg |= minfo->values.reg.opt & 0x1C00;
 		else
-			hw->MXoptionReg |= (ACCESS_FBINFO(devflags.memtype) & 7) << 10;
-		if (ACCESS_FBINFO(devflags.sgram))
+			hw->MXoptionReg |= (minfo->devflags.memtype & 7) << 10;
+		if (minfo->devflags.sgram)
 			hw->MXoptionReg |= 0x4000;
-		mga_outl(M_CTLWTST, ACCESS_FBINFO(values).reg.mctlwtst);
-		mga_outl(M_MEMRDBK, ACCESS_FBINFO(values).reg.memrdbk);
+		mga_outl(M_CTLWTST, minfo->values.reg.mctlwtst);
+		mga_outl(M_MEMRDBK, minfo->values.reg.memrdbk);
 		udelay(200);
 		mga_outl(M_MACCESS, 0x00000000);
 		mga_outl(M_MACCESS, 0x00008000);
 		udelay(100);
-		mga_outl(M_MEMRDBK, ACCESS_FBINFO(values).reg.memrdbk);
+		mga_outl(M_MEMRDBK, minfo->values.reg.memrdbk);
 		hw->MXoptionReg |= 0x00040020;
 	}
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, hw->MXoptionReg);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 	return 0;
 }
 
 static void MGAG100_reset(WPMINFO2) {
 	u_int8_t b;
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
@@ -964,22 +964,22 @@ static void MGAG100_reset(WPMINFO2) {
 
 		find 1014/22 (IBM/82351); /* if found and bridging Matrox, do some strange stuff */
 		pci_read_config_byte(ibm, PCI_SECONDARY_BUS, &b);
-		if (b == ACCESS_FBINFO(pcidev)->bus->number) {
+		if (b == minfo->pcidev->bus->number) {
 			pci_write_config_byte(ibm, PCI_COMMAND+1, 0);	/* disable back-to-back & SERR */
 			pci_write_config_byte(ibm, 0x41, 0xF4);		/* ??? */
 			pci_write_config_byte(ibm, PCI_IO_BASE, 0xF0);	/* ??? */
 			pci_write_config_byte(ibm, PCI_IO_LIMIT, 0x00);	/* ??? */
 		}
 #endif
-		if (!ACCESS_FBINFO(devflags.noinit)) {
+		if (!minfo->devflags.noinit) {
 			if (x7AF4 & 8) {
 				hw->MXoptionReg |= 0x40;	/* FIXME... */
-				pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, hw->MXoptionReg);
+				pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 			}
 			mga_setr(M_EXTVGA_INDEX, 0x06, 0x00);
 		}
 	}
-	if (ACCESS_FBINFO(devflags.g450dac)) {
+	if (minfo->devflags.g450dac) {
 		/* either leave MCLK as is... or they were set in preinit */
 		hw->DACclk[3] = inDAC1064(PMINFO DAC1064_XSYSPLLM);
 		hw->DACclk[4] = inDAC1064(PMINFO DAC1064_XSYSPLLN);
@@ -987,14 +987,14 @@ static void MGAG100_reset(WPMINFO2) {
 	} else {
 		DAC1064_setmclk(PMINFO DAC1064_OPT_RESERVED | DAC1064_OPT_MDIV2 | DAC1064_OPT_GDIV1 | DAC1064_OPT_SCLK_PLL, 133333);
 	}
-	if (ACCESS_FBINFO(devflags.accelerator) == FB_ACCEL_MATROX_MGAG400) {
-		if (ACCESS_FBINFO(devflags.dfp_type) == -1) {
-			ACCESS_FBINFO(devflags.dfp_type) = inDAC1064(PMINFO 0x1F);
+	if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG400) {
+		if (minfo->devflags.dfp_type == -1) {
+			minfo->devflags.dfp_type = inDAC1064(PMINFO 0x1F);
 		}
 	}
-	if (ACCESS_FBINFO(devflags.noinit))
+	if (minfo->devflags.noinit)
 		return;
-	if (ACCESS_FBINFO(devflags.g450dac)) {
+	if (minfo->devflags.g450dac) {
 	} else {
 		MGAG100_setPixClock(PMINFO 4, 25175);
 		MGAG100_setPixClock(PMINFO 5, 28322);
@@ -1011,7 +1011,7 @@ static void MGAG100_reset(WPMINFO2) {
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
 static void MGA1064_restore(WPMINFO2) {
 	int i;
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	CRITFLAGS
 
@@ -1019,7 +1019,7 @@ static void MGA1064_restore(WPMINFO2) {
 
 	CRITBEGIN
 
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, hw->MXoptionReg);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 	mga_outb(M_IEN, 0x00);
 	mga_outb(M_CACHEFLUSH, 0x00);
 
@@ -1027,7 +1027,7 @@ static void MGA1064_restore(WPMINFO2) {
 
 	DAC1064_restore_1(PMINFO2);
 	matroxfb_vgaHWrestore(PMINFO2);
-	ACCESS_FBINFO(crtc1.panpos) = -1;
+	minfo->crtc1.panpos = -1;
 	for (i = 0; i < 6; i++)
 		mga_setr(M_EXTVGA_INDEX, i, hw->CRTCEXT[i]);
 	DAC1064_restore_2(PMINFO2);
@@ -1037,7 +1037,7 @@ static void MGA1064_restore(WPMINFO2) {
 #ifdef CONFIG_FB_MATROX_G
 static void MGAG100_restore(WPMINFO2) {
 	int i;
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	CRITFLAGS
 
@@ -1045,16 +1045,16 @@ static void MGAG100_restore(WPMINFO2) {
 
 	CRITBEGIN
 
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, hw->MXoptionReg);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 	CRITEND
 
 	DAC1064_restore_1(PMINFO2);
 	matroxfb_vgaHWrestore(PMINFO2);
 #ifdef CONFIG_FB_MATROX_32MB
-	if (ACCESS_FBINFO(devflags.support32MB))
+	if (minfo->devflags.support32MB)
 		mga_setr(M_EXTVGA_INDEX, 8, hw->CRTCEXT[8]);
 #endif
-	ACCESS_FBINFO(crtc1.panpos) = -1;
+	minfo->crtc1.panpos = -1;
 	for (i = 0; i < 6; i++)
 		mga_setr(M_EXTVGA_INDEX, i, hw->CRTCEXT[i]);
 	DAC1064_restore_2(PMINFO2);
diff -puN drivers/video/matrox/matroxfb_Ti3026.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_Ti3026.c
--- a/drivers/video/matrox/matroxfb_Ti3026.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_Ti3026.c
@@ -295,11 +295,11 @@ static int Ti3026_calcclock(CPMINFO unsi
 static int Ti3026_setpclk(WPMINFO int clk) {
 	unsigned int f_pll;
 	unsigned int pixfeed, pixin, pixpost;
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
-	f_pll = Ti3026_calcclock(PMINFO clk, ACCESS_FBINFO(max_pixel_clock), &pixin, &pixfeed, &pixpost);
+	f_pll = Ti3026_calcclock(PMINFO clk, minfo->max_pixel_clock, &pixin, &pixfeed, &pixpost);
 
 	hw->DACclk[0] = pixin | 0xC0;
 	hw->DACclk[1] = pixfeed;
@@ -309,9 +309,9 @@ static int Ti3026_setpclk(WPMINFO int cl
 		unsigned int loopfeed, loopin, looppost, loopdiv, z;
 		unsigned int Bpp;
 
-		Bpp = ACCESS_FBINFO(curr.final_bppShift);
+		Bpp = minfo->curr.final_bppShift;
 
-		if (ACCESS_FBINFO(fbcon).var.bits_per_pixel == 24) {
+		if (minfo->fbcon.var.bits_per_pixel == 24) {
 			loopfeed = 3;		/* set lm to any possible value */
 			loopin = 3 * 32 / Bpp;
 		} else {
@@ -330,18 +330,18 @@ static int Ti3026_setpclk(WPMINFO int cl
 			looppost = 3;
 			loopdiv = z/16;
 		}
-		if (ACCESS_FBINFO(fbcon).var.bits_per_pixel == 24) {
+		if (minfo->fbcon.var.bits_per_pixel == 24) {
 			hw->DACclk[3] = ((65 - loopin) & 0x3F) | 0xC0;
 			hw->DACclk[4] = (65 - loopfeed) | 0x80;
-			if (ACCESS_FBINFO(accel.ramdac_rev) > 0x20) {
-				if (isInterleave(MINFO))
+			if (minfo->accel.ramdac_rev > 0x20) {
+				if (isInterleave(minfo))
 					hw->DACreg[POS3026_XLATCHCTRL] = TVP3026B_XLATCHCTRL_8_3;
 				else {
 					hw->DACclk[4] &= ~0xC0;
 					hw->DACreg[POS3026_XLATCHCTRL] = TVP3026B_XLATCHCTRL_4_3;
 				}
 			} else {
-				if (isInterleave(MINFO))
+				if (isInterleave(minfo))
 					;	/* default... */
 				else {
 					hw->DACclk[4] ^= 0xC0;	/* change from 0x80 to 0x40 */
@@ -349,7 +349,7 @@ static int Ti3026_setpclk(WPMINFO int cl
 				}
 			}
 			hw->DACclk[5] = looppost | 0xF8;
-			if (ACCESS_FBINFO(devflags.mga_24bpp_fix))
+			if (minfo->devflags.mga_24bpp_fix)
 				hw->DACclk[5] ^= 0x40;
 		} else {
 			hw->DACclk[3] = ((65 - loopin) & 0x3F) | 0xC0;
@@ -362,13 +362,13 @@ static int Ti3026_setpclk(WPMINFO int cl
 }
 
 static int Ti3026_init(WPMINFO struct my_timming* m) {
-	u_int8_t muxctrl = isInterleave(MINFO) ? TVP3026_XMUXCTRL_MEMORY_64BIT : TVP3026_XMUXCTRL_MEMORY_32BIT;
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	u_int8_t muxctrl = isInterleave(minfo) ? TVP3026_XMUXCTRL_MEMORY_64BIT : TVP3026_XMUXCTRL_MEMORY_32BIT;
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
 	memcpy(hw->DACreg, MGADACbpp32, sizeof(hw->DACreg));
-	switch (ACCESS_FBINFO(fbcon).var.bits_per_pixel) {
+	switch (minfo->fbcon.var.bits_per_pixel) {
 		case 4:	hw->DACreg[POS3026_XLATCHCTRL] = TVP3026_XLATCHCTRL_16_1;	/* or _8_1, they are same */
 			hw->DACreg[POS3026_XTRUECOLORCTRL] = TVP3026_XTRUECOLORCTRL_PSEUDOCOLOR;
 			hw->DACreg[POS3026_XMUXCTRL] = muxctrl | TVP3026_XMUXCTRL_PIXEL_4BIT;
@@ -383,7 +383,7 @@ static int Ti3026_init(WPMINFO struct my
 			break;
 		case 16:
 			/* XLATCHCTRL should be _4_1 / _2_1... Why is not? (_2_1 is used everytime) */
-			hw->DACreg[POS3026_XTRUECOLORCTRL] = (ACCESS_FBINFO(fbcon).var.green.length == 5)? (TVP3026_XTRUECOLORCTRL_DIRECTCOLOR | TVP3026_XTRUECOLORCTRL_ORGB_1555 ) : (TVP3026_XTRUECOLORCTRL_DIRECTCOLOR | TVP3026_XTRUECOLORCTRL_RGB_565);
+			hw->DACreg[POS3026_XTRUECOLORCTRL] = (minfo->fbcon.var.green.length == 5) ? (TVP3026_XTRUECOLORCTRL_DIRECTCOLOR | TVP3026_XTRUECOLORCTRL_ORGB_1555) : (TVP3026_XTRUECOLORCTRL_DIRECTCOLOR | TVP3026_XTRUECOLORCTRL_RGB_565);
 			hw->DACreg[POS3026_XMUXCTRL] = muxctrl | TVP3026_XMUXCTRL_PIXEL_16BIT;
 			hw->DACreg[POS3026_XCLKCTRL] = TVP3026_XCLKCTRL_SRC_PLL | TVP3026_XCLKCTRL_DIV2;
 			break;
@@ -412,9 +412,9 @@ static int Ti3026_init(WPMINFO struct my
 		hw->DACreg[POS3026_XGENCTRL] |= TVP3026_XGENCTRL_SYNC_ON_GREEN;
 
 	/* set DELAY */
-	if (ACCESS_FBINFO(video.len) < 0x400000)
+	if (minfo->video.len < 0x400000)
 		hw->CRTCEXT[3] |= 0x08;
-	else if (ACCESS_FBINFO(video.len) > 0x400000)
+	else if (minfo->video.len > 0x400000)
 		hw->CRTCEXT[3] |= 0x10;
 
 	/* set HWCURSOR */
@@ -426,7 +426,7 @@ static int Ti3026_init(WPMINFO struct my
 
 	/* set interleaving */
 	hw->MXoptionReg &= ~0x00001000;
-	if (isInterleave(MINFO)) hw->MXoptionReg |= 0x00001000;
+	if (isInterleave(minfo)) hw->MXoptionReg |= 0x00001000;
 
 	/* set DAC */
 	Ti3026_setpclk(PMINFO m->pixclock);
@@ -442,7 +442,7 @@ static void ti3026_setMCLK(WPMINFO int f
 
 	DBG(__func__)
 
-	f_pll = Ti3026_calcclock(PMINFO fout, ACCESS_FBINFO(max_pixel_clock), &mclk_n, &mclk_m, &mclk_p);
+	f_pll = Ti3026_calcclock(PMINFO fout, minfo->max_pixel_clock, &mclk_n, &mclk_m, &mclk_p);
 
 	/* save pclk */
 	outTi3026(PMINFO TVP3026_XPLLADDR, 0xFC);
@@ -496,7 +496,7 @@ static void ti3026_setMCLK(WPMINFO int f
 		printk(KERN_ERR "matroxfb: Memory PLL not locked after 5 secs\n");
 
 	f_pll = f_pll * 333 / (10000 << mclk_p);
-	if (isMilleniumII(MINFO)) {
+	if (isMilleniumII(minfo)) {
 		rfhcnt = (f_pll - 128) / 256;
 		if (rfhcnt > 15)
 			rfhcnt = 15;
@@ -505,8 +505,8 @@ static void ti3026_setMCLK(WPMINFO int f
 		if (rfhcnt > 15)
 			rfhcnt = 0;
 	}
-	ACCESS_FBINFO(hw).MXoptionReg = (ACCESS_FBINFO(hw).MXoptionReg & ~0x000F0000) | (rfhcnt << 16);
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, ACCESS_FBINFO(hw).MXoptionReg);
+	minfo->hw.MXoptionReg = (minfo->hw.MXoptionReg & ~0x000F0000) | (rfhcnt << 16);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg);
 
 	/* output MCLK to MCLK pin */
 	outTi3026(PMINFO TVP3026_XMEMPLLCTRL, (mclk_ctl & 0xE7) | TVP3026_XMEMPLLCTRL_MCLK_MCLKPLL);
@@ -536,14 +536,14 @@ static void ti3026_ramdac_init(WPMINFO2)
 
 	DBG(__func__)
 
-	ACCESS_FBINFO(features.pll.vco_freq_min) = 110000;
-	ACCESS_FBINFO(features.pll.ref_freq)	 = 114545;
-	ACCESS_FBINFO(features.pll.feed_div_min) = 2;
-	ACCESS_FBINFO(features.pll.feed_div_max) = 24;
-	ACCESS_FBINFO(features.pll.in_div_min)	 = 2;
-	ACCESS_FBINFO(features.pll.in_div_max)	 = 63;
-	ACCESS_FBINFO(features.pll.post_shift_max) = 3;
-	if (ACCESS_FBINFO(devflags.noinit))
+	minfo->features.pll.vco_freq_min = 110000;
+	minfo->features.pll.ref_freq	 = 114545;
+	minfo->features.pll.feed_div_min = 2;
+	minfo->features.pll.feed_div_max = 24;
+	minfo->features.pll.in_div_min	 = 2;
+	minfo->features.pll.in_div_max	 = 63;
+	minfo->features.pll.post_shift_max = 3;
+	if (minfo->devflags.noinit)
 		return;
 	ti3026_setMCLK(PMINFO 60000);
 }
@@ -551,7 +551,7 @@ static void ti3026_ramdac_init(WPMINFO2)
 static void Ti3026_restore(WPMINFO2) {
 	int i;
 	unsigned char progdac[6];
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 	CRITFLAGS
 
 	DBG(__func__)
@@ -565,7 +565,7 @@ static void Ti3026_restore(WPMINFO2) {
 
 	CRITBEGIN
 
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, hw->MXoptionReg);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 
 	CRITEND
 
@@ -573,7 +573,7 @@ static void Ti3026_restore(WPMINFO2) {
 
 	CRITBEGIN
 
-	ACCESS_FBINFO(crtc1.panpos) = -1;
+	minfo->crtc1.panpos = -1;
 	for (i = 0; i < 6; i++)
 		mga_setr(M_EXTVGA_INDEX, i, hw->CRTCEXT[i]);
 
@@ -678,35 +678,35 @@ static int Ti3026_preinit(WPMINFO2) {
 	static const int vxres_mill1[] = {             640, 768,  800,        960,
 					  1024, 1152, 1280,      1600,       1920,
 					  2048, 0};
-	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
-	ACCESS_FBINFO(millenium) = 1;
-	ACCESS_FBINFO(milleniumII) = (ACCESS_FBINFO(pcidev)->device != PCI_DEVICE_ID_MATROX_MIL);
-	ACCESS_FBINFO(capable.cfb4) = 1;
-	ACCESS_FBINFO(capable.text) = 1; /* isMilleniumII(MINFO); */
-	ACCESS_FBINFO(capable.vxres) = isMilleniumII(MINFO)?vxres_mill2:vxres_mill1;
-
-	ACCESS_FBINFO(outputs[0]).data = MINFO;
-	ACCESS_FBINFO(outputs[0]).output = &ti3026_output;
-	ACCESS_FBINFO(outputs[0]).src = ACCESS_FBINFO(outputs[0]).default_src;
-	ACCESS_FBINFO(outputs[0]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
+	minfo->millenium = 1;
+	minfo->milleniumII = (minfo->pcidev->device != PCI_DEVICE_ID_MATROX_MIL);
+	minfo->capable.cfb4 = 1;
+	minfo->capable.text = 1; /* isMilleniumII(minfo); */
+	minfo->capable.vxres = isMilleniumII(minfo) ? vxres_mill2 : vxres_mill1;
+
+	minfo->outputs[0].data = minfo;
+	minfo->outputs[0].output = &ti3026_output;
+	minfo->outputs[0].src = minfo->outputs[0].default_src;
+	minfo->outputs[0].mode = MATROXFB_OUTPUT_MODE_MONITOR;
 
-	if (ACCESS_FBINFO(devflags.noinit))
+	if (minfo->devflags.noinit)
 		return 0;
 	/* preserve VGA I/O, BIOS and PPC */
 	hw->MXoptionReg &= 0xC0000100;
 	hw->MXoptionReg |= 0x002C0000;
-	if (ACCESS_FBINFO(devflags.novga))
+	if (minfo->devflags.novga)
 		hw->MXoptionReg &= ~0x00000100;
-	if (ACCESS_FBINFO(devflags.nobios))
+	if (minfo->devflags.nobios)
 		hw->MXoptionReg &= ~0x40000000;
-	if (ACCESS_FBINFO(devflags.nopciretry))
+	if (minfo->devflags.nopciretry)
 		hw->MXoptionReg |=  0x20000000;
-	pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, hw->MXoptionReg);
+	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 
-	ACCESS_FBINFO(accel.ramdac_rev) = inTi3026(PMINFO TVP3026_XSILICONREV);
+	minfo->accel.ramdac_rev = inTi3026(PMINFO TVP3026_XSILICONREV);
 
 	outTi3026(PMINFO TVP3026_XCLKCTRL, TVP3026_XCLKCTRL_SRC_CLK0VGA | TVP3026_XCLKCTRL_CLKSTOPPED);
 	outTi3026(PMINFO TVP3026_XTRUECOLORCTRL, TVP3026_XTRUECOLORCTRL_PSEUDOCOLOR);
diff -puN drivers/video/matrox/matroxfb_accel.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_accel.c
--- a/drivers/video/matrox/matroxfb_accel.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_accel.c
@@ -81,7 +81,7 @@
 #include "matroxfb_Ti3026.h"
 #include "matroxfb_misc.h"
 
-#define curr_ydstorg(x)	ACCESS_FBINFO2(x, curr.ydstorg.pixels)
+#define curr_ydstorg(x)	((x)->curr.ydstorg.pixels)
 
 #define mga_ydstlen(y,l) mga_outl(M_YDSTLEN | M_EXEC, ((y) << 16) | (l))
 
@@ -115,59 +115,59 @@ void matrox_cfbX_init(WPMINFO2) {
 
 	DBG(__func__)
 
-	mpitch = ACCESS_FBINFO(fbcon).var.xres_virtual;
+	mpitch = minfo->fbcon.var.xres_virtual;
 
-	ACCESS_FBINFO(fbops).fb_copyarea = cfb_copyarea;
-	ACCESS_FBINFO(fbops).fb_fillrect = cfb_fillrect;
-	ACCESS_FBINFO(fbops).fb_imageblit = cfb_imageblit;
-	ACCESS_FBINFO(fbops).fb_cursor = NULL;
+	minfo->fbops.fb_copyarea = cfb_copyarea;
+	minfo->fbops.fb_fillrect = cfb_fillrect;
+	minfo->fbops.fb_imageblit = cfb_imageblit;
+	minfo->fbops.fb_cursor = NULL;
 
-	accel = (ACCESS_FBINFO(fbcon).var.accel_flags & FB_ACCELF_TEXT) == FB_ACCELF_TEXT;
+	accel = (minfo->fbcon.var.accel_flags & FB_ACCELF_TEXT) == FB_ACCELF_TEXT;
 
-	switch (ACCESS_FBINFO(fbcon).var.bits_per_pixel) {
+	switch (minfo->fbcon.var.bits_per_pixel) {
 		case 4:		maccess = 0x00000000;	/* accelerate as 8bpp video */
 				mpitch = (mpitch >> 1) | 0x8000; /* disable linearization */
 				mopmode = M_OPMODE_4BPP;
-				matrox_cfb4_pal(ACCESS_FBINFO(cmap));
+				matrox_cfb4_pal(minfo->cmap);
 				if (accel && !(mpitch & 1)) {
-					ACCESS_FBINFO(fbops).fb_copyarea = matroxfb_cfb4_copyarea;
-					ACCESS_FBINFO(fbops).fb_fillrect = matroxfb_cfb4_fillrect;
+					minfo->fbops.fb_copyarea = matroxfb_cfb4_copyarea;
+					minfo->fbops.fb_fillrect = matroxfb_cfb4_fillrect;
 				}
 				break;
 		case 8:		maccess = 0x00000000;
 				mopmode = M_OPMODE_8BPP;
-				matrox_cfb8_pal(ACCESS_FBINFO(cmap));
+				matrox_cfb8_pal(minfo->cmap);
 				if (accel) {
-					ACCESS_FBINFO(fbops).fb_copyarea = matroxfb_copyarea;
-					ACCESS_FBINFO(fbops).fb_fillrect = matroxfb_fillrect;
-					ACCESS_FBINFO(fbops).fb_imageblit = matroxfb_imageblit;
+					minfo->fbops.fb_copyarea = matroxfb_copyarea;
+					minfo->fbops.fb_fillrect = matroxfb_fillrect;
+					minfo->fbops.fb_imageblit = matroxfb_imageblit;
 				}
 				break;
-		case 16:	if (ACCESS_FBINFO(fbcon).var.green.length == 5)
+		case 16:	if (minfo->fbcon.var.green.length == 5)
 					maccess = 0xC0000001;
 				else
 					maccess = 0x40000001;
 				mopmode = M_OPMODE_16BPP;
 				if (accel) {
-					ACCESS_FBINFO(fbops).fb_copyarea = matroxfb_copyarea;
-					ACCESS_FBINFO(fbops).fb_fillrect = matroxfb_fillrect;
-					ACCESS_FBINFO(fbops).fb_imageblit = matroxfb_imageblit;
+					minfo->fbops.fb_copyarea = matroxfb_copyarea;
+					minfo->fbops.fb_fillrect = matroxfb_fillrect;
+					minfo->fbops.fb_imageblit = matroxfb_imageblit;
 				}
 				break;
 		case 24:	maccess = 0x00000003;
 				mopmode = M_OPMODE_24BPP;
 				if (accel) {
-					ACCESS_FBINFO(fbops).fb_copyarea = matroxfb_copyarea;
-					ACCESS_FBINFO(fbops).fb_fillrect = matroxfb_fillrect;
-					ACCESS_FBINFO(fbops).fb_imageblit = matroxfb_imageblit;
+					minfo->fbops.fb_copyarea = matroxfb_copyarea;
+					minfo->fbops.fb_fillrect = matroxfb_fillrect;
+					minfo->fbops.fb_imageblit = matroxfb_imageblit;
 				}
 				break;
 		case 32:	maccess = 0x00000002;
 				mopmode = M_OPMODE_32BPP;
 				if (accel) {
-					ACCESS_FBINFO(fbops).fb_copyarea = matroxfb_copyarea;
-					ACCESS_FBINFO(fbops).fb_fillrect = matroxfb_fillrect;
-					ACCESS_FBINFO(fbops).fb_imageblit = matroxfb_imageblit;
+					minfo->fbops.fb_copyarea = matroxfb_copyarea;
+					minfo->fbops.fb_fillrect = matroxfb_fillrect;
+					minfo->fbops.fb_imageblit = matroxfb_imageblit;
 				}
 				break;
 		default:	maccess = 0x00000000;
@@ -176,10 +176,10 @@ void matrox_cfbX_init(WPMINFO2) {
 	}
 	mga_fifo(8);
 	mga_outl(M_PITCH, mpitch);
-	mga_outl(M_YDSTORG, curr_ydstorg(MINFO));
-	if (ACCESS_FBINFO(capable.plnwt))
+	mga_outl(M_YDSTORG, curr_ydstorg(minfo));
+	if (minfo->capable.plnwt)
 		mga_outl(M_PLNWT, -1);
-	if (ACCESS_FBINFO(capable.srcorg)) {
+	if (minfo->capable.srcorg) {
 		mga_outl(M_SRCORG, 0);
 		mga_outl(M_DSTORG, 0);
 	}
@@ -188,9 +188,9 @@ void matrox_cfbX_init(WPMINFO2) {
 	mga_outl(M_YTOP, 0);
 	mga_outl(M_YBOT, 0x01FFFFFF);
 	mga_outl(M_MACCESS, maccess);
-	ACCESS_FBINFO(accel.m_dwg_rect) = M_DWG_TRAP | M_DWG_SOLID | M_DWG_ARZERO | M_DWG_SGNZERO | M_DWG_SHIFTZERO;
-	if (isMilleniumII(MINFO)) ACCESS_FBINFO(accel.m_dwg_rect) |= M_DWG_TRANSC;
-	ACCESS_FBINFO(accel.m_opmode) = mopmode;
+	minfo->accel.m_dwg_rect = M_DWG_TRAP | M_DWG_SOLID | M_DWG_ARZERO | M_DWG_SGNZERO | M_DWG_SHIFTZERO;
+	if (isMilleniumII(minfo)) minfo->accel.m_dwg_rect |= M_DWG_TRANSC;
+	minfo->accel.m_opmode = mopmode;
 }
 
 EXPORT_SYMBOL(matrox_cfbX_init);
@@ -209,7 +209,7 @@ static void matrox_accel_bmove(WPMINFO i
 			 M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_AR5, vxres);
 		width--;
-		start = sy*vxres+sx+curr_ydstorg(MINFO);
+		start = sy*vxres+sx+curr_ydstorg(minfo);
 		end = start+width;
 	} else {
 		mga_fifo(3);
@@ -217,7 +217,7 @@ static void matrox_accel_bmove(WPMINFO i
 		mga_outl(M_SGN, 5);
 		mga_outl(M_AR5, -vxres);
 		width--;
-		end = (sy+height-1)*vxres+sx+curr_ydstorg(MINFO);
+		end = (sy+height-1)*vxres+sx+curr_ydstorg(minfo);
 		start = end+width;
 		dy += height-1;
 	}
@@ -245,7 +245,7 @@ static void matrox_accel_bmove_lin(WPMIN
 			M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_AR5, vxres);
 		width--;
-		start = sy*vxres+sx+curr_ydstorg(MINFO);
+		start = sy*vxres+sx+curr_ydstorg(minfo);
 		end = start+width;
 	} else {
 		mga_fifo(3);
@@ -253,7 +253,7 @@ static void matrox_accel_bmove_lin(WPMIN
 		mga_outl(M_SGN, 5);
 		mga_outl(M_AR5, -vxres);
 		width--;
-		end = (sy+height-1)*vxres+sx+curr_ydstorg(MINFO);
+		end = (sy+height-1)*vxres+sx+curr_ydstorg(minfo);
 		start = end+width;
 		dy += height-1;
 	}
@@ -274,13 +274,13 @@ static void matroxfb_cfb4_copyarea(struc
 	if ((area->sx | area->dx | area->width) & 1)
 		cfb_copyarea(info, area);
 	else
-		matrox_accel_bmove_lin(PMINFO ACCESS_FBINFO(fbcon.var.xres_virtual) >> 1, area->sy, area->sx >> 1, area->dy, area->dx >> 1, area->height, area->width >> 1);
+		matrox_accel_bmove_lin(PMINFO minfo->fbcon.var.xres_virtual >> 1, area->sy, area->sx >> 1, area->dy, area->dx >> 1, area->height, area->width >> 1);
 }
 
 static void matroxfb_copyarea(struct fb_info* info, const struct fb_copyarea* area) {
 	MINFO_FROM_INFO(info);
 
-	matrox_accel_bmove(PMINFO ACCESS_FBINFO(fbcon.var.xres_virtual), area->sy, area->sx, area->dy, area->dx, area->height, area->width);
+	matrox_accel_bmove(PMINFO minfo->fbcon.var.xres_virtual, area->sy, area->sx, area->dy, area->dx, area->height, area->width);
 }
 
 static void matroxfb_accel_clear(WPMINFO u_int32_t color, int sy, int sx, int height,
@@ -292,7 +292,7 @@ static void matroxfb_accel_clear(WPMINFO
 	CRITBEGIN
 
 	mga_fifo(5);
-	mga_outl(M_DWGCTL, ACCESS_FBINFO(accel.m_dwg_rect) | M_DWG_REPLACE);
+	mga_outl(M_DWGCTL, minfo->accel.m_dwg_rect | M_DWG_REPLACE);
 	mga_outl(M_FCOL, color);
 	mga_outl(M_FXBNDRY, ((sx + width) << 16) | sx);
 	mga_ydstlen(sy, height);
@@ -333,16 +333,16 @@ static void matroxfb_cfb4_clear(WPMINFO 
 	sx >>= 1;
 	if (width) {
 		mga_fifo(5);
-		mga_outl(M_DWGCTL, ACCESS_FBINFO(accel.m_dwg_rect) | M_DWG_REPLACE2);
+		mga_outl(M_DWGCTL, minfo->accel.m_dwg_rect | M_DWG_REPLACE2);
 		mga_outl(M_FCOL, bgx);
 		mga_outl(M_FXBNDRY, ((sx + width) << 16) | sx);
-		mga_outl(M_YDST, sy * ACCESS_FBINFO(fbcon).var.xres_virtual >> 6);
+		mga_outl(M_YDST, sy * minfo->fbcon.var.xres_virtual >> 6);
 		mga_outl(M_LEN | M_EXEC, height);
 		WaitTillIdle();
 	}
 	if (whattodo) {
-		u_int32_t step = ACCESS_FBINFO(fbcon).var.xres_virtual >> 1;
-		vaddr_t vbase = ACCESS_FBINFO(video.vbase);
+		u_int32_t step = minfo->fbcon.var.xres_virtual >> 1;
+		vaddr_t vbase = minfo->video.vbase;
 		if (whattodo & 1) {
 			unsigned int uaddr = sy * step + sx - 1;
 			u_int32_t loop;
@@ -412,7 +412,7 @@ static void matroxfb_1bpp_imageblit(WPMI
 	mga_outl(M_FCOL, fgx);
 	mga_outl(M_BCOL, bgx);
 	fxbndry = ((xx + width - 1) << 16) | xx;
-	mmio = ACCESS_FBINFO(mmio.vbase);
+	mmio = minfo->mmio.vbase;
 
 	mga_fifo(6);
 	mga_writel(mmio, M_FXBNDRY, fxbndry);
diff -puN drivers/video/matrox/matroxfb_base.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -155,20 +155,20 @@ static struct fb_var_screeninfo vesafb_d
 
 /* --------------------------------------------------------------------- */
 static void update_crtc2(WPMINFO unsigned int pos) {
-	struct matroxfb_dh_fb_info* info = ACCESS_FBINFO(crtc2.info);
+	struct matroxfb_dh_fb_info *info = minfo->crtc2.info;
 
 	/* Make sure that displays are compatible */
-	if (info && (info->fbcon.var.bits_per_pixel == ACCESS_FBINFO(fbcon).var.bits_per_pixel)
-		 && (info->fbcon.var.xres_virtual == ACCESS_FBINFO(fbcon).var.xres_virtual)
-		 && (info->fbcon.var.green.length == ACCESS_FBINFO(fbcon).var.green.length)
+	if (info && (info->fbcon.var.bits_per_pixel == minfo->fbcon.var.bits_per_pixel)
+		 && (info->fbcon.var.xres_virtual == minfo->fbcon.var.xres_virtual)
+		 && (info->fbcon.var.green.length == minfo->fbcon.var.green.length)
 		 ) {
-		switch (ACCESS_FBINFO(fbcon).var.bits_per_pixel) {
+		switch (minfo->fbcon.var.bits_per_pixel) {
 			case 16:
 			case 32:
 				pos = pos * 8;
 				if (info->interlaced) {
 					mga_outl(0x3C2C, pos);
-					mga_outl(0x3C28, pos + ACCESS_FBINFO(fbcon).var.xres_virtual * ACCESS_FBINFO(fbcon).var.bits_per_pixel / 8);
+					mga_outl(0x3C28, pos + minfo->fbcon.var.xres_virtual * minfo->fbcon.var.bits_per_pixel / 8);
 				} else {
 					mga_outl(0x3C28, pos);
 				}
@@ -178,16 +178,16 @@ static void update_crtc2(WPMINFO unsigne
 }
 
 static void matroxfb_crtc1_panpos(WPMINFO2) {
-	if (ACCESS_FBINFO(crtc1.panpos) >= 0) {
+	if (minfo->crtc1.panpos >= 0) {
 		unsigned long flags;
 		int panpos;
 
 		matroxfb_DAC_lock_irqsave(flags);
-		panpos = ACCESS_FBINFO(crtc1.panpos);
+		panpos = minfo->crtc1.panpos;
 		if (panpos >= 0) {
 			unsigned int extvga_reg;
 
-			ACCESS_FBINFO(crtc1.panpos) = -1; /* No update pending anymore */
+			minfo->crtc1.panpos = -1; /* No update pending anymore */
 			extvga_reg = mga_inb(M_EXTVGA_INDEX);
 			mga_setr(M_EXTVGA_INDEX, 0x00, panpos);
 			if (extvga_reg != 0x00) {
@@ -209,15 +209,15 @@ static irqreturn_t matrox_irq(int irq, v
 
 	if (status & 0x20) {
 		mga_outl(M_ICLEAR, 0x20);
-		ACCESS_FBINFO(crtc1.vsync.cnt)++;
+		minfo->crtc1.vsync.cnt++;
 		matroxfb_crtc1_panpos(PMINFO2);
-		wake_up_interruptible(&ACCESS_FBINFO(crtc1.vsync.wait));
+		wake_up_interruptible(&minfo->crtc1.vsync.wait);
 		handled = 1;
 	}
 	if (status & 0x200) {
 		mga_outl(M_ICLEAR, 0x200);
-		ACCESS_FBINFO(crtc2.vsync.cnt)++;
-		wake_up_interruptible(&ACCESS_FBINFO(crtc2.vsync.wait));
+		minfo->crtc2.vsync.cnt++;
+		wake_up_interruptible(&minfo->crtc2.vsync.wait);
 		handled = 1;
 	}
 	return IRQ_RETVAL(handled);
@@ -226,15 +226,15 @@ static irqreturn_t matrox_irq(int irq, v
 int matroxfb_enable_irq(WPMINFO int reenable) {
 	u_int32_t bm;
 
-	if (ACCESS_FBINFO(devflags.accelerator) == FB_ACCEL_MATROX_MGAG400)
+	if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG400)
 		bm = 0x220;
 	else
 		bm = 0x020;
 
-	if (!test_and_set_bit(0, &ACCESS_FBINFO(irq_flags))) {
-		if (request_irq(ACCESS_FBINFO(pcidev)->irq, matrox_irq,
-				IRQF_SHARED, "matroxfb", MINFO)) {
-			clear_bit(0, &ACCESS_FBINFO(irq_flags));
+	if (!test_and_set_bit(0, &minfo->irq_flags)) {
+		if (request_irq(minfo->pcidev->irq, matrox_irq,
+				IRQF_SHARED, "matroxfb", minfo)) {
+			clear_bit(0, &minfo->irq_flags);
 			return -EINVAL;
 		}
 		/* Clear any pending field interrupts */
@@ -253,14 +253,14 @@ int matroxfb_enable_irq(WPMINFO int reen
 }
 
 static void matroxfb_disable_irq(WPMINFO2) {
-	if (test_and_clear_bit(0, &ACCESS_FBINFO(irq_flags))) {
+	if (test_and_clear_bit(0, &minfo->irq_flags)) {
 		/* Flush pending pan-at-vbl request... */
 		matroxfb_crtc1_panpos(PMINFO2);
-		if (ACCESS_FBINFO(devflags.accelerator) == FB_ACCEL_MATROX_MGAG400)
+		if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG400)
 			mga_outl(M_IEN, mga_inl(M_IEN) & ~0x220);
 		else
 			mga_outl(M_IEN, mga_inl(M_IEN) & ~0x20);
-		free_irq(ACCESS_FBINFO(pcidev)->irq, MINFO);
+		free_irq(minfo->pcidev->irq, minfo);
 	}
 }
 
@@ -271,13 +271,13 @@ int matroxfb_wait_for_sync(WPMINFO u_int
 
 	switch (crtc) {
 		case 0:
-			vs = &ACCESS_FBINFO(crtc1.vsync);
+			vs = &minfo->crtc1.vsync;
 			break;
 		case 1:
-			if (ACCESS_FBINFO(devflags.accelerator) != FB_ACCEL_MATROX_MGAG400) {
+			if (minfo->devflags.accelerator != FB_ACCEL_MATROX_MGAG400) {
 				return -ENODEV;
 			}
-			vs = &ACCESS_FBINFO(crtc2.vsync);
+			vs = &minfo->crtc2.vsync;
 			break;
 		default:
 			return -ENODEV;
@@ -314,18 +314,18 @@ static void matrox_pan_var(WPMINFO struc
 
 	DBG(__func__)
 
-	if (ACCESS_FBINFO(dead))
+	if (minfo->dead)
 		return;
 
-	ACCESS_FBINFO(fbcon).var.xoffset = var->xoffset;
-	ACCESS_FBINFO(fbcon).var.yoffset = var->yoffset;
-	pos = (ACCESS_FBINFO(fbcon).var.yoffset * ACCESS_FBINFO(fbcon).var.xres_virtual + ACCESS_FBINFO(fbcon).var.xoffset) * ACCESS_FBINFO(curr.final_bppShift) / 32;
-	pos += ACCESS_FBINFO(curr.ydstorg.chunks);
-	p0 = ACCESS_FBINFO(hw).CRTC[0x0D] = pos & 0xFF;
-	p1 = ACCESS_FBINFO(hw).CRTC[0x0C] = (pos & 0xFF00) >> 8;
-	p2 = ACCESS_FBINFO(hw).CRTCEXT[0] = (ACCESS_FBINFO(hw).CRTCEXT[0] & 0xB0) | ((pos >> 16) & 0x0F) | ((pos >> 14) & 0x40);
+	minfo->fbcon.var.xoffset = var->xoffset;
+	minfo->fbcon.var.yoffset = var->yoffset;
+	pos = (minfo->fbcon.var.yoffset * minfo->fbcon.var.xres_virtual + minfo->fbcon.var.xoffset) * minfo->curr.final_bppShift / 32;
+	pos += minfo->curr.ydstorg.chunks;
+	p0 = minfo->hw.CRTC[0x0D] = pos & 0xFF;
+	p1 = minfo->hw.CRTC[0x0C] = (pos & 0xFF00) >> 8;
+	p2 = minfo->hw.CRTCEXT[0] = (minfo->hw.CRTCEXT[0] & 0xB0) | ((pos >> 16) & 0x0F) | ((pos >> 14) & 0x40);
 #ifdef CONFIG_FB_MATROX_32MB
-	p3 = ACCESS_FBINFO(hw).CRTCEXT[8] = pos >> 21;
+	p3 = minfo->hw.CRTCEXT[8] = pos >> 21;
 #endif
 
 	/* FB_ACTIVATE_VBL and we can acquire interrupts? Honor FB_ACTIVATE_VBL then... */
@@ -337,14 +337,14 @@ static void matrox_pan_var(WPMINFO struc
 	mga_setr(M_CRTC_INDEX, 0x0D, p0);
 	mga_setr(M_CRTC_INDEX, 0x0C, p1);
 #ifdef CONFIG_FB_MATROX_32MB
-	if (ACCESS_FBINFO(devflags.support32MB))
+	if (minfo->devflags.support32MB)
 		mga_setr(M_EXTVGA_INDEX, 0x08, p3);
 #endif
 	if (vbl) {
-		ACCESS_FBINFO(crtc1.panpos) = p2;
+		minfo->crtc1.panpos = p2;
 	} else {
 		/* Abort any pending change */
-		ACCESS_FBINFO(crtc1.panpos) = -1;
+		minfo->crtc1.panpos = -1;
 		mga_setr(M_EXTVGA_INDEX, 0x00, p2);
 	}
 	matroxfb_DAC_unlock_irqrestore(flags);
@@ -363,22 +363,22 @@ static void matroxfb_remove(WPMINFO int 
 	 * write data without causing too much damage...
 	 */
 
-	ACCESS_FBINFO(dead) = 1;
-	if (ACCESS_FBINFO(usecount)) {
+	minfo->dead = 1;
+	if (minfo->usecount) {
 		/* destroy it later */
 		return;
 	}
-	matroxfb_unregister_device(MINFO);
-	unregister_framebuffer(&ACCESS_FBINFO(fbcon));
+	matroxfb_unregister_device(minfo);
+	unregister_framebuffer(&minfo->fbcon);
 	matroxfb_g450_shutdown(PMINFO2);
 #ifdef CONFIG_MTRR
-	if (ACCESS_FBINFO(mtrr.vram_valid))
-		mtrr_del(ACCESS_FBINFO(mtrr.vram), ACCESS_FBINFO(video.base), ACCESS_FBINFO(video.len));
+	if (minfo->mtrr.vram_valid)
+		mtrr_del(minfo->mtrr.vram, minfo->video.base, minfo->video.len);
 #endif
-	mga_iounmap(ACCESS_FBINFO(mmio.vbase));
-	mga_iounmap(ACCESS_FBINFO(video.vbase));
-	release_mem_region(ACCESS_FBINFO(video.base), ACCESS_FBINFO(video.len_maximum));
-	release_mem_region(ACCESS_FBINFO(mmio.base), 16384);
+	mga_iounmap(minfo->mmio.vbase);
+	mga_iounmap(minfo->video.vbase);
+	release_mem_region(minfo->video.base, minfo->video.len_maximum);
+	release_mem_region(minfo->mmio.base, 16384);
 	kfree(minfo);
 }
 
@@ -392,12 +392,12 @@ static int matroxfb_open(struct fb_info 
 
 	DBG_LOOP(__func__)
 
-	if (ACCESS_FBINFO(dead)) {
+	if (minfo->dead) {
 		return -ENXIO;
 	}
-	ACCESS_FBINFO(usecount)++;
+	minfo->usecount++;
 	if (user) {
-		ACCESS_FBINFO(userusecount)++;
+		minfo->userusecount++;
 	}
 	return(0);
 }
@@ -409,11 +409,11 @@ static int matroxfb_release(struct fb_in
 	DBG_LOOP(__func__)
 
 	if (user) {
-		if (0 == --ACCESS_FBINFO(userusecount)) {
+		if (0 == --minfo->userusecount) {
 			matroxfb_disable_irq(PMINFO2);
 		}
 	}
-	if (!(--ACCESS_FBINFO(usecount)) && ACCESS_FBINFO(dead)) {
+	if (!(--minfo->usecount) && minfo->dead) {
 		matroxfb_remove(PMINFO 0);
 	}
 	return(0);
@@ -438,9 +438,9 @@ static int matroxfb_get_final_bppShift(C
 	if (!bppshft2) {
 		return 8;
 	}
-	if (isInterleave(MINFO))
+	if (isInterleave(minfo))
 		bppshft2 >>= 1;
-	if (ACCESS_FBINFO(devflags.video64bits))
+	if (minfo->devflags.video64bits)
 		bppshft2 >>= 1;
 	return bppshft2;
 }
@@ -463,11 +463,11 @@ static int matroxfb_test_and_set_roundin
 				break;
 		default:	rounding = 16;
 				/* on G400, 16 really does not work */
-				if (ACCESS_FBINFO(devflags.accelerator) == FB_ACCEL_MATROX_MGAG400)
+				if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG400)
 					rounding = 32;
 				break;
 	}
-	if (isInterleave(MINFO)) {
+	if (isInterleave(minfo)) {
 		rounding *= 2;
 	}
 	over = xres % rounding;
@@ -484,9 +484,9 @@ static int matroxfb_pitch_adjust(CPMINFO
 
 	if (!bpp) return xres;
 
-	width = ACCESS_FBINFO(capable.vxres);
+	width = minfo->capable.vxres;
 
-	if (ACCESS_FBINFO(devflags.precise_width)) {
+	if (minfo->devflags.precise_width) {
 		while (*width) {
 			if ((*width >= xres) && (matroxfb_test_and_set_rounding(PMINFO *width, bpp) == *width)) {
 				break;
@@ -549,7 +549,7 @@ static int matroxfb_decode_var(CPMINFO s
 	DBG(__func__)
 
 	switch (bpp) {
-		case 4:	 if (!ACCESS_FBINFO(capable.cfb4)) return -EINVAL;
+		case 4:	 if (!minfo->capable.cfb4) return -EINVAL;
 			 break;
 		case 8:	 break;
 		case 16: break;
@@ -558,7 +558,7 @@ static int matroxfb_decode_var(CPMINFO s
 		default: return -EINVAL;
 	}
 	*ydstorg = 0;
-	vramlen = ACCESS_FBINFO(video.len_usable);
+	vramlen = minfo->video.len_usable;
 	if (var->yres_virtual < var->yres)
 		var->yres_virtual = var->yres;
 	if (var->xres_virtual < var->xres)
@@ -573,7 +573,7 @@ static int matroxfb_decode_var(CPMINFO s
 	/* There is hardware bug that no line can cross 4MB boundary */
 	/* give up for CFB24, it is impossible to easy workaround it */
 	/* for other try to do something */
-	if (!ACCESS_FBINFO(capable.cross4MB) && (memlen > 0x400000)) {
+	if (!minfo->capable.cross4MB && (memlen > 0x400000)) {
 		if (bpp == 24) {
 			/* sorry */
 		} else {
@@ -653,20 +653,20 @@ static int matroxfb_setcolreg(unsigned r
 	 *  != 0 for invalid regno.
 	 */
 
-	if (regno >= ACCESS_FBINFO(curr.cmap_len))
+	if (regno >= minfo->curr.cmap_len)
 		return 1;
 
-	if (ACCESS_FBINFO(fbcon).var.grayscale) {
+	if (minfo->fbcon.var.grayscale) {
 		/* gray = 0.30*R + 0.59*G + 0.11*B */
 		red = green = blue = (red * 77 + green * 151 + blue * 28) >> 8;
 	}
 
-	red = CNVT_TOHW(red, ACCESS_FBINFO(fbcon).var.red.length);
-	green = CNVT_TOHW(green, ACCESS_FBINFO(fbcon).var.green.length);
-	blue = CNVT_TOHW(blue, ACCESS_FBINFO(fbcon).var.blue.length);
-	transp = CNVT_TOHW(transp, ACCESS_FBINFO(fbcon).var.transp.length);
+	red = CNVT_TOHW(red, minfo->fbcon.var.red.length);
+	green = CNVT_TOHW(green, minfo->fbcon.var.green.length);
+	blue = CNVT_TOHW(blue, minfo->fbcon.var.blue.length);
+	transp = CNVT_TOHW(transp, minfo->fbcon.var.transp.length);
 
-	switch (ACCESS_FBINFO(fbcon).var.bits_per_pixel) {
+	switch (minfo->fbcon.var.bits_per_pixel) {
 	case 4:
 	case 8:
 		mga_outb(M_DAC_REG, regno);
@@ -679,22 +679,22 @@ static int matroxfb_setcolreg(unsigned r
 			break;
 		{
 			u_int16_t col =
-				(red << ACCESS_FBINFO(fbcon).var.red.offset)     |
-				(green << ACCESS_FBINFO(fbcon).var.green.offset) |
-				(blue << ACCESS_FBINFO(fbcon).var.blue.offset)   |
-				(transp << ACCESS_FBINFO(fbcon).var.transp.offset); /* for 1:5:5:5 */
-			ACCESS_FBINFO(cmap[regno]) = col | (col << 16);
+				(red << minfo->fbcon.var.red.offset)     |
+				(green << minfo->fbcon.var.green.offset) |
+				(blue << minfo->fbcon.var.blue.offset)   |
+				(transp << minfo->fbcon.var.transp.offset); /* for 1:5:5:5 */
+			minfo->cmap[regno] = col | (col << 16);
 		}
 		break;
 	case 24:
 	case 32:
 		if (regno >= 16)
 			break;
-		ACCESS_FBINFO(cmap[regno]) =
-			(red   << ACCESS_FBINFO(fbcon).var.red.offset)   |
-			(green << ACCESS_FBINFO(fbcon).var.green.offset) |
-			(blue  << ACCESS_FBINFO(fbcon).var.blue.offset)  |
-			(transp << ACCESS_FBINFO(fbcon).var.transp.offset);	/* 8:8:8:8 */
+		minfo->cmap[regno] =
+			(red   << minfo->fbcon.var.red.offset)   |
+			(green << minfo->fbcon.var.green.offset) |
+			(blue  << minfo->fbcon.var.blue.offset)  |
+			(transp << minfo->fbcon.var.transp.offset);	/* 8:8:8:8 */
 		break;
 	}
 	return 0;
@@ -702,7 +702,7 @@ static int matroxfb_setcolreg(unsigned r
 
 static void matroxfb_init_fix(WPMINFO2)
 {
-	struct fb_fix_screeninfo *fix = &ACCESS_FBINFO(fbcon).fix;
+	struct fb_fix_screeninfo *fix = &minfo->fbcon.fix;
 	DBG(__func__)
 
 	strcpy(fix->id,"MATROX");
@@ -710,20 +710,20 @@ static void matroxfb_init_fix(WPMINFO2)
 	fix->xpanstep = 8;	/* 8 for 8bpp, 4 for 16bpp, 2 for 32bpp */
 	fix->ypanstep = 1;
 	fix->ywrapstep = 0;
-	fix->mmio_start = ACCESS_FBINFO(mmio.base);
-	fix->mmio_len = ACCESS_FBINFO(mmio.len);
-	fix->accel = ACCESS_FBINFO(devflags.accelerator);
+	fix->mmio_start = minfo->mmio.base;
+	fix->mmio_len = minfo->mmio.len;
+	fix->accel = minfo->devflags.accelerator;
 }
 
 static void matroxfb_update_fix(WPMINFO2)
 {
-	struct fb_fix_screeninfo *fix = &ACCESS_FBINFO(fbcon).fix;
+	struct fb_fix_screeninfo *fix = &minfo->fbcon.fix;
 	DBG(__func__)
 
-	mutex_lock(&ACCESS_FBINFO(fbcon).mm_lock);
-	fix->smem_start = ACCESS_FBINFO(video.base) + ACCESS_FBINFO(curr.ydstorg.bytes);
-	fix->smem_len = ACCESS_FBINFO(video.len_usable) - ACCESS_FBINFO(curr.ydstorg.bytes);
-	mutex_unlock(&ACCESS_FBINFO(fbcon).mm_lock);
+	mutex_lock(&minfo->fbcon.mm_lock);
+	fix->smem_start = minfo->video.base + minfo->curr.ydstorg.bytes;
+	fix->smem_len = minfo->video.len_usable - minfo->curr.ydstorg.bytes;
+	mutex_unlock(&minfo->fbcon.mm_lock);
 }
 
 static int matroxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
@@ -734,7 +734,7 @@ static int matroxfb_check_var(struct fb_
 	unsigned int ydstorg;
 	MINFO_FROM_INFO(info);
 
-	if (ACCESS_FBINFO(dead)) {
+	if (minfo->dead) {
 		return -ENXIO;
 	}
 	if ((err = matroxfb_decode_var(PMINFO var, &visual, &cmap_len, &ydstorg)) != 0)
@@ -753,31 +753,31 @@ static int matroxfb_set_par(struct fb_in
 
 	DBG(__func__)
 
-	if (ACCESS_FBINFO(dead)) {
+	if (minfo->dead) {
 		return -ENXIO;
 	}
 
 	var = &info->var;
 	if ((err = matroxfb_decode_var(PMINFO var, &visual, &cmap_len, &ydstorg)) != 0)
 		return err;
-	ACCESS_FBINFO(fbcon.screen_base) = vaddr_va(ACCESS_FBINFO(video.vbase)) + ydstorg;
+	minfo->fbcon.screen_base = vaddr_va(minfo->video.vbase) + ydstorg;
 	matroxfb_update_fix(PMINFO2);
-	ACCESS_FBINFO(fbcon).fix.visual = visual;
-	ACCESS_FBINFO(fbcon).fix.type = FB_TYPE_PACKED_PIXELS;
-	ACCESS_FBINFO(fbcon).fix.type_aux = 0;
-	ACCESS_FBINFO(fbcon).fix.line_length = (var->xres_virtual * var->bits_per_pixel) >> 3;
+	minfo->fbcon.fix.visual = visual;
+	minfo->fbcon.fix.type = FB_TYPE_PACKED_PIXELS;
+	minfo->fbcon.fix.type_aux = 0;
+	minfo->fbcon.fix.line_length = (var->xres_virtual * var->bits_per_pixel) >> 3;
 	{
 		unsigned int pos;
 
-		ACCESS_FBINFO(curr.cmap_len) = cmap_len;
-		ydstorg += ACCESS_FBINFO(devflags.ydstorg);
-		ACCESS_FBINFO(curr.ydstorg.bytes) = ydstorg;
-		ACCESS_FBINFO(curr.ydstorg.chunks) = ydstorg >> (isInterleave(MINFO)?3:2);
+		minfo->curr.cmap_len = cmap_len;
+		ydstorg += minfo->devflags.ydstorg;
+		minfo->curr.ydstorg.bytes = ydstorg;
+		minfo->curr.ydstorg.chunks = ydstorg >> (isInterleave(minfo) ? 3 : 2);
 		if (var->bits_per_pixel == 4)
-			ACCESS_FBINFO(curr.ydstorg.pixels) = ydstorg;
+			minfo->curr.ydstorg.pixels = ydstorg;
 		else
-			ACCESS_FBINFO(curr.ydstorg.pixels) = (ydstorg * 8) / var->bits_per_pixel;
-		ACCESS_FBINFO(curr.final_bppShift) = matroxfb_get_final_bppShift(PMINFO var->bits_per_pixel);
+			minfo->curr.ydstorg.pixels = (ydstorg * 8) / var->bits_per_pixel;
+		minfo->curr.final_bppShift = matroxfb_get_final_bppShift(PMINFO var->bits_per_pixel);
 		{	struct my_timming mt;
 			struct matrox_hw_state* hw;
 			int out;
@@ -793,46 +793,46 @@ static int matroxfb_set_par(struct fb_in
 				default:	mt.delay = 31 + 8; break;
 			}
 
-			hw = &ACCESS_FBINFO(hw);
+			hw = &minfo->hw;
 
-			down_read(&ACCESS_FBINFO(altout).lock);
+			down_read(&minfo->altout.lock);
 			for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-				if (ACCESS_FBINFO(outputs[out]).src == MATROXFB_SRC_CRTC1 &&
-				    ACCESS_FBINFO(outputs[out]).output->compute) {
-					ACCESS_FBINFO(outputs[out]).output->compute(ACCESS_FBINFO(outputs[out]).data, &mt);
+				if (minfo->outputs[out].src == MATROXFB_SRC_CRTC1 &&
+				    minfo->outputs[out].output->compute) {
+					minfo->outputs[out].output->compute(minfo->outputs[out].data, &mt);
 				}
 			}
-			up_read(&ACCESS_FBINFO(altout).lock);
-			ACCESS_FBINFO(crtc1).pixclock = mt.pixclock;
-			ACCESS_FBINFO(crtc1).mnp = mt.mnp;
-			ACCESS_FBINFO(hw_switch->init(PMINFO &mt));
-			pos = (var->yoffset * var->xres_virtual + var->xoffset) * ACCESS_FBINFO(curr.final_bppShift) / 32;
-			pos += ACCESS_FBINFO(curr.ydstorg.chunks);
+			up_read(&minfo->altout.lock);
+			minfo->crtc1.pixclock = mt.pixclock;
+			minfo->crtc1.mnp = mt.mnp;
+			minfo->hw_switch->init(PMINFO &mt);
+			pos = (var->yoffset * var->xres_virtual + var->xoffset) * minfo->curr.final_bppShift / 32;
+			pos += minfo->curr.ydstorg.chunks;
 
 			hw->CRTC[0x0D] = pos & 0xFF;
 			hw->CRTC[0x0C] = (pos & 0xFF00) >> 8;
 			hw->CRTCEXT[0] = (hw->CRTCEXT[0] & 0xF0) | ((pos >> 16) & 0x0F) | ((pos >> 14) & 0x40);
 			hw->CRTCEXT[8] = pos >> 21;
-			ACCESS_FBINFO(hw_switch->restore(PMINFO2));
+			minfo->hw_switch->restore(PMINFO2);
 			update_crtc2(PMINFO pos);
-			down_read(&ACCESS_FBINFO(altout).lock);
+			down_read(&minfo->altout.lock);
 			for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-				if (ACCESS_FBINFO(outputs[out]).src == MATROXFB_SRC_CRTC1 &&
-				    ACCESS_FBINFO(outputs[out]).output->program) {
-					ACCESS_FBINFO(outputs[out]).output->program(ACCESS_FBINFO(outputs[out]).data);
+				if (minfo->outputs[out].src == MATROXFB_SRC_CRTC1 &&
+				    minfo->outputs[out].output->program) {
+					minfo->outputs[out].output->program(minfo->outputs[out].data);
 				}
 			}
 			for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-				if (ACCESS_FBINFO(outputs[out]).src == MATROXFB_SRC_CRTC1 &&
-				    ACCESS_FBINFO(outputs[out]).output->start) {
-					ACCESS_FBINFO(outputs[out]).output->start(ACCESS_FBINFO(outputs[out]).data);
+				if (minfo->outputs[out].src == MATROXFB_SRC_CRTC1 &&
+				    minfo->outputs[out].output->start) {
+					minfo->outputs[out].output->start(minfo->outputs[out].data);
 				}
 			}
-			up_read(&ACCESS_FBINFO(altout).lock);
+			up_read(&minfo->altout.lock);
 			matrox_cfbX_init(PMINFO2);
 		}
 	}
-	ACCESS_FBINFO(initialized) = 1;
+	minfo->initialized = 1;
 	return 0;
 }
 
@@ -853,13 +853,13 @@ static int matroxfb_get_vblank(WPMINFO s
 		vblank->flags |= FB_VBLANK_HBLANKING;
 	if (sts1 & 8)
 		vblank->flags |= FB_VBLANK_VSYNCING;
-	if (vblank->vcount >= ACCESS_FBINFO(fbcon).var.yres)
+	if (vblank->vcount >= minfo->fbcon.var.yres)
 		vblank->flags |= FB_VBLANK_VBLANKING;
-	if (test_bit(0, &ACCESS_FBINFO(irq_flags))) {
+	if (test_bit(0, &minfo->irq_flags)) {
 		vblank->flags |= FB_VBLANK_HAVE_COUNT;
 		/* Only one writer, aligned int value...
 		   it should work without lock and without atomic_t */
-		vblank->count = ACCESS_FBINFO(crtc1).vsync.cnt;
+		vblank->count = minfo->crtc1.vsync.cnt;
 	}
 	return 0;
 }
@@ -876,7 +876,7 @@ static int matroxfb_ioctl(struct fb_info
 
 	DBG(__func__)
 
-	if (ACCESS_FBINFO(dead)) {
+	if (minfo->dead) {
 		return -ENXIO;
 	}
 
@@ -912,8 +912,8 @@ static int matroxfb_ioctl(struct fb_info
 					return -EFAULT;
 				if (mom.output >= MATROXFB_MAX_OUTPUTS)
 					return -ENXIO;
-				down_read(&ACCESS_FBINFO(altout.lock));
-				oproc = ACCESS_FBINFO(outputs[mom.output]).output;
+				down_read(&minfo->altout.lock);
+				oproc = minfo->outputs[mom.output].output;
 				if (!oproc) {
 					val = -ENXIO;
 				} else if (!oproc->verifymode) {
@@ -923,18 +923,18 @@ static int matroxfb_ioctl(struct fb_info
 						val = -EINVAL;
 					}
 				} else {
-					val = oproc->verifymode(ACCESS_FBINFO(outputs[mom.output]).data, mom.mode);
+					val = oproc->verifymode(minfo->outputs[mom.output].data, mom.mode);
 				}
 				if (!val) {
-					if (ACCESS_FBINFO(outputs[mom.output]).mode != mom.mode) {
-						ACCESS_FBINFO(outputs[mom.output]).mode = mom.mode;
+					if (minfo->outputs[mom.output].mode != mom.mode) {
+						minfo->outputs[mom.output].mode = mom.mode;
 						val = 1;
 					}
 				}
-				up_read(&ACCESS_FBINFO(altout.lock));
+				up_read(&minfo->altout.lock);
 				if (val != 1)
 					return val;
-				switch (ACCESS_FBINFO(outputs[mom.output]).src) {
+				switch (minfo->outputs[mom.output].src) {
 					case MATROXFB_SRC_CRTC1:
 						matroxfb_set_par(info);
 						break;
@@ -942,11 +942,11 @@ static int matroxfb_ioctl(struct fb_info
 						{
 							struct matroxfb_dh_fb_info* crtc2;
 
-							down_read(&ACCESS_FBINFO(crtc2.lock));
-							crtc2 = ACCESS_FBINFO(crtc2.info);
+							down_read(&minfo->crtc2.lock);
+							crtc2 = minfo->crtc2.info;
 							if (crtc2)
 								crtc2->fbcon.fbops->fb_set_par(&crtc2->fbcon);
-							up_read(&ACCESS_FBINFO(crtc2.lock));
+							up_read(&minfo->crtc2.lock);
 						}
 						break;
 				}
@@ -962,15 +962,15 @@ static int matroxfb_ioctl(struct fb_info
 					return -EFAULT;
 				if (mom.output >= MATROXFB_MAX_OUTPUTS)
 					return -ENXIO;
-				down_read(&ACCESS_FBINFO(altout.lock));
-				oproc = ACCESS_FBINFO(outputs[mom.output]).output;
+				down_read(&minfo->altout.lock);
+				oproc = minfo->outputs[mom.output].output;
 				if (!oproc) {
 					val = -ENXIO;
 				} else {
-					mom.mode = ACCESS_FBINFO(outputs[mom.output]).mode;
+					mom.mode = minfo->outputs[mom.output].mode;
 					val = 0;
 				}
-				up_read(&ACCESS_FBINFO(altout.lock));
+				up_read(&minfo->altout.lock);
 				if (val)
 					return val;
 				if (copy_to_user(argp, &mom, sizeof(mom)))
@@ -989,9 +989,9 @@ static int matroxfb_ioctl(struct fb_info
 					if (tmp & (1 << i)) {
 						if (i >= MATROXFB_MAX_OUTPUTS)
 							return -ENXIO;
-						if (!ACCESS_FBINFO(outputs[i]).output)
+						if (!minfo->outputs[i].output)
 							return -ENXIO;
-						switch (ACCESS_FBINFO(outputs[i]).src) {
+						switch (minfo->outputs[i].src) {
 							case MATROXFB_SRC_NONE:
 							case MATROXFB_SRC_CRTC1:
 								break;
@@ -1000,12 +1000,12 @@ static int matroxfb_ioctl(struct fb_info
 						}
 					}
 				}
-				if (ACCESS_FBINFO(devflags.panellink)) {
+				if (minfo->devflags.panellink) {
 					if (tmp & MATROXFB_OUTPUT_CONN_DFP) {
 						if (tmp & MATROXFB_OUTPUT_CONN_SECONDARY)
 							return -EINVAL;
 						for (i = 0; i < MATROXFB_MAX_OUTPUTS; i++) {
-							if (ACCESS_FBINFO(outputs[i]).src == MATROXFB_SRC_CRTC2) {
+							if (minfo->outputs[i].src == MATROXFB_SRC_CRTC2) {
 								return -EBUSY;
 							}
 						}
@@ -1014,13 +1014,13 @@ static int matroxfb_ioctl(struct fb_info
 				changes = 0;
 				for (i = 0; i < MATROXFB_MAX_OUTPUTS; i++) {
 					if (tmp & (1 << i)) {
-						if (ACCESS_FBINFO(outputs[i]).src != MATROXFB_SRC_CRTC1) {
+						if (minfo->outputs[i].src != MATROXFB_SRC_CRTC1) {
 							changes = 1;
-							ACCESS_FBINFO(outputs[i]).src = MATROXFB_SRC_CRTC1;
+							minfo->outputs[i].src = MATROXFB_SRC_CRTC1;
 						}
-					} else if (ACCESS_FBINFO(outputs[i]).src == MATROXFB_SRC_CRTC1) {
+					} else if (minfo->outputs[i].src == MATROXFB_SRC_CRTC1) {
 						changes = 1;
-						ACCESS_FBINFO(outputs[i]).src = MATROXFB_SRC_NONE;
+						minfo->outputs[i].src = MATROXFB_SRC_NONE;
 					}
 				}
 				if (!changes)
@@ -1034,7 +1034,7 @@ static int matroxfb_ioctl(struct fb_info
 				int i;
 
 				for (i = 0; i < MATROXFB_MAX_OUTPUTS; i++) {
-					if (ACCESS_FBINFO(outputs[i]).src == MATROXFB_SRC_CRTC1) {
+					if (minfo->outputs[i].src == MATROXFB_SRC_CRTC1) {
 						conn |= 1 << i;
 					}
 				}
@@ -1048,8 +1048,8 @@ static int matroxfb_ioctl(struct fb_info
 				int i;
 
 				for (i = 0; i < MATROXFB_MAX_OUTPUTS; i++) {
-					if (ACCESS_FBINFO(outputs[i]).output) {
-						switch (ACCESS_FBINFO(outputs[i]).src) {
+					if (minfo->outputs[i].output) {
+						switch (minfo->outputs[i].src) {
 							case MATROXFB_SRC_NONE:
 							case MATROXFB_SRC_CRTC1:
 								conn |= 1 << i;
@@ -1057,7 +1057,7 @@ static int matroxfb_ioctl(struct fb_info
 						}
 					}
 				}
-				if (ACCESS_FBINFO(devflags.panellink)) {
+				if (minfo->devflags.panellink) {
 					if (conn & MATROXFB_OUTPUT_CONN_DFP)
 						conn &= ~MATROXFB_OUTPUT_CONN_SECONDARY;
 					if (conn & MATROXFB_OUTPUT_CONN_SECONDARY)
@@ -1073,7 +1073,7 @@ static int matroxfb_ioctl(struct fb_info
 				int i;
 
 				for (i = 0; i < MATROXFB_MAX_OUTPUTS; i++) {
-					if (ACCESS_FBINFO(outputs[i]).output) {
+					if (minfo->outputs[i].output) {
 						conn |= 1 << i;
 					}
 				}
@@ -1088,7 +1088,7 @@ static int matroxfb_ioctl(struct fb_info
 				memset(&r, 0, sizeof(r));
 				strcpy(r.driver, "matroxfb");
 				strcpy(r.card, "Matrox");
-				sprintf(r.bus_info, "PCI:%s", pci_name(ACCESS_FBINFO(pcidev)));
+				sprintf(r.bus_info, "PCI:%s", pci_name(minfo->pcidev));
 				r.version = KERNEL_VERSION(1,0,0);
 				r.capabilities = V4L2_CAP_VIDEO_OUTPUT;
 				if (copy_to_user(argp, &r, sizeof(r)))
@@ -1104,15 +1104,15 @@ static int matroxfb_ioctl(struct fb_info
 				if (copy_from_user(&qctrl, argp, sizeof(qctrl)))
 					return -EFAULT;
 
-				down_read(&ACCESS_FBINFO(altout).lock);
-				if (!ACCESS_FBINFO(outputs[1]).output) {
+				down_read(&minfo->altout.lock);
+				if (!minfo->outputs[1].output) {
 					err = -ENXIO;
-				} else if (ACCESS_FBINFO(outputs[1]).output->getqueryctrl) {
-					err = ACCESS_FBINFO(outputs[1]).output->getqueryctrl(ACCESS_FBINFO(outputs[1]).data, &qctrl);
+				} else if (minfo->outputs[1].output->getqueryctrl) {
+					err = minfo->outputs[1].output->getqueryctrl(minfo->outputs[1].data, &qctrl);
 				} else {
 					err = -EINVAL;
 				}
-				up_read(&ACCESS_FBINFO(altout).lock);
+				up_read(&minfo->altout.lock);
 				if (err >= 0 &&
 				    copy_to_user(argp, &qctrl, sizeof(qctrl)))
 					return -EFAULT;
@@ -1126,15 +1126,15 @@ static int matroxfb_ioctl(struct fb_info
 				if (copy_from_user(&ctrl, argp, sizeof(ctrl)))
 					return -EFAULT;
 
-				down_read(&ACCESS_FBINFO(altout).lock);
-				if (!ACCESS_FBINFO(outputs[1]).output) {
+				down_read(&minfo->altout.lock);
+				if (!minfo->outputs[1].output) {
 					err = -ENXIO;
-				} else if (ACCESS_FBINFO(outputs[1]).output->getctrl) {
-					err = ACCESS_FBINFO(outputs[1]).output->getctrl(ACCESS_FBINFO(outputs[1]).data, &ctrl);
+				} else if (minfo->outputs[1].output->getctrl) {
+					err = minfo->outputs[1].output->getctrl(minfo->outputs[1].data, &ctrl);
 				} else {
 					err = -EINVAL;
 				}
-				up_read(&ACCESS_FBINFO(altout).lock);
+				up_read(&minfo->altout.lock);
 				if (err >= 0 &&
 				    copy_to_user(argp, &ctrl, sizeof(ctrl)))
 					return -EFAULT;
@@ -1149,15 +1149,15 @@ static int matroxfb_ioctl(struct fb_info
 				if (copy_from_user(&ctrl, argp, sizeof(ctrl)))
 					return -EFAULT;
 
-				down_read(&ACCESS_FBINFO(altout).lock);
-				if (!ACCESS_FBINFO(outputs[1]).output) {
+				down_read(&minfo->altout.lock);
+				if (!minfo->outputs[1].output) {
 					err = -ENXIO;
-				} else if (ACCESS_FBINFO(outputs[1]).output->setctrl) {
-					err = ACCESS_FBINFO(outputs[1]).output->setctrl(ACCESS_FBINFO(outputs[1]).data, &ctrl);
+				} else if (minfo->outputs[1].output->setctrl) {
+					err = minfo->outputs[1].output->setctrl(minfo->outputs[1].data, &ctrl);
 				} else {
 					err = -EINVAL;
 				}
-				up_read(&ACCESS_FBINFO(altout).lock);
+				up_read(&minfo->altout.lock);
 				return err;
 			}
 	}
@@ -1175,7 +1175,7 @@ static int matroxfb_blank(int blank, str
 
 	DBG(__func__)
 
-	if (ACCESS_FBINFO(dead))
+	if (minfo->dead)
 		return 1;
 
 	switch (blank) {
@@ -1287,7 +1287,7 @@ static int matroxfb_getmemory(WPMINFO un
 
 	DBG(__func__)
 
-	vm = ACCESS_FBINFO(video.vbase);
+	vm = minfo->video.vbase;
 	maxSize &= ~0x1FFFFF;	/* must be X*2MB (really it must be 2 or X*4MB) */
 	/* at least 2MB */
 	if (maxSize < 0x0200000) return 0;
@@ -1319,7 +1319,7 @@ static int matroxfb_getmemory(WPMINFO un
 
 	*realSize = offs - 0x100000;
 #ifdef CONFIG_FB_MATROX_MILLENIUM
-	ACCESS_FBINFO(interleave) = !(!isMillenium(MINFO) || ((offs - 0x100000) & 0x3FFFFF));
+	minfo->interleave = !(!isMillenium(minfo) || ((offs - 0x100000) & 0x3FFFFF));
 #endif
 	return 1;
 }
@@ -1558,12 +1558,12 @@ static void setDefaultOutputs(WPMINFO2) 
 	unsigned int i;
 	const char* ptr;
 
-	ACCESS_FBINFO(outputs[0]).default_src = MATROXFB_SRC_CRTC1;
-	if (ACCESS_FBINFO(devflags.g450dac)) {
-		ACCESS_FBINFO(outputs[1]).default_src = MATROXFB_SRC_CRTC1;
-		ACCESS_FBINFO(outputs[2]).default_src = MATROXFB_SRC_CRTC1;
+	minfo->outputs[0].default_src = MATROXFB_SRC_CRTC1;
+	if (minfo->devflags.g450dac) {
+		minfo->outputs[1].default_src = MATROXFB_SRC_CRTC1;
+		minfo->outputs[2].default_src = MATROXFB_SRC_CRTC1;
 	} else if (dfp) {
-		ACCESS_FBINFO(outputs[2]).default_src = MATROXFB_SRC_CRTC1;
+		minfo->outputs[2].default_src = MATROXFB_SRC_CRTC1;
 	}
 	ptr = outputs;
 	for (i = 0; i < MATROXFB_MAX_OUTPUTS; i++) {
@@ -1573,11 +1573,11 @@ static void setDefaultOutputs(WPMINFO2) 
 			break;
 		}
 		if (c == '0') {
-			ACCESS_FBINFO(outputs[i]).default_src = MATROXFB_SRC_NONE;
+			minfo->outputs[i].default_src = MATROXFB_SRC_NONE;
 		} else if (c == '1') {
-			ACCESS_FBINFO(outputs[i]).default_src = MATROXFB_SRC_CRTC1;
-		} else if (c == '2' && ACCESS_FBINFO(devflags.crtc2)) {
-			ACCESS_FBINFO(outputs[i]).default_src = MATROXFB_SRC_CRTC2;
+			minfo->outputs[i].default_src = MATROXFB_SRC_CRTC1;
+		} else if (c == '2' && minfo->devflags.crtc2) {
+			minfo->outputs[i].default_src = MATROXFB_SRC_CRTC2;
 		} else {
 			printk(KERN_ERR "matroxfb: Unknown outputs setting\n");
 			break;
@@ -1603,58 +1603,58 @@ static int initMatrox2(WPMINFO struct bo
 	/* set default values... */
 	vesafb_defined.accel_flags = FB_ACCELF_TEXT;
 
-	ACCESS_FBINFO(hw_switch) = b->base->lowlevel;
-	ACCESS_FBINFO(devflags.accelerator) = b->base->accelID;
-	ACCESS_FBINFO(max_pixel_clock) = b->maxclk;
+	minfo->hw_switch = b->base->lowlevel;
+	minfo->devflags.accelerator = b->base->accelID;
+	minfo->max_pixel_clock = b->maxclk;
 
 	printk(KERN_INFO "matroxfb: Matrox %s detected\n", b->name);
-	ACCESS_FBINFO(capable.plnwt) = 1;
-	ACCESS_FBINFO(chip) = b->chip;
-	ACCESS_FBINFO(capable.srcorg) = b->flags & DEVF_SRCORG;
-	ACCESS_FBINFO(devflags.video64bits) = b->flags & DEVF_VIDEO64BIT;
+	minfo->capable.plnwt = 1;
+	minfo->chip = b->chip;
+	minfo->capable.srcorg = b->flags & DEVF_SRCORG;
+	minfo->devflags.video64bits = b->flags & DEVF_VIDEO64BIT;
 	if (b->flags & DEVF_TEXT4B) {
-		ACCESS_FBINFO(devflags.vgastep) = 4;
-		ACCESS_FBINFO(devflags.textmode) = 4;
-		ACCESS_FBINFO(devflags.text_type_aux) = FB_AUX_TEXT_MGA_STEP16;
+		minfo->devflags.vgastep = 4;
+		minfo->devflags.textmode = 4;
+		minfo->devflags.text_type_aux = FB_AUX_TEXT_MGA_STEP16;
 	} else if (b->flags & DEVF_TEXT16B) {
-		ACCESS_FBINFO(devflags.vgastep) = 16;
-		ACCESS_FBINFO(devflags.textmode) = 1;
-		ACCESS_FBINFO(devflags.text_type_aux) = FB_AUX_TEXT_MGA_STEP16;
+		minfo->devflags.vgastep = 16;
+		minfo->devflags.textmode = 1;
+		minfo->devflags.text_type_aux = FB_AUX_TEXT_MGA_STEP16;
 	} else {
-		ACCESS_FBINFO(devflags.vgastep) = 8;
-		ACCESS_FBINFO(devflags.textmode) = 1;
-		ACCESS_FBINFO(devflags.text_type_aux) = FB_AUX_TEXT_MGA_STEP8;
+		minfo->devflags.vgastep = 8;
+		minfo->devflags.textmode = 1;
+		minfo->devflags.text_type_aux = FB_AUX_TEXT_MGA_STEP8;
 	}
 #ifdef CONFIG_FB_MATROX_32MB
-	ACCESS_FBINFO(devflags.support32MB) = (b->flags & DEVF_SUPPORT32MB) != 0;
+	minfo->devflags.support32MB = (b->flags & DEVF_SUPPORT32MB) != 0;
 #endif
-	ACCESS_FBINFO(devflags.precise_width) = !(b->flags & DEVF_ANY_VXRES);
-	ACCESS_FBINFO(devflags.crtc2) = (b->flags & DEVF_CRTC2) != 0;
-	ACCESS_FBINFO(devflags.maven_capable) = (b->flags & DEVF_MAVEN_CAPABLE) != 0;
-	ACCESS_FBINFO(devflags.dualhead) = (b->flags & DEVF_DUALHEAD) != 0;
-	ACCESS_FBINFO(devflags.dfp_type) = dfp_type;
-	ACCESS_FBINFO(devflags.g450dac) = (b->flags & DEVF_G450DAC) != 0;
-	ACCESS_FBINFO(devflags.textstep) = ACCESS_FBINFO(devflags.vgastep) * ACCESS_FBINFO(devflags.textmode);
-	ACCESS_FBINFO(devflags.textvram) = 65536 / ACCESS_FBINFO(devflags.textmode);
+	minfo->devflags.precise_width = !(b->flags & DEVF_ANY_VXRES);
+	minfo->devflags.crtc2 = (b->flags & DEVF_CRTC2) != 0;
+	minfo->devflags.maven_capable = (b->flags & DEVF_MAVEN_CAPABLE) != 0;
+	minfo->devflags.dualhead = (b->flags & DEVF_DUALHEAD) != 0;
+	minfo->devflags.dfp_type = dfp_type;
+	minfo->devflags.g450dac = (b->flags & DEVF_G450DAC) != 0;
+	minfo->devflags.textstep = minfo->devflags.vgastep * minfo->devflags.textmode;
+	minfo->devflags.textvram = 65536 / minfo->devflags.textmode;
 	setDefaultOutputs(PMINFO2);
 	if (b->flags & DEVF_PANELLINK_CAPABLE) {
-		ACCESS_FBINFO(outputs[2]).data = MINFO;
-		ACCESS_FBINFO(outputs[2]).output = &panellink_output;
-		ACCESS_FBINFO(outputs[2]).src = ACCESS_FBINFO(outputs[2]).default_src;
-		ACCESS_FBINFO(outputs[2]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
-		ACCESS_FBINFO(devflags.panellink) = 1;
+		minfo->outputs[2].data = minfo;
+		minfo->outputs[2].output = &panellink_output;
+		minfo->outputs[2].src = minfo->outputs[2].default_src;
+		minfo->outputs[2].mode = MATROXFB_OUTPUT_MODE_MONITOR;
+		minfo->devflags.panellink = 1;
 	}
 
-	if (ACCESS_FBINFO(capable.cross4MB) < 0)
-		ACCESS_FBINFO(capable.cross4MB) = b->flags & DEVF_CROSS4MB;
+	if (minfo->capable.cross4MB < 0)
+		minfo->capable.cross4MB = b->flags & DEVF_CROSS4MB;
 	if (b->flags & DEVF_SWAPS) {
-		ctrlptr_phys = pci_resource_start(ACCESS_FBINFO(pcidev), 1);
-		video_base_phys = pci_resource_start(ACCESS_FBINFO(pcidev), 0);
-		ACCESS_FBINFO(devflags.fbResource) = PCI_BASE_ADDRESS_0;
+		ctrlptr_phys = pci_resource_start(minfo->pcidev, 1);
+		video_base_phys = pci_resource_start(minfo->pcidev, 0);
+		minfo->devflags.fbResource = PCI_BASE_ADDRESS_0;
 	} else {
-		ctrlptr_phys = pci_resource_start(ACCESS_FBINFO(pcidev), 0);
-		video_base_phys = pci_resource_start(ACCESS_FBINFO(pcidev), 1);
-		ACCESS_FBINFO(devflags.fbResource) = PCI_BASE_ADDRESS_1;
+		ctrlptr_phys = pci_resource_start(minfo->pcidev, 0);
+		video_base_phys = pci_resource_start(minfo->pcidev, 1);
+		minfo->devflags.fbResource = PCI_BASE_ADDRESS_1;
 	}
 	err = -EINVAL;
 	if (!ctrlptr_phys) {
@@ -1672,7 +1672,7 @@ static int initMatrox2(WPMINFO struct bo
 	if (!request_mem_region(video_base_phys, memsize, "matroxfb FB")) {
 		goto failCtrlMR;
 	}
-	ACCESS_FBINFO(video.len_maximum) = memsize;
+	minfo->video.len_maximum = memsize;
 	/* convert mem (autodetect k, M) */
 	if (mem < 1024) mem *= 1024;
 	if (mem < 0x00100000) mem *= 1024;
@@ -1680,14 +1680,14 @@ static int initMatrox2(WPMINFO struct bo
 	if (mem && (mem < memsize))
 		memsize = mem;
 	err = -ENOMEM;
-	if (mga_ioremap(ctrlptr_phys, 16384, MGA_IOREMAP_MMIO, &ACCESS_FBINFO(mmio.vbase))) {
+	if (mga_ioremap(ctrlptr_phys, 16384, MGA_IOREMAP_MMIO, &minfo->mmio.vbase)) {
 		printk(KERN_ERR "matroxfb: cannot ioremap(%lX, 16384), matroxfb disabled\n", ctrlptr_phys);
 		goto failVideoMR;
 	}
-	ACCESS_FBINFO(mmio.base) = ctrlptr_phys;
-	ACCESS_FBINFO(mmio.len) = 16384;
-	ACCESS_FBINFO(video.base) = video_base_phys;
-	if (mga_ioremap(video_base_phys, memsize, MGA_IOREMAP_FB, &ACCESS_FBINFO(video.vbase))) {
+	minfo->mmio.base = ctrlptr_phys;
+	minfo->mmio.len = 16384;
+	minfo->video.base = video_base_phys;
+	if (mga_ioremap(video_base_phys, memsize, MGA_IOREMAP_FB, &minfo->video.vbase)) {
 		printk(KERN_ERR "matroxfb: cannot ioremap(%lX, %d), matroxfb disabled\n",
 			video_base_phys, memsize);
 		goto failCtrlIO;
@@ -1696,63 +1696,63 @@ static int initMatrox2(WPMINFO struct bo
 		u_int32_t cmd;
 		u_int32_t mga_option;
 
-		pci_read_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, &mga_option);
-		pci_read_config_dword(ACCESS_FBINFO(pcidev), PCI_COMMAND, &cmd);
+		pci_read_config_dword(minfo->pcidev, PCI_OPTION_REG, &mga_option);
+		pci_read_config_dword(minfo->pcidev, PCI_COMMAND, &cmd);
 		mga_option &= 0x7FFFFFFF; /* clear BIG_ENDIAN */
 		mga_option |= MX_OPTION_BSWAP;
 		/* disable palette snooping */
 		cmd &= ~PCI_COMMAND_VGA_PALETTE;
 		if (pci_dev_present(intel_82437)) {
-			if (!(mga_option & 0x20000000) && !ACCESS_FBINFO(devflags.nopciretry)) {
+			if (!(mga_option & 0x20000000) && !minfo->devflags.nopciretry) {
 				printk(KERN_WARNING "matroxfb: Disabling PCI retries due to i82437 present\n");
 			}
 			mga_option |= 0x20000000;
-			ACCESS_FBINFO(devflags.nopciretry) = 1;
+			minfo->devflags.nopciretry = 1;
 		}
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_COMMAND, cmd);
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_OPTION_REG, mga_option);
-		ACCESS_FBINFO(hw).MXoptionReg = mga_option;
+		pci_write_config_dword(minfo->pcidev, PCI_COMMAND, cmd);
+		pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, mga_option);
+		minfo->hw.MXoptionReg = mga_option;
 
 		/* select non-DMA memory for PCI_MGA_DATA, otherwise dump of PCI cfg space can lock PCI bus */
 		/* maybe preinit() candidate, but it is same... for all devices... at this time... */
-		pci_write_config_dword(ACCESS_FBINFO(pcidev), PCI_MGA_INDEX, 0x00003C00);
+		pci_write_config_dword(minfo->pcidev, PCI_MGA_INDEX, 0x00003C00);
 	}
 
 	err = -ENXIO;
 	matroxfb_read_pins(PMINFO2);
-	if (ACCESS_FBINFO(hw_switch)->preinit(PMINFO2)) {
+	if (minfo->hw_switch->preinit(PMINFO2)) {
 		goto failVideoIO;
 	}
 
 	err = -ENOMEM;
-	if (!matroxfb_getmemory(PMINFO memsize, &ACCESS_FBINFO(video.len)) || !ACCESS_FBINFO(video.len)) {
+	if (!matroxfb_getmemory(PMINFO memsize, &minfo->video.len) || !minfo->video.len) {
 		printk(KERN_ERR "matroxfb: cannot determine memory size\n");
 		goto failVideoIO;
 	}
-	ACCESS_FBINFO(devflags.ydstorg) = 0;
+	minfo->devflags.ydstorg = 0;
 
-	ACCESS_FBINFO(video.base) = video_base_phys;
-	ACCESS_FBINFO(video.len_usable) = ACCESS_FBINFO(video.len);
-	if (ACCESS_FBINFO(video.len_usable) > b->base->maxdisplayable)
-		ACCESS_FBINFO(video.len_usable) = b->base->maxdisplayable;
+	minfo->video.base = video_base_phys;
+	minfo->video.len_usable = minfo->video.len;
+	if (minfo->video.len_usable > b->base->maxdisplayable)
+		minfo->video.len_usable = b->base->maxdisplayable;
 #ifdef CONFIG_MTRR
 	if (mtrr) {
-		ACCESS_FBINFO(mtrr.vram) = mtrr_add(video_base_phys, ACCESS_FBINFO(video.len), MTRR_TYPE_WRCOMB, 1);
-		ACCESS_FBINFO(mtrr.vram_valid) = 1;
+		minfo->mtrr.vram = mtrr_add(video_base_phys, minfo->video.len, MTRR_TYPE_WRCOMB, 1);
+		minfo->mtrr.vram_valid = 1;
 		printk(KERN_INFO "matroxfb: MTRR's turned on\n");
 	}
 #endif	/* CONFIG_MTRR */
 
-	if (!ACCESS_FBINFO(devflags.novga))
+	if (!minfo->devflags.novga)
 		request_region(0x3C0, 32, "matrox");
 	matroxfb_g450_connect(PMINFO2);
-	ACCESS_FBINFO(hw_switch->reset(PMINFO2));
+	minfo->hw_switch->reset(PMINFO2);
 
-	ACCESS_FBINFO(fbcon.monspecs.hfmin) = 0;
-	ACCESS_FBINFO(fbcon.monspecs.hfmax) = fh;
-	ACCESS_FBINFO(fbcon.monspecs.vfmin) = 0;
-	ACCESS_FBINFO(fbcon.monspecs.vfmax) = fv;
-	ACCESS_FBINFO(fbcon.monspecs.dpms) = 0;	/* TBD */
+	minfo->fbcon.monspecs.hfmin = 0;
+	minfo->fbcon.monspecs.hfmax = fh;
+	minfo->fbcon.monspecs.vfmin = 0;
+	minfo->fbcon.monspecs.vfmax = fv;
+	minfo->fbcon.monspecs.dpms = 0;	/* TBD */
 
 	/* static settings */
 	vesafb_defined.red = colors[depth-1].red;
@@ -1764,24 +1764,24 @@ static int initMatrox2(WPMINFO struct bo
 	if (noaccel)
 		vesafb_defined.accel_flags &= ~FB_ACCELF_TEXT;
 
-	ACCESS_FBINFO(fbops) = matroxfb_ops;
-	ACCESS_FBINFO(fbcon.fbops) = &ACCESS_FBINFO(fbops);
-	ACCESS_FBINFO(fbcon.pseudo_palette) = ACCESS_FBINFO(cmap);
+	minfo->fbops = matroxfb_ops;
+	minfo->fbcon.fbops = &minfo->fbops;
+	minfo->fbcon.pseudo_palette = minfo->cmap;
 	/* after __init time we are like module... no logo */
-	ACCESS_FBINFO(fbcon.flags) = hotplug ? FBINFO_FLAG_MODULE : FBINFO_FLAG_DEFAULT;
-	ACCESS_FBINFO(fbcon.flags) |= FBINFO_PARTIAL_PAN_OK | 	 /* Prefer panning for scroll under MC viewer/edit */
+	minfo->fbcon.flags = hotplug ? FBINFO_FLAG_MODULE : FBINFO_FLAG_DEFAULT;
+	minfo->fbcon.flags |= FBINFO_PARTIAL_PAN_OK | 	 /* Prefer panning for scroll under MC viewer/edit */
 				      FBINFO_HWACCEL_COPYAREA |  /* We have hw-assisted bmove */
 				      FBINFO_HWACCEL_FILLRECT |  /* And fillrect */
 				      FBINFO_HWACCEL_IMAGEBLIT | /* And imageblit */
 				      FBINFO_HWACCEL_XPAN |      /* And we support both horizontal */
 				      FBINFO_HWACCEL_YPAN;       /* And vertical panning */
-	ACCESS_FBINFO(video.len_usable) &= PAGE_MASK;
-	fb_alloc_cmap(&ACCESS_FBINFO(fbcon.cmap), 256, 1);
+	minfo->video.len_usable &= PAGE_MASK;
+	fb_alloc_cmap(&minfo->fbcon.cmap, 256, 1);
 
 #ifndef MODULE
 	/* mode database is marked __init!!! */
 	if (!hotplug) {
-		fb_find_mode(&vesafb_defined, &ACCESS_FBINFO(fbcon), videomode[0]?videomode:NULL,
+		fb_find_mode(&vesafb_defined, &minfo->fbcon, videomode[0] ? videomode : NULL,
 			NULL, 0, &defaultmode, vesafb_defined.bits_per_pixel);
 	}
 #endif /* !MODULE */
@@ -1871,51 +1871,51 @@ static int initMatrox2(WPMINFO struct bo
 							to yres_virtual * xres_virtual < 2^32 */
 	}
 	matroxfb_init_fix(PMINFO2);
-	ACCESS_FBINFO(fbcon.screen_base) = vaddr_va(ACCESS_FBINFO(video.vbase));
+	minfo->fbcon.screen_base = vaddr_va(minfo->video.vbase);
 	/* Normalize values (namely yres_virtual) */
-	matroxfb_check_var(&vesafb_defined, &ACCESS_FBINFO(fbcon));
+	matroxfb_check_var(&vesafb_defined, &minfo->fbcon);
 	/* And put it into "current" var. Do NOT program hardware yet, or we'll not take over
 	 * vgacon correctly. fbcon_startup will call fb_set_par for us, WITHOUT check_var,
 	 * and unfortunately it will do it BEFORE vgacon contents is saved, so it won't work
 	 * anyway. But we at least tried... */
-	ACCESS_FBINFO(fbcon.var) = vesafb_defined;
+	minfo->fbcon.var = vesafb_defined;
 	err = -EINVAL;
 
 	printk(KERN_INFO "matroxfb: %dx%dx%dbpp (virtual: %dx%d)\n",
 		vesafb_defined.xres, vesafb_defined.yres, vesafb_defined.bits_per_pixel,
 		vesafb_defined.xres_virtual, vesafb_defined.yres_virtual);
 	printk(KERN_INFO "matroxfb: framebuffer at 0x%lX, mapped to 0x%p, size %d\n",
-		ACCESS_FBINFO(video.base), vaddr_va(ACCESS_FBINFO(video.vbase)), ACCESS_FBINFO(video.len));
+		minfo->video.base, vaddr_va(minfo->video.vbase), minfo->video.len);
 
 /* We do not have to set currcon to 0... register_framebuffer do it for us on first console
  * and we do not want currcon == 0 for subsequent framebuffers */
 
-	ACCESS_FBINFO(fbcon).device = &ACCESS_FBINFO(pcidev)->dev;
-	if (register_framebuffer(&ACCESS_FBINFO(fbcon)) < 0) {
+	minfo->fbcon.device = &minfo->pcidev->dev;
+	if (register_framebuffer(&minfo->fbcon) < 0) {
 		goto failVideoIO;
 	}
 	printk("fb%d: %s frame buffer device\n",
-	       ACCESS_FBINFO(fbcon.node), ACCESS_FBINFO(fbcon.fix.id));
+	       minfo->fbcon.node, minfo->fbcon.fix.id);
 
 	/* there is no console on this fb... but we have to initialize hardware
 	 * until someone tells me what is proper thing to do */
-	if (!ACCESS_FBINFO(initialized)) {
+	if (!minfo->initialized) {
 		printk(KERN_INFO "fb%d: initializing hardware\n",
-		       ACCESS_FBINFO(fbcon.node));
+		       minfo->fbcon.node);
 		/* We have to use FB_ACTIVATE_FORCE, as we had to put vesafb_defined to the fbcon.var
 		 * already before, so register_framebuffer works correctly. */
 		vesafb_defined.activate |= FB_ACTIVATE_FORCE;
-		fb_set_var(&ACCESS_FBINFO(fbcon), &vesafb_defined);
+		fb_set_var(&minfo->fbcon, &vesafb_defined);
 	}
 
 	return 0;
 failVideoIO:;
 	matroxfb_g450_shutdown(PMINFO2);
-	mga_iounmap(ACCESS_FBINFO(video.vbase));
+	mga_iounmap(minfo->video.vbase);
 failCtrlIO:;
-	mga_iounmap(ACCESS_FBINFO(mmio.vbase));
+	mga_iounmap(minfo->mmio.vbase);
 failVideoMR:;
-	release_mem_region(video_base_phys, ACCESS_FBINFO(video.len_maximum));
+	release_mem_region(video_base_phys, minfo->video.len_maximum);
 failCtrlMR:;
 	release_mem_region(ctrlptr_phys, 16384);
 fail:;
@@ -1971,7 +1971,7 @@ void matroxfb_unregister_driver(struct m
 static void matroxfb_register_device(struct matrox_fb_info* minfo) {
 	struct matroxfb_driver* drv;
 	int i = 0;
-	list_add(&ACCESS_FBINFO(next_fb), &matroxfb_list);
+	list_add(&minfo->next_fb, &matroxfb_list);
 	for (drv = matroxfb_driver_l(matroxfb_driver_list.next);
 	     drv != matroxfb_driver_l(&matroxfb_driver_list);
 	     drv = matroxfb_driver_l(drv->node.next)) {
@@ -1991,7 +1991,7 @@ static void matroxfb_register_device(str
 static void matroxfb_unregister_device(struct matrox_fb_info* minfo) {
 	int i;
 
-	list_del(&ACCESS_FBINFO(next_fb));
+	list_del(&minfo->next_fb);
 	for (i = 0; i < minfo->drivers_count; i++) {
 		struct matroxfb_driver* drv = minfo->drivers[i];
 
@@ -2033,51 +2033,51 @@ static int matroxfb_probe(struct pci_dev
 	minfo = kmalloc(sizeof(*minfo), GFP_KERNEL);
 	if (!minfo)
 		return -1;
-	memset(MINFO, 0, sizeof(*MINFO));
+	memset(minfo, 0, sizeof(*minfo));
 
-	ACCESS_FBINFO(pcidev) = pdev;
-	ACCESS_FBINFO(dead) = 0;
-	ACCESS_FBINFO(usecount) = 0;
-	ACCESS_FBINFO(userusecount) = 0;
+	minfo->pcidev = pdev;
+	minfo->dead = 0;
+	minfo->usecount = 0;
+	minfo->userusecount = 0;
 
-	pci_set_drvdata(pdev, MINFO);
+	pci_set_drvdata(pdev, minfo);
 	/* DEVFLAGS */
-	ACCESS_FBINFO(devflags.memtype) = memtype;
+	minfo->devflags.memtype = memtype;
 	if (memtype != -1)
 		noinit = 0;
 	if (cmd & PCI_COMMAND_MEMORY) {
-		ACCESS_FBINFO(devflags.novga) = novga;
-		ACCESS_FBINFO(devflags.nobios) = nobios;
-		ACCESS_FBINFO(devflags.noinit) = noinit;
+		minfo->devflags.novga = novga;
+		minfo->devflags.nobios = nobios;
+		minfo->devflags.noinit = noinit;
 		/* subsequent heads always needs initialization and must not enable BIOS */
 		novga = 1;
 		nobios = 1;
 		noinit = 0;
 	} else {
-		ACCESS_FBINFO(devflags.novga) = 1;
-		ACCESS_FBINFO(devflags.nobios) = 1;
-		ACCESS_FBINFO(devflags.noinit) = 0;
-	}
-
-	ACCESS_FBINFO(devflags.nopciretry) = no_pci_retry;
-	ACCESS_FBINFO(devflags.mga_24bpp_fix) = inv24;
-	ACCESS_FBINFO(devflags.precise_width) = option_precise_width;
-	ACCESS_FBINFO(devflags.sgram) = sgram;
-	ACCESS_FBINFO(capable.cross4MB) = cross4MB;
-
-	spin_lock_init(&ACCESS_FBINFO(lock.DAC));
-	spin_lock_init(&ACCESS_FBINFO(lock.accel));
-	init_rwsem(&ACCESS_FBINFO(crtc2.lock));
-	init_rwsem(&ACCESS_FBINFO(altout.lock));
-	mutex_init(&ACCESS_FBINFO(fbcon).mm_lock);
-	ACCESS_FBINFO(irq_flags) = 0;
-	init_waitqueue_head(&ACCESS_FBINFO(crtc1.vsync.wait));
-	init_waitqueue_head(&ACCESS_FBINFO(crtc2.vsync.wait));
-	ACCESS_FBINFO(crtc1.panpos) = -1;
+		minfo->devflags.novga = 1;
+		minfo->devflags.nobios = 1;
+		minfo->devflags.noinit = 0;
+	}
+
+	minfo->devflags.nopciretry = no_pci_retry;
+	minfo->devflags.mga_24bpp_fix = inv24;
+	minfo->devflags.precise_width = option_precise_width;
+	minfo->devflags.sgram = sgram;
+	minfo->capable.cross4MB = cross4MB;
+
+	spin_lock_init(&minfo->lock.DAC);
+	spin_lock_init(&minfo->lock.accel);
+	init_rwsem(&minfo->crtc2.lock);
+	init_rwsem(&minfo->altout.lock);
+	mutex_init(&minfo->fbcon.mm_lock);
+	minfo->irq_flags = 0;
+	init_waitqueue_head(&minfo->crtc1.vsync.wait);
+	init_waitqueue_head(&minfo->crtc2.vsync.wait);
+	minfo->crtc1.panpos = -1;
 
 	err = initMatrox2(PMINFO b);
 	if (!err) {
-		matroxfb_register_device(MINFO);
+		matroxfb_register_device(minfo);
 		return 0;
 	}
 	kfree(minfo);
diff -puN drivers/video/matrox/matroxfb_base.h~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_base.h
--- a/drivers/video/matrox/matroxfb_base.h~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_base.h
@@ -524,11 +524,6 @@ struct matrox_fb_info {
 
 #define info2minfo(info) container_of(info, struct matrox_fb_info, fbcon)
 
-#define ACCESS_FBINFO2(info, x) (info->x)
-#define ACCESS_FBINFO(x) ACCESS_FBINFO2(minfo,x)
-
-#define MINFO minfo
-
 #define WPMINFO2 struct matrox_fb_info* minfo
 #define WPMINFO  WPMINFO2 ,
 #define CPMINFO2 const struct matrox_fb_info* minfo
@@ -707,11 +702,11 @@ void matroxfb_unregister_driver(struct m
 #endif
 #endif
 
-#define mga_inb(addr)		mga_readb(ACCESS_FBINFO(mmio.vbase), (addr))
-#define mga_inl(addr)		mga_readl(ACCESS_FBINFO(mmio.vbase), (addr))
-#define mga_outb(addr,val)	mga_writeb(ACCESS_FBINFO(mmio.vbase), (addr), (val))
-#define mga_outw(addr,val)	mga_writew(ACCESS_FBINFO(mmio.vbase), (addr), (val))
-#define mga_outl(addr,val)	mga_writel(ACCESS_FBINFO(mmio.vbase), (addr), (val))
+#define mga_inb(addr)		mga_readb(minfo->mmio.vbase, (addr))
+#define mga_inl(addr)		mga_readl(minfo->mmio.vbase, (addr))
+#define mga_outb(addr,val)	mga_writeb(minfo->mmio.vbase, (addr), (val))
+#define mga_outw(addr,val)	mga_writew(minfo->mmio.vbase, (addr), (val))
+#define mga_outl(addr,val)	mga_writel(minfo->mmio.vbase, (addr), (val))
 #define mga_readr(port,idx)	(mga_outb((port),(idx)), mga_inb((port)+1))
 #define mga_setr(addr,port,val)	mga_outw(addr, ((val)<<8) | (port))
 
@@ -730,10 +725,10 @@ void matroxfb_unregister_driver(struct m
 #define isMilleniumII(x) (0)
 #endif
 
-#define matroxfb_DAC_lock()                   spin_lock(&ACCESS_FBINFO(lock.DAC))
-#define matroxfb_DAC_unlock()                 spin_unlock(&ACCESS_FBINFO(lock.DAC))
-#define matroxfb_DAC_lock_irqsave(flags)      spin_lock_irqsave(&ACCESS_FBINFO(lock.DAC),flags)
-#define matroxfb_DAC_unlock_irqrestore(flags) spin_unlock_irqrestore(&ACCESS_FBINFO(lock.DAC),flags)
+#define matroxfb_DAC_lock()                   spin_lock(&minfo->lock.DAC)
+#define matroxfb_DAC_unlock()                 spin_unlock(&minfo->lock.DAC)
+#define matroxfb_DAC_lock_irqsave(flags)      spin_lock_irqsave(&minfo->lock.DAC, flags)
+#define matroxfb_DAC_unlock_irqrestore(flags) spin_unlock_irqrestore(&minfo->lock.DAC, flags)
 extern void matroxfb_DAC_out(CPMINFO int reg, int val);
 extern int matroxfb_DAC_in(CPMINFO int reg);
 extern void matroxfb_var2my(struct fb_var_screeninfo* fvsi, struct my_timming* mt);
@@ -741,8 +736,8 @@ extern int matroxfb_wait_for_sync(WPMINF
 extern int matroxfb_enable_irq(WPMINFO int reenable);
 
 #ifdef MATROXFB_USE_SPINLOCKS
-#define CRITBEGIN  spin_lock_irqsave(&ACCESS_FBINFO(lock.accel), critflags);
-#define CRITEND	   spin_unlock_irqrestore(&ACCESS_FBINFO(lock.accel), critflags);
+#define CRITBEGIN  spin_lock_irqsave(&minfo->lock.accel, critflags);
+#define CRITEND	   spin_unlock_irqrestore(&minfo->lock.accel, critflags);
 #define CRITFLAGS  unsigned long critflags;
 #else
 #define CRITBEGIN
diff -puN drivers/video/matrox/matroxfb_crtc2.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -81,11 +81,11 @@ static void matroxfb_dh_restore(struct m
 	}
 	tmp |= 0x00000001;	/* enable CRTC2 */
 	datactl = 0;
-	if (ACCESS_FBINFO(outputs[1]).src == MATROXFB_SRC_CRTC2) {
-		if (ACCESS_FBINFO(devflags.g450dac)) {
+	if (minfo->outputs[1].src == MATROXFB_SRC_CRTC2) {
+		if (minfo->devflags.g450dac) {
 			tmp |= 0x00000006; /* source from secondary pixel PLL */
 			/* no vidrst when in monitor mode */
-			if (ACCESS_FBINFO(outputs[1]).mode != MATROXFB_OUTPUT_MODE_MONITOR) {
+			if (minfo->outputs[1].mode != MATROXFB_OUTPUT_MODE_MONITOR) {
 				tmp |=  0xC0001000; /* Enable H/V vidrst */
 			}
 		} else {
@@ -93,11 +93,11 @@ static void matroxfb_dh_restore(struct m
 			tmp |= 0xC0000000; /* enable vvidrst & hvidrst */
 			/* MGA TVO is our clock source */
 		}
-	} else if (ACCESS_FBINFO(outputs[0]).src == MATROXFB_SRC_CRTC2) {
+	} else if (minfo->outputs[0].src == MATROXFB_SRC_CRTC2) {
 		tmp |= 0x00000004; /* source from pixclock */
 		/* PIXPLL is our clock source */
 	}
-	if (ACCESS_FBINFO(outputs[0]).src == MATROXFB_SRC_CRTC2) {
+	if (minfo->outputs[0].src == MATROXFB_SRC_CRTC2) {
 		tmp |= 0x00100000;	/* connect CRTC2 to DAC */
 	}
 	if (mt->interlaced) {
@@ -146,7 +146,7 @@ static void matroxfb_dh_restore(struct m
 		}
 	}
 	mga_outl(0x3C10, tmp);
-	ACCESS_FBINFO(hw).crtc2.ctl = tmp;
+	minfo->hw.crtc2.ctl = tmp;
 
 	tmp = mt->VDisplay << 16;	/* line compare */
 	if (mt->sync & FB_SYNC_HOR_HIGH_ACT)
@@ -160,7 +160,7 @@ static void matroxfb_dh_disable(struct m
 	MINFO_FROM(m2info->primary_dev);
 
 	mga_outl(0x3C10, 0x00000004);	/* disable CRTC2, CRTC1->DAC1, PLL as clock source */
-	ACCESS_FBINFO(hw).crtc2.ctl = 0x00000004;
+	minfo->hw.crtc2.ctl = 0x00000004;
 }
 
 static void matroxfb_dh_pan_var(struct matroxfb_dh_fb_info* m2info,
@@ -262,13 +262,13 @@ static int matroxfb_dh_open(struct fb_in
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	MINFO_FROM(m2info->primary_dev);
 
-	if (MINFO) {
+	if (minfo) {
 		int err;
 
-		if (ACCESS_FBINFO(dead)) {
+		if (minfo->dead) {
 			return -ENXIO;
 		}
-		err = ACCESS_FBINFO(fbops).fb_open(&ACCESS_FBINFO(fbcon), user);
+		err = minfo->fbops.fb_open(&minfo->fbcon, user);
 		if (err) {
 			return err;
 		}
@@ -282,8 +282,8 @@ static int matroxfb_dh_release(struct fb
 	int err = 0;
 	MINFO_FROM(m2info->primary_dev);
 
-	if (MINFO) {
-		err = ACCESS_FBINFO(fbops).fb_release(&ACCESS_FBINFO(fbcon), user);
+	if (minfo) {
+		err = minfo->fbops.fb_release(&minfo->fbcon, user);
 	}
 	return err;
 #undef m2info
@@ -352,18 +352,18 @@ static int matroxfb_dh_set_par(struct fb
 		pos = (m2info->fbcon.var.yoffset * m2info->fbcon.var.xres_virtual + m2info->fbcon.var.xoffset) * m2info->fbcon.var.bits_per_pixel >> 3;
 		pos += m2info->video.offbase;
 		cnt = 0;
-		down_read(&ACCESS_FBINFO(altout).lock);
+		down_read(&minfo->altout.lock);
 		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-			if (ACCESS_FBINFO(outputs[out]).src == MATROXFB_SRC_CRTC2) {
+			if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2) {
 				cnt++;
-				if (ACCESS_FBINFO(outputs[out]).output->compute) {
-					ACCESS_FBINFO(outputs[out]).output->compute(ACCESS_FBINFO(outputs[out]).data, &mt);
+				if (minfo->outputs[out].output->compute) {
+					minfo->outputs[out].output->compute(minfo->outputs[out].data, &mt);
 				}
 			}
 		}
-		ACCESS_FBINFO(crtc2).pixclock = mt.pixclock;
-		ACCESS_FBINFO(crtc2).mnp = mt.mnp;
-		up_read(&ACCESS_FBINFO(altout).lock);
+		minfo->crtc2.pixclock = mt.pixclock;
+		minfo->crtc2.mnp = mt.mnp;
+		up_read(&minfo->altout.lock);
 		if (cnt) {
 			matroxfb_dh_restore(m2info, &mt, mode, pos);
 		} else {
@@ -371,20 +371,20 @@ static int matroxfb_dh_set_par(struct fb
 		}
 		DAC1064_global_init(PMINFO2);
 		DAC1064_global_restore(PMINFO2);
-		down_read(&ACCESS_FBINFO(altout).lock);
+		down_read(&minfo->altout.lock);
 		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-			if (ACCESS_FBINFO(outputs[out]).src == MATROXFB_SRC_CRTC2 &&
-			    ACCESS_FBINFO(outputs[out]).output->program) {
-				ACCESS_FBINFO(outputs[out]).output->program(ACCESS_FBINFO(outputs[out]).data);
+			if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2 &&
+			    minfo->outputs[out].output->program) {
+				minfo->outputs[out].output->program(minfo->outputs[out].data);
 			}
 		}
 		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-			if (ACCESS_FBINFO(outputs[out]).src == MATROXFB_SRC_CRTC2 &&
-			    ACCESS_FBINFO(outputs[out]).output->start) {
-				ACCESS_FBINFO(outputs[out]).output->start(ACCESS_FBINFO(outputs[out]).data);
+			if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2 &&
+			    minfo->outputs[out].output->start) {
+				minfo->outputs[out].output->start(minfo->outputs[out].data);
 			}
 		}
-		up_read(&ACCESS_FBINFO(altout).lock);
+		up_read(&minfo->altout.lock);
 	}
 	m2info->initialized = 1;
 	return 0;
@@ -409,11 +409,11 @@ static int matroxfb_dh_get_vblank(const 
 	/* compatibility stuff */
 	if (vblank->vcount >= m2info->fbcon.var.yres)
 		vblank->flags |= FB_VBLANK_VBLANKING;
-        if (test_bit(0, &ACCESS_FBINFO(irq_flags))) {
+	if (test_bit(0, &minfo->irq_flags)) {
                 vblank->flags |= FB_VBLANK_HAVE_COUNT;
                 /* Only one writer, aligned int value...
                    it should work without lock and without atomic_t */
-                vblank->count = ACCESS_FBINFO(crtc2).vsync.cnt;
+		vblank->count = minfo->crtc2.vsync.cnt;
         }
 	return 0;
 }
@@ -455,7 +455,7 @@ static int matroxfb_dh_ioctl(struct fb_i
 		case MATROXFB_GET_OUTPUT_MODE:
 		case MATROXFB_GET_ALL_OUTPUTS:
 			{
-				return ACCESS_FBINFO(fbcon.fbops)->fb_ioctl(&ACCESS_FBINFO(fbcon), cmd, arg);
+				return minfo->fbcon.fbops->fb_ioctl(&minfo->fbcon, cmd, arg);
 			}
 		case MATROXFB_SET_OUTPUT_CONNECTION:
 			{
@@ -469,9 +469,9 @@ static int matroxfb_dh_ioctl(struct fb_i
 					if (tmp & (1 << out)) {
 						if (out >= MATROXFB_MAX_OUTPUTS)
 							return -ENXIO;
-						if (!ACCESS_FBINFO(outputs[out]).output)
+						if (!minfo->outputs[out].output)
 							return -ENXIO;
-						switch (ACCESS_FBINFO(outputs[out]).src) {
+						switch (minfo->outputs[out].src) {
 							case MATROXFB_SRC_NONE:
 							case MATROXFB_SRC_CRTC2:
 								break;
@@ -480,22 +480,22 @@ static int matroxfb_dh_ioctl(struct fb_i
 						}
 					}
 				}
-				if (ACCESS_FBINFO(devflags.panellink)) {
+				if (minfo->devflags.panellink) {
 					if (tmp & MATROXFB_OUTPUT_CONN_DFP)
 						return -EINVAL;
-					if ((ACCESS_FBINFO(outputs[2]).src == MATROXFB_SRC_CRTC1) && tmp)
+					if ((minfo->outputs[2].src == MATROXFB_SRC_CRTC1) && tmp)
 						return -EBUSY;
 				}
 				changes = 0;
 				for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
 					if (tmp & (1 << out)) {
-						if (ACCESS_FBINFO(outputs[out]).src != MATROXFB_SRC_CRTC2) {
+						if (minfo->outputs[out].src != MATROXFB_SRC_CRTC2) {
 							changes = 1;
-							ACCESS_FBINFO(outputs[out]).src = MATROXFB_SRC_CRTC2;
+							minfo->outputs[out].src = MATROXFB_SRC_CRTC2;
 						}
-					} else if (ACCESS_FBINFO(outputs[out]).src == MATROXFB_SRC_CRTC2) {
+					} else if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2) {
 						changes = 1;
-						ACCESS_FBINFO(outputs[out]).src = MATROXFB_SRC_NONE;
+						minfo->outputs[out].src = MATROXFB_SRC_NONE;
 					}
 				}
 				if (!changes)
@@ -509,7 +509,7 @@ static int matroxfb_dh_ioctl(struct fb_i
 				int out;
 
 				for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-					if (ACCESS_FBINFO(outputs[out]).src == MATROXFB_SRC_CRTC2) {
+					if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2) {
 						conn |= 1 << out;
 					}
 				}
@@ -523,8 +523,8 @@ static int matroxfb_dh_ioctl(struct fb_i
 				int out;
 
 				for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-					if (ACCESS_FBINFO(outputs[out]).output) {
-						switch (ACCESS_FBINFO(outputs[out]).src) {
+					if (minfo->outputs[out].output) {
+						switch (minfo->outputs[out].src) {
 							case MATROXFB_SRC_NONE:
 							case MATROXFB_SRC_CRTC2:
 								tmp |= 1 << out;
@@ -532,9 +532,9 @@ static int matroxfb_dh_ioctl(struct fb_i
 						}
 					}
 				}
-				if (ACCESS_FBINFO(devflags.panellink)) {
+				if (minfo->devflags.panellink) {
 					tmp &= ~MATROXFB_OUTPUT_CONN_DFP;
-					if (ACCESS_FBINFO(outputs[2]).src == MATROXFB_SRC_CRTC1) {
+					if (minfo->outputs[2].src == MATROXFB_SRC_CRTC1) {
 						tmp = 0;
 					}
 				}
@@ -611,21 +611,21 @@ static int matroxfb_dh_regit(CPMINFO str
 	if (mem < 64*1024)
 		mem *= 1024;
 	mem &= ~0x00000FFF;	/* PAGE_MASK? */
-	if (ACCESS_FBINFO(video.len_usable) + mem <= ACCESS_FBINFO(video.len))
-		m2info->video.offbase = ACCESS_FBINFO(video.len) - mem;
-	else if (ACCESS_FBINFO(video.len) < mem) {
+	if (minfo->video.len_usable + mem <= minfo->video.len)
+		m2info->video.offbase = minfo->video.len - mem;
+	else if (minfo->video.len < mem) {
 		return -ENOMEM;
 	} else { /* check yres on first head... */
 		m2info->video.borrowed = mem;
-		ACCESS_FBINFO(video.len_usable) -= mem;
-		m2info->video.offbase = ACCESS_FBINFO(video.len_usable);
+		minfo->video.len_usable -= mem;
+		m2info->video.offbase = minfo->video.len_usable;
 	}
-	m2info->video.base = ACCESS_FBINFO(video.base) + m2info->video.offbase;
+	m2info->video.base = minfo->video.base + m2info->video.offbase;
 	m2info->video.len = m2info->video.len_usable = m2info->video.len_maximum = mem;
-	m2info->video.vbase.vaddr = vaddr_va(ACCESS_FBINFO(video.vbase)) + m2info->video.offbase;
-	m2info->mmio.base = ACCESS_FBINFO(mmio.base);
-	m2info->mmio.vbase = ACCESS_FBINFO(mmio.vbase);
-	m2info->mmio.len = ACCESS_FBINFO(mmio.len);
+	m2info->video.vbase.vaddr = vaddr_va(minfo->video.vbase) + m2info->video.offbase;
+	m2info->mmio.base = minfo->mmio.base;
+	m2info->mmio.vbase = minfo->mmio.vbase;
+	m2info->mmio.len = minfo->mmio.len;
 
 	matroxfb_dh_init_fix(m2info);
 	if (register_framebuffer(&m2info->fbcon)) {
@@ -633,10 +633,10 @@ static int matroxfb_dh_regit(CPMINFO str
 	}
 	if (!m2info->initialized)
 		fb_set_var(&m2info->fbcon, &matroxfb_dh_defined);
-	down_write(&ACCESS_FBINFO(crtc2.lock));
-	oldcrtc2 = ACCESS_FBINFO(crtc2.info);
-	ACCESS_FBINFO(crtc2.info) = m2info;
-	up_write(&ACCESS_FBINFO(crtc2.lock));
+	down_write(&minfo->crtc2.lock);
+	oldcrtc2 = minfo->crtc2.info;
+	minfo->crtc2.info = m2info;
+	up_write(&minfo->crtc2.lock);
 	if (oldcrtc2) {
 		printk(KERN_ERR "matroxfb_crtc2: Internal consistency check failed: crtc2 already present: %p\n",
 			oldcrtc2);
@@ -654,7 +654,7 @@ static int matroxfb_dh_registerfb(struct
 		return -1;
 	}
 	printk(KERN_INFO "matroxfb_crtc2: secondary head of fb%u was registered as fb%u\n",
-		ACCESS_FBINFO(fbcon.node), m2info->fbcon.node);
+		minfo->fbcon.node, m2info->fbcon.node);
 	m2info->fbcon_registered = 1;
 	return 0;
 #undef minfo
@@ -666,11 +666,11 @@ static void matroxfb_dh_deregisterfb(str
 		int id;
 		struct matroxfb_dh_fb_info* crtc2;
 
-		down_write(&ACCESS_FBINFO(crtc2.lock));
-		crtc2 = ACCESS_FBINFO(crtc2.info);
+		down_write(&minfo->crtc2.lock);
+		crtc2 = minfo->crtc2.info;
 		if (crtc2 == m2info)
-			ACCESS_FBINFO(crtc2.info) = NULL;
-		up_write(&ACCESS_FBINFO(crtc2.lock));
+			minfo->crtc2.info = NULL;
+		up_write(&minfo->crtc2.lock);
 		if (crtc2 != m2info) {
 			printk(KERN_ERR "matroxfb_crtc2: Internal consistency check failed: crtc2 mismatch at unload: %p != %p\n",
 				crtc2, m2info);
@@ -680,7 +680,7 @@ static void matroxfb_dh_deregisterfb(str
 		id = m2info->fbcon.node;
 		unregister_framebuffer(&m2info->fbcon);
 		/* return memory back to primary head */
-		ACCESS_FBINFO(video.len_usable) += m2info->video.borrowed;
+		minfo->video.len_usable += m2info->video.borrowed;
 		printk(KERN_INFO "matroxfb_crtc2: fb%u unregistered\n", id);
 		m2info->fbcon_registered = 0;
 	}
@@ -691,14 +691,14 @@ static void* matroxfb_crtc2_probe(struct
 	struct matroxfb_dh_fb_info* m2info;
 
 	/* hardware is CRTC2 incapable... */
-	if (!ACCESS_FBINFO(devflags.crtc2))
+	if (!minfo->devflags.crtc2)
 		return NULL;
 	m2info = kzalloc(sizeof(*m2info), GFP_KERNEL);
 	if (!m2info) {
 		printk(KERN_ERR "matroxfb_crtc2: Not enough memory for CRTC2 control structs\n");
 		return NULL;
 	}
-	m2info->primary_dev = MINFO;
+	m2info->primary_dev = minfo;
 	if (matroxfb_dh_registerfb(m2info)) {
 		kfree(m2info);
 		printk(KERN_ERR "matroxfb_crtc2: CRTC2 framebuffer failed to register\n");
diff -puN drivers/video/matrox/matroxfb_g450.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_g450.c
--- a/drivers/video/matrox/matroxfb_g450.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_g450.c
@@ -81,7 +81,7 @@ static int get_ctrl_id(__u32 v4l2_id) {
 }
 
 static inline int* get_ctrl_ptr(WPMINFO unsigned int idx) {
-	return (int*)((char*)MINFO + g450_controls[idx].control);
+	return (int*)((char*)minfo + g450_controls[idx].control);
 }
 
 static void tvo_fill_defaults(WPMINFO2) {
@@ -124,8 +124,8 @@ static void cve2_set_reg10(WPMINFO int r
 }
 
 static void g450_compute_bwlevel(CPMINFO int *bl, int *wl) {
-	const int b = ACCESS_FBINFO(altout.tvo_params.brightness) + BLMIN;
-	const int c = ACCESS_FBINFO(altout.tvo_params.contrast);
+	const int b = minfo->altout.tvo_params.brightness + BLMIN;
+	const int c = minfo->altout.tvo_params.contrast;
 
 	*bl = max(b - c, BLMIN);
 	*wl = min(b + c, WLMAX);
@@ -509,31 +509,31 @@ static void cve2_init_TV(WPMINFO const s
 static int matroxfb_g450_compute(void* md, struct my_timming* mt) {
 	MINFO_FROM(md);
 
-	dprintk(KERN_DEBUG "Computing, mode=%u\n", ACCESS_FBINFO(outputs[1]).mode);
+	dprintk(KERN_DEBUG "Computing, mode=%u\n", minfo->outputs[1].mode);
 
 	if (mt->crtc == MATROXFB_SRC_CRTC2 &&
-	    ACCESS_FBINFO(outputs[1]).mode != MATROXFB_OUTPUT_MODE_MONITOR) {
+	    minfo->outputs[1].mode != MATROXFB_OUTPUT_MODE_MONITOR) {
 		const struct output_desc* outd;
 
-		cve2_init_TVdata(ACCESS_FBINFO(outputs[1]).mode, &ACCESS_FBINFO(hw).maven, &outd);
+		cve2_init_TVdata(minfo->outputs[1].mode, &minfo->hw.maven, &outd);
 		{
 			int blacklevel, whitelevel;
 			g450_compute_bwlevel(PMINFO &blacklevel, &whitelevel);
-			ACCESS_FBINFO(hw).maven.regs[0x0E] = blacklevel >> 2;
-			ACCESS_FBINFO(hw).maven.regs[0x0F] = blacklevel & 3;
-			ACCESS_FBINFO(hw).maven.regs[0x1E] = whitelevel >> 2;
-			ACCESS_FBINFO(hw).maven.regs[0x1F] = whitelevel & 3;
+			minfo->hw.maven.regs[0x0E] = blacklevel >> 2;
+			minfo->hw.maven.regs[0x0F] = blacklevel & 3;
+			minfo->hw.maven.regs[0x1E] = whitelevel >> 2;
+			minfo->hw.maven.regs[0x1F] = whitelevel & 3;
 
-			ACCESS_FBINFO(hw).maven.regs[0x20] =
-			ACCESS_FBINFO(hw).maven.regs[0x22] = ACCESS_FBINFO(altout.tvo_params.saturation);
+			minfo->hw.maven.regs[0x20] =
+			minfo->hw.maven.regs[0x22] = minfo->altout.tvo_params.saturation;
 
-			ACCESS_FBINFO(hw).maven.regs[0x25] = ACCESS_FBINFO(altout.tvo_params.hue);
+			minfo->hw.maven.regs[0x25] = minfo->altout.tvo_params.hue;
 
-			if (ACCESS_FBINFO(altout.tvo_params.testout)) {
-				ACCESS_FBINFO(hw).maven.regs[0x05] |= 0x02;
+			if (minfo->altout.tvo_params.testout) {
+				minfo->hw.maven.regs[0x05] |= 0x02;
 			}
 		}
-		computeRegs(PMINFO &ACCESS_FBINFO(hw).maven, mt, outd);
+		computeRegs(PMINFO &minfo->hw.maven, mt, outd);
 	} else if (mt->mnp < 0) {
 		/* We must program clocks before CRTC2, otherwise interlaced mode
 		   startup may fail */
@@ -547,8 +547,8 @@ static int matroxfb_g450_compute(void* m
 static int matroxfb_g450_program(void* md) {
 	MINFO_FROM(md);
 	
-	if (ACCESS_FBINFO(outputs[1]).mode != MATROXFB_OUTPUT_MODE_MONITOR) {
-		cve2_init_TV(PMINFO &ACCESS_FBINFO(hw).maven);
+	if (minfo->outputs[1].mode != MATROXFB_OUTPUT_MODE_MONITOR) {
+		cve2_init_TV(PMINFO &minfo->hw.maven);
 	}
 	return 0;
 }
@@ -589,33 +589,33 @@ static struct matrox_altout matroxfb_g45
 };
 
 void matroxfb_g450_connect(WPMINFO2) {
-	if (ACCESS_FBINFO(devflags.g450dac)) {
-		down_write(&ACCESS_FBINFO(altout.lock));
+	if (minfo->devflags.g450dac) {
+		down_write(&minfo->altout.lock);
 		tvo_fill_defaults(PMINFO2);
-		ACCESS_FBINFO(outputs[1]).src = ACCESS_FBINFO(outputs[1]).default_src;
-		ACCESS_FBINFO(outputs[1]).data = MINFO;
-		ACCESS_FBINFO(outputs[1]).output = &matroxfb_g450_altout;
-		ACCESS_FBINFO(outputs[1]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
-		ACCESS_FBINFO(outputs[2]).src = ACCESS_FBINFO(outputs[2]).default_src;
-		ACCESS_FBINFO(outputs[2]).data = MINFO;
-		ACCESS_FBINFO(outputs[2]).output = &matroxfb_g450_dvi;
-		ACCESS_FBINFO(outputs[2]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
-		up_write(&ACCESS_FBINFO(altout.lock));
+		minfo->outputs[1].src = minfo->outputs[1].default_src;
+		minfo->outputs[1].data = minfo;
+		minfo->outputs[1].output = &matroxfb_g450_altout;
+		minfo->outputs[1].mode = MATROXFB_OUTPUT_MODE_MONITOR;
+		minfo->outputs[2].src = minfo->outputs[2].default_src;
+		minfo->outputs[2].data = minfo;
+		minfo->outputs[2].output = &matroxfb_g450_dvi;
+		minfo->outputs[2].mode = MATROXFB_OUTPUT_MODE_MONITOR;
+		up_write(&minfo->altout.lock);
 	}
 }
 
 void matroxfb_g450_shutdown(WPMINFO2) {
-	if (ACCESS_FBINFO(devflags.g450dac)) {
-		down_write(&ACCESS_FBINFO(altout.lock));
-		ACCESS_FBINFO(outputs[1]).src = MATROXFB_SRC_NONE;
-		ACCESS_FBINFO(outputs[1]).output = NULL;
-		ACCESS_FBINFO(outputs[1]).data = NULL;
-		ACCESS_FBINFO(outputs[1]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
-		ACCESS_FBINFO(outputs[2]).src = MATROXFB_SRC_NONE;
-		ACCESS_FBINFO(outputs[2]).output = NULL;
-		ACCESS_FBINFO(outputs[2]).data = NULL;
-		ACCESS_FBINFO(outputs[2]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
-		up_write(&ACCESS_FBINFO(altout.lock));
+	if (minfo->devflags.g450dac) {
+		down_write(&minfo->altout.lock);
+		minfo->outputs[1].src = MATROXFB_SRC_NONE;
+		minfo->outputs[1].output = NULL;
+		minfo->outputs[1].data = NULL;
+		minfo->outputs[1].mode = MATROXFB_OUTPUT_MODE_MONITOR;
+		minfo->outputs[2].src = MATROXFB_SRC_NONE;
+		minfo->outputs[2].output = NULL;
+		minfo->outputs[2].data = NULL;
+		minfo->outputs[2].mode = MATROXFB_OUTPUT_MODE_MONITOR;
+		up_write(&minfo->altout.lock);
 	}
 }
 
diff -puN drivers/video/matrox/matroxfb_maven.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_maven.c
--- a/drivers/video/matrox/matroxfb_maven.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_maven.c
@@ -460,7 +460,7 @@ static void maven_init_TVdata(const stru
 	}, MATROXFB_OUTPUT_MODE_NTSC, 525, 60 };
 	MINFO_FROM(md->primary_head);
 
-	if (ACCESS_FBINFO(outputs[1]).mode == MATROXFB_OUTPUT_MODE_PAL)
+	if (minfo->outputs[1].mode == MATROXFB_OUTPUT_MODE_PAL)
 		*data = palregs;
 	else
 		*data = ntscregs;
@@ -496,11 +496,11 @@ static void maven_init_TVdata(const stru
 	/* Set saturation */
 	{
 		data->regs[0x20] =
-		data->regs[0x22] = ACCESS_FBINFO(altout.tvo_params.saturation);
+		data->regs[0x22] = minfo->altout.tvo_params.saturation;
 	}
  
 	/* Set HUE */
-	data->regs[0x25] = ACCESS_FBINFO(altout.tvo_params.hue);
+	data->regs[0x25] = minfo->altout.tvo_params.hue;
 	return;
 }
 
@@ -743,7 +743,7 @@ static inline int maven_compute_timming(
 	unsigned int a, bv, c;
 	MINFO_FROM(md->primary_head);
 
-	m->mode = ACCESS_FBINFO(outputs[1]).mode;
+	m->mode = minfo->outputs[1].mode;
 	if (m->mode != MATROXFB_OUTPUT_MODE_MONITOR) {
 		unsigned int lmargin;
 		unsigned int umargin;
@@ -1132,7 +1132,7 @@ static int maven_get_control (struct mav
 static int maven_out_compute(void* md, struct my_timming* mt) {
 #define mdinfo ((struct maven_data*)md)
 #define minfo (mdinfo->primary_head)
-	return maven_compute_timming(md, mt, &ACCESS_FBINFO(hw).maven);
+	return maven_compute_timming(md, mt, &minfo->hw.maven);
 #undef minfo
 #undef mdinfo
 }
@@ -1140,7 +1140,7 @@ static int maven_out_compute(void* md, s
 static int maven_out_program(void* md) {
 #define mdinfo ((struct maven_data*)md)
 #define minfo (mdinfo->primary_head)
-	return maven_program_timming(md, &ACCESS_FBINFO(hw).maven);
+	return maven_program_timming(md, &minfo->hw.maven);
 #undef minfo
 #undef mdinfo
 }
@@ -1186,14 +1186,14 @@ static int maven_init_client(struct i2c_
 	struct maven_data* md = i2c_get_clientdata(clnt);
 	MINFO_FROM(container_of(clnt->adapter, struct i2c_bit_adapter, adapter)->minfo);
 
-	md->primary_head = MINFO;
+	md->primary_head = minfo;
 	md->client = clnt;
-	down_write(&ACCESS_FBINFO(altout.lock));
-	ACCESS_FBINFO(outputs[1]).output = &maven_altout;
-	ACCESS_FBINFO(outputs[1]).src = ACCESS_FBINFO(outputs[1]).default_src;
-	ACCESS_FBINFO(outputs[1]).data = md;
-	ACCESS_FBINFO(outputs[1]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
-	up_write(&ACCESS_FBINFO(altout.lock));
+	down_write(&minfo->altout.lock);
+	minfo->outputs[1].output = &maven_altout;
+	minfo->outputs[1].src = minfo->outputs[1].default_src;
+	minfo->outputs[1].data = md;
+	minfo->outputs[1].mode = MATROXFB_OUTPUT_MODE_MONITOR;
+	up_write(&minfo->altout.lock);
 	if (maven_get_reg(clnt, 0xB2) < 0x14) {
 		md->version = MGATVO_B;
 		/* Tweak some things for this old chip */
@@ -1220,12 +1220,12 @@ static int maven_shutdown_client(struct 
 	if (md->primary_head) {
 		MINFO_FROM(md->primary_head);
 
-		down_write(&ACCESS_FBINFO(altout.lock));
-		ACCESS_FBINFO(outputs[1]).src = MATROXFB_SRC_NONE;
-		ACCESS_FBINFO(outputs[1]).output = NULL;
-		ACCESS_FBINFO(outputs[1]).data = NULL;
-		ACCESS_FBINFO(outputs[1]).mode = MATROXFB_OUTPUT_MODE_MONITOR;
-		up_write(&ACCESS_FBINFO(altout.lock));
+		down_write(&minfo->altout.lock);
+		minfo->outputs[1].src = MATROXFB_SRC_NONE;
+		minfo->outputs[1].output = NULL;
+		minfo->outputs[1].data = NULL;
+		minfo->outputs[1].mode = MATROXFB_OUTPUT_MODE_MONITOR;
+		up_write(&minfo->altout.lock);
 		md->primary_head = NULL;
 	}
 	return 0;
diff -puN drivers/video/matrox/matroxfb_misc.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_misc.c
--- a/drivers/video/matrox/matroxfb_misc.c~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_misc.c
@@ -190,7 +190,7 @@ int matroxfb_vgaHWinit(WPMINFO struct my
 	unsigned int wd;
 	unsigned int divider;
 	int i;
-	struct matrox_hw_state * const hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state * const hw = &minfo->hw;
 
 	DBG(__func__)
 
@@ -240,7 +240,7 @@ int matroxfb_vgaHWinit(WPMINFO struct my
 	/* standard timmings are in 8pixels, but for interleaved we cannot */
 	/* do it for 4bpp (because of (4bpp >> 1(interleaved))/4 == 0) */
 	/* using 16 or more pixels per unit can save us */
-	divider = ACCESS_FBINFO(curr.final_bppShift);
+	divider = minfo->curr.final_bppShift;
 	while (divider & 3) {
 		hd >>= 1;
 		hs >>= 1;
@@ -270,7 +270,7 @@ int matroxfb_vgaHWinit(WPMINFO struct my
 	if (((ht & 0x07) == 0x06) || ((ht & 0x0F) == 0x04))
 		ht++;
 	hbe = ht;
-	wd = ACCESS_FBINFO(fbcon).var.xres_virtual * ACCESS_FBINFO(curr.final_bppShift) / 64;
+	wd = minfo->fbcon.var.xres_virtual * minfo->curr.final_bppShift / 64;
 
 	hw->CRTCEXT[0] = 0;
 	hw->CRTCEXT[5] = 0;
@@ -287,7 +287,7 @@ int matroxfb_vgaHWinit(WPMINFO struct my
 			  ((hs      & 0x100) >> 6) | /* sync start */
 			   (hbe     & 0x040);	 /* end hor. blanking */
 	/* FIXME: Enable vidrst only on G400, and only if TV-out is used */
-	if (ACCESS_FBINFO(outputs[1]).src == MATROXFB_SRC_CRTC1)
+	if (minfo->outputs[1].src == MATROXFB_SRC_CRTC1)
 		hw->CRTCEXT[1] |= 0x88;		/* enable horizontal and vertical vidrst */
 	hw->CRTCEXT[2] =  ((vt & 0xC00) >> 10) |
 			  ((vd & 0x400) >>  8) |	/* disp end */
@@ -333,7 +333,7 @@ int matroxfb_vgaHWinit(WPMINFO struct my
 
 void matroxfb_vgaHWrestore(WPMINFO2) {
 	int i;
-	struct matrox_hw_state * const hw = &ACCESS_FBINFO(hw);
+	struct matrox_hw_state * const hw = &minfo->hw;
 	CRITFLAGS
 
 	DBG(__func__)
@@ -533,98 +533,98 @@ static int parse_pins1(WPMINFO const str
 	if (get_unaligned_le16(bd->pins + 24)) {
 		maxdac = get_unaligned_le16(bd->pins + 24) * 10;
 	}
-	MINFO->limits.pixel.vcomax = maxdac;
-	MINFO->values.pll.system = get_unaligned_le16(bd->pins + 28) ?
+	minfo->limits.pixel.vcomax = maxdac;
+	minfo->values.pll.system = get_unaligned_le16(bd->pins + 28) ?
 		get_unaligned_le16(bd->pins + 28) * 10 : 50000;
 	/* ignore 4MB, 8MB, module clocks */
-	MINFO->features.pll.ref_freq = 14318;
-	MINFO->values.reg.mctlwtst	= 0x00030101;
+	minfo->features.pll.ref_freq = 14318;
+	minfo->values.reg.mctlwtst	= 0x00030101;
 	return 0;
 }
 
 static void default_pins1(WPMINFO2) {
 	/* Millennium */
-	MINFO->limits.pixel.vcomax	= 220000;
-	MINFO->values.pll.system	=  50000;
-	MINFO->features.pll.ref_freq	=  14318;
-	MINFO->values.reg.mctlwtst	= 0x00030101;
+	minfo->limits.pixel.vcomax	= 220000;
+	minfo->values.pll.system	=  50000;
+	minfo->features.pll.ref_freq	=  14318;
+	minfo->values.reg.mctlwtst	= 0x00030101;
 }
 
 static int parse_pins2(WPMINFO const struct matrox_bios* bd) {
-	MINFO->limits.pixel.vcomax	=
-	MINFO->limits.system.vcomax	= (bd->pins[41] == 0xFF) ? 230000 : ((bd->pins[41] + 100) * 1000);
-	MINFO->values.reg.mctlwtst	= ((bd->pins[51] & 0x01) ? 0x00000001 : 0) |
+	minfo->limits.pixel.vcomax	=
+	minfo->limits.system.vcomax	= (bd->pins[41] == 0xFF) ? 230000 : ((bd->pins[41] + 100) * 1000);
+	minfo->values.reg.mctlwtst	= ((bd->pins[51] & 0x01) ? 0x00000001 : 0) |
 					  ((bd->pins[51] & 0x02) ? 0x00000100 : 0) |
 					  ((bd->pins[51] & 0x04) ? 0x00010000 : 0) |
 					  ((bd->pins[51] & 0x08) ? 0x00020000 : 0);
-	MINFO->values.pll.system	= (bd->pins[43] == 0xFF) ? 50000 : ((bd->pins[43] + 100) * 1000);
-	MINFO->features.pll.ref_freq	= 14318;
+	minfo->values.pll.system	= (bd->pins[43] == 0xFF) ? 50000 : ((bd->pins[43] + 100) * 1000);
+	minfo->features.pll.ref_freq	= 14318;
 	return 0;
 }
 
 static void default_pins2(WPMINFO2) {
 	/* Millennium II, Mystique */
-	MINFO->limits.pixel.vcomax	=
-	MINFO->limits.system.vcomax	= 230000;
-	MINFO->values.reg.mctlwtst	= 0x00030101;
-	MINFO->values.pll.system	=  50000;
-	MINFO->features.pll.ref_freq	=  14318;
+	minfo->limits.pixel.vcomax	=
+	minfo->limits.system.vcomax	= 230000;
+	minfo->values.reg.mctlwtst	= 0x00030101;
+	minfo->values.pll.system	=  50000;
+	minfo->features.pll.ref_freq	=  14318;
 }
 
 static int parse_pins3(WPMINFO const struct matrox_bios* bd) {
-	MINFO->limits.pixel.vcomax	=
-	MINFO->limits.system.vcomax	= (bd->pins[36] == 0xFF) ? 230000			: ((bd->pins[36] + 100) * 1000);
-	MINFO->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 48) == 0xFFFFFFFF ?
+	minfo->limits.pixel.vcomax	=
+	minfo->limits.system.vcomax	= (bd->pins[36] == 0xFF) ? 230000			: ((bd->pins[36] + 100) * 1000);
+	minfo->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 48) == 0xFFFFFFFF ?
 		0x01250A21 : get_unaligned_le32(bd->pins + 48);
 	/* memory config */
-	MINFO->values.reg.memrdbk	= ((bd->pins[57] << 21) & 0x1E000000) |
+	minfo->values.reg.memrdbk	= ((bd->pins[57] << 21) & 0x1E000000) |
 					  ((bd->pins[57] << 22) & 0x00C00000) |
 					  ((bd->pins[56] <<  1) & 0x000001E0) |
 					  ( bd->pins[56]        & 0x0000000F);
-	MINFO->values.reg.opt		= (bd->pins[54] & 7) << 10;
-	MINFO->values.reg.opt2		= bd->pins[58] << 12;
-	MINFO->features.pll.ref_freq	= (bd->pins[52] & 0x20) ? 14318 : 27000;
+	minfo->values.reg.opt		= (bd->pins[54] & 7) << 10;
+	minfo->values.reg.opt2		= bd->pins[58] << 12;
+	minfo->features.pll.ref_freq	= (bd->pins[52] & 0x20) ? 14318 : 27000;
 	return 0;
 }
 
 static void default_pins3(WPMINFO2) {
 	/* G100, G200 */
-	MINFO->limits.pixel.vcomax	=
-	MINFO->limits.system.vcomax	= 230000;
-	MINFO->values.reg.mctlwtst	= 0x01250A21;
-	MINFO->values.reg.memrdbk	= 0x00000000;
-	MINFO->values.reg.opt		= 0x00000C00;
-	MINFO->values.reg.opt2		= 0x00000000;
-	MINFO->features.pll.ref_freq	=  27000;
+	minfo->limits.pixel.vcomax	=
+	minfo->limits.system.vcomax	= 230000;
+	minfo->values.reg.mctlwtst	= 0x01250A21;
+	minfo->values.reg.memrdbk	= 0x00000000;
+	minfo->values.reg.opt		= 0x00000C00;
+	minfo->values.reg.opt2		= 0x00000000;
+	minfo->features.pll.ref_freq	=  27000;
 }
 
 static int parse_pins4(WPMINFO const struct matrox_bios* bd) {
-	MINFO->limits.pixel.vcomax	= (bd->pins[ 39] == 0xFF) ? 230000			: bd->pins[ 39] * 4000;
-	MINFO->limits.system.vcomax	= (bd->pins[ 38] == 0xFF) ? MINFO->limits.pixel.vcomax	: bd->pins[ 38] * 4000;
-	MINFO->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 71);
-	MINFO->values.reg.memrdbk	= ((bd->pins[87] << 21) & 0x1E000000) |
+	minfo->limits.pixel.vcomax	= (bd->pins[ 39] == 0xFF) ? 230000			: bd->pins[ 39] * 4000;
+	minfo->limits.system.vcomax	= (bd->pins[ 38] == 0xFF) ? minfo->limits.pixel.vcomax	: bd->pins[ 38] * 4000;
+	minfo->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 71);
+	minfo->values.reg.memrdbk	= ((bd->pins[87] << 21) & 0x1E000000) |
 					  ((bd->pins[87] << 22) & 0x00C00000) |
 					  ((bd->pins[86] <<  1) & 0x000001E0) |
 					  ( bd->pins[86]        & 0x0000000F);
-	MINFO->values.reg.opt		= ((bd->pins[53] << 15) & 0x00400000) |
+	minfo->values.reg.opt		= ((bd->pins[53] << 15) & 0x00400000) |
 					  ((bd->pins[53] << 22) & 0x10000000) |
 					  ((bd->pins[53] <<  7) & 0x00001C00);
-	MINFO->values.reg.opt3		= get_unaligned_le32(bd->pins + 67);
-	MINFO->values.pll.system	= (bd->pins[ 65] == 0xFF) ? 200000 			: bd->pins[ 65] * 4000;
-	MINFO->features.pll.ref_freq	= (bd->pins[ 92] & 0x01) ? 14318 : 27000;
+	minfo->values.reg.opt3		= get_unaligned_le32(bd->pins + 67);
+	minfo->values.pll.system	= (bd->pins[ 65] == 0xFF) ? 200000 			: bd->pins[ 65] * 4000;
+	minfo->features.pll.ref_freq	= (bd->pins[ 92] & 0x01) ? 14318 : 27000;
 	return 0;
 }
 
 static void default_pins4(WPMINFO2) {
 	/* G400 */
-	MINFO->limits.pixel.vcomax	=
-	MINFO->limits.system.vcomax	= 252000;
-	MINFO->values.reg.mctlwtst	= 0x04A450A1;
-	MINFO->values.reg.memrdbk	= 0x000000E7;
-	MINFO->values.reg.opt		= 0x10000400;
-	MINFO->values.reg.opt3		= 0x0190A419;
-	MINFO->values.pll.system	= 200000;
-	MINFO->features.pll.ref_freq	= 27000;
+	minfo->limits.pixel.vcomax	=
+	minfo->limits.system.vcomax	= 252000;
+	minfo->values.reg.mctlwtst	= 0x04A450A1;
+	minfo->values.reg.memrdbk	= 0x000000E7;
+	minfo->values.reg.opt		= 0x10000400;
+	minfo->values.reg.opt3		= 0x0190A419;
+	minfo->values.pll.system	= 200000;
+	minfo->features.pll.ref_freq	= 27000;
 }
 
 static int parse_pins5(WPMINFO const struct matrox_bios* bd) {
@@ -632,65 +632,65 @@ static int parse_pins5(WPMINFO const str
 	
 	mult = bd->pins[4]?8000:6000;
 	
-	MINFO->limits.pixel.vcomax	= (bd->pins[ 38] == 0xFF) ? 600000			: bd->pins[ 38] * mult;
-	MINFO->limits.system.vcomax	= (bd->pins[ 36] == 0xFF) ? MINFO->limits.pixel.vcomax	: bd->pins[ 36] * mult;
-	MINFO->limits.video.vcomax	= (bd->pins[ 37] == 0xFF) ? MINFO->limits.system.vcomax	: bd->pins[ 37] * mult;
-	MINFO->limits.pixel.vcomin	= (bd->pins[123] == 0xFF) ? 256000			: bd->pins[123] * mult;
-	MINFO->limits.system.vcomin	= (bd->pins[121] == 0xFF) ? MINFO->limits.pixel.vcomin	: bd->pins[121] * mult;
-	MINFO->limits.video.vcomin	= (bd->pins[122] == 0xFF) ? MINFO->limits.system.vcomin	: bd->pins[122] * mult;
-	MINFO->values.pll.system	=
-	MINFO->values.pll.video		= (bd->pins[ 92] == 0xFF) ? 284000			: bd->pins[ 92] * 4000;
-	MINFO->values.reg.opt		= get_unaligned_le32(bd->pins + 48);
-	MINFO->values.reg.opt2		= get_unaligned_le32(bd->pins + 52);
-	MINFO->values.reg.opt3		= get_unaligned_le32(bd->pins + 94);
-	MINFO->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 98);
-	MINFO->values.reg.memmisc	= get_unaligned_le32(bd->pins + 102);
-	MINFO->values.reg.memrdbk	= get_unaligned_le32(bd->pins + 106);
-	MINFO->features.pll.ref_freq	= (bd->pins[110] & 0x01) ? 14318 : 27000;
-	MINFO->values.memory.ddr	= (bd->pins[114] & 0x60) == 0x20;
-	MINFO->values.memory.dll	= (bd->pins[115] & 0x02) != 0;
-	MINFO->values.memory.emrswen	= (bd->pins[115] & 0x01) != 0;
-	MINFO->values.reg.maccess	= MINFO->values.memory.emrswen ? 0x00004000 : 0x00000000;
+	minfo->limits.pixel.vcomax	= (bd->pins[ 38] == 0xFF) ? 600000			: bd->pins[ 38] * mult;
+	minfo->limits.system.vcomax	= (bd->pins[ 36] == 0xFF) ? minfo->limits.pixel.vcomax	: bd->pins[ 36] * mult;
+	minfo->limits.video.vcomax	= (bd->pins[ 37] == 0xFF) ? minfo->limits.system.vcomax	: bd->pins[ 37] * mult;
+	minfo->limits.pixel.vcomin	= (bd->pins[123] == 0xFF) ? 256000			: bd->pins[123] * mult;
+	minfo->limits.system.vcomin	= (bd->pins[121] == 0xFF) ? minfo->limits.pixel.vcomin	: bd->pins[121] * mult;
+	minfo->limits.video.vcomin	= (bd->pins[122] == 0xFF) ? minfo->limits.system.vcomin	: bd->pins[122] * mult;
+	minfo->values.pll.system	=
+	minfo->values.pll.video		= (bd->pins[ 92] == 0xFF) ? 284000			: bd->pins[ 92] * 4000;
+	minfo->values.reg.opt		= get_unaligned_le32(bd->pins + 48);
+	minfo->values.reg.opt2		= get_unaligned_le32(bd->pins + 52);
+	minfo->values.reg.opt3		= get_unaligned_le32(bd->pins + 94);
+	minfo->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 98);
+	minfo->values.reg.memmisc	= get_unaligned_le32(bd->pins + 102);
+	minfo->values.reg.memrdbk	= get_unaligned_le32(bd->pins + 106);
+	minfo->features.pll.ref_freq	= (bd->pins[110] & 0x01) ? 14318 : 27000;
+	minfo->values.memory.ddr	= (bd->pins[114] & 0x60) == 0x20;
+	minfo->values.memory.dll	= (bd->pins[115] & 0x02) != 0;
+	minfo->values.memory.emrswen	= (bd->pins[115] & 0x01) != 0;
+	minfo->values.reg.maccess	= minfo->values.memory.emrswen ? 0x00004000 : 0x00000000;
 	if (bd->pins[115] & 4) {
-		MINFO->values.reg.mctlwtst_core = MINFO->values.reg.mctlwtst;
+		minfo->values.reg.mctlwtst_core = minfo->values.reg.mctlwtst;
 	} else {
 		u_int32_t wtst_xlat[] = { 0, 1, 5, 6, 7, 5, 2, 3 };
-		MINFO->values.reg.mctlwtst_core = (MINFO->values.reg.mctlwtst & ~7) |
-		                                  wtst_xlat[MINFO->values.reg.mctlwtst & 7];
+		minfo->values.reg.mctlwtst_core = (minfo->values.reg.mctlwtst & ~7) |
+						  wtst_xlat[minfo->values.reg.mctlwtst & 7];
 	}
-	MINFO->max_pixel_clock_panellink = bd->pins[47] * 4000;
+	minfo->max_pixel_clock_panellink = bd->pins[47] * 4000;
 	return 0;
 }
 
 static void default_pins5(WPMINFO2) {
 	/* Mine 16MB G450 with SDRAM DDR */
-	MINFO->limits.pixel.vcomax	=
-	MINFO->limits.system.vcomax	=
-	MINFO->limits.video.vcomax	= 600000;
-	MINFO->limits.pixel.vcomin	=
-	MINFO->limits.system.vcomin	=
-	MINFO->limits.video.vcomin	= 256000;
-	MINFO->values.pll.system	=
-	MINFO->values.pll.video		= 284000;
-	MINFO->values.reg.opt		= 0x404A1160;
-	MINFO->values.reg.opt2		= 0x0000AC00;
-	MINFO->values.reg.opt3		= 0x0090A409;
-	MINFO->values.reg.mctlwtst_core	=
-	MINFO->values.reg.mctlwtst	= 0x0C81462B;
-	MINFO->values.reg.memmisc	= 0x80000004;
-	MINFO->values.reg.memrdbk	= 0x01001103;
-	MINFO->features.pll.ref_freq	= 27000;
-	MINFO->values.memory.ddr	= 1;
-	MINFO->values.memory.dll	= 1;
-	MINFO->values.memory.emrswen	= 1;
-	MINFO->values.reg.maccess	= 0x00004000;
+	minfo->limits.pixel.vcomax	=
+	minfo->limits.system.vcomax	=
+	minfo->limits.video.vcomax	= 600000;
+	minfo->limits.pixel.vcomin	=
+	minfo->limits.system.vcomin	=
+	minfo->limits.video.vcomin	= 256000;
+	minfo->values.pll.system	=
+	minfo->values.pll.video		= 284000;
+	minfo->values.reg.opt		= 0x404A1160;
+	minfo->values.reg.opt2		= 0x0000AC00;
+	minfo->values.reg.opt3		= 0x0090A409;
+	minfo->values.reg.mctlwtst_core	=
+	minfo->values.reg.mctlwtst	= 0x0C81462B;
+	minfo->values.reg.memmisc	= 0x80000004;
+	minfo->values.reg.memrdbk	= 0x01001103;
+	minfo->features.pll.ref_freq	= 27000;
+	minfo->values.memory.ddr	= 1;
+	minfo->values.memory.dll	= 1;
+	minfo->values.memory.emrswen	= 1;
+	minfo->values.reg.maccess	= 0x00004000;
 }
 
 static int matroxfb_set_limits(WPMINFO const struct matrox_bios* bd) {
 	unsigned int pins_version;
 	static const unsigned int pinslen[] = { 64, 64, 64, 128, 128 };
 
-	switch (ACCESS_FBINFO(chip)) {
+	switch (minfo->chip) {
 		case MGA_2064:	default_pins1(PMINFO2); break;
 		case MGA_2164:
 		case MGA_1064:
@@ -743,19 +743,19 @@ void matroxfb_read_pins(WPMINFO2) {
 	u32 opt;
 	u32 biosbase;
 	u32 fbbase;
-	struct pci_dev* pdev = ACCESS_FBINFO(pcidev);
+	struct pci_dev *pdev = minfo->pcidev;
 	
-	memset(&ACCESS_FBINFO(bios), 0, sizeof(ACCESS_FBINFO(bios)));
+	memset(&minfo->bios, 0, sizeof(minfo->bios));
 	pci_read_config_dword(pdev, PCI_OPTION_REG, &opt);
 	pci_write_config_dword(pdev, PCI_OPTION_REG, opt | PCI_OPTION_ENABLE_ROM);
 	pci_read_config_dword(pdev, PCI_ROM_ADDRESS, &biosbase);
-	pci_read_config_dword(pdev, ACCESS_FBINFO(devflags.fbResource), &fbbase);
+	pci_read_config_dword(pdev, minfo->devflags.fbResource, &fbbase);
 	pci_write_config_dword(pdev, PCI_ROM_ADDRESS, (fbbase & PCI_ROM_ADDRESS_MASK) | PCI_ROM_ADDRESS_ENABLE);
-	parse_bios(vaddr_va(ACCESS_FBINFO(video).vbase), &ACCESS_FBINFO(bios));
+	parse_bios(vaddr_va(minfo->video.vbase), &minfo->bios);
 	pci_write_config_dword(pdev, PCI_ROM_ADDRESS, biosbase);
 	pci_write_config_dword(pdev, PCI_OPTION_REG, opt);
 #ifdef CONFIG_X86
-	if (!ACCESS_FBINFO(bios).bios_valid) {
+	if (!minfo->bios.bios_valid) {
 		unsigned char __iomem* b;
 
 		b = ioremap(0x000C0000, 65536);
@@ -769,15 +769,15 @@ void matroxfb_read_pins(WPMINFO2) {
 				printk(KERN_INFO "matroxfb: Legacy BIOS is for %04X:%04X, while this device is %04X:%04X\n",
 					ven, dev, pdev->vendor, pdev->device);
 			} else {
-				parse_bios(b, &ACCESS_FBINFO(bios));
+				parse_bios(b, &minfo->bios);
 			}
 			iounmap(b);
 		}
 	}
 #endif
-	matroxfb_set_limits(PMINFO &ACCESS_FBINFO(bios));
+	matroxfb_set_limits(PMINFO &minfo->bios);
 	printk(KERN_INFO "PInS memtype = %u\n",
-	       (ACCESS_FBINFO(values).reg.opt & 0x1C00) >> 10);
+	       (minfo->values.reg.opt & 0x1C00) >> 10);
 }
 
 EXPORT_SYMBOL(matroxfb_DAC_in);
diff -puN drivers/video/matrox/matroxfb_misc.h~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo drivers/video/matrox/matroxfb_misc.h
--- a/drivers/video/matrox/matroxfb_misc.h~matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo
+++ a/drivers/video/matrox/matroxfb_misc.h
@@ -8,7 +8,7 @@ int matroxfb_PLL_calcclock(const struct 
 	unsigned int* in, unsigned int* feed, unsigned int* post);
 static inline int PLL_calcclock(CPMINFO unsigned int freq, unsigned int fmax,
 		unsigned int* in, unsigned int* feed, unsigned int* post) {
-	return matroxfb_PLL_calcclock(&ACCESS_FBINFO(features.pll), freq, fmax, in, feed, post);
+	return matroxfb_PLL_calcclock(&minfo->features.pll, freq, fmax, in, feed, post);
 }
 
 int matroxfb_vgaHWinit(WPMINFO struct my_timming* m);
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
hwmon-driver-for-texas-instruments-amc6821-chip.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch


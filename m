From: akpm@osdl.org
Subject: - atyfb-rivafb-minor-fixes.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:01 -0800
Message-ID: <200612082013.kB8KD1Mf003055@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59421 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946723AbWLHUNK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     atyfb, rivafb: minor fixes
has been removed from the -mm tree.  Its filename was
     atyfb-rivafb-minor-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb, rivafb: minor fixes
From: Jeff Garzik <jeff@garzik.org>

aty128fb: return an error in the unlikely event that we cannot calculate
some key PLL info

rivafb:
* call CalcStateExt() directly, rather than via function pointers, since
  CalcStateExt() is the only value ever assigned to ->CalcStateExt().
* propagate error return back from CalcVClock() through callers

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/aty128fb.c |    5 +++++
 drivers/video/riva/fbdev.c   |   22 +++++++++++++++++-----
 drivers/video/riva/riva_hw.c |   10 +++++-----
 drivers/video/riva/riva_hw.h |   17 ++++++++++++++++-
 4 files changed, 43 insertions(+), 11 deletions(-)

diff -puN drivers/video/aty/aty128fb.c~atyfb-rivafb-minor-fixes drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~atyfb-rivafb-minor-fixes
+++ a/drivers/video/aty/aty128fb.c
@@ -1333,6 +1333,8 @@ static int aty128_var_to_pll(u32 period_
 	if (vclk * 12 < c.ppll_min)
 		vclk = c.ppll_min/12;
 
+	pll->post_divider = -1;
+
 	/* now, find an acceptable divider */
 	for (i = 0; i < sizeof(post_dividers); i++) {
 		output_freq = post_dividers[i] * vclk;
@@ -1342,6 +1344,9 @@ static int aty128_var_to_pll(u32 period_
 		}
 	}
 
+	if (pll->post_divider < 0)
+		return -EINVAL;
+
 	/* calculate feedback divider */
 	n = c.ref_divider * output_freq;
 	d = c.ref_clk;
diff -puN drivers/video/riva/fbdev.c~atyfb-rivafb-minor-fixes drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~atyfb-rivafb-minor-fixes
+++ a/drivers/video/riva/fbdev.c
@@ -740,11 +740,12 @@ static void riva_load_state(struct riva_
  * CALLED FROM:
  * rivafb_set_par()
  */
-static void riva_load_video_mode(struct fb_info *info)
+static int riva_load_video_mode(struct fb_info *info)
 {
 	int bpp, width, hDisplaySize, hDisplay, hStart,
 	    hEnd, hTotal, height, vDisplay, vStart, vEnd, vTotal, dotClock;
 	int hBlankStart, hBlankEnd, vBlankStart, vBlankEnd;
+	int rc;
 	struct riva_par *par = info->par;
 	struct riva_regs newmode;
 	
@@ -850,8 +851,10 @@ static void riva_load_video_mode(struct 
 	else
 		newmode.misc_output |= 0x80;	
 
-	par->riva.CalcStateExt(&par->riva, &newmode.ext, bpp, width,
-				  hDisplaySize, height, dotClock);
+	rc = CalcStateExt(&par->riva, &newmode.ext, bpp, width,
+			  hDisplaySize, height, dotClock);
+	if (rc)
+		goto out;
 
 	newmode.ext.scale = NV_RD32(par->riva.PRAMDAC, 0x00000848) &
 		0xfff000ff;
@@ -883,8 +886,12 @@ static void riva_load_video_mode(struct 
 	par->current_state = newmode;
 	riva_load_state(par, &par->current_state);
 	par->riva.LockUnlock(&par->riva, 0); /* important for HW cursor */
+
+out:
 	rivafb_blank(FB_BLANK_UNBLANK, info);
 	NVTRACE_LEAVE();
+
+	return rc;
 }
 
 static void riva_update_var(struct fb_var_screeninfo *var, struct fb_videomode *modedb)
@@ -1252,12 +1259,15 @@ static int rivafb_check_var(struct fb_va
 static int rivafb_set_par(struct fb_info *info)
 {
 	struct riva_par *par = info->par;
+	int rc = 0;
 
 	NVTRACE_ENTER();
 	/* vgaHWunlock() + riva unlock (0x7F) */
 	CRTCout(par, 0x11, 0xFF);
 	par->riva.LockUnlock(&par->riva, 0);
-	riva_load_video_mode(info);
+	rc = riva_load_video_mode(info);
+	if (rc)
+		goto out;
 	if(!(info->flags & FBINFO_HWACCEL_DISABLED))
 		riva_setup_accel(info);
 	
@@ -1270,8 +1280,10 @@ static int rivafb_set_par(struct fb_info
 		info->pixmap.scan_align = 1;
 	else
 		info->pixmap.scan_align = 4;
+
+out:
 	NVTRACE_LEAVE();
-	return 0;
+	return rc;
 }
 
 /**
diff -puN drivers/video/riva/riva_hw.c~atyfb-rivafb-minor-fixes drivers/video/riva/riva_hw.c
--- a/drivers/video/riva/riva_hw.c~atyfb-rivafb-minor-fixes
+++ a/drivers/video/riva/riva_hw.c
@@ -1227,7 +1227,7 @@ static int CalcVClock
  * Calculate extended mode parameters (SVGA) and save in a 
  * mode state structure.
  */
-static void CalcStateExt
+int CalcStateExt
 (
     RIVA_HW_INST  *chip,
     RIVA_HW_STATE *state,
@@ -1249,7 +1249,8 @@ static void CalcStateExt
      * Extended RIVA registers.
      */
     pixelDepth = (bpp + 1)/8;
-    CalcVClock(dotClock, &VClk, &m, &n, &p, chip);
+    if (!CalcVClock(dotClock, &VClk, &m, &n, &p, chip))
+    	return -EINVAL;
 
     switch (chip->Architecture)
     {
@@ -1327,6 +1328,8 @@ static void CalcStateExt
     state->pitch1   =
     state->pitch2   =
     state->pitch3   = pixelDepth * width;
+
+    return 0;
 }
 /*
  * Load fixed function state and pre-calculated/stored state.
@@ -2026,7 +2029,6 @@ static void nv3GetConfig
      */
     chip->Busy            = nv3Busy;
     chip->ShowHideCursor  = ShowHideCursor;
-    chip->CalcStateExt    = CalcStateExt;
     chip->LoadStateExt    = LoadStateExt;
     chip->UnloadStateExt  = UnloadStateExt;
     chip->SetStartAddress = SetStartAddress3;
@@ -2084,7 +2086,6 @@ static void nv4GetConfig
      */
     chip->Busy            = nv4Busy;
     chip->ShowHideCursor  = ShowHideCursor;
-    chip->CalcStateExt    = CalcStateExt;
     chip->LoadStateExt    = LoadStateExt;
     chip->UnloadStateExt  = UnloadStateExt;
     chip->SetStartAddress = SetStartAddress;
@@ -2186,7 +2187,6 @@ static void nv10GetConfig
      */
     chip->Busy            = nv10Busy;
     chip->ShowHideCursor  = ShowHideCursor;
-    chip->CalcStateExt    = CalcStateExt;
     chip->LoadStateExt    = LoadStateExt;
     chip->UnloadStateExt  = UnloadStateExt;
     chip->SetStartAddress = SetStartAddress;
diff -puN drivers/video/riva/riva_hw.h~atyfb-rivafb-minor-fixes drivers/video/riva/riva_hw.h
--- a/drivers/video/riva/riva_hw.h~atyfb-rivafb-minor-fixes
+++ a/drivers/video/riva/riva_hw.h
@@ -463,7 +463,6 @@ typedef struct _riva_hw_inst
      * Common chip functions.
      */
     int  (*Busy)(struct _riva_hw_inst *);
-    void (*CalcStateExt)(struct _riva_hw_inst *,struct _riva_hw_state *,int,int,int,int,int);
     void (*LoadStateExt)(struct _riva_hw_inst *,struct _riva_hw_state *);
     void (*UnloadStateExt)(struct _riva_hw_inst *,struct _riva_hw_state *);
     void (*SetStartAddress)(struct _riva_hw_inst *,U032);
@@ -528,6 +527,22 @@ typedef struct _riva_hw_state
     U032 pitch2;
     U032 pitch3;
 } RIVA_HW_STATE;
+
+/*
+ * function prototypes
+ */
+
+extern int CalcStateExt
+(
+    RIVA_HW_INST  *chip,
+    RIVA_HW_STATE *state,
+    int            bpp,
+    int            width,
+    int            hDisplaySize,
+    int            height,
+    int            dotClock
+);
+
 /*
  * External routines.
  */
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
atyfb-rivafb-minor-fixes.patch
git-acpi.patch
git-cpufreq.patch
drm-handle-pci_enable_device-failure.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
ata_piix-ide-mode-sata-patch-for-intel-ich9.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-mtd.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-force-media-setting-fix.patch
tulip-fix-shutdown-dma-irq-race.patch
git-ioat.patch
via-sb600-sata-quirk.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
usb-fix-ohcih-over-use-warnings.patch
md-conditionalize-some-code.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch


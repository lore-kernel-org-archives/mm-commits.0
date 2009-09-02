From: akpm@linux-foundation.org
Subject: + matroxfb-get-rid-of-config_fb_matrox_32mb.patch added to -mm tree
Date: Wed, 02 Sep 2009 14:12:34 -0700
Message-ID: <200909022112.n82LCYGV010786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbZIBVNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 17:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, krzysztof.h1@poczta.fm, vandrove@vc.cvut.cz


The patch titled
     matroxfb: get rid of CONFIG_FB_MATROX_32MB
has been added to the -mm tree.  Its filename is
     matroxfb-get-rid-of-config_fb_matrox_32mb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: matroxfb: get rid of CONFIG_FB_MATROX_32MB
From: Jean Delvare <khali@linux-fr.org>

CONFIG_FB_MATROX_32MB is always enabled, so there is no point in having
ifdefs all around.  And it is bad practice to use CONFIG_* as a name for
something which is not a Kconfig option.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_DAC1064.c |    2 --
 drivers/video/matrox/matroxfb_base.c    |   12 ------------
 drivers/video/matrox/matroxfb_base.h    |    5 -----
 3 files changed, 19 deletions(-)

diff -puN drivers/video/matrox/matroxfb_DAC1064.c~matroxfb-get-rid-of-config_fb_matrox_32mb drivers/video/matrox/matroxfb_DAC1064.c
--- a/drivers/video/matrox/matroxfb_DAC1064.c~matroxfb-get-rid-of-config_fb_matrox_32mb
+++ a/drivers/video/matrox/matroxfb_DAC1064.c
@@ -1080,10 +1080,8 @@ static void MGAG100_restore(struct matro
 
 	DAC1064_restore_1(minfo);
 	matroxfb_vgaHWrestore(minfo);
-#ifdef CONFIG_FB_MATROX_32MB
 	if (minfo->devflags.support32MB)
 		mga_setr(M_EXTVGA_INDEX, 8, hw->CRTCEXT[8]);
-#endif
 	minfo->crtc1.panpos = -1;
 	for (i = 0; i < 6; i++)
 		mga_setr(M_EXTVGA_INDEX, i, hw->CRTCEXT[i]);
diff -puN drivers/video/matrox/matroxfb_base.c~matroxfb-get-rid-of-config_fb_matrox_32mb drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~matroxfb-get-rid-of-config_fb_matrox_32mb
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -310,9 +310,7 @@ static void matrox_pan_var(struct matrox
 {
 	unsigned int pos;
 	unsigned short p0, p1, p2;
-#ifdef CONFIG_FB_MATROX_32MB
 	unsigned int p3;
-#endif
 	int vbl;
 	unsigned long flags;
 
@@ -330,9 +328,7 @@ static void matrox_pan_var(struct matrox
 	p0 = minfo->hw.CRTC[0x0D] = pos & 0xFF;
 	p1 = minfo->hw.CRTC[0x0C] = (pos & 0xFF00) >> 8;
 	p2 = minfo->hw.CRTCEXT[0] = (minfo->hw.CRTCEXT[0] & 0xB0) | ((pos >> 16) & 0x0F) | ((pos >> 14) & 0x40);
-#ifdef CONFIG_FB_MATROX_32MB
 	p3 = minfo->hw.CRTCEXT[8] = pos >> 21;
-#endif
 
 	/* FB_ACTIVATE_VBL and we can acquire interrupts? Honor FB_ACTIVATE_VBL then... */
 	vbl = (var->activate & FB_ACTIVATE_VBL) && (matroxfb_enable_irq(minfo, 0) == 0);
@@ -342,10 +338,8 @@ static void matrox_pan_var(struct matrox
 	matroxfb_DAC_lock_irqsave(flags);
 	mga_setr(M_CRTC_INDEX, 0x0D, p0);
 	mga_setr(M_CRTC_INDEX, 0x0C, p1);
-#ifdef CONFIG_FB_MATROX_32MB
 	if (minfo->devflags.support32MB)
 		mga_setr(M_EXTVGA_INDEX, 0x08, p3);
-#endif
 	if (vbl) {
 		minfo->crtc1.panpos = p2;
 	} else {
@@ -1360,13 +1354,9 @@ static struct video_board vbMystique		= 
 #ifdef CONFIG_FB_MATROX_G
 static struct video_board vbG100		= {0x0800000, 0x0800000, FB_ACCEL_MATROX_MGAG100,	&matrox_G100};
 static struct video_board vbG200		= {0x1000000, 0x1000000, FB_ACCEL_MATROX_MGAG200,	&matrox_G100};
-#ifdef CONFIG_FB_MATROX_32MB
 /* from doc it looks like that accelerator can draw only to low 16MB :-( Direct accesses & displaying are OK for
    whole 32MB */
 static struct video_board vbG400		= {0x2000000, 0x1000000, FB_ACCEL_MATROX_MGAG400,	&matrox_G100};
-#else
-static struct video_board vbG400		= {0x2000000, 0x1000000, FB_ACCEL_MATROX_MGAG400,	&matrox_G100};
-#endif
 #endif
 
 #define DEVF_VIDEO64BIT		0x0001
@@ -1646,9 +1636,7 @@ static int initMatrox2(struct matrox_fb_
 		minfo->devflags.textmode = 1;
 		minfo->devflags.text_type_aux = FB_AUX_TEXT_MGA_STEP8;
 	}
-#ifdef CONFIG_FB_MATROX_32MB
 	minfo->devflags.support32MB = (b->flags & DEVF_SUPPORT32MB) != 0;
-#endif
 	minfo->devflags.precise_width = !(b->flags & DEVF_ANY_VXRES);
 	minfo->devflags.crtc2 = (b->flags & DEVF_CRTC2) != 0;
 	minfo->devflags.maven_capable = (b->flags & DEVF_MAVEN_CAPABLE) != 0;
diff -puN drivers/video/matrox/matroxfb_base.h~matroxfb-get-rid-of-config_fb_matrox_32mb drivers/video/matrox/matroxfb_base.h
--- a/drivers/video/matrox/matroxfb_base.h~matroxfb-get-rid-of-config_fb_matrox_32mb
+++ a/drivers/video/matrox/matroxfb_base.h
@@ -54,9 +54,6 @@
 #include "../macmodes.h"
 #endif
 
-/* always compile support for 32MB... It cost almost nothing */
-#define CONFIG_FB_MATROX_32MB
-
 #ifdef MATROXFB_DEBUG
 
 #define DEBUG
@@ -464,9 +461,7 @@ struct matrox_fb_info {
 		int		nopciretry;
 		int		noinit;
 		int		sgram;
-#ifdef CONFIG_FB_MATROX_32MB
 		int		support32MB;
-#endif
 
 		int		accelerator;
 		int		text_type_aux;
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
dme1737-keep-index-within-pwm_config.patch
drivers-hwmon-adm1021c-support-high-precision-adm1023-remote-sensor.patch
drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver.patch
drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver-update.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch
matroxfb-make-config_fb_matrox_multihead=y-mandatory.patch
matroxfb-get-rid-of-unneeded-macros-access_fbinfo-and-minfo.patch
matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends.patch
matroxfb-get-rid-of-unneeded-macro-minfo_from.patch
matroxfb-get-rid-of-config_fb_matrox_32mb.patch


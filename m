From: akpm@linux-foundation.org
Subject: + viafb-set-sync-polarity-for-all-output-devices.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:19 -0700
Message-ID: <201009212237.o8LMbJmg006807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894Ab0IUWhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:37:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net


The patch titled
     viafb: set sync polarity for all output devices
has been added to the -mm tree.  Its filename is
     viafb-set-sync-polarity-for-all-output-devices.patch

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
Subject: viafb: set sync polarity for all output devices
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Set the sync polarity for all output devices, not only CRT.  This may give
some people a working screen but only if lcd scaling and centering are not
used as it is currently too dificult to propagate a output device. 
Hopefully this does not introduce regressions as the polarity of non-CRT
devices was completly ignored before.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-set-sync-polarity-for-all-output-devices drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-set-sync-polarity-for-all-output-devices
+++ a/drivers/video/via/hw.c
@@ -2014,7 +2014,6 @@ void viafb_fill_crtc_timing(struct crt_m
 	int index = 0;
 	int h_addr, v_addr;
 	u32 pll_D_N;
-	u8 polarity = 0;
 
 	for (i = 0; i < video_mode->mode_array; i++) {
 		index = i;
@@ -2041,14 +2040,6 @@ void viafb_fill_crtc_timing(struct crt_m
 
 	h_addr = crt_reg.hor_addr;
 	v_addr = crt_reg.ver_addr;
-
-	/* update polarity for CRT timing */
-	if (crt_table[index].h_sync_polarity == NEGATIVE)
-		polarity |= VIA_HSYNC_NEGATIVE;
-	if (crt_table[index].v_sync_polarity == NEGATIVE)
-		polarity |= VIA_VSYNC_NEGATIVE;
-	via_set_sync_polarity(VIA_CRT, polarity);
-
 	if (set_iga == IGA1) {
 		viafb_unlock_crt();
 		viafb_write_reg(CR09, VIACR, 0x00);	/*initial CR09=0 */
@@ -2352,6 +2343,17 @@ static void set_display_channel(void)
 	}
 }
 
+static u8 get_sync(struct fb_info *info)
+{
+	u8 polarity = 0;
+
+	if (!(info->var.sync & FB_SYNC_HOR_HIGH_ACT))
+		polarity |= VIA_HSYNC_NEGATIVE;
+	if (!(info->var.sync & FB_SYNC_VERT_HIGH_ACT))
+		polarity |= VIA_VSYNC_NEGATIVE;
+	return polarity;
+}
+
 int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	struct VideoModeTable *vmode_tbl1, int video_bpp1)
 {
@@ -2566,6 +2568,15 @@ int viafb_setmode(struct VideoModeTable 
 			viafb_DeviceStatus = CRT_Device;
 	}
 	device_on();
+	if (!viafb_dual_fb)
+		via_set_sync_polarity(devices, get_sync(viafbinfo));
+	else {
+		via_set_sync_polarity(viaparinfo->shared->iga1_devices,
+			get_sync(viafbinfo));
+		via_set_sync_polarity(viaparinfo->shared->iga2_devices,
+			get_sync(viafbinfo1));
+	}
+
 	via_set_state(devices, VIA_STATE_ON);
 	device_screen_on();
 	return 1;
@@ -2719,4 +2730,9 @@ void viafb_fill_var_timing_info(struct f
 	    crt_reg.ver_total - (crt_reg.ver_sync_start + crt_reg.ver_sync_end);
 	var->lower_margin = crt_reg.ver_sync_start - crt_reg.ver_addr;
 	var->vsync_len = crt_reg.ver_sync_end;
+	var->sync = 0;
+	if (crt_timing[index].h_sync_polarity == POSITIVE)
+		var->sync |= FB_SYNC_HOR_HIGH_ACT;
+	if (crt_timing[index].v_sync_polarity == POSITIVE)
+		var->sync |= FB_SYNC_VERT_HIGH_ACT;
 }
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

linux-next.patch
viafb-add-interface-for-output-device-configuration.patch
viafb-limit-lcd-code-impact.patch
viafb-introduce-per-output-device-power-management.patch
viafb-vt1636-cleanup.patch
viafb-fix-i2c_transfer-error-handling.patch
viafb-enable-i2c-for-crt.patch
viafb-reduce-i2c-timeout-and-delay.patch
viafb-add-function-to-change-sync-polarity-per-device.patch
viafb-set-sync-polarity-for-all-output-devices.patch
viafb-add-a-mapping-of-supported-output-devices.patch
viafb-rename-output-devices.patch
viafb-add-documentation-for-proc-interface.patch


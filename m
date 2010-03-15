From: akpm@linux-foundation.org
Subject: [merged] viafb-make-viafb_set_par-more-dual-framebuffer-compatible.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:25 -0400
Message-ID: <201003150656.o2F6uwoa016334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934463Ab0COG5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, mm-commits@vger.kernel.org


The patch titled
     viafb: make viafb_set_par more dual framebuffer compatible
has been removed from the -mm tree.  Its filename was
     viafb-make-viafb_set_par-more-dual-framebuffer-compatible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: make viafb_set_par more dual framebuffer compatible
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

This patch is an attempt to make viafb_set_par work correctly with more
than one framebuffer.  As modesetting is not (yet/easily) possible for
each individual IGA it uses the (normally to be avoided) global variables
viafbinfo{,1} to ensure that each function is called with the correct
values.

This patch (finally) allows usable dual framebuffer setups and should not
affect non dual fb ones.  It works in some (most?) configurations as
sometimes the driver still gets device connections wrong.  It can be worth
to try the devices in reverse order (in viafb_active_dev).

The user experience is still not very nice as:

- on the second fb you'll normally have a garbled picture as long as
  no application draws to it
  goal: auto on/off devices depending on reference counting
- as the whole machinery is always done you can see mode changes also
  in an unaffected framebuffer
  goal: split modesetting up for each individual IGA

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-make-viafb_set_par-more-dual-framebuffer-compatible drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-make-viafb_set_par-more-dual-framebuffer-compatible
+++ a/drivers/video/via/viafbdev.c
@@ -160,11 +160,17 @@ static int viafb_set_par(struct fb_info 
 	DEBUG_MSG(KERN_INFO "viafb_set_par!\n");
 
 	viapar->depth = fb_get_color_depth(&info->var, &info->fix);
-	viafb_update_device_setting(info->var.xres, info->var.yres,
-			      info->var.bits_per_pixel, viafb_refresh, 0);
+	viafb_update_device_setting(viafbinfo->var.xres, viafbinfo->var.yres,
+		viafbinfo->var.bits_per_pixel, viafb_refresh, 0);
 
-	vmode_entry = viafb_get_mode(info->var.xres, info->var.yres);
-	if (viafb_SAMM_ON == 1) {
+	vmode_entry = viafb_get_mode(viafbinfo->var.xres, viafbinfo->var.yres);
+	if (viafb_dual_fb) {
+		vmode_entry1 = viafb_get_mode(viafbinfo1->var.xres,
+			viafbinfo1->var.yres);
+		viafb_update_device_setting(viafbinfo1->var.xres,
+			viafbinfo1->var.yres, viafbinfo1->var.bits_per_pixel,
+			viafb_refresh1, 1);
+	} else if (viafb_SAMM_ON == 1) {
 		DEBUG_MSG(KERN_INFO
 		"viafb_second_xres = %d, viafb_second_yres = %d, bpp = %d\n",
 			  viafb_second_xres, viafb_second_yres, viafb_bpp1);
@@ -177,7 +183,11 @@ static int viafb_set_par(struct fb_info 
 
 	if (vmode_entry) {
 		viafb_update_fix(info);
-		viafb_bpp = info->var.bits_per_pixel;
+		if (viafb_dual_fb && viapar->iga_path == IGA2)
+			viafb_bpp1 = info->var.bits_per_pixel;
+		else
+			viafb_bpp = info->var.bits_per_pixel;
+
 		if (info->var.accel_flags & FB_ACCELF_TEXT)
 			info->flags &= ~FBINFO_HWACCEL_DISABLED;
 		else
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch


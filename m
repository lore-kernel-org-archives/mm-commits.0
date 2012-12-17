From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-drm_fb_helperc-avoid-sleeping-in-unblank_screen-if-oops-in-progress.patch added to -mm tree
Date: Mon, 17 Dec 2012 13:38:19 -0800
Message-ID: <20121217213820.1C52820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44805 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2LQViW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 16:38:22 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so350896wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 13:38:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, airlied@linux.ie


The patch titled
     Subject: drivers/gpu/drm/drm_fb_helper.c: avoid sleeping in unblank_screen() if oops in progress
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-drm_fb_helperc-avoid-sleeping-in-unblank_screen-if-oops-in-progress.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: drivers/gpu/drm/drm_fb_helper.c: avoid sleeping in unblank_screen() if oops in progress

unblank_screen() can be called from interrupt context during oops.  thus
all ->fb_blank handlers should avoid sleeping in this situation.

callstack:
panic()
bust_spinlocks(1)
unblank_screen()
vc->vc_sw->con_blank()
fbcon_blank()
fb_blank()
info->fbops->fb_blank()
drm_fb_helper_blank()
drm_fb_helper_dpms()
mutex_lock(&dev->mode_config.mutex)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fb_helper.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/gpu/drm/drm_fb_helper.c~drivers-gpu-drm-drm_fb_helperc-avoid-sleeping-in-unblank_screen-if-oops-in-progress drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~drivers-gpu-drm-drm_fb_helperc-avoid-sleeping-in-unblank_screen-if-oops-in-progress
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -326,7 +326,7 @@ static struct sysrq_key_op sysrq_drm_fb_
 static struct sysrq_key_op sysrq_drm_fb_helper_restore_op = { };
 #endif
 
-static void drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
+static int drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
 {
 	struct drm_fb_helper *fb_helper = info->par;
 	struct drm_device *dev = fb_helper->dev;
@@ -334,10 +334,15 @@ static void drm_fb_helper_dpms(struct fb
 	struct drm_connector *connector;
 	int i, j;
 
+	if (oops_in_progress) {
+		if (!mutex_trylock(&dev->mode_config.mutex))
+			return -EBUSY;
+	} else
+		mutex_lock(&dev->mode_config.mutex);
+
 	/*
 	 * For each CRTC in this fb, turn the connectors on/off.
 	 */
-	mutex_lock(&dev->mode_config.mutex);
 	for (i = 0; i < fb_helper->crtc_count; i++) {
 		crtc = fb_helper->crtc_info[i].mode_set.crtc;
 
@@ -353,6 +358,7 @@ static void drm_fb_helper_dpms(struct fb
 		}
 	}
 	mutex_unlock(&dev->mode_config.mutex);
+	return 0;
 }
 
 int drm_fb_helper_blank(int blank, struct fb_info *info)
@@ -360,24 +366,19 @@ int drm_fb_helper_blank(int blank, struc
 	switch (blank) {
 	/* Display: On; HSync: On, VSync: On */
 	case FB_BLANK_UNBLANK:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_ON);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_ON);
 	/* Display: Off; HSync: On, VSync: On */
 	case FB_BLANK_NORMAL:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
 	/* Display: Off; HSync: Off, VSync: On */
 	case FB_BLANK_HSYNC_SUSPEND:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
 	/* Display: Off; HSync: On, VSync: Off */
 	case FB_BLANK_VSYNC_SUSPEND:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_SUSPEND);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_SUSPEND);
 	/* Display: Off; HSync: Off, VSync: Off */
 	case FB_BLANK_POWERDOWN:
-		drm_fb_helper_dpms(info, DRM_MODE_DPMS_OFF);
-		break;
+		return drm_fb_helper_dpms(info, DRM_MODE_DPMS_OFF);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
drivers-gpu-drm-drm_fb_helperc-avoid-sleeping-in-unblank_screen-if-oops-in-progress.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch


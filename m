From: akpm@linux-foundation.org
Subject: [merged]
 drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:00:21 -0800
Message-ID: <52e02355.ZxeiVoVD51uKgV2I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaAVUAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:00:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robdclark@gmail.com, khlebnikov@openvz.org, airlied@gmail.com, daniel.vetter@ffwll.ch

Subject: [merged] drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch removed from -mm tree
To: daniel.vetter@ffwll.ch,airlied@gmail.com,khlebnikov@openvz.org,robdclark@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:00:21 -0800


The patch titled
     Subject: drm/fb-helper: don't sleep for screen unblank when an oops is in progress
has been removed from the -mm tree.  Its filename was
     drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: drm/fb-helper: don't sleep for screen unblank when an oops is in progress

Otherwise the system will burn even brighter and worse, leave the user
wondering what's going on exactly.

Since we already have a panic handler which will (try) to restore the
entire fbdev console mode, we can just bail out.  Inspired by a patch from
Konstantin Khlebnikov.  The callchain leading to this, cut&pasted from
Konstantin's original patch:

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
drm_modeset_lock_all()
mutex_lock(&dev->mode_config.mutex)

Note that the entire locking in the fb helper around panic/sysrq and kdbg
is ...  non-existant.  So we have a decent change of blowing up
everything.  But since reworking this ties in with funny concepts like the
fbdev notifier chain or the impressive things which happen around
console_lock while oopsing, I'll leave that as an exercise for braver
souls than me.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dave Airlie <airlied@gmail.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fb_helper.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/gpu/drm/drm_fb_helper.c~drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -412,6 +412,14 @@ static void drm_fb_helper_dpms(struct fb
 		return;
 
 	/*
+	 * fbdev->blank can be called from irq context in case of a panic.
+	 * Since we already have our own special panic handler which will
+	 * restore the fbdev console mode completely, just bail out early.
+	 */
+	if (oops_in_progress)
+		return;
+
+	/*
 	 * For each CRTC in this fb, turn the connectors on/off.
 	 */
 	drm_modeset_lock_all(dev);
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are

origin.patch
linux-next.patch


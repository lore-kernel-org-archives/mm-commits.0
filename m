From: akpm@linux-foundation.org
Subject: + drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch added to -mm tree
Date: Mon, 28 Jan 2013 14:04:16 -0800
Message-ID: <20130128220416.AD4525A4005@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:51381 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3A1WER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 17:04:17 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so328106ggn.0
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 14:04:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.vetter@ffwll.ch, airlied@gmail.com, khlebnikov@openvz.org


The patch titled
     Subject: drm/fb-helper: don't sleep for screen unblank when an oopps is in progress
has been added to the -mm tree.  Its filename is
     drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: drm/fb-helper: don't sleep for screen unblank when an oopps is in progress

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fb_helper.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/gpu/drm/drm_fb_helper.c~drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -353,6 +353,14 @@ static void drm_fb_helper_dpms(struct fb
 	int i, j;
 
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

linux-next.patch
drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch


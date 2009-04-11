From: akpm@linux-foundation.org
Subject: + fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch added to -mm tree
Date: Sat, 11 Apr 2009 11:23:25 -0700
Message-ID: <200904111823.n3BINPtV009221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504AbZDKS3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 11 Apr 2009 14:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, eric.y.miao@gmail.com, geert@linux-m68k.org, krzysztof.h1@poczta.fm, proski@gnu.org, rjw@sisk.pl, stefanr@s5r6.in-berlin.de


The patch titled
     fbdev: fix info->lock deadlock in fbcon_event_notify()
has been added to the -mm tree.  Its filename is
     fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch

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
Subject: fbdev: fix info->lock deadlock in fbcon_event_notify()
From: Andrea Righi <righi.andrea@gmail.com>

fb_notifier_call_chain() is called with info->lock held, i.e.  in
do_fb_ioctl() => FBIOPUT_VSCREENINFO => fb_set_var() and the some
notifier callbacks, like fbcon_event_notify(), try to re-acquire
info->lock again.

Remove the lock/unlock_fb_info() in all the framebuffer notifier
callbacks' and be sure to always call fb_notifier_call_chain() with
info->lock held.

Reported-by: Pavel Roskin <proski@gnu.org>
Reported-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    3 -
 drivers/video/backlight/lcd.c       |    3 -
 drivers/video/console/fbcon.c       |   55 +-------------------------
 drivers/video/fbmem.c               |   19 ++++++++
 4 files changed, 22 insertions(+), 58 deletions(-)

diff -puN drivers/video/backlight/backlight.c~fbdev-fix-info-lock-deadlock-in-fbcon_event_notify drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~fbdev-fix-info-lock-deadlock-in-fbcon_event_notify
+++ a/drivers/video/backlight/backlight.c
@@ -35,8 +35,6 @@ static int fb_notifier_callback(struct n
 		return 0;
 
 	bd = container_of(self, struct backlight_device, fb_notif);
-	if (!lock_fb_info(evdata->info))
-		return -ENODEV;
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops)
 		if (!bd->ops->check_fb ||
@@ -49,7 +47,6 @@ static int fb_notifier_callback(struct n
 			backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
-	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff -puN drivers/video/backlight/lcd.c~fbdev-fix-info-lock-deadlock-in-fbcon_event_notify drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~fbdev-fix-info-lock-deadlock-in-fbcon_event_notify
+++ a/drivers/video/backlight/lcd.c
@@ -40,8 +40,6 @@ static int fb_notifier_callback(struct n
 	if (!ld->ops)
 		return 0;
 
-	if (!lock_fb_info(evdata->info))
-		return -ENODEV;
 	mutex_lock(&ld->ops_lock);
 	if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info)) {
 		if (event == FB_EVENT_BLANK) {
@@ -53,7 +51,6 @@ static int fb_notifier_callback(struct n
 		}
 	}
 	mutex_unlock(&ld->ops_lock);
-	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff -puN drivers/video/console/fbcon.c~fbdev-fix-info-lock-deadlock-in-fbcon_event_notify drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbdev-fix-info-lock-deadlock-in-fbcon_event_notify
+++ a/drivers/video/console/fbcon.c
@@ -2263,9 +2263,12 @@ static void fbcon_generic_blank(struct v
 	}
 
 
+	if (!lock_fb_info(info))
+		return;
 	event.info = info;
 	event.data = &blank;
 	fb_notifier_call_chain(FB_EVENT_CONBLANK, &event);
+	unlock_fb_info(info);
 }
 
 static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
@@ -2956,8 +2959,6 @@ static int fbcon_fb_unregistered(struct 
 {
 	int i, idx;
 
-	if (!lock_fb_info(info))
-		return -ENODEV;
 	idx = info->node;
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
 		if (con2fb_map[i] == idx)
@@ -2985,8 +2986,6 @@ static int fbcon_fb_unregistered(struct 
 	if (primary_device == idx)
 		primary_device = -1;
 
-	unlock_fb_info(info);
-
 	if (!num_registered_fb)
 		unregister_con_driver(&fb_con);
 
@@ -3027,11 +3026,8 @@ static int fbcon_fb_registered(struct fb
 {
 	int ret = 0, i, idx;
 
-	if (!lock_fb_info(info))
-		return -ENODEV;
 	idx = info->node;
 	fbcon_select_primary(info);
-	unlock_fb_info(info);
 
 	if (info_idx == -1) {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
@@ -3152,53 +3148,23 @@ static int fbcon_event_notify(struct not
 
 	switch(action) {
 	case FB_EVENT_SUSPEND:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_suspended(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_RESUME:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_resumed(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_modechanged(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE_ALL:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_set_all_vcs(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_DELETE:
 		mode = event->data;
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		ret = fbcon_mode_deleted(info, mode);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_FB_UNBIND:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		idx = info->node;
-		unlock_fb_info(info);
 		ret = fbcon_fb_unbind(idx);
 		break;
 	case FB_EVENT_FB_REGISTERED:
@@ -3217,29 +3183,14 @@ static int fbcon_event_notify(struct not
 		con2fb->framebuffer = con2fb_map[con2fb->console - 1];
 		break;
 	case FB_EVENT_BLANK:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_fb_blanked(info, *(int *)event->data);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_NEW_MODELIST:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_new_modelist(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_GET_REQ:
 		caps = event->data;
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_get_requirement(info, caps);
-		unlock_fb_info(info);
 		break;
 	}
 done:
diff -puN drivers/video/fbmem.c~fbdev-fix-info-lock-deadlock-in-fbcon_event_notify drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-fix-info-lock-deadlock-in-fbcon_event_notify
+++ a/drivers/video/fbmem.c
@@ -1097,8 +1097,11 @@ static long do_fb_ioctl(struct fb_info *
 			return -EINVAL;
 		con2fb.framebuffer = -1;
 		event.data = &con2fb;
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		event.info = info;
 		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
+		unlock_fb_info(info);
 		ret = copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_CON2FBMAP:
@@ -1115,8 +1118,11 @@ static long do_fb_ioctl(struct fb_info *
 			break;
 		}
 		event.data = &con2fb;
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
+		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
 		if (!lock_fb_info(info))
@@ -1521,7 +1527,10 @@ register_framebuffer(struct fb_info *fb_
 	registered_fb[i] = fb_info;
 
 	event.info = fb_info;
+	if (!lock_fb_info(fb_info))
+		return -ENODEV;
 	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
+	unlock_fb_info(fb_info);
 	return 0;
 }
 
@@ -1555,8 +1564,12 @@ unregister_framebuffer(struct fb_info *f
 		goto done;
 	}
 
+
+	if (!lock_fb_info(fb_info))
+		return -ENODEV;
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
+	unlock_fb_info(fb_info);
 
 	if (ret) {
 		ret = -EINVAL;
@@ -1590,6 +1603,8 @@ void fb_set_suspend(struct fb_info *info
 {
 	struct fb_event event;
 
+	if (!lock_fb_info(info))
+		return;
 	event.info = info;
 	if (state) {
 		fb_notifier_call_chain(FB_EVENT_SUSPEND, &event);
@@ -1598,6 +1613,7 @@ void fb_set_suspend(struct fb_info *info
 		info->state = FBINFO_STATE_RUNNING;
 		fb_notifier_call_chain(FB_EVENT_RESUME, &event);
 	}
+	unlock_fb_info(info);
 }
 
 /**
@@ -1667,8 +1683,11 @@ int fb_new_modelist(struct fb_info *info
 	err = 1;
 
 	if (!list_empty(&info->modelist)) {
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		event.info = info;
 		err = fb_notifier_call_chain(FB_EVENT_NEW_MODELIST, &event);
+		unlock_fb_info(info);
 	}
 
 	return err;
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch
revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
res_counter-update-documentation.patch


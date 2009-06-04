From: akpm@linux-foundation.org
Subject: - revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch removed from -mm tree
Date: Thu, 04 Jun 2009 12:57:02 -0700
Message-ID: <200906041957.n54Jv2Ma014360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbZFDT6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 15:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     revert "fbdev: fix info->lock deadlock in fbcon_event_notify()"
has been removed from the -mm tree.  Its filename was
     revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch

This patch was dropped because we'll be trying to fix it up

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "fbdev: fix info->lock deadlock in fbcon_event_notify()"
From: Krzysztof Helt <krzysztof.h1@wp.pl>

A conversion of the BLK to the fb_info->lock mutex brought some circular
locking dependencies.  Despite extensive effort to fix these problems
there are still some bugs left.  The last effort unveiled a problem
described below.  It is not fixable without rethinking how locking should
be done inside the fbdev layer.  

Short summary of the lock dep is:

1. sys_munmap() obtains [mm->mmap_sem] and calls indirectly
  :: fb_release() obtains [fb_info->lock]

2. fb_ioctl() obtains [fb_info->lock] and calls indirectly
  :: fb_notifier_call_chain() obtains [fb_notifier_list->rwsem]

3. driver_probe_device() calls indirectly
  :: register_framebuffer() calls indirectly
    :: fb_notifier_call_chain() obtains [fb_notifier_list->rwsem] and calls indirectly
      :: sysfs_create_dir() obtains [sysfs_mutex]

4. sysfs_readdir() obtains [sysfs_mutex] and calls indirectly
  :: copy_to_user() obtains [mm->mmap_sem]

Revert the BKL to mutex conversion patch
(3e680aae4e53ab54cdbb0c29257dae0cbb158e1c) while keeping the patch which
made the fb_ioctl and the fb_compat_ioctl using a common function
(a684e7d33096892093456dd56a582cfc3bfad648).

This patch: revert

: commit 513adb58685615b0b1d47a3f0d40f5352beff189
: Author: Andrea Righi <righi.andrea@gmail.com>
: Date:   Mon Apr 13 14:39:39 2009 -0700
: 
:     fbdev: fix info->lock deadlock in fbcon_event_notify()
    
Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrea Righi <righi.andrea@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    3 +
 drivers/video/backlight/lcd.c       |    3 +
 drivers/video/console/fbcon.c       |   55 ++++++++++++++++++++++++--
 drivers/video/fbmem.c               |   19 --------
 4 files changed, 58 insertions(+), 22 deletions(-)

diff -puN drivers/video/backlight/backlight.c~revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify
+++ a/drivers/video/backlight/backlight.c
@@ -35,6 +35,8 @@ static int fb_notifier_callback(struct n
 		return 0;
 
 	bd = container_of(self, struct backlight_device, fb_notif);
+	if (!lock_fb_info(evdata->info))
+		return -ENODEV;
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops)
 		if (!bd->ops->check_fb ||
@@ -47,6 +49,7 @@ static int fb_notifier_callback(struct n
 			backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
+	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff -puN drivers/video/backlight/lcd.c~revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify
+++ a/drivers/video/backlight/lcd.c
@@ -40,6 +40,8 @@ static int fb_notifier_callback(struct n
 	if (!ld->ops)
 		return 0;
 
+	if (!lock_fb_info(evdata->info))
+		return -ENODEV;
 	mutex_lock(&ld->ops_lock);
 	if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info)) {
 		if (event == FB_EVENT_BLANK) {
@@ -51,6 +53,7 @@ static int fb_notifier_callback(struct n
 		}
 	}
 	mutex_unlock(&ld->ops_lock);
+	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff -puN drivers/video/console/fbcon.c~revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify
+++ a/drivers/video/console/fbcon.c
@@ -2263,12 +2263,9 @@ static void fbcon_generic_blank(struct v
 	}
 
 
-	if (!lock_fb_info(info))
-		return;
 	event.info = info;
 	event.data = &blank;
 	fb_notifier_call_chain(FB_EVENT_CONBLANK, &event);
-	unlock_fb_info(info);
 }
 
 static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
@@ -2959,6 +2956,8 @@ static int fbcon_fb_unregistered(struct 
 {
 	int i, idx;
 
+	if (!lock_fb_info(info))
+		return -ENODEV;
 	idx = info->node;
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
 		if (con2fb_map[i] == idx)
@@ -2986,6 +2985,8 @@ static int fbcon_fb_unregistered(struct 
 	if (primary_device == idx)
 		primary_device = -1;
 
+	unlock_fb_info(info);
+
 	if (!num_registered_fb)
 		unregister_con_driver(&fb_con);
 
@@ -3026,8 +3027,11 @@ static int fbcon_fb_registered(struct fb
 {
 	int ret = 0, i, idx;
 
+	if (!lock_fb_info(info))
+		return -ENODEV;
 	idx = info->node;
 	fbcon_select_primary(info);
+	unlock_fb_info(info);
 
 	if (info_idx == -1) {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
@@ -3148,23 +3152,53 @@ static int fbcon_event_notify(struct not
 
 	switch(action) {
 	case FB_EVENT_SUSPEND:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_suspended(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_RESUME:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_resumed(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_modechanged(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE_ALL:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_set_all_vcs(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_DELETE:
 		mode = event->data;
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		ret = fbcon_mode_deleted(info, mode);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_FB_UNBIND:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		idx = info->node;
+		unlock_fb_info(info);
 		ret = fbcon_fb_unbind(idx);
 		break;
 	case FB_EVENT_FB_REGISTERED:
@@ -3183,14 +3217,29 @@ static int fbcon_event_notify(struct not
 		con2fb->framebuffer = con2fb_map[con2fb->console - 1];
 		break;
 	case FB_EVENT_BLANK:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_fb_blanked(info, *(int *)event->data);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_NEW_MODELIST:
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_new_modelist(info);
+		unlock_fb_info(info);
 		break;
 	case FB_EVENT_GET_REQ:
 		caps = event->data;
+		if (!lock_fb_info(info)) {
+			ret = -ENODEV;
+			goto done;
+		}
 		fbcon_get_requirement(info, caps);
+		unlock_fb_info(info);
 		break;
 	}
 done:
diff -puN drivers/video/fbmem.c~revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify
+++ a/drivers/video/fbmem.c
@@ -1097,11 +1097,8 @@ static long do_fb_ioctl(struct fb_info *
 			return -EINVAL;
 		con2fb.framebuffer = -1;
 		event.data = &con2fb;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
 		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
-		unlock_fb_info(info);
 		ret = copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_CON2FBMAP:
@@ -1118,11 +1115,8 @@ static long do_fb_ioctl(struct fb_info *
 			break;
 		}
 		event.data = &con2fb;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
-		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
 		if (!lock_fb_info(info))
@@ -1527,10 +1521,7 @@ register_framebuffer(struct fb_info *fb_
 	registered_fb[i] = fb_info;
 
 	event.info = fb_info;
-	if (!lock_fb_info(fb_info))
-		return -ENODEV;
 	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
-	unlock_fb_info(fb_info);
 	return 0;
 }
 
@@ -1564,12 +1555,8 @@ unregister_framebuffer(struct fb_info *f
 		goto done;
 	}
 
-
-	if (!lock_fb_info(fb_info))
-		return -ENODEV;
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
-	unlock_fb_info(fb_info);
 
 	if (ret) {
 		ret = -EINVAL;
@@ -1603,8 +1590,6 @@ void fb_set_suspend(struct fb_info *info
 {
 	struct fb_event event;
 
-	if (!lock_fb_info(info))
-		return;
 	event.info = info;
 	if (state) {
 		fb_notifier_call_chain(FB_EVENT_SUSPEND, &event);
@@ -1613,7 +1598,6 @@ void fb_set_suspend(struct fb_info *info
 		info->state = FBINFO_STATE_RUNNING;
 		fb_notifier_call_chain(FB_EVENT_RESUME, &event);
 	}
-	unlock_fb_info(info);
 }
 
 /**
@@ -1683,11 +1667,8 @@ int fb_new_modelist(struct fb_info *info
 	err = 1;
 
 	if (!list_empty(&info->modelist)) {
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
 		err = fb_notifier_call_chain(FB_EVENT_NEW_MODELIST, &event);
-		unlock_fb_info(info);
 	}
 
 	return err;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch
revert-fbdev-uninline-lock_fb_info.patch
revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
revert-fbmem-dont-call-copy_from-to_user-with-mutex-held.patch
fbdev-move-back-to-bkl-solution.patch
linux-next.patch
intelfb-fix-color-map-setting-with-an-lvds-display.patch
chipsfb-remove-redundant-assignment.patch
igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
acornfb-remove-fb_mmap-function.patch
s3c-fb-fix-resource-releasing-on-error-during-probing.patch
fbdev-use-framebuffer_release-for-freeing-fb_info-structures.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch
bw2-use-standard-fields-for-framebuffer-physical-address-and-length.patch
cg14-use-standard-fields-for-framebuffer-physical-address-and-length.patch
cg3-use-standard-fields-for-framebuffer-physical-address-and-length.patch
cg6-use-standard-fields-for-framebuffer-physical-address-and-length.patch
leo-use-standard-fields-for-framebuffer-physical-address-and-length.patch
p9100-use-standard-fields-for-framebuffer-physical-address-and-length.patch
tcx-use-standard-fields-for-framebuffer-physical-address-and-length.patch


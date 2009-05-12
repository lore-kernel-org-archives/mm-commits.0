From: akpm@linux-foundation.org
Subject: + revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch added to -mm tree
Date: Tue, 12 May 2009 14:27:04 -0700
Message-ID: <200905122127.n4CLR4Bm023454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132AbZELV3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:29:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, geert@linux-m68k.org, righi.andrea@gmail.com


The patch titled
     revert "fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency"
has been added to the -mm tree.  Its filename is
     revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch

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
Subject: revert "fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency"
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

: commit 66c1ca019078220dc1bf968f2bb18421100ef147
: Author: Andrea Righi <righi.andrea@gmail.com>
: Date:   Tue Mar 31 15:25:18 2009 -0700
: 
:     fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrea Righi <righi.andrea@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    3 -
 drivers/video/backlight/lcd.c       |    3 -
 drivers/video/console/fbcon.c       |   71 +++-----------------------
 drivers/video/fbmem.c               |   11 +++-
 4 files changed, 19 insertions(+), 69 deletions(-)

diff -puN drivers/video/backlight/backlight.c~revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency
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
 
diff -puN drivers/video/backlight/lcd.c~revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency
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
 
diff -puN drivers/video/console/fbcon.c~revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency
+++ a/drivers/video/console/fbcon.c
@@ -2954,11 +2954,8 @@ static int fbcon_fb_unbind(int idx)
 
 static int fbcon_fb_unregistered(struct fb_info *info)
 {
-	int i, idx;
+	int i, idx = info->node;
 
-	if (!lock_fb_info(info))
-		return -ENODEV;
-	idx = info->node;
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
 		if (con2fb_map[i] == idx)
 			con2fb_map[i] = -1;
@@ -2982,14 +2979,13 @@ static int fbcon_fb_unregistered(struct 
 		}
 	}
 
-	if (primary_device == idx)
-		primary_device = -1;
-
-	unlock_fb_info(info);
-
 	if (!num_registered_fb)
 		unregister_con_driver(&fb_con);
 
+
+	if (primary_device == idx)
+		primary_device = -1;
+
 	return 0;
 }
 
@@ -3025,13 +3021,9 @@ static inline void fbcon_select_primary(
 
 static int fbcon_fb_registered(struct fb_info *info)
 {
-	int ret = 0, i, idx;
+	int ret = 0, i, idx = info->node;
 
-	if (!lock_fb_info(info))
-		return -ENODEV;
-	idx = info->node;
 	fbcon_select_primary(info);
-	unlock_fb_info(info);
 
 	if (info_idx == -1) {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
@@ -3140,7 +3132,7 @@ static int fbcon_event_notify(struct not
 	struct fb_videomode *mode;
 	struct fb_con2fbmap *con2fb;
 	struct fb_blit_caps *caps;
-	int idx, ret = 0;
+	int ret = 0;
 
 	/*
 	 * ignore all events except driver registration and deregistration
@@ -3152,54 +3144,23 @@ static int fbcon_event_notify(struct not
 
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
-		idx = info->node;
-		unlock_fb_info(info);
-		ret = fbcon_fb_unbind(idx);
+		ret = fbcon_fb_unbind(info->node);
 		break;
 	case FB_EVENT_FB_REGISTERED:
 		ret = fbcon_fb_registered(info);
@@ -3217,31 +3178,17 @@ static int fbcon_event_notify(struct not
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
+
 done:
 	return ret;
 }
diff -puN drivers/video/fbmem.c~revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency
+++ a/drivers/video/fbmem.c
@@ -1086,8 +1086,13 @@ static long do_fb_ioctl(struct fb_info *
 			return -EINVAL;
 		con2fb.framebuffer = -1;
 		event.data = &con2fb;
+
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		event.info = info;
 		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
+		unlock_fb_info(info);
+
 		ret = copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_CON2FBMAP:
@@ -1104,8 +1109,12 @@ static long do_fb_ioctl(struct fb_info *
 			break;
 		}
 		event.data = &con2fb;
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		event.info = info;
-		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
+		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
+					      &event);
+		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
 		if (!lock_fb_info(info))
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

viafb-make-it-work-on-x86_64.patch
linux-next.patch
revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch
revert-fbdev-uninline-lock_fb_info.patch
revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
revert-fbmem-dont-call-copy_from-to_user-with-mutex-held.patch
chipsfb-remove-redundant-assignment.patch
igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch


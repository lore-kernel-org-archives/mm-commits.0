From: akpm@linux-foundation.org
Subject: + revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch added to -mm tree
Date: Fri, 10 Apr 2009 15:35:07 -0700
Message-ID: <200904102235.n3AMZ7r7026673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbZDJWkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 18:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arvidjaar@mail.ru, geert@linux-m68k.org, krzysztof.h1@poczta.fm, righi.andrea@gmail.com, stable@kernel.org


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
From: Andrew Morton <akpm@linux-foundation.org>

Revert

    commit 66c1ca019078220dc1bf968f2bb18421100ef147
    Author: Andrea Righi <righi.andrea@gmail.com>
    Date:   Tue Mar 31 15:25:18 2009 -0700

        fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency

Since it caused Xfbmem failures.

This will re-introduce the circular locking dependency fb_info->lock =>
mm->mmap_sem => fb_info->lock.  Krzysztof will work on an alternative fix.

Cc: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Andrea Righi <righi.andrea@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: <stable@kernel.org>
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
@@ -1097,8 +1097,13 @@ static long do_fb_ioctl(struct fb_info *
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
@@ -1115,8 +1120,12 @@ static long do_fb_ioctl(struct fb_info *
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
hfs-fix-memory-leak-when-unmounting-fix.patch
memcg-remove-warning-when-config_debug_vm=n-fix.patch
shmem-respect-max_lfs_filesize-fix.patch
shmem-respect-max_lfs_filesize-fix-fix.patch
revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-consolidate-init_mm-definition-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch


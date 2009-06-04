From: akpm@linux-foundation.org
Subject: - revert-fbdev-uninline-lock_fb_info.patch removed from -mm tree
Date: Thu, 04 Jun 2009 12:57:04 -0700
Message-ID: <200906041957.n54Jv4n3014473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbZFDT6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 15:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, akpm@linux-foundation.org, geert@linux-m68k.org, righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     revert "fbdev: uninline lock_fb_info()"
has been removed from the -mm tree.  Its filename was
     revert-fbdev-uninline-lock_fb_info.patch

This patch was dropped because we'll be trying to fix it up

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "fbdev: uninline lock_fb_info()"
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

: commit 6a7f2829b5f8be124e168265f176dbbbea8861a0
: Author: Andrew Morton <akpm@linux-foundation.org>
: Date:   Tue Mar 31 15:25:19 2009 -0700
: 
:     fbdev: uninline lock_fb_info()

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrea Righi <righi.andrea@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   11 -----------
 include/linux/fb.h    |   10 +++++++++-
 2 files changed, 9 insertions(+), 12 deletions(-)

diff -puN drivers/video/fbmem.c~revert-fbdev-uninline-lock_fb_info drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~revert-fbdev-uninline-lock_fb_info
+++ a/drivers/video/fbmem.c
@@ -46,17 +46,6 @@
 struct fb_info *registered_fb[FB_MAX] __read_mostly;
 int num_registered_fb __read_mostly;
 
-int lock_fb_info(struct fb_info *info)
-{
-	mutex_lock(&info->lock);
-	if (!info->fbops) {
-		mutex_unlock(&info->lock);
-		return 0;
-	}
-	return 1;
-}
-EXPORT_SYMBOL(lock_fb_info);
-
 /*
  * Helpers
  */
diff -puN include/linux/fb.h~revert-fbdev-uninline-lock_fb_info include/linux/fb.h
--- a/include/linux/fb.h~revert-fbdev-uninline-lock_fb_info
+++ a/include/linux/fb.h
@@ -965,7 +965,15 @@ extern struct fb_info *registered_fb[FB_
 extern int num_registered_fb;
 extern struct class *fb_class;
 
-extern int lock_fb_info(struct fb_info *info);
+static inline int lock_fb_info(struct fb_info *info)
+{
+	mutex_lock(&info->lock);
+	if (!info->fbops) {
+		mutex_unlock(&info->lock);
+		return 0;
+	}
+	return 1;
+}
 
 static inline void unlock_fb_info(struct fb_info *info)
 {
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

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


From: akpm@linux-foundation.org
Subject: [to-be-updated] fb-move-mutex_init-to-framebuffer_alloc.patch removed from -mm tree
Date: Thu, 02 Jul 2009 12:51:27 -0700
Message-ID: <200907021951.n62JpRcC008328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbZGBTw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 15:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, a.p.zijlstra@chello.nl, krzysztof.h1@wp.pl, rjw@sisk.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fb: move mutex_init to framebuffer_alloc()
has been removed from the -mm tree.  Its filename was
     fb-move-mutex_init-to-framebuffer_alloc.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: move mutex_init to framebuffer_alloc()
From: Daniel Mack <daniel@caiaq.de>

In 537a1bf05 ("fbdev: add mutex for fb_mmap locking"), a per-fbinfo mutex
was added and framebuffer drivers were adopted accordingly.  This new lock
is currently initialized in register_framebuffer().

The mx3fb driver takes this lock in mx3fb_map_video_memory() _before_
register_framebuffer() is called and hence crashes the system very early.

Moving this mutex_init() to framebuffer_alloc() solves this and also seems
a lot more straight forward.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c   |    3 ---
 drivers/video/fbsysfs.c |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/fbmem.c~fb-move-mutex_init-to-framebuffer_alloc drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-move-mutex_init-to-framebuffer_alloc
+++ a/drivers/video/fbmem.c
@@ -1513,9 +1513,6 @@ register_framebuffer(struct fb_info *fb_
 		if (!registered_fb[i])
 			break;
 	fb_info->node = i;
-	mutex_init(&fb_info->lock);
-	mutex_init(&fb_info->mm_lock);
-
 	fb_info->dev = device_create(fb_class, fb_info->device,
 				     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
 	if (IS_ERR(fb_info->dev)) {
diff -puN drivers/video/fbsysfs.c~fb-move-mutex_init-to-framebuffer_alloc drivers/video/fbsysfs.c
--- a/drivers/video/fbsysfs.c~fb-move-mutex_init-to-framebuffer_alloc
+++ a/drivers/video/fbsysfs.c
@@ -58,6 +58,9 @@ struct fb_info *framebuffer_alloc(size_t
 
 	info->device = dev;
 
+	mutex_init(&info->lock);
+	mutex_init(&info->mm_lock);
+
 #ifdef CONFIG_FB_BACKLIGHT
 	mutex_init(&info->bl_curve_mutex);
 #endif
_

Patches currently in -mm which might be from daniel@caiaq.de are

fb-move-mutex_init-to-framebuffer_alloc.patch
lis3-fix-typo.patch
lis3-add-free-fall-wakeup-function-via-platform_data.patch
lis3-add-power-management-functions.patch
lis3-add-power-management-functions-fix.patch
lis3_spi-code-cleanups.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch


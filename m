From: akpm@linux-foundation.org
Subject: + fbdev-permit-setting-of-vesa-modes-when-using-compiled-in-drivers.patch added to -mm tree
Date: Tue, 26 May 2009 23:15:21 -0700
Message-ID: <200905270615.n4R6FLbJ029078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130AbZE0GPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 02:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, wl@gnu.org


The patch titled
     fbdev: permit setting of VESA modes when using compiled-in drivers
has been added to the -mm tree.  Its filename is
     fbdev-permit-setting-of-vesa-modes-when-using-compiled-in-drivers.patch

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
Subject: fbdev: permit setting of VESA modes when using compiled-in drivers
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The kernel does not accept VESA modes via the "vga=" kernel parameter
if there is no frame buffer driver compiled-in to handle it.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Werner Lemberg <wl@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-does-not-allow-vesa-modes-without-compiled-in-drivers-bug-13249 drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-does-not-allow-vesa-modes-without-compiled-in-drivers-bug-13249
+++ a/drivers/video/Kconfig
@@ -1122,7 +1122,7 @@ config FB_INTEL
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select FB_BOOT_VESA_SUPPORT
+	select FB_BOOT_VESA_SUPPORT if FB_INTEL = y
 	help
 	  This driver supports the on-board graphics built in to the Intel
           830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.
@@ -1460,7 +1460,7 @@ config FB_SIS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select FB_BOOT_VESA_SUPPORT
+	select FB_BOOT_VESA_SUPPORT if FB_SIS = y
 	help
 	  This is the frame buffer device driver for the SiS 300, 315, 330
 	  and 340 series as well as XGI V3XT, V5, V8, Z7 graphics chipsets.
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch
revert-fbdev-uninline-lock_fb_info.patch
revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
revert-fbmem-dont-call-copy_from-to_user-with-mutex-held.patch
fbdev-move-back-to-bkl-solution.patch
linux-next.patch
fbdev-permit-setting-of-vesa-modes-when-using-compiled-in-drivers.patch
intelfb-fix-color-map-setting-with-an-lvds-display.patch
chipsfb-remove-redundant-assignment.patch
igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch


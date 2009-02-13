From: akpm@linux-foundation.org
Subject: + fbdev-drm-fix-kconfig-submenu-mess-in-graphics-support.patch added to -mm tree
Date: Fri, 13 Feb 2009 15:39:00 -0800
Message-ID: <200902132339.n1DNd097021828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbZBMXjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 18:39:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, airlied@linux.ie, mingo@elte.hu


The patch titled
     fbdev/drm: fix Kconfig submenu mess in "Graphics support"
has been added to the -mm tree.  Its filename is
     fbdev-drm-fix-kconfig-submenu-mess-in-graphics-support.patch

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
Subject: fbdev/drm: fix Kconfig submenu mess in "Graphics support"
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Submenus of the graphics support "Support for frame buffer devices" and
"Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)" are
broken in half after latest changes for Intel 915 mode setting support.

The DRM subsection is broken because one option is put outside the choice
section it depends on.

The frame buffers part is broken then due to circular dependency.  Fix
this by make Intel frame buffers depend on CONFIG_INTEL_AGP.

Kconfigs are broken by d2f59357700487a8b944f4f7777d1e97cf5ea2ed
("drm/i915: select framebuffer support automatically").

This is probably not only way to fix this.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/Kconfig |   13 ++++++-------
 drivers/video/Kconfig   |   10 ++--------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff -puN drivers/gpu/drm/Kconfig~fbdev-drm-fix-kconfig-submenu-mess-in-graphics-support drivers/gpu/drm/Kconfig
--- a/drivers/gpu/drm/Kconfig~fbdev-drm-fix-kconfig-submenu-mess-in-graphics-support
+++ a/drivers/gpu/drm/Kconfig
@@ -80,18 +80,17 @@ config DRM_I915
 	  XFree86 4.4 and above. If unsure, build this and i830 as modules and
 	  the X server will load the correct one.
 
-endchoice
-
 config DRM_I915_KMS
 	bool "Enable modesetting on intel by default"
 	depends on DRM_I915
 	help
-	Choose this option if you want kernel modesetting enabled by default,
-	and you have a new enough userspace to support this. Running old
-	userspaces with this enabled will cause pain.  Note that this causes
-	the driver to bind to PCI devices, which precludes loading things
-	like intelfb.
+	  Choose this option if you want kernel modesetting enabled by default,
+	  and you have a new enough userspace to support this. Running old
+	  userspaces with this enabled will cause pain.  Note that this causes
+	  the driver to bind to PCI devices, which precludes loading things
+	  like intelfb.
 
+endchoice
 
 config DRM_MGA
 	tristate "Matrox g200/g400"
diff -puN drivers/video/Kconfig~fbdev-drm-fix-kconfig-submenu-mess-in-graphics-support drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-drm-fix-kconfig-submenu-mess-in-graphics-support
+++ a/drivers/video/Kconfig
@@ -1054,10 +1054,7 @@ config FB_RIVA_BACKLIGHT
 
 config FB_I810
 	tristate "Intel 810/815 support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI && X86_32
-	select AGP
-	select AGP_INTEL
-	select FB
+	depends on EXPERIMENTAL && FB && PCI && X86_32 && AGP_INTEL
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1120,10 +1117,7 @@ config FB_CARILLO_RANCH
 
 config FB_INTEL
 	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI && X86
-	select FB
-	select AGP
-	select AGP_INTEL
+	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
fbdev-drm-fix-kconfig-submenu-mess-in-graphics-support.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch


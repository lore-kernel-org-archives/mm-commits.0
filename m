From: akpm@linux-foundation.org
Subject: - video-gfx-merge-kconfig-menus.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:03 -0700
Message-ID: <200710162045.l9GKj3Ow016226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965052AbXJPU5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adaplas@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     video gfx: merge kconfig menus
has been removed from the -mm tree.  Its filename was
     video-gfx-merge-kconfig-menus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: video gfx: merge kconfig menus
From: Randy Dunlap <randy.dunlap@oracle.com>

Move AGP and DRM menus into the video graphics support menu.
  They use 'menuconfig' so that they can all be disabled with
  one selection.
Make the console menu use 'menuconfig' so that it can all be
  disabled with one selection.
Make the frame buffer menu use 'menuconfig' so that it can all be
  disabled with one selection.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig     |    4 ----
 drivers/char/agp/Kconfig |    2 +-
 drivers/char/drm/Kconfig |    2 +-
 drivers/video/Kconfig    |   11 +++++++----
 4 files changed, 9 insertions(+), 10 deletions(-)

diff -puN drivers/char/Kconfig~video-gfx-merge-kconfig-menus drivers/char/Kconfig
--- a/drivers/char/Kconfig~video-gfx-merge-kconfig-menus
+++ a/drivers/char/Kconfig
@@ -896,10 +896,6 @@ config GPIO_TB0219
 	depends on TANBAC_TB022X
 	select GPIO_VR41XX
 
-source "drivers/char/agp/Kconfig"
-
-source "drivers/char/drm/Kconfig"
-
 source "drivers/char/pcmcia/Kconfig"
 
 config MWAVE
diff -puN drivers/char/agp/Kconfig~video-gfx-merge-kconfig-menus drivers/char/agp/Kconfig
--- a/drivers/char/agp/Kconfig~video-gfx-merge-kconfig-menus
+++ a/drivers/char/agp/Kconfig
@@ -1,4 +1,4 @@
-config AGP
+menuconfig AGP
 	tristate "/dev/agpgart (AGP Support)"
 	depends on ALPHA || IA64 || PARISC || PPC || X86
 	depends on PCI
diff -puN drivers/char/drm/Kconfig~video-gfx-merge-kconfig-menus drivers/char/drm/Kconfig
--- a/drivers/char/drm/Kconfig~video-gfx-merge-kconfig-menus
+++ a/drivers/char/drm/Kconfig
@@ -4,7 +4,7 @@
 # This driver provides support for the
 # Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
 #
-config DRM
+menuconfig DRM
 	tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)"
 	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG
 	help
diff -puN drivers/video/Kconfig~video-gfx-merge-kconfig-menus drivers/video/Kconfig
--- a/drivers/video/Kconfig~video-gfx-merge-kconfig-menus
+++ a/drivers/video/Kconfig
@@ -5,8 +5,9 @@
 menu "Graphics support"
 	depends on HAS_IOMEM
 
-source "drivers/video/backlight/Kconfig"
-source "drivers/video/display/Kconfig"
+source "drivers/char/agp/Kconfig"
+
+source "drivers/char/drm/Kconfig"
 
 config VGASTATE
        tristate
@@ -19,7 +20,7 @@ config VIDEO_OUTPUT_CONTROL
 	  This framework adds support for low-level control of the video 
 	  output switch.
 
-config FB
+menuconfig FB
 	tristate "Support for frame buffer devices"
 	---help---
 	  The frame buffer device provides an abstraction for the graphics
@@ -1896,6 +1897,9 @@ if ARCH_OMAP
 	source "drivers/video/omap/Kconfig"
 endif
 
+source "drivers/video/backlight/Kconfig"
+source "drivers/video/display/Kconfig"
+
 if VT
 	source "drivers/video/console/Kconfig"
 endif
@@ -1905,4 +1909,3 @@ if FB || SGI_NEWPORT_CONSOLE
 endif
 
 endmenu
-
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
dontdiff-update-based-on-gitignore-updates.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
remap_file_pages-kernel-doc-corrections.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch

From: akpm@linux-foundation.org
Subject: + video-gfx-merge-kconfig-menus.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:53:05 -0700
Message-ID: <200710032053.l93Kr6DR008075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48143 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbXJCUxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:53:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@gmail.com, airlied@linux.ie


The patch titled
     video gfx: merge kconfig menus
has been added to the -mm tree.  Its filename is
     video-gfx-merge-kconfig-menus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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


diff -puN drivers/char/Kconfig~video-gfx-merge-kconfig-menus drivers/char/Kconfig
--- a/drivers/char/Kconfig~video-gfx-merge-kconfig-menus
+++ a/drivers/char/Kconfig
@@ -925,10 +925,6 @@ config GPIO_TB0219
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
@@ -18,7 +19,7 @@ config VIDEO_OUTPUT_CONTROL
 	  This framework adds support for low-level control of the video 
 	  output switch.
 
-config FB
+menuconfig FB
 	tristate "Support for frame buffer devices"
 	---help---
 	  The frame buffer device provides an abstraction for the graphics
@@ -1895,6 +1896,9 @@ if ARCH_OMAP
 	source "drivers/video/omap/Kconfig"
 endif
 
+source "drivers/video/backlight/Kconfig"
+source "drivers/video/display/Kconfig"
+
 if VT
 	source "drivers/video/console/Kconfig"
 endif
@@ -1904,4 +1908,3 @@ if FB || SGI_NEWPORT_CONSOLE
 endif
 
 endmenu
-
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
menuconfig-distinguish-between-selected-by-another-options-and-comments.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
kgdb-fix-help-text.patch
kgdb-fix-docbook-and-kernel-doc-typos.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
video-gfx-merge-kconfig-menus.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch

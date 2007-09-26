From: akpm@linux-foundation.org
Subject: + video-gfx-fix-menu-ordering.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:47:36 -0700
Message-ID: <200709262047.l8QKlaTR003137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761641AbXIZUsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@pol.net


The patch titled
     video gfx: fix menu ordering
has been added to the -mm tree.  Its filename is
     video-gfx-fix-menu-ordering.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: video gfx: fix menu ordering
From: Randy Dunlap <randy.dunlap@oracle.com>

Move video graphics driver configs to fix menus:

Fix FB_PMAGB_B to depend on FB so that the FB menus remain
  listed in order and indented correctly.
Fix FB_IBM_GXT4500 to depend on FB so that the FB menus remain
  listed in order and indented correctly.
The OMAP FB drivers still muck up the FB menu a bit, so I put
  OMAP drivers at the end of the FB menu.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/Kconfig~video-gfx-fix-menu-ordering drivers/video/Kconfig
--- a/drivers/video/Kconfig~video-gfx-fix-menu-ordering
+++ a/drivers/video/Kconfig
@@ -1635,7 +1635,7 @@ config FB_PMAG_BA
 
 config FB_PMAGB_B
 	tristate "PMAGB-B TURBOchannel framebuffer support"
-	depends on TC
+	depends on FB && TC
  	select FB_CFB_FILLRECT
  	select FB_CFB_COPYAREA
  	select FB_CFB_IMAGEBLIT
@@ -1803,7 +1803,7 @@ config FB_PNX4008_DUM_RGB
 
 config FB_IBM_GXT4500
 	tristate "Framebuffer support for IBM GXT4500P adaptor"
-	depends on PPC
+	depends on FB && PPC
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1843,10 +1843,6 @@ config FB_XILINX
 	  framebuffer. ML300 carries a 640*480 LCD display on the board,
 	  ML403 uses a standard DB15 VGA connector.
 
-if ARCH_OMAP
-	source "drivers/video/omap/Kconfig"
-endif
-
 config FB_VIRTUAL
 	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
 	depends on FB
@@ -1870,6 +1866,10 @@ config FB_VIRTUAL
 
 	  If unsure, say N.
 
+if ARCH_OMAP
+	source "drivers/video/omap/Kconfig"
+endif
+
 if VT
 	source "drivers/video/console/Kconfig"
 endif
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
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
profile-likely-unlikely-macros.patch

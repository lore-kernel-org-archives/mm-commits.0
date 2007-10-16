From: akpm@linux-foundation.org
Subject: - video-gfx-fix-menu-ordering.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:50 -0700
Message-ID: <200710162044.l9GKio0P016200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933949AbXJPVHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     video gfx: fix menu ordering
has been removed from the -mm tree.  Its filename was
     video-gfx-fix-menu-ordering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/video/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/Kconfig~video-gfx-fix-menu-ordering drivers/video/Kconfig
--- a/drivers/video/Kconfig~video-gfx-fix-menu-ordering
+++ a/drivers/video/Kconfig
@@ -1820,7 +1820,7 @@ config FB_PNX4008_DUM_RGB
 
 config FB_IBM_GXT4500
 	tristate "Framebuffer support for IBM GXT4500P adaptor"
-	depends on PPC
+	depends on FB && PPC
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1860,10 +1860,6 @@ config FB_XILINX
 	  framebuffer. ML300 carries a 640*480 LCD display on the board,
 	  ML403 uses a standard DB15 VGA connector.
 
-if ARCH_OMAP
-	source "drivers/video/omap/Kconfig"
-endif
-
 config FB_VIRTUAL
 	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
 	depends on FB
@@ -1887,6 +1883,10 @@ config FB_VIRTUAL
 
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

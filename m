From: akpm@linux-foundation.org
Subject: - fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:19 -0700
Message-ID: <200710301806.l9UI6JKO020508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbXJ3SHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fb menu: fix FB_OMAP dependencies so that menu is displayed correctly
has been removed from the -mm tree.  Its filename was
     fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fb menu: fix FB_OMAP dependencies so that menu is displayed correctly
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix FB_OMAP dependencies so that the OMAP FB driver options are presented
correctly.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig      |    4 +---
 drivers/video/omap/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/Kconfig~fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed drivers/video/Kconfig
--- a/drivers/video/Kconfig~fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed
+++ a/drivers/video/Kconfig
@@ -1892,9 +1892,7 @@ config FB_VIRTUAL
 
 	  If unsure, say N.
 
-if ARCH_OMAP
-	source "drivers/video/omap/Kconfig"
-endif
+source "drivers/video/omap/Kconfig"
 
 source "drivers/video/backlight/Kconfig"
 source "drivers/video/display/Kconfig"
diff -puN drivers/video/omap/Kconfig~fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed drivers/video/omap/Kconfig
--- a/drivers/video/omap/Kconfig~fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed
+++ a/drivers/video/omap/Kconfig
@@ -1,6 +1,6 @@
 config FB_OMAP
 	tristate "OMAP frame buffer support (EXPERIMENTAL)"
-	depends on FB
+	depends on FB && ARCH_OMAP
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch

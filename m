From: akpm@linux-foundation.org
Subject: + fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:37:40 -0700
Message-ID: <200710240637.l9O6be2t026704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbXJXGhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@pol.net


The patch titled
     fb menu: fix FB_OMAP dependencies so that menu is displayed correctly
has been added to the -mm tree.  Its filename is
     fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed.patch
git-mtd.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
move-kprobes-examples-to-samples-resend.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch

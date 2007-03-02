From: akpm@linux-foundation.org
Subject: - ps3-introduce-config_ps3_advanced.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:11 -0800
Message-ID: <200703020507.l2257BKe000859@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42411 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422772AbXCBFHn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, geoffrey.levand@am.sony.com, paulus@samba.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ps3: introduce CONFIG_PS3_ADVANCED
has been removed from the -mm tree.  Its filename was
     ps3-introduce-config_ps3_advanced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3: introduce CONFIG_PS3_ADVANCED
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3: Introduce CONFIG_PS3_ADVANCED, as suggested by Roman Zippel, and use
it to control questions about PS3 subsystems that may not be obvious for
the casual user.

This gets rid of the following warning on non-powerpc platforms: |
drivers/video/Kconfig:1604:warning: 'select' used by config symbol 'FB_PS3'
refer to undefined symbol 'PS3_PS3AV'

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/ps3/Kconfig |   28 ++++++++++++++++++++-------
 drivers/video/Kconfig              |    3 --
 2 files changed, 22 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/platforms/ps3/Kconfig~ps3-introduce-config_ps3_advanced arch/powerpc/platforms/ps3/Kconfig
--- a/arch/powerpc/platforms/ps3/Kconfig~ps3-introduce-config_ps3_advanced
+++ a/arch/powerpc/platforms/ps3/Kconfig
@@ -1,9 +1,24 @@
 menu "PS3 Platform Options"
 	depends on PPC_PS3
 
+config PS3_ADVANCED
+	depends on PPC_PS3
+	bool "PS3 Advanced configuration options"
+	help
+	  This gives you access to some advanced options for the PS3. The
+	  defaults should be fine for most users, but these options may make
+	  it possible to better control the kernel configuration if you know
+	  what you are doing.
+
+	  Note that the answer to this question won't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about these options.
+
+	  Most users should say N to this question.
+
 config PS3_HTAB_SIZE
 	depends on PPC_PS3
-	int "PS3 Platform pagetable size"
+	int "PS3 Platform pagetable size" if PS3_ADVANCED
 	range 18 20
 	default 20
 	help
@@ -42,7 +57,7 @@ config PS3_USE_LPAR_ADDR
 
 config PS3_VUART
 	depends on PPC_PS3
-	bool "PS3 Virtual UART support"
+	bool "PS3 Virtual UART support" if PS3_ADVANCED
 	default y
 	help
 	  Include support for the PS3 Virtual UART.
@@ -52,9 +67,8 @@ config PS3_VUART
 	  general, all users will say Y.
 
 config PS3_PS3AV
-	tristate "PS3 AV settings driver"
-	depends on PPC_PS3
-	select PS3_VUART
+	tristate "PS3 AV settings driver" if PS3_ADVANCED
+	depends on PS3_VUART
 	default y
 	help
 	  Include support for the PS3 AV Settings driver.
@@ -63,8 +77,8 @@ config PS3_PS3AV
 	  general, all users will say Y or M.
 
 config PS3_SYS_MANAGER
-	bool "PS3 System Manager driver"
-	select PS3_VUART
+	bool "PS3 System Manager driver" if PS3_ADVANCED
+	depends on PS3_VUART
 	default y
 	help
 	  Include support for the PS3 System Manager.
diff -puN drivers/video/Kconfig~ps3-introduce-config_ps3_advanced drivers/video/Kconfig
--- a/drivers/video/Kconfig~ps3-introduce-config_ps3_advanced
+++ a/drivers/video/Kconfig
@@ -1618,8 +1618,7 @@ config FB_IBM_GXT4500
 
 config FB_PS3
 	bool "PS3 GPU framebuffer driver"
-	depends on FB && PPC_PS3
-	select PS3_PS3AV
+	depends on FB && PS3_PS3AV
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3fb-thread-updates.patch
ps3fb-thread-updates-update.patch
ps3fb-thread-updates-2.patch
ps3fb-thread-updates-42.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3fb-atomic-fixes.patch
ps3av-misc-updates.patch

From: akpm@linux-foundation.org
Subject: + fix-font-dependency-for-sgi-newport-console-driver.patch added to -mm tree
Date: Wed, 22 Aug 2007 16:06:08 -0700
Message-ID: <200708222306.l7MN68vH009517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758288AbXHVXGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 19:06:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, adaplas@pol.net


The patch titled
     Fix font dependency for SGI Newport console driver
has been added to the -mm tree.  Its filename is
     fix-font-dependency-for-sgi-newport-console-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix font dependency for SGI Newport console driver
From: Ralf Baechle <ralf@linux-mips.org>

We better select a font when the newport driver is a module or the user
experience might suffer.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/Kconfig~fix-font-dependency-for-sgi-newport-console-driver drivers/video/console/Kconfig
--- a/drivers/video/console/Kconfig~fix-font-dependency-for-sgi-newport-console-driver
+++ a/drivers/video/console/Kconfig
@@ -182,7 +182,7 @@ config FONT_8x8
 
 config FONT_8x16
 	bool "VGA 8x16 font" if FONTS
-	depends on FRAMEBUFFER_CONSOLE || SGI_NEWPORT_CONSOLE=y || STI_CONSOLE || USB_SISUSBVGA_CON 
+	depends on FRAMEBUFFER_CONSOLE || SGI_NEWPORT_CONSOLE || STI_CONSOLE || USB_SISUSBVGA_CON
 	default y if !SPARC && !FONTS
 	help
 	  This is the "high resolution" font for the VGA frame buffer (the one
_

Patches currently in -mm which might be from ralf@linux-mips.org are

serial_txx9-fix-modem-control-line-handling.patch
newport_con-warning-fix.patch
au1100fb-move-au1100fb_fb_blank-beforce.patch
fix-font-dependency-for-sgi-newport-console-driver.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-irix_getcontext-will-always-fail-efault.patch
git-mtd.patch
git-netdev-all.patch
dont-use-gfp_dma-for-zone-allocation.patch
sgiseeq-fix-return-type-of-sgiseeq_remove.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
serio-fix-modpost-warning.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
define-global-bit-macro.patch

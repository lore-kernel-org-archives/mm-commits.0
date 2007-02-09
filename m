From: akpm@linux-foundation.org
Subject: + ps3-ps3av-fb-defconfig-updates.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:26:53 -0800
Message-ID: <200702090926.l199QrDd009519@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946261AbXBIJ1s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:27:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, jsimmons@infradead.org, paulus@samba.org


The patch titled
     ps3: ps3av/fb defconfig updates
has been added to the -mm tree.  Its filename is
     ps3-ps3av-fb-defconfig-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3: ps3av/fb defconfig updates
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

PS3: defconfig updates for ps3av and ps3fb

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/configs/ps3_defconfig |   29 ++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/configs/ps3_defconfig~ps3-ps3av-fb-defconfig-updates arch/powerpc/configs/ps3_defconfig
--- a/arch/powerpc/configs/ps3_defconfig~ps3-ps3av-fb-defconfig-updates
+++ a/arch/powerpc/configs/ps3_defconfig
@@ -163,6 +163,7 @@ CONFIG_PS3_HTAB_SIZE=20
 # CONFIG_PS3_DYNAMIC_DMA is not set
 CONFIG_PS3_USE_LPAR_ADDR=y
 CONFIG_PS3_VUART=y
+CONFIG_PS3_PS3AV=y
 
 #
 # Kernel options
@@ -611,14 +612,40 @@ CONFIG_GEN_RTC=y
 # Graphics support
 #
 # CONFIG_FIRMWARE_EDID is not set
-# CONFIG_FB is not set
+CONFIG_FB=y
+CONFIG_FB_CFB_FILLRECT=y
+CONFIG_FB_CFB_COPYAREA=y
+CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
+# CONFIG_FB_MODE_HELPERS is not set
+# CONFIG_FB_TILEBLITTING is not set
+# CONFIG_FB_OF is not set
+# CONFIG_FB_VGA16 is not set
+# CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_IBM_GXT4500 is not set
+CONFIG_FB_PS3=y
+CONFIG_FB_PS3_DEFAULT_SIZE_M=18
+# CONFIG_FB_VIRTUAL is not set
 
 #
 # Console display driver support
 #
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
+# CONFIG_FONTS is not set
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+
+#
+# Logo configuration
+#
+CONFIG_LOGO=y
+# CONFIG_LOGO_LINUX_MONO is not set
+# CONFIG_LOGO_LINUX_VGA16 is not set
+CONFIG_LOGO_LINUX_CLUT224=y
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3-add-shutdown-to-virtual-uart-port-driver-framework.patch
ps3-av-settings-driver.patch
fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch
fbdev-modedb-make-more-pointer-parameters-const.patch
fb_videomode_to_var-reset-virtual-screen-parameters.patch
ps3-preallocate-bootmem-memory-for-ps3fb.patch
ps3-virtual-frame-buffer-driver.patch
ps3-disable-display-flipping-during-mode-changes.patch
ps3-cleanup-ps3fb-before-clearing-hpte.patch
ps3-ps3av-fb-defconfig-updates.patch

From: akpm@linux-foundation.org
Subject: - ps3-ps3av-fb-defconfig-updates.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:50:32 -0800
Message-ID: <200702122250.l1CMoWge014230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45856 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030416AbXBLWvB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:51:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3: ps3av/fb defconfig updates
has been removed from the -mm tree.  Its filename was
     ps3-ps3av-fb-defconfig-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

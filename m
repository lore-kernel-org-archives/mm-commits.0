From: akpm@linux-foundation.org
Subject: - viafb-makefile-kconfig.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:18 -0700
Message-ID: <200810182316.m9INGIxD028791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbYJRXQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: Makefile, Kconfig
has been removed from the -mm tree.  Its filename was
     viafb-makefile-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: Makefile, Kconfig
From: Joseph Chan <JosephChan@via.com.tw>

Modified drivers/video/Makefile and drivers/video/Kconfig.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig  |   18 ++++++++++++++++++
 drivers/video/Makefile |    1 +
 2 files changed, 19 insertions(+)

diff -puN drivers/video/Kconfig~viafb-makefile-kconfig drivers/video/Kconfig
--- a/drivers/video/Kconfig~viafb-makefile-kconfig
+++ a/drivers/video/Kconfig
@@ -1492,6 +1492,24 @@ config FB_SIS_315
 	  (315/H/PRO, 55x, 650, 651, 740, 330, 661, 741, 760, 761) as well
 	  as XGI V3XT, V5, V8 and Z7.
 
+config FB_VIA
+       tristate "VIA UniChrome (Pro) and Chrome9 display support"
+       depends on FB && PCI
+       select FB_CFB_FILLRECT
+       select FB_CFB_COPYAREA
+       select FB_CFB_IMAGEBLIT
+       select FB_SOFT_CURSOR
+       select I2C_ALGOBIT
+       select I2C
+       help
+	  This is the frame buffer device driver for Graphics chips of VIA
+	  UniChrome (Pro) Family (CLE266,PM800/CN400,P4M800CE/P4M800Pro/
+	  CN700/VN800,CX700/VX700,P4M890) and Chrome9 Family (K8M890,CN896
+ 	  /P4M900,VX800)
+	  Say Y if you have a VIA UniChrome graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called viafb.
 config FB_NEOMAGIC
 	tristate "NeoMagic display support"
 	depends on FB && PCI
diff -puN drivers/video/Makefile~viafb-makefile-kconfig drivers/video/Makefile
--- a/drivers/video/Makefile~viafb-makefile-kconfig
+++ a/drivers/video/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_FB_ATY)		  += aty/ macmodes
 obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_RADEON)		  += aty/
 obj-$(CONFIG_FB_SIS)		  += sis/
+obj-$(CONFIG_FB_VIA)		  += via/
 obj-$(CONFIG_FB_KYRO)             += kyro/
 obj-$(CONFIG_FB_SAVAGE)		  += savage/
 obj-$(CONFIG_FB_GEODE)		  += geode/
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

origin.patch


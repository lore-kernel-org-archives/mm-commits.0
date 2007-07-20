From: akpm@linux-foundation.org
Subject: + stradis-and-zoran-depend-on-virt_to_bus.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:16:43 -0700
Message-ID: <200707200616.l6K6GhkE011040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198AbXGTGRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, mchehab@infradead.org


The patch titled
     stradis and zoran depend on virt_to_bus
has been added to the -mm tree.  Its filename is
     stradis-and-zoran-depend-on-virt_to_bus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: stradis and zoran depend on virt_to_bus
From: Stephen Rothwell <sfr@canb.auug.org.au>

I assume that is why they were marked as !PPC64.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/Kconfig~stradis-and-zoran-depend-on-virt_to_bus drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~stradis-and-zoran-depend-on-virt_to_bus
+++ a/drivers/media/video/Kconfig
@@ -509,7 +509,7 @@ config VIDEO_VINO
 
 config VIDEO_STRADIS
 	tristate "Stradis 4:2:2 MPEG-2 video driver  (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PCI && VIDEO_V4L1 && !PPC64
+	depends on EXPERIMENTAL && PCI && VIDEO_V4L1 && VIRT_TO_BUS
 	help
 	  Say Y here to enable support for the Stradis 4:2:2 MPEG-2 video
 	  driver for PCI.  There is a product page at
@@ -520,7 +520,7 @@ config VIDEO_ZORAN_ZR36060
 
 config VIDEO_ZORAN
 	tristate "Zoran ZR36057/36067 Video For Linux"
-	depends on PCI && I2C_ALGOBIT && VIDEO_V4L1 && !PPC64
+	depends on PCI && I2C_ALGOBIT && VIDEO_V4L1 && VIRT_TO_BUS
 	help
 	  Say Y for support for MJPEG capture cards based on the Zoran
 	  36057/36067 PCI controller chipset. This includes the Iomega
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
dpt_i2o-depends-on-virt_to_bus.patch
toshiba_fir-depends-on-virt_to_bus.patch
stradis-and-zoran-depend-on-virt_to_bus.patch
git-kbuild.patch

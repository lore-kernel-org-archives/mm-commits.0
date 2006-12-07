From: akpm@osdl.org
Subject: - winbond-ide-depends-on-idedma.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:46 -0800
Message-ID: <200612072315.kB7NFkmF030749@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53568 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163810AbWLGXPy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:15:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     winbond IDE depends on IDEDMA
has been removed from the -mm tree.  Its filename was
     winbond-ide-depends-on-idedma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: winbond IDE depends on IDEDMA
From: Olaf Hering <olaf@aepfle.de>

winbond ide depends on idedma.
Move the option into the IDEDMA section.

drivers/built-in.o: In function `.sl82c105_ide_dma_timeout':
sl82c105.c:(.text+0x624d0): undefined reference to `.__ide_dma_timeout'
drivers/built-in.o: In function `.sl82c105_ide_dma_off_quietly':
sl82c105.c:(.text+0x6274c): undefined reference to `.__ide_dma_off_quietly'
drivers/built-in.o: In function `.sl82c105_ide_dma_on':
sl82c105.c:(.text+0x6284c): undefined reference to `.__ide_dma_on'
drivers/built-in.o: In function `.sl82c105_check_drive':
sl82c105.c:(.text+0x628ec): undefined reference to `.__ide_dma_bad_drive'
sl82c105.c:(.text+0x62934): undefined reference to `.__ide_dma_good_drive'
drivers/built-in.o: In function `.sl82c105_ide_dma_start':
sl82c105.c:(.text+0x62c24): undefined reference to `.ide_dma_start'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Acked-by: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/ide/Kconfig~winbond-ide-depends-on-idedma drivers/ide/Kconfig
--- a/drivers/ide/Kconfig~winbond-ide-depends-on-idedma
+++ a/drivers/ide/Kconfig
@@ -389,14 +389,6 @@ config BLK_DEV_RZ1000
 	  Linux. This may slow disk throughput by a few percent, but at least
 	  things will operate 100% reliably.
 
-config BLK_DEV_SL82C105
-	tristate "Winbond SL82c105 support"
-	depends on PCI && (PPC || ARM) && BLK_DEV_IDEPCI
-	help
-	  If you have a Winbond SL82c105 IDE controller, say Y here to enable
-	  special configuration for this chip. This is common on various CHRP
-	  motherboards, but could be used elsewhere. If in doubt, say Y.
-
 config BLK_DEV_IDEDMA_PCI
 	bool "Generic PCI bus-master DMA support"
 	depends on PCI && BLK_DEV_IDEPCI
@@ -712,6 +704,14 @@ config BLK_DEV_SIS5513
 
 	  Please read the comments at the top of <file:drivers/ide/pci/sis5513.c>.
 
+config BLK_DEV_SL82C105
+	tristate "Winbond SL82c105 support"
+	depends on (PPC || ARM)
+	help
+	  If you have a Winbond SL82c105 IDE controller, say Y here to enable
+	  special configuration for this chip. This is common on various CHRP
+	  motherboards, but could be used elsewhere. If in doubt, say Y.
+
 config BLK_DEV_SLC90E66
 	tristate "SLC90E66 chipset support"
 	help
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
git-alsa.patch
git-ieee1394.patch


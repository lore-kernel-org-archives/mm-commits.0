From: akpm@linux-foundation.org
Subject: - blk_dev_ide_celleb-dependency-fix.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:38:09 -0800
Message-ID: <200703152138.l2FLc9ts026975@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41431 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbXCOViQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:38:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akira2.iguchi@toshiba.co.jp, bzolnier@gmail.com, kou.ishizaki@toshiba.co.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     BLK_DEV_IDE_CELLEB dependency fix
has been removed from the -mm tree.  Its filename was
     blk_dev_ide_celleb-dependency-fix.patch

This patch was dropped because it got rejects

------------------------------------------------------
Subject: BLK_DEV_IDE_CELLEB dependency fix
From: Akira Iguchi <akira2.iguchi@toshiba.co.jp>

It's bool and it depends on BLK_DEV_IDE
 => should depend on BLK_DEV_IDE=y

And move it to "if BLK_DEV_IDEDMA_PCI" block because it depends on
BLK_DEV_IDEDMA_PCI.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/ide/Kconfig~blk_dev_ide_celleb-dependency-fix drivers/ide/Kconfig
--- a/drivers/ide/Kconfig~blk_dev_ide_celleb-dependency-fix
+++ a/drivers/ide/Kconfig
@@ -783,6 +783,14 @@ config BLK_DEV_TC86C001
 	help
 	This driver adds support for Toshiba TC86C001 GOKU-S chip.
 
+config BLK_DEV_IDE_CELLEB
+	bool "Toshiba's Cell Reference Set IDE support"
+	depends on PPC_CELLEB && BLK_DEV_IDE=y
+	help
+	  This driver provides support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+	  If unsure, say Y.
+
 endif
 
 config BLK_DEV_IDE_PMAC
@@ -814,14 +822,6 @@ config BLK_DEV_IDEDMA_PMAC
 	  to transfer data to and from memory.  Saying Y is safe and improves
 	  performance.
 
-config BLK_DEV_IDE_CELLEB
-	bool "Toshiba's Cell Reference Set IDE support"
-	depends on PPC_CELLEB
-	help
-	  This driver provides support for the built-in IDE controller on
-	  Toshiba Cell Reference Board.
-	  If unsure, say Y.
-
 config BLK_DEV_IDE_SWARM
 	tristate "IDE for Sibyte evaluation boards"
 	depends on SIBYTE_SB1xxx_SOC
_

Patches currently in -mm which might be from akira2.iguchi@toshiba.co.jp are

blk_dev_ide_celleb-dependency-fix.patch

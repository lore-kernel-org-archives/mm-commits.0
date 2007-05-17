From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ide.patch removed from -mm tree
Date: Wed, 16 May 2007 20:47:35 -0700
Message-ID: <200705170347.l4H3lYLn016520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296AbXEQDuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 23:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, bzolnier@gmail.com, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: IDE
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ide.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: IDE
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/Kconfig |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/ide/Kconfig~use-menuconfig-objects-ide drivers/ide/Kconfig
--- a/drivers/ide/Kconfig~use-menuconfig-objects-ide
+++ a/drivers/ide/Kconfig
@@ -4,13 +4,10 @@
 # Andre Hedrick <andre@linux-ide.org>
 #
 
-if BLOCK
-
-menu "ATA/ATAPI/MFM/RLL support"
-	depends on HAS_IOMEM
-
-config IDE
+menuconfig IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
+	depends on BLOCK
+	depends on HAS_IOMEM
 	---help---
 	  If you say Y here, your kernel will be able to manage low cost mass
 	  storage units such as ATA/(E)IDE and ATAPI units. The most common
@@ -1099,8 +1096,4 @@ config BLK_DEV_HD_ONLY
 config BLK_DEV_HD
 	def_bool BLK_DEV_HD_IDE || BLK_DEV_HD_ONLY
 
-endif
-
-endmenu
-
-endif
+endif # IDE
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-ii-sound.patch
git-ieee1394.patch
use-menuconfig-objects-ii-infiniband.patch
use-menuconfig-objects-ii-kvm-virt.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-usb.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
use-menuconfig-objects-ii-isdn.patch
use-menuconfig-objects-ii-md.patch

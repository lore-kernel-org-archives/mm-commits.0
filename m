From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ide.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:47:59 -0700
Message-ID: <200704122247.l3CMlxNc018722@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35532 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbXDLWsM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, bzolnier@gmail.com, jengelh@gmx.de


The patch titled
     Use menuconfig objects: IDE
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ide.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: IDE
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/Kconfig |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/ide/Kconfig~use-menuconfig-objects-ide drivers/ide/Kconfig
--- a/drivers/ide/Kconfig~use-menuconfig-objects-ide
+++ a/drivers/ide/Kconfig
@@ -4,12 +4,9 @@
 # Andre Hedrick <andre@linux-ide.org>
 #
 
-if BLOCK
-
-menu "ATA/ATAPI/MFM/RLL support"
-
-config IDE
+menuconfig IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
+	depends on BLOCK
 	---help---
 	  If you say Y here, your kernel will be able to manage low cost mass
 	  storage units such as ATA/(E)IDE and ATAPI units. The most common
@@ -1097,8 +1094,4 @@ config BLK_DEV_HD_ONLY
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

git-kbuild.patch
remove-artificial-software-max_loop-limit.patch
fix-kevents-childs-priority-greediness.patch
vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
vt-add-color-support-to-the-underline-and-italic-attributes.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-mtd.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pcihotplug.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch

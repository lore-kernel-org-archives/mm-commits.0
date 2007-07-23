From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-fusion.patch added to -mm tree
Date: Mon, 23 Jul 2007 15:41:17 -0700
Message-ID: <200707232241.l6NMfHEL015793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbXGWWlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 18:41:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de, Eric.Moore@lsil.com, jengelh@gmx.de


The patch titled
     Use menuconfig objects: Fusion
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-fusion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: Fusion
From: Jan Engelhardt <jengelh@computergmbh.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/Kconfig |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/message/fusion/Kconfig~use-menuconfig-objects-fusion drivers/message/fusion/Kconfig
--- a/drivers/message/fusion/Kconfig~use-menuconfig-objects-fusion
+++ a/drivers/message/fusion/Kconfig
@@ -1,15 +1,19 @@
 
-menu "Fusion MPT device support"
+menuconfig FUSION
+	bool "Fusion MPT device support"
 	depends on PCI
+	---help---
+	Say Y here to get to see options for Fusion Message
+	Passing Technology (MPT) drivers.
+	This option alone does not add any kernel code.
+
+	If you say N, all options in this submenu will be skipped and disabled.
 
-config FUSION
-	bool
-	default n
+if FUSION
 
 config FUSION_SPI
 	tristate "Fusion MPT ScsiHost drivers for SPI"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_SPI_ATTRS
 	---help---
 	  SCSI HOST support for a parallel SCSI host adapters.
@@ -24,7 +28,6 @@ config FUSION_SPI
 config FUSION_FC
 	tristate "Fusion MPT ScsiHost drivers for FC"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_FC_ATTRS
 	---help---
 	  SCSI HOST support for a Fiber Channel host adapters.
@@ -42,7 +45,6 @@ config FUSION_FC
 config FUSION_SAS
 	tristate "Fusion MPT ScsiHost drivers for SAS"
 	depends on PCI && SCSI
- 	select FUSION
 	select SCSI_SAS_ATTRS
 	---help---
 	  SCSI HOST support for a SAS host adapters.
@@ -56,7 +58,6 @@ config FUSION_SAS
 
 config FUSION_MAX_SGE
 	int "Maximum number of scatter gather entries (16 - 128)"
-	depends on FUSION
 	default "128"
 	range 16 128
 	help
@@ -102,4 +103,4 @@ config FUSION_LAN
 
 	  If unsure whether you really want or need this, say N.
 
-endmenu
+endif # FUSION
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

use-menuconfig-objects-fusion.patch
use-menuconfig-objects-rtc.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch

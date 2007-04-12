From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-oldcd.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:48:26 -0700
Message-ID: <200704122248.l3CMmQcU018749@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35605 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXDLWsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, jens.axboe@oracle.com


The patch titled
     Use menuconfig objects: oldcd
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-oldcd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: oldcd
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/Kconfig |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff -puN drivers/cdrom/Kconfig~use-menuconfig-objects-oldcd drivers/cdrom/Kconfig
--- a/drivers/cdrom/Kconfig~use-menuconfig-objects-oldcd
+++ a/drivers/cdrom/Kconfig
@@ -2,11 +2,9 @@
 # CDROM driver configuration
 #
 
-menu "Old CD-ROM drivers (not SCSI, not IDE)"
+menuconfig CD_NO_IDESCSI
+	bool "Old CD-ROM drivers (not SCSI, not IDE)"
 	depends on ISA && BLOCK
-
-config CD_NO_IDESCSI
-	bool "Support non-SCSI/IDE/ATAPI CDROM drives"
 	---help---
 	  If you have a CD-ROM drive that is neither SCSI nor IDE/ATAPI, say Y
 	  here, otherwise N. Read the CD-ROM-HOWTO, available from
@@ -31,9 +29,10 @@ config CD_NO_IDESCSI
 	  answer will get "defaulted" for you if you enable any of the Linux
 	  CD-ROM drivers).
 
+if CD_NO_IDESCSI
+
 config AZTCD
 	tristate "Aztech/Orchid/Okano/Wearnes/TXC/CyDROM  CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  This is your driver if you have an Aztech CDA268-01A, Orchid
 	  CD-3110, Okano or Wearnes CDD110, Conrad TXC, or CyCD-ROM CR520 or
@@ -51,7 +50,6 @@ config AZTCD
 
 config GSCD
 	tristate "Goldstar R420 CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  If this is your CD-ROM drive, say Y here.  As described in the file
 	  <file:Documentation/cdrom/gscd>, you might have to change a setting
@@ -67,7 +65,7 @@ config GSCD
 
 config SBPCD
 	tristate "Matsushita/Panasonic/Creative, Longshine, TEAC CDROM support"
-	depends on CD_NO_IDESCSI && BROKEN_ON_SMP
+	depends on BROKEN_ON_SMP
 	---help---
 	  This driver supports most of the drives which use the Panasonic or
 	  Sound Blaster interface.  Please read the file
@@ -105,7 +103,6 @@ config SBPCD
 
 config MCDX
 	tristate "Mitsumi CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  Use this driver if you want to be able to use your Mitsumi LU-005,
 	  FX-001 or FX-001D CD-ROM drive.
@@ -121,7 +118,6 @@ config MCDX
 
 config OPTCD
 	tristate "Optics Storage DOLPHIN 8000AT CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  This is the driver for the 'DOLPHIN' drive with a 34-pin Sony
 	  compatible interface. It also works with the Lasermate CR328A. If
@@ -138,7 +134,7 @@ config OPTCD
 
 config CM206
 	tristate "Philips/LMS CM206 CDROM support"
-	depends on CD_NO_IDESCSI && BROKEN_ON_SMP
+	depends on BROKEN_ON_SMP
 	---help---
 	  If you have a Philips/LMS CD-ROM drive cm206 in combination with a
 	  cm260 host adapter card, say Y here. Please also read the file
@@ -153,7 +149,6 @@ config CM206
 
 config SJCD
 	tristate "Sanyo CDR-H94A CDROM support"
-	depends on CD_NO_IDESCSI
 	help
 	  If this is your CD-ROM drive, say Y here and read the file
 	  <file:Documentation/cdrom/sjcd>. You should then also say Y or M to
@@ -165,7 +160,6 @@ config SJCD
 
 config ISP16_CDI
 	tristate "ISP16/MAD16/Mozart soft configurable cdrom interface support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  These are sound cards with built-in cdrom interfaces using the OPTi
 	  82C928 or 82C929 chips. Say Y here to have them detected and
@@ -178,7 +172,7 @@ config ISP16_CDI
 
 config CDU31A
 	tristate "Sony CDU31A/CDU33A CDROM support"
-	depends on CD_NO_IDESCSI && BROKEN_ON_SMP
+	depends on BROKEN_ON_SMP
 	---help---
 	  These CD-ROM drives have a spring-pop-out caddyless drawer, and a
 	  rectangular green LED centered beneath it.  NOTE: these CD-ROM
@@ -198,7 +192,6 @@ config CDU31A
 
 config CDU535
 	tristate "Sony CDU535 CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  This is the driver for the older Sony CDU-535 and CDU-531 CD-ROM
 	  drives. Please read the file <file:Documentation/cdrom/sonycd535>.
@@ -210,4 +203,4 @@ config CDU535
 	  To compile this driver as a module, choose M here: the
 	  module will be called sonycd535.
 
-endmenu
+endif # CD_NO_IDESCSI
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

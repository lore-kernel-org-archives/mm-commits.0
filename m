From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-parport.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:48:28 -0700
Message-ID: <200704122248.l3CMmShQ018752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35601 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXDLWsg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de


The patch titled
     Use menuconfig objects: parport
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-parport.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: parport
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/Kconfig |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff -puN drivers/parport/Kconfig~use-menuconfig-objects-parport drivers/parport/Kconfig
--- a/drivers/parport/Kconfig~use-menuconfig-objects-parport
+++ a/drivers/parport/Kconfig
@@ -5,9 +5,7 @@
 # Parport configuration.
 #
 
-menu "Parallel port support"
-
-config PARPORT
+menuconfig PARPORT
 	tristate "Parallel port support"
 	---help---
 	  If you want to use devices connected to your machine's parallel port
@@ -32,9 +30,11 @@ config PARPORT
 
 	  If unsure, say Y.
 
+if PARPORT
+
 config PARPORT_PC
 	tristate "PC-style hardware"
-	depends on PARPORT && (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV
+	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
@@ -84,7 +84,7 @@ config PARPORT_PC_PCMCIA
 
 config PARPORT_IP32
 	tristate "SGI IP32 builtin port (EXPERIMENTAL)"
-	depends on SGI_IP32 && PARPORT && EXPERIMENTAL
+	depends on SGI_IP32 && EXPERIMENTAL
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port on
@@ -93,7 +93,7 @@ config PARPORT_IP32
 
 config PARPORT_AMIGA
 	tristate "Amiga builtin port"
-	depends on AMIGA && PARPORT
+	depends on AMIGA
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port hardware on
@@ -102,7 +102,7 @@ config PARPORT_AMIGA
 
 config PARPORT_MFC3
 	tristate "Multiface III parallel port"
-	depends on ZORRO && PARPORT
+	depends on ZORRO
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need parallel port support for the MFC3 card.
@@ -111,7 +111,7 @@ config PARPORT_MFC3
 
 config PARPORT_ATARI
 	tristate "Atari hardware"
-	depends on ATARI && PARPORT
+	depends on ATARI
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port hardware on
@@ -121,12 +121,11 @@ config PARPORT_ATARI
 config PARPORT_GSC
 	tristate
 	default GSC
-	depends on PARPORT
 	select PARPORT_NOT_PC
 
 config PARPORT_SUNBPP
 	tristate "Sparc hardware (EXPERIMENTAL)"
-	depends on SBUS && PARPORT && EXPERIMENTAL
+	depends on SBUS && EXPERIMENTAL
 	select PARPORT_NOT_PC
 	help
 	  This driver provides support for the bidirectional parallel port
@@ -135,7 +134,6 @@ config PARPORT_SUNBPP
 
 config PARPORT_AX88796
 	tristate "AX88796 Parallel Port"
-	depends on PARPORT
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port hardware on
@@ -147,7 +145,6 @@ config PARPORT_AX88796
 
 config PARPORT_1284
 	bool "IEEE 1284 transfer modes"
-	depends on PARPORT
 	help
 	  If you have a printer that supports status readback or device ID, or
 	  want to use a device that uses enhanced parallel port transfer modes
@@ -158,5 +155,4 @@ config PARPORT_1284
 config PARPORT_NOT_PC
 	bool
 
-endmenu
-
+endif # PARPORT
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

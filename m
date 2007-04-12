From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-toeknring.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:48:22 -0700
Message-ID: <200704122248.l3CMmM0U018743@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35584 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbXDLWsa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de


The patch titled
     Use menuconfig objects: tokenring
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-toeknring.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: tokenring
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/Kconfig |   33 +++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff -puN drivers/net/tokenring/Kconfig~use-menuconfig-objects-toeknring drivers/net/tokenring/Kconfig
--- a/drivers/net/tokenring/Kconfig~use-menuconfig-objects-toeknring
+++ a/drivers/net/tokenring/Kconfig
@@ -2,12 +2,10 @@
 # Token Ring driver configuration
 #
 
-menu "Token Ring devices"
-	depends on NETDEVICES && !UML
-
 # So far, we only have PCI, ISA, and MCA token ring devices
-config TR
+menuconfig TR
 	bool "Token Ring driver support"
+	depends on NETDEVICES && !UML
 	depends on (PCI || ISA || MCA || CCW)
 	select LLC
 	help
@@ -20,9 +18,11 @@ config TR
 	  from <http://www.tldp.org/docs.html#howto>. Most people can
 	  say N here.
 
+if TR
+
 config IBMTR
 	tristate "IBM Tropic chipset based adapter support"
-	depends on TR && (ISA || MCA)
+	depends on ISA || MCA
 	---help---
 	  This is support for all IBM Token Ring cards that don't use DMA. If
 	  you have such a beast, say Y and read the Token-Ring mini-HOWTO,
@@ -36,7 +36,7 @@ config IBMTR
 
 config IBMOL
 	tristate "IBM Olympic chipset PCI adapter support"
-	depends on TR && PCI
+	depends on PCI
 	---help---
 	  This is support for all non-Lanstreamer IBM PCI Token Ring Cards.
 	  Specifically this is all IBM PCI, PCI Wake On Lan, PCI II, PCI II
@@ -54,7 +54,7 @@ config IBMOL
 
 config IBMLS
 	tristate "IBM Lanstreamer chipset PCI adapter support"
-	depends on TR && PCI && !64BIT
+	depends on PCI && !64BIT
 	help
 	  This is support for IBM Lanstreamer PCI Token Ring Cards.
 
@@ -66,7 +66,7 @@ config IBMLS
 
 config 3C359
 	tristate "3Com 3C359 Token Link Velocity XL adapter support"
-	depends on TR && PCI
+	depends on PCI
 	---help---
 	  This is support for the 3Com PCI Velocity XL cards, specifically
 	  the 3Com 3C359, please note this is not for the 3C339 cards, you
@@ -84,7 +84,7 @@ config 3C359
 
 config TMS380TR
 	tristate "Generic TMS380 Token Ring ISA/PCI adapter support"
-	depends on TR && (PCI || ISA && ISA_DMA_API || MCA)
+	depends on PCI || ISA && ISA_DMA_API || MCA
 	select FW_LOADER
 	---help---
 	  This driver provides generic support for token ring adapters
@@ -108,7 +108,7 @@ config TMS380TR
 
 config TMSPCI
 	tristate "Generic TMS380 PCI support"
-	depends on TR && TMS380TR && PCI
+	depends on TMS380TR && PCI
 	---help---
 	  This tms380 module supports generic TMS380-based PCI cards.
 
@@ -123,7 +123,7 @@ config TMSPCI
 
 config SKISA
 	tristate "SysKonnect TR4/16 ISA support"
-	depends on TR && TMS380TR && ISA
+	depends on TMS380TR && ISA
 	help
 	  This tms380 module supports SysKonnect TR4/16 ISA cards.
 
@@ -135,7 +135,7 @@ config SKISA
 
 config PROTEON
 	tristate "Proteon ISA support"
-	depends on TR && TMS380TR && ISA
+	depends on TMS380TR && ISA
 	help
 	  This tms380 module supports Proteon ISA cards.
 
@@ -148,7 +148,7 @@ config PROTEON
 
 config ABYSS
 	tristate "Madge Smart 16/4 PCI Mk2 support"
-	depends on TR && TMS380TR && PCI
+	depends on TMS380TR && PCI
 	help
 	  This tms380 module supports the Madge Smart 16/4 PCI Mk2
 	  cards (51-02).
@@ -158,7 +158,7 @@ config ABYSS
 
 config MADGEMC
 	tristate "Madge Smart 16/4 Ringnode MicroChannel"
-	depends on TR && TMS380TR && MCA
+	depends on TMS380TR && MCA
 	help
 	  This tms380 module supports the Madge Smart 16/4 MC16 and MC32
 	  MicroChannel adapters.
@@ -168,7 +168,7 @@ config MADGEMC
 
 config SMCTR
 	tristate "SMC ISA/MCA adapter support"
-	depends on TR && (ISA || MCA_LEGACY) && (BROKEN || !64BIT)
+	depends on (ISA || MCA_LEGACY) && (BROKEN || !64BIT)
 	---help---
 	  This is support for the ISA and MCA SMC Token Ring cards,
 	  specifically SMC TokenCard Elite (8115T) and SMC TokenCard Elite/A
@@ -182,5 +182,4 @@ config SMCTR
 	  To compile this driver as a module, choose M here: the module will be
 	  called smctr.
 
-endmenu
-
+endif # TR
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

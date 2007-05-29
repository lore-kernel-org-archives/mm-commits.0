From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-toeknring.patch removed from -mm tree
Date: Tue, 29 May 2007 11:54:53 -0700
Message-ID: <200705291854.l4TIsqQr008556@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761227AbXE2Sz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: tokenring
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-toeknring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

use-menuconfig-objects-acpi.patch
git-hid.patch
use-menuconfig-objects-ii-infiniband.patch
git-kvm.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
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

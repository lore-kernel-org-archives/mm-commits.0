From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-pcihotplug.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:48:30 -0700
Message-ID: <200704122248.l3CMmUoX018755@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35610 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbXDLWsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, kristen.c.accardi@intel.com


The patch titled
     Use menuconfig objects: pcihotplug
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-pcihotplug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: pcihotplug
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/Kconfig |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff -puN drivers/pci/hotplug/Kconfig~use-menuconfig-objects-pcihotplug drivers/pci/hotplug/Kconfig
--- a/drivers/pci/hotplug/Kconfig~use-menuconfig-objects-pcihotplug
+++ a/drivers/pci/hotplug/Kconfig
@@ -2,9 +2,7 @@
 # PCI Hotplug support
 #
 
-menu "PCI Hotplug Support"
-
-config HOTPLUG_PCI
+menuconfig HOTPLUG_PCI
 	tristate "Support for PCI Hotplug (EXPERIMENTAL)"
 	depends on PCI && EXPERIMENTAL && HOTPLUG
 	---help---
@@ -17,9 +15,10 @@ config HOTPLUG_PCI
 
 	  When in doubt, say N.
 
+if HOTPLUG_PCI
+
 config HOTPLUG_PCI_FAKE
 	tristate "Fake PCI Hotplug driver"
-	depends on HOTPLUG_PCI
 	help
 	  Say Y here if you want to use the fake PCI hotplug driver. It can
 	  be used to simulate PCI hotplug events if even if your system is
@@ -42,7 +41,7 @@ config HOTPLUG_PCI_FAKE
 
 config HOTPLUG_PCI_COMPAQ
 	tristate "Compaq PCI Hotplug driver"
-	depends on HOTPLUG_PCI && X86 && PCI_BIOS
+	depends on X86 && PCI_BIOS
 	help
 	  Say Y here if you have a motherboard with a Compaq PCI Hotplug
 	  controller.
@@ -64,7 +63,7 @@ config HOTPLUG_PCI_COMPAQ_NVRAM
 
 config HOTPLUG_PCI_IBM
 	tristate "IBM PCI Hotplug driver"
-	depends on HOTPLUG_PCI && X86_IO_APIC && X86 && PCI_BIOS
+	depends on X86_IO_APIC && X86 && PCI_BIOS
 	help
 	  Say Y here if you have a motherboard with a IBM PCI Hotplug
 	  controller.
@@ -76,7 +75,6 @@ config HOTPLUG_PCI_IBM
 
 config HOTPLUG_PCI_ACPI
 	tristate "ACPI PCI Hotplug driver"
-	depends on HOTPLUG_PCI
 	depends on (!ACPI_DOCK && ACPI) || (ACPI_DOCK)
 	help
 	  Say Y here if you have a system that supports PCI Hotplug using
@@ -101,7 +99,6 @@ config HOTPLUG_PCI_ACPI_IBM
 
 config HOTPLUG_PCI_CPCI
 	bool "CompactPCI Hotplug driver"
-	depends on HOTPLUG_PCI
 	help
 	  Say Y here if you have a CompactPCI system card with CompactPCI
 	  hotswap support per the PICMG 2.1 specification.
@@ -110,7 +107,7 @@ config HOTPLUG_PCI_CPCI
 
 config HOTPLUG_PCI_CPCI_ZT5550
 	tristate "Ziatech ZT5550 CompactPCI Hotplug driver"
-	depends on HOTPLUG_PCI && HOTPLUG_PCI_CPCI && X86
+	depends on HOTPLUG_PCI_CPCI && X86
 	help
 	  Say Y here if you have an Performance Technologies (formerly Intel,
           formerly just Ziatech) Ziatech ZT5550 CompactPCI system card.
@@ -122,7 +119,7 @@ config HOTPLUG_PCI_CPCI_ZT5550
 
 config HOTPLUG_PCI_CPCI_GENERIC
 	tristate "Generic port I/O CompactPCI Hotplug driver"
-	depends on HOTPLUG_PCI && HOTPLUG_PCI_CPCI && X86
+	depends on HOTPLUG_PCI_CPCI && X86
 	help
 	  Say Y here if you have a CompactPCI system card that exposes the #ENUM
 	  hotswap signal as a bit in a system register that can be read through
@@ -135,7 +132,6 @@ config HOTPLUG_PCI_CPCI_GENERIC
 
 config HOTPLUG_PCI_SHPC
 	tristate "SHPC PCI Hotplug driver"
-	depends on HOTPLUG_PCI
 	help
 	  Say Y here if you have a motherboard with a SHPC PCI Hotplug
 	  controller.
@@ -147,7 +143,7 @@ config HOTPLUG_PCI_SHPC
 
 config HOTPLUG_PCI_RPA
 	tristate "RPA PCI Hotplug driver"
-	depends on HOTPLUG_PCI && PPC_PSERIES && PPC64 && !HOTPLUG_PCI_FAKE
+	depends on PPC_PSERIES && PPC64 && !HOTPLUG_PCI_FAKE
 	help
 	  Say Y here if you have a RPA system that supports PCI Hotplug.
 
@@ -170,12 +166,11 @@ config HOTPLUG_PCI_RPA_DLPAR
 
 config HOTPLUG_PCI_SGI
 	tristate "SGI PCI Hotplug Support"
-	depends on HOTPLUG_PCI && (IA64_SGI_SN2 || IA64_GENERIC)
+	depends on IA64_SGI_SN2 || IA64_GENERIC
 	help
 	  Say Y here if you want to use the SGI Altix Hotplug
 	  Driver for PCI devices.
 
 	  When in doubt, say N.
 
-endmenu
-
+endif # HOTPLUG_PCI
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

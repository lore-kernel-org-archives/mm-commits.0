From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-pnp.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:48:34 -0700
Message-ID: <200704122248.l3CMmYaC018764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbXDLWtF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, ambx1@neo.rr.com, bjorn.helgaas@hp.com, jengelh@gmx.de


The patch titled
     Use menuconfig objects: PNP
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-pnp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: PNP
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/Kconfig         |   11 ++++-------
 drivers/pnp/isapnp/Kconfig  |    2 +-
 drivers/pnp/pnpbios/Kconfig |    2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/pnp/Kconfig~use-menuconfig-objects-pnp drivers/pnp/Kconfig
--- a/drivers/pnp/Kconfig~use-menuconfig-objects-pnp
+++ a/drivers/pnp/Kconfig
@@ -2,9 +2,7 @@
 # Plug and Play configuration
 #
 
-menu "Plug and Play support"
-
-config PNP
+menuconfig PNP
 	bool "Plug and Play support"
 	depends on ISA || ACPI
 	---help---
@@ -21,15 +19,15 @@ config PNP
 
 	  If unsure, say Y.
 
+if PNP
+
 config PNP_DEBUG
 	bool "PnP Debug Messages"
-	depends on PNP
 	help
 	  Say Y if you want the Plug and Play Layer to print debug messages.
 	  This is useful if you are developing a PnP driver or troubleshooting.
 
 comment "Protocols"
-	depends on PNP
 
 source "drivers/pnp/isapnp/Kconfig"
 
@@ -37,5 +35,4 @@ source "drivers/pnp/pnpbios/Kconfig"
 
 source "drivers/pnp/pnpacpi/Kconfig"
 
-endmenu
-
+endif # PNP
diff -puN drivers/pnp/isapnp/Kconfig~use-menuconfig-objects-pnp drivers/pnp/isapnp/Kconfig
--- a/drivers/pnp/isapnp/Kconfig~use-menuconfig-objects-pnp
+++ a/drivers/pnp/isapnp/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISAPNP
 	bool "ISA Plug and Play support"
-	depends on PNP && ISA
+	depends on ISA
 	help
 	  Say Y here if you would like support for ISA Plug and Play devices.
 	  Some information is in <file:Documentation/isapnp.txt>.
diff -puN drivers/pnp/pnpbios/Kconfig~use-menuconfig-objects-pnp drivers/pnp/pnpbios/Kconfig
--- a/drivers/pnp/pnpbios/Kconfig~use-menuconfig-objects-pnp
+++ a/drivers/pnp/pnpbios/Kconfig
@@ -3,7 +3,7 @@
 #
 config PNPBIOS
 	bool "Plug and Play BIOS support (EXPERIMENTAL)"
-	depends on PNP && ISA && X86 && EXPERIMENTAL
+	depends on ISA && X86 && EXPERIMENTAL
 	default n
 	---help---
 	  Linux uses the PNPBIOS as defined in "Plug and Play BIOS
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

From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-w1.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:48:36 -0700
Message-ID: <200704122248.l3CMmauC018767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35637 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbXDLWsy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, johnpol@2ka.mipt.ru


The patch titled
     Use menuconfig objects: W1
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-w1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: W1
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/Kconfig         |   12 ++++++------
 drivers/w1/masters/Kconfig |    7 +++----
 drivers/w1/slaves/Kconfig  |    4 ----
 3 files changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/w1/Kconfig~use-menuconfig-objects-w1 drivers/w1/Kconfig
--- a/drivers/w1/Kconfig~use-menuconfig-objects-w1
+++ a/drivers/w1/Kconfig
@@ -1,7 +1,5 @@
-menu "Dallas's 1-wire bus"
-
-config W1
-	tristate "Dallas's 1-wire support"
+menuconfig W1
+	tristate "Dallas's 1-wire bus support"
 	---help---
 	  Dallas' 1-wire bus is useful to connect slow 1-pin devices
 	  such as iButtons and thermal sensors.
@@ -11,8 +9,10 @@ config W1
 	  This W1 support can also be built as a module.  If so, the module
 	  will be called wire.ko.
 
+if W1
+
 config W1_CON
-	depends on CONNECTOR && W1
+	depends on CONNECTOR
 	bool "Userspace communication over connector"
 	default y
 	--- help ---
@@ -26,4 +26,4 @@ config W1_CON
 source drivers/w1/masters/Kconfig
 source drivers/w1/slaves/Kconfig
 
-endmenu
+endif # W1
diff -puN drivers/w1/masters/Kconfig~use-menuconfig-objects-w1 drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig~use-menuconfig-objects-w1
+++ a/drivers/w1/masters/Kconfig
@@ -3,11 +3,10 @@
 #
 
 menu "1-wire Bus Masters"
-	depends on W1
 
 config W1_MASTER_MATROX
 	tristate "Matrox G400 transport layer for 1-wire"
-	depends on W1 && PCI
+	depends on PCI
 	help
 	  Say Y here if you want to communicate with your 1-wire devices
 	  using Matrox's G400 GPIO pins.
@@ -17,7 +16,7 @@ config W1_MASTER_MATROX
 
 config W1_MASTER_DS2490
 	tristate "DS2490 USB <-> W1 transport layer for 1-wire"
-  	depends on W1 && USB
+  	depends on USB
   	help
 	  Say Y here if you want to have a driver for DS2490 based USB <-> W1 bridges,
 	  for example DS9490*.
@@ -27,7 +26,7 @@ config W1_MASTER_DS2490
 
 config W1_MASTER_DS2482
 	tristate "Maxim DS2482 I2C to 1-Wire bridge"
-	depends on I2C && W1 && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Maxim DS2482
 	  I2C to 1-Wire bridge.
diff -puN drivers/w1/slaves/Kconfig~use-menuconfig-objects-w1 drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~use-menuconfig-objects-w1
+++ a/drivers/w1/slaves/Kconfig
@@ -3,25 +3,21 @@
 #
 
 menu "1-wire Slaves"
-	depends on W1
 
 config W1_SLAVE_THERM
 	tristate "Thermal family implementation"
-	depends on W1
 	help
 	  Say Y here if you want to connect 1-wire thermal sensors to your
 	  wire.
 
 config W1_SLAVE_SMEM
 	tristate "Simple 64bit memory family implementation"
-	depends on W1
 	help
 	  Say Y here if you want to connect 1-wire
 	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
 
 config W1_SLAVE_DS2433
 	tristate "4kb EEPROM family support (DS2433)"
-	depends on W1
 	help
 	  Say Y here if you want to use a 1-wire
 	  4kb EEPROM family device (DS2433).
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

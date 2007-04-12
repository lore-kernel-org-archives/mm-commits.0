From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-i2o.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:47:36 -0700
Message-ID: <200704122247.l3CMlvhe018719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35524 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbXDLWsF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de


The patch titled
     Use menuconfig objects: I2O
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-i2o.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: I2O
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/Kconfig |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff -puN drivers/message/i2o/Kconfig~use-menuconfig-objects-i2o drivers/message/i2o/Kconfig
--- a/drivers/message/i2o/Kconfig~use-menuconfig-objects-i2o
+++ a/drivers/message/i2o/Kconfig
@@ -1,8 +1,6 @@
 
-menu "I2O device support"
-
-config I2O
-	tristate "I2O support"
+menuconfig I2O
+	tristate "I2O device support"
 	depends on PCI
 	---help---
 	  The Intelligent Input/Output (I2O) architecture allows hardware
@@ -24,9 +22,10 @@ config I2O
 
 	  If unsure, say N.
 
+if I2O
+
 config I2O_LCT_NOTIFY_ON_CHANGES
 	bool "Enable LCT notification"
-	depends on I2O
 	default y
 	---help---
 	  Only say N here if you have a I2O controller from SUN. The SUN
@@ -38,7 +37,6 @@ config I2O_LCT_NOTIFY_ON_CHANGES
 
 config I2O_EXT_ADAPTEC
 	bool "Enable Adaptec extensions"
-	depends on I2O
 	default y
 	---help---
 	  Say Y for support of raidutils for Adaptec I2O controllers. You also
@@ -56,7 +54,6 @@ config I2O_EXT_ADAPTEC_DMA64
 
 config I2O_CONFIG
 	tristate "I2O Configuration support"
-	depends on I2O
 	---help---
 	  Say Y for support of the configuration interface for the I2O adapters.
 	  If you have a RAID controller from Adaptec and you want to use the
@@ -77,7 +74,6 @@ config I2O_CONFIG_OLD_IOCTL
 
 config I2O_BUS
 	tristate "I2O Bus Adapter OSM"
-	depends on I2O
 	---help---
 	  Include support for the I2O Bus Adapter OSM. The Bus Adapter OSM
 	  provides access to the busses on the I2O controller. The main purpose
@@ -88,7 +84,7 @@ config I2O_BUS
 
 config I2O_BLOCK
 	tristate "I2O Block OSM"
-	depends on I2O && BLOCK
+	depends on BLOCK
 	---help---
 	  Include support for the I2O Block OSM. The Block OSM presents disk
 	  and other structured block devices to the operating system. If you
@@ -101,7 +97,7 @@ config I2O_BLOCK
 
 config I2O_SCSI
 	tristate "I2O SCSI OSM"
-	depends on I2O && SCSI
+	depends on SCSI
 	---help---
 	  Allows direct SCSI access to SCSI devices on a SCSI or FibreChannel
 	  I2O controller. You can use both the SCSI and Block OSM together if
@@ -113,7 +109,6 @@ config I2O_SCSI
 
 config I2O_PROC
 	tristate "I2O /proc support"
-	depends on I2O
 	---help---
 	  If you say Y here and to "/proc file system support", you will be
 	  able to read I2O related information from the virtual directory
@@ -122,5 +117,4 @@ config I2O_PROC
 	  To compile this support as a module, choose M here: the
 	  module will be called i2o_proc.
 
-endmenu
-
+endif # I2O
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

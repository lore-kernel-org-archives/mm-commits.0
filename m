From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-i2o.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:43 -0700
Message-ID: <200707162052.l6GKqhab001564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759029AbXGPV1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:27:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: I2O
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-i2o.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: I2O
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/Kconfig |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN drivers/message/i2o/Kconfig~use-menuconfig-objects-i2o drivers/message/i2o/Kconfig
--- a/drivers/message/i2o/Kconfig~use-menuconfig-objects-i2o
+++ a/drivers/message/i2o/Kconfig
@@ -1,9 +1,6 @@
 
-menu "I2O device support"
-	depends on PCI
-
-config I2O
-	tristate "I2O support"
+menuconfig I2O
+	tristate "I2O device support"
 	depends on PCI
 	---help---
 	  The Intelligent Input/Output (I2O) architecture allows hardware
@@ -25,9 +22,10 @@ config I2O
 
 	  If unsure, say N.
 
+if I2O
+
 config I2O_LCT_NOTIFY_ON_CHANGES
 	bool "Enable LCT notification"
-	depends on I2O
 	default y
 	---help---
 	  Only say N here if you have a I2O controller from SUN. The SUN
@@ -39,7 +37,6 @@ config I2O_LCT_NOTIFY_ON_CHANGES
 
 config I2O_EXT_ADAPTEC
 	bool "Enable Adaptec extensions"
-	depends on I2O
 	default y
 	---help---
 	  Say Y for support of raidutils for Adaptec I2O controllers. You also
@@ -57,7 +54,6 @@ config I2O_EXT_ADAPTEC_DMA64
 
 config I2O_CONFIG
 	tristate "I2O Configuration support"
-	depends on I2O
 	---help---
 	  Say Y for support of the configuration interface for the I2O adapters.
 	  If you have a RAID controller from Adaptec and you want to use the
@@ -78,7 +74,6 @@ config I2O_CONFIG_OLD_IOCTL
 
 config I2O_BUS
 	tristate "I2O Bus Adapter OSM"
-	depends on I2O
 	---help---
 	  Include support for the I2O Bus Adapter OSM. The Bus Adapter OSM
 	  provides access to the busses on the I2O controller. The main purpose
@@ -89,7 +84,7 @@ config I2O_BUS
 
 config I2O_BLOCK
 	tristate "I2O Block OSM"
-	depends on I2O && BLOCK
+	depends on BLOCK
 	---help---
 	  Include support for the I2O Block OSM. The Block OSM presents disk
 	  and other structured block devices to the operating system. If you
@@ -102,7 +97,7 @@ config I2O_BLOCK
 
 config I2O_SCSI
 	tristate "I2O SCSI OSM"
-	depends on I2O && SCSI
+	depends on SCSI
 	---help---
 	  Allows direct SCSI access to SCSI devices on a SCSI or FibreChannel
 	  I2O controller. You can use both the SCSI and Block OSM together if
@@ -114,7 +109,6 @@ config I2O_SCSI
 
 config I2O_PROC
 	tristate "I2O /proc support"
-	depends on I2O
 	---help---
 	  If you say Y here and to "/proc file system support", you will be
 	  able to read I2O related information from the virtual directory
@@ -123,5 +117,4 @@ config I2O_PROC
 	  To compile this support as a module, choose M here: the
 	  module will be called i2o_proc.
 
-endmenu
-
+endif # I2O
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch

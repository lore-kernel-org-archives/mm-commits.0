From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch removed from -mm tree
Date: Fri, 13 Jul 2007 16:21:04 -0700
Message-ID: <200707132321.l6DNL5nE027972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757829AbXGMXVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 19:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: ISDN: CONFIG_ISDN_DRV_GIGASET
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Use menuconfig objects: ISDN: CONFIG_ISDN_DRV_GIGASET
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Transform Kconfig objects from "menu, config" into "menuconfig" so that the
user can disable the whole feature without having to enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/Kconfig |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/isdn/gigaset/Kconfig~use-menuconfig-objects-isdn-config_isdn_drv_gigaset drivers/isdn/gigaset/Kconfig
--- a/drivers/isdn/gigaset/Kconfig~use-menuconfig-objects-isdn-config_isdn_drv_gigaset
+++ a/drivers/isdn/gigaset/Kconfig
@@ -1,6 +1,4 @@
-menu "Siemens Gigaset"
-
-config ISDN_DRV_GIGASET
+menuconfig ISDN_DRV_GIGASET
 	tristate "Siemens Gigaset support (isdn)"
 	select CRC_CCITT
 	select BITREVERSE
@@ -13,11 +11,11 @@ config ISDN_DRV_GIGASET
 	  one of the connection specific parts that follow.
 	  This will build a module called "gigaset".
 
-if ISDN_DRV_GIGASET!=n
+if ISDN_DRV_GIGASET
 
 config GIGASET_BASE
 	tristate "Gigaset base station support"
-	depends on ISDN_DRV_GIGASET && USB
+	depends on USB
 	help
 	  Say M here if you want to use the USB interface of the Gigaset
 	  base for connection to your system.
@@ -25,7 +23,7 @@ config GIGASET_BASE
 
 config GIGASET_M105
 	tristate "Gigaset M105 support"
-	depends on ISDN_DRV_GIGASET && USB
+	depends on USB
 	help
 	  Say M here if you want to connect to the Gigaset base via DECT
 	  using a Gigaset M105 (Sinus 45 Data 2) USB DECT device.
@@ -33,7 +31,6 @@ config GIGASET_M105
 
 config GIGASET_M101
 	tristate "Gigaset M101 support"
-	depends on ISDN_DRV_GIGASET
 	help
 	  Say M here if you want to connect to the Gigaset base via DECT
 	  using a Gigaset M101 (Sinus 45 Data 1) RS232 DECT device.
@@ -53,6 +50,4 @@ config GIGASET_UNDOCREQ
 	  features like configuration mode of M105, say yes. If you
 	  care about your device, say no.
 
-endif
-
-endmenu
+endif # ISDN_DRV_GIGASET
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
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
kernel-utf-8-handling.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch

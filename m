From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-isdn-config_capi_eicon.patch added to -mm tree
Date: Wed, 30 May 2007 15:38:47 -0700
Message-ID: <200705302238.l4UMclc3006914@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbXE3Wi6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 18:38:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de


The patch titled
     Use menuconfig objects: ISDN: CONFIG_CAPI_EICON
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-isdn-config_capi_eicon.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: ISDN: CONFIG_CAPI_EICON
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Transform Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to enter
the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/Kconfig |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/isdn/hardware/eicon/Kconfig~use-menuconfig-objects-isdn-config_capi_eicon drivers/isdn/hardware/eicon/Kconfig
--- a/drivers/isdn/hardware/eicon/Kconfig~use-menuconfig-objects-isdn-config_capi_eicon
+++ a/drivers/isdn/hardware/eicon/Kconfig
@@ -2,51 +2,50 @@
 # ISDN DIVAS Eicon driver
 #
 
-menu "Active Eicon DIVA Server cards"
-
-config CAPI_EICON
-	bool "Support Eicon cards"
+menuconfig CAPI_EICON
+	bool "Active Eicon DIVA Server cards"
 	help
 	  Enable support for Eicon Networks active ISDN cards.
 
+if CAPI_EICON
+
 config ISDN_DIVAS
 	tristate "Support Eicon DIVA Server cards"
-	depends on CAPI_EICON && PROC_FS && PCI
+	depends on PROC_FS && PCI
 	help
 	  Say Y here if you have an Eicon Networks DIVA Server PCI ISDN card.
 	  In order to use this card, additional firmware is necessary, which
 	  has to be downloaded into the card using the divactrl utility.
 
+if ISDN_DIVAS
+
 config ISDN_DIVAS_BRIPCI
 	bool "DIVA Server BRI/PCI support"
-	depends on ISDN_DIVAS
 	help
 	  Enable support for DIVA Server BRI-PCI.
 
 config ISDN_DIVAS_PRIPCI
 	bool "DIVA Server PRI/PCI support"
-	depends on ISDN_DIVAS
 	help
 	  Enable support for DIVA Server PRI-PCI.
 
 config ISDN_DIVAS_DIVACAPI
 	tristate "DIVA CAPI2.0 interface support"
-	depends on ISDN_DIVAS
 	help
 	  You need this to provide the CAPI interface
 	  for DIVA Server cards.
 
 config ISDN_DIVAS_USERIDI
 	tristate "DIVA User-IDI interface support"
-	depends on ISDN_DIVAS
 	help
 	  Enable support for user-mode IDI interface.
 
 config ISDN_DIVAS_MAINT
 	tristate "DIVA Maint driver support"
-	depends on ISDN_DIVAS && m
+	depends on m
 	help
 	  Enable Divas Maintenance driver.
 
-endmenu
+endif # ISDN_DIVAS
 
+endif # CAPI_EICON
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
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_i4l.patch
use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch

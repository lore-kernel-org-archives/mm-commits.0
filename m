From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-isdn-config_capi_avm.patch added to -mm tree
Date: Wed, 30 May 2007 15:38:45 -0700
Message-ID: <200705302238.l4UMcjtt006911@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbXE3Wiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 18:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de


The patch titled
     Use menuconfig objects: ISDN: CONFIG_CAPI_AVM
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-isdn-config_capi_avm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: ISDN: CONFIG_CAPI_AVM
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Transform Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to enter
the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/Kconfig |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/isdn/hardware/avm/Kconfig~use-menuconfig-objects-isdn-config_capi_avm drivers/isdn/hardware/avm/Kconfig
--- a/drivers/isdn/hardware/avm/Kconfig~use-menuconfig-objects-isdn-config_capi_avm
+++ a/drivers/isdn/hardware/avm/Kconfig
@@ -2,22 +2,22 @@
 # ISDN AVM drivers
 #
 
-menu "Active AVM cards"
-
-config CAPI_AVM
-	bool "Support AVM cards"
+menuconfig CAPI_AVM
+	bool "Active AVM cards"
 	help
 	  Enable support for AVM active ISDN cards.
 
+if CAPI_AVM
+
 config ISDN_DRV_AVMB1_B1ISA
 	tristate "AVM B1 ISA support"
-	depends on CAPI_AVM && ISA
+	depends on ISA
 	help
 	  Enable support for the ISA version of the AVM B1 card.
 
 config ISDN_DRV_AVMB1_B1PCI
 	tristate "AVM B1 PCI support"
-	depends on CAPI_AVM && PCI
+	depends on PCI
 	help
 	  Enable support for the PCI version of the AVM B1 card.
 
@@ -29,14 +29,13 @@ config ISDN_DRV_AVMB1_B1PCIV4
 
 config ISDN_DRV_AVMB1_T1ISA
 	tristate "AVM T1/T1-B ISA support"
-	depends on CAPI_AVM && ISA
+	depends on ISA
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_B1PCMCIA
 	tristate "AVM B1/M1/M2 PCMCIA support"
-	depends on CAPI_AVM
 	help
 	  Enable support for the PCMCIA version of the AVM B1 card.
 
@@ -49,17 +48,16 @@ config ISDN_DRV_AVMB1_AVM_CS
 
 config ISDN_DRV_AVMB1_T1PCI
 	tristate "AVM T1/T1-B PCI support"
-	depends on CAPI_AVM && PCI
+	depends on PCI
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_C4
 	tristate "AVM C4/C2 support"
-	depends on CAPI_AVM && PCI
+	depends on PCI
 	help
 	  Enable support for the AVM C4/C2 PCI cards.
 	  These cards handle 4/2 BRI ISDN lines (8/4 channels).
 
-endmenu
-
+endif # CAPI_AVM
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

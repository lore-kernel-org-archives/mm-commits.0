From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-netdev-atm.patch added to -mm tree
Date: Wed, 09 May 2007 23:17:11 -0700
Message-ID: <200705100617.l4A6HBP8013809@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682AbXEJGRX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 02:17:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jeff@garzik.org, jengelh@gmx.de


The patch titled
     Use menuconfig objects II - netdev/atm
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-netdev-atm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects II - netdev/atm
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/Kconfig |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN drivers/atm/Kconfig~use-menuconfig-objects-ii-netdev-atm drivers/atm/Kconfig
--- a/drivers/atm/Kconfig~use-menuconfig-objects-ii-netdev-atm
+++ a/drivers/atm/Kconfig
@@ -2,19 +2,22 @@
 # ATM device configuration
 #
 
-menu "ATM drivers"
+menuconfig ATM_DRIVERS
+	bool "ATM drivers"
 	depends on NETDEVICES && ATM
+	default y
+
+if ATM_DRIVERS
 
 config ATM_DUMMY
 	tristate "Dummy ATM driver"
-	depends on ATM
 	help
 	  Dummy ATM driver. Useful for proxy signalling, testing,
 	  and development.  If unsure, say N.
 
 config ATM_TCP
 	tristate "ATM over TCP"
-	depends on INET && ATM
+	depends on INET
 	help
 	  ATM over TCP driver. Useful mainly for development and for
 	  experiments. If unsure, say N.
@@ -30,7 +33,7 @@ config ATM_LANAI
 
 config ATM_ENI
 	tristate "Efficient Networks ENI155P"
-	depends on PCI && ATM
+	depends on PCI
 	---help---
 	  Driver for the Efficient Networks ENI155p series and SMC ATM
 	  Power155 155 Mbps ATM adapters. Both, the versions with 512KB and
@@ -139,7 +142,7 @@ config ATM_ENI_BURST_RX_2W
 
 config ATM_FIRESTREAM
 	tristate "Fujitsu FireStream (FS50/FS155) "
-	depends on PCI && ATM
+	depends on PCI
 	help
 	  Driver for the Fujitsu FireStream 155 (MB86697) and
 	  FireStream 50 (MB86695) ATM PCI chips.
@@ -149,7 +152,7 @@ config ATM_FIRESTREAM
 
 config ATM_ZATM
 	tristate "ZeitNet ZN1221/ZN1225"
-	depends on PCI && ATM
+	depends on PCI
 	help
 	  Driver for the ZeitNet ZN1221 (MMF) and ZN1225 (UTP-5) 155 Mbps ATM
 	  adapters.
@@ -169,7 +172,7 @@ config ATM_ZATM_DEBUG
 
 config ATM_NICSTAR
 	tristate "IDT 77201 (NICStAR) (ForeRunnerLE)"
-	depends on PCI && ATM && !64BIT
+	depends on PCI && !64BIT
 	help
 	  The NICStAR chipset family is used in a large number of ATM NICs for
 	  25 and for 155 Mbps, including IDT cards and the Fore ForeRunnerLE
@@ -202,7 +205,7 @@ config ATM_NICSTAR_USE_IDT77105
 
 config ATM_IDT77252
 	tristate "IDT 77252 (NICStAR II)"
-	depends on PCI && ATM
+	depends on PCI
 	help
 	  Driver for the IDT 77252 ATM PCI chips.
 
@@ -237,7 +240,7 @@ config ATM_IDT77252_USE_SUNI
 
 config ATM_AMBASSADOR
 	tristate "Madge Ambassador (Collage PCI 155 Server)"
-	depends on PCI && ATM
+	depends on PCI
 	select BITREVERSE
 	help
 	  This is a driver for ATMizer based ATM card produced by Madge
@@ -262,7 +265,7 @@ config ATM_AMBASSADOR_DEBUG
 
 config ATM_HORIZON
 	tristate "Madge Horizon [Ultra] (Collage PCI 25 and Collage PCI 155 Client)"
-	depends on PCI && ATM
+	depends on PCI
 	help
 	  This is a driver for the Horizon chipset ATM adapter cards once
 	  produced by Madge Networks Ltd. Say Y (or M to compile as a module
@@ -286,7 +289,7 @@ config ATM_HORIZON_DEBUG
 
 config ATM_IA
 	tristate "Interphase ATM PCI x575/x525/x531"
-	depends on PCI && ATM && !64BIT
+	depends on PCI && !64BIT
 	---help---
 	  This is a driver for the Interphase (i)ChipSAR adapter cards
 	  which include a variety of variants in term of the size of the
@@ -319,7 +322,7 @@ config ATM_IA_DEBUG
 
 config ATM_FORE200E_MAYBE
 	tristate "FORE Systems 200E-series"
-	depends on (PCI || SBUS) && ATM
+	depends on PCI || SBUS
 	---help---
 	  This is a driver for the FORE Systems 200E-series ATM adapter
 	  cards. It simultaneously supports PCA-200E and SBA-200E models
@@ -436,7 +439,7 @@ config ATM_FORE200E
 
 config ATM_HE
 	tristate "ForeRunner HE Series"
-	depends on PCI && ATM
+	depends on PCI
 	help
 	  This is a driver for the Marconi ForeRunner HE-series ATM adapter
 	  cards. It simultaneously supports the 155 and 622 versions.
@@ -448,5 +451,4 @@ config ATM_HE_USE_SUNI
 	  Support for the S/UNI-Ultra and S/UNI-622 found in the ForeRunner
 	  HE cards.  This driver provides carrier detection some statistics.
 
-endmenu
-
+endif # ATM
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-ii-sound.patch
git-dvb.patch
use-menuconfig-objects-ii-ieee1394.patch
use-menuconfig-objects-ii-infiniband.patch
use-menuconfig-objects-ii-kvm-virt.patch
use-menuconfig-objects-ii-led.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-ii-netdev-atm.patch
use-menuconfig-objects-ii-netdev-pcmcia.patch
use-menuconfig-objects-ii-netdev-wan.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-fusion.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-usb.patch
git-watchdog.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-rtc.patch
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

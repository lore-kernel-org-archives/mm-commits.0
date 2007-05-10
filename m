From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-netdev-wan.patch added to -mm tree
Date: Wed, 09 May 2007 23:17:15 -0700
Message-ID: <200705100617.l4A6HFFu013815@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877AbXEJGRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 02:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jeff@garzik.org, jengelh@gmx.de, khc@pm.waw.pl


The patch titled
     Use menuconfig objects II - netdev/wan
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-netdev-wan.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects II - netdev/wan
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/Kconfig |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff -puN drivers/net/wan/Kconfig~use-menuconfig-objects-ii-netdev-wan drivers/net/wan/Kconfig
--- a/drivers/net/wan/Kconfig~use-menuconfig-objects-ii-netdev-wan
+++ a/drivers/net/wan/Kconfig
@@ -2,10 +2,7 @@
 # wan devices configuration
 #
 
-menu "Wan interfaces"
-	depends on NETDEVICES
-
-config WAN
+menuconfig WAN
 	bool "Wan interfaces support"
 	---help---
 	  Wide Area Networks (WANs), such as X.25, Frame Relay and leased
@@ -23,10 +20,12 @@ config WAN
 
 	  If unsure, say N.
 
+if WAN
+
 # There is no way to detect a comtrol sv11 - force it modular for now.
 config HOSTESS_SV11
 	tristate "Comtrol Hostess SV-11 support"
-	depends on WAN && ISA && m && ISA_DMA_API && INET
+	depends on ISA && m && ISA_DMA_API && INET
 	help
 	  Driver for Comtrol Hostess SV-11 network card which
 	  operates on low speed synchronous serial links at up to
@@ -38,7 +37,7 @@ config HOSTESS_SV11
 # The COSA/SRP driver has not been tested as non-modular yet.
 config COSA
 	tristate "COSA/SRP sync serial boards support"
-	depends on WAN && ISA && m && ISA_DMA_API
+	depends on ISA && m && ISA_DMA_API
 	---help---
 	  Driver for COSA and SRP synchronous serial boards.
 
@@ -62,7 +61,7 @@ config COSA
 #
 config LANMEDIA
 	tristate "LanMedia Corp. SSI/V.35, T1/E1, HSSI, T3 boards"
-	depends on WAN && PCI
+	depends on PCI
 	---help---
 	  Driver for the following Lan Media family of serial boards:
 
@@ -89,7 +88,7 @@ config LANMEDIA
 # There is no way to detect a Sealevel board. Force it modular
 config SEALEVEL_4021
 	tristate "Sealevel Systems 4021 support"
-	depends on WAN && ISA && m && ISA_DMA_API && INET
+	depends on ISA && m && ISA_DMA_API && INET
 	help
 	  This is a driver for the Sealevel Systems ACB 56 serial I/O adapter.
 
@@ -99,7 +98,6 @@ config SEALEVEL_4021
 # Generic HDLC
 config HDLC
 	tristate "Generic HDLC layer"
-	depends on WAN
 	help
 	  Say Y to this option if your Linux box contains a WAN (Wide Area
 	  Network) card supported by this driver and you are planning to
@@ -167,7 +165,7 @@ config HDLC_X25
 	  If unsure, say N.
 
 comment "X.25/LAPB support is disabled"
-	depends on WAN && HDLC && (LAPB!=m || HDLC!=m) && LAPB!=y
+	depends on HDLC && (LAPB!=m || HDLC!=m) && LAPB!=y
 
 config PCI200SYN
 	tristate "Goramo PCI200SYN support"
@@ -230,10 +228,10 @@ config PC300_MLPPP
 	  Multilink PPP over the PC300 synchronous communication boards.
 
 comment "Cyclades-PC300 MLPPP support is disabled."
-	depends on WAN && HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
+	depends on HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
 
 comment "Refer to the file README.mlppp, provided by PC300 package."
-	depends on WAN && HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
+	depends on HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
 
 config PC300TOO
 	tristate "Cyclades PC300 RSV/X21 alternative support"
@@ -338,7 +336,6 @@ config DSCC4_PCI_RST
 
 config DLCI
 	tristate "Frame Relay DLCI support"
-	depends on WAN
 	---help---
 	  Support for the Frame Relay protocol.
 
@@ -385,7 +382,7 @@ config SDLA
 # Wan router core.
 config WAN_ROUTER_DRIVERS
 	tristate "WAN router drivers"
-	depends on WAN && WAN_ROUTER
+	depends on WAN_ROUTER
 	---help---
 	  Connect LAN to WAN via Linux box.
 
@@ -440,7 +437,7 @@ config CYCLOMX_X25
 # X.25 network drivers
 config LAPBETHER
 	tristate "LAPB over Ethernet driver (EXPERIMENTAL)"
-	depends on WAN && LAPB && X25
+	depends on LAPB && X25
 	---help---
 	  Driver for a pseudo device (typically called /dev/lapb0) which allows
 	  you to open an LAPB point-to-point connection to some other computer
@@ -456,7 +453,7 @@ config LAPBETHER
 
 config X25_ASY
 	tristate "X.25 async driver (EXPERIMENTAL)"
-	depends on WAN && LAPB && X25
+	depends on LAPB && X25
 	---help---
 	  Send and receive X.25 frames over regular asynchronous serial
 	  lines such as telephone lines equipped with ordinary modems.
@@ -471,7 +468,7 @@ config X25_ASY
 
 config SBNI
 	tristate "Granch SBNI12 Leased Line adapter support"
-	depends on WAN && X86
+	depends on X86
 	---help---
 	  Driver for ISA SBNI12-xx cards which are low cost alternatives to
 	  leased line modems.
@@ -497,5 +494,4 @@ config SBNI_MULTILINE
 
 	  If unsure, say N.
 
-endmenu
-
+endif # WAN
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

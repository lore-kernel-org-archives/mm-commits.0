From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-netdev-pcmcia.patch added to -mm tree
Date: Wed, 09 May 2007 23:17:13 -0700
Message-ID: <200705100617.l4A6HDe5013812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965AbXEJGRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 02:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jeff@garzik.org, jengelh@gmx.de, linux@dominikbrodowski.net


The patch titled
     Use menuconfig objects II - netdev/pcmcia
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-netdev-pcmcia.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects II - netdev/pcmcia
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/Kconfig |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff -puN drivers/net/pcmcia/Kconfig~use-menuconfig-objects-ii-netdev-pcmcia drivers/net/pcmcia/Kconfig
--- a/drivers/net/pcmcia/Kconfig~use-menuconfig-objects-ii-netdev-pcmcia
+++ a/drivers/net/pcmcia/Kconfig
@@ -2,11 +2,9 @@
 # PCMCIA Network device configuration
 #
 
-menu "PCMCIA network device support"
-	depends on NETDEVICES && PCMCIA!=n
-
-config NET_PCMCIA
+menuconfig NET_PCMCIA
 	bool "PCMCIA network device support"
+	depends on PCMCIA
 	---help---
 	  Say Y if you would like to include support for any PCMCIA or CardBus
 	  network adapters, then say Y to the driver for your particular card
@@ -21,9 +19,10 @@ config NET_PCMCIA
 
 	  If unsure, say N.
 
+if NET_PCMCIA
+
 config PCMCIA_3C589
 	tristate "3Com 3c589 PCMCIA support"
-	depends on NET_PCMCIA && PCMCIA
 	help
 	  Say Y here if you intend to attach a 3Com 3c589 or compatible PCMCIA
 	  (PC-card) Ethernet card to your computer.
@@ -33,7 +32,6 @@ config PCMCIA_3C589
 
 config PCMCIA_3C574
 	tristate "3Com 3c574 PCMCIA support"
-	depends on NET_PCMCIA && PCMCIA
 	help
 	  Say Y here if you intend to attach a 3Com 3c574 or compatible PCMCIA
 	  (PC-card) Fast Ethernet card to your computer.
@@ -43,7 +41,6 @@ config PCMCIA_3C574
 
 config PCMCIA_FMVJ18X
 	tristate "Fujitsu FMV-J18x PCMCIA support"
-	depends on NET_PCMCIA && PCMCIA
 	select CRC32
 	help
 	  Say Y here if you intend to attach a Fujitsu FMV-J18x or compatible
@@ -54,7 +51,6 @@ config PCMCIA_FMVJ18X
 
 config PCMCIA_PCNET
 	tristate "NE2000 compatible PCMCIA support"
-	depends on NET_PCMCIA && PCMCIA
 	select CRC32
 	help
 	  Say Y here if you intend to attach an NE2000 compatible PCMCIA
@@ -65,7 +61,6 @@ config PCMCIA_PCNET
 
 config PCMCIA_NMCLAN
 	tristate "New Media PCMCIA support"
-	depends on NET_PCMCIA && PCMCIA
 	help
 	  Say Y here if you intend to attach a New Media Ethernet or LiveWire
 	  PCMCIA (PC-card) Ethernet card to your computer.
@@ -75,7 +70,6 @@ config PCMCIA_NMCLAN
 
 config PCMCIA_SMC91C92
 	tristate "SMC 91Cxx PCMCIA support"
-	depends on NET_PCMCIA && PCMCIA
 	select CRC32
 	select MII
 	help
@@ -87,7 +81,6 @@ config PCMCIA_SMC91C92
 
 config PCMCIA_XIRC2PS
 	tristate "Xircom 16-bit PCMCIA support"
-	depends on NET_PCMCIA && PCMCIA
 	help
 	  Say Y here if you intend to attach a Xircom 16-bit PCMCIA (PC-card)
 	  Ethernet or Fast Ethernet card to your computer.
@@ -97,7 +90,6 @@ config PCMCIA_XIRC2PS
 
 config PCMCIA_AXNET
 	tristate "Asix AX88190 PCMCIA support"
-	depends on NET_PCMCIA && PCMCIA
 	---help---
 	  Say Y here if you intend to attach an Asix AX88190-based PCMCIA
 	  (PC-card) Fast Ethernet card to your computer.  These cards are
@@ -109,7 +101,7 @@ config PCMCIA_AXNET
 
 config ARCNET_COM20020_CS
 	tristate "COM20020 ARCnet PCMCIA support"
-	depends on NET_PCMCIA && ARCNET_COM20020 && PCMCIA
+	depends on ARCNET_COM20020
 	help
 	  Say Y here if you intend to attach this type of ARCnet PCMCIA card
 	  to your computer.
@@ -119,7 +111,7 @@ config ARCNET_COM20020_CS
 
 config PCMCIA_IBMTR
 	tristate "IBM PCMCIA tokenring adapter support"
-	depends on NET_PCMCIA && IBMTR!=y && TR && PCMCIA && !64BIT
+	depends on IBMTR!=y && TR && !64BIT
 	help
 	  Say Y here if you intend to attach this type of Token Ring PCMCIA
 	  card to your computer. You then also need to say Y to "Token Ring
@@ -128,5 +120,4 @@ config PCMCIA_IBMTR
 	  To compile this driver as a module, choose M here: the module will be
 	  called ibmtr_cs.
 
-endmenu
-
+endif # NET_PCMCIA
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

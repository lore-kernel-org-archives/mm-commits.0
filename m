From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-phy.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:50 -0700
Message-ID: <200705120536.l4C5aof5002407@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015AbXELFhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jeff@garzik.org, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: PHY
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-phy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: PHY
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/Kconfig |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff -puN drivers/net/phy/Kconfig~use-menuconfig-objects-phy drivers/net/phy/Kconfig
--- a/drivers/net/phy/Kconfig~use-menuconfig-objects-phy
+++ a/drivers/net/phy/Kconfig
@@ -2,70 +2,61 @@
 # PHY Layer Configuration
 #
 
-menu "PHY device support"
-	depends on !S390
-
-config PHYLIB
+menuconfig PHYLIB
 	tristate "PHY Device support and infrastructure"
+	depends on !S390
 	depends on NET_ETHERNET && (BROKEN || !S390)
 	help
 	  Ethernet controllers are usually attached to PHY
 	  devices.  This option provides infrastructure for
 	  managing PHY devices.
 
+if PHYLIB
+
 comment "MII PHY device drivers"
-	depends on PHYLIB
 
 config MARVELL_PHY
 	tristate "Drivers for Marvell PHYs"
-	depends on PHYLIB
 	---help---
 	  Currently has a driver for the 88E1011S
 	
 config DAVICOM_PHY
 	tristate "Drivers for Davicom PHYs"
-	depends on PHYLIB
 	---help---
 	  Currently supports dm9161e and dm9131
 
 config QSEMI_PHY
 	tristate "Drivers for Quality Semiconductor PHYs"
-	depends on PHYLIB
 	---help---
 	  Currently supports the qs6612
 
 config LXT_PHY
 	tristate "Drivers for the Intel LXT PHYs"
-	depends on PHYLIB
 	---help---
 	  Currently supports the lxt970, lxt971
 
 config CICADA_PHY
 	tristate "Drivers for the Cicada PHYs"
-	depends on PHYLIB
 	---help---
 	  Currently supports the cis8204
+
 config VITESSE_PHY
         tristate "Drivers for the Vitesse PHYs"
-        depends on PHYLIB
         ---help---
           Currently supports the vsc8244
 
 config SMSC_PHY
 	tristate "Drivers for SMSC PHYs"
-	depends on PHYLIB
 	---help---
 	  Currently supports the LAN83C185 PHY
 
 config BROADCOM_PHY
 	tristate "Drivers for Broadcom PHYs"
-	depends on PHYLIB
 	---help---
 	  Currently supports the BCM5411, BCM5421 and BCM5461 PHYs.
 
 config FIXED_PHY
 	tristate "Drivers for PHY emulation on fixed speed/link"
-	depends on PHYLIB
 	---help---
 	  Adds the driver to PHY layer to cover the boards that do not have any PHY bound,
 	  but with the ability to manipulate the speed/link in software. The relevant MII
@@ -80,5 +71,4 @@ config FIXED_MII_100_FDX
 	bool "Emulation for 100M Fdx fixed PHY behavior"
 	depends on FIXED_PHY
 
-endmenu
-
+endif # PHYLIB
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-ii-sound.patch
git-dvb.patch
git-ieee1394.patch
use-menuconfig-objects-ii-infiniband.patch
use-menuconfig-objects-ii-kvm-virt.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-usb.patch
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

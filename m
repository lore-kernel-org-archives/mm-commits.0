From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-netdev.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:52 -0700
Message-ID: <200705120536.l4C5aqaH002412@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790AbXELFhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:37:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jeff@garzik.org, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: netdev
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-netdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: netdev
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/net/Kconfig~use-menuconfig-objects-netdev drivers/net/Kconfig
--- a/drivers/net/Kconfig~use-menuconfig-objects-netdev
+++ a/drivers/net/Kconfig
@@ -1942,8 +1942,12 @@ endmenu
 #	Gigabit Ethernet
 #
 
-menu "Ethernet (1000 Mbit)"
+menuconfig NETDEV_1000
+	bool "Ethernet (1000 Mbit)"
 	depends on !UML
+	default y
+
+if NETDEV_1000
 
 config ACENIC
 	tristate "Alteon AceNIC/3Com 3C985/NetGear GA620 Gigabit support"
@@ -2369,14 +2373,18 @@ config ATL1
 	  To compile this driver as a module, choose M here.  The module
 	  will be called atl1.
 
-endmenu
+endif # NETDEV_1000
 
 #
 #	10 Gigabit Ethernet
 #
 
-menu "Ethernet (10000 Mbit)"
+menuconfig NETDEV_10000
+	bool "Ethernet (10000 Mbit)"
 	depends on !UML
+	default y
+
+if NETDEV_10000
 
 config CHELSIO_T1
         tristate "Chelsio 10Gb Ethernet support"
@@ -2551,7 +2559,7 @@ config MLX4_DEBUG
 	  debug_level module parameter (which can also be set after
 	  the driver is loaded through sysfs).
 
-endmenu
+endif # NETDEV_10000
 
 source "drivers/net/tokenring/Kconfig"
 
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

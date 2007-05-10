From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-misc-strange-dev.patch added to -mm tree
Date: Wed, 09 May 2007 23:17:49 -0700
Message-ID: <200705100617.l4A6HnS2013848@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755233AbXEJGSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 02:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de


The patch titled
     Use menuconfig objects II - misc strange dev
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-misc-strange-dev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects II - misc strange dev
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/misc/Kconfig~use-menuconfig-objects-ii-misc-strange-dev drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~use-menuconfig-objects-ii-misc-strange-dev
+++ a/drivers/misc/Kconfig
@@ -2,7 +2,11 @@
 # Misc strange devices
 #
 
-menu "Misc devices"
+menuconfig MISC_STRANGE_DEV
+	bool "Misc devices"
+	default y
+
+if MISC_STRANGE_DEV
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
@@ -202,4 +206,4 @@ config EEPROM_93CX6
 	  This is a driver for the EEPROM chipsets 93c46 and 93c66.
 	  The driver supports both read as well as write commands.
 
-endmenu
+endif # MISC_STRANGE_DEV
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

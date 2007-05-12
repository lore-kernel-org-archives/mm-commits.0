From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-ieee1394.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:23 -0700
Message-ID: <200705120536.l4C5aNAg002370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756665AbXELFgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - IEEE1394
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-ieee1394.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - IEEE1394
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Follows Stefan's suggestion as per http://lkml.org/lkml/2007/4/28/108

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ieee1394/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/ieee1394/Kconfig~use-menuconfig-objects-ii-ieee1394 drivers/ieee1394/Kconfig
--- a/drivers/ieee1394/Kconfig~use-menuconfig-objects-ii-ieee1394
+++ a/drivers/ieee1394/Kconfig
@@ -1,5 +1,9 @@
-menu "IEEE 1394 (FireWire) support"
+menuconfig IEEE1394_SUPPORT
+	bool "IEEE 1394 (FireWire) support"
 	depends on PCI || BROKEN
+	default y
+
+if IEEE1394_SUPPORT
 
 source "drivers/firewire/Kconfig"
 
@@ -147,4 +151,4 @@ config IEEE1394_RAWIO
 	  To compile this driver as a module, say M here: the module will be
 	  called raw1394.
 
-endmenu
+endif # IEEE1394_SUPPORT
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

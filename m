From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-usb.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:18 -0700
Message-ID: <200705212317.l4LNHH1H022458@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758685AbXEUXUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:20:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, greg@kroah.com, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - USB
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-usb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - USB
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu", so that
the user can disable all the options in that menu at once instead of having to
disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/Kconfig |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/usb/Kconfig~use-menuconfig-objects-ii-usb drivers/usb/Kconfig
--- a/drivers/usb/Kconfig~use-menuconfig-objects-ii-usb
+++ a/drivers/usb/Kconfig
@@ -2,8 +2,12 @@
 # USB device configuration
 #
 
-menu "USB support"
+menuconfig USB_SUPPORT
+	bool "USB support"
 	depends on HAS_IOMEM
+	default y
+
+if USB_SUPPORT
 
 # Host-side USB depends on having a host controller
 # NOTE:  dummy_hcd is always an option, but it's ignored here ...
@@ -130,5 +134,4 @@ source "drivers/usb/atm/Kconfig"
 
 source "drivers/usb/gadget/Kconfig"
 
-endmenu
-
+endif # USB_SUPPORT
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

use-menuconfig-objects-acpi.patch
use-menuconfig-objects-ii-sound.patch
git-ieee1394.patch
use-menuconfig-objects-ii-infiniband.patch
use-menuconfig-objects-ii-kvm-virt.patch
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
usb-fix-debug-output-of-ark3116.patch
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
use-menuconfig-objects-ii-isdn.patch
use-menuconfig-objects-ii-md.patch

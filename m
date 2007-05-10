From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-isdn.patch added to -mm tree
Date: Wed, 09 May 2007 23:18:01 -0700
Message-ID: <200705100618.l4A6I1Nu013866@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272AbXEJGSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 02:18:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de


The patch titled
     Use menuconfig objects II - ISDN
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-isdn.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects II - ISDN
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

In this patch, CONFIG_ISDN is also changed from a tristate to bool,
since no Makefile uses obj-$(CONFIG_ISDN) that could possibly
produce a module out of CONFIG_ISDN. So CONFIG_ISDN=y and
CONFIG_ISDN=m would do the same, in which case only allowing yes/no
seems 'nicer' to me. The submodules in the ISDN menu can still be
built as modules, as usual.

CAUTION: Everyone who has CONFIG_ISDN set to 'm' will get it set to
'n'(!), so either everyone (including defconfig maintainers) should keep
an eye open, or I need to come up with a patch that changes kconfig to
just downgrade m->y in such cases.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/Kconfig |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN drivers/isdn/Kconfig~use-menuconfig-objects-ii-isdn drivers/isdn/Kconfig
--- a/drivers/isdn/Kconfig~use-menuconfig-objects-ii-isdn
+++ a/drivers/isdn/Kconfig
@@ -2,10 +2,8 @@
 # ISDN device configuration
 #
 
-menu "ISDN subsystem"
-
-config ISDN
-	tristate "ISDN support"
+menuconfig ISDN
+	bool "ISDN support"
 	depends on NET
 	---help---
 	  ISDN ("Integrated Services Digital Networks", called RNIS in France)
@@ -21,11 +19,11 @@ config ISDN
 	  Select this option if you want your kernel to support ISDN.
 
 
-menu "Old ISDN4Linux"
-	depends on NET && ISDN
+if ISDN
 
-config ISDN_I4L
+menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (obsolete)"
+	depends on NET
 	---help---
 	  This driver allows you to use an ISDN-card for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
@@ -45,14 +43,11 @@ if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"
 endif
 
-endmenu
-
 comment "CAPI subsystem"
-	depends on NET && ISDN
+	depends on NET
 
 config ISDN_CAPI
 	tristate "CAPI2.0 support"
-	depends on ISDN
 	help
 	  This provides the CAPI (Common ISDN Application Programming
 	  Interface, a standard making it easy for programs to access ISDN
@@ -63,5 +58,4 @@ source "drivers/isdn/capi/Kconfig"
 
 source "drivers/isdn/hardware/Kconfig"
 
-endmenu
-
+endif # ISDN
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

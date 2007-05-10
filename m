From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-ipmi.patch added to -mm tree
Date: Wed, 09 May 2007 23:17:47 -0700
Message-ID: <200705100617.l4A6HlID013845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755230AbXEJGSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 02:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, minyard@acm.org


The patch titled
     Use menuconfig objects II - IPMI
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-ipmi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects II - IPMI
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/Kconfig |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/char/ipmi/Kconfig~use-menuconfig-objects-ii-ipmi drivers/char/ipmi/Kconfig
--- a/drivers/char/ipmi/Kconfig~use-menuconfig-objects-ii-ipmi
+++ a/drivers/char/ipmi/Kconfig
@@ -2,8 +2,7 @@
 # IPMI device configuration
 #
 
-menu "IPMI"
-config IPMI_HANDLER
+menuconfig IPMI_HANDLER
        tristate 'IPMI top-level message handler'
        help
          This enables the central IPMI message handler, required for IPMI
@@ -16,9 +15,10 @@ config IPMI_HANDLER
 
 	 If unsure, say N.
 
+if IPMI_HANDLER
+
 config IPMI_PANIC_EVENT
        bool 'Generate a panic event to all BMCs on a panic'
-       depends on IPMI_HANDLER
        help
          When a panic occurs, this will cause the IPMI message handler to
 	 generate an IPMI event describing the panic to each interface
@@ -38,14 +38,12 @@ config IPMI_PANIC_STRING
 
 config IPMI_DEVICE_INTERFACE
        tristate 'Device interface for IPMI'
-       depends on IPMI_HANDLER
        help
          This provides an IOCTL interface to the IPMI message handler so
 	 userland processes may use IPMI.  It supports poll() and select().
 
 config IPMI_SI
        tristate 'IPMI System Interface handler'
-       depends on IPMI_HANDLER
        help
          Provides a driver for System Interfaces (KCS, SMIC, BT).
 	 Currently, only KCS and SMIC are supported.  If
@@ -53,15 +51,13 @@ config IPMI_SI
 
 config IPMI_WATCHDOG
        tristate 'IPMI Watchdog Timer'
-       depends on IPMI_HANDLER
        help
          This enables the IPMI watchdog timer.
 
 config IPMI_POWEROFF
        tristate 'IPMI Poweroff'
-       depends on IPMI_HANDLER
        help
          This enables a function to power off the system with IPMI if
 	 the IPMI management controller is capable of this.
 
-endmenu
+endif # IPMI_HANDLER
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

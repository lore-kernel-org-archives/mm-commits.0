From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-isdn.patch removed from -mm tree
Date: Wed, 30 May 2007 12:06:02 -0700
Message-ID: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbXE3TGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 15:06:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - ISDN
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-isdn.patch

This patch was dropped because an updated version will be merged

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
 1 files changed, 7 insertions(+), 13 deletions(-)

diff -puN drivers/isdn/Kconfig~use-menuconfig-objects-ii-isdn drivers/isdn/Kconfig
--- a/drivers/isdn/Kconfig~use-menuconfig-objects-ii-isdn
+++ a/drivers/isdn/Kconfig
@@ -2,11 +2,9 @@
 # ISDN device configuration
 #
 
-menu "ISDN subsystem"
-	depends on !S390
-
-config ISDN
+menuconfig ISDN
 	tristate "ISDN support"
+	depends on !S390
 	depends on NET
 	---help---
 	  ISDN ("Integrated Services Digital Networks", called RNIS in France)
@@ -22,11 +20,11 @@ config ISDN
 	  Select this option if you want your kernel to support ISDN.
 
 
-menu "Old ISDN4Linux"
-	depends on NET && ISDN
+if ISDN
 
-config ISDN_I4L
+menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
+	depends on NET
 	---help---
 	  This driver allows you to use an ISDN adapter for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
@@ -47,14 +45,11 @@ if ISDN_I4L
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
@@ -65,5 +60,4 @@ source "drivers/isdn/capi/Kconfig"
 
 source "drivers/isdn/hardware/Kconfig"
 
-endmenu
-
+endif # ISDN
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

use-menuconfig-objects-acpi.patch
git-hid.patch
use-menuconfig-objects-ii-infiniband.patch
git-kvm.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
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

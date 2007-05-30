From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-isdn-config_isdn.patch added to -mm tree
Date: Wed, 30 May 2007 15:38:37 -0700
Message-ID: <200705302238.l4UMcbNh006899@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbXE3Wit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 18:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de


The patch titled
     Use menuconfig objects: ISDN: CONFIG_ISDN
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-isdn-config_isdn.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: ISDN: CONFIG_ISDN
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Transform Kconfig objects from "menu, config" into "menuconfig" so that the
user can disable the whole feature without having to enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/Kconfig                |   13 ++++---------
 drivers/isdn/hardware/Kconfig       |    2 +-
 drivers/isdn/hardware/avm/Kconfig   |    2 +-
 drivers/isdn/hardware/eicon/Kconfig |    2 +-
 drivers/isdn/i4l/Kconfig            |    7 +++----
 5 files changed, 10 insertions(+), 16 deletions(-)

diff -puN drivers/isdn/Kconfig~use-menuconfig-objects-isdn-config_isdn drivers/isdn/Kconfig
--- a/drivers/isdn/Kconfig~use-menuconfig-objects-isdn-config_isdn
+++ a/drivers/isdn/Kconfig
@@ -2,12 +2,10 @@
 # ISDN device configuration
 #
 
-menu "ISDN subsystem"
-	depends on !S390
-
-config ISDN
+menuconfig ISDN
 	tristate "ISDN support"
 	depends on NET
+	depends on !S390
 	---help---
 	  ISDN ("Integrated Services Digital Networks", called RNIS in France)
 	  is a special type of fully digital telephone service; it's mostly
@@ -21,9 +19,9 @@ config ISDN
 
 	  Select this option if you want your kernel to support ISDN.
 
+if ISDN
 
 menu "Old ISDN4Linux"
-	depends on NET && ISDN
 
 config ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
@@ -50,11 +48,9 @@ endif
 endmenu
 
 comment "CAPI subsystem"
-	depends on NET && ISDN
 
 config ISDN_CAPI
 	tristate "CAPI2.0 support"
-	depends on ISDN
 	help
 	  This provides the CAPI (Common ISDN Application Programming
 	  Interface, a standard making it easy for programs to access ISDN
@@ -65,5 +61,4 @@ source "drivers/isdn/capi/Kconfig"
 
 source "drivers/isdn/hardware/Kconfig"
 
-endmenu
-
+endif # ISDN
diff -puN drivers/isdn/hardware/Kconfig~use-menuconfig-objects-isdn-config_isdn drivers/isdn/hardware/Kconfig
--- a/drivers/isdn/hardware/Kconfig~use-menuconfig-objects-isdn-config_isdn
+++ a/drivers/isdn/hardware/Kconfig
@@ -2,7 +2,7 @@
 # ISDN hardware drivers
 #
 comment "CAPI hardware drivers"
-	depends on NET && ISDN && ISDN_CAPI
+	depends on ISDN_CAPI
 
 source "drivers/isdn/hardware/avm/Kconfig"
 
diff -puN drivers/isdn/hardware/avm/Kconfig~use-menuconfig-objects-isdn-config_isdn drivers/isdn/hardware/avm/Kconfig
--- a/drivers/isdn/hardware/avm/Kconfig~use-menuconfig-objects-isdn-config_isdn
+++ a/drivers/isdn/hardware/avm/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "Active AVM cards"
-	depends on NET && ISDN && ISDN_CAPI!=n
+	depends on ISDN_CAPI!=n
 
 config CAPI_AVM
 	bool "Support AVM cards"
diff -puN drivers/isdn/hardware/eicon/Kconfig~use-menuconfig-objects-isdn-config_isdn drivers/isdn/hardware/eicon/Kconfig
--- a/drivers/isdn/hardware/eicon/Kconfig~use-menuconfig-objects-isdn-config_isdn
+++ a/drivers/isdn/hardware/eicon/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "Active Eicon DIVA Server cards"
-	depends on NET && ISDN && ISDN_CAPI!=n
+	depends on ISDN_CAPI!=n
 
 config CAPI_EICON
 	bool "Support Eicon cards"
diff -puN drivers/isdn/i4l/Kconfig~use-menuconfig-objects-isdn-config_isdn drivers/isdn/i4l/Kconfig
--- a/drivers/isdn/i4l/Kconfig~use-menuconfig-objects-isdn-config_isdn
+++ a/drivers/isdn/i4l/Kconfig
@@ -86,7 +86,6 @@ config ISDN_X25
 
 
 menu "ISDN feature submodules"
-	depends on ISDN
 
 config ISDN_DRV_LOOP
 	tristate "isdnloop support"
@@ -100,7 +99,7 @@ config ISDN_DRV_LOOP
 
 config ISDN_DIVERSION
 	tristate "Support isdn diversion services"
-	depends on ISDN && ISDN_I4L
+	depends on ISDN_I4L
 	help
 	  This option allows you to use some supplementary diversion
 	  services in conjunction with the HiSax driver on an EURO/DSS1
@@ -120,13 +119,13 @@ config ISDN_DIVERSION
 endmenu
 
 comment "ISDN4Linux hardware drivers"
-	depends on NET && ISDN && ISDN_I4L
+	depends on ISDN_I4L
 
 source "drivers/isdn/hisax/Kconfig"
 
 
 menu "Active cards"
-	depends on NET && ISDN && ISDN_I4L!=n
+	depends on ISDN_I4L!=n
 
 source "drivers/isdn/icn/Kconfig"
 
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
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_i4l.patch
use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch

From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-isdn-config_isdn_capi.patch added to -mm tree
Date: Wed, 30 May 2007 15:38:43 -0700
Message-ID: <200705302238.l4UMch2M006908@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752279AbXE3Wiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 18:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de


The patch titled
     Use menuconfig objects: ISDN: CONFIG_ISDN_CAPI
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-isdn-config_isdn_capi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: ISDN: CONFIG_ISDN_CAPI
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Transform "depends on" into a simpler if-endif block style dependency.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/Kconfig                |    4 ++++
 drivers/isdn/capi/Kconfig           |    7 ++-----
 drivers/isdn/hardware/Kconfig       |    1 -
 drivers/isdn/hardware/avm/Kconfig   |   13 ++++++-------
 drivers/isdn/hardware/eicon/Kconfig |    3 +--
 5 files changed, 13 insertions(+), 15 deletions(-)

diff -puN drivers/isdn/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi drivers/isdn/Kconfig
--- a/drivers/isdn/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi
+++ a/drivers/isdn/Kconfig
@@ -53,8 +53,12 @@ config ISDN_CAPI
 	  hardware, see <http://www.capi.org/>.  This is needed for AVM's set
 	  of active ISDN controllers like B1, T1, M1.
 
+if ISDN_CAPI
+
 source "drivers/isdn/capi/Kconfig"
 
 source "drivers/isdn/hardware/Kconfig"
 
+endif # ISDN_CAPI
+
 endif # ISDN
diff -puN drivers/isdn/capi/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi drivers/isdn/capi/Kconfig
--- a/drivers/isdn/capi/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi
+++ a/drivers/isdn/capi/Kconfig
@@ -3,7 +3,6 @@
 #
 config ISDN_DRV_AVMB1_VERBOSE_REASON
 	bool "Verbose reason code reporting"
-	depends on ISDN_CAPI
 	default y
 	help
 	  If you say Y here, the CAPI drivers will give verbose reasons for
@@ -12,7 +11,6 @@ config ISDN_DRV_AVMB1_VERBOSE_REASON
 
 config CAPI_TRACE
 	bool "CAPI trace support"
-	depends on ISDN_CAPI
 	default y
 	help
 	  If you say Y here, the kernelcapi driver can make verbose traces
@@ -23,7 +21,7 @@ config CAPI_TRACE
 
 config ISDN_CAPI_MIDDLEWARE
 	bool "CAPI2.0 Middleware support (EXPERIMENTAL)"
-	depends on ISDN_CAPI && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  This option will enhance the capabilities of the /dev/capi20
 	  interface.  It will provide a means of moving a data connection,
@@ -33,7 +31,6 @@ config ISDN_CAPI_MIDDLEWARE
 
 config ISDN_CAPI_CAPI20
 	tristate "CAPI2.0 /dev/capi support"
-	depends on ISDN_CAPI
 	help
 	  This option will provide the CAPI 2.0 interface to userspace
 	  applications via /dev/capi20. Applications should use the
@@ -56,7 +53,7 @@ config ISDN_CAPI_CAPIFS
 
 config ISDN_CAPI_CAPIDRV
 	tristate "CAPI2.0 capidrv interface support"
-	depends on ISDN_CAPI && ISDN_I4L
+	depends on ISDN_I4L
 	help
 	  This option provides the glue code to hook up CAPI driven cards to
 	  the legacy isdn4linux link layer.  If you have a card which is
diff -puN drivers/isdn/hardware/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi drivers/isdn/hardware/Kconfig
--- a/drivers/isdn/hardware/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi
+++ a/drivers/isdn/hardware/Kconfig
@@ -2,7 +2,6 @@
 # ISDN hardware drivers
 #
 comment "CAPI hardware drivers"
-	depends on ISDN_CAPI
 
 source "drivers/isdn/hardware/avm/Kconfig"
 
diff -puN drivers/isdn/hardware/avm/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi drivers/isdn/hardware/avm/Kconfig
--- a/drivers/isdn/hardware/avm/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi
+++ a/drivers/isdn/hardware/avm/Kconfig
@@ -3,7 +3,6 @@
 #
 
 menu "Active AVM cards"
-	depends on ISDN_CAPI!=n
 
 config CAPI_AVM
 	bool "Support AVM cards"
@@ -12,13 +11,13 @@ config CAPI_AVM
 
 config ISDN_DRV_AVMB1_B1ISA
 	tristate "AVM B1 ISA support"
-	depends on CAPI_AVM && ISDN_CAPI && ISA
+	depends on CAPI_AVM && ISA
 	help
 	  Enable support for the ISA version of the AVM B1 card.
 
 config ISDN_DRV_AVMB1_B1PCI
 	tristate "AVM B1 PCI support"
-	depends on CAPI_AVM && ISDN_CAPI && PCI
+	depends on CAPI_AVM && PCI
 	help
 	  Enable support for the PCI version of the AVM B1 card.
 
@@ -30,14 +29,14 @@ config ISDN_DRV_AVMB1_B1PCIV4
 
 config ISDN_DRV_AVMB1_T1ISA
 	tristate "AVM T1/T1-B ISA support"
-	depends on CAPI_AVM && ISDN_CAPI && ISA
+	depends on CAPI_AVM && ISA
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_B1PCMCIA
 	tristate "AVM B1/M1/M2 PCMCIA support"
-	depends on CAPI_AVM && ISDN_CAPI
+	depends on CAPI_AVM
 	help
 	  Enable support for the PCMCIA version of the AVM B1 card.
 
@@ -50,14 +49,14 @@ config ISDN_DRV_AVMB1_AVM_CS
 
 config ISDN_DRV_AVMB1_T1PCI
 	tristate "AVM T1/T1-B PCI support"
-	depends on CAPI_AVM && ISDN_CAPI && PCI
+	depends on CAPI_AVM && PCI
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_C4
 	tristate "AVM C4/C2 support"
-	depends on CAPI_AVM && ISDN_CAPI && PCI
+	depends on CAPI_AVM && PCI
 	help
 	  Enable support for the AVM C4/C2 PCI cards.
 	  These cards handle 4/2 BRI ISDN lines (8/4 channels).
diff -puN drivers/isdn/hardware/eicon/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi drivers/isdn/hardware/eicon/Kconfig
--- a/drivers/isdn/hardware/eicon/Kconfig~use-menuconfig-objects-isdn-config_isdn_capi
+++ a/drivers/isdn/hardware/eicon/Kconfig
@@ -3,7 +3,6 @@
 #
 
 menu "Active Eicon DIVA Server cards"
-	depends on ISDN_CAPI!=n
 
 config CAPI_EICON
 	bool "Support Eicon cards"
@@ -32,7 +31,7 @@ config ISDN_DIVAS_PRIPCI
 
 config ISDN_DIVAS_DIVACAPI
 	tristate "DIVA CAPI2.0 interface support"
-	depends on ISDN_DIVAS && ISDN_CAPI
+	depends on ISDN_DIVAS
 	help
 	  You need this to provide the CAPI interface
 	  for DIVA Server cards.
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

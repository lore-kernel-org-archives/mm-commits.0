From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-isdn-config_isdn.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:39 -0700
Message-ID: <200707172303.l6HN3dXm011707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936668AbXGQXQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: ISDN: CONFIG_ISDN
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-isdn-config_isdn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch

From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-config_isdn_i4l.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:43:16 -0700
Message-ID: <200707192343.l6JNhGaH028908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41086 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757617AbXGSXnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, jengelh@computergmbh.de, kkeil@suse.de


The patch titled
     Use menuconfig objects - CONFIG_ISDN_I4L
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-config_isdn_i4l.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects - CONFIG_ISDN_I4L
From: Tilman Schmidt <tilman@imap.cc>

Remove a menu statement and several dependencies from the Kconfig files in
the drivers/isdn tree as they have become unnecessary by the transformation
of CONFIG_ISDN from "menu, config" into "menuconfig".
(Modified version of a patch originally proposed by Jan Engelhardt.)

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/Kconfig         |    8 +-------
 drivers/isdn/act2000/Kconfig |    2 +-
 drivers/isdn/gigaset/Kconfig |    2 --
 drivers/isdn/hisax/Kconfig   |    1 -
 drivers/isdn/i4l/Kconfig     |    3 ---
 drivers/isdn/icn/Kconfig     |    2 +-
 drivers/isdn/pcbit/Kconfig   |    2 +-
 drivers/isdn/sc/Kconfig      |    2 +-
 8 files changed, 5 insertions(+), 17 deletions(-)

diff -puN drivers/isdn/Kconfig~use-menuconfig-objects-config_isdn_i4l drivers/isdn/Kconfig
--- a/drivers/isdn/Kconfig~use-menuconfig-objects-config_isdn_i4l
+++ a/drivers/isdn/Kconfig
@@ -21,8 +21,6 @@ menuconfig ISDN
 
 if ISDN
 
-menu "Old ISDN4Linux"
-
 config ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
 	---help---
@@ -45,12 +43,8 @@ if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"
 endif
 
-endmenu
-
-comment "CAPI subsystem"
-
 config ISDN_CAPI
-	tristate "CAPI2.0 support"
+	tristate "CAPI 2.0 subsystem"
 	help
 	  This provides the CAPI (Common ISDN Application Programming
 	  Interface, a standard making it easy for programs to access ISDN
diff -puN drivers/isdn/act2000/Kconfig~use-menuconfig-objects-config_isdn_i4l drivers/isdn/act2000/Kconfig
--- a/drivers/isdn/act2000/Kconfig~use-menuconfig-objects-config_isdn_i4l
+++ a/drivers/isdn/act2000/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISDN_DRV_ACT2000
 	tristate "IBM Active 2000 support"
-	depends on ISDN_I4L && ISA
+	depends on ISA
 	help
 	  Say Y here if you have an IBM Active 2000 ISDN card. In order to use
 	  this card, additional firmware is necessary, which has to be loaded
diff -puN drivers/isdn/gigaset/Kconfig~use-menuconfig-objects-config_isdn_i4l drivers/isdn/gigaset/Kconfig
--- a/drivers/isdn/gigaset/Kconfig~use-menuconfig-objects-config_isdn_i4l
+++ a/drivers/isdn/gigaset/Kconfig
@@ -1,9 +1,7 @@
 menu "Siemens Gigaset"
-	depends on ISDN_I4L
 
 config ISDN_DRV_GIGASET
 	tristate "Siemens Gigaset support (isdn)"
-	depends on ISDN_I4L
 	select CRC_CCITT
 	select BITREVERSE
 	help
diff -puN drivers/isdn/hisax/Kconfig~use-menuconfig-objects-config_isdn_i4l drivers/isdn/hisax/Kconfig
--- a/drivers/isdn/hisax/Kconfig~use-menuconfig-objects-config_isdn_i4l
+++ a/drivers/isdn/hisax/Kconfig
@@ -1,6 +1,5 @@
 
 menu "Passive cards"
-	depends on ISDN_I4L
 
 config ISDN_DRV_HISAX
 	tristate "HiSax SiemensChipSet driver support"
diff -puN drivers/isdn/i4l/Kconfig~use-menuconfig-objects-config_isdn_i4l drivers/isdn/i4l/Kconfig
--- a/drivers/isdn/i4l/Kconfig~use-menuconfig-objects-config_isdn_i4l
+++ a/drivers/isdn/i4l/Kconfig
@@ -99,7 +99,6 @@ config ISDN_DRV_LOOP
 
 config ISDN_DIVERSION
 	tristate "Support isdn diversion services"
-	depends on ISDN_I4L
 	help
 	  This option allows you to use some supplementary diversion
 	  services in conjunction with the HiSax driver on an EURO/DSS1
@@ -119,13 +118,11 @@ config ISDN_DIVERSION
 endmenu
 
 comment "ISDN4Linux hardware drivers"
-	depends on ISDN_I4L
 
 source "drivers/isdn/hisax/Kconfig"
 
 
 menu "Active cards"
-	depends on ISDN_I4L!=n
 
 source "drivers/isdn/icn/Kconfig"
 
diff -puN drivers/isdn/icn/Kconfig~use-menuconfig-objects-config_isdn_i4l drivers/isdn/icn/Kconfig
--- a/drivers/isdn/icn/Kconfig~use-menuconfig-objects-config_isdn_i4l
+++ a/drivers/isdn/icn/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISDN_DRV_ICN
 	tristate "ICN 2B and 4B support"
-	depends on ISDN_I4L && ISA
+	depends on ISA
 	help
 	  This enables support for two kinds of ISDN-cards made by a German
 	  company called ICN.  2B is the standard version for a single ISDN
diff -puN drivers/isdn/pcbit/Kconfig~use-menuconfig-objects-config_isdn_i4l drivers/isdn/pcbit/Kconfig
--- a/drivers/isdn/pcbit/Kconfig~use-menuconfig-objects-config_isdn_i4l
+++ a/drivers/isdn/pcbit/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISDN_DRV_PCBIT
 	tristate "PCBIT-D support"
-	depends on ISDN_I4L && ISA && (BROKEN || X86)
+	depends on ISA && (BROKEN || X86)
 	help
 	  This enables support for the PCBIT ISDN-card.  This card is
 	  manufactured in Portugal by Octal.  For running this card,
diff -puN drivers/isdn/sc/Kconfig~use-menuconfig-objects-config_isdn_i4l drivers/isdn/sc/Kconfig
--- a/drivers/isdn/sc/Kconfig~use-menuconfig-objects-config_isdn_i4l
+++ a/drivers/isdn/sc/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISDN_DRV_SC
 	tristate "Spellcaster support"
-	depends on ISDN_I4L && ISA
+	depends on ISA
 	help
 	  This enables support for the Spellcaster BRI ISDN boards.  This
 	  driver currently builds only in a modularized version.
_

Patches currently in -mm which might be from tilman@imap.cc are

use-menuconfig-objects-config_isdn_i4l.patch
use-menuconfig-objects-isdn.patch
use-menuconfig-objects-isdn-gigaset.patch

From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-isdn-config_capi_eicon.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:46 -0700
Message-ID: <200707172303.l6HN3kW1011736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936681AbXGQXQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: ISDN: CONFIG_CAPI_EICON
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-isdn-config_capi_eicon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: ISDN: CONFIG_CAPI_EICON
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Transform Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to enter
the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/Kconfig |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/isdn/hardware/eicon/Kconfig~use-menuconfig-objects-isdn-config_capi_eicon drivers/isdn/hardware/eicon/Kconfig
--- a/drivers/isdn/hardware/eicon/Kconfig~use-menuconfig-objects-isdn-config_capi_eicon
+++ a/drivers/isdn/hardware/eicon/Kconfig
@@ -2,51 +2,50 @@
 # ISDN DIVAS Eicon driver
 #
 
-menu "Active Eicon DIVA Server cards"
-
-config CAPI_EICON
-	bool "Support Eicon cards"
+menuconfig CAPI_EICON
+	bool "Active Eicon DIVA Server cards"
 	help
 	  Enable support for Eicon Networks active ISDN cards.
 
+if CAPI_EICON
+
 config ISDN_DIVAS
 	tristate "Support Eicon DIVA Server cards"
-	depends on CAPI_EICON && PROC_FS && PCI
+	depends on PROC_FS && PCI
 	help
 	  Say Y here if you have an Eicon Networks DIVA Server PCI ISDN card.
 	  In order to use this card, additional firmware is necessary, which
 	  has to be downloaded into the card using the divactrl utility.
 
+if ISDN_DIVAS
+
 config ISDN_DIVAS_BRIPCI
 	bool "DIVA Server BRI/PCI support"
-	depends on ISDN_DIVAS
 	help
 	  Enable support for DIVA Server BRI-PCI.
 
 config ISDN_DIVAS_PRIPCI
 	bool "DIVA Server PRI/PCI support"
-	depends on ISDN_DIVAS
 	help
 	  Enable support for DIVA Server PRI-PCI.
 
 config ISDN_DIVAS_DIVACAPI
 	tristate "DIVA CAPI2.0 interface support"
-	depends on ISDN_DIVAS
 	help
 	  You need this to provide the CAPI interface
 	  for DIVA Server cards.
 
 config ISDN_DIVAS_USERIDI
 	tristate "DIVA User-IDI interface support"
-	depends on ISDN_DIVAS
 	help
 	  Enable support for user-mode IDI interface.
 
 config ISDN_DIVAS_MAINT
 	tristate "DIVA Maint driver support"
-	depends on ISDN_DIVAS && m
+	depends on m
 	help
 	  Enable Divas Maintenance driver.
 
-endmenu
+endif # ISDN_DIVAS
 
+endif # CAPI_EICON
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch

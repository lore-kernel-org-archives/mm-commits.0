From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-isdn-config_capi_avm.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:44 -0700
Message-ID: <200707172303.l6HN3ims011728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936689AbXGQXQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: ISDN: CONFIG_CAPI_AVM
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-isdn-config_capi_avm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: ISDN: CONFIG_CAPI_AVM
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Transform Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to enter
the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/Kconfig |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/isdn/hardware/avm/Kconfig~use-menuconfig-objects-isdn-config_capi_avm drivers/isdn/hardware/avm/Kconfig
--- a/drivers/isdn/hardware/avm/Kconfig~use-menuconfig-objects-isdn-config_capi_avm
+++ a/drivers/isdn/hardware/avm/Kconfig
@@ -2,22 +2,22 @@
 # ISDN AVM drivers
 #
 
-menu "Active AVM cards"
-
-config CAPI_AVM
-	bool "Support AVM cards"
+menuconfig CAPI_AVM
+	bool "Active AVM cards"
 	help
 	  Enable support for AVM active ISDN cards.
 
+if CAPI_AVM
+
 config ISDN_DRV_AVMB1_B1ISA
 	tristate "AVM B1 ISA support"
-	depends on CAPI_AVM && ISA
+	depends on ISA
 	help
 	  Enable support for the ISA version of the AVM B1 card.
 
 config ISDN_DRV_AVMB1_B1PCI
 	tristate "AVM B1 PCI support"
-	depends on CAPI_AVM && PCI
+	depends on PCI
 	help
 	  Enable support for the PCI version of the AVM B1 card.
 
@@ -29,14 +29,13 @@ config ISDN_DRV_AVMB1_B1PCIV4
 
 config ISDN_DRV_AVMB1_T1ISA
 	tristate "AVM T1/T1-B ISA support"
-	depends on CAPI_AVM && ISA
+	depends on ISA
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_B1PCMCIA
 	tristate "AVM B1/M1/M2 PCMCIA support"
-	depends on CAPI_AVM
 	help
 	  Enable support for the PCMCIA version of the AVM B1 card.
 
@@ -49,17 +48,16 @@ config ISDN_DRV_AVMB1_AVM_CS
 
 config ISDN_DRV_AVMB1_T1PCI
 	tristate "AVM T1/T1-B PCI support"
-	depends on CAPI_AVM && PCI
+	depends on PCI
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_C4
 	tristate "AVM C4/C2 support"
-	depends on CAPI_AVM && PCI
+	depends on PCI
 	help
 	  Enable support for the AVM C4/C2 PCI cards.
 	  These cards handle 4/2 BRI ISDN lines (8/4 channels).
 
-endmenu
-
+endif # CAPI_AVM
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch

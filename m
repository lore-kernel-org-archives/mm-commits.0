From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-parport.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:46 -0700
Message-ID: <200707162052.l6GKqkgq001567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761200AbXGPV1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:27:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: parport
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-parport.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: parport
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/Kconfig |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff -puN drivers/parport/Kconfig~use-menuconfig-objects-parport drivers/parport/Kconfig
--- a/drivers/parport/Kconfig~use-menuconfig-objects-parport
+++ a/drivers/parport/Kconfig
@@ -5,11 +5,9 @@
 # Parport configuration.
 #
 
-menu "Parallel port support"
-	depends on HAS_IOMEM
-
-config PARPORT
+menuconfig PARPORT
 	tristate "Parallel port support"
+	depends on HAS_IOMEM
 	---help---
 	  If you want to use devices connected to your machine's parallel port
 	  (the connector at the computer with 25 holes), e.g. printer, ZIP
@@ -33,9 +31,11 @@ config PARPORT
 
 	  If unsure, say Y.
 
+if PARPORT
+
 config PARPORT_PC
 	tristate "PC-style hardware"
-	depends on PARPORT && (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV
+	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
@@ -85,7 +85,7 @@ config PARPORT_PC_PCMCIA
 
 config PARPORT_IP32
 	tristate "SGI IP32 builtin port (EXPERIMENTAL)"
-	depends on SGI_IP32 && PARPORT && EXPERIMENTAL
+	depends on SGI_IP32 && EXPERIMENTAL
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port on
@@ -94,7 +94,7 @@ config PARPORT_IP32
 
 config PARPORT_AMIGA
 	tristate "Amiga builtin port"
-	depends on AMIGA && PARPORT
+	depends on AMIGA
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port hardware on
@@ -103,7 +103,7 @@ config PARPORT_AMIGA
 
 config PARPORT_MFC3
 	tristate "Multiface III parallel port"
-	depends on ZORRO && PARPORT
+	depends on ZORRO
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need parallel port support for the MFC3 card.
@@ -112,7 +112,7 @@ config PARPORT_MFC3
 
 config PARPORT_ATARI
 	tristate "Atari hardware"
-	depends on ATARI && PARPORT
+	depends on ATARI
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port hardware on
@@ -122,12 +122,11 @@ config PARPORT_ATARI
 config PARPORT_GSC
 	tristate
 	default GSC
-	depends on PARPORT
 	select PARPORT_NOT_PC
 
 config PARPORT_SUNBPP
 	tristate "Sparc hardware (EXPERIMENTAL)"
-	depends on SBUS && PARPORT && EXPERIMENTAL
+	depends on SBUS && EXPERIMENTAL
 	select PARPORT_NOT_PC
 	help
 	  This driver provides support for the bidirectional parallel port
@@ -136,7 +135,6 @@ config PARPORT_SUNBPP
 
 config PARPORT_AX88796
 	tristate "AX88796 Parallel Port"
-	depends on PARPORT
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port hardware on
@@ -148,7 +146,6 @@ config PARPORT_AX88796
 
 config PARPORT_1284
 	bool "IEEE 1284 transfer modes"
-	depends on PARPORT
 	help
 	  If you have a printer that supports status readback or device ID, or
 	  want to use a device that uses enhanced parallel port transfer modes
@@ -159,5 +156,4 @@ config PARPORT_1284
 config PARPORT_NOT_PC
 	bool
 
-endmenu
-
+endif # PARPORT
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch

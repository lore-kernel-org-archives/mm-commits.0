From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-edac.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:16 -0700
Message-ID: <200707162052.l6GKqGXo001524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759356AbXGPVZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:25:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - EDAC
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-edac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - EDAC
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/edac/Kconfig~use-menuconfig-objects-ii-edac drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~use-menuconfig-objects-ii-edac
+++ a/drivers/edac/Kconfig
@@ -6,11 +6,9 @@
 # $Id: Kconfig,v 1.4.2.7 2005/07/08 22:05:38 dsp_llnl Exp $
 #
 
-menu 'EDAC - error detection and reporting (RAS) (EXPERIMENTAL)'
+menuconfig EDAC
+	tristate "EDAC - error detection and reporting (EXPERIMENTAL)"
 	depends on HAS_IOMEM
-
-config EDAC
-	tristate "EDAC core system error reporting (EXPERIMENTAL)"
 	depends on X86 && EXPERIMENTAL
 	help
 	  EDAC is designed to report errors in the core system.
@@ -30,13 +28,12 @@ config EDAC
 	  There is also a mailing list for the EDAC project, which can
 	  be found via the sourceforge page.
 
+if EDAC
 
 comment "Reporting subsystems"
-	depends on EDAC
 
 config EDAC_DEBUG
 	bool "Debugging"
-	depends on EDAC
 	help
 	  This turns on debugging information for the entire EDAC
 	  sub-system. You can insert module with "debug_level=x", current
@@ -45,7 +42,6 @@ config EDAC_DEBUG
 
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
-	depends on EDAC
 	default y
 	help
 	  Some systems are able to detect and correct errors in main
@@ -100,15 +96,13 @@ config EDAC_R82600
 
 choice
 	prompt "Error detecting method"
-	depends on EDAC
 	default EDAC_POLL
 
 config EDAC_POLL
 	bool "Poll for errors"
-	depends on EDAC
 	help
 	  Poll the chipset periodically to detect errors.
 
 endchoice
 
-endmenu
+endif # EDAC
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

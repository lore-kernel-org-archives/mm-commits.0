From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-tpm.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:34 -0700
Message-ID: <200707162052.l6GKqYcH001555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762083AbXGPVfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, kjhall@us.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - TPM
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-tpm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - TPM
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/Kconfig |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/char/tpm/Kconfig~use-menuconfig-objects-ii-tpm drivers/char/tpm/Kconfig
--- a/drivers/char/tpm/Kconfig~use-menuconfig-objects-ii-tpm
+++ a/drivers/char/tpm/Kconfig
@@ -2,11 +2,9 @@
 # TPM device configuration
 #
 
-menu "TPM devices"
-	depends on HAS_IOMEM
-
-config TCG_TPM
+menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
+	depends on HAS_IOMEM
 	depends on EXPERIMENTAL
 	---help---
 	  If you have a TPM security chip in your system, which
@@ -21,9 +19,11 @@ config TCG_TPM
 	  Note: For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
 	  and CONFIG_PNPACPI.
 
+if TCG_TPM
+
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface"
-	depends on TCG_TPM && PNPACPI
+	depends on PNPACPI
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
@@ -32,7 +32,7 @@ config TCG_TIS
 
 config TCG_NSC
 	tristate "National Semiconductor TPM Interface"
-	depends on TCG_TPM && PNPACPI
+	depends on PNPACPI
 	---help---
 	  If you have a TPM security chip from National Semiconductor 
 	  say Yes and it will be accessible from within Linux.  To 
@@ -41,7 +41,6 @@ config TCG_NSC
 
 config TCG_ATMEL
 	tristate "Atmel TPM Interface"
-	depends on TCG_TPM
 	---help---
 	  If you have a TPM security chip from Atmel say Yes and it 
 	  will be accessible from within Linux.  To compile this driver 
@@ -49,7 +48,7 @@ config TCG_ATMEL
 
 config TCG_INFINEON
 	tristate "Infineon Technologies TPM Interface"
-	depends on TCG_TPM && PNPACPI
+	depends on PNPACPI
 	---help---
 	  If you have a TPM security chip from Infineon Technologies
 	  (either SLD 9630 TT 1.1 or SLB 9635 TT 1.2) say Yes and it
@@ -59,5 +58,4 @@ config TCG_INFINEON
 	  Further information on this driver and the supported hardware
 	  can be found at http://www.prosec.rub.de/tpm
 
-endmenu
-
+endif # TCG_TPM
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

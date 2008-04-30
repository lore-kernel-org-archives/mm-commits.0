From: akpm@linux-foundation.org
Subject: - tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:01 -0700
Message-ID: <200804300549.m3U5n1Hq029935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbYD3G1c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:27:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, kjhall@us.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm: change Kconfig dependencies from PNPACPI to PNP
has been removed from the -mm tree.  Its filename was
     tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: change Kconfig dependencies from PNPACPI to PNP
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

There is no "PNPACPI" driver interface as such.  PNPACPI is an internal
backend of PNP, and drivers just use the generic PNP interface.

The drivers should depend on CONFIG_PNP, not CONFIG_PNPACPI.

tpm_nsc.c doesn't use PNP at all, so we can just remove the dependency
completely.  It probably *should* use PNP to discover the device, but until it
does, there's no point in depending on PNP.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/char/tpm/Kconfig~tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp drivers/char/tpm/Kconfig
--- a/drivers/char/tpm/Kconfig~tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp
+++ a/drivers/char/tpm/Kconfig
@@ -23,7 +23,7 @@ if TCG_TPM
 
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface"
-	depends on PNPACPI
+	depends on PNP
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
@@ -32,7 +32,6 @@ config TCG_TIS
 
 config TCG_NSC
 	tristate "National Semiconductor TPM Interface"
-	depends on PNPACPI
 	---help---
 	  If you have a TPM security chip from National Semiconductor 
 	  say Yes and it will be accessible from within Linux.  To 
@@ -48,7 +47,7 @@ config TCG_ATMEL
 
 config TCG_INFINEON
 	tristate "Infineon Technologies TPM Interface"
-	depends on PNPACPI
+	depends on PNP
 	---help---
 	  If you have a TPM security chip from Infineon Technologies
 	  (either SLD 9630 TT 1.1 or SLB 9635 TT 1.2) say Yes and it
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
acpi_pm_device_sleep_state-cleanup.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch


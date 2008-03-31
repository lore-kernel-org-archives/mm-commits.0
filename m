From: akpm@linux-foundation.org
Subject: + tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:21:50 -0700
Message-ID: <200803312121.m2VLLojv026615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757367AbYCaVWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, kjhall@us.ibm.com, tpm@selhorst.net


The patch titled
     tpm: change Kconfig dependencies from PNPACPI to PNP
has been added to the -mm tree.  Its filename is
     tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-acpi.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
revert-gregkh-pci-pci-alpha-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ia64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-powerpc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch
hisax-depend-on-config_pnp-not-__isapnp__.patch


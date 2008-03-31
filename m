From: akpm@linux-foundation.org
Subject: + nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch added to -mm tree
Date: Mon, 31 Mar 2008 16:03:24 -0700
Message-ID: <200803312303.m2VN3PSZ030464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbYCaXDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 19:03:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, kamalesh@linux.vnet.ibm.com, samuel@sortiz.org, sfr@canb.auug.org.au


The patch titled
     nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
has been added to the -mm tree.  Its filename is
     nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

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
Subject: nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Wrap PNP probe code in #ifdef CONFIG_PNP.

Without this change, we'll have unresolved references to pnp_get_resource()
function when CONFIG_PNP=n.  (This is a new interface that's not in mainline
yet.)

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/nsc-ircc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/net/irda/nsc-ircc.c~nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp drivers/net/irda/nsc-ircc.c
--- a/drivers/net/irda/nsc-ircc.c~nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp
+++ a/drivers/net/irda/nsc-ircc.c
@@ -100,7 +100,6 @@ static int nsc_ircc_probe_39x(nsc_chip_t
 static int nsc_ircc_init_108(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_338(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_39x(nsc_chip_t *chip, chipio_t *info);
-static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id);
 
 /* These are the known NSC chips */
 static nsc_chip_t chips[] = {
@@ -145,8 +144,10 @@ static char *dongle_types[] = {
 	"No dongle connected",
 };
 
-/* PNP probing */
 static chipio_t pnp_info;
+
+#ifdef CONFIG_PNP
+/* PNP probing */
 static const struct pnp_device_id nsc_ircc_pnp_table[] = {
 	{ .id = "NSC6001", .driver_data = 0 },
 	{ .id = "IBM0071", .driver_data = 0 },
@@ -155,11 +156,16 @@ static const struct pnp_device_id nsc_ir
 
 MODULE_DEVICE_TABLE(pnp, nsc_ircc_pnp_table);
 
+static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id);
+
 static struct pnp_driver nsc_ircc_pnp_driver = {
 	.name = "nsc-ircc",
 	.id_table = nsc_ircc_pnp_table,
 	.probe = nsc_ircc_pnp_probe,
 };
+#else
+static struct pnp_driver nsc_ircc_pnp_driver;
+#endif
 
 /* Some prototypes */
 static int  nsc_ircc_open(chipio_t *info);
@@ -916,6 +922,7 @@ static int nsc_ircc_probe_39x(nsc_chip_t
 	return 0;
 }
 
+#ifdef CONFIG_PNP
 /* PNP probing */
 static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id)
 {
@@ -952,6 +959,7 @@ static int nsc_ircc_pnp_probe(struct pnp
 
 	return 0;
 }
+#endif
 
 /*
  * Function nsc_ircc_setup (info)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

git-acpi.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
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
hisax-depend-on-config_pnp-not-__isapnp__.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch


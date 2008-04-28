From: akpm@linux-foundation.org
Subject: - hisax-depend-on-config_pnp-not-__isapnp__.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:51 -0700
Message-ID: <200804282156.m3SLupsa018273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935593AbYD1V5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     hisax: depend on CONFIG_PNP, not __ISAPNP__
has been removed from the -mm tree.  Its filename was
     hisax-depend-on-config_pnp-not-__isapnp__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hisax: depend on CONFIG_PNP, not __ISAPNP__
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

The PNP driver interfaces depend on CONFIG_PNP, so test that rather than
__ISAPNP__.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/hisax_fcpcipnp.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/hisax/hisax_fcpcipnp.c~hisax-depend-on-config_pnp-not-__isapnp__ drivers/isdn/hisax/hisax_fcpcipnp.c
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c~hisax-depend-on-config_pnp-not-__isapnp__
+++ a/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -68,7 +68,7 @@ static struct pci_device_id fcpci_ids[] 
 
 MODULE_DEVICE_TABLE(pci, fcpci_ids);
 
-#ifdef __ISAPNP__
+#ifdef CONFIG_PNP
 static struct pnp_device_id fcpnp_ids[] __devinitdata = {
 	{ 
 		.id		= "AVM0900",
@@ -914,7 +914,7 @@ static int __devinit fcpci_probe(struct 
 	return retval;
 }
 
-#ifdef __ISAPNP__
+#ifdef CONFIG_PNP
 static int __devinit fcpnp_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 {
 	struct fritz_adapter *adapter;
@@ -974,6 +974,8 @@ static struct pnp_driver fcpnp_driver = 
 	.remove		= __devexit_p(fcpnp_remove),
 	.id_table	= fcpnp_ids,
 };
+#else
+static struct pnp_driver fcpnp_driver;
 #endif
 
 static void __devexit fcpci_remove(struct pci_dev *pdev)
@@ -1001,7 +1003,7 @@ static int __init hisax_fcpcipnp_init(vo
 	retval = pci_register_driver(&fcpci_driver);
 	if (retval)
 		return retval;
-#ifdef __ISAPNP__
+#ifdef CONFIG_PNP
 	retval = pnp_register_driver(&fcpnp_driver);
 	if (retval < 0) {
 		pci_unregister_driver(&fcpci_driver);
@@ -1013,7 +1015,7 @@ static int __init hisax_fcpcipnp_init(vo
 
 static void __exit hisax_fcpcipnp_exit(void)
 {
-#ifdef __ISAPNP__
+#ifdef CONFIG_PNP
 	pnp_unregister_driver(&fcpnp_driver);
 #endif
 	pci_unregister_driver(&fcpci_driver);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
simplify-initcall_debug-output.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch


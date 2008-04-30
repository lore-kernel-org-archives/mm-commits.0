From: akpm@linux-foundation.org
Subject: - parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:56 -0700
Message-ID: <200804300548.m3U5mu2v029928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758791AbYD3Ftc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
has been removed from the -mm tree.  Its filename was
     parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Wrap PNP probe code in #ifdef CONFIG_PNP.  We already do the same for
CONFIG_PCI.

Without this change, we'll have unresolved references to pnp_get_resource()
function when CONFIG_PNP=n.  (This is a new interface that's not in mainline
yet.)

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/parport/parport_pc.c~parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp
+++ a/drivers/parport/parport_pc.c
@@ -3082,6 +3082,7 @@ static struct pci_driver parport_pc_pci_
 static int __init parport_pc_init_superio(int autoirq, int autodma) {return 0;}
 #endif /* CONFIG_PCI */
 
+#ifdef CONFIG_PNP
 
 static const struct pnp_device_id parport_pc_pnp_tbl[] = {
 	/* Standard LPT Printer Port */
@@ -3148,6 +3149,9 @@ static struct pnp_driver parport_pc_pnp_
 	.remove		= parport_pc_pnp_remove,
 };
 
+#else
+static struct pnp_driver parport_pc_pnp_driver;
+#endif /* CONFIG_PNP */
 
 static int __devinit parport_pc_platform_probe(struct platform_device *pdev)
 {
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
acpi_pm_device_sleep_state-cleanup.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch


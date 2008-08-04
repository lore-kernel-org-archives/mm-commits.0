From: akpm@linux-foundation.org
Subject: - amd64-agp-run-fallback-when-no-bridges-found-not-when-driver-registration-fails.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:11 -0700
Message-ID: <200808042006.m74K6BBC027660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbYHDUGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     amd64-agp: run fallback when no bridges found, not when driver registration fails
has been removed from the -mm tree.  Its filename was
     amd64-agp-run-fallback-when-no-bridges-found-not-when-driver-registration-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: amd64-agp: run fallback when no bridges found, not when driver registration fails
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

I think the intent was that if no bridges matched agp_amd64_pci_table[],
we would fall back to checking for any bridge with the AGP capability. 
But in the current code, we execute the fallback path only when
pci_register_driver() itself fails, which is unrelated to whether any
matching devices were found.

This patch counts the AGP bridges found in the probe() method and executes
the fallback path when none is found.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd64-agp.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/char/agp/amd64-agp.c~amd64-agp-run-fallback-when-no-bridges-found-not-when-driver-registration-fails drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~amd64-agp-run-fallback-when-no-bridges-found-not-when-driver-registration-fails
+++ a/drivers/char/agp/amd64-agp.c
@@ -34,6 +34,7 @@
 
 static struct resource *aperture_resource;
 static int __initdata agp_try_unsupported = 1;
+static int agp_bridges_found;
 
 static void amd64_tlbflush(struct agp_memory *temp)
 {
@@ -489,6 +490,7 @@ static int __devinit agp_amd64_probe(str
 {
 	struct agp_bridge_data *bridge;
 	u8 cap_ptr;
+	int err;
 
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
@@ -536,7 +538,12 @@ static int __devinit agp_amd64_probe(str
 	}
 
 	pci_set_drvdata(pdev, bridge);
-	return agp_add_bridge(bridge);
+	err = agp_add_bridge(bridge);
+	if (err < 0)
+		return err;
+
+	agp_bridges_found++;
+	return 0;
 }
 
 static void __devexit agp_amd64_remove(struct pci_dev *pdev)
@@ -713,7 +720,11 @@ int __init agp_amd64_init(void)
 
 	if (agp_off)
 		return -EINVAL;
-	if (pci_register_driver(&agp_amd64_pci_driver) < 0) {
+	err = pci_register_driver(&agp_amd64_pci_driver);
+	if (err < 0)
+		return err;
+
+	if (agp_bridges_found == 0) {
 		struct pci_dev *dev;
 		if (!agp_try_unsupported && !agp_try_unsupported_boot) {
 			printk(KERN_INFO PFX "No supported AGP bridge found.\n");
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch


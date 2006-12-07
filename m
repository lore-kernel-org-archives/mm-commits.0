From: akpm@osdl.org
Subject: - pci-quirks-remove-redundant-check.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:18:51 -0800
Message-ID: <200612072318.kB7NIpst031062@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54073 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163948AbWLGXTD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@cs.washington.edu, gregkh@suse.de, mj@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     pci quirks: remove redundant check
has been removed from the -mm tree.  Its filename was
     pci-quirks-remove-redundant-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci quirks: remove redundant check
From: David Rientjes <rientjes@cs.washington.edu>

Removes redundant check for dev->subordinate; if it is NULL, the function
returns before the patch-affected code region.

Cc: Martin Mares <mj@ucw.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: David Rientjes <rientjes@cs.washington.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/quirks.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/pci/quirks.c~pci-quirks-remove-redundant-check drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-remove-redundant-check
+++ a/drivers/pci/quirks.c
@@ -1741,8 +1741,7 @@ static void __devinit quirk_nvidia_ck804
 	pdev = pci_get_slot(dev->bus, 0);
 	if (!pdev)
 		return;
-	if (dev->subordinate && !msi_ht_cap_enabled(dev)
-	    && !msi_ht_cap_enabled(pdev)) {
+	if (!msi_ht_cap_enabled(dev) && !msi_ht_cap_enabled(pdev)) {
 		printk(KERN_WARNING "PCI: MSI quirk detected. "
 		       "MSI disabled on chipset %s.\n",
 		       pci_name(dev));
_

Patches currently in -mm which might be from rientjes@cs.washington.edu are

origin.patch
video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch
hrtimers-clean-up-locking-fix.patch


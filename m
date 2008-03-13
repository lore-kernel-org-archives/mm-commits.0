From: akpm@linux-foundation.org
Subject: - pci-simplify-quirk-debug-output.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:49 -0700
Message-ID: <200803131859.m2DIxnMC027985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbYCMTC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     PCI: simplify quirk debug output
has been removed from the -mm tree.  Its filename was
     pci-simplify-quirk-debug-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI: simplify quirk debug output
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

print_fn_descriptor_symbol() prints the address if we don't have a symbol,
so no need to print both.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/quirks.c~pci-simplify-quirk-debug-output drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-simplify-quirk-debug-output
+++ a/drivers/pci/quirks.c
@@ -1501,8 +1501,8 @@ static void pci_do_fixups(struct pci_dev
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
  		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
 #ifdef DEBUG
-			dev_dbg(&dev->dev, "calling quirk 0x%p", f->hook);
-			print_fn_descriptor_symbol(": %s()\n",
+			dev_dbg(&dev->dev, "calling ");
+			print_fn_descriptor_symbol("%s()\n",
 				(unsigned long) f->hook);
 #endif
 			f->hook(dev);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch


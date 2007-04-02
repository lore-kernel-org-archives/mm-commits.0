From: akpm@linux-foundation.org
Subject: - flush-msi-x-table-writes.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:04:14 -0700
Message-ID: <200704022304.l32N4EDd011967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52011 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966077AbXDBXEQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:04:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitch.a.williams@intel.com, ebiederm@xmission.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Flush MSI-X table writes
has been removed from the -mm tree.  Its filename was
     flush-msi-x-table-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Flush MSI-X table writes
From: Mitch Williams <mitch.a.williams@intel.com>

Fix a kernel bug which is triggered when using the irqbalance daemon with
MSI-X hardware.

Because both MSI-X interrupt messages and MSI-X table writes are posted,
it's possible for them to cross while in-flight.  This results in
interrupts being received long after the kernel thinks they're disabled,
and in interrupts being sent to stale vectors after rebalancing.

This patch performs a read flush after writes to the MSI-X table for mask
and unmask operations.  Since the SMP affinity is set while the interrupt
is masked, and since it's unmasked immediately after, no additional flushes
are required in the various affinity setting routines.

This patch has been validated with (unreleased) network hardware which
uses MSI-X.

Revised with input from Eric Biederman.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+)

diff -puN drivers/pci/msi.c~flush-msi-x-table-writes drivers/pci/msi.c
--- a/drivers/pci/msi.c~flush-msi-x-table-writes
+++ a/drivers/pci/msi.c
@@ -56,6 +56,28 @@ static void msix_set_enable(struct pci_d
 	}
 }
 
+static void msix_flush_writes(unsigned int irq)
+{
+	struct msi_desc *entry;
+
+	entry = get_irq_msi(irq);
+	BUG_ON(!entry || !entry->dev);
+	switch (entry->msi_attrib.type) {
+	case PCI_CAP_ID_MSI:
+		/* nothing to do */
+		break;
+	case PCI_CAP_ID_MSIX: {
+		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
+			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
+		readl(entry->mask_base + offset);
+		break;
+	}
+	default:
+		BUG();
+		break;
+	}
+}
+
 static void msi_set_mask_bit(unsigned int irq, int flag)
 {
 	struct msi_desc *entry;
@@ -174,11 +196,13 @@ void write_msi_msg(unsigned int irq, str
 void mask_msi_irq(unsigned int irq)
 {
 	msi_set_mask_bit(irq, 1);
+	msix_flush_writes(irq);
 }
 
 void unmask_msi_irq(unsigned int irq)
 {
 	msi_set_mask_bit(irq, 0);
+	msix_flush_writes(irq);
 }
 
 static int msi_free_irq(struct pci_dev* dev, int irq);
_

Patches currently in -mm which might be from mitch.a.williams@intel.com are

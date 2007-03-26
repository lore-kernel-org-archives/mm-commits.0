From: akpm@linux-foundation.org
Subject: + msi-read-flush-msi-x-table.patch added to -mm tree
Date: Mon, 26 Mar 2007 16:32:48 -0700
Message-ID: <200703262332.l2QNWmOT001072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58838 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933757AbXCZXcv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 19:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mitch.a.williams@intel.com, ebiederm@xmission.com, greg@kroah.com


The patch titled
     MSI: read-flush MSI-X table
has been added to the -mm tree.  Its filename is
     msi-read-flush-msi-x-table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MSI: read-flush MSI-X table
From: Mitch Williams <mitch.a.williams@intel.com>

This patch fixes a kernel bug which is triggered when using the irqbalance
daemon with MSI-X hardware.

Because both MSI-X interrupt messages and MSI-X table writes are posted,
it's possible for them to cross while in-flight.  This results in
interrupts being received long after the kernel thinks they're disabled,
and in interrupts being sent to stale vectors after rebalancing.

This patch performs a read flush after writes to the MSI-X table for
enable/disable and rebalancing operations.  Because this is an expensive
operation, we do not perform the read flush after mask/unmask operations. 
Hardware which supports MSI-X typically also supports some sort of
interrupt moderation, so a read-flush is not necessary for mask/unmask
operations.

This patch has been validated with (unreleased) network hardware which
uses MSI-X.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/io_apic.c   |    2 +
 arch/ia64/kernel/msi_ia64.c  |    2 +
 arch/ia64/sn/kernel/msi_sn.c |    2 +
 arch/x86_64/kernel/io_apic.c |    4 +++
 drivers/pci/msi.c            |   34 +++++++++++++++++++++++++++++++++
 include/linux/msi.h          |    3 ++
 6 files changed, 47 insertions(+)

diff -puN arch/i386/kernel/io_apic.c~msi-read-flush-msi-x-table arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~msi-read-flush-msi-x-table
+++ a/arch/i386/kernel/io_apic.c
@@ -2594,6 +2594,8 @@ static void set_msi_irq_affinity(unsigne
  */
 static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
 	.ack		= ack_ioapic_irq,
diff -puN arch/ia64/kernel/msi_ia64.c~msi-read-flush-msi-x-table arch/ia64/kernel/msi_ia64.c
--- a/arch/ia64/kernel/msi_ia64.c~msi-read-flush-msi-x-table
+++ a/arch/ia64/kernel/msi_ia64.c
@@ -121,6 +121,8 @@ static int ia64_msi_retrigger_irq(unsign
  */
 static struct irq_chip ia64_msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.ack		= ia64_ack_msi_irq,
diff -puN arch/ia64/sn/kernel/msi_sn.c~msi-read-flush-msi-x-table arch/ia64/sn/kernel/msi_sn.c
--- a/arch/ia64/sn/kernel/msi_sn.c~msi-read-flush-msi-x-table
+++ a/arch/ia64/sn/kernel/msi_sn.c
@@ -224,6 +224,8 @@ static int sn_msi_retrigger_irq(unsigned
 
 static struct irq_chip sn_msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.ack		= sn_ack_msi_irq,
diff -puN arch/x86_64/kernel/io_apic.c~msi-read-flush-msi-x-table arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~msi-read-flush-msi-x-table
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1942,6 +1942,7 @@ static void set_msi_irq_affinity(unsigne
 	if (cpus_empty(tmp))
 		return;
 
+	msix_flush_writes(irq);
 	if (assign_irq_vector(irq, mask))
 		return;
 
@@ -1956,6 +1957,7 @@ static void set_msi_irq_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
+	msix_flush_writes(irq);
 	irq_desc[irq].affinity = mask;
 }
 #endif /* CONFIG_SMP */
@@ -1966,6 +1968,8 @@ static void set_msi_irq_affinity(unsigne
  */
 static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
 	.ack		= ack_apic_edge,
diff -puN drivers/pci/msi.c~msi-read-flush-msi-x-table drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-read-flush-msi-x-table
+++ a/drivers/pci/msi.c
@@ -68,6 +68,29 @@ static void msix_set_enable(struct pci_d
 	}
 }
 
+void msix_flush_writes(unsigned int irq)
+{
+	struct msi_desc *entry;
+
+	entry = get_irq_msi(irq);
+	BUG_ON(!entry || !entry->dev);
+	switch (entry->msi_attrib.type) {
+	case PCI_CAP_ID_MSI:
+		/* nothing to do */
+		break;
+	case PCI_CAP_ID_MSIX:
+	{
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
@@ -193,6 +216,17 @@ void unmask_msi_irq(unsigned int irq)
 	msi_set_mask_bit(irq, 0);
 }
 
+void disable_msi_irq(unsigned int irq)
+{
+	msi_set_mask_bit(irq, 1);
+	msix_flush_writes(irq);
+}
+
+void enable_msi_irq(unsigned int irq)
+{
+	msi_set_mask_bit(irq, 0);
+	msix_flush_writes(irq);
+}
 static int msi_free_irq(struct pci_dev* dev, int irq);
 
 static int msi_init(void)
diff -puN include/linux/msi.h~msi-read-flush-msi-x-table include/linux/msi.h
--- a/include/linux/msi.h~msi-read-flush-msi-x-table
+++ a/include/linux/msi.h
@@ -10,8 +10,11 @@ struct msi_msg {
 /* Helper functions */
 extern void mask_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
+extern void disable_msi_irq(unsigned int irq);
+extern void enable_msi_irq(unsigned int irq);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+extern void msix_flush_writes(unsigned int irq);
 
 struct msi_desc {
 	struct {
_

Patches currently in -mm which might be from mitch.a.williams@intel.com are

msi-read-flush-msi-x-table.patch

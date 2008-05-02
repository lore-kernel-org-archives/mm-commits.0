From: akpm@linux-foundation.org
Subject: - x86_64-restore-mask_bits-in-msi-shutdown.patch removed from -mm tree
Date: Fri, 02 May 2008 14:10:20 -0700
Message-ID: <200805022110.m42LAKDC015126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936367AbYEBVLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 17:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel.send@gmail.com, aabdulla@nvidia.com, ebiederm@xmission.com, jeff@garzik.org, mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: restore mask_bits in msi shutdown
has been removed from the -mm tree.  Its filename was
     x86_64-restore-mask_bits-in-msi-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: restore mask_bits in msi shutdown
From: Yinghai Lu <yhlu.kernel.send@gmail.com>

I can not kexec RHEL 5.1 from 2.6.25-rc3 later

caused by:
commit 89d694b9dbe769ca1004e01db0ca43964806a611
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Feb 18 18:25:17 2008 +0100

    genirq: do not leave interupts enabled on free_irq

    The default_disable() function was changed in commit:

     76d2160147f43f982dfe881404cfde9fd0a9da21
     genirq: do not mask interrupts by default

    It removed the mask function in favour of the default delayed
    interrupt disabling. Unfortunately this also broke the shutdown in
    free_irq() when the last handler is removed from the interrupt for
    those architectures which rely on the default implementations. Now we
    can end up with a enabled interrupt line after the last handler was
    removed, which can result in spurious interrupts.

    Fix this by adding a default_shutdown function, which is only
    installed, when the irqchip implementation does provide neither a
    shutdown nor a disable function.

    [@stable: affected versions: .21 - .24 ]

for MSI, default_shutdown will call mask_bit for msi device.  so all mask bits
will left disabled after free_irq.  then if kexec next kernel that only can
use msi_enable bit.  all device's MSI can not be used.

So try to restore MSI mask bits that is saved before using msi in first
kernel.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/io_apic_64.c |    9 +++++++++
 drivers/pci/msi.c            |   26 ++++++++++++++++++++++++++
 include/linux/msi.h          |    2 ++
 3 files changed, 37 insertions(+)

diff -puN arch/x86/kernel/io_apic_64.c~x86_64-restore-mask_bits-in-msi-shutdown arch/x86/kernel/io_apic_64.c
--- a/arch/x86/kernel/io_apic_64.c~x86_64-restore-mask_bits-in-msi-shutdown
+++ a/arch/x86/kernel/io_apic_64.c
@@ -2001,6 +2001,14 @@ static void set_msi_irq_affinity(unsigne
 }
 #endif /* CONFIG_SMP */
 
+static void msi_shutdown(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	msi_restore_mask_bits(irq);
+	desc->status |= IRQ_MASKED;
+}
+
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
@@ -2010,6 +2018,7 @@ static struct irq_chip msi_chip = {
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
 	.ack		= ack_apic_edge,
+	.shutdown	= msi_shutdown,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_msi_irq_affinity,
 #endif
diff -puN drivers/pci/msi.c~x86_64-restore-mask_bits-in-msi-shutdown drivers/pci/msi.c
--- a/drivers/pci/msi.c~x86_64-restore-mask_bits-in-msi-shutdown
+++ a/drivers/pci/msi.c
@@ -123,6 +123,31 @@ static void msix_flush_writes(unsigned i
 	}
 }
 
+void msi_restore_mask_bits(unsigned int irq)
+{
+	struct msi_desc *entry;
+
+	entry = get_irq_msi(irq);
+	BUG_ON(!entry || !entry->dev);
+	switch (entry->msi_attrib.type) {
+	case PCI_CAP_ID_MSI:
+		if (entry->msi_attrib.maskbit) {
+			int pos;
+			u32 mask_bits;
+
+			pos = (long)entry->mask_base;
+			mask_bits = entry->orig_mask_bits;
+			pci_write_config_dword(entry->dev, pos, mask_bits);
+		}
+		break;
+	case PCI_CAP_ID_MSIX:
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
 static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 {
 	struct msi_desc *entry;
@@ -377,6 +402,7 @@ static int msi_capability_init(struct pc
 		pci_read_config_dword(dev,
 			msi_mask_bits_reg(pos, is_64bit_address(control)),
 			&maskbits);
+		entry->orig_mask_bits = maskbits;
 		temp = (1 << multi_msi_capable(control));
 		temp = ((temp - 1) & ~temp);
 		maskbits |= temp;
diff -puN include/linux/msi.h~x86_64-restore-mask_bits-in-msi-shutdown include/linux/msi.h
--- a/include/linux/msi.h~x86_64-restore-mask_bits-in-msi-shutdown
+++ a/include/linux/msi.h
@@ -14,6 +14,7 @@ extern void mask_msi_irq(unsigned int ir
 extern void unmask_msi_irq(unsigned int irq);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+extern void msi_restore_mask_bits(unsigned int irq);
 
 struct msi_desc {
 	struct {
@@ -31,6 +32,7 @@ struct msi_desc {
 	struct list_head list;
 
 	void __iomem *mask_base;
+	u32 orig_mask_bits;  /* restoring it for freeing */
 	struct pci_dev *dev;
 
 	/* Last set MSI message */
_

Patches currently in -mm which might be from yhlu.kernel.send@gmail.com are

origin.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
git-pci-current.patch


From: akpm@linux-foundation.org
Subject: + intel-iommu-dmar-fault-handling-support.patch added to -mm tree
Date: Mon, 25 Jun 2007 23:43:05 -0700
Message-ID: <200706260643.l5Q6h5Mn020239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbXFZGnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 02:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, muli@il.ibm.com, suresh.b.siddha@intel.com


The patch titled
     Intel IOMMU: DMAR fault handling support
has been added to the -mm tree.  Its filename is
     intel-iommu-dmar-fault-handling-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel IOMMU: DMAR fault handling support
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

MSI interrupt handler registrations and fault handling support for Intel-IOMMU
hadrware.

This patch enables the MSI interrupts for the DMA remapping units and in the
interrupt handler read the fault cause and outputs the same on to the console.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Intel-IOMMU.txt |   17 ++
 arch/x86_64/kernel/io_apic.c  |   59 +++++++++
 drivers/pci/intel-iommu.c     |  194 ++++++++++++++++++++++++++++++++
 include/linux/dmar.h          |   12 +
 4 files changed, 281 insertions(+), 1 deletion(-)

diff -puN Documentation/Intel-IOMMU.txt~intel-iommu-dmar-fault-handling-support Documentation/Intel-IOMMU.txt
--- a/Documentation/Intel-IOMMU.txt~intel-iommu-dmar-fault-handling-support
+++ a/Documentation/Intel-IOMMU.txt
@@ -63,6 +63,15 @@ Interrupt ranges are not address transla
 The same is true for peer to peer transactions. Hence we reserve the
 address from PCI MMIO ranges so they are not allocated for IOVA addresses.
 
+
+Fault reporting
+---------------
+When errors are reported, the DMA engine signals via an interrupt. The fault
+reason and device that caused it with fault reason is printed on console.
+
+See below for sample.
+
+
 Boot Message Sample
 -------------------
 
@@ -85,6 +94,14 @@ When DMAR is enabled for use, you will n
 
 PCI-DMA: Using DMAR IOMMU
 
+Fault reporting
+---------------
+
+DMAR:[DMA Write] Request device [00:02.0] fault addr 6df084000
+DMAR:[fault reason 05] PTE Write access is not set
+DMAR:[DMA Write] Request device [00:02.0] fault addr 6df084000
+DMAR:[fault reason 05] PTE Write access is not set
+
 TBD
 ----
 
diff -puN arch/x86_64/kernel/io_apic.c~intel-iommu-dmar-fault-handling-support arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~intel-iommu-dmar-fault-handling-support
+++ a/arch/x86_64/kernel/io_apic.c
@@ -31,6 +31,7 @@
 #include <linux/sysdev.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
+#include <linux/dmar.h>
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
@@ -2027,8 +2028,64 @@ void arch_teardown_msi_irq(unsigned int 
 	destroy_irq(irq);
 }
 
-#endif /* CONFIG_PCI_MSI */
+#ifdef CONFIG_DMAR
+#ifdef CONFIG_SMP
+static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
+{
+	struct irq_cfg *cfg = irq_cfg + irq;
+	struct msi_msg msg;
+	unsigned int dest;
+	cpumask_t tmp;
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	dmar_msi_read(irq, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	dmar_msi_write(irq, &msg);
+	irq_desc[irq].affinity = mask;
+}
+#endif /* CONFIG_SMP */
+
+struct irq_chip dmar_msi_type = {
+	.name = "DMAR_MSI",
+	.unmask = dmar_msi_unmask,
+	.mask = dmar_msi_mask,
+	.ack = ack_apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity = dmar_msi_set_affinity,
+#endif
+	.retrigger = ioapic_retrigger_irq,
+};
+
+int arch_setup_dmar_msi(unsigned int irq)
+{
+	int ret;
+	struct msi_msg msg;
+
+	ret = msi_compose_msg(NULL, irq, &msg);
+	if (ret < 0)
+		return ret;
+	dmar_msi_write(irq, &msg);
+	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
+		"edge");
+	return 0;
+}
+#endif
 
+#endif /* CONFIG_PCI_MSI */
 /*
  * Hypertransport interrupt support
  */
diff -puN drivers/pci/intel-iommu.c~intel-iommu-dmar-fault-handling-support drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-dmar-fault-handling-support
+++ a/drivers/pci/intel-iommu.c
@@ -742,6 +742,196 @@ static int iommu_disable_translation(str
 	return 0;
 }
 
+/* iommu interrupt handling. Most stuff are MSI-like. */
+
+static char *fault_reason_strings[] =
+{
+	"Software",
+	"Present bit in root entry is clear",
+	"Present bit in context entry is clear",
+	"Invalid context entry",
+	"Access beyond MGAW",
+	"PTE Write access is not set",
+	"PTE Read access is not set",
+	"Next page table ptr is invalid",
+	"Root table address invalid",
+	"Context table ptr is invalid",
+	"non-zero reserved fields in RTP",
+	"non-zero reserved fields in CTP",
+	"non-zero reserved fields in PTE",
+	"Unknown"
+};
+#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings)
+
+char *dmar_get_fault_reason(u8 fault_reason)
+{
+	if (fault_reason > MAX_FAULT_REASON_IDX)
+		return fault_reason_strings[MAX_FAULT_REASON_IDX];
+	else
+		return fault_reason_strings[fault_reason];
+}
+
+void dmar_msi_unmask(unsigned int irq)
+{
+	struct intel_iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	/* unmask it */
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	writel(0, iommu->reg + DMAR_FECTL_REG);
+	/* Read a reg to force flush the post write */
+	readl(iommu->reg + DMAR_FECTL_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_mask(unsigned int irq)
+{
+	unsigned long flag;
+	struct intel_iommu *iommu = get_irq_data(irq);
+
+	/* mask it */
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	writel(DMA_FECTL_IM, iommu->reg + DMAR_FECTL_REG);
+	/* Read a reg to force flush the post write */
+	readl(iommu->reg + DMAR_FECTL_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_write(int irq, struct msi_msg *msg)
+{
+	struct intel_iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	writel(msg->data, iommu->reg + DMAR_FEDATA_REG);
+	writel(msg->address_lo, iommu->reg + DMAR_FEADDR_REG);
+	writel(msg->address_hi, iommu->reg + DMAR_FEUADDR_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_read(int irq, struct msi_msg *msg)
+{
+	struct intel_iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	msg->data = readl(iommu->reg + DMAR_FEDATA_REG);
+	msg->address_lo = readl(iommu->reg + DMAR_FEADDR_REG);
+	msg->address_hi = readl(iommu->reg + DMAR_FEUADDR_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+static int iommu_page_fault_do_one(struct intel_iommu *iommu, int type,
+		u8 fault_reason, u16 source_id, u64 addr)
+{
+	char *reason;
+
+	reason = dmar_get_fault_reason(fault_reason);
+
+	printk(KERN_ERR
+		"DMAR:[%s] Request device [%02x:%02x.%d] "
+		"fault addr %llx \n"
+		"DMAR:[fault reason %02d] %s\n",
+		(type ? "DMA Read" : "DMA Write"),
+		(source_id >> 8), PCI_SLOT(source_id & 0xFF),
+		PCI_FUNC(source_id & 0xFF), addr, fault_reason, reason);
+	return 0;
+}
+
+#define PRIMARY_FAULT_REG_LEN (16)
+static irqreturn_t iommu_page_fault(int irq, void *dev_id)
+{
+	struct intel_iommu *iommu = dev_id;
+	int reg, fault_index;
+	u32 fault_status;
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
+
+	/* TBD: ignore advanced fault log currently */
+	if (!(fault_status & DMA_FSTS_PPF))
+		goto clear_overflow;
+
+	fault_index = dma_fsts_fault_record_index(fault_status);
+	reg = cap_fault_reg_offset(iommu->cap);
+	while (1) {
+		u8 fault_reason;
+		u16 source_id;
+		u64 guest_addr;
+		int type;
+		u32 data;
+
+		/* highest 32 bits */
+		data = readl(iommu->reg + reg +
+				fault_index * PRIMARY_FAULT_REG_LEN + 12);
+		if (!(data & DMA_FRCD_F))
+			break;
+
+		fault_reason = dma_frcd_fault_reason(data);
+		type = dma_frcd_type(data);
+
+		data = readl(iommu->reg + reg +
+				fault_index * PRIMARY_FAULT_REG_LEN + 8);
+		source_id = dma_frcd_source_id(data);
+
+		guest_addr = dmar_readq(iommu->reg + reg +
+				fault_index * PRIMARY_FAULT_REG_LEN);
+		guest_addr = dma_frcd_page_addr(guest_addr);
+		/* clear the fault */
+		writel(DMA_FRCD_F, iommu->reg + reg +
+			fault_index * PRIMARY_FAULT_REG_LEN + 12);
+
+		spin_unlock_irqrestore(&iommu->register_lock, flag);
+
+		iommu_page_fault_do_one(iommu, type, fault_reason,
+				source_id, guest_addr);
+
+		fault_index++;
+		if (fault_index > cap_num_fault_regs(iommu->cap))
+			fault_index = 0;
+		spin_lock_irqsave(&iommu->register_lock, flag);
+	}
+clear_overflow:
+	/* clear primary fault overflow */
+	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
+	if (fault_status & DMA_FSTS_PFO)
+		writel(DMA_FSTS_PFO, iommu->reg + DMAR_FSTS_REG);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	return IRQ_HANDLED;
+}
+
+int dmar_set_interrupt(struct intel_iommu *iommu)
+{
+	int irq, ret;
+
+	irq = create_irq();
+	if (!irq) {
+		printk(KERN_ERR "IOMMU: no free vectors\n");
+		return -EINVAL;
+	}
+
+	set_irq_data(irq, iommu);
+	iommu->irq = irq;
+
+	ret = arch_setup_dmar_msi(irq);
+	if (ret) {
+		set_irq_data(irq, NULL);
+		iommu->irq = 0;
+		destroy_irq(irq);
+		return 0;
+	}
+
+	/* Force fault register is cleared */
+	iommu_page_fault(irq, iommu);
+
+	ret = request_irq(irq, iommu_page_fault, 0, iommu->name, iommu);
+	if (ret)
+		printk(KERN_ERR "IOMMU: can't request irq\n");
+	return ret;
+}
+
 static int iommu_init_domains(struct intel_iommu *iommu)
 {
 	unsigned long ndomains;
@@ -1489,6 +1679,10 @@ int __init init_dmars(void)
 
 		iommu_flush_write_buffer(iommu);
 
+		ret = dmar_set_interrupt(iommu);
+		if (ret)
+			goto error;
+
 		iommu_set_root_entry(iommu);
 
 		iommu_flush_context_global(iommu, 0);
diff -puN include/linux/dmar.h~intel-iommu-dmar-fault-handling-support include/linux/dmar.h
--- a/include/linux/dmar.h~intel-iommu-dmar-fault-handling-support
+++ a/include/linux/dmar.h
@@ -28,6 +28,18 @@
 #ifdef CONFIG_DMAR
 struct intel_iommu;
 
+extern char *dmar_get_fault_reason(u8 fault_reason);
+
+/* Can't use the common MSI interrupt functions
+ * since DMAR is not a pci device
+ */
+extern void dmar_msi_unmask(unsigned int irq);
+extern void dmar_msi_mask(unsigned int irq);
+extern void dmar_msi_read(int irq, struct msi_msg *msg);
+extern void dmar_msi_write(int irq, struct msi_msg *msg);
+extern int dmar_set_interrupt(struct intel_iommu *iommu);
+extern int arch_setup_dmar_msi(unsigned int irq);
+
 /* Intel IOMMU detection and initialization functions */
 extern void detect_intel_iommu(void);
 extern int intel_iommu_init(void);
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch

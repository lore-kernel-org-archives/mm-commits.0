From: akpm@linux-foundation.org
Subject: + msi-sanely-support-hardware-level-msi-disabling.patch added to -mm tree
Date: Wed, 28 Feb 2007 22:38:48 -0800
Message-ID: <200703010638.l216cmRd006633@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57664 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703AbXCAGi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 01:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, benh@kernel.crashing.org, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org


The patch titled
     msi: sanely support hardware level msi disabling
has been added to the -mm tree.  Its filename is
     msi-sanely-support-hardware-level-msi-disabling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: msi: sanely support hardware level msi disabling
From: Eric W. Biederman <ebiederm@xmission.com>

In some cases when we are not using msi we need a way to ensure that the
hardware does not have an msi capability enabled.  Currently the code has been
calling disable_msi_mode to try and achieve that.  However disable_msi_mode
has several other side effects and is only available when msi support is
compiled in so it isn't really appropriate.

Instead this patch implements pci_msi_off which disables all msi and msix
capabilities unconditionally with no additional side effects.

pci_disable_device was redundantly clearing the bus master enable flag and
clearing the msi enable bit.  A device that is not allowed to perform bus
mastering operations cannot generate intx or msi interrupt messages as those
are essentially a special case of dma, and require bus mastering.  So the call
in pci_disable_device to disable msi capabilities was redundant.

quirk_pcie_pxh also called disable_msi_mode and is updated to use pci_msi_off.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/irq.c |    1 -
 drivers/pci/msi.c         |    2 +-
 drivers/pci/pci.c         |   34 +++++++++++++++++++++++++++-------
 drivers/pci/pci.h         |    2 --
 drivers/pci/quirks.c      |    4 ++--
 include/linux/pci.h       |    1 +
 include/linux/pci_regs.h  |    7 ++++---
 7 files changed, 35 insertions(+), 16 deletions(-)

diff -puN arch/powerpc/kernel/irq.c~msi-sanely-support-hardware-level-msi-disabling arch/powerpc/kernel/irq.c
--- a/arch/powerpc/kernel/irq.c~msi-sanely-support-hardware-level-msi-disabling
+++ a/arch/powerpc/kernel/irq.c
@@ -968,7 +968,6 @@ void pci_scan_msi_device(struct pci_dev 
 int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec) {return -1;}
 void pci_disable_msix(struct pci_dev *dev) {}
 void msi_remove_pci_irq_vectors(struct pci_dev *dev) {}
-void disable_msi_mode(struct pci_dev *dev, int pos, int type) {}
 void pci_no_msi(void) {}
 EXPORT_SYMBOL(pci_enable_msix);
 EXPORT_SYMBOL(pci_disable_msix);
diff -puN drivers/pci/msi.c~msi-sanely-support-hardware-level-msi-disabling drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-sanely-support-hardware-level-msi-disabling
+++ a/drivers/pci/msi.c
@@ -211,7 +211,7 @@ static void enable_msi_mode(struct pci_d
 	pci_intx(dev, 0);  /* disable intx */
 }
 
-void disable_msi_mode(struct pci_dev *dev, int pos, int type)
+static void disable_msi_mode(struct pci_dev *dev, int pos, int type)
 {
 	u16 control;
 
diff -puN drivers/pci/pci.c~msi-sanely-support-hardware-level-msi-disabling drivers/pci/pci.c
--- a/drivers/pci/pci.c~msi-sanely-support-hardware-level-msi-disabling
+++ a/drivers/pci/pci.c
@@ -881,13 +881,6 @@ pci_disable_device(struct pci_dev *dev)
 	if (atomic_sub_return(1, &dev->enable_cnt) != 0)
 		return;
 
-	if (dev->msi_enabled)
-		disable_msi_mode(dev, pci_find_capability(dev, PCI_CAP_ID_MSI),
-			PCI_CAP_ID_MSI);
-	if (dev->msix_enabled)
-		disable_msi_mode(dev, pci_find_capability(dev, PCI_CAP_ID_MSI),
-			PCI_CAP_ID_MSIX);
-
 	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
 	if (pci_command & PCI_COMMAND_MASTER) {
 		pci_command &= ~PCI_COMMAND_MASTER;
@@ -1277,6 +1270,33 @@ pci_intx(struct pci_dev *pdev, int enabl
 	}
 }
 
+/**
+ * pci_msi_off - disables any msi or msix capabilities
+ * @pdev: the PCI device to operate on
+ *
+ * If you want to use msi see pci_enable_msi and friends.
+ * This is a lower level primitive that allows us to disable
+ * msi operation at the device level.
+ */
+void pci_msi_off(struct pci_dev *dev)
+{
+	int pos;
+	u16 control;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	if (pos) {
+		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
+		control &= ~PCI_MSI_FLAGS_ENABLE;
+		pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
+	}
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
+	if (pos) {
+		pci_read_config_word(dev, pos + PCI_MSIX_FLAGS, &control);
+		control &= ~PCI_MSIX_FLAGS_ENABLE;
+		pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
+	}
+}
+
 #ifndef HAVE_ARCH_PCI_SET_DMA_MASK
 /*
  * These can be overridden by arch-specific implementations
diff -puN drivers/pci/pci.h~msi-sanely-support-hardware-level-msi-disabling drivers/pci/pci.h
--- a/drivers/pci/pci.h~msi-sanely-support-hardware-level-msi-disabling
+++ a/drivers/pci/pci.h
@@ -46,10 +46,8 @@ extern struct rw_semaphore pci_bus_sem;
 extern unsigned int pci_pm_d3_delay;
 
 #ifdef CONFIG_PCI_MSI
-void disable_msi_mode(struct pci_dev *dev, int pos, int type);
 void pci_no_msi(void);
 #else
-static inline void disable_msi_mode(struct pci_dev *dev, int pos, int type) { }
 static inline void pci_no_msi(void) { }
 #endif
 
diff -puN drivers/pci/quirks.c~msi-sanely-support-hardware-level-msi-disabling drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~msi-sanely-support-hardware-level-msi-disabling
+++ a/drivers/pci/quirks.c
@@ -1415,8 +1415,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
  */
 static void __devinit quirk_pcie_pxh(struct pci_dev *dev)
 {
-	disable_msi_mode(dev, pci_find_capability(dev, PCI_CAP_ID_MSI),
-					PCI_CAP_ID_MSI);
+	pci_msi_off(dev);
+
 	dev->no_msi = 1;
 
 	printk(KERN_WARNING "PCI: PXH quirk detected, "
diff -puN include/linux/pci.h~msi-sanely-support-hardware-level-msi-disabling include/linux/pci.h
--- a/include/linux/pci.h~msi-sanely-support-hardware-level-msi-disabling
+++ a/include/linux/pci.h
@@ -543,6 +543,7 @@ void pci_set_master(struct pci_dev *dev)
 int __must_check pci_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
+void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
 void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno);
diff -puN include/linux/pci_regs.h~msi-sanely-support-hardware-level-msi-disabling include/linux/pci_regs.h
--- a/include/linux/pci_regs.h~msi-sanely-support-hardware-level-msi-disabling
+++ a/include/linux/pci_regs.h
@@ -292,9 +292,10 @@
 #define PCI_MSI_DATA_64		12	/* 16 bits of data for 64-bit devices */
 #define PCI_MSI_MASK_BIT	16	/* Mask bits register */
 
-/* MSI-X registers (these are at offset PCI_MSI_FLAGS) */
-#define PCI_MSIX_FLAGS_QSIZE	0x7FF
-#define PCI_MSIX_FLAGS_ENABLE	(1 << 15)
+/* MSI-X registers (these are at offset PCI_MSIX_FLAGS) */
+#define PCI_MSIX_FLAGS		2
+#define  PCI_MSIX_FLAGS_QSIZE	0x7FF
+#define  PCI_MSIX_FLAGS_ENABLE	(1 << 15)
 #define PCI_MSIX_FLAGS_BIRMASK	(7 << 0)
 #define PCI_MSIX_FLAGS_BITMASK	(1 << 0)
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
make-ipc-shmcshm_nopage-static.patch
mm-tiny-shmemc-cleanups.patch
fix-the-sysctl=n-compilation.patch
msi-sanely-support-hardware-level-msi-disabling.patch
msi-fixup-the-msi-enable-disable-logic.patch
msi-support-masking-msi-irqs-without-a-mask-bit.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
i386-irq-kill-irq-compression.patch
i386-irq-kill-irq-compression-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

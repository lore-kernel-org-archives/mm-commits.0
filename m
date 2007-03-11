From: akpm@linux-foundation.org
Subject: + msi-safer-state-caching.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:36:28 -0800
Message-ID: <200703110936.l2B9aS57008974@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41429 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbXCKJgc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:36:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, greg@kroah.com


The patch titled
     msi: safer state caching
has been added to the -mm tree.  Its filename is
     msi-safer-state-caching.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: msi: safer state caching
From: Eric W. Biederman <ebiederm@xmission.com>

There are two ways pci_save_state and pci_restore_state are used.  As helper
functions during suspend/resume, and as helper functions around a hardware
reset event.  When used as helper functions around a hardware reset event
there is no reason to believe the calls will be paired, nor is there a good
reason to believe that if we restore the msi state from before the reset that
it will match the current msi state.  Since arch code may change the msi
message without going through the driver, drivers currently do not have enough
information to even know when to call pci_save_state to ensure they will have
msi state in sync with the other kernel irq reception data structures.

It turns out the solution is straight forward, cache the state in the existing
msi data structures (not the magic pci saved things) and have the msi code
update the cached state each time we write to the hardware.  This means we
never need to read the hardware to figure out what the hardware state should
be.

By modifying the caching in this manner we get to remove our save_state
routines and only need to provide restore_state routines.

The only fields that were at all tricky to regenerate were the msi and msi-x
control registers and the way we regenerate them currently is a bit dependent
upon assumptions on how we use the allow msi registers to be configured and
used making the code a little bit brittle.  If we ever change what cases we
allow or how we configure the msi bits we can address the fragility then.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c        |  150 ++++++-------------------------------
 drivers/pci/pci.c        |    2 
 drivers/pci/pci.h        |    2 
 include/linux/msi.h      |    8 -
 include/linux/pci_regs.h |    1 
 5 files changed, 29 insertions(+), 134 deletions(-)

diff -puN drivers/pci/msi.c~msi-safer-state-caching drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-safer-state-caching
+++ a/drivers/pci/msi.c
@@ -100,6 +100,7 @@ static void msi_set_mask_bit(unsigned in
 		BUG();
 		break;
 	}
+	entry->msi_attrib.masked = !!flag;
 }
 
 void read_msi_msg(unsigned int irq, struct msi_msg *msg)
@@ -179,6 +180,7 @@ void write_msi_msg(unsigned int irq, str
 	default:
 		BUG();
 	}
+	entry->msg = *msg;
 }
 
 void mask_msi_irq(unsigned int irq)
@@ -225,164 +227,60 @@ static struct msi_desc* alloc_msi_entry(
 }
 
 #ifdef CONFIG_PM
-static int __pci_save_msi_state(struct pci_dev *dev)
-{
-	int pos, i = 0;
-	u16 control;
-	struct pci_cap_saved_state *save_state;
-	u32 *cap;
-
-	if (!dev->msi_enabled)
-		return 0;
-
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
-	if (pos <= 0)
-		return 0;
-
-	save_state = kzalloc(sizeof(struct pci_cap_saved_state) + sizeof(u32) * 5,
-		GFP_KERNEL);
-	if (!save_state) {
-		printk(KERN_ERR "Out of memory in pci_save_msi_state\n");
-		return -ENOMEM;
-	}
-	cap = &save_state->data[0];
-
-	pci_read_config_dword(dev, pos, &cap[i++]);
-	control = cap[0] >> 16;
-	pci_read_config_dword(dev, pos + PCI_MSI_ADDRESS_LO, &cap[i++]);
-	if (control & PCI_MSI_FLAGS_64BIT) {
-		pci_read_config_dword(dev, pos + PCI_MSI_ADDRESS_HI, &cap[i++]);
-		pci_read_config_dword(dev, pos + PCI_MSI_DATA_64, &cap[i++]);
-	} else
-		pci_read_config_dword(dev, pos + PCI_MSI_DATA_32, &cap[i++]);
-	if (control & PCI_MSI_FLAGS_MASKBIT)
-		pci_read_config_dword(dev, pos + PCI_MSI_MASK_BIT, &cap[i++]);
-	save_state->cap_nr = PCI_CAP_ID_MSI;
-	pci_add_saved_cap(dev, save_state);
-	return 0;
-}
-
 static void __pci_restore_msi_state(struct pci_dev *dev)
 {
-	int i = 0, pos;
+	int pos;
 	u16 control;
-	struct pci_cap_saved_state *save_state;
-	u32 *cap;
+	struct msi_desc *entry;
 
 	if (!dev->msi_enabled)
 		return;
 
-	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_MSI);
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
-	if (!save_state || pos <= 0)
-		return;
-	cap = &save_state->data[0];
+	entry = get_irq_msi(dev->irq);
+	pos = entry->msi_attrib.pos;
 
 	pci_intx(dev, 0);		/* disable intx */
-	control = cap[i++] >> 16;
 	msi_set_enable(dev, 0);
-	pci_write_config_dword(dev, pos + PCI_MSI_ADDRESS_LO, cap[i++]);
-	if (control & PCI_MSI_FLAGS_64BIT) {
-		pci_write_config_dword(dev, pos + PCI_MSI_ADDRESS_HI, cap[i++]);
-		pci_write_config_dword(dev, pos + PCI_MSI_DATA_64, cap[i++]);
-	} else
-		pci_write_config_dword(dev, pos + PCI_MSI_DATA_32, cap[i++]);
-	if (control & PCI_MSI_FLAGS_MASKBIT)
-		pci_write_config_dword(dev, pos + PCI_MSI_MASK_BIT, cap[i++]);
+	write_msi_msg(dev->irq, &entry->msg);
+	if (entry->msi_attrib.maskbit)
+		msi_set_mask_bit(dev->irq, entry->msi_attrib.masked);
+
+	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
+	control &= ~(PCI_MSI_FLAGS_QSIZE | PCI_MSI_FLAGS_ENABLE);
+	if (entry->msi_attrib.maskbit || !entry->msi_attrib.masked)
+		control |= PCI_MSI_FLAGS_ENABLE;
 	pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
-	pci_remove_saved_cap(save_state);
-	kfree(save_state);
-}
-
-static int __pci_save_msix_state(struct pci_dev *dev)
-{
-	int pos;
-	int irq, head, tail = 0;
-	u16 control;
-	struct pci_cap_saved_state *save_state;
-
-	if (!dev->msix_enabled)
-		return 0;
-
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (pos <= 0)
-		return 0;
-
-	/* save the capability */
-	pci_read_config_word(dev, msi_control_reg(pos), &control);
-	save_state = kzalloc(sizeof(struct pci_cap_saved_state) + sizeof(u16),
-		GFP_KERNEL);
-	if (!save_state) {
-		printk(KERN_ERR "Out of memory in pci_save_msix_state\n");
-		return -ENOMEM;
-	}
-	*((u16 *)&save_state->data[0]) = control;
-
-	/* save the table */
-	irq = head = dev->first_msi_irq;
-	while (head != tail) {
-		struct msi_desc *entry;
-
-		entry = get_irq_msi(irq);
-		read_msi_msg(irq, &entry->msg_save);
-
-		tail = entry->link.tail;
-		irq = tail;
-	}
-
-	save_state->cap_nr = PCI_CAP_ID_MSIX;
-	pci_add_saved_cap(dev, save_state);
-	return 0;
-}
-
-int pci_save_msi_state(struct pci_dev *dev)
-{
-	int rc;
-
-	rc = __pci_save_msi_state(dev);
-	if (rc)
-		return rc;
-
-	rc = __pci_save_msix_state(dev);
-
-	return rc;
 }
 
 static void __pci_restore_msix_state(struct pci_dev *dev)
 {
-	u16 save;
 	int pos;
 	int irq, head, tail = 0;
 	struct msi_desc *entry;
-	struct pci_cap_saved_state *save_state;
+	u16 control;
 
 	if (!dev->msix_enabled)
 		return;
 
-	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_MSIX);
-	if (!save_state)
-		return;
-	save = *((u16 *)&save_state->data[0]);
-	pci_remove_saved_cap(save_state);
-	kfree(save_state);
-
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (pos <= 0)
-		return;
-
 	/* route the table */
 	pci_intx(dev, 0);		/* disable intx */
 	msix_set_enable(dev, 0);
 	irq = head = dev->first_msi_irq;
+	entry = get_irq_msi(irq);
+	pos = entry->msi_attrib.pos;
 	while (head != tail) {
 		entry = get_irq_msi(irq);
-		write_msi_msg(irq, &entry->msg_save);
+		write_msi_msg(irq, &entry->msg);
+		msi_set_mask_bit(irq, entry->msi_attrib.masked);
 
 		tail = entry->link.tail;
 		irq = tail;
 	}
 
-	pci_write_config_word(dev, msi_control_reg(pos), save);
+	pci_read_config_word(dev, pos + PCI_MSIX_FLAGS, &control);
+	control &= ~PCI_MSIX_FLAGS_MASKALL;
+	control |= PCI_MSIX_FLAGS_ENABLE;
+	pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
 }
 
 void pci_restore_msi_state(struct pci_dev *dev)
@@ -420,6 +318,7 @@ static int msi_capability_init(struct pc
 	entry->msi_attrib.is_64 = is_64bit_address(control);
 	entry->msi_attrib.entry_nr = 0;
 	entry->msi_attrib.maskbit = is_mask_bit_support(control);
+	entry->msi_attrib.masked = 1;
 	entry->msi_attrib.default_irq = dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.pos = pos;
 	if (is_mask_bit_support(control)) {
@@ -507,6 +406,7 @@ static int msix_capability_init(struct p
 		entry->msi_attrib.is_64 = 1;
 		entry->msi_attrib.entry_nr = j;
 		entry->msi_attrib.maskbit = 1;
+		entry->msi_attrib.masked = 1;
 		entry->msi_attrib.default_irq = dev->irq;
 		entry->msi_attrib.pos = pos;
 		entry->dev = dev;
diff -puN drivers/pci/pci.c~msi-safer-state-caching drivers/pci/pci.c
--- a/drivers/pci/pci.c~msi-safer-state-caching
+++ a/drivers/pci/pci.c
@@ -637,8 +637,6 @@ pci_save_state(struct pci_dev *dev)
 	/* XXX: 100% dword access ok here? */
 	for (i = 0; i < 16; i++)
 		pci_read_config_dword(dev, i * 4,&dev->saved_config_space[i]);
-	if ((i = pci_save_msi_state(dev)) != 0)
-		return i;
 	if ((i = pci_save_pcie_state(dev)) != 0)
 		return i;
 	if ((i = pci_save_pcix_state(dev)) != 0)
diff -puN drivers/pci/pci.h~msi-safer-state-caching drivers/pci/pci.h
--- a/drivers/pci/pci.h~msi-safer-state-caching
+++ a/drivers/pci/pci.h
@@ -52,10 +52,8 @@ static inline void pci_no_msi(void) { }
 #endif
 
 #if defined(CONFIG_PCI_MSI) && defined(CONFIG_PM)
-int pci_save_msi_state(struct pci_dev *dev);
 void pci_restore_msi_state(struct pci_dev *dev);
 #else
-static inline int pci_save_msi_state(struct pci_dev *dev) { return 0; }
 static inline void pci_restore_msi_state(struct pci_dev *dev) {}
 #endif
 
diff -puN include/linux/msi.h~msi-safer-state-caching include/linux/msi.h
--- a/include/linux/msi.h~msi-safer-state-caching
+++ a/include/linux/msi.h
@@ -17,7 +17,7 @@ struct msi_desc {
 	struct {
 		__u8	type	: 5; 	/* {0: unused, 5h:MSI, 11h:MSI-X} */
 		__u8	maskbit	: 1; 	/* mask-pending bit supported ?   */
-		__u8	unused	: 1;
+		__u8	masked	: 1;
 		__u8	is_64	: 1;	/* Address size: 0=32bit 1=64bit  */
 		__u8	pos;	 	/* Location of the msi capability */
 		__u16	entry_nr;    	/* specific enabled entry 	  */
@@ -32,10 +32,8 @@ struct msi_desc {
 	void __iomem *mask_base;
 	struct pci_dev *dev;
 
-#ifdef CONFIG_PM
-	/* PM save area for MSIX address/data */
-	struct msi_msg msg_save;
-#endif
+	/* Last set MSI message */
+	struct msi_msg msg;
 };
 
 /*
diff -puN include/linux/pci_regs.h~msi-safer-state-caching include/linux/pci_regs.h
--- a/include/linux/pci_regs.h~msi-safer-state-caching
+++ a/include/linux/pci_regs.h
@@ -296,6 +296,7 @@
 #define PCI_MSIX_FLAGS		2
 #define  PCI_MSIX_FLAGS_QSIZE	0x7FF
 #define  PCI_MSIX_FLAGS_ENABLE	(1 << 15)
+#define  PCI_MSIX_FLAGS_MASKALL	(1 << 14)
 #define PCI_MSIX_FLAGS_BIRMASK	(7 << 0)
 #define PCI_MSIX_FLAGS_BITMASK	(1 << 0)
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
msi-safer-state-caching.patch
i386-irq-kill-irq-compression.patch
x86_64-irq-remove-extra-smp_processor_id-calling.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
edac-k8-driver-coding-tidy.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

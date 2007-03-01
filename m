From: akpm@linux-foundation.org
Subject: + msi-fixup-the-msi-enable-disable-logic.patch added to -mm tree
Date: Wed, 28 Feb 2007 22:38:50 -0800
Message-ID: <200703010638.l216coQ1006645@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57665 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbXCAGi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 01:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, benh@kernel.crashing.org, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org


The patch titled
     msi: fix up the msi enable/disable logic
has been added to the -mm tree.  Its filename is
     msi-fixup-the-msi-enable-disable-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: msi: fix up the msi enable/disable logic
From: Eric W. Biederman <ebiederm@xmission.com>

enable/disable_msi_mode have several side effects which keeps them from being
generally useful.  So this patch replaces them with with two much more
targeted functions: msi_set_enable and msix_set_enable.

This patch makes pci_dev->msi_enabled and pci_dev->msix_enabled the definitive
way to test if linux has enabled the msi capability, and has the appropriate
msi data structures set up.

This patch ensures that while writing the msi messages in save/restore and
during device initialization we have the msi capability disabled so we don't
get into races.  The pci spec requires that we do not have the msi capability
enabled and the msi messages unmasked while we write the messages.  Completely
disabling the capability is overkill but it is easy :)

Care has been taken so we never have both a msi capability and intx enabled
simultaneously.  We haven't run into a problem yet but better safe then sorry.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |  144 +++++++++++++++++++-------------------------
 1 file changed, 64 insertions(+), 80 deletions(-)

diff -puN drivers/pci/msi.c~msi-fixup-the-msi-enable-disable-logic drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-fixup-the-msi-enable-disable-logic
+++ a/drivers/pci/msi.c
@@ -38,6 +38,36 @@ static int msi_cache_init(void)
 	return 0;
 }
 
+static void msi_set_enable(struct pci_dev *dev, int enable)
+{
+	int pos;
+	u16 control;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	if (pos) {
+		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
+		control &= ~PCI_MSI_FLAGS_ENABLE;
+		if (enable)
+			control |= PCI_MSI_FLAGS_ENABLE;
+		pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
+	}
+}
+
+static void msix_set_enable(struct pci_dev *dev, int enable)
+{
+	int pos;
+	u16 control;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
+	if (pos) {
+		pci_read_config_word(dev, pos + PCI_MSIX_FLAGS, &control);
+		control &= ~PCI_MSIX_FLAGS_ENABLE;
+		if (enable)
+			control |= PCI_MSIX_FLAGS_ENABLE;
+		pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
+	}
+}
+
 static void msi_set_mask_bit(unsigned int irq, int flag)
 {
 	struct msi_desc *entry;
@@ -192,44 +222,6 @@ static struct msi_desc* alloc_msi_entry(
 	return entry;
 }
 
-static void enable_msi_mode(struct pci_dev *dev, int pos, int type)
-{
-	u16 control;
-
-	pci_read_config_word(dev, msi_control_reg(pos), &control);
-	if (type == PCI_CAP_ID_MSI) {
-		/* Set enabled bits to single MSI & enable MSI_enable bit */
-		msi_enable(control, 1);
-		pci_write_config_word(dev, msi_control_reg(pos), control);
-		dev->msi_enabled = 1;
-	} else {
-		msix_enable(control);
-		pci_write_config_word(dev, msi_control_reg(pos), control);
-		dev->msix_enabled = 1;
-	}
-
-	pci_intx(dev, 0);  /* disable intx */
-}
-
-static void disable_msi_mode(struct pci_dev *dev, int pos, int type)
-{
-	u16 control;
-
-	pci_read_config_word(dev, msi_control_reg(pos), &control);
-	if (type == PCI_CAP_ID_MSI) {
-		/* Set enabled bits to single MSI & enable MSI_enable bit */
-		msi_disable(control);
-		pci_write_config_word(dev, msi_control_reg(pos), control);
-		dev->msi_enabled = 0;
-	} else {
-		msix_disable(control);
-		pci_write_config_word(dev, msi_control_reg(pos), control);
-		dev->msix_enabled = 0;
-	}
-
-	pci_intx(dev, 1);  /* enable intx */
-}
-
 #ifdef CONFIG_PM
 static int __pci_save_msi_state(struct pci_dev *dev)
 {
@@ -238,12 +230,11 @@ static int __pci_save_msi_state(struct p
 	struct pci_cap_saved_state *save_state;
 	u32 *cap;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
-	if (pos <= 0 || dev->no_msi)
+	if (!dev->msi_enabled)
 		return 0;
 
-	pci_read_config_word(dev, msi_control_reg(pos), &control);
-	if (!(control & PCI_MSI_FLAGS_ENABLE))
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	if (pos <= 0)
 		return 0;
 
 	save_state = kzalloc(sizeof(struct pci_cap_saved_state) + sizeof(u32) * 5,
@@ -276,13 +267,18 @@ static void __pci_restore_msi_state(stru
 	struct pci_cap_saved_state *save_state;
 	u32 *cap;
 
+	if (!dev->msi_enabled)
+		return;
+
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_MSI);
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
 	if (!save_state || pos <= 0)
 		return;
 	cap = &save_state->data[0];
 
+	pci_intx(dev, 0);		/* disable intx */
 	control = cap[i++] >> 16;
+	msi_set_enable(dev, 0);
 	pci_write_config_dword(dev, pos + PCI_MSI_ADDRESS_LO, cap[i++]);
 	if (control & PCI_MSI_FLAGS_64BIT) {
 		pci_write_config_dword(dev, pos + PCI_MSI_ADDRESS_HI, cap[i++]);
@@ -292,7 +288,6 @@ static void __pci_restore_msi_state(stru
 	if (control & PCI_MSI_FLAGS_MASKBIT)
 		pci_write_config_dword(dev, pos + PCI_MSI_MASK_BIT, cap[i++]);
 	pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
-	enable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
 	pci_remove_saved_cap(save_state);
 	kfree(save_state);
 }
@@ -308,13 +303,11 @@ static int __pci_save_msix_state(struct 
 		return 0;
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (pos <= 0 || dev->no_msi)
+	if (pos <= 0)
 		return 0;
 
 	/* save the capability */
 	pci_read_config_word(dev, msi_control_reg(pos), &control);
-	if (!(control & PCI_MSIX_FLAGS_ENABLE))
-		return 0;
 	save_state = kzalloc(sizeof(struct pci_cap_saved_state) + sizeof(u16),
 		GFP_KERNEL);
 	if (!save_state) {
@@ -376,6 +369,8 @@ static void __pci_restore_msix_state(str
 		return;
 
 	/* route the table */
+	pci_intx(dev, 0);		/* disable intx */
+	msix_set_enable(dev, 0);
 	irq = head = dev->first_msi_irq;
 	while (head != tail) {
 		entry = get_irq_msi(irq);
@@ -386,7 +381,6 @@ static void __pci_restore_msix_state(str
 	}
 
 	pci_write_config_word(dev, msi_control_reg(pos), save);
-	enable_msi_mode(dev, pos, PCI_CAP_ID_MSIX);
 }
 
 void pci_restore_msi_state(struct pci_dev *dev)
@@ -411,6 +405,8 @@ static int msi_capability_init(struct pc
 	int pos, irq;
 	u16 control;
 
+	msi_set_enable(dev, 0);	/* Ensure msi is disabled as I set it up */
+
    	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
 	pci_read_config_word(dev, msi_control_reg(pos), &control);
 	/* MSI Entry Initialization */
@@ -454,7 +450,9 @@ static int msi_capability_init(struct pc
 	set_irq_msi(irq, entry);
 
 	/* Set MSI enabled bits	 */
-	enable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
+	pci_intx(dev, 0);		/* disable intx */
+	msi_set_enable(dev, 1);
+	dev->msi_enabled = 1;
 
 	dev->irq = irq;
 	return 0;
@@ -481,6 +479,8 @@ static int msix_capability_init(struct p
 	u8 bir;
 	void __iomem *base;
 
+	msix_set_enable(dev, 0);/* Ensure msix is disabled as I set it up */
+
    	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
 	/* Request & Map MSI-X table region */
  	pci_read_config_word(dev, msi_control_reg(pos), &control);
@@ -549,7 +549,9 @@ static int msix_capability_init(struct p
 	}
 	dev->first_msi_irq = entries[0].vector;
 	/* Set MSI-X enabled bits */
-	enable_msi_mode(dev, pos, PCI_CAP_ID_MSIX);
+	pci_intx(dev, 0);		/* disable intx */
+	msix_set_enable(dev, 1);
+	dev->msix_enabled = 1;
 
 	return 0;
 }
@@ -611,12 +613,11 @@ int pci_enable_msi(struct pci_dev* dev)
 	WARN_ON(!!dev->msi_enabled);
 
 	/* Check whether driver already requested for MSI-X irqs */
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (pos > 0 && dev->msix_enabled) {
-			printk(KERN_INFO "PCI: %s: Can't enable MSI.  "
-			       "Device already has MSI-X enabled\n",
-			       pci_name(dev));
-			return -EINVAL;
+	if (dev->msix_enabled) {
+		printk(KERN_INFO "PCI: %s: Can't enable MSI.  "
+			"Device already has MSI-X enabled\n",
+			pci_name(dev));
+		return -EINVAL;
 	}
 	status = msi_capability_init(dev);
 	return status;
@@ -625,8 +626,7 @@ int pci_enable_msi(struct pci_dev* dev)
 void pci_disable_msi(struct pci_dev* dev)
 {
 	struct msi_desc *entry;
-	int pos, default_irq;
-	u16 control;
+	int default_irq;
 
 	if (!pci_msi_enable)
 		return;
@@ -636,16 +636,9 @@ void pci_disable_msi(struct pci_dev* dev
 	if (!dev->msi_enabled)
 		return;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
-	if (!pos)
-		return;
-
-	pci_read_config_word(dev, msi_control_reg(pos), &control);
-	if (!(control & PCI_MSI_FLAGS_ENABLE))
-		return;
-
-
-	disable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
+	msi_set_enable(dev, 0);
+	pci_intx(dev, 1);		/* enable intx */
+	dev->msi_enabled = 0;
 
 	entry = get_irq_msi(dev->first_msi_irq);
 	if (!entry || !entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI) {
@@ -746,8 +739,7 @@ int pci_enable_msix(struct pci_dev* dev,
 	WARN_ON(!!dev->msix_enabled);
 
 	/* Check whether driver already requested for MSI irq */
-   	if (pci_find_capability(dev, PCI_CAP_ID_MSI) > 0 &&
-		dev->msi_enabled) {
+   	if (dev->msi_enabled) {
 		printk(KERN_INFO "PCI: %s: Can't enable MSI-X.  "
 		       "Device already has an MSI irq assigned\n",
 		       pci_name(dev));
@@ -760,8 +752,6 @@ int pci_enable_msix(struct pci_dev* dev,
 void pci_disable_msix(struct pci_dev* dev)
 {
 	int irq, head, tail = 0, warning = 0;
-	int pos;
-	u16 control;
 
 	if (!pci_msi_enable)
 		return;
@@ -771,15 +761,9 @@ void pci_disable_msix(struct pci_dev* de
 	if (!dev->msix_enabled)
 		return;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (!pos)
-		return;
-
-	pci_read_config_word(dev, msi_control_reg(pos), &control);
-	if (!(control & PCI_MSIX_FLAGS_ENABLE))
-		return;
-
-	disable_msi_mode(dev, pos, PCI_CAP_ID_MSIX);
+	msix_set_enable(dev, 0);
+	pci_intx(dev, 1);		/* enable intx */
+	dev->msix_enabled = 0;
 
 	irq = head = dev->first_msi_irq;
 	while (head != tail) {
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

From: akpm@linux-foundation.org
Subject: - msi-debug-code.patch removed from -mm tree
Date: Sat, 10 Mar 2007 15:49:32 -0800
Message-ID: <200703102349.l2ANnW8C000444@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59523 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXCJXtj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Mar 2007 18:49:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     MSI debug code
has been removed from the -mm tree.  Its filename was
     msi-debug-code.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: MSI debug code
From: "Eric W. Biederman" <ebiederm@xmission.com>

Below is an additional set of warnings that should help debug this.
The old code just got lucky that it triggered a warning when this happens.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |    6 ++++++
 drivers/pci/pci.c |    1 +
 2 files changed, 7 insertions(+)

diff -puN drivers/pci/msi.c~msi-debug-code drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-debug-code
+++ a/drivers/pci/msi.c
@@ -613,6 +613,7 @@ int pci_enable_msi(struct pci_dev* dev)
 		return -EINVAL;
 
 	WARN_ON(!!dev->msi_enabled);
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
 
 	/* Check whether driver already requested for MSI-X irqs */
 	if (dev->msix_enabled) {
@@ -638,6 +639,8 @@ void pci_disable_msi(struct pci_dev* dev
 	if (!dev->msi_enabled)
 		return;
 
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
+
 	msi_set_enable(dev, 0);
 	pci_intx(dev, 1);		/* enable intx */
 	dev->msi_enabled = 0;
@@ -739,6 +742,7 @@ int pci_enable_msix(struct pci_dev* dev,
 		}
 	}
 	WARN_ON(!!dev->msix_enabled);
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
 
 	/* Check whether driver already requested for MSI irq */
    	if (dev->msi_enabled) {
@@ -763,6 +767,8 @@ void pci_disable_msix(struct pci_dev* de
 	if (!dev->msix_enabled)
 		return;
 
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
+
 	msix_set_enable(dev, 0);
 	pci_intx(dev, 1);		/* enable intx */
 	dev->msix_enabled = 0;
diff -puN drivers/pci/pci.c~msi-debug-code drivers/pci/pci.c
--- a/drivers/pci/pci.c~msi-debug-code
+++ a/drivers/pci/pci.c
@@ -676,6 +676,7 @@ pci_restore_state(struct pci_dev *dev)
 	}
 	pci_restore_pcix_state(dev);
 	pci_restore_msi_state(dev);
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
 
 	return 0;
 }
_

Patches currently in -mm which might be from ebiederm@xmission.com are

powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
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
msi-debug-code.patch

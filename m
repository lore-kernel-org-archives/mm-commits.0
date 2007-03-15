From: akpm@linux-foundation.org
Subject: - pci-repair-pci_save-restore_state-so-we-can-restore-one-save-many-times.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:59:31 -0800
Message-ID: <200703152159.l2FLxVsM027827@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbXCOV7e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:59:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, auke-jan.h.kok@intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci: repair pci_save/restore_state so we can restore one save many times
has been removed from the -mm tree.  Its filename was
     pci-repair-pci_save-restore_state-so-we-can-restore-one-save-many-times.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci: repair pci_save/restore_state so we can restore one save many times
From: ebiederm@xmission.com (Eric W. Biederman)

Because we do not reserve space for the pci-x and pci-e state in struct pci
dev we need to dynamically allocate it.  However because we need to support
restore being called multiple times after a single save it is never safe to
free the buffers we have allocated to hold the state.

So this patch modifies the save routines to first check to see if we have
already allocated a state buffer before allocating a new one.  Then the
restore routines are modified to not free the state after restoring it. 
Simple and it fixes some subtle error path handling bugs, that are hard to
test for.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c   |   12 ++++++------
 include/linux/pci.h |    5 -----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff -puN drivers/pci/pci.c~pci-repair-pci_save-restore_state-so-we-can-restore-one-save-many-times drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-repair-pci_save-restore_state-so-we-can-restore-one-save-many-times
+++ a/drivers/pci/pci.c
@@ -550,7 +550,9 @@ static int pci_save_pcie_state(struct pc
 	if (pos <= 0)
 		return 0;
 
-	save_state = kzalloc(sizeof(*save_state) + sizeof(u16) * 4, GFP_KERNEL);
+	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
+	if (!save_state)
+		save_state = kzalloc(sizeof(*save_state) + sizeof(u16) * 4, GFP_KERNEL);
 	if (!save_state) {
 		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
 		return -ENOMEM;
@@ -581,8 +583,6 @@ static void pci_restore_pcie_state(struc
 	pci_write_config_word(dev, pos + PCI_EXP_LNKCTL, cap[i++]);
 	pci_write_config_word(dev, pos + PCI_EXP_SLTCTL, cap[i++]);
 	pci_write_config_word(dev, pos + PCI_EXP_RTCTL, cap[i++]);
-	pci_remove_saved_cap(save_state);
-	kfree(save_state);
 }
 
 
@@ -596,7 +596,9 @@ static int pci_save_pcix_state(struct pc
 	if (pos <= 0)
 		return 0;
 
-	save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
+	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
+	if (!save_state)
+		save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
 	if (!save_state) {
 		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
 		return -ENOMEM;
@@ -621,8 +623,6 @@ static void pci_restore_pcix_state(struc
 	cap = (u16 *)&save_state->data[0];
 
 	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
-	pci_remove_saved_cap(save_state);
-	kfree(save_state);
 }
 
 
diff -puN include/linux/pci.h~pci-repair-pci_save-restore_state-so-we-can-restore-one-save-many-times include/linux/pci.h
--- a/include/linux/pci.h~pci-repair-pci_save-restore_state-so-we-can-restore-one-save-many-times
+++ a/include/linux/pci.h
@@ -227,11 +227,6 @@ static inline void pci_add_saved_cap(str
 	hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
 }
 
-static inline void pci_remove_saved_cap(struct pci_cap_saved_state *cap)
-{
-	hlist_del(&cap->next);
-}
-
 /*
  *  For PCI devices, the region numbers are assigned this way:
  *
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
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
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
remove-the-likelypid-check-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

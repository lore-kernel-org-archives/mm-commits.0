From: akpm@linux-foundation.org
Subject: - msi-x-fix-resume-crash.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:41 -0700
Message-ID: <200703290742.l2T7gfjZ030319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46155 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbXC2Hms (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     MSI: fix resume crash
has been removed from the -mm tree.  Its filename was
     msi-x-fix-resume-crash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MSI: fix resume crash
From: Eric W. Biederman <ebiederm@xmission.com>

So I think the right solution is to simply make pci_enable_device just flip
enable bits and move the rest of the work someplace else.

However a thorough cleanup is a little extreme for this point in the
release cycle, so I think a quick hack that makes the code not stomp the
irq when msi irq's are enabled should be the first fix.  Then we can later
make the code not change the irqs at all.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/pci/bios.c |    4 +++-
 arch/frv/mb93090-mb00/pci-vdk.c       |    3 ++-
 arch/i386/pci/common.c                |    6 ++++--
 arch/ia64/pci/pci.c                   |    8 ++++++--
 4 files changed, 15 insertions(+), 6 deletions(-)

diff -puN arch/cris/arch-v32/drivers/pci/bios.c~msi-x-fix-resume-crash arch/cris/arch-v32/drivers/pci/bios.c
--- a/arch/cris/arch-v32/drivers/pci/bios.c~msi-x-fix-resume-crash
+++ a/arch/cris/arch-v32/drivers/pci/bios.c
@@ -100,7 +100,9 @@ int pcibios_enable_device(struct pci_dev
 	if ((err = pcibios_enable_resources(dev, mask)) < 0)
 		return err;
 
-	return pcibios_enable_irq(dev);
+	if (!dev->msi_enabled)
+		pcibios_enable_irq(dev);
+	return 0;
 }
 
 int pcibios_assign_resources(void)
diff -puN arch/frv/mb93090-mb00/pci-vdk.c~msi-x-fix-resume-crash arch/frv/mb93090-mb00/pci-vdk.c
--- a/arch/frv/mb93090-mb00/pci-vdk.c~msi-x-fix-resume-crash
+++ a/arch/frv/mb93090-mb00/pci-vdk.c
@@ -466,6 +466,7 @@ int pcibios_enable_device(struct pci_dev
 
 	if ((err = pcibios_enable_resources(dev, mask)) < 0)
 		return err;
-	pcibios_enable_irq(dev);
+	if (!dev->msi_enabled)
+		pcibios_enable_irq(dev);
 	return 0;
 }
diff -puN arch/i386/pci/common.c~msi-x-fix-resume-crash arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~msi-x-fix-resume-crash
+++ a/arch/i386/pci/common.c
@@ -449,11 +449,13 @@ int pcibios_enable_device(struct pci_dev
 	if ((err = pcibios_enable_resources(dev, mask)) < 0)
 		return err;
 
-	return pcibios_enable_irq(dev);
+	if (!dev->msi_enabled)
+		return pcibios_enable_irq(dev);
+	return 0;
 }
 
 void pcibios_disable_device (struct pci_dev *dev)
 {
-	if (pcibios_disable_irq)
+	if (!dev->msi_enabled && pcibios_disable_irq)
 		pcibios_disable_irq(dev);
 }
diff -puN arch/ia64/pci/pci.c~msi-x-fix-resume-crash arch/ia64/pci/pci.c
--- a/arch/ia64/pci/pci.c~msi-x-fix-resume-crash
+++ a/arch/ia64/pci/pci.c
@@ -557,14 +557,18 @@ pcibios_enable_device (struct pci_dev *d
 	if (ret < 0)
 		return ret;
 
-	return acpi_pci_irq_enable(dev);
+	if (!dev->msi_enabled)
+		return acpi_pci_irq_enable(dev);
+	return 0;
 }
 
 void
 pcibios_disable_device (struct pci_dev *dev)
 {
 	BUG_ON(atomic_read(&dev->enable_cnt));
-	acpi_pci_irq_disable(dev);
+	if (!dev->msi_enabled)
+		acpi_pci_irq_disable(dev);
+	return 0;
 }
 
 void
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
i386-irq-kill-irq-compression.patch
i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs.patch
x86_64-irq-remove-extra-smp_processor_id-calling.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
i386-account-for-module-percpu-space-separately-from-kernel.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

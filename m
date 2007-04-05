From: akpm@linux-foundation.org
Subject: - msi-immediately-mask-and-unmask-msi-x-irqs.patch removed from -mm tree
Date: Wed, 04 Apr 2007 18:59:48 -0700
Message-ID: <200704050159.l351xmpQ004732@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXDEB7y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 21:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, greg@kroah.com, mitch.a.williams@intel.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     msi: immediately mask and unmask msi-x irqs
has been removed from the -mm tree.  Its filename was
     msi-immediately-mask-and-unmask-msi-x-irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: msi: immediately mask and unmask msi-x irqs
From: "Eric W. Biederman" <ebiederm@xmission.com>

This is a simplified and actually more comprehensive form of a bug fix from
Mitch Williams <mitch.a.williams@intel.com>.

When we mask or unmask a msi-x irqs the writes may be posted because we are
writing to memory mapped region.  This means the mask and unmask don't
happen immediately but at some unspecified time in the future.  Which is
out of sync with how the mask/unmask logic work for ioapic irqs.

The practical result is that we get very subtle and hard to track down irq
migration bugs.

This patch performs a read flush after writes to the MSI-X table for mask
and unmask operations.  Since the SMP affinity is set while the interrupt
is masked, and since it's unmasked immediately after, no additional flushes
are required in the various affinity setting routines.

The testing by Mitch Williams on his especially problematic system should
still be valid as I have only simplified the code, not changed the
functionality.

We currently have 7 drivers: cciss, mthca, cxgb3, forceth, s2io,
pcie/portdrv_core, and qla2xxx in 2.6.21 that are affected by this problem
when the hardware they driver is plugged into the right slot.

Given the difficulty of reproducing this bug and tracing it down to
anything that even remotely resembles a cause, even if people are being
affected we aren't likely to see many meaningful bug reports, and the
people who see this bug aren't likely to be able to reproduce this bug in a
timely fashion.  So it is best to get this problem fixed as soon as we can
so people don't have problems.

Then if people do have a kernel message stating "No irq for vector" we will
know it is yet another novel cause that needs a complete new investigation.

Acked-by: Mitch Williams <mitch.a.williams@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/pci/msi.c~msi-immediately-mask-and-unmask-msi-x-irqs drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-immediately-mask-and-unmask-msi-x-irqs
+++ a/drivers/pci/msi.c
@@ -94,6 +94,7 @@ static void msi_set_mask_bit(unsigned in
 		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
 		writel(flag, entry->mask_base + offset);
+		readl(entry->mask_base + offset);
 		break;
 	}
 	default:
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-relocatable-kernel-support.patch
i386-irq-kill-irq-compression.patch
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
clean-up-elf-note-generation.patch
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

From: akpm@linux-foundation.org
Subject: - msi-support-masking-msi-irqs-without-a-mask-bit.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:54:31 -0800
Message-ID: <200703052354.l25NsVL3005100@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41867 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbXCEXym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:54:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, benh@kernel.crashing.org, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     msi: support masking msi irqs without a mask bit
has been removed from the -mm tree.  Its filename was
     msi-support-masking-msi-irqs-without-a-mask-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: msi: support masking msi irqs without a mask bit
From: Eric W. Biederman <ebiederm@xmission.com>

For devices that do not support msi-x we only support 1 interrupt.  Therefore
we can disable that one interrupt by disabling the msi capability itself.  If
we leave the intx interrupts disabled while we have the msi capability
disabled no interrupts should be delivered from that device.

Devices with just the minimal msi support (and thus hitting this code path)
include things like the intel e1000 nic, so it looks like is going to be a
fairly common case and thus important to get right.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/pci/msi.c~msi-support-masking-msi-irqs-without-a-mask-bit drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-support-masking-msi-irqs-without-a-mask-bit
+++ a/drivers/pci/msi.c
@@ -85,6 +85,8 @@ static void msi_set_mask_bit(unsigned in
 			mask_bits &= ~(1);
 			mask_bits |= flag;
 			pci_write_config_dword(entry->dev, pos, mask_bits);
+		} else {
+			msi_set_enable(entry->dev, !flag);
 		}
 		break;
 	case PCI_CAP_ID_MSIX:
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
i386-irq-kill-irq-compression.patch
i386-irq-kill-irq-compression-fix.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

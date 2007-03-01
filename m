From: akpm@linux-foundation.org
Subject: + msi-support-masking-msi-irqs-without-a-mask-bit.patch added to -mm tree
Date: Wed, 28 Feb 2007 22:38:52 -0800
Message-ID: <200703010638.l216cqHT006648@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57669 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbXCAGjE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 01:39:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, benh@kernel.crashing.org, greg@kroah.com, michael@ellerman.id.au, paulus@samba.org


The patch titled
     msi: support masking msi irqs without a mask bit
has been added to the -mm tree.  Its filename is
     msi-support-masking-msi-irqs-without-a-mask-bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

From: akpm@osdl.org
Subject: - kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:25 -0800
Message-ID: <200701260751.l0Q7pPoZ010724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50485 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030813AbXAZHvp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: fix race between mmio reads and injected interrupts
has been removed from the -mm tree.  Its filename was
     kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: fix race between mmio reads and injected interrupts
From: Avi Kivity <avi@qumranet.com>

The kvm mmio read path looks like:

 1. guest read faults
 2. kvm emulates read, calls emulator_read_emulated()
 3. fails as a read requires userspace help
 4. exit to userspace
 5. userspace emulates read, kvm sets vcpu->mmio_read_completed
 6. re-enter guest, fault again
 7. kvm emulates read, calls emulator_read_emulated()
 8. succeeds as vcpu->mmio_read_emulated is set
 9. instruction completes and guest is resumed

A problem surfaces if the userspace exit (step 5) also requests an interrupt
injection.  In that case, the guest does not re-execute the original
instruction, but the interrupt handler.  The next time an mmio read is
exectued (likely for a different address), step 3 will find
vcpu->mmio_read_completed set and return the value read for the original
instruction.

The problem manifested itself in a few annoying ways:
- little squares appear randomly on console when switching virtual terminals
- ne2000 fails under nfs read load
- rtl8139 complains about "pci errors" even though the device model is
  incapable of issuing them.

Fix by skipping interrupt injection if an mmio read is pending.

A better fix is to avoid re-entry into the guest, and re-emulating immediately
instead.  However that's a bit more complex.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    3 ++-
 drivers/kvm/vmx.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/svm.c~kvm-fix-race-between-mmio-reads-and-injected-interrupts drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-fix-race-between-mmio-reads-and-injected-interrupts
+++ a/drivers/kvm/svm.c
@@ -1407,7 +1407,8 @@ static int svm_vcpu_run(struct kvm_vcpu 
 	int r;
 
 again:
-	do_interrupt_requests(vcpu, kvm_run);
+	if (!vcpu->mmio_read_completed)
+		do_interrupt_requests(vcpu, kvm_run);
 
 	clgi();
 
diff -puN drivers/kvm/vmx.c~kvm-fix-race-between-mmio-reads-and-injected-interrupts drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-fix-race-between-mmio-reads-and-injected-interrupts
+++ a/drivers/kvm/vmx.c
@@ -1717,7 +1717,8 @@ again:
 	vmcs_writel(HOST_GS_BASE, segment_base(gs_sel));
 #endif
 
-	do_interrupt_requests(vcpu, kvm_run);
+	if (!vcpu->mmio_read_completed)
+		do_interrupt_requests(vcpu, kvm_run);
 
 	if (vcpu->guest_debug.enabled)
 		kvm_guest_debug_pre(vcpu);
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-svm-fix-svm-idt-confusion.patch
kvm-emulate-ia32_misc_enable-msr.patch
kvm-mmu-perform-access-checks-in-walk_addr.patch
kvm-mmu-report-nx-faults-to-the-guest.patch
kvm-svm-propagate-cpu-shutdown-events-to-userspace.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch

From: akpm@osdl.org
Subject: + kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:07:43 -0800
Message-ID: <200701112107.l0BL7h6O003058@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXAKVIP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:08:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: fix race between mmio reads and injected interrupts
has been added to the -mm tree.  Its filename is
     kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-add-vm-exit-profiling.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-asm-constraints-with-config_frame_pointer=n.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch

From: akpm@osdl.org
Subject: + kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:07:41 -0800
Message-ID: <200701112107.l0BL7ft4003054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34968 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbXAKVI0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:08:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: make sure there is a vcpu context loaded when destroying the mmu
has been added to the -mm tree.  Its filename is
     kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: make sure there is a vcpu context loaded when destroying the mmu
From: Avi Kivity <avi@qumranet.com>

This makes the vmwrite errors on vm shutdown go away.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-make-sure-there-is-a-vcpu-context-loaded-when drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-sure-there-is-a-vcpu-context-loaded-when
+++ a/drivers/kvm/kvm_main.c
@@ -272,7 +272,9 @@ static void kvm_free_physmem(struct kvm 
 
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
+	vcpu_load(vcpu->kvm, vcpu_slot(vcpu));
 	kvm_mmu_destroy(vcpu);
+	vcpu_put(vcpu);
 	kvm_arch_ops->vcpu_free(vcpu);
 }
 
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-add-vm-exit-profiling.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-asm-constraints-with-config_frame_pointer=n.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch

From: akpm@osdl.org
Subject: - kvm-virtualization-infrastructure-fix-mmu-reset-locking-when-setting-cr0.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:19 -0800
Message-ID: <200612100752.kBA7qJn3017640@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59521 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760381AbWLJHwV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yaniv@qumranet.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Fix mmu reset locking when setting cr0
has been removed from the -mm tree.  Its filename was
     kvm-virtualization-infrastructure-fix-mmu-reset-locking-when-setting-cr0.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Fix mmu reset locking when setting cr0
From: Yaniv Kamay <yaniv@qumranet.com>

An mmu reset needs to be called with the kvm lock held.

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-virtualization-infrastructure-fix-mmu-reset-locking-when-setting-cr0 drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-virtualization-infrastructure-fix-mmu-reset-locking-when-setting-cr0
+++ a/drivers/kvm/kvm_main.c
@@ -939,7 +939,9 @@ static void set_cr0(struct kvm_vcpu *vcp
 	}
 
 	__set_cr0(vcpu, cr0);
+	spin_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
+	spin_unlock(&vcpu->kvm->lock);
 	return;
 }
 
_

Patches currently in -mm which might be from yaniv@qumranet.com are

kvm-userspace-interface.patch
kvm-virtualization-infrastructure-fix-mmu-reset-locking-when-setting-cr0.patch
kvm-memory-slot-management.patch
kvm-vcpu-creation-and-maintenance.patch
kvm-vcpu-execution-loop.patch
kvm-define-exit-handlers.patch
kvm-define-exit-handlers-pass-fs-gs-segment-bases-to-x86-emulator.patch
kvm-less-common-exit-handlers.patch
kvm-less-common-exit-handlers-handle-rdmsrmsr_efer.patch
kvm-mmu.patch
kvm-x86-emulator.patch
kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch


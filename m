From: akpm@osdl.org
Subject: - kvm-define-exit-handlers-pass-fs-gs-segment-bases-to-x86-emulator.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:45 -0800
Message-ID: <200612100752.kBA7qjNi017681@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59570 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760416AbWLJHwr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yaniv@qumranet.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Pass fs, gs segment bases to x86 emulator
has been removed from the -mm tree.  Its filename was
     kvm-define-exit-handlers-pass-fs-gs-segment-bases-to-x86-emulator.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Pass fs, gs segment bases to x86 emulator
From: Yaniv Kamay <yaniv@qumranet.com>

The x86-64 respects segment bases for fs and gs.

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-define-exit-handlers-pass-fs-gs-segment-bases-to-x86-emulator drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-define-exit-handlers-pass-fs-gs-segment-bases-to-x86-emulator
+++ a/drivers/kvm/kvm_main.c
@@ -1872,17 +1872,16 @@ static int emulate_instruction(struct kv
 		emulate_ctxt.ds_base = 0;
 		emulate_ctxt.es_base = 0;
 		emulate_ctxt.ss_base = 0;
-		emulate_ctxt.gs_base = 0;
-		emulate_ctxt.fs_base = 0;
 	} else {
 		emulate_ctxt.cs_base = vmcs_readl(GUEST_CS_BASE);
 		emulate_ctxt.ds_base = vmcs_readl(GUEST_DS_BASE);
 		emulate_ctxt.es_base = vmcs_readl(GUEST_ES_BASE);
 		emulate_ctxt.ss_base = vmcs_readl(GUEST_SS_BASE);
-		emulate_ctxt.gs_base = vmcs_readl(GUEST_GS_BASE);
-		emulate_ctxt.fs_base = vmcs_readl(GUEST_FS_BASE);
 	}
 
+	emulate_ctxt.gs_base = vmcs_readl(GUEST_GS_BASE);
+	emulate_ctxt.fs_base = vmcs_readl(GUEST_FS_BASE);
+
 	vcpu->mmio_is_write = 0;
 	r = x86_emulate_memop(&emulate_ctxt, &emulate_ops);
 
_

Patches currently in -mm which might be from yaniv@qumranet.com are

kvm-userspace-interface.patch
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


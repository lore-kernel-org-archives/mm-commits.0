From: akpm@linux-foundation.org
Subject: - kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:47 -0800
Message-ID: <200702122248.l1CMmlsd014052@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45582 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030377AbXBLWtA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kvm: Fix mmu going crazy of guest sets cr0.wp == 0
has been removed from the -mm tree.  Its filename was
     kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: Fix mmu going crazy of guest sets cr0.wp == 0
From: Avi Kivity <avi@qumranet.com>

The kvm mmu relies on cr0.wp being set even if the guest does not set it.  The
vmx code correctly forces cr0.wp at all times, the svm code does not, so it
can't boot solaris without this patch.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/svm.c~kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0 drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0
+++ a/drivers/kvm/svm.c
@@ -723,7 +723,7 @@ static void svm_set_cr0(struct kvm_vcpu 
 	}
 #endif
 	vcpu->svm->cr0 = cr0;
-	vcpu->svm->vmcb->save.cr0 = cr0 | CR0_PG_MASK;
+	vcpu->svm->vmcb->save.cr0 = cr0 | CR0_PG_MASK | CR0_WP_MASK;
 	vcpu->cr0 = cr0;
 }
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch

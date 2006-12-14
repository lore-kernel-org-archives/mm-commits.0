From: akpm@osdl.org
Subject: - kvm-remove-extranous-put_cpu-from-vcpu_put.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:02:15 -0800
Message-ID: <200612140602.kBE62F7n001743@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbWLNGC3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:02:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, huisinro@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Remove extranous put_cpu() from vcpu_put()
has been removed from the -mm tree.  Its filename was
     kvm-remove-extranous-put_cpu-from-vcpu_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Remove extranous put_cpu() from vcpu_put()
From: Avi Kivity <avi@qumranet.com>

The arch splitting patchset left an extra put_cpu() in core code, where it can
cause trouble for CONFIG_PREEMPT kernels.

Reported-by: Huihong Luo <huisinro@yahoo.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-remove-extranous-put_cpu-from-vcpu_put drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-remove-extranous-put_cpu-from-vcpu_put
+++ a/drivers/kvm/kvm_main.c
@@ -205,7 +205,6 @@ static struct kvm_vcpu *vcpu_load(struct
 static void vcpu_put(struct kvm_vcpu *vcpu)
 {
 	kvm_arch_ops->vcpu_put(vcpu);
-	put_cpu();
 	mutex_unlock(&vcpu->mutex);
 }
 
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-add-valid_vcpu-helper.patch
kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch
kvm-amd-svm-save-and-restore-the-floating-point-unit.patch


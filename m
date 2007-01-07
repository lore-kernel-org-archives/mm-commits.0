From: akpm@osdl.org
Subject: - kvm-initialize-vcpu-kvm-a-little-earlier.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:13 -0800
Message-ID: <200701070800.l0780D2T013168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41000 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484AbXAGIAR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Initialize vcpu->kvm a little earlier
has been removed from the -mm tree.  Its filename was
     kvm-initialize-vcpu-kvm-a-little-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Initialize vcpu->kvm a little earlier
From: Avi Kivity <avi@qumranet.com>

Fixes oops on early close of /dev/kvm.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-initialize-vcpu-kvm-a-little-earlier drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-initialize-vcpu-kvm-a-little-earlier
+++ a/drivers/kvm/kvm_main.c
@@ -230,6 +230,7 @@ static int kvm_dev_open(struct inode *in
 		struct kvm_vcpu *vcpu = &kvm->vcpus[i];
 
 		mutex_init(&vcpu->mutex);
+		vcpu->kvm = kvm;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
 		INIT_LIST_HEAD(&vcpu->free_pages);
 	}
@@ -530,7 +531,6 @@ static int kvm_dev_ioctl_create_vcpu(str
 	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
 
 	vcpu->cpu = -1;  /* First load will set up TR */
-	vcpu->kvm = kvm;
 	r = kvm_arch_ops->vcpu_create(vcpu);
 	if (r < 0)
 		goto out_free_vcpus;
_

Patches currently in -mm which might be from avi@qumranet.com are

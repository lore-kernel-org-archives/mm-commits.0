From: akpm@osdl.org
Subject: + kvm-remove-extranous-put_cpu-from-vcpu_put.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:20:30 -0800
Message-ID: <200612112020.kBBKKUSw006084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33123 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937645AbWLKUU4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:20:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, huisinro@yahoo.com


The patch titled
     KVM: Remove extranous put_cpu() from vcpu_put()
has been added to the -mm tree.  Its filename is
     kvm-remove-extranous-put_cpu-from-vcpu_put.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 deletion(-)

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

origin.patch
kvm-add-missing-include.patch
kvm-put-kvm-in-a-new-virtualization-menu.patch
kvm-clean-up-amd-svm-debug-registers-load-and-unload.patch
kvm-replace-__x86_64__-with-config_x86_64.patch
kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch
kvm-move-find_vmx_entry-to-vmxc.patch
kvm-remove-extranous-put_cpu-from-vcpu_put.patch
kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes.patch
kvm-add-maintainers-entry.patch


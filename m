From: akpm@osdl.org
Subject: + kvm-fix-oops-on-oom.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:15:59 -0800
Message-ID: <200612282315.kBSNFxIY015866@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbWL1XQC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:16:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Fix oops on oom
has been added to the -mm tree.  Its filename is
     kvm-fix-oops-on-oom.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Fix oops on oom
From: Avi Kivity <avi@qumranet.com>

__free_page() doesn't like a NULL argument, so check before calling it.  A
NULL can only happen if memory is exhausted during allocation of a memory
slot.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-fix-oops-on-oom drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-fix-oops-on-oom
+++ a/drivers/kvm/kvm_main.c
@@ -245,7 +245,8 @@ static void kvm_free_physmem_slot(struct
 	if (!dont || free->phys_mem != dont->phys_mem)
 		if (free->phys_mem) {
 			for (i = 0; i < free->npages; ++i)
-				__free_page(free->phys_mem[i]);
+				if (free->phys_mem[i])
+					__free_page(free->phys_mem[i]);
 			vfree(free->phys_mem);
 		}
 
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-use-boot_cpu_data-instead-of-current_cpu_data.patch
kvm-simplify-is_long_mode.patch
kvm-initialize-kvm_arch_ops-on-unload.patch
kvm-implement-a-few-system-configuration-msrs.patch
kvm-move-common-msr-handling-to-arch-independent-code.patch
kvm-more-msr-misery.patch
kvm-rename-some-msrs.patch
kvm-fix-oops-on-oom.patch
kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu.patch


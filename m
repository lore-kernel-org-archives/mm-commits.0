From: akpm@linux-foundation.org
Subject: [obsolete]
 i915-gvt-kvm-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch removed
 from -mm tree
Date: Thu, 16 Apr 2020 20:38:06 -0700
Message-ID: <20200417033806.-wEI4pKNh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgDQDiI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Apr 2020 23:38:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, hch@lst.de, jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com


The patch titled
     Subject: i915/gvt/kvm: a NULL ->mm does not mean a thread is a kthread
has been removed from the -mm tree.  Its filename was
     i915-gvt-kvm-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: i915/gvt/kvm: a NULL ->mm does not mean a thread is a kthread

Use the proper API instead.

Link: http://lkml.kernel.org/r/20200404094101.672954-3-hch@lst.de
Fixes: f440c8a572d7 ("drm/i915/gvt/kvmgt: read/write GPA via KVM API")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gvt/kvmgt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gvt/kvmgt.c~i915-gvt-kvm-a-null-mm-does-not-mean-a-thread-is-a-kthread
+++ a/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -2037,7 +2037,7 @@ static int kvmgt_rw_gpa(unsigned long ha
 	struct kvmgt_guest_info *info;
 	struct kvm *kvm;
 	int idx, ret;
-	bool kthread = current->mm == NULL;
+	bool kthread = (current->flags & PF_KTHREAD);
 
 	if (!handle_valid(handle))
 		return -ESRCH;
_

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
i915-gvt-remove-unused-xen-bits.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-set-user_ds-in-kthread_use_mm.patch

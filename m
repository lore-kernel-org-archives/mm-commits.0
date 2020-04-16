From: akpm@linux-foundation.org
Subject: +
 amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch added to -mm
 tree
Date: Wed, 15 Apr 2020 17:51:07 -0700
Message-ID: <20200416005107.WicT7RuPU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405058AbgDPAvK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 20:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, hch@lst.de, jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com


The patch titled
     Subject: amdgpu: a NULL ->mm does not mean a thread is a kthread
has been added to the -mm tree.  Its filename is
     amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: amdgpu: a NULL ->mm does not mean a thread is a kthread

Patch series "improve use_mm / unuse_mm".

This series improves the use_mm / unuse_mm interface by better documenting
the assumptions, and my taking the set_fs manipulations spread over the
callers into the core API.


This patch (of 6):

Use the proper API instead.

Link: http://lkml.kernel.org/r/20200404094101.672954-1-hch@lst.de
Link: http://lkml.kernel.org/r/20200404094101.672954-2-hch@lst.de
Fixes: 70539bd795002 ("drm/amd: Update MEC HQD loading code for KFD")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h~amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -190,7 +190,7 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_coun
 			pagefault_disable();				\
 			if ((mmptr) == current->mm) {			\
 				valid = !get_user((dst), (wptr));	\
-			} else if (current->mm == NULL) {		\
+			} else if (current->flags & PF_KTHREAD) {	\
 				use_mm(mmptr);				\
 				valid = !get_user((dst), (wptr));	\
 				unuse_mm(mmptr);			\
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
i915-gvt-kvm-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
i915-gvt-remove-unused-xen-bits.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-set-user_ds-in-kthread_use_mm.patch

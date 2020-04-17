From: akpm@linux-foundation.org
Subject: +
 kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch added to
 -mm tree
Date: Fri, 17 Apr 2020 16:07:05 -0700
Message-ID: <20200417230705.9rskNzXCy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDQXHH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 19:07:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, gregkh@linuxfoundation.org, hch@lst.de, jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com


The patch titled
     Subject: kernel-better-document-the-use_mm-unuse_mm-api-contract-v2
has been added to the -mm tree.  Its filename is
     kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch

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
Subject: kernel-better-document-the-use_mm-unuse_mm-api-contract-v2

fix a comment typo, cover the newly merged use_mm/unuse_mm caller in vfio

Link: http://lkml.kernel.org/r/20200416053158.586887-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/vfio_iommu_type1.c |    4 ++--
 kernel/kthread.c                |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c~kernel-better-document-the-use_mm-unuse_mm-api-contract-v2
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -2333,7 +2333,7 @@ static int vfio_iommu_type1_dma_rw_chunk
 		return -EPERM;
 
 	if (kthread)
-		use_mm(mm);
+		kthread_use_mm(mm);
 	else if (current->mm != mm)
 		goto out;
 
@@ -2351,7 +2351,7 @@ static int vfio_iommu_type1_dma_rw_chunk
 		*copied = __copy_from_user(data, (void __user *)vaddr,
 					   count) ? 0 : count;
 	if (kthread)
-		unuse_mm(mm);
+		kthread_unuse_mm(mm);
 out:
 	mmput(mm);
 	return *copied ? 0 : -EFAULT;
--- a/kernel/kthread.c~kernel-better-document-the-use_mm-unuse_mm-api-contract-v2
+++ a/kernel/kthread.c
@@ -1239,7 +1239,7 @@ void kthread_use_mm(struct mm_struct *mm
 EXPORT_SYMBOL_GPL(kthread_use_mm);
 
 /**
- * kthread_use_mm - reverse the effect of kthread_use_mm()
+ * kthread_unuse_mm - reverse the effect of kthread_use_mm()
  * @mm: address space to operate on
  */
 void kthread_unuse_mm(struct mm_struct *mm)
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
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch

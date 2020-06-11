From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch removed
 from -mm tree
Date: Wed, 10 Jun 2020 18:21:17 -0700
Message-ID: <20200611012117.4y3H_5sYb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKBVT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, gregkh@linuxfoundation.org, hch@lst.de, jasowang@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com


The patch titled
     Subject: kernel-better-document-the-use_mm-unuse_mm-api-contract-v2
has been removed from the -mm tree.  Its filename was
     kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch

This patch was dropped because it was folded into kernel-better-document-the-use_mm-unuse_mm-api-contract.patch

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
@@ -2817,7 +2817,7 @@ static int vfio_iommu_type1_dma_rw_chunk
 		return -EPERM;
 
 	if (kthread)
-		use_mm(mm);
+		kthread_use_mm(mm);
 	else if (current->mm != mm)
 		goto out;
 
@@ -2844,7 +2844,7 @@ static int vfio_iommu_type1_dma_rw_chunk
 		*copied = copy_from_user(data, (void __user *)vaddr,
 					   count) ? 0 : count;
 	if (kthread)
-		unuse_mm(mm);
+		kthread_unuse_mm(mm);
 out:
 	mmput(mm);
 	return *copied ? 0 : -EFAULT;
--- a/kernel/kthread.c~kernel-better-document-the-use_mm-unuse_mm-api-contract-v2
+++ a/kernel/kthread.c
@@ -1256,7 +1256,7 @@ void kthread_use_mm(struct mm_struct *mm
 EXPORT_SYMBOL_GPL(kthread_use_mm);
 
 /**
- * kthread_use_mm - reverse the effect of kthread_use_mm()
+ * kthread_unuse_mm - reverse the effect of kthread_use_mm()
  * @mm: address space to operate on
  */
 void kthread_unuse_mm(struct mm_struct *mm)
_

Patches currently in -mm which might be from hch@lst.de are

kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-set-user_ds-in-kthread_use_mm.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch

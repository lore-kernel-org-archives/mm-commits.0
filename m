Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A3AC11F6A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1E8661CA3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhGFTYW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhGFTYV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A138261C9D;
        Tue,  6 Jul 2021 19:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599302;
        bh=zG+/5ADQsOus5wiihTEBfgUmfF8hx2KqncD+EWBU9Zs=;
        h=Date:From:To:Subject:From;
        b=jkr4bG6VeTi1KOFyI5q3IPs8OblpZA4NNYys5MHoCx7qiOcUSX/tnVel8phBURJZ8
         P7AoBYy2hui6lDYvxWEDxc7LPzTKMp/m7m0XNLfL3A/EapJivRZ4mq5n+kbA5uSDk3
         XN9JHPTTmgtTghMgWr/H309dFa73T45uloJ12DDc=
Date:   Tue, 06 Jul 2021 12:21:41 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bskeggs@redhat.com, hch@lst.de,
        hughd@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shakeelb@google.com, willy@infradead.org
Subject:  [merged] nouveau-svm-implement-atomic-svm-access.patch
 removed from -mm tree
Message-ID: <20210706192141.1DAUyiQ-_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nouveau/svm: implement atomic SVM access
has been removed from the -mm tree.  Its filename was
     nouveau-svm-implement-atomic-svm-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: nouveau/svm: implement atomic SVM access

Some NVIDIA GPUs do not support direct atomic access to system memory via
PCIe.  Instead this must be emulated by granting the GPU exclusive access
to the memory.  This is achieved by replacing CPU page table entries with
special swap entries that fault on userspace access.

The driver then grants the GPU permission to update the page undergoing
atomic access via the GPU page tables.  When CPU access to the page is
required a CPU fault is raised which calls into the device driver via MMU
notifiers to revoke the atomic access.  The original page table entries
are then restored allowing CPU access to proceed.

Link: https://lkml.kernel.org/r/20210616105937.23201-11-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/include/nvif/if000c.h      |    1 
 drivers/gpu/drm/nouveau/nouveau_svm.c              |  126 ++++++++++-
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h      |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c |    6 
 4 files changed, 123 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/nouveau/include/nvif/if000c.h~nouveau-svm-implement-atomic-svm-access
+++ a/drivers/gpu/drm/nouveau/include/nvif/if000c.h
@@ -77,6 +77,7 @@ struct nvif_vmm_pfnmap_v0 {
 #define NVIF_VMM_PFNMAP_V0_APER                           0x00000000000000f0ULL
 #define NVIF_VMM_PFNMAP_V0_HOST                           0x0000000000000000ULL
 #define NVIF_VMM_PFNMAP_V0_VRAM                           0x0000000000000010ULL
+#define NVIF_VMM_PFNMAP_V0_A				  0x0000000000000004ULL
 #define NVIF_VMM_PFNMAP_V0_W                              0x0000000000000002ULL
 #define NVIF_VMM_PFNMAP_V0_V                              0x0000000000000001ULL
 #define NVIF_VMM_PFNMAP_V0_NONE                           0x0000000000000000ULL
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~nouveau-svm-implement-atomic-svm-access
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -35,6 +35,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sort.h>
 #include <linux/hmm.h>
+#include <linux/rmap.h>
 
 struct nouveau_svm {
 	struct nouveau_drm *drm;
@@ -67,6 +68,11 @@ struct nouveau_svm {
 	} buffer[1];
 };
 
+#define FAULT_ACCESS_READ 0
+#define FAULT_ACCESS_WRITE 1
+#define FAULT_ACCESS_ATOMIC 2
+#define FAULT_ACCESS_PREFETCH 3
+
 #define SVM_DBG(s,f,a...) NV_DEBUG((s)->drm, "svm: "f"\n", ##a)
 #define SVM_ERR(s,f,a...) NV_WARN((s)->drm, "svm: "f"\n", ##a)
 
@@ -412,6 +418,24 @@ nouveau_svm_fault_cancel_fault(struct no
 }
 
 static int
+nouveau_svm_fault_priority(u8 fault)
+{
+	switch (fault) {
+	case FAULT_ACCESS_PREFETCH:
+		return 0;
+	case FAULT_ACCESS_READ:
+		return 1;
+	case FAULT_ACCESS_WRITE:
+		return 2;
+	case FAULT_ACCESS_ATOMIC:
+		return 3;
+	default:
+		WARN_ON_ONCE(1);
+		return -1;
+	}
+}
+
+static int
 nouveau_svm_fault_cmp(const void *a, const void *b)
 {
 	const struct nouveau_svm_fault *fa = *(struct nouveau_svm_fault **)a;
@@ -421,9 +445,8 @@ nouveau_svm_fault_cmp(const void *a, con
 		return ret;
 	if ((ret = (s64)fa->addr - fb->addr))
 		return ret;
-	/*XXX: atomic? */
-	return (fa->access == 0 || fa->access == 3) -
-	       (fb->access == 0 || fb->access == 3);
+	return nouveau_svm_fault_priority(fa->access) -
+		nouveau_svm_fault_priority(fb->access);
 }
 
 static void
@@ -487,6 +510,10 @@ static bool nouveau_svm_range_invalidate
 	struct svm_notifier *sn =
 		container_of(mni, struct svm_notifier, notifier);
 
+	if (range->event == MMU_NOTIFY_EXCLUSIVE &&
+	    range->owner == sn->svmm->vmm->cli->drm->dev)
+		return true;
+
 	/*
 	 * serializes the update to mni->invalidate_seq done by caller and
 	 * prevents invalidation of the PTE from progressing while HW is being
@@ -555,6 +582,71 @@ static void nouveau_hmm_convert_pfn(stru
 		args->p.phys[0] |= NVIF_VMM_PFNMAP_V0_W;
 }
 
+static int nouveau_atomic_range_fault(struct nouveau_svmm *svmm,
+			       struct nouveau_drm *drm,
+			       struct nouveau_pfnmap_args *args, u32 size,
+			       struct svm_notifier *notifier)
+{
+	unsigned long timeout =
+		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	struct mm_struct *mm = svmm->notifier.mm;
+	struct page *page;
+	unsigned long start = args->p.addr;
+	unsigned long notifier_seq;
+	int ret = 0;
+
+	ret = mmu_interval_notifier_insert(&notifier->notifier, mm,
+					args->p.addr, args->p.size,
+					&nouveau_svm_mni_ops);
+	if (ret)
+		return ret;
+
+	while (true) {
+		if (time_after(jiffies, timeout)) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		notifier_seq = mmu_interval_read_begin(&notifier->notifier);
+		mmap_read_lock(mm);
+		ret = make_device_exclusive_range(mm, start, start + PAGE_SIZE,
+					    &page, drm->dev);
+		mmap_read_unlock(mm);
+		if (ret <= 0 || !page) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		mutex_lock(&svmm->mutex);
+		if (!mmu_interval_read_retry(&notifier->notifier,
+					     notifier_seq))
+			break;
+		mutex_unlock(&svmm->mutex);
+	}
+
+	/* Map the page on the GPU. */
+	args->p.page = 12;
+	args->p.size = PAGE_SIZE;
+	args->p.addr = start;
+	args->p.phys[0] = page_to_phys(page) |
+		NVIF_VMM_PFNMAP_V0_V |
+		NVIF_VMM_PFNMAP_V0_W |
+		NVIF_VMM_PFNMAP_V0_A |
+		NVIF_VMM_PFNMAP_V0_HOST;
+
+	svmm->vmm->vmm.object.client->super = true;
+	ret = nvif_object_ioctl(&svmm->vmm->vmm.object, args, size, NULL);
+	svmm->vmm->vmm.object.client->super = false;
+	mutex_unlock(&svmm->mutex);
+
+	unlock_page(page);
+	put_page(page);
+
+out:
+	mmu_interval_notifier_remove(&notifier->notifier);
+	return ret;
+}
+
 static int nouveau_range_fault(struct nouveau_svmm *svmm,
 			       struct nouveau_drm *drm,
 			       struct nouveau_pfnmap_args *args, u32 size,
@@ -637,7 +729,7 @@ nouveau_svm_fault(struct nvif_notify *no
 	unsigned long hmm_flags;
 	u64 inst, start, limit;
 	int fi, fn;
-	int replay = 0, ret;
+	int replay = 0, atomic = 0, ret;
 
 	/* Parse available fault buffer entries into a cache, and update
 	 * the GET pointer so HW can reuse the entries.
@@ -718,12 +810,14 @@ nouveau_svm_fault(struct nvif_notify *no
 		/*
 		 * Determine required permissions based on GPU fault
 		 * access flags.
-		 * XXX: atomic?
 		 */
 		switch (buffer->fault[fi]->access) {
 		case 0: /* READ. */
 			hmm_flags = HMM_PFN_REQ_FAULT;
 			break;
+		case 2: /* ATOMIC. */
+			atomic = true;
+			break;
 		case 3: /* PREFETCH. */
 			hmm_flags = 0;
 			break;
@@ -739,8 +833,14 @@ nouveau_svm_fault(struct nvif_notify *no
 		}
 
 		notifier.svmm = svmm;
-		ret = nouveau_range_fault(svmm, svm->drm, &args.i,
-					sizeof(args), hmm_flags, &notifier);
+		if (atomic)
+			ret = nouveau_atomic_range_fault(svmm, svm->drm,
+							 &args.i, sizeof(args),
+							 &notifier);
+		else
+			ret = nouveau_range_fault(svmm, svm->drm, &args.i,
+						  sizeof(args), hmm_flags,
+						  &notifier);
 		mmput(mm);
 
 		limit = args.i.p.addr + args.i.p.size;
@@ -756,11 +856,15 @@ nouveau_svm_fault(struct nvif_notify *no
 			 */
 			if (buffer->fault[fn]->svmm != svmm ||
 			    buffer->fault[fn]->addr >= limit ||
-			    (buffer->fault[fi]->access == 0 /* READ. */ &&
+			    (buffer->fault[fi]->access == FAULT_ACCESS_READ &&
 			     !(args.phys[0] & NVIF_VMM_PFNMAP_V0_V)) ||
-			    (buffer->fault[fi]->access != 0 /* READ. */ &&
-			     buffer->fault[fi]->access != 3 /* PREFETCH. */ &&
-			     !(args.phys[0] & NVIF_VMM_PFNMAP_V0_W)))
+			    (buffer->fault[fi]->access != FAULT_ACCESS_READ &&
+			     buffer->fault[fi]->access != FAULT_ACCESS_PREFETCH &&
+			     !(args.phys[0] & NVIF_VMM_PFNMAP_V0_W)) ||
+			    (buffer->fault[fi]->access != FAULT_ACCESS_READ &&
+			     buffer->fault[fi]->access != FAULT_ACCESS_WRITE &&
+			     buffer->fault[fi]->access != FAULT_ACCESS_PREFETCH &&
+			     !(args.phys[0] & NVIF_VMM_PFNMAP_V0_A)))
 				break;
 		}
 
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c~nouveau-svm-implement-atomic-svm-access
+++ a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
@@ -88,6 +88,9 @@ gp100_vmm_pgt_pfn(struct nvkm_vmm *vmm,
 		if (!(*map->pfn & NVKM_VMM_PFN_W))
 			data |= BIT_ULL(6); /* RO. */
 
+		if (!(*map->pfn & NVKM_VMM_PFN_A))
+			data |= BIT_ULL(7); /* Atomic disable. */
+
 		if (!(*map->pfn & NVKM_VMM_PFN_VRAM)) {
 			addr = *map->pfn >> NVKM_VMM_PFN_ADDR_SHIFT;
 			addr = dma_map_page(dev, pfn_to_page(addr), 0,
@@ -322,6 +325,9 @@ gp100_vmm_pd0_pfn(struct nvkm_vmm *vmm,
 		if (!(*map->pfn & NVKM_VMM_PFN_W))
 			data |= BIT_ULL(6); /* RO. */
 
+		if (!(*map->pfn & NVKM_VMM_PFN_A))
+			data |= BIT_ULL(7); /* Atomic disable. */
+
 		if (!(*map->pfn & NVKM_VMM_PFN_VRAM)) {
 			addr = *map->pfn >> NVKM_VMM_PFN_ADDR_SHIFT;
 			addr = dma_map_page(dev, pfn_to_page(addr), 0,
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h~nouveau-svm-implement-atomic-svm-access
+++ a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h
@@ -178,6 +178,7 @@ void nvkm_vmm_unmap_region(struct nvkm_v
 #define NVKM_VMM_PFN_APER                                 0x00000000000000f0ULL
 #define NVKM_VMM_PFN_HOST                                 0x0000000000000000ULL
 #define NVKM_VMM_PFN_VRAM                                 0x0000000000000010ULL
+#define NVKM_VMM_PFN_A					  0x0000000000000004ULL
 #define NVKM_VMM_PFN_W                                    0x0000000000000002ULL
 #define NVKM_VMM_PFN_V                                    0x0000000000000001ULL
 #define NVKM_VMM_PFN_NONE                                 0x0000000000000000ULL
_

Patches currently in -mm which might be from apopple@nvidia.com are



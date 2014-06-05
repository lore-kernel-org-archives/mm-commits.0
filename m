From: akpm@linux-foundation.org
Subject: [merged] drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:07 -0700
Message-ID: <5390c9ef.iCUkTgGy/CvZPy2N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaFETuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jy0922.shim@samsung.com, inki.dae@samsung.com, davidlohr@hp.com, airlied@linux.ie, zeus@gnu.org

Subject: [merged] drm-exynos-call-find_vma-with-the-mmap_sem-held.patch removed from -mm tree
To: zeus@gnu.org,airlied@linux.ie,davidlohr@hp.com,inki.dae@samsung.com,jy0922.shim@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:07 -0700


The patch titled
     Subject: drm/exynos: call find_vma with the mmap_sem held
has been removed from the -mm tree.  Its filename was
     drm-exynos-call-find_vma-with-the-mmap_sem-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jonathan Gonzalez V <zeus@gnu.org>
Subject: drm/exynos: call find_vma with the mmap_sem held

Performing vma lookups without taking the mm->mmap_sem is asking for
trouble.  While doing the search, the vma in question can be modified or
even removed before returning to the caller.  Take the lock (exclusively)
in order to avoid races while iterating through the vmacache and/or
rbtree.

Signed-off-by: Jonathan Gonzalez V <zeus@gnu.org>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/exynos/exynos_drm_g2d.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/gpu/drm/exynos/exynos_drm_g2d.c~drm-exynos-call-find_vma-with-the-mmap_sem-held drivers/gpu/drm/exynos/exynos_drm_g2d.c
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c~drm-exynos-call-find_vma-with-the-mmap_sem-held
+++ a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -467,14 +467,17 @@ static dma_addr_t *g2d_userptr_get_dma_a
 		goto err_free;
 	}
 
+	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, userptr);
 	if (!vma) {
+		up_read(&current->mm->mmap_sem);
 		DRM_ERROR("failed to get vm region.\n");
 		ret = -EFAULT;
 		goto err_free_pages;
 	}
 
 	if (vma->vm_end < userptr + size) {
+		up_read(&current->mm->mmap_sem);
 		DRM_ERROR("vma is too small.\n");
 		ret = -EFAULT;
 		goto err_free_pages;
@@ -482,6 +485,7 @@ static dma_addr_t *g2d_userptr_get_dma_a
 
 	g2d_userptr->vma = exynos_gem_get_vma(vma);
 	if (!g2d_userptr->vma) {
+		up_read(&current->mm->mmap_sem);
 		DRM_ERROR("failed to copy vma.\n");
 		ret = -ENOMEM;
 		goto err_free_pages;
@@ -492,10 +496,12 @@ static dma_addr_t *g2d_userptr_get_dma_a
 	ret = exynos_gem_get_pages_from_userptr(start & PAGE_MASK,
 						npages, pages, vma);
 	if (ret < 0) {
+		up_read(&current->mm->mmap_sem);
 		DRM_ERROR("failed to get user pages from userptr.\n");
 		goto err_put_vma;
 	}
 
+	up_read(&current->mm->mmap_sem);
 	g2d_userptr->pages = pages;
 
 	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
_

Patches currently in -mm which might be from zeus@gnu.org are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + drm-exynos-call-find_vma-with-the-mmap_sem-held.patch added to
 -mm tree
Date: Mon, 21 Apr 2014 14:20:46 -0700
Message-ID: <53558bae.M04MYf/ahu2AYpAe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaDUVUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 17:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jy0922.shim@samsung.com, inki.dae@samsung.com, davidlohr@hp.com, airlied@linux.ie, zeus@gnu.org

Subject: + drm-exynos-call-find_vma-with-the-mmap_sem-held.patch added to -mm tree
To: zeus@gnu.org,airlied@linux.ie,davidlohr@hp.com,inki.dae@samsung.com,jy0922.shim@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 14:20:46 -0700


The patch titled
     Subject: drm/exynos: call find_vma with the mmap_sem held
has been added to the -mm tree.  Its filename is
     drm-exynos-call-find_vma-with-the-mmap_sem-held.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-exynos-call-find_vma-with-the-mmap_sem-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch


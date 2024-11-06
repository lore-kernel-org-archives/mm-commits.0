Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A0517E00B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854829; cv=none; b=QOX76Xr+BpA9yyzl6zMrPvIkwaxROtervWDbi4lS1dB+2kFvQh0zHyFSGmYuwKE59GgLT5jDsszlXOwJWiE4PWjnQNaK70Zbv137aHpU58h4jJ+adahHmCD2yd3d6Q5gCxlrA4k/CJrQisLu3gifXq6sqtffwXECFntFrvOBJEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854829; c=relaxed/simple;
	bh=UzIixfXURB/u3BtCmHYbtxuWQliTwsWfH4JebnX2Fhc=;
	h=Date:To:From:Subject:Message-Id; b=PnpNM3KbPcFejWf0l+GSnPBrgnAKWYSn65gsKg87G4Ni4jcM564dkczhjgNDcAwqKuQCaz+Ql1Cm3FNvoVZNm6uY/wt+jr9KOjxpbLHwAzg02RIroYSvL3HC0cUdepvQop9Kz+5uRRJefBgpjRqgBhZrwwuis8TNGSX+jUBOSWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eiB3v9MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eiB3v9MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B542C4CECF;
	Wed,  6 Nov 2024 01:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854827;
	bh=UzIixfXURB/u3BtCmHYbtxuWQliTwsWfH4JebnX2Fhc=;
	h=Date:To:From:Subject:From;
	b=eiB3v9MGWlDqUU0ErIcvas2r3n2uXWM529jjF6AElHPRQkXoD2uT+jJ+AEMjPGI9Q
	 pVf9H3mgwljmmZLsf9H3BSQGJZ4AUrrR1cjCQD5auVnT8t+CQHWGHMTzGdxkFJdj2w
	 8bJrkTdZ1iN9gsGeM9QrgrmBaOH2//xEomsY6JE0=
Date: Tue, 05 Nov 2024 17:00:27 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,wangkefeng.wang@huawei.com,pedro.falcato@gmail.com,lorenzo.stoakes@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-clean-up-vma_to_resize.patch removed from -mm tree
Message-Id: <20241106010027.8B542C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: cleanup vma_to_resize()
has been removed from the -mm tree.  Its filename was
     mm-mremap-clean-up-vma_to_resize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mremap: cleanup vma_to_resize()
Date: Fri, 18 Oct 2024 13:41:13 -0400

Patch series "mm/mremap: Remove extra vma tree walk", v2.

An extra vma tree walk was discovered in some mremap call paths during the
discussion on mseal() changes.  This patch set removes the extra vma tree
walk and further cleans up mremap_to().


This patch (of 2):

vma_to_resize() is used in two locations to find and validate the vma for
the mremap location.  One of the two locations already has the vma, which
is then re-found to validate the same vma.

This code can be simplified by moving the vma_lookup() from
vma_to_resize() to mremap_to() and changing the return type to an int
error.

Since the function now just validates the vma, the function is renamed to
resize_is_valid() to better reflect what it is doing.

This commit also adds documentation about the function.

Link: https://lkml.kernel.org/r/20241018174114.2871880-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20241018174114.2871880-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   53 +++++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

--- a/mm/mremap.c~mm-mremap-clean-up-vma_to_resize
+++ a/mm/mremap.c
@@ -826,17 +826,24 @@ static unsigned long move_vma(struct vm_
 	return new_addr;
 }
 
-static struct vm_area_struct *vma_to_resize(unsigned long addr,
+/*
+ * resize_is_valid() - Ensure the vma can be resized to the new length at the give
+ * address.
+ *
+ * @vma: The vma to resize
+ * @addr: The old address
+ * @old_len: The current size
+ * @new_len: The desired size
+ * @flags: The vma flags
+ *
+ * Return 0 on success, error otherwise.
+ */
+static int resize_is_valid(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long old_len, unsigned long new_len, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
 	unsigned long pgoff;
 
-	vma = vma_lookup(mm, addr);
-	if (!vma)
-		return ERR_PTR(-EFAULT);
-
 	/*
 	 * !old_len is a special case where an attempt is made to 'duplicate'
 	 * a mapping.  This makes no sense for private mappings as it will
@@ -847,37 +854,37 @@ static struct vm_area_struct *vma_to_res
 	 */
 	if (!old_len && !(vma->vm_flags & (VM_SHARED | VM_MAYSHARE))) {
 		pr_warn_once("%s (%d): attempted to duplicate a private mapping with mremap.  This is not supported.\n", current->comm, current->pid);
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	}
 
 	if ((flags & MREMAP_DONTUNMAP) &&
 			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	/* We can't remap across vm area boundaries */
 	if (old_len > vma->vm_end - addr)
-		return ERR_PTR(-EFAULT);
+		return -EFAULT;
 
 	if (new_len == old_len)
-		return vma;
+		return 0;
 
 	/* Need to be careful about a growing mapping */
 	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
 	pgoff += vma->vm_pgoff;
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
-		return ERR_PTR(-EFAULT);
+		return -EFAULT;
 
 	if (!mlock_future_ok(mm, vma->vm_flags, new_len - old_len))
-		return ERR_PTR(-EAGAIN);
+		return -EAGAIN;
 
 	if (!may_expand_vm(mm, vma->vm_flags,
 				(new_len - old_len) >> PAGE_SHIFT))
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
-	return vma;
+	return 0;
 }
 
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
@@ -936,12 +943,16 @@ static unsigned long mremap_to(unsigned
 		old_len = new_len;
 	}
 
-	vma = vma_to_resize(addr, old_len, new_len, flags);
-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
+	vma = vma_lookup(mm, addr);
+	if (!vma) {
+		ret = -EFAULT;
 		goto out;
 	}
 
+	ret = resize_is_valid(vma, addr, old_len, new_len, flags);
+	if (ret)
+		goto out;
+
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
 	if (flags & MREMAP_DONTUNMAP &&
 		!may_expand_vm(mm, vma->vm_flags, old_len >> PAGE_SHIFT)) {
@@ -1114,11 +1125,9 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	/*
 	 * Ok, we need to grow..
 	 */
-	vma = vma_to_resize(addr, old_len, new_len, flags);
-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
+	ret = resize_is_valid(vma, addr, old_len, new_len, flags);
+	if (ret)
 		goto out;
-	}
 
 	/* old_len exactly to the end of the area..
 	 */
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

vma-detect-infinite-loop-in-vma-tree.patch


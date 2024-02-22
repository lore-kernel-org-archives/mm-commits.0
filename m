Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D802904
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560097; cv=none; b=kdjwunXEKwxVEyTKRZSD/DKQ8N0ojYHdxm+k69kyMWvrdim1bHZj1u/4JFEgYKPaNwRdJnl8pFn42Xf6wdCyotOXKZQy7IWylUUpod/DUVPyHKHggwi3Ew6cNLQ9hC4tj7S2qu2NzONUmqPwKd2S1KBjvncF35X2VwR9bRUOQQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560097; c=relaxed/simple;
	bh=9wnG7pWgtalZr/ZJ2zRWZiFKrUhWa4rOFZIyzyDr8UE=;
	h=Date:To:From:Subject:Message-Id; b=O4pQJx23ng2TvlUKAvqqkvteI7+Ky14qgaVFs0qA9VSokYgtef8oaDmoqzgSUbYw5EnnYLuxRR+CFhww3/N6kIgfjRet4sCmRrKikA/NTBpKIWxOzfEbbJ9LD5ImWrUPSzQt4UyfGjc0OpgG7iTzh3z7iZ6E0NEdhGk9Mn1psc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iY51WHms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iY51WHms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68022C43390;
	Thu, 22 Feb 2024 00:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560097;
	bh=9wnG7pWgtalZr/ZJ2zRWZiFKrUhWa4rOFZIyzyDr8UE=;
	h=Date:To:From:Subject:From;
	b=iY51WHmsACAefaYmACXB6j+bC4CT9qfflXhqV8DPvhJ1o9AyGl/8SbkgjuEjZtgko
	 KKBNrPFas4/OfLq6Lb6bORg955AnADFqz1M/AfmQU5j7KNMxikX1D7c9tDCwAHNpJs
	 xbvNugP8vd7zV7M0RhQpVeHWRqgBd8ipYhWEl8Y8=
Date: Wed, 21 Feb 2024 16:01:36 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-introduce-vma_set_range.patch removed from -mm tree
Message-Id: <20240222000137.68022C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: introduce vma_set_range()
has been removed from the -mm tree.  Its filename was
     mm-mmap-introduce-vma_set_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: introduce vma_set_range()
Date: Wed, 24 Jan 2024 11:57:19 +0800

There is a lot of code needs to set the range of vma in mmap.c, introduce
vma_set_range() to simplify the code.

Link: https://lkml.kernel.org/r/20240124035719.3685193-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    9 +++++++++
 mm/mmap.c     |   29 +++++++----------------------
 2 files changed, 16 insertions(+), 22 deletions(-)

--- a/mm/internal.h~mm-mmap-introduce-vma_set_range
+++ a/mm/internal.h
@@ -1114,6 +1114,15 @@ static inline bool gup_must_unshare(stru
 extern bool mirrored_kernelcore;
 extern bool memblock_has_mirror(void);
 
+static __always_inline void vma_set_range(struct vm_area_struct *vma,
+					  unsigned long start, unsigned long end,
+					  pgoff_t pgoff)
+{
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+}
+
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
 	/*
--- a/mm/mmap.c~mm-mmap-introduce-vma_set_range
+++ a/mm/mmap.c
@@ -663,9 +663,7 @@ int vma_expand(struct vma_iterator *vmi,
 
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, start, end, 0);
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
+	vma_set_range(vma, start, end, pgoff);
 	vma_iter_store(vmi, vma);
 
 	vma_complete(&vp, vmi, vma->vm_mm);
@@ -708,9 +706,7 @@ int vma_shrink(struct vma_iterator *vmi,
 	vma_adjust_trans_huge(vma, start, end, 0);
 
 	vma_iter_clear(vmi);
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
+	vma_set_range(vma, start, end, pgoff);
 	vma_complete(&vp, vmi, vma->vm_mm);
 	return 0;
 }
@@ -1015,10 +1011,7 @@ static struct vm_area_struct
 
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_start);
-
-	vma->vm_start = vma_start;
-	vma->vm_end = vma_end;
-	vma->vm_pgoff = vma_pgoff;
+	vma_set_range(vma, vma_start, vma_end, vma_pgoff);
 
 	if (vma_expanded)
 		vma_iter_store(vmi, vma);
@@ -2811,11 +2804,9 @@ cannot_expand:
 	}
 
 	vma_iter_config(&vmi, addr, end);
-	vma->vm_start = addr;
-	vma->vm_end = end;
+	vma_set_range(vma, addr, end, pgoff);
 	vm_flags_init(vma, vm_flags);
 	vma->vm_page_prot = vm_get_page_prot(vm_flags);
-	vma->vm_pgoff = pgoff;
 
 	if (file) {
 		vma->vm_file = get_file(file);
@@ -3165,9 +3156,7 @@ static int do_brk_flags(struct vma_itera
 		goto unacct_fail;
 
 	vma_set_anonymous(vma);
-	vma->vm_start = addr;
-	vma->vm_end = addr + len;
-	vma->vm_pgoff = addr >> PAGE_SHIFT;
+	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
 	vm_flags_init(vma, flags);
 	vma->vm_page_prot = vm_get_page_prot(flags);
 	vma_start_write(vma);
@@ -3404,9 +3393,7 @@ struct vm_area_struct *copy_vma(struct v
 		new_vma = vm_area_dup(vma);
 		if (!new_vma)
 			goto out;
-		new_vma->vm_start = addr;
-		new_vma->vm_end = addr + len;
-		new_vma->vm_pgoff = pgoff;
+		vma_set_range(new_vma, addr, addr + len, pgoff);
 		if (vma_dup_policy(vma, new_vma))
 			goto out_free_vma;
 		if (anon_vma_clone(new_vma, vma))
@@ -3574,9 +3561,7 @@ static struct vm_area_struct *__install_
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
 
-	vma->vm_start = addr;
-	vma->vm_end = addr + len;
-
+	vma_set_range(vma, addr, addr + len, 0);
 	vm_flags_init(vma, (vm_flags | mm->def_flags |
 		      VM_DONTEXPAND | VM_SOFTDIRTY) & ~VM_LOCKED_MASK);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
_

Patches currently in -mm which might be from yajun.deng@linux.dev are



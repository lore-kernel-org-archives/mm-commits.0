Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D5858200
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 21:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uc9zr9Z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B06EC433C7;
	Thu, 11 Jan 2024 21:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705008426;
	bh=wpF3xbTvEbimE6gEnWsWd6h4niCN0s/rUnZNMMMwJSU=;
	h=Date:To:From:Subject:From;
	b=uc9zr9Z9pAFzPwmVt++15/fnKL8U28bHyo01GoSAy9crzkR0dHeGqTlI4DETlLKE3
	 izl8Ade9fbJpr7YmqvfEWkLpZ+0IQjh3wIo07ODs4s/iHYuXFKBzb0Tw/03gkyXjYl
	 yUAi0AYKjPEanKpZPe/SxaMvmLNSI245ay9KkfEY=
Date: Thu, 11 Jan 2024 13:27:05 -0800
To: mm-commits@vger.kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-introduce-vma_range_init.patch added to mm-unstable branch
Message-Id: <20240111212706.4B06EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: introduce vma_range_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-introduce-vma_range_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-introduce-vma_range_init.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: introduce vma_range_init()
Date: Thu, 11 Jan 2024 10:15:26 +0800

There is a lot of code that needs to set the range of a vma.  Introduce
vma_range_init() to initialize the range of vma.

Link: https://lkml.kernel.org/r/20240111021526.3461825-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++++++++
 mm/mmap.c          |   29 +++++++----------------------
 2 files changed, 16 insertions(+), 22 deletions(-)

--- a/include/linux/mm.h~mm-mmap-introduce-vma_range_init
+++ a/include/linux/mm.h
@@ -3516,6 +3516,15 @@ static inline bool range_in_vma(struct v
 	return (vma && vma->vm_start <= start && end <= vma->vm_end);
 }
 
+static inline void vma_range_init(struct vm_area_struct *vma,
+				  unsigned long start, unsigned long end,
+				  pgoff_t pgoff)
+{
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+}
+
 #ifdef CONFIG_MMU
 pgprot_t vm_get_page_prot(unsigned long vm_flags);
 void vma_set_page_prot(struct vm_area_struct *vma);
--- a/mm/mmap.c~mm-mmap-introduce-vma_range_init
+++ a/mm/mmap.c
@@ -663,9 +663,7 @@ int vma_expand(struct vma_iterator *vmi,
 
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, start, end, 0);
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
+	vma_range_init(vma, start, end, pgoff);
 	vma_iter_store(vmi, vma);
 
 	vma_complete(&vp, vmi, vma->vm_mm);
@@ -708,9 +706,7 @@ int vma_shrink(struct vma_iterator *vmi,
 	vma_adjust_trans_huge(vma, start, end, 0);
 
 	vma_iter_clear(vmi);
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
+	vma_range_init(vma, start, end, pgoff);
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
+	vma_range_init(vma, vma_start, vma_end, vma_pgoff);
 
 	if (vma_expanded)
 		vma_iter_store(vmi, vma);
@@ -2809,11 +2802,9 @@ cannot_expand:
 	}
 
 	vma_iter_config(&vmi, addr, end);
-	vma->vm_start = addr;
-	vma->vm_end = end;
+	vma_range_init(vma, addr, end, pgoff);
 	vm_flags_init(vma, vm_flags);
 	vma->vm_page_prot = vm_get_page_prot(vm_flags);
-	vma->vm_pgoff = pgoff;
 
 	if (file) {
 		vma->vm_file = get_file(file);
@@ -3163,9 +3154,7 @@ static int do_brk_flags(struct vma_itera
 		goto unacct_fail;
 
 	vma_set_anonymous(vma);
-	vma->vm_start = addr;
-	vma->vm_end = addr + len;
-	vma->vm_pgoff = addr >> PAGE_SHIFT;
+	vma_range_init(vma, addr, addr + len, addr >> PAGE_SHIFT);
 	vm_flags_init(vma, flags);
 	vma->vm_page_prot = vm_get_page_prot(flags);
 	vma_start_write(vma);
@@ -3402,9 +3391,7 @@ struct vm_area_struct *copy_vma(struct v
 		new_vma = vm_area_dup(vma);
 		if (!new_vma)
 			goto out;
-		new_vma->vm_start = addr;
-		new_vma->vm_end = addr + len;
-		new_vma->vm_pgoff = pgoff;
+		vma_range_init(new_vma, addr, addr + len, pgoff);
 		if (vma_dup_policy(vma, new_vma))
 			goto out_free_vma;
 		if (anon_vma_clone(new_vma, vma))
@@ -3572,9 +3559,7 @@ static struct vm_area_struct *__install_
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
 
-	vma->vm_start = addr;
-	vma->vm_end = addr + len;
-
+	vma_range_init(vma, addr, addr + len, 0);
 	vm_flags_init(vma, (vm_flags | mm->def_flags |
 		      VM_DONTEXPAND | VM_SOFTDIRTY) & ~VM_LOCKED_MASK);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-mmap-simplify-vma-link-and-unlink.patch
mm-mmap-introduce-vma_range_init.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7E91D45F3
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 21:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729115984; cv=none; b=Fl7Wc5HUCxpM8LB3tuDPT/cQRUUdB+HKiqzEOkLwJzqbKmwpAviB+G+rog5b8Q5FkcsYwGDVS4RcdUyXz5FTHODhrjvS1mamCBrAQUK25lkpMOy1fRvjFAMlZpxLgbQlQ6ezVJYf/5gZlUs0C/yLEJ/UMnkIzv5PsMPBQ5jCraI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729115984; c=relaxed/simple;
	bh=D+nXdU5HKlCKuKeD++ufTYI6Q9F6WWqSQ2QkfxGTesQ=;
	h=Date:To:From:Subject:Message-Id; b=i8PC4KCGFrvSXVhonS9tDmgAjYYDYhaWBmXiKORmC4LSJ3QE5YAhiK/X7dGarDgjo/ilTqPM31sH/2VFDX4HCQxaLi1AMnDs0AlDEL3BI6I0Xh1NdebBYMEbTgEn08m3471d5OYE0+vfEJhoZgY2R73JgyVsfaQET4KAenoFBD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aIaa5ES9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aIaa5ES9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DE2C4CEC5;
	Wed, 16 Oct 2024 21:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729115983;
	bh=D+nXdU5HKlCKuKeD++ufTYI6Q9F6WWqSQ2QkfxGTesQ=;
	h=Date:To:From:Subject:From;
	b=aIaa5ES9PpadhNGfKcTbN1gI0g+Ng+/JIWmDIULtsGKP00CkITAK4ErJWo3UE3o3I
	 vEGiyAapE4hkc+s/NXAtF8+6DDOXmCisgDqimy4mPcMm2ofGk5TRymT1Ge9/pWOx3x
	 B1QvW04JHalroohsi80SuoJPKidVoDXz7FNRseyU=
Date: Wed, 16 Oct 2024 14:59:43 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,wangkefeng.wang@huawei.com,pedro.falcato@gmail.com,lorenzo.stoakes@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-clean-up-vma_to_resize.patch added to mm-unstable branch
Message-Id: <20241016215943.B8DE2C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: clean up vma_to_resize()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-clean-up-vma_to_resize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-clean-up-vma_to_resize.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mremap: clean up vma_to_resize()
Date: Wed, 16 Oct 2024 16:17:17 -0400

Patch series "mm/mremap: Remove extra vma tree walk".

An extra vma tree walk was discovered in some mremap call paths during the
discussion on mseal() changes.  This patchset removes the extra vma tree
walk and further cleans up mremap_to().


This patch (of 2):

vma_to_resize() is used in two locations to find and validate the vma
for the mremap location.  One of the two locations already has the vma,
which is then re-found to validate the same vma.

This code can be simplified by moving the vma_lookup() from
vma_to_resize() to mremap_to() and changing the return type to an int
error.

Since the function now just validates the vma, the function is renamed to
mremap_vma_check() to better reflect what it is doing.

Link: https://lkml.kernel.org/r/20241016201719.2449143-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20241016201719.2449143-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/mm/mremap.c~mm-mremap-clean-up-vma_to_resize
+++ a/mm/mremap.c
@@ -826,17 +826,12 @@ static unsigned long move_vma(struct vm_
 	return new_addr;
 }
 
-static struct vm_area_struct *vma_to_resize(unsigned long addr,
+static int mremap_vma_check(struct vm_area_struct *vma, unsigned long addr,
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
@@ -847,37 +842,37 @@ static struct vm_area_struct *vma_to_res
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
@@ -936,7 +931,13 @@ static unsigned long mremap_to(unsigned
 		old_len = new_len;
 	}
 
-	vma = vma_to_resize(addr, old_len, new_len, flags);
+	vma = vma_lookup(mm, addr);
+	if (!vma) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	mremap_vma_check(vma, addr, old_len, new_len, flags);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
@@ -1114,11 +1115,9 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	/*
 	 * Ok, we need to grow..
 	 */
-	vma = vma_to_resize(addr, old_len, new_len, flags);
-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
+	ret = mremap_vma_check(vma, addr, old_len, new_len, flags);
+	if (ret)
 		goto out;
-	}
 
 	/* old_len exactly to the end of the area..
 	 */
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-mmap-fix-race-in-mmap_region-with-ftrucate.patch
mm-mremap-clean-up-vma_to_resize.patch
mm-mremap-remove-goto-from-mremap_to.patch


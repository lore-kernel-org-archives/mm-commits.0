Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC6D2DB7A6
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939846; cv=none; b=qUpUGYEE8M7fEhJG3pjPpbqo1099364vjtmsy1aIivutlwhWsR5wO8L7Al8TxGXvSershqis+bVUkA4Z0AZWB1t5cTywZ6qWcQRH/1MsBysvRiKCT/tZDoz3pJcHe4Am1mAcsQiCJuskbTX5iA7qc87WEqfMr+91qRKnLLtKA9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939846; c=relaxed/simple;
	bh=aPPRluDDIfSd/iJpG7O+iNJxorYBFNU7JGGyRgD3Xo4=;
	h=Date:To:From:Subject:Message-Id; b=EJPax2cq1gvSqNFzna1AI2Ge3R3JlBxLcrdz20xpsV4LscAxShfYPIyy/EJ4cOJUziGqMSN31P9bnndekZrrW/0sgRKc8DzU8Qo/89V4KKceCF5KLlvGsqx6EPnUUn3udh7XAZuus0wx7uhDuoxd0Q4cm/8BRq6JGhwsQleX7sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QyiZcIqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QyiZcIqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DE6C4CEF7;
	Thu, 12 Feb 2026 23:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939846;
	bh=aPPRluDDIfSd/iJpG7O+iNJxorYBFNU7JGGyRgD3Xo4=;
	h=Date:To:From:Subject:From;
	b=QyiZcIqCR57bu0OSsxNJtCKRXmblvfk13lRUn5KS/LMtXVBavnUz/AgS1toTPraIh
	 6sLSWiFpy5EntMOZ6e4mxcVMeazD/Y6cD4gnwEuzJffPJ6v7dhmdNHSHc6I62ckj2E
	 2szHIFUcOSQH2X3sIrB9hx60KEPO/GDvcK0tyy1I=
Date: Thu, 12 Feb 2026 15:44:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,Liam.Howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch removed from -mm tree
Message-Id: <20260212234406.75DE6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update secretmem to use VMA flags on mmap_prepare
has been removed from the -mm tree.  Its filename was
     mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: update secretmem to use VMA flags on mmap_prepare
Date: Thu, 22 Jan 2026 16:06:16 +0000

This patch updates secretmem to use the new vma_flags_t type which will
soon supersede vm_flags_t altogether.

In order to make this change we also have to update mlock_future_ok(), we
replace the vm_flags_t parameter with a simple boolean is_vma_locked one,
which also simplifies the invocation here.

This is laying the groundwork for eliminating the vm_flags_t in
vm_area_desc and more broadly throughout the kernel.

No functional changes intended.

[lorenzo.stoakes@oracle.com: fix check_brk_limits(), per Chris]
  Link: https://lkml.kernel.org/r/3aab9ab1-74b4-405e-9efb-08fc2500c06e@lucifer.local
Link: https://lkml.kernel.org/r/a243a09b0a5d0581e963d696de1735f61f5b2075.1769097829.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Chris Mason <clm@fb.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |    2 +-
 mm/mmap.c      |   11 ++++++-----
 mm/mremap.c    |    2 +-
 mm/secretmem.c |    7 +++----
 mm/vma.c       |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

--- a/mm/internal.h~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/internal.h
@@ -1046,7 +1046,7 @@ extern long populate_vma_page_range(stru
 		unsigned long start, unsigned long end, int *locked);
 extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, bool write, int *locked);
-bool mlock_future_ok(const struct mm_struct *mm, vm_flags_t vm_flags,
+bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
 		unsigned long bytes);
 
 /*
--- a/mm/mmap.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/mmap.c
@@ -108,7 +108,8 @@ static int check_brk_limits(unsigned lon
 	if (IS_ERR_VALUE(mapped_addr))
 		return mapped_addr;
 
-	return mlock_future_ok(current->mm, current->mm->def_flags, len)
+	return mlock_future_ok(current->mm,
+			      current->mm->def_flags & VM_LOCKED, len)
 		? 0 : -EAGAIN;
 }
 
@@ -225,12 +226,12 @@ static inline unsigned long round_hint_t
 	return hint;
 }
 
-bool mlock_future_ok(const struct mm_struct *mm, vm_flags_t vm_flags,
-			unsigned long bytes)
+bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
+		     unsigned long bytes)
 {
 	unsigned long locked_pages, limit_pages;
 
-	if (!(vm_flags & VM_LOCKED) || capable(CAP_IPC_LOCK))
+	if (!is_vma_locked || capable(CAP_IPC_LOCK))
 		return true;
 
 	locked_pages = bytes >> PAGE_SHIFT;
@@ -416,7 +417,7 @@ unsigned long do_mmap(struct file *file,
 		if (!can_do_mlock())
 			return -EPERM;
 
-	if (!mlock_future_ok(mm, vm_flags, len))
+	if (!mlock_future_ok(mm, vm_flags & VM_LOCKED, len))
 		return -EAGAIN;
 
 	if (file) {
--- a/mm/mremap.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/mremap.c
@@ -1740,7 +1740,7 @@ static int check_prep_vma(struct vma_rem
 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 		return -EFAULT;
 
-	if (!mlock_future_ok(mm, vma->vm_flags, vrm->delta))
+	if (!mlock_future_ok(mm, vma->vm_flags & VM_LOCKED, vrm->delta))
 		return -EAGAIN;
 
 	if (!may_expand_vm(mm, vma->vm_flags, vrm->delta >> PAGE_SHIFT))
--- a/mm/secretmem.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/secretmem.c
@@ -122,13 +122,12 @@ static int secretmem_mmap_prepare(struct
 {
 	const unsigned long len = vma_desc_size(desc);
 
-	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
+	if (!vma_desc_test_flags(desc, VMA_SHARED_BIT, VMA_MAYSHARE_BIT))
 		return -EINVAL;
 
-	if (!mlock_future_ok(desc->mm, desc->vm_flags | VM_LOCKED, len))
+	vma_desc_set_flags(desc, VMA_LOCKED_BIT, VMA_DONTDUMP_BIT);
+	if (!mlock_future_ok(desc->mm, /*is_vma_locked=*/ true, len))
 		return -EAGAIN;
-
-	desc->vm_flags |= VM_LOCKED | VM_DONTDUMP;
 	desc->vm_ops = &secretmem_vm_ops;
 
 	return 0;
--- a/mm/vma.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare
+++ a/mm/vma.c
@@ -3053,7 +3053,7 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* mlock limit tests */
-	if (!mlock_future_ok(mm, vma->vm_flags, grow << PAGE_SHIFT))
+	if (!mlock_future_ok(mm, vma->vm_flags & VM_LOCKED, grow << PAGE_SHIFT))
 		return -ENOMEM;
 
 	/* Check to ensure the stack will not grow into a hugetlb-only region */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are



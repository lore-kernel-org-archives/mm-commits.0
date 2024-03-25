Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F8656B68
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 20:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711397733; cv=none; b=rlZ3BhiqZTiorJplep9xhIRR1/bkyfLl4oytz4YdHjaJJPpNUUiLETSui8ETS32NfQJFDZkb5GSOg5GT7W+vofPbXaccVdp+/YaavkqnUns8UKmS/6/3UFpldNUVp+6tYOaQ1I0IC0PLYewaCLTE/VpWPheUNBCqzQ24ZYzL2v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711397733; c=relaxed/simple;
	bh=FQyeG9R53clXHttGWrptMYcfpshSoVnCUGgWU6BdSFU=;
	h=Date:To:From:Subject:Message-Id; b=Ya9L1e0OlJnNTvlUcOmLzwKYbo5OPFLxf329ZJFJidWdDGC7ltZcJ/CBGRLCztSq6DJZQ2Dq3ofbcCtU47b0iP7PunzeUIagI4iVsR3aJ3/OpI+2IJA12kZNgGHttUHFSzTKUyn4l3Demn4UkukkkMiFnhoDk5qwJ/o2VzSGPqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2TN2EqXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2TN2EqXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576C3C433C7;
	Mon, 25 Mar 2024 20:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711397732;
	bh=FQyeG9R53clXHttGWrptMYcfpshSoVnCUGgWU6BdSFU=;
	h=Date:To:From:Subject:From;
	b=2TN2EqXKAy6AE1yvfk9+FnrvSa6KynHmRhNlJfiOHNsrSSj9IS9fzNx/jr2GEgwZP
	 AhTHHhrnsD32Ozy4LEvNO36YRn4Wn0fKi1UpDNFDCr+mpXJq9jWNBr7vkpvHL5rZCw
	 tzyzFK1fjbhA+g+1ntk7KfBaEAwDuCNtZP9BD8Cs=
Date: Mon, 25 Mar 2024 13:15:31 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingo@kernel.org,luto@kernel.org,fei1.li@intel.com,david@redhat.com,dave.hansen@linux.intel.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-follow_pfn.patch added to mm-unstable branch
Message-Id: <20240325201532.576C3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove follow_pfn
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-follow_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-follow_pfn.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove follow_pfn
Date: Mon, 25 Mar 2024 07:45:41 +0800

Remove follow_pfn now that the last user is gone.

Link: https://lkml.kernel.org/r/20240324234542.2038726-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fei Li <fei1.li@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/memory.c        |   36 ++----------------------------------
 mm/nommu.c         |   21 ---------------------
 3 files changed, 2 insertions(+), 57 deletions(-)

--- a/include/linux/mm.h~mm-remove-follow_pfn
+++ a/include/linux/mm.h
@@ -2424,8 +2424,6 @@ int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp);
-int follow_pfn(struct vm_area_struct *vma, unsigned long address,
-	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
 		unsigned int flags, unsigned long *prot, resource_size_t *phys);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
--- a/mm/memory.c~mm-remove-follow_pfn
+++ a/mm/memory.c
@@ -5884,8 +5884,8 @@ int __pmd_alloc(struct mm_struct *mm, pu
  * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
  * should be taken for read.
  *
- * KVM uses this function.  While it is arguably less bad than ``follow_pfn``,
- * it is not a good general-purpose API.
+ * KVM uses this function.  While it is arguably less bad than the historic
+ * ``follow_pfn``, it is not a good general-purpose API.
  *
  * Return: zero on success, -ve otherwise.
  */
@@ -5927,38 +5927,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(follow_pte);
 
-/**
- * follow_pfn - look up PFN at a user virtual address
- * @vma: memory mapping
- * @address: user virtual address
- * @pfn: location to store found PFN
- *
- * Only IO mappings and raw PFN mappings are allowed.
- *
- * This function does not allow the caller to read the permissions
- * of the PTE.  Do not use it.
- *
- * Return: zero and the pfn at @pfn on success, -ve otherwise.
- */
-int follow_pfn(struct vm_area_struct *vma, unsigned long address,
-	unsigned long *pfn)
-{
-	int ret = -EINVAL;
-	spinlock_t *ptl;
-	pte_t *ptep;
-
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-		return ret;
-
-	ret = follow_pte(vma->vm_mm, address, &ptep, &ptl);
-	if (ret)
-		return ret;
-	*pfn = pte_pfn(ptep_get(ptep));
-	pte_unmap_unlock(ptep, ptl);
-	return 0;
-}
-EXPORT_SYMBOL(follow_pfn);
-
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 int follow_phys(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags,
--- a/mm/nommu.c~mm-remove-follow_pfn
+++ a/mm/nommu.c
@@ -110,27 +110,6 @@ unsigned int kobjsize(const void *objp)
 	return page_size(page);
 }
 
-/**
- * follow_pfn - look up PFN at a user virtual address
- * @vma: memory mapping
- * @address: user virtual address
- * @pfn: location to store found PFN
- *
- * Only IO mappings and raw PFN mappings are allowed.
- *
- * Returns zero and the pfn at @pfn on success, -ve otherwise.
- */
-int follow_pfn(struct vm_area_struct *vma, unsigned long address,
-	unsigned long *pfn)
-{
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-		return -EINVAL;
-
-	*pfn = address >> PAGE_SHIFT;
-	return 0;
-}
-EXPORT_SYMBOL(follow_pfn);
-
 void vfree(const void *addr)
 {
 	kfree(addr);
_

Patches currently in -mm which might be from hch@lst.de are

virt-acrn-stop-using-follow_pfn.patch
mm-remove-follow_pfn.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec.patch


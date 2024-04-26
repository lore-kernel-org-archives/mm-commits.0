Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1008C7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104008; cv=none; b=Ryon1pOlt0pwlDvDJuIQT4Km8JyWSJcE1i5CoB1zCX3VP1s6XCxQnkFTNzz54thcTulh9A02ys/Q/tEwoL5XW5JrgZ9j7Jj9ud/I3HN0U+3okyZemkNBjp6AX7qjDXsTe636BEwawacQADflYLAWTebLLlDXDRg4LPUJDoYoD8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104008; c=relaxed/simple;
	bh=In6SEooMspvwgJno1CmrOir3QzCkUJEvkkqxdYAeC8s=;
	h=Date:To:From:Subject:Message-Id; b=NnTpdEJjF8ET4cEUre0cdmD0qSTApokvtBam/KpsvAF1XZVICacSYKrmISa9xTKKDzb/GJrQVYqwKRy+WySqNh52+mNUISgTLTn2bdTl1t6KaCDIaAz4JR1Luje6JkapeTK08F1uCAeqExN7NVRQFKlIdcy7NdMGVMilbMelxFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oaauIbj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oaauIbj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0FBC116B1;
	Fri, 26 Apr 2024 04:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104007;
	bh=In6SEooMspvwgJno1CmrOir3QzCkUJEvkkqxdYAeC8s=;
	h=Date:To:From:Subject:From;
	b=oaauIbj6KKBOgYcIIP9fMVlMxAttZCDJPd/chdK7R3Z7VZjz9afWeLgshgncYzhFL
	 LnvjxZ2sRLKxQFAHohnr1YByCIifMvxf0I0IyIQxcryhHtcv1KPrTqWvoEdVEqimdS
	 wcSvPWfKyFGLPOeTAMd9EQ3DwUT9viRbLThZHBpo=
Date: Thu, 25 Apr 2024 21:00:07 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,nathan@kernel.org,mingo@kernel.org,luto@kernel.org,fei1.li@intel.com,david@redhat.com,dave.hansen@linux.intel.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-follow_pfn.patch removed from -mm tree
Message-Id: <20240426040007.DB0FBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove follow_pfn
has been removed from the -mm tree.  Its filename was
     mm-remove-follow_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Nathan Chancellor <nathan@kernel.org>
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2356E7D3FA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104009; cv=none; b=S9g9ydsAqIoHeM+buFcaAvkqQ9q/Uitu0CadWAs9ywqOqduzsk4+uuIRXmWMMaFU/h01DN5JFhCq0cxlHyyCZRgFGCh3NPjiAVYNWZT+WZnnnWM+IOh6er5iJFOBOq26UeC2lLtZgkkHkgNXu2TeBcuA5jdbnVT6Le4xpXMXYjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104009; c=relaxed/simple;
	bh=+nkmquE9IgJU3YapFYjsEZyHLS9FBDk4OOXnEm1Th0k=;
	h=Date:To:From:Subject:Message-Id; b=Bu+vno4kle43X9f+9JPMxIbGj5yNNhnVSFkE3c1tRPOZljH2xFntY0UNGvWyDQR2GF3ARunA+24xUIeLOmwjAVj1IB0MU4w6/c7uBwH2bQg7TbRExfNK0tbW47pwG+rfR5Lj2dAcFf1mCW/sDq1KwksSgcaSE84+bV8cspLDkOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rg3VnKWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rg3VnKWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4EEC113CD;
	Fri, 26 Apr 2024 04:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104009;
	bh=+nkmquE9IgJU3YapFYjsEZyHLS9FBDk4OOXnEm1Th0k=;
	h=Date:To:From:Subject:From;
	b=Rg3VnKWM6C97aiXQdvipA6YGPeGgQhLTtynlw0bM2opm5aruvypvYFKQ/7+2GwO4l
	 DU6mQigeNr0Yo0GrqoTbjQCg+JWWuPXQavT+EgaW9Rh1ClzUgq0FKeqAo5uSfVY1PR
	 9JFB/MJUkH2BtkPZZPkCJtyJBRjl5BSGTelT8BcM=
Date: Thu, 25 Apr 2024 21:00:08 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,nathan@kernel.org,mingo@kernel.org,luto@kernel.org,fei1.li@intel.com,david@redhat.com,dave.hansen@linux.intel.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-follow_phys-to-arch-x86-mm-pat-memtypec.patch removed from -mm tree
Message-Id: <20240426040008.EA4EEC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move follow_phys to arch/x86/mm/pat/memtype.c
has been removed from the -mm tree.  Its filename was
     mm-move-follow_phys-to-arch-x86-mm-pat-memtypec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: move follow_phys to arch/x86/mm/pat/memtype.c
Date: Mon, 25 Mar 2024 07:45:42 +0800

follow_phys is only used by two callers in arch/x86/mm/pat/memtype.c. 
Move it there and hardcode the two arguments that get the same values
passed by both callers.

[david@redhat.com: conflict resolutions]
Link: https://lkml.kernel.org/r/20240403212131.929421-4-david@redhat.com
Link: https://lkml.kernel.org/r/20240324234542.2038726-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fei Li <fei1.li@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |   29 ++++++++++++++++++++++++++++-
 include/linux/mm.h        |    2 --
 mm/memory.c               |   32 --------------------------------
 3 files changed, 28 insertions(+), 35 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~mm-move-follow_phys-to-arch-x86-mm-pat-memtypec
+++ a/arch/x86/mm/pat/memtype.c
@@ -39,6 +39,7 @@
 #include <linux/pfn_t.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <linux/fs.h>
 #include <linux/rbtree.h>
 
@@ -947,6 +948,32 @@ static void free_pfn_range(u64 paddr, un
 		memtype_free(paddr, paddr + size);
 }
 
+static int follow_phys(struct vm_area_struct *vma, unsigned long *prot,
+		resource_size_t *phys)
+{
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		return -EINVAL;
+
+	if (follow_pte(vma->vm_mm, vma->vm_start, &ptep, &ptl))
+		return -EINVAL;
+
+	pte = ptep_get(ptep);
+
+	/* Never return PFNs of anon folios in COW mappings. */
+	if (vm_normal_folio(vma, vma->vm_start, pte)) {
+		pte_unmap_unlock(ptep, ptl);
+		return -EINVAL;
+	}
+
+	*prot = pgprot_val(pte_pgprot(pte));
+	*phys = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
+	pte_unmap_unlock(ptep, ptl);
+	return 0;
+}
+
 static int get_pat_info(struct vm_area_struct *vma, resource_size_t *paddr,
 		pgprot_t *pgprot)
 {
@@ -964,7 +991,7 @@ static int get_pat_info(struct vm_area_s
 	 * detect the PFN. If we need the cachemode as well, we're out of luck
 	 * for now and have to fail fork().
 	 */
-	if (!follow_phys(vma, vma->vm_start, 0, &prot, paddr)) {
+	if (!follow_phys(vma, &prot, paddr)) {
 		if (pgprot)
 			*pgprot = __pgprot(prot);
 		return 0;
--- a/include/linux/mm.h~mm-move-follow_phys-to-arch-x86-mm-pat-memtypec
+++ a/include/linux/mm.h
@@ -2424,8 +2424,6 @@ int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp);
-int follow_phys(struct vm_area_struct *vma, unsigned long address,
-		unsigned int flags, unsigned long *prot, resource_size_t *phys);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
--- a/mm/memory.c~mm-move-follow_phys-to-arch-x86-mm-pat-memtypec
+++ a/mm/memory.c
@@ -5928,38 +5928,6 @@ out:
 EXPORT_SYMBOL_GPL(follow_pte);
 
 #ifdef CONFIG_HAVE_IOREMAP_PROT
-int follow_phys(struct vm_area_struct *vma,
-		unsigned long address, unsigned int flags,
-		unsigned long *prot, resource_size_t *phys)
-{
-	int ret = -EINVAL;
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
-
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-		goto out;
-
-	if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
-		goto out;
-	pte = ptep_get(ptep);
-
-	/* Never return PFNs of anon folios in COW mappings. */
-	if (vm_normal_folio(vma, address, pte))
-		goto unlock;
-
-	if ((flags & FOLL_WRITE) && !pte_write(pte))
-		goto unlock;
-
-	*prot = pgprot_val(pte_pgprot(pte));
-	*phys = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
-
-	ret = 0;
-unlock:
-	pte_unmap_unlock(ptep, ptl);
-out:
-	return ret;
-}
-
 /**
  * generic_access_phys - generic implementation for iomem mmap access
  * @vma: the vma to access
_

Patches currently in -mm which might be from hch@lst.de are



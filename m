Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5D15CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956992; cv=none; b=RBVY5tW6Gzd7cMNRxOoMlWo9cHJSwoXVho/gxuMxxD1n2agvbxGL1/bGc4wdpeIIK/7CuMqDNEvk6Uy9NoJFyhxM+wfrSNY7uiEihea7Fu8O5lx2tXr02VmmZ6SybsnABi8I5VyqvdW0z7sdiSV1Ay71dWk6cA0w5YvM+iuPqLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956992; c=relaxed/simple;
	bh=UUP5edExyrTyb9NDpvWqVTAAWNuFHGgv5eIXfqAWA6A=;
	h=Date:To:From:Subject:Message-Id; b=QE0GYzBWn3KWjWdcwlUpUDqfdEa71B8UExgvSMmjEjETD+0tfnwmjOsLPDc9f4D/BMPRYKfs291rk6ti1rb4VgtGOQzE0EhCV3b7I3UWkc+Vkt0ZZzr35cZiw2f7YzqQiXe0BahwTVvfGWSaMcpBFD9SSfLotJ27YJW1N6tas1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ETxd/eaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ETxd/eaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4C5C113CC;
	Mon,  6 May 2024 00:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956992;
	bh=UUP5edExyrTyb9NDpvWqVTAAWNuFHGgv5eIXfqAWA6A=;
	h=Date:To:From:Subject:From;
	b=ETxd/eaZ1FUiOwm6801mdZ5mKko8/p3dN3lH176o7j5mVyYgcAJgBYaM9/vZ4N3Hf
	 dJmjfUICdkW3Y2nyO6GFivu7T29Ocybhahlqo0m6aYclUtptBL8iBw1Kwq4Bfhq4tX
	 wSlIWpkWYogy/kJa9iQaAqTWaXLnGETmTFoCWWr8=
Date: Sun, 05 May 2024 17:56:31 -0700
To: mm-commits@vger.kernel.org,yonghua.huang@intel.com,seanjc@google.com,pbonzini@redhat.com,mingo@redhat.com,hch@lst.de,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,fei1.li@intel.com,alex.williamson@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-vma-instead-of-mm-to-follow_pte.patch removed from -mm tree
Message-Id: <20240506005632.4D4C5C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass VMA instead of MM to follow_pte()
has been removed from the -mm tree.  Its filename was
     mm-pass-vma-instead-of-mm-to-follow_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: pass VMA instead of MM to follow_pte()
Date: Wed, 10 Apr 2024 17:55:26 +0200

... and centralize the VM_IO/VM_PFNMAP sanity check in there. We'll
now also perform these sanity checks for direct follow_pte()
invocations.

For generic_access_phys(), we might now check multiple times: nothing to
worry about, really.

Link: https://lkml.kernel.org/r/20240410155527.474777-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Sean Christopherson <seanjc@google.com>	[KVM]
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Fei Li <fei1.li@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Yonghua Huang <yonghua.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/pci/pci_mmio.c        |    4 ++--
 arch/x86/mm/pat/memtype.c       |    5 +----
 drivers/vfio/vfio_iommu_type1.c |    4 ++--
 drivers/virt/acrn/mm.c          |    3 +--
 include/linux/mm.h              |    2 +-
 mm/memory.c                     |   15 ++++++++-------
 virt/kvm/kvm_main.c             |    4 ++--
 7 files changed, 17 insertions(+), 20 deletions(-)

--- a/arch/s390/pci/pci_mmio.c~mm-pass-vma-instead-of-mm-to-follow_pte
+++ a/arch/s390/pci/pci_mmio.c
@@ -169,7 +169,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, uns
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
+	ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
@@ -308,7 +308,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsi
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
+	ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
--- a/arch/x86/mm/pat/memtype.c~mm-pass-vma-instead-of-mm-to-follow_pte
+++ a/arch/x86/mm/pat/memtype.c
@@ -954,10 +954,7 @@ static int follow_phys(struct vm_area_st
 	pte_t *ptep, pte;
 	spinlock_t *ptl;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-		return -EINVAL;
-
-	if (follow_pte(vma->vm_mm, vma->vm_start, &ptep, &ptl))
+	if (follow_pte(vma, vma->vm_start, &ptep, &ptl))
 		return -EINVAL;
 
 	pte = ptep_get(ptep);
--- a/drivers/vfio/vfio_iommu_type1.c~mm-pass-vma-instead-of-mm-to-follow_pte
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -518,7 +518,7 @@ static int follow_fault_pfn(struct vm_ar
 	spinlock_t *ptl;
 	int ret;
 
-	ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
+	ret = follow_pte(vma, vaddr, &ptep, &ptl);
 	if (ret) {
 		bool unlocked = false;
 
@@ -532,7 +532,7 @@ static int follow_fault_pfn(struct vm_ar
 		if (ret)
 			return ret;
 
-		ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
+		ret = follow_pte(vma, vaddr, &ptep, &ptl);
 		if (ret)
 			return ret;
 	}
--- a/drivers/virt/acrn/mm.c~mm-pass-vma-instead-of-mm-to-follow_pte
+++ a/drivers/virt/acrn/mm.c
@@ -187,8 +187,7 @@ int acrn_vm_ram_map(struct acrn_vm *vm,
 		}
 
 		for (i = 0; i < nr_pages; i++) {
-			ret = follow_pte(vma->vm_mm,
-					 memmap->vma_base + i * PAGE_SIZE,
+			ret = follow_pte(vma, memmap->vma_base + i * PAGE_SIZE,
 					 &ptep, &ptl);
 			if (ret)
 				break;
--- a/include/linux/mm.h~mm-pass-vma-instead-of-mm-to-follow_pte
+++ a/include/linux/mm.h
@@ -2420,7 +2420,7 @@ void free_pgd_range(struct mmu_gather *t
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_pte(struct mm_struct *mm, unsigned long address,
+int follow_pte(struct vm_area_struct *vma, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
--- a/mm/memory.c~mm-pass-vma-instead-of-mm-to-follow_pte
+++ a/mm/memory.c
@@ -5926,7 +5926,7 @@ int __pmd_alloc(struct mm_struct *mm, pu
 
 /**
  * follow_pte - look up PTE at a user virtual address
- * @mm: the mm_struct of the target address space
+ * @vma: the memory mapping
  * @address: user virtual address
  * @ptepp: location to store found PTE
  * @ptlp: location to store the lock for the PTE
@@ -5945,15 +5945,19 @@ int __pmd_alloc(struct mm_struct *mm, pu
  *
  * Return: zero on success, -ve otherwise.
  */
-int follow_pte(struct mm_struct *mm, unsigned long address,
+int follow_pte(struct vm_area_struct *vma, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *ptep;
 
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		goto out;
+
 	pgd = pgd_offset(mm, address);
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		goto out;
@@ -6007,11 +6011,8 @@ int generic_access_phys(struct vm_area_s
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-		return -EINVAL;
-
 retry:
-	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
+	if (follow_pte(vma, addr, &ptep, &ptl))
 		return -EINVAL;
 	pte = ptep_get(ptep);
 	pte_unmap_unlock(ptep, ptl);
@@ -6026,7 +6027,7 @@ retry:
 	if (!maddr)
 		return -ENOMEM;
 
-	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
+	if (follow_pte(vma, addr, &ptep, &ptl))
 		goto out_unmap;
 
 	if (!pte_same(pte, ptep_get(ptep))) {
--- a/virt/kvm/kvm_main.c~mm-pass-vma-instead-of-mm-to-follow_pte
+++ a/virt/kvm/kvm_main.c
@@ -2902,7 +2902,7 @@ static int hva_to_pfn_remapped(struct vm
 	spinlock_t *ptl;
 	int r;
 
-	r = follow_pte(vma->vm_mm, addr, &ptep, &ptl);
+	r = follow_pte(vma, addr, &ptep, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -2917,7 +2917,7 @@ static int hva_to_pfn_remapped(struct vm
 		if (r)
 			return r;
 
-		r = follow_pte(vma->vm_mm, addr, &ptep, &ptl);
+		r = follow_pte(vma, addr, &ptep, &ptl);
 		if (r)
 			return r;
 	}
_

Patches currently in -mm which might be from david@redhat.com are



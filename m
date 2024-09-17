Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D91B14C5B0
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560483; cv=none; b=UM02cUX9alIIBEbi0vSAyMOaci1iL3Ks4xeA9venqKb3HpaVIw9RCniKQjNvGJw+EiG0KFeQxx6dP+rdyodm0V2ifiRn6ZUQJaX/x40GZHwE2H2YSM1288DgUpEeaRpAcj6LJvycsBvj81AQbbnwI9mTb1iutvyzHpEraONCwng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560483; c=relaxed/simple;
	bh=uuE95Alk61KZYrUuEtPjT+rVstqz0sN3TDRmZX2o/V4=;
	h=Date:To:From:Subject:Message-Id; b=RCOLdEp3D9+QOQefroM4elyYTdBLgatHZyjSFrRRguGfA1kQlnI2HoXwJtnr+Ep5oaBrw8bMp9pHPNl/s8Yn9sQeifZW2i6hJzimXdNAN9YazynmJezeThXPiKkBs1jGJf3CWjPOd1u/5issGOUVZtjfH3z6VOcxy/aegHTvIN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FW5BC176; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FW5BC176"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F963C4CEC6;
	Tue, 17 Sep 2024 08:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560483;
	bh=uuE95Alk61KZYrUuEtPjT+rVstqz0sN3TDRmZX2o/V4=;
	h=Date:To:From:Subject:From;
	b=FW5BC1769RIU8t9jZVMYBbD2fq8gGiykjYaTU1CssD2YNSySqIKif7X+GjncbiC4v
	 SZXihqgIN0Reb7/2TR2qOe92WkGaIm6amRsNb8r+klt8Ig27rp7mC20NhaoSg8gUeQ
	 fHjB5CDMa11WEip0E7SGqbEv2l14tSgI4+QSwy08=
Date: Tue, 17 Sep 2024 01:08:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-new-follow_pfnmap-api.patch removed from -mm tree
Message-Id: <20240917080802.9F963C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: new follow_pfnmap API
has been removed from the -mm tree.  Its filename was
     mm-new-follow_pfnmap-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: new follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:43 -0400

Introduce a pair of APIs to follow pfn mappings to get entry information. 
It's very similar to what follow_pte() does before, but different in that
it recognizes huge pfn mappings.

Link: https://lkml.kernel.org/r/20240826204353.2228736-10-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   31 ++++++++
 mm/memory.c        |  150 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+)

--- a/include/linux/mm.h~mm-new-follow_pfnmap-api
+++ a/include/linux/mm.h
@@ -2373,6 +2373,37 @@ int follow_pte(struct vm_area_struct *vm
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
+struct follow_pfnmap_args {
+	/**
+	 * Inputs:
+	 * @vma: Pointer to @vm_area_struct struct
+	 * @address: the virtual address to walk
+	 */
+	struct vm_area_struct *vma;
+	unsigned long address;
+	/**
+	 * Internals:
+	 *
+	 * The caller shouldn't touch any of these.
+	 */
+	spinlock_t *lock;
+	pte_t *ptep;
+	/**
+	 * Outputs:
+	 *
+	 * @pfn: the PFN of the address
+	 * @pgprot: the pgprot_t of the mapping
+	 * @writable: whether the mapping is writable
+	 * @special: whether the mapping is a special mapping (real PFN maps)
+	 */
+	unsigned long pfn;
+	pgprot_t pgprot;
+	bool writable;
+	bool special;
+};
+int follow_pfnmap_start(struct follow_pfnmap_args *args);
+void follow_pfnmap_end(struct follow_pfnmap_args *args);
+
 extern void truncate_pagecache(struct inode *inode, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to);
--- a/mm/memory.c~mm-new-follow_pfnmap-api
+++ a/mm/memory.c
@@ -6172,6 +6172,156 @@ out:
 }
 EXPORT_SYMBOL_GPL(follow_pte);
 
+static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
+				     spinlock_t *lock, pte_t *ptep,
+				     pgprot_t pgprot, unsigned long pfn_base,
+				     unsigned long addr_mask, bool writable,
+				     bool special)
+{
+	args->lock = lock;
+	args->ptep = ptep;
+	args->pfn = pfn_base + ((args->address & ~addr_mask) >> PAGE_SHIFT);
+	args->pgprot = pgprot;
+	args->writable = writable;
+	args->special = special;
+}
+
+static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
+{
+#ifdef CONFIG_LOCKDEP
+	struct address_space *mapping = vma->vm_file->f_mapping;
+
+	if (mapping)
+		lockdep_assert(lockdep_is_held(&vma->vm_file->f_mapping->i_mmap_rwsem) ||
+			       lockdep_is_held(&vma->vm_mm->mmap_lock));
+	else
+		lockdep_assert(lockdep_is_held(&vma->vm_mm->mmap_lock));
+#endif
+}
+
+/**
+ * follow_pfnmap_start() - Look up a pfn mapping at a user virtual address
+ * @args: Pointer to struct @follow_pfnmap_args
+ *
+ * The caller needs to setup args->vma and args->address to point to the
+ * virtual address as the target of such lookup.  On a successful return,
+ * the results will be put into other output fields.
+ *
+ * After the caller finished using the fields, the caller must invoke
+ * another follow_pfnmap_end() to proper releases the locks and resources
+ * of such look up request.
+ *
+ * During the start() and end() calls, the results in @args will be valid
+ * as proper locks will be held.  After the end() is called, all the fields
+ * in @follow_pfnmap_args will be invalid to be further accessed.  Further
+ * use of such information after end() may require proper synchronizations
+ * by the caller with page table updates, otherwise it can create a
+ * security bug.
+ *
+ * If the PTE maps a refcounted page, callers are responsible to protect
+ * against invalidation with MMU notifiers; otherwise access to the PFN at
+ * a later point in time can trigger use-after-free.
+ *
+ * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
+ * should be taken for read, and the mmap semaphore cannot be released
+ * before the end() is invoked.
+ *
+ * This function must not be used to modify PTE content.
+ *
+ * Return: zero on success, negative otherwise.
+ */
+int follow_pfnmap_start(struct follow_pfnmap_args *args)
+{
+	struct vm_area_struct *vma = args->vma;
+	unsigned long address = args->address;
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *lock;
+	pgd_t *pgdp;
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
+	pte_t *ptep, pte;
+
+	pfnmap_lockdep_assert(vma);
+
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+		goto out;
+
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		goto out;
+retry:
+	pgdp = pgd_offset(mm, address);
+	if (pgd_none(*pgdp) || unlikely(pgd_bad(*pgdp)))
+		goto out;
+
+	p4dp = p4d_offset(pgdp, address);
+	p4d = READ_ONCE(*p4dp);
+	if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
+		goto out;
+
+	pudp = pud_offset(p4dp, address);
+	pud = READ_ONCE(*pudp);
+	if (pud_none(pud))
+		goto out;
+	if (pud_leaf(pud)) {
+		lock = pud_lock(mm, pudp);
+		if (!unlikely(pud_leaf(pud))) {
+			spin_unlock(lock);
+			goto retry;
+		}
+		pfnmap_args_setup(args, lock, NULL, pud_pgprot(pud),
+				  pud_pfn(pud), PUD_MASK, pud_write(pud),
+				  pud_special(pud));
+		return 0;
+	}
+
+	pmdp = pmd_offset(pudp, address);
+	pmd = pmdp_get_lockless(pmdp);
+	if (pmd_leaf(pmd)) {
+		lock = pmd_lock(mm, pmdp);
+		if (!unlikely(pmd_leaf(pmd))) {
+			spin_unlock(lock);
+			goto retry;
+		}
+		pfnmap_args_setup(args, lock, NULL, pmd_pgprot(pmd),
+				  pmd_pfn(pmd), PMD_MASK, pmd_write(pmd),
+				  pmd_special(pmd));
+		return 0;
+	}
+
+	ptep = pte_offset_map_lock(mm, pmdp, address, &lock);
+	if (!ptep)
+		goto out;
+	pte = ptep_get(ptep);
+	if (!pte_present(pte))
+		goto unlock;
+	pfnmap_args_setup(args, lock, ptep, pte_pgprot(pte),
+			  pte_pfn(pte), PAGE_MASK, pte_write(pte),
+			  pte_special(pte));
+	return 0;
+unlock:
+	pte_unmap_unlock(ptep, lock);
+out:
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(follow_pfnmap_start);
+
+/**
+ * follow_pfnmap_end(): End a follow_pfnmap_start() process
+ * @args: Pointer to struct @follow_pfnmap_args
+ *
+ * Must be used in pair of follow_pfnmap_start().  See the start() function
+ * above for more information.
+ */
+void follow_pfnmap_end(struct follow_pfnmap_args *args)
+{
+	if (args->lock)
+		spin_unlock(args->lock);
+	if (args->ptep)
+		pte_unmap(args->ptep);
+}
+EXPORT_SYMBOL_GPL(follow_pfnmap_end);
+
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 /**
  * generic_access_phys - generic implementation for iomem mmap access
_

Patches currently in -mm which might be from peterx@redhat.com are



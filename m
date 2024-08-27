Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C491C8FB0
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802742; cv=none; b=d+BFvL78e+Y1z4KULyt5mWJZWItjnYDWi0XDkIGwvJAdbsL308DVQLlKirmgNlSfkETN8B01s7tZh//XBidsnDeOqLJsySoBtd0uNAk7nHU9XTXG/j7tiOCd6puOazeJgom+VMt4c2r+FV6kPXFDnnREsyrr7A5NJMObIiJde+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802742; c=relaxed/simple;
	bh=ef8/k8Sznf2J8nijeeKxk9mZ9yDBsPHziwBpJpoxOKI=;
	h=Date:To:From:Subject:Message-Id; b=R8a2M1x/lK03I2x2z+qtB0eCUe1tpUtmaOr+XrgfbBN5+OACuVYoTDStqFqhU+vRe1/g6fjDOIu4mRoWu7KsITEfOjhqvXIxwhxpV+MFhA47DEtpp6ZBNf/n3NKVHTLIg1ViYftxBte4TSJhXBC60ekxVlHDWFnOn37dB2P2mzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mTIGl0Do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mTIGl0Do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ED5C4FF73;
	Tue, 27 Aug 2024 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802742;
	bh=ef8/k8Sznf2J8nijeeKxk9mZ9yDBsPHziwBpJpoxOKI=;
	h=Date:To:From:Subject:From;
	b=mTIGl0DoxtSf8ufPZhOvezbqu7wVmzMmAErpev6amtfXnrYcK8JQ/xfArqGsYhLGt
	 8vZl/bSeI/ylDhcUM/SK8PH3caMWcu6+WXRgDwrYFGEpmHIcKtIHNbrRSvNKI64Bb9
	 IfEJYitADdNoQBumAvLfEDAqcdvxyBCLKXzUkVK8=
Date: Tue, 27 Aug 2024 16:52:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-new-follow_pfnmap-api.patch added to mm-unstable branch
Message-Id: <20240827235222.19ED5C4FF73@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: new follow_pfnmap API
has been added to the -mm mm-unstable branch.  Its filename is
     mm-new-follow_pfnmap-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-new-follow_pfnmap-api.patch

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
@@ -6369,6 +6369,156 @@ out:
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

mm-dax-dump-start-address-in-fault-handler.patch
mm-mprotect-push-mmu-notifier-to-puds.patch
mm-powerpc-add-missing-pud-helpers.patch
mm-x86-make-pud_leaf-only-care-about-pse-bit.patch
mm-x86-implement-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch
mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud.patch
mm-drop-is_huge_zero_pud.patch
mm-mark-special-bits-for-huge-pfn-mappings-when-inject.patch
mm-allow-thp-orders-for-pfnmaps.patch
mm-gup-detect-huge-pfnmap-entries-in-gup-fast.patch
mm-pagewalk-check-pfnmap-for-folio_walk_start.patch
mm-fork-accept-huge-pfnmap-entries.patch
mm-always-define-pxx_pgprot.patch
mm-new-follow_pfnmap-api.patch
kvm-use-follow_pfnmap-api.patch
s390-pci_mmio-use-follow_pfnmap-api.patch
mm-x86-pat-use-the-new-follow_pfnmap-api.patch
vfio-use-the-new-follow_pfnmap-api.patch
acrn-use-the-new-follow_pfnmap-api.patch
mm-access_process_vm-use-the-new-follow_pfnmap-api.patch
mm-remove-follow_pte.patch
mm-x86-support-large-pfn-mappings.patch
mm-arm64-support-large-pfn-mappings.patch


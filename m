From: akpm@linux-foundation.org
Subject: + mm-add-vmf_insert_pfn_pmd.patch added to -mm tree
Date: Mon, 13 Jul 2015 14:32:05 -0700
Message-ID: <55a42e55.XDckuHHJO9uBFB9N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbbGMVcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dhillf@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add vmf_insert_pfn_pmd()
has been added to the -mm tree.  Its filename is
     mm-add-vmf_insert_pfn_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-vmf_insert_pfn_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-vmf_insert_pfn_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mm: add vmf_insert_pfn_pmd()

Similar to vm_insert_pfn(), but for PMDs rather than PTEs.  The 'vmf_'
prefix instead of 'vm_' prefix is intended to indicate that it returns a
VMF_ value rather than an errno (which would only have to be converted
into a VMF_ value anyway).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +
 mm/huge_memory.c        |   43 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff -puN include/linux/huge_mm.h~mm-add-vmf_insert_pfn_pmd include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-add-vmf_insert_pfn_pmd
+++ a/include/linux/huge_mm.h
@@ -33,6 +33,8 @@ extern int move_huge_pmd(struct vm_area_
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, pgprot_t newprot,
 			int prot_numa);
+int vmf_insert_pfn_pmd(struct vm_area_struct *, unsigned long addr, pmd_t *,
+			unsigned long pfn, bool write);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff -puN mm/huge_memory.c~mm-add-vmf_insert_pfn_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-add-vmf_insert_pfn_pmd
+++ a/mm/huge_memory.c
@@ -865,6 +865,49 @@ int do_huge_pmd_anonymous_page(struct mm
 					    flags);
 }
 
+static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmd, unsigned long pfn, pgprot_t prot, bool write)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pmd_t entry;
+	spinlock_t *ptl;
+
+	ptl = pmd_lock(mm, pmd);
+	if (pmd_none(*pmd)) {
+		entry = pmd_mkhuge(pfn_pmd(pfn, prot));
+		if (write) {
+			entry = pmd_mkyoung(pmd_mkdirty(entry));
+			entry = maybe_pmd_mkwrite(entry, vma);
+		}
+		set_pmd_at(mm, addr, pmd, entry);
+		update_mmu_cache_pmd(vma, addr, pmd);
+	}
+	spin_unlock(ptl);
+	return VM_FAULT_NOPAGE;
+}
+
+int vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
+			pmd_t *pmd, unsigned long pfn, bool write)
+{
+	pgprot_t pgprot = vma->vm_page_prot;
+	/*
+	 * If we had pmd_special, we could avoid all these restrictions,
+	 * but we need to be consistent with PTEs and architectures that
+	 * can't support a 'special' bit.
+	 */
+	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
+	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
+						(VM_PFNMAP|VM_MIXEDMAP));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
+	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+	if (track_pfn_insert(vma, &pgprot, pfn))
+		return VM_FAULT_SIGBUS;
+	return insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write);
+}
+
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *vma)
_

Patches currently in -mm which might be from willy@linux.intel.com are

mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch


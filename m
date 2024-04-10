Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47197181BBC
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782854; cv=none; b=Q35R28FK+3WKNfdG04PP2NoELs0N5j4v/ponhuN3DmUGbLBafG3A4816WxmPGuM5icRCw386xQueqiDgWL4cVZflEptwHFI+/ENcNcAyKqefIAN4ZBoiHLrIZFz1wYgd5A9Nl9V0IU8ZOYhUpQkEVNf7lgNBp9La2GVu0jldJtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782854; c=relaxed/simple;
	bh=FW3kPjx1teCN7F7c4u7urLXrYHhkwUHegxQKIhD/GK0=;
	h=Date:To:From:Subject:Message-Id; b=kDe6qjpOFgFNUh8iXISAtXu6pwvuD3AT8LwZcwZ1j+uJZVsInqW/0+Tl8T1EMI/49sDGZBswzVo8oEzgTcuf6uEjw7hORMr+EpV0i7wxsCbm0K4cuim3ab2zf0vERymcFhcbVMHFp6Ktc4Yh+3k6LoK3CHBanuN3fRc61cWRrPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ToGvE7Hi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ToGvE7Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11580C43390;
	Wed, 10 Apr 2024 21:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712782854;
	bh=FW3kPjx1teCN7F7c4u7urLXrYHhkwUHegxQKIhD/GK0=;
	h=Date:To:From:Subject:From;
	b=ToGvE7HiYxbYGsg74256kYgjXgRJ/VSF21t4+ntk+hM7rJXjC8vwu5b091b/f8ctW
	 5F35e74ff+aBv6MaBRFghJjH71YHxiMZMIXJ0SczwRjcu4Qwc5iY17zp25K/KYnWyP
	 aH0OLsBG9o7m0Omh/LZc44kC2BoJbt5QTPgDuuc4=
Date: Wed, 10 Apr 2024 14:00:53 -0700
To: mm-commits@vger.kernel.org,yonghua.huang@intel.com,seanjc@google.com,pbonzini@redhat.com,mingo@redhat.com,hch@lst.de,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,fei1.li@intel.com,alex.williamson@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-follow_pte-improvements.patch added to mm-unstable branch
Message-Id: <20240410210054.11580C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: follow_pte() improvements
has been added to the -mm mm-unstable branch.  Its filename is
     mm-follow_pte-improvements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-follow_pte-improvements.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: follow_pte() improvements
Date: Wed, 10 Apr 2024 17:55:27 +0200

follow_pte() is now our main function to lookup PTEs in VM_PFNMAP/VM_IO
VMAs.  Let's perform some more sanity checks to make this exported
function harder to abuse.

Further, extend the doc a bit, it still focuses on the KVM use case with
MMU notifiers.  Drop the KVM+follow_pfn() comment, follow_pfn() is no
more, and we have other users nowadays.

Also extend the doc regarding refcounted pages and the interaction with
MMU notifiers.

KVM is one example that uses MMU notifiers and can deal with refcounted
pages properly.  VFIO is one example that doesn't use MMU notifiers, and
to prevent use-after-free, rejects refcounted pages: pfn_valid(pfn) &&
!PageReserved(pfn_to_page(pfn)).  Protection changes are less of a concern
for users like VFIO: the behavior is similar to longterm-pinning a page,
and getting the PTE protection changed afterwards.

The primary concern with refcounted pages is use-after-free, which callers
should be aware of.

Link: https://lkml.kernel.org/r/20240410155527.474777-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Fei Li <fei1.li@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Yonghua Huang <yonghua.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-follow_pte-improvements
+++ a/mm/memory.c
@@ -5933,15 +5933,21 @@ int __pmd_alloc(struct mm_struct *mm, pu
  *
  * On a successful return, the pointer to the PTE is stored in @ptepp;
  * the corresponding lock is taken and its location is stored in @ptlp.
- * The contents of the PTE are only stable until @ptlp is released;
- * any further use, if any, must be protected against invalidation
- * with MMU notifiers.
+ *
+ * The contents of the PTE are only stable until @ptlp is released using
+ * pte_unmap_unlock(). This function will fail if the PTE is non-present.
+ * Present PTEs may include PTEs that map refcounted pages, such as
+ * anonymous folios in COW mappings.
+ *
+ * Callers must be careful when relying on PTE content after
+ * pte_unmap_unlock(). Especially if the PTE maps a refcounted page,
+ * callers must protect against invalidation with MMU notifiers; otherwise
+ * access to the PFN at a later point in time can trigger use-after-free.
  *
  * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
  * should be taken for read.
  *
- * KVM uses this function.  While it is arguably less bad than the historic
- * ``follow_pfn``, it is not a good general-purpose API.
+ * This function must not be used to modify PTE content.
  *
  * Return: zero on success, -ve otherwise.
  */
@@ -5955,6 +5961,10 @@ int follow_pte(struct vm_area_struct *vm
 	pmd_t *pmd;
 	pte_t *ptep;
 
+	mmap_assert_locked(mm);
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+		goto out;
+
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out;
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch
drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch


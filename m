Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB3BBA34
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714156475; cv=none; b=PzI8Gcm3AzYBOY6cDX8ehkreABE5npt6qMs983Y2O7/1EcSshrOJDlUw41IvEhEE4WlCcIW+DFdAVAHjs+dshRo0XWwHaaWH9YPbdj/7V0xBB4qYjFIkAYdMjtfZUSFMuel3CXRpYXpuHvjTnF0Tv7uFRAiMIEUP/KFGHiSW/Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714156475; c=relaxed/simple;
	bh=TjoSCTiENS9rhsV9HOekgpBPrN42lyZlbzs7IAFnESQ=;
	h=Date:To:From:Subject:Message-Id; b=PsTv/vE/R5rid944NMTfGRBj9dY9Fs3k5vp5Sb+1Y/CRlABdD3RfztHExs93Q+OJfR82QEItBWE/mONuHnJY5NelVrsCfc9/GH4Y74BAJ2huCm8+fADXU5vd6f/H46HWBtQlK/EEPkZWNjLLBWtrsHTh5b/jx03QxVC2TaYoTW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eWJyNdVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eWJyNdVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFD7C113CD;
	Fri, 26 Apr 2024 18:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714156475;
	bh=TjoSCTiENS9rhsV9HOekgpBPrN42lyZlbzs7IAFnESQ=;
	h=Date:To:From:Subject:From;
	b=eWJyNdVID3/3HpmV0NU1Hi52DGVK8UwTeYR/6350GQv3M/fBCTbLEjbZzgfofyIaA
	 FvFBjEswNzqINe1pNeDAhqNcNc4DhTEBAZBYg0cIvUZhdE3/1NGOIfZhamNpt8h2iH
	 vtH8Pmm87lec5tUQHp1QkG4MGMxtCXhAfv1ev+Z0=
Date: Fri, 26 Apr 2024 11:34:34 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,jannh@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch added to mm-unstable branch
Message-Id: <20240426183435.0FFD7C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimise vmf_anon_prepare() for VMAs without an anon_vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: optimise vmf_anon_prepare() for VMAs without an anon_vma
Date: Fri, 26 Apr 2024 15:45:03 +0100

If the mmap_lock can be taken for read, we can call __anon_vma_prepare()
while holding it, saving ourselves a trip back through the fault handler.

Link: https://lkml.kernel.org/r/20240426144506.1290619-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma
+++ a/mm/memory.c
@@ -3232,16 +3232,21 @@ static inline vm_fault_t vmf_can_call_fa
 vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	vm_fault_t ret = 0;
 
 	if (likely(vma->anon_vma))
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
+		if (!mmap_read_trylock(vma->vm_mm)) {
+			vma_end_read(vma);
+			return VM_FAULT_RETRY;
+		}
 	}
 	if (__anon_vma_prepare(vma))
-		return VM_FAULT_OOM;
-	return 0;
+		ret = VM_FAULT_OOM;
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
+		mmap_read_unlock(vma->vm_mm);
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch
mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch
mm-delay-the-check-for-a-null-anon_vma.patch
mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch
mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch


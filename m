Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB6ABA34
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 18:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714156473; cv=none; b=WcghdAS0cAZOS0tk2WK7HED74ztzwzEWCGc4vCmHcXHZ3QkKareguDROwCHnJ4cILzW9sHzOM7jBZb/olTBaBd48cWAxHGOOlPfpQZR0u8P4pCvyrykbV2ruBXqdvHSUAwkrCanvOkWfrwyR62QoPQOLv6YQt0oariNl4QsJDQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714156473; c=relaxed/simple;
	bh=QGkCR+3/KrA4mq+NqrChgvAQ7sNe05yNyhR8BWdV4Ig=;
	h=Date:To:From:Subject:Message-Id; b=G4amEzKbrOA9eftt3VGfczgOSkhOEh+m9yYxBMd60YfS/fJp2pMzjB9Zr0lGphJqNrMcN2BitbxQZ5vbVY9Ga5eIzOB+DEevuNgaCW3dkMTfwSgpDDffUHolHotdtyqKJG+QEVxXRNHl+kZAovGAi7gKKAY07SMy9wiEft6bz4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uuaETNPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uuaETNPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6326C113CD;
	Fri, 26 Apr 2024 18:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714156471;
	bh=QGkCR+3/KrA4mq+NqrChgvAQ7sNe05yNyhR8BWdV4Ig=;
	h=Date:To:From:Subject:From;
	b=uuaETNPHchjG7Csam5q4ZbLpQbtKWItwCy4uX/jjL7COPZNgX1mjBhOZjHuOiykV5
	 0FClvs3VpPzjU6Uhhng5GBDmWpVQQbtCnp6BRfXo539dfkmVmPHAgOlj20me8L6+a5
	 /Fo3SCXaWVVtgPCtQW++5PfSuuaMi/vS+ia0Qmp4=
Date: Fri, 26 Apr 2024 11:34:30 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,jannh@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delay-the-check-for-a-null-anon_vma.patch added to mm-unstable branch
Message-Id: <20240426183430.E6326C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: delay the check for a NULL anon_vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-delay-the-check-for-a-null-anon_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delay-the-check-for-a-null-anon_vma.patch

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
Subject: mm: delay the check for a NULL anon_vma
Date: Fri, 26 Apr 2024 15:45:01 +0100

Instead of checking the anon_vma early in the fault path where all page
faults pay the cost, delay it until we know we're going to need the
anon_vma to be filled in.  This will have a slight negative effect on the
first fault in an anonymous VMA, but it shortens every other page fault. 
It also makes the code slightly cleaner as the anon and file backed fault
handling look more similar.

The Intel kernel test bot reports a 3x improvement in vm-scalability
throughput with the small-allocs-mt test.  This is clearly an extreme
situation that won't be replicated in any real-world workload, but it's a
nice win.

https://lore.kernel.org/all/202404261055.c5e24608-oliver.sang@intel.com/

Link: https://lkml.kernel.org/r/20240426144506.1290619-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 mm/memory.c      |   29 ++++++++++++++++++-----------
 2 files changed, 22 insertions(+), 13 deletions(-)

--- a/mm/huge_memory.c~mm-delay-the-check-for-a-null-anon_vma
+++ a/mm/huge_memory.c
@@ -1057,11 +1057,13 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 	gfp_t gfp;
 	struct folio *folio;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	vm_fault_t ret;
 
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return VM_FAULT_FALLBACK;
-	if (unlikely(anon_vma_prepare(vma)))
-		return VM_FAULT_OOM;
+	ret = vmf_anon_prepare(vmf);
+	if (ret)
+		return ret;
 	khugepaged_enter_vma(vma, vma->vm_flags);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
--- a/mm/memory.c~mm-delay-the-check-for-a-null-anon_vma
+++ a/mm/memory.c
@@ -3214,6 +3214,21 @@ static inline vm_fault_t vmf_can_call_fa
 	return VM_FAULT_RETRY;
 }
 
+/**
+ * vmf_anon_prepare - Prepare to handle an anonymous fault.
+ * @vmf: The vm_fault descriptor passed from the fault handler.
+ *
+ * When preparing to insert an anonymous page into a VMA from a
+ * fault handler, call this function rather than anon_vma_prepare().
+ * If this vma does not already have an associated anon_vma and we are
+ * only protected by the per-VMA lock, the caller must retry with the
+ * mmap_lock held.  __anon_vma_prepare() will look at adjacent VMAs to
+ * determine if this VMA can share its anon_vma, and that's not safe to
+ * do with only the per-VMA lock held for this VMA.
+ *
+ * Return: 0 if fault handling can proceed.  Any other value should be
+ * returned to the caller.
+ */
 vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -4439,8 +4454,9 @@ static vm_fault_t do_anonymous_page(stru
 	}
 
 	/* Allocate our own private page. */
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
+	ret = vmf_anon_prepare(vmf);
+	if (ret)
+		return ret;
 	/* Returns NULL on OOM or ERR_PTR(-EAGAIN) if we must retry the fault */
 	folio = alloc_anon_folio(vmf);
 	if (IS_ERR(folio))
@@ -5828,15 +5844,6 @@ retry:
 	if (!vma_start_read(vma))
 		goto inval;
 
-	/*
-	 * find_mergeable_anon_vma uses adjacent vmas which are not locked.
-	 * This check must happen after vma_start_read(); otherwise, a
-	 * concurrent mremap() with MREMAP_DONTUNMAP could dissociate the VMA
-	 * from its anon_vma.
-	 */
-	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma))
-		goto inval_end_read;
-
 	/* Check since vm_start/vm_end might change before we lock the VMA */
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		goto inval_end_read;
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


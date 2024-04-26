Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBEE7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104043; cv=none; b=Vw4FdRQ3EPQYr48P50t2tuLES+MXAAvi3HDiVTdN8dAzPRzLt8pH2vkXXOctVsW8oe/WdNNwF4e0MqCcEeVNvoIHb3ZNFTedA/PvovXMjh4DAg4v3WlIfLp9PdGsiYdlj0aiIdBthQs2eCmszKhBrJHbyDob1M0V7EL7Ne14Xss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104043; c=relaxed/simple;
	bh=mnVNEQ194szNfJUWRFA5+n2tvXC1JCmFSV/1SnUyEf8=;
	h=Date:To:From:Subject:Message-Id; b=opsuG9jzEPWK6vmSVI4OzTLKlrIUFnJsJY0mWPeHe+5pP6p8VNqAgqQ6Ersn5q9NR7nUjLMhLFsZ1xSnw6dfY1/tiQJYrBPLJikhj3XU/DlSsS212Y0tk8aiw2zsmR5yRUIQIxLiqakxx0bjUwjjsHxcUo5ZwAhLxZGDZt/BZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vYAjzU+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vYAjzU+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E88C113CD;
	Fri, 26 Apr 2024 04:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104043;
	bh=mnVNEQ194szNfJUWRFA5+n2tvXC1JCmFSV/1SnUyEf8=;
	h=Date:To:From:Subject:From;
	b=vYAjzU+TRpceznVQYsKilitbwzvbGK123gqJU00+5VPz90fe3DVWMC7KraKIuF9HL
	 KFhB6wSdzE7X13LPEtEr583ioaoSX5l8LHRfowPwze6w3zhaNZhOoSx4+amJXrXL/R
	 LpkET6PTEhmQH8DQxbHFVEVTMKga+WvuaSAYGS+0=
Date: Thu, 25 Apr 2024 21:00:42 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-pmd_folio.patch removed from -mm tree
Message-Id: <20240426040042.E7E88C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add pmd_folio()
has been removed from the -mm tree.  Its filename was
     mm-add-pmd_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add pmd_folio()
Date: Tue, 26 Mar 2024 20:28:23 +0000

Convert directly from a pmd to a folio without going through another
representation first.  For now this is just a slightly shorter way to
write it, but it might end up being more efficient later.

Link: https://lkml.kernel.org/r/20240326202833.523759-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    2 ++
 mm/huge_memory.c        |    6 +++---
 mm/madvise.c            |    2 +-
 mm/mempolicy.c          |    2 +-
 mm/mlock.c              |    2 +-
 mm/userfaultfd.c        |    2 +-
 6 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/linux/pgtable.h~mm-add-pmd_folio
+++ a/include/linux/pgtable.h
@@ -50,6 +50,8 @@
 #define pmd_pgtable(pmd) pmd_page(pmd)
 #endif
 
+#define pmd_folio(pmd) page_folio(pmd_page(pmd))
+
 /*
  * A page table page can be thought of an array like this: pXd_t[PTRS_PER_PxD]
  *
--- a/mm/huge_memory.c~mm-add-pmd_folio
+++ a/mm/huge_memory.c
@@ -1816,7 +1816,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		goto out;
 	}
 
-	folio = pfn_folio(pmd_pfn(orig_pmd));
+	folio = pmd_folio(orig_pmd);
 	/*
 	 * If other processes are mapping this folio, we couldn't discard
 	 * the folio unless they all do MADV_FREE so let's skip the folio.
@@ -2086,7 +2086,7 @@ int change_huge_pmd(struct mmu_gather *t
 		if (pmd_protnone(*pmd))
 			goto unlock;
 
-		folio = page_folio(pmd_page(*pmd));
+		folio = pmd_folio(*pmd);
 		toptier = node_is_toptier(folio_nid(folio));
 		/*
 		 * Skip scanning top tier node if normal numa
@@ -2663,7 +2663,7 @@ void __split_huge_pmd(struct vm_area_str
 		 * It's safe to call pmd_page when folio is set because it's
 		 * guaranteed that pmd is present.
 		 */
-		if (folio && folio != page_folio(pmd_page(*pmd)))
+		if (folio && folio != pmd_folio(*pmd))
 			goto out;
 		__split_huge_pmd_locked(vma, pmd, range.start, freeze);
 	}
--- a/mm/madvise.c~mm-add-pmd_folio
+++ a/mm/madvise.c
@@ -363,7 +363,7 @@ static int madvise_cold_or_pageout_pte_r
 			goto huge_unlock;
 		}
 
-		folio = pfn_folio(pmd_pfn(orig_pmd));
+		folio = pmd_folio(orig_pmd);
 
 		/* Do not interfere with other mappings of this folio */
 		if (folio_likely_mapped_shared(folio))
--- a/mm/mempolicy.c~mm-add-pmd_folio
+++ a/mm/mempolicy.c
@@ -509,7 +509,7 @@ static void queue_folios_pmd(pmd_t *pmd,
 		qp->nr_failed++;
 		return;
 	}
-	folio = pfn_folio(pmd_pfn(*pmd));
+	folio = pmd_folio(*pmd);
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
--- a/mm/mlock.c~mm-add-pmd_folio
+++ a/mm/mlock.c
@@ -378,7 +378,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 			goto out;
 		if (is_huge_zero_pmd(*pmd))
 			goto out;
-		folio = page_folio(pmd_page(*pmd));
+		folio = pmd_folio(*pmd);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_folio(folio);
 		else
--- a/mm/userfaultfd.c~mm-add-pmd_folio
+++ a/mm/userfaultfd.c
@@ -1662,7 +1662,7 @@ ssize_t move_pages(struct userfaultfd_ct
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pfn_folio(pmd_pfn(*src_pmd));
+				struct folio *folio = pmd_folio(*src_pmd);
 
 				if (!folio || (!is_huge_zero_folio(folio) &&
 					       !PageAnonExclusive(&folio->page))) {
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


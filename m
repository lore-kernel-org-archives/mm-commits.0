Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E7A7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104041; cv=none; b=ZM05O+8yu6UxkqWbVjA6LzTsxJeiHgFiSzomOAlooq4a/oPWr5dVw1xM5Gf0wLYnJ95O2BXvr40xALejQhjCdOPavV4N7UsYNyp3SEU5KoTQXbx6YIvCCR7JNnMKHY1lA3VNu7KOVcAT4ToPbV5IhB7VGL5Gnp1PyMJbGde6AhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104041; c=relaxed/simple;
	bh=XRAKzkVjawTAc956qtTmcL0IQ2St1mxMGGbNwg3oKB0=;
	h=Date:To:From:Subject:Message-Id; b=eXbw+EgY0ogmMIodP95zgvF5/77T9aNgidnu59G+6z/7bvcX0aIO7zBCaJNdpiOgeP6XTupXQrdjw8XQfW4Gv/2QpMaw25jzS5R7122cqVScsSiML4HHtbI2wP9EVufXuHJCi6s02yeqT5yR3a4LGxGAXUhsrMmzTE5/1IbSkfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mw2KPpt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mw2KPpt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC048C113CD;
	Fri, 26 Apr 2024 04:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104041;
	bh=XRAKzkVjawTAc956qtTmcL0IQ2St1mxMGGbNwg3oKB0=;
	h=Date:To:From:Subject:From;
	b=Mw2KPpt5BVGADXVEdnR9hHrt9PHcA/KRjZDY+hy6YxKRbUwGZRBHq8gHX8FDAbY3v
	 oPLLdznDfIzCDtu/5We6zyYNxUQnazFhExCc5kCorqKvkTgNW2Z0utjEE6DFSoZGuK
	 faj1Fl+SKwpLPEihtWMUlsyLudRFu3q+BPReAidU=
Date: Thu, 25 Apr 2024 21:00:40 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-use-is_huge_zero_pmd.patch removed from -mm tree
Message-Id: <20240426040040.EC048C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc: use is_huge_zero_pmd()
has been removed from the -mm tree.  Its filename was
     sparc-use-is_huge_zero_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: sparc: use is_huge_zero_pmd()
Date: Tue, 26 Mar 2024 20:28:21 +0000

Patch series "Convert huge_zero_page to huge_zero_folio".

Almost all the callers of is_huge_zero_page() already have a folio.  And
they should -- is_huge_zero_page() will return false for tail pages, even
if they're tail pages of the huge zero page.  That's confusing, and one of
the benefits of the folio conversion is to get rid of this confusion.


This patch (of 8):

There's no need to convert to a page, much less a folio.  We can tell from
the pmd whether it is a huge zero page or not.  Saves 60 bytes of text.

Link: https://lkml.kernel.org/r/20240326202833.523759-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240326202833.523759-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sparc/mm/tlb.c~sparc-use-is_huge_zero_pmd
+++ a/arch/sparc/mm/tlb.c
@@ -183,12 +183,12 @@ static void __set_pmd_acct(struct mm_str
 		 * hugetlb_pte_count.
 		 */
 		if (pmd_val(pmd) & _PAGE_PMD_HUGE) {
-			if (is_huge_zero_page(pmd_page(pmd)))
+			if (is_huge_zero_pmd(pmd))
 				mm->context.hugetlb_pte_count++;
 			else
 				mm->context.thp_pte_count++;
 		} else {
-			if (is_huge_zero_page(pmd_page(orig)))
+			if (is_huge_zero_pmd(orig))
 				mm->context.hugetlb_pte_count--;
 			else
 				mm->context.thp_pte_count--;
@@ -259,7 +259,7 @@ pmd_t pmdp_invalidate(struct vm_area_str
 	 * Sanity check pmd before doing the actual decrement.
 	 */
 	if ((pmd_val(entry) & _PAGE_PMD_HUGE) &&
-	    !is_huge_zero_page(pmd_page(entry)))
+	    !is_huge_zero_pmd(entry))
 		(vma->vm_mm)->context.thp_pte_count--;
 
 	return old;
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60D880631
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104126; cv=none; b=cZNWWYHjphL6rpulVt9uHjRAcLkFzJ1X3NX2+xPglrq8UVGKRenqVXXs5lqHrqaMbHXTvToApSFJNptRfAEEGDrLZpLjzDR69nZWVC8IeK6HpSoG82KgS4BZkMhbBSOeEIIDlXohCe9vLPEXwYw4oYEKNPEF3gupwc+1htwsVLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104126; c=relaxed/simple;
	bh=N03fcKD0MGmd0Jv3uSE4mYKHua8kg5DBwka/d6QgyRA=;
	h=Date:To:From:Subject:Message-Id; b=aqAuaWuSuSny5lEeA4J6DhoMkjwgviTD15/P+eFqY7SN+jZOGUA4i4ZKL0VeDZQs1RgSTKz+HCQ5RXMnPv1YuGt3OHf28nF/ZMhuIHwQafxfDfOHtbVPu+RIJ8mJNytAuvJPVGrOgs/3Rrq0sgPhUw9xMiJGCe2BAtj2eFjfXQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i/Im3UUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i/Im3UUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C69C113CD;
	Fri, 26 Apr 2024 04:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104126;
	bh=N03fcKD0MGmd0Jv3uSE4mYKHua8kg5DBwka/d6QgyRA=;
	h=Date:To:From:Subject:From;
	b=i/Im3UUy90ZeVX3mB4jqev860gVaq9QhXUmpg31AtjCWjwjPePD/aMofRIOTq0/zB
	 z3wFGYrsELkRHMSb2ZEjd6ihPMrqNbCAboJM1kTj5hHt8Aw/GqX+c38vT7Sga6pE3c
	 3zelDJSSVcHW4yD+mmfPMQdQBGWvftMfIpx/FoGk=
Date: Thu, 25 Apr 2024 21:02:06 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-convert-clear_refs_pte_range-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240426040206.A4C69C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: convert clear_refs_pte_range to use a folio
has been removed from the -mm tree.  Its filename was
     proc-convert-clear_refs_pte_range-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: convert clear_refs_pte_range to use a folio
Date: Tue, 2 Apr 2024 21:12:48 +0100

Patch series "Remove page_idle and page_young wrappers".

There are only a couple of places left using the page wrappers for idle &
young tracking.  Convert the two users in proc and then we can remove the
wrappers.  That enables the further simplification of autogenerating the
definitions when CONFIG_PAGE_IDLE_FLAG is disabled.  


This patch (of 4):

Replaces four calls to compound_head() with two.

Link: https://lkml.kernel.org/r/20240402201252.917342-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240402201252.917342-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/proc/task_mmu.c~proc-convert-clear_refs_pte_range-to-use-a-folio
+++ a/fs/proc/task_mmu.c
@@ -1161,7 +1161,7 @@ static int clear_refs_pte_range(pmd_t *p
 	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
-	struct page *page;
+	struct folio *folio;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
@@ -1173,12 +1173,12 @@ static int clear_refs_pte_range(pmd_t *p
 		if (!pmd_present(*pmd))
 			goto out;
 
-		page = pmd_page(*pmd);
+		folio = pmd_folio(*pmd);
 
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
-		test_and_clear_page_young(page);
-		ClearPageReferenced(page);
+		folio_test_clear_young(folio);
+		folio_clear_referenced(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1200,14 +1200,14 @@ out:
 		if (!pte_present(ptent))
 			continue;
 
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
+		folio = vm_normal_folio(vma, addr, ptent);
+		if (!folio)
 			continue;
 
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
-		test_and_clear_page_young(page);
-		ClearPageReferenced(page);
+		folio_test_clear_young(folio);
+		folio_clear_referenced(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
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


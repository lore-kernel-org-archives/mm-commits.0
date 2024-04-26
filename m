Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF34B8062B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104119; cv=none; b=T27icyrOmZWXked2jc75P0D2yqmCIoriSbbWPBG9vJ3bX0LbNFl97PamNubccV+loKF2HqAztRMEUmjfWvBkvMIp/ikCniM27Jo7Yw0R/z14Zh61SA9j+f2sZazMwmUVecBYC5JGl5tsrVLP4PkVhHvsfO1aVNFzNC67MUGdwdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104119; c=relaxed/simple;
	bh=28h87s4sWskkXkK0hLaRkUD6u54tB/ez+KrjF1easOY=;
	h=Date:To:From:Subject:Message-Id; b=MjSE3MdHDboLIfu/9UoOHPHcS+nIsexsnnZ8i74J2qFn4hsWhBqzmbiB0o22CNu52DtMkvNAWU9eDWTbDjk2gx68eIxjODXYAFbIFnbNK7dmnNhZnHyiJoPPbR6boAcZZ06t0WseEvHwEzHiXWvwVAJX3FIVNNBtSOD9vkWqClk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EiA0ZRLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EiA0ZRLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4865C113CD;
	Fri, 26 Apr 2024 04:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104119;
	bh=28h87s4sWskkXkK0hLaRkUD6u54tB/ez+KrjF1easOY=;
	h=Date:To:From:Subject:From;
	b=EiA0ZRLPhXiwAT7sWoFLaLOL2WMQEOcpwNrsconZkuNCSTMMWgQ4IlG+HhvkyDWwu
	 f2DXgzduxIQWIQGo26fU2kWdPhtS4wq6u1KTgY9XYqcKQuIu1v0Bcwiwhr+Un76XUH
	 1CBnptsKh4XJ7L8LmuHpX0oyxh11TkDsfrLDvPpc=
Date: Thu, 25 Apr 2024 21:01:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch removed from -mm tree
Message-Id: <20240426040159.A4865C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: convert alloc_charge_hpage to alloc_charge_folio
has been removed from the -mm tree.  Its filename was
     khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: khugepaged: convert alloc_charge_hpage to alloc_charge_folio
Date: Wed, 3 Apr 2024 18:18:31 +0100

Both callers want to deal with a folio, so return a folio from this
function.

Link: https://lkml.kernel.org/r/20240403171838.1445826-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio
+++ a/mm/khugepaged.c
@@ -1045,7 +1045,7 @@ out:
 	return result;
 }
 
-static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
+static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 			      struct collapse_control *cc)
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
@@ -1055,7 +1055,7 @@ static int alloc_charge_hpage(struct pag
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
 	if (!folio) {
-		*hpage = NULL;
+		*foliop = NULL;
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
@@ -1063,13 +1063,13 @@ static int alloc_charge_hpage(struct pag
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
-		*hpage = NULL;
+		*foliop = NULL;
 		return SCAN_CGROUP_CHARGE_FAIL;
 	}
 
 	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
 
-	*hpage = folio_page(folio, 0);
+	*foliop = folio;
 	return SCAN_SUCCEED;
 }
 
@@ -1098,7 +1098,8 @@ static int collapse_huge_page(struct mm_
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_hpage(&hpage, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc);
+	hpage = &folio->page;
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1204,7 +1205,6 @@ static int collapse_huge_page(struct mm_
 	if (unlikely(result != SCAN_SUCCEED))
 		goto out_up_write;
 
-	folio = page_folio(hpage);
 	/*
 	 * The smp_wmb() inside __folio_mark_uptodate() ensures the
 	 * copy_huge_page writes become visible before the set_pmd_at()
@@ -1789,7 +1789,7 @@ static int collapse_file(struct mm_struc
 	struct page *hpage;
 	struct page *page;
 	struct page *tmp;
-	struct folio *folio;
+	struct folio *folio, *new_folio;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1800,7 +1800,8 @@ static int collapse_file(struct mm_struc
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_hpage(&hpage, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc);
+	hpage = &new_folio->page;
 	if (result != SCAN_SUCCEED)
 		goto out;
 
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


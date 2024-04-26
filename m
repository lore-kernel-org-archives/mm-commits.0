Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4F980C16
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104156; cv=none; b=mkWpRH6ZoGXcyQE0GwFl3hMM70rOXO/Vb07MmHBLNfciq2nVCsF4j74AtA09aSEYCYu6TUPLdDPmwSvFluzKxt6LFU2f8VNN+nA0ZG5dl/sTlQr8H5zJg4CrU9RRLlA47UjFHV5UbBI3RlDMAIgL+0fqhYGws72HLOt2Cog5AXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104156; c=relaxed/simple;
	bh=zCNq37UXFWsbEGfAywxhAElHdGcuhXFp2ctkzDIw7+U=;
	h=Date:To:From:Subject:Message-Id; b=h79xLeRBNoLJ4zMol+sB3FrUOLwtEB6kXQj+gVEimwYTHuJGpK0E8xr0SSoYG4hqsFR/zeNEkpy2ScbiExaZBA6o1O0YxYhaGnvQjBToeA/zWXZWnYsZ7/NkVWxb5bureTfivcF/U40QbHmvkWs7c7yUY3j+kjJ5xx/lBXy41o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gSunbrwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gSunbrwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90956C113CD;
	Fri, 26 Apr 2024 04:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104156;
	bh=zCNq37UXFWsbEGfAywxhAElHdGcuhXFp2ctkzDIw7+U=;
	h=Date:To:From:Subject:From;
	b=gSunbrwkRdSVJ8h7DaRExre6rnv/r1d9wvkQhHaVaQm+sqPkSEH21ZFk+frRAg6Aj
	 7q0B0AgYhzDoNCqDwIBtlkT6XSgdSV6mXgeInqlqnW1oEbrEcLDmnfvBUSkH/FiKiH
	 BlUxGkuX3GQ5D/bDbrrmjTYGVO4OZz/miEhNGg6w=
Date: Thu, 25 Apr 2024 21:02:36 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240426040236.90956C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: convert alloc_buddy_hugetlb_folio to use a folio
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: convert alloc_buddy_hugetlb_folio to use a folio
Date: Tue, 2 Apr 2024 21:06:54 +0100

While this function returned a folio, it was still using __alloc_pages()
and __free_pages().  Use __folio_alloc() and put_folio() instead.  This
actually removes a call to compound_head(), but more importantly, it
prepares us for the move to memdescs.

Link: https://lkml.kernel.org/r/20240402200656.913841-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/mm/hugetlb.c~hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio
+++ a/mm/hugetlb.c
@@ -2177,13 +2177,13 @@ static struct folio *alloc_buddy_hugetlb
 		nodemask_t *node_alloc_noretry)
 {
 	int order = huge_page_order(h);
-	struct page *page;
+	struct folio *folio;
 	bool alloc_try_hard = true;
 	bool retry = true;
 
 	/*
-	 * By default we always try hard to allocate the page with
-	 * __GFP_RETRY_MAYFAIL flag.  However, if we are allocating pages in
+	 * By default we always try hard to allocate the folio with
+	 * __GFP_RETRY_MAYFAIL flag.  However, if we are allocating folios in
 	 * a loop (to adjust global huge page counts) and previous allocation
 	 * failed, do not continue to try hard on the same node.  Use the
 	 * node_alloc_noretry bitmap to manage this state information.
@@ -2196,43 +2196,42 @@ static struct folio *alloc_buddy_hugetlb
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 retry:
-	page = __alloc_pages(gfp_mask, order, nid, nmask);
+	folio = __folio_alloc(gfp_mask, order, nid, nmask);
 
-	/* Freeze head page */
-	if (page && !page_ref_freeze(page, 1)) {
-		__free_pages(page, order);
+	if (folio && !folio_ref_freeze(folio, 1)) {
+		folio_put(folio);
 		if (retry) {	/* retry once */
 			retry = false;
 			goto retry;
 		}
 		/* WOW!  twice in a row. */
-		pr_warn("HugeTLB head page unexpected inflated ref count\n");
-		page = NULL;
+		pr_warn("HugeTLB unexpected inflated folio ref count\n");
+		folio = NULL;
 	}
 
 	/*
-	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a page this
-	 * indicates an overall state change.  Clear bit so that we resume
-	 * normal 'try hard' allocations.
+	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
+	 * folio this indicates an overall state change.  Clear bit so
+	 * that we resume normal 'try hard' allocations.
 	 */
-	if (node_alloc_noretry && page && !alloc_try_hard)
+	if (node_alloc_noretry && folio && !alloc_try_hard)
 		node_clear(nid, *node_alloc_noretry);
 
 	/*
-	 * If we tried hard to get a page but failed, set bit so that
+	 * If we tried hard to get a folio but failed, set bit so that
 	 * subsequent attempts will not try as hard until there is an
 	 * overall state change.
 	 */
-	if (node_alloc_noretry && !page && alloc_try_hard)
+	if (node_alloc_noretry && !folio && alloc_try_hard)
 		node_set(nid, *node_alloc_noretry);
 
-	if (!page) {
+	if (!folio) {
 		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
 		return NULL;
 	}
 
 	__count_vm_event(HTLB_BUDDY_PGALLOC);
-	return page_folio(page);
+	return folio;
 }
 
 static struct folio *__alloc_fresh_hugetlb_folio(struct hstate *h,
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


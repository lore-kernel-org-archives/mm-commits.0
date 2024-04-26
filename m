Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DAB80631
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104126; cv=none; b=mKl/wsa1VQ5I/j/gPXznUqcdlRBjSz3EgZoDAisCdp5yisVQUGwncvJ3UezjNxySv9uEDOYLRsOpIRjUBIp+Zkla7g7FjMo3dAOmnwQlcsQLaCD7c2rAcpaEDNMct/WDhZMFnL8LFC3X7WsG/pwC7yDVzPY6MExrMWpUKtTIUOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104126; c=relaxed/simple;
	bh=iOjO/iKQ8vaXsCfVezUbc5IG7QKOQ9k1k2wI28IbZcI=;
	h=Date:To:From:Subject:Message-Id; b=HRWa33Q+E/ykCt0TE/X4zDl/YOmHr+fhue+REpBfe6eOoxry3OKn8EVegR8l7WGRxsr9ww7yXVN2JlQJSc/oF1dGorqwJd4CMo5m/6eMEEMH3pcw5ODIQ9AP6YrXTL5+SfxCixwZ1hxhmd9SZY8oqumMjtJURVLZhhJEyBrA2Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMvLX7aI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMvLX7aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC62C113CD;
	Fri, 26 Apr 2024 04:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104125;
	bh=iOjO/iKQ8vaXsCfVezUbc5IG7QKOQ9k1k2wI28IbZcI=;
	h=Date:To:From:Subject:From;
	b=fMvLX7aIVLbaiSPvO/kInQcxCLOhqdOnH3D7nKRzr7vLN22Ao2vOBUD/zuY17wZAM
	 ZkClpmqMb1f7mPVKB6pTynHsabRtLb9YYYyQ4r1Qx/Z9iwB2M9SpxHjt9rCACsN5f6
	 mOMcoOAD+52U1xfJWQlQ6Xc2hUqUL9YqMdCcJ6Ho=
Date: Thu, 25 Apr 2024 21:02:05 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch removed from -mm tree
Message-Id: <20240426040205.9FC62C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: use a folio throughout hpage_collapse_scan_file()
has been removed from the -mm tree.  Its filename was
     khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: khugepaged: use a folio throughout hpage_collapse_scan_file()
Date: Wed, 3 Apr 2024 18:18:36 +0100

Replace the use of pages with folios.  Saves a few calls to
compound_head() and removes some uses of obsolete functions.

Link: https://lkml.kernel.org/r/20240403171838.1445826-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    6 ++--
 mm/khugepaged.c                    |   33 +++++++++++++--------------
 2 files changed, 19 insertions(+), 20 deletions(-)

--- a/include/trace/events/huge_memory.h~khugepaged-use-a-folio-throughout-hpage_collapse_scan_file
+++ a/include/trace/events/huge_memory.h
@@ -174,10 +174,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin
 
 TRACE_EVENT(mm_khugepaged_scan_file,
 
-	TP_PROTO(struct mm_struct *mm, struct page *page, struct file *file,
+	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
 		 int present, int swap, int result),
 
-	TP_ARGS(mm, page, file, present, swap, result),
+	TP_ARGS(mm, folio, file, present, swap, result),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -190,7 +190,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = page ? page_to_pfn(page) : -1;
+		__entry->pfn = folio ? folio_pfn(folio) : -1;
 		__assign_str(filename, file->f_path.dentry->d_iname);
 		__entry->present = present;
 		__entry->swap = swap;
--- a/mm/khugepaged.c~khugepaged-use-a-folio-throughout-hpage_collapse_scan_file
+++ a/mm/khugepaged.c
@@ -2203,7 +2203,7 @@ static int hpage_collapse_scan_file(stru
 				    struct file *file, pgoff_t start,
 				    struct collapse_control *cc)
 {
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
@@ -2215,11 +2215,11 @@ static int hpage_collapse_scan_file(stru
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	rcu_read_lock();
-	xas_for_each(&xas, page, start + HPAGE_PMD_NR - 1) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
+		if (xas_retry(&xas, folio))
 			continue;
 
-		if (xa_is_value(page)) {
+		if (xa_is_value(folio)) {
 			++swap;
 			if (cc->is_khugepaged &&
 			    swap > khugepaged_max_ptes_swap) {
@@ -2234,11 +2234,9 @@ static int hpage_collapse_scan_file(stru
 		 * TODO: khugepaged should compact smaller compound pages
 		 * into a PMD sized page
 		 */
-		if (PageTransCompound(page)) {
-			struct page *head = compound_head(page);
-
-			result = compound_order(head) == HPAGE_PMD_ORDER &&
-					head->index == start
+		if (folio_test_large(folio)) {
+			result = folio_order(folio) == HPAGE_PMD_ORDER &&
+					folio->index == start
 					/* Maybe PMD-mapped */
 					? SCAN_PTE_MAPPED_HUGEPAGE
 					: SCAN_PAGE_COMPOUND;
@@ -2251,28 +2249,29 @@ static int hpage_collapse_scan_file(stru
 			break;
 		}
 
-		node = page_to_nid(page);
+		node = folio_nid(folio);
 		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			break;
 		}
 		cc->node_load[node]++;
 
-		if (!PageLRU(page)) {
+		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
 			break;
 		}
 
-		if (page_count(page) !=
-		    1 + page_mapcount(page) + page_has_private(page)) {
+		if (folio_ref_count(folio) !=
+		    1 + folio_mapcount(folio) + folio_test_private(folio)) {
 			result = SCAN_PAGE_COUNT;
 			break;
 		}
 
 		/*
-		 * We probably should check if the page is referenced here, but
-		 * nobody would transfer pte_young() to PageReferenced() for us.
-		 * And rmap walk here is just too costly...
+		 * We probably should check if the folio is referenced
+		 * here, but nobody would transfer pte_young() to
+		 * folio_test_referenced() for us.  And rmap walk here
+		 * is just too costly...
 		 */
 
 		present++;
@@ -2294,7 +2293,7 @@ static int hpage_collapse_scan_file(stru
 		}
 	}
 
-	trace_mm_khugepaged_scan_file(mm, page, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
 	return result;
 }
 #else
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


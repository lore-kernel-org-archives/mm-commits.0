Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC55E80628
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104118; cv=none; b=XTKxEWF+gulahcxH1PnfV29idIncfdEZX4IBp2z4OHj+er6i5RdFeiiRI/iDIAvFKlRha1PIHpVTmiA0jLe426Du1bX3eIAocdf7bPhnmKHlWgwhg7EPbTRcP77S695gaQQfw+JVfe2vKCr4q7+u9SZmjQa5p9Jgg5uYTFQasOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104118; c=relaxed/simple;
	bh=YHa6UsHCvln9/OF7fEnkIV8/icLZp2ImUcOBHabz/Ps=;
	h=Date:To:From:Subject:Message-Id; b=ikoWSaEWxmoOmlEGp4f6EYLKqaSqo90WfyGuXwVUOA3YbpFhoKRP/shGsWh84T4YKOyu7+Wf5qYTdRLaPlM+pzv/TZs6UPanoJ4ocj6ndpbQYqWvTt8tPVEpiVyjNZUtNCfFeTW+JnfW3DmHDU92L/frfE2+S0E1OwEvJ2IHli8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YWnjOq/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YWnjOq/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4001C113CD;
	Fri, 26 Apr 2024 04:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104118;
	bh=YHa6UsHCvln9/OF7fEnkIV8/icLZp2ImUcOBHabz/Ps=;
	h=Date:To:From:Subject:From;
	b=YWnjOq/VWtfQzOHEAFSS0t5WKp881ZnDqE/QEB9vYqrsNMWSW37Yl+pAZOUgMiTdw
	 tcIySrhz76FeVyXpcOocDn9dB3003Lp+L+ATiB4fcDMnUYnFlySxbVU+f0h/IPIXTl
	 /YDYmSHNq7PTqOF7Ex7ZBPvQ7NsqbB4vViEbhMEU=
Date: Thu, 25 Apr 2024 21:01:58 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-inline-hpage_collapse_alloc_folio.patch removed from -mm tree
Message-Id: <20240426040158.A4001C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: inline hpage_collapse_alloc_folio()
has been removed from the -mm tree.  Its filename was
     khugepaged-inline-hpage_collapse_alloc_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: khugepaged: inline hpage_collapse_alloc_folio()
Date: Wed, 3 Apr 2024 18:18:30 +0100

Patch series "khugepaged folio conversions".

We've been kind of hacking piecemeal at converting khugepaged to use
folios instead of compound pages, and so this patchset is a little larger
than it should be as I undo some of our wrong moves in the past.  In
particular, collapse_file() now consistently uses 'new_folio' for the
freshly allocated folio and 'folio' for the one that's currently in use.  


This patch (of 7):

This function has one caller, and the combined function is simpler to
read, reason about and modify.

Link: https://lkml.kernel.org/r/20240403171838.1445826-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240403171838.1445826-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/khugepaged.c~khugepaged-inline-hpage_collapse_alloc_folio
+++ a/mm/khugepaged.c
@@ -891,20 +891,6 @@ static int hpage_collapse_find_target_no
 }
 #endif
 
-static bool hpage_collapse_alloc_folio(struct folio **folio, gfp_t gfp, int node,
-				      nodemask_t *nmask)
-{
-	*folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, nmask);
-
-	if (unlikely(!*folio)) {
-		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
-		return false;
-	}
-
-	count_vm_event(THP_COLLAPSE_ALLOC);
-	return true;
-}
-
 /*
  * If mmap_lock temporarily dropped, revalidate vma
  * before taking mmap_lock.
@@ -1067,11 +1053,14 @@ static int alloc_charge_hpage(struct pag
 	int node = hpage_collapse_find_target_node(cc);
 	struct folio *folio;
 
-	if (!hpage_collapse_alloc_folio(&folio, gfp, node, &cc->alloc_nmask)) {
+	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
+	if (!folio) {
 		*hpage = NULL;
+		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
+	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*hpage = NULL;
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


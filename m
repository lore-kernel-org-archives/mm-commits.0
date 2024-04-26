Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70B57F7D1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104111; cv=none; b=SlW3ZdbeHdHhqAQrEOJdY/De2XahnDG+Yy1jdMDSm9/QBxpF+FKPH2UWBoKE5cDzsQ8EP/ymb7z7jOyzwCR6zbUjmCuDw0O7PV+r5Sy6C9xbK1Ef2gR5CNkfnOn6sTqwzlMcKAdEpCgYmSpTcCMFL8WMO6dv+xO1Lp00WpZC2Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104111; c=relaxed/simple;
	bh=yvzHbI6ADC1upooNjwvCB8mbarUqbSipYFlOLWy4ExM=;
	h=Date:To:From:Subject:Message-Id; b=lFbltLjx6FVhLV63pWtbCsz0fuqul7kLyBdwKXo4V60Or5aMDNhvawzU/YAO5nFhgZUSLUcR52oJQrcYy/HQYhoOoGJGJBGuRnTIfli5Rn7x3AKPmYbS5X/QNESUo5JzWqzVh3cqr0k0QnEpAacSVZwdDuBS6TE7ugU0QElkSHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KXEuhEDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KXEuhEDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D313C113CD;
	Fri, 26 Apr 2024 04:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104111;
	bh=yvzHbI6ADC1upooNjwvCB8mbarUqbSipYFlOLWy4ExM=;
	h=Date:To:From:Subject:From;
	b=KXEuhEDWo4kQcJzqa/5s3R9geTfioy1I94HA1ktf7zua78JtY07NDIW5C24xJQVm1
	 A/WneEgbGaGryM/Oy3oQ3POFJqyviFU30d3pmuSi72IHj7PwBHf0EQBzWFv9S1F3UX
	 8zTInaUWkPDPIIlFn9UxeYt+zsOMtfCCnaBVrMCc=
Date: Thu, 25 Apr 2024 21:01:50 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-correct-page_mapped_in_vma-for-large-folios.patch removed from -mm tree
Message-Id: <20240426040151.7D313C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: correct page_mapped_in_vma() for large folios
has been removed from the -mm tree.  Its filename was
     mm-correct-page_mapped_in_vma-for-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: correct page_mapped_in_vma() for large folios
Date: Thu, 28 Mar 2024 22:58:27 +0000

Patch series "Unify vma_address and vma_pgoff_address".

The current vma_address() pretends that the ambiguity between head & tail
page is an advantage.  If you pass a head page to vma_address(), it will
operate on all pages in the folio, while if you pass a tail page, it will
operate on a single page.  That's not what any of the callers actually
want, so first convert all callers to use vma_pgoff_address() and then
rename vma_pgoff_address() to vma_address().


This patch (of 3):

If 'page' is the first page of a large folio then vma_address() will scan
for any page in the entire folio.  This can lead to page_mapped_in_vma()
returning true if some of the tail pages are mapped and the head page is
not.  This could lead to memory failure choosing to kill a task
unnecessarily.

Link: https://lkml.kernel.org/r/20240328225831.1765286-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240328225831.1765286-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_vma_mapped.c~mm-correct-page_mapped_in_vma-for-large-folios
+++ a/mm/page_vma_mapped.c
@@ -325,6 +325,8 @@ next_pte:
  */
 int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 {
+	struct folio *folio = page_folio(page);
+	pgoff_t pgoff = folio->index + folio_page_idx(folio, page);
 	struct page_vma_mapped_walk pvmw = {
 		.pfn = page_to_pfn(page),
 		.nr_pages = 1,
@@ -332,7 +334,7 @@ int page_mapped_in_vma(struct page *page
 		.flags = PVMW_SYNC,
 	};
 
-	pvmw.address = vma_address(page, vma);
+	pvmw.address = vma_pgoff_address(pgoff, 1, vma);
 	if (pvmw.address == -EFAULT)
 		return 0;
 	if (!page_vma_mapped_walk(&pvmw))
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


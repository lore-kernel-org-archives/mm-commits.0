Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D997B8062B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104133; cv=none; b=k8qZV2141zd1fKVved0MCemhKjycQAZNdfK8lpw0Ag5YekhLS6cDzyW7rIk2VQmP4iVLnbHNMWFQSZbojuQW2/vLxQtOZhLAWY7Xrr8MuLRMS8QPs/bOh00ego2vYxMVEKG4VEBJ7KH8IW/y8W/PhR070zI1rOQnvUMjMnUq2Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104133; c=relaxed/simple;
	bh=IK9z78Zn+oxsVWAOZ7tfAReKlxRHyJY2Ky8qhWxOzvA=;
	h=Date:To:From:Subject:Message-Id; b=S+XSK28ETYyR/VkZtp2OWnI5nX9zUhEH+JyoPCNPMGtOuZDOqyo7OAmB29Ewryf2Bk1NvpV99Ubw9s9Qn5vGaJdv2fEjaHYE1ZUF9kf4D98qNGtaBap8QRtF0HR8ar6XB8TNJ81HnAyWSiMU3CdQP5erE8wLfsREbGR8msyuqe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fF268p+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fF268p+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B050FC113CD;
	Fri, 26 Apr 2024 04:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104133;
	bh=IK9z78Zn+oxsVWAOZ7tfAReKlxRHyJY2Ky8qhWxOzvA=;
	h=Date:To:From:Subject:From;
	b=fF268p+CCD2h+2cprSXqWilz1O7IbK4ek5p4Co1HCbkdD1SlFjxuy8n8V/0hooxf2
	 V++HhGg0JMJXTq3nBI9Fl+qYVi3cladZo36yGecnHN8Rus/YrZsTbN8MD6sz3cvUBC
	 J6OkoRlOVLrmFub1gPstPSBzbytEUF7IREGpL4+o=
Date: Thu, 25 Apr 2024 21:02:13 -0700
To: mm-commits@vger.kernel.org,brauner@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-convert-smaps_pmd_entry-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240426040213.B050FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: convert smaps_pmd_entry to use a folio
has been removed from the -mm tree.  Its filename was
     proc-convert-smaps_pmd_entry-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: convert smaps_pmd_entry to use a folio
Date: Wed, 3 Apr 2024 18:14:55 +0100

Replace two calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20240403171456.1445117-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~proc-convert-smaps_pmd_entry-to-use-a-folio
+++ a/fs/proc/task_mmu.c
@@ -578,6 +578,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	struct folio *folio;
 	bool migration = false;
 
 	if (pmd_present(*pmd)) {
@@ -592,11 +593,12 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
-	if (PageAnon(page))
+	folio = page_folio(page);
+	if (folio_test_anon(folio))
 		mss->anonymous_thp += HPAGE_PMD_SIZE;
-	else if (PageSwapBacked(page))
+	else if (folio_test_swapbacked(folio))
 		mss->shmem_thp += HPAGE_PMD_SIZE;
-	else if (is_zone_device_page(page))
+	else if (folio_is_zone_device(folio))
 		/* pass */;
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
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


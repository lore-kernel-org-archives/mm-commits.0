Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23C80BF8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104131; cv=none; b=ASNpQRs44dM3La5jzzd5yp5ZzyeHjtU6fD3NxPawm/khZLo0q2hai6eE6e7M55TkhYhHsm1PYICb9zSdkbGlDgm9JLW98btkg31P5c68kV+PqHrMUxSiX4wXtD7X/DmZK7FqrTuhlwBvCPkITAftsLXROf092jJckNQwD0ErBC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104131; c=relaxed/simple;
	bh=GZR0iTFWCuix3dY7bG+aJnNlQ777kvJKbTQJztGVmYU=;
	h=Date:To:From:Subject:Message-Id; b=qh8UJdQVclQAGERe/s4DAjrlCGr4oZtsIToM3ZQak6v31fVQOrdBXkc43ua45Vr5CGPtDi1p8pfcO8tzVuXULjPx7x4uAnGXWbHGjtwME0fOJQ0lDnEr/CuzIDSaj6mqqgsWguB2Bz525NHji+1F5pD20nP3aSgkJYGfqw7/FrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3AbB/Gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3AbB/Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF36C113CD;
	Fri, 26 Apr 2024 04:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104131;
	bh=GZR0iTFWCuix3dY7bG+aJnNlQ777kvJKbTQJztGVmYU=;
	h=Date:To:From:Subject:From;
	b=C3AbB/GdUj5QodFZRVvmziIOF5Eqj/M2WadSRECEDGf7597qty7ZgABDS1asB8wCI
	 /vhhAAO3brt3nZhqYjWe5fe0DyTRd38t21gkyzemm2xnxqCT4BDlra0/0OvUpSjFDG
	 8d5Yu3R1T2pZpfND3oxxX3Xy6xRLC1wdh/sqiU84=
Date: Thu, 25 Apr 2024 21:02:11 -0700
To: mm-commits@vger.kernel.org,brauner@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-convert-smaps_page_accumulate-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240426040211.ABF36C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: convert smaps_page_accumulate to use a folio
has been removed from the -mm tree.  Its filename was
     proc-convert-smaps_page_accumulate-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: convert smaps_page_accumulate to use a folio
Date: Wed, 3 Apr 2024 18:14:53 +0100

Replaces three calls to compound_head() with one.  Shrinks the function
from 2614 bytes to 1112 bytes in an allmodconfig build.

Link: https://lkml.kernel.org/r/20240403171456.1445117-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~proc-convert-smaps_page_accumulate-to-use-a-folio
+++ a/fs/proc/task_mmu.c
@@ -414,11 +414,12 @@ static void smaps_page_accumulate(struct
 		struct page *page, unsigned long size, unsigned long pss,
 		bool dirty, bool locked, bool private)
 {
+	struct folio *folio = page_folio(page);
 	mss->pss += pss;
 
-	if (PageAnon(page))
+	if (folio_test_anon(folio))
 		mss->pss_anon += pss;
-	else if (PageSwapBacked(page))
+	else if (folio_test_swapbacked(folio))
 		mss->pss_shmem += pss;
 	else
 		mss->pss_file += pss;
@@ -426,7 +427,7 @@ static void smaps_page_accumulate(struct
 	if (locked)
 		mss->pss_locked += pss;
 
-	if (dirty || PageDirty(page)) {
+	if (dirty || folio_test_dirty(folio)) {
 		mss->pss_dirty += pss;
 		if (private)
 			mss->private_dirty += size;
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


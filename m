Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3EF80BF7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104128; cv=none; b=E8YZz3t5T9wUZA/wDzY33Fk0AQ2dHar0dZUr9oUXomNCVs9TN57ttA64h4TtWNS71Uc0ZShOqN24Q126t7o1inKNzr6+0b2NmgBQ1xbjqluWrGxKNIyq5UMc1yPlyFMD8FW5e8roUhAftiSSTD9bzziMYBfBFfbhWu8n0lIhpSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104128; c=relaxed/simple;
	bh=DC3Hp67Lk8KL/N60fxNCDcUKyDMht13Ju8947T26SSQ=;
	h=Date:To:From:Subject:Message-Id; b=mZx8x/Evn4oTGt57LxqniF5pt5Ve/d5qwvp4jojxVb3Q9HL93OPx6LXCDP/SfwY0n24agy4YdmQbv0QgByBkxcajA2N266Vkzor+SiKTFW8PEgoMzglZNAKlHMTs/i3O6zK9Q/TJQLMS4Cxh45qICv+QYt+Hv0TGLwzHvPpr+/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lUOYliWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lUOYliWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25B6C113CD;
	Fri, 26 Apr 2024 04:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104127;
	bh=DC3Hp67Lk8KL/N60fxNCDcUKyDMht13Ju8947T26SSQ=;
	h=Date:To:From:Subject:From;
	b=lUOYliWZkp9ncaUmgv9Ck28v7wGkkHIDTpF5T5aM8j8eIOxy7Z5wYXOHiOgh0izFn
	 MViyhVGJbHwLcigG76dV/DQv8LSnB2FjQkOAYnD0hZPduDMjSjCsgcS0l2y71r7gGE
	 xye2364wV+6vcwNIqc1qFi5KJTVYQ+aXvA1SZ+48=
Date: Thu, 25 Apr 2024 21:02:07 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-convert-smaps_account-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240426040207.A25B6C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: convert smaps_account() to use a folio
has been removed from the -mm tree.  Its filename was
     proc-convert-smaps_account-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: convert smaps_account() to use a folio
Date: Tue, 2 Apr 2024 21:12:49 +0100

Replace seven calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20240402201252.917342-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/proc/task_mmu.c~proc-convert-smaps_account-to-use-a-folio
+++ a/fs/proc/task_mmu.c
@@ -444,6 +444,7 @@ static void smaps_account(struct mem_siz
 		bool compound, bool young, bool dirty, bool locked,
 		bool migration)
 {
+	struct folio *folio = page_folio(page);
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
 
@@ -451,27 +452,28 @@ static void smaps_account(struct mem_siz
 	 * First accumulate quantities that depend only on |size| and the type
 	 * of the compound page.
 	 */
-	if (PageAnon(page)) {
+	if (folio_test_anon(folio)) {
 		mss->anonymous += size;
-		if (!PageSwapBacked(page) && !dirty && !PageDirty(page))
+		if (!folio_test_swapbacked(folio) && !dirty &&
+		    !folio_test_dirty(folio))
 			mss->lazyfree += size;
 	}
 
-	if (PageKsm(page))
+	if (folio_test_ksm(folio))
 		mss->ksm += size;
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || page_is_young(page) || PageReferenced(page))
+	if (young || folio_test_young(folio) || folio_test_referenced(folio))
 		mss->referenced += size;
 
 	/*
 	 * Then accumulate quantities that may depend on sharing, or that may
 	 * differ page-by-page.
 	 *
-	 * page_count(page) == 1 guarantees the page is mapped exactly once.
+	 * refcount == 1 guarantees the page is mapped exactly once.
 	 * If any subpage of the compound page mapped with PTE it would elevate
-	 * page_count().
+	 * the refcount.
 	 *
 	 * The page_mapcount() is called to get a snapshot of the mapcount.
 	 * Without holding the page lock this snapshot can be slightly wrong as
@@ -480,7 +482,7 @@ static void smaps_account(struct mem_siz
 	 * especially for migration entries.  Treat regular migration entries
 	 * as mapcount == 1.
 	 */
-	if ((page_count(page) == 1) || migration) {
+	if ((folio_ref_count(folio) == 1) || migration) {
 		smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
 			locked, true);
 		return;
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


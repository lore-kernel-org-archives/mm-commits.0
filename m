Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CFD811E2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104132; cv=none; b=Y5ef6ekpPmqykYyMYPX5nZ4onh97P7ZCeW61TPjX/euznYG7SRY71XLBoX1aZNaPxyZIeIRf9Pf47Q+bQKuJiD1qvaBSbRBvM2Yzy18xd9A7Nb3dhQGXRmzTB+M5G4OAQ7zfsbbOXYL8wcbUeu9vkin5aiqQ6yCQF0dWr/QLoY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104132; c=relaxed/simple;
	bh=Kg1g6UAHS8De9K2uBqSr3QyyPKCfp7Bc5bwIqqzlgPI=;
	h=Date:To:From:Subject:Message-Id; b=QkeTmWUgL3qFMP1UbfuORXe7pOnZP1Dfs7kyBW1eCyjGWAUCKqmb48szaavnkaVtS/wnIySa/OYcZiG/RSy+RQ/RXguPTnQncb2CilNGchyUMjJWa/XyXr+n/63Sm1l4chJa6tm6k04nxgC/wiEfPjyUzo9PjxYJiv0gNPCrmU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jaGGiaty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jaGGiaty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA076C116B1;
	Fri, 26 Apr 2024 04:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104132;
	bh=Kg1g6UAHS8De9K2uBqSr3QyyPKCfp7Bc5bwIqqzlgPI=;
	h=Date:To:From:Subject:From;
	b=jaGGiaty/8IFzmPldMMem+SVDKTqsaDuF+5yv154aIcWlKmrnZaJi47RE8m7LUu1o
	 EGdrxJqAzhvVtrZehJU87yno+KSl8fdVVGlo1N9PcUlzxxei0PNH1NbiLj327R7IN8
	 boUxMv8gR+qFMF0fqMy27lFe7Qq7syFB0OxLDDnc=
Date: Thu, 25 Apr 2024 21:02:12 -0700
To: mm-commits@vger.kernel.org,brauner@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-pass-a-folio-to-smaps_page_accumulate.patch removed from -mm tree
Message-Id: <20240426040212.AA076C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: pass a folio to smaps_page_accumulate()
has been removed from the -mm tree.  Its filename was
     proc-pass-a-folio-to-smaps_page_accumulate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: pass a folio to smaps_page_accumulate()
Date: Wed, 3 Apr 2024 18:14:54 +0100

Both callers already have a folio; pass it in instead of doing the
conversion each time.

Link: https://lkml.kernel.org/r/20240403171456.1445117-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~proc-pass-a-folio-to-smaps_page_accumulate
+++ a/fs/proc/task_mmu.c
@@ -411,10 +411,9 @@ struct mem_size_stats {
 };
 
 static void smaps_page_accumulate(struct mem_size_stats *mss,
-		struct page *page, unsigned long size, unsigned long pss,
+		struct folio *folio, unsigned long size, unsigned long pss,
 		bool dirty, bool locked, bool private)
 {
-	struct folio *folio = page_folio(page);
 	mss->pss += pss;
 
 	if (folio_test_anon(folio))
@@ -484,8 +483,8 @@ static void smaps_account(struct mem_siz
 	 * as mapcount == 1.
 	 */
 	if ((folio_ref_count(folio) == 1) || migration) {
-		smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
-			locked, true);
+		smaps_page_accumulate(mss, folio, size, size << PSS_SHIFT,
+				dirty, locked, true);
 		return;
 	}
 	for (i = 0; i < nr; i++, page++) {
@@ -493,8 +492,8 @@ static void smaps_account(struct mem_siz
 		unsigned long pss = PAGE_SIZE << PSS_SHIFT;
 		if (mapcount >= 2)
 			pss /= mapcount;
-		smaps_page_accumulate(mss, page, PAGE_SIZE, pss, dirty, locked,
-				      mapcount < 2);
+		smaps_page_accumulate(mss, folio, PAGE_SIZE, pss,
+				dirty, locked, mapcount < 2);
 	}
 }
 
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


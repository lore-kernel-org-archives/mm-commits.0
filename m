Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1FB10A37
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560073; cv=none; b=mK6UrZDrEADK8YHEvAv6kKTjFgJhQNE8B78jHyJ8AnN3IW62MWPJ7M0mPLg6TGc7ruc2VulXdgezZHhdMpIz5qlDZkUiG2f5jUiKujLj8Q71yHxQAFKf8zCbl7lQ6G2SUV3RJLHeyrF3sTY1mQHwh8RYJet/ocJPKRExMv2Z7Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560073; c=relaxed/simple;
	bh=7HOdLR7JsVIEdkJcKkN9bFJyUx5tqgC/DHWsnMXBmv8=;
	h=Date:To:From:Subject:Message-Id; b=fgHyeBUJL7tDFHyUmQfJ0XzTQ1+auUeuPTHcY8N3IoMo298TYH/jK9eBMw1wL33afFaAfBSHl+M71GEQNh6D6fbIY5mcHEnZuHMAzKs0QHy1Vr046rby2FM5cqPdDDl4T8frAfKVqddU+GxkYj/00K26P1by5/v8WjFxkZfyImo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eXb+VDdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eXb+VDdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80123C43399;
	Thu, 22 Feb 2024 00:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560073;
	bh=7HOdLR7JsVIEdkJcKkN9bFJyUx5tqgC/DHWsnMXBmv8=;
	h=Date:To:From:Subject:From;
	b=eXb+VDdQxz5zfSP5hnhmcea9XlUoV5H0momeeca6KAD9s9I3CTBuljOq8yBaj1Lzg
	 ycI9yPTHt48DnKJ2u7XOKOpoXnnUtLG7ea9069kuvVITWHOamFi+l6Dw+BzbuHsxmN
	 S6hGDoCZ2xxiAHQ0FDAEiGJh4rrm8vHz2npc3XwY=
Date: Wed, 21 Feb 2024 16:01:12 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-pfn_swap_entry_folio.patch removed from -mm tree
Message-Id: <20240222000113.80123C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add pfn_swap_entry_folio()
has been removed from the -mm tree.  Its filename was
     mm-add-pfn_swap_entry_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add pfn_swap_entry_folio()
Date: Thu, 11 Jan 2024 15:24:20 +0000

Patch series "mm: convert mm counter to take a folio", v3.

Make sure all mm_counter() and mm_counter_file() callers have a folio,
then convert mm counter functions to take a folio, which saves some
compound_head() calls.


This patch (of 10):  

Thanks to the compound_head() hidden inside PageLocked(), this saves a
call to compound_head() over calling page_folio(pfn_swap_entry_to_page())

Link: https://lkml.kernel.org/r/20240111152429.3374566-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240111152429.3374566-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   13 +++++++++++++
 mm/filemap.c            |    2 +-
 mm/huge_memory.c        |    2 +-
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/include/linux/swapops.h~mm-add-pfn_swap_entry_folio
+++ a/include/linux/swapops.h
@@ -468,6 +468,19 @@ static inline struct page *pfn_swap_entr
 	return p;
 }
 
+static inline struct folio *pfn_swap_entry_folio(swp_entry_t entry)
+{
+	struct folio *folio = pfn_folio(swp_offset_pfn(entry));
+
+	/*
+	 * Any use of migration entries may only occur while the
+	 * corresponding folio is locked
+	 */
+	BUG_ON(is_migration_entry(entry) && !folio_test_locked(folio));
+
+	return folio;
+}
+
 /*
  * A pfn swap entry is a special type of swap entry that always has a pfn stored
  * in the swap offset. They are used to represent unaddressable device memory
--- a/mm/filemap.c~mm-add-pfn_swap_entry_folio
+++ a/mm/filemap.c
@@ -1354,7 +1354,7 @@ void migration_entry_wait_on_locked(swp_
 	unsigned long pflags;
 	bool in_thrashing;
 	wait_queue_head_t *q;
-	struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
+	struct folio *folio = pfn_swap_entry_folio(entry);
 
 	q = folio_waitqueue(folio);
 	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
--- a/mm/huge_memory.c~mm-add-pfn_swap_entry_folio
+++ a/mm/huge_memory.c
@@ -2045,7 +2045,7 @@ int change_huge_pmd(struct mmu_gather *t
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 	if (is_swap_pmd(*pmd)) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
-		struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
+		struct folio *folio = pfn_swap_entry_folio(entry);
 		pmd_t newpmd;
 
 		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch


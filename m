Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF7D7EF0C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104017; cv=none; b=NpW1pQ2v1WeGARLi5xXgbovOvX4FC7G9/LuDbnCf13bngA5I8tc3APV/i3XiD+EB0Ip1+qXUbHDehlPQMk2DIV5dz27F1rg2XDjYpJ96jeIbXg/pFvgPS4m2YdEcgONQmzgGj8fly14SxVfebkVs5KOFw+Q7qVa2ns+zGPYv94A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104017; c=relaxed/simple;
	bh=iUEhsdG1HmB54okL4xcxHWxXf7A546MedYhKpsfJzVM=;
	h=Date:To:From:Subject:Message-Id; b=AigwsMC23tOsA8jFJeXt8mKyeuAW0fPinzZb0PuBoD/VJhR5+zcVCmX4fsM2sCQ6Gufw1dyq7LWevIOOJ/rGM8n2zWPNaM+pgKAIae5aQxwdvcz2QxC4L+aEJXVv2+49KFYt329ZKt+S/aoRi7Z/po/DV5K5aA/jZrZQoWxeryU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sfNhRU7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sfNhRU7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AF2C113CD;
	Fri, 26 Apr 2024 04:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104017;
	bh=iUEhsdG1HmB54okL4xcxHWxXf7A546MedYhKpsfJzVM=;
	h=Date:To:From:Subject:From;
	b=sfNhRU7Rc7NtSOXLEQoHrF/LFLzz0Uhv+ZBbZq73Bs2J2XED2965AOfN7vyGzqEnF
	 uvXpajmZldjC1Zv7fCt4N+YhzbKuV70ZN7n9NJB5KBy2wU3w5Josy6rdTKeYrFxlTP
	 pf9Tgh93bsn5adWJo5cQkPvLWR684BEXHYTdTco0=
Date: Thu, 25 Apr 2024 21:00:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-is_free_buddy_page-take-a-const-argument.patch removed from -mm tree
Message-Id: <20240426040017.35AF2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make is_free_buddy_page() take a const argument
has been removed from the -mm tree.  Its filename was
     mm-make-is_free_buddy_page-take-a-const-argument.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make is_free_buddy_page() take a const argument
Date: Tue, 26 Mar 2024 17:10:27 +0000

This function does not modify its argument; let the callers know that so
they can make better optimisation decisions.

Link: https://lkml.kernel.org/r/20240326171045.410737-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 mm/page_alloc.c            |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/page-flags.h~mm-make-is_free_buddy_page-take-a-const-argument
+++ a/include/linux/page-flags.h
@@ -1088,7 +1088,7 @@ static inline bool is_page_hwpoison(cons
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
-extern bool is_free_buddy_page(struct page *page);
+bool is_free_buddy_page(const struct page *page);
 
 PAGEFLAG(Isolated, isolated, PF_ANY);
 
--- a/mm/page_alloc.c~mm-make-is_free_buddy_page-take-a-const-argument
+++ a/mm/page_alloc.c
@@ -6745,16 +6745,16 @@ void __offline_isolated_pages(unsigned l
 /*
  * This function returns a stable result only if called under zone lock.
  */
-bool is_free_buddy_page(struct page *page)
+bool is_free_buddy_page(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	unsigned int order;
 
 	for (order = 0; order < NR_PAGE_ORDERS; order++) {
-		struct page *page_head = page - (pfn & ((1 << order) - 1));
+		const struct page *head = page - (pfn & ((1 << order) - 1));
 
-		if (PageBuddy(page_head) &&
-		    buddy_order_unsafe(page_head) >= order)
+		if (PageBuddy(head) &&
+		    buddy_order_unsafe(head) >= order)
 			break;
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


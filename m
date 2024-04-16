Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBED13956B
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297619; cv=none; b=ZCX+9wbtS4D9pKBtkVl1KunIwh8nvCGJsITgfW45h3XsmISqJrj6BFtBwtoRTk+Mps03EnVt8k78FXW6Vw0TvTSHZQChJiZ124tskN+6xfRThLeo0jHmm9a/y92c4Lk7O51jGYu53xw7Rdmb9NptGq8HvOBR5TsMK4GxcTvDqEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297619; c=relaxed/simple;
	bh=kabqFPlbKMZCY7YWlisL7GCIGIDfT4G/aHyW8OYVawo=;
	h=Date:To:From:Subject:Message-Id; b=bNBZV3iN66Yj/rvQhyx+vaAYPJQe+yDdhDyR6Z7ptU10Jh7HhsrSXq+PlcHLUTjtZDDHFRxRZyu23isZZMEWUgzjyZeJO4oEYoS8dUdyL1EvwZF3Ava25a8zXu6LadAl/4MQlJXnw/hO2NEARvJmwXxDt33k9utyMDwAzMsbdus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=POrE6yNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="POrE6yNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEE8C113CE;
	Tue, 16 Apr 2024 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713297618;
	bh=kabqFPlbKMZCY7YWlisL7GCIGIDfT4G/aHyW8OYVawo=;
	h=Date:To:From:Subject:From;
	b=POrE6yNzhgY2RSNzcxCcp1C2JEUzmHB9i5wmCMy/+uSxJQTVAazU2HFGAwBkVNvru
	 gS9yTl2Ner69CGrgDRT8+oX7U9rLlCkh6gGjdrHd8wlOKYaepczq6T4p8HBk7APonz
	 pxGFiL42qfkhLJ6zOHOAXkmZNMx/n5qQ23NjjCnU=
Date: Tue, 16 Apr 2024 13:00:17 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-improve-the-description-of-__folio_mark_dirty.patch added to mm-unstable branch
Message-Id: <20240416200018.6CEE8C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: doc: improve the description of __folio_mark_dirty
has been added to the -mm mm-unstable branch.  Its filename is
     doc-improve-the-description-of-__folio_mark_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-improve-the-description-of-__folio_mark_dirty.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: doc: improve the description of __folio_mark_dirty
Date: Tue, 16 Apr 2024 04:17:45 +0100

Patch series "Improve buffer head documentation", v3.

Turn buffer head documentation into its own document, and make many
general improvements to the docs.  Obviously there is much more that could
be done.  Tested with make htmldocs.


This patch (of 8):

I've learned why it's safe to call __folio_mark_dirty() from
mark_buffer_dirty() without holding the folio lock, so update the
description to explain why.

Link: https://lkml.kernel.org/r/20240416031754.4076917-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240416031754.4076917-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/page-writeback.c~doc-improve-the-description-of-__folio_mark_dirty
+++ a/mm/page-writeback.c
@@ -2705,11 +2705,15 @@ void folio_account_cleaned(struct folio
  * If warn is true, then emit a warning if the folio is not uptodate and has
  * not been truncated.
  *
- * The caller must hold folio_memcg_lock().  Most callers have the folio
- * locked.  A few have the folio blocked from truncation through other
- * means (eg zap_vma_pages() has it mapped and is holding the page table
- * lock).  This can also be called from mark_buffer_dirty(), which I
- * cannot prove is always protected against truncate.
+ * The caller must hold folio_memcg_lock().  It is the caller's
+ * responsibility to prevent the folio from being truncated while
+ * this function is in progress, although it may have been truncated
+ * before this function is called.  Most callers have the folio locked.
+ * A few have the folio blocked from truncation through other means (e.g.
+ * zap_vma_pages() has it mapped and is holding the page table lock).
+ * When called from mark_buffer_dirty(), the filesystem should hold a
+ * reference to the buffer_head that is being marked dirty, which causes
+ * try_to_free_buffers() to fail.
  */
 void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
 			     int warn)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
proc-rewrite-stable_page_flags-fix-2.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file-fix.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch
proc-convert-gather_stats-to-use-a-folio.patch
proc-convert-smaps_page_accumulate-to-use-a-folio.patch
proc-pass-a-folio-to-smaps_page_accumulate.patch
proc-convert-smaps_pmd_entry-to-use-a-folio.patch
mm-remove-struct-page-from-get_shadow_from_swap_cache.patch
hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch
mm-convert-pagecache_isize_extended-to-use-a-folio.patch
mm-free-non-hugetlb-large-folios-in-a-batch.patch
mm-combine-free_the_page-and-free_unref_page.patch
mm-inline-destroy_large_folio-into-__folio_put_large.patch
mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch
mm-convert-free_zone_device_page-to-free_zone_device_folio.patch
doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch


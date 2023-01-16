Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCD8C46467
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbjAPUGa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbjAPUGE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:06:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EB959D2
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:06:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27372B810A4
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B1AC433D2;
        Mon, 16 Jan 2023 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899559;
        bh=RSN4zDXoKFlE2aRzMt8iyDNZnwMRlfCELwBcKilVNOw=;
        h=Date:To:From:Subject:From;
        b=MVhINfxpPiTDP9XGONkcD4HYpiXfj6ygfd7ZHFzrOnczJBiGIlOQas3zJJFtkXdF4
         lt9wgucMgkAgtmDjQmxUZM0/7wR0gq5oLdohlydAXe87xNFdFG9ItCsGneJeTgqQjn
         p+2I32gYlnGF/TfAB9oLwkVoslKPIyMjM5/RJYQQ=
Date:   Mon, 16 Jan 2023 12:05:59 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-munlock_vma_page.patch added to mm-unstable branch
Message-Id: <20230116200559.C3B1AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove munlock_vma_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-munlock_vma_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-munlock_vma_page.patch

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
Subject: mm: remove munlock_vma_page()
Date: Mon, 16 Jan 2023 19:28:26 +0000

All callers now have a folio and can call munlock_vma_folio().  Update the
documentation to refer to munlock_vma_folio().

Link: https://lkml.kernel.org/r/20230116192827.2146732-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/unevictable-lru.rst~mm-remove-munlock_vma_page
+++ a/Documentation/mm/unevictable-lru.rst
@@ -486,7 +486,7 @@ Before the unevictable/mlock changes, ml
 way, so unmapping them required no processing.
 
 For each PTE (or PMD) being unmapped from a VMA, page_remove_rmap() calls
-munlock_vma_page(), which calls munlock_page() when the VMA is VM_LOCKED
+munlock_vma_folio(), which calls munlock_folio() when the VMA is VM_LOCKED
 (unless it was a PTE mapping of a part of a transparent huge page).
 
 munlock_page() uses the mlock pagevec to batch up work to be done under
@@ -510,7 +510,7 @@ which had been Copied-On-Write from the
 
 Mlocked pages can be munlocked and deleted in this way: like with munmap(),
 for each PTE (or PMD) being unmapped from a VMA, page_remove_rmap() calls
-munlock_vma_page(), which calls munlock_page() when the VMA is VM_LOCKED
+munlock_vma_folio(), which calls munlock_folio() when the VMA is VM_LOCKED
 (unless it was a PTE mapping of a part of a transparent huge page).
 
 However, if there is a racing munlock(), since mlock_vma_pages_range() starts
--- a/kernel/events/uprobes.c~mm-remove-munlock_vma_page
+++ a/kernel/events/uprobes.c
@@ -22,7 +22,6 @@
 #include <linux/swap.h>		/* folio_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
 #include <linux/kdebug.h>	/* notifier mechanism */
-#include "../../mm/internal.h"	/* munlock_vma_page */
 #include <linux/percpu-rwsem.h>
 #include <linux/task_work.h>
 #include <linux/shmem_fs.h>
--- a/mm/internal.h~mm-remove-munlock_vma_page
+++ a/mm/internal.h
@@ -548,7 +548,6 @@ static inline void mlock_vma_folio(struc
 }
 
 void munlock_folio(struct folio *folio);
-
 static inline void munlock_vma_folio(struct folio *folio,
 			struct vm_area_struct *vma, bool compound)
 {
@@ -557,11 +556,6 @@ static inline void munlock_vma_folio(str
 		munlock_folio(folio);
 }
 
-static inline void munlock_vma_page(struct page *page,
-			struct vm_area_struct *vma, bool compound)
-{
-	munlock_vma_folio(page_folio(page), vma, compound);
-}
 void mlock_new_folio(struct folio *folio);
 bool need_mlock_drain(int cpu);
 void mlock_drain_local(void);
@@ -650,8 +644,6 @@ static inline struct file *maybe_unlock_
 }
 #else /* !CONFIG_MMU */
 static inline void unmap_mapping_folio(struct folio *folio) { }
-static inline void munlock_vma_page(struct page *page,
-			struct vm_area_struct *vma, bool compound) { }
 static inline void mlock_new_folio(struct folio *folio) { }
 static inline bool need_mlock_drain(int cpu) { return false; }
 static inline void mlock_drain_local(void) { }
--- a/mm/rmap.c~mm-remove-munlock_vma_page
+++ a/mm/rmap.c
@@ -1431,14 +1431,14 @@ void page_remove_rmap(struct page *page,
 	}
 
 	/*
-	 * It would be tidy to reset PageAnon mapping when fully unmapped,
-	 * but that might overwrite a racing page_add_anon_rmap
-	 * which increments mapcount after us but sets mapping
-	 * before us: so leave the reset to free_pages_prepare,
-	 * and remember that it's only reliable while mapped.
+	 * It would be tidy to reset folio_test_anon mapping when fully
+	 * unmapped, but that might overwrite a racing page_add_anon_rmap
+	 * which increments mapcount after us but sets mapping before us:
+	 * so leave the reset to free_pages_prepare, and remember that
+	 * it's only reliable while mapped.
 	 */
 
-	munlock_vma_page(page, vma, compound);
+	munlock_vma_folio(folio, vma, compound);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch
mm-memcg-add-folio_memcg_check.patch
mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C5FC54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbjAPUGb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbjAPUGE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:06:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E62233C4
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:06:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5FBD6111C
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38310C433D2;
        Mon, 16 Jan 2023 20:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899562;
        bh=bBTD5p4qR1ICuGsRwEfVy8aXzkuAWar11Fkp40O6hgA=;
        h=Date:To:From:Subject:From;
        b=Pc7vPARlPuxSyIH+qZwX/YYDa6Ou7qMAXIZtomfVlnYMdZYyoRzCpCOz89TUuDnu5
         r/62A193ao6fBQupXgHcoFovNjNrBrgSvvP15UtM8vZ4pnRG+u9S5UJfCmGOMFat+Z
         u9ViBW+ZRWNYGBNPKG90rz5VDhPFFyoAHNHvZks0=
Date:   Mon, 16 Jan 2023 12:06:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clean-up-mlock_page-munlock_page-references-in-comments.patch added to mm-unstable branch
Message-Id: <20230116200602.38310C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up mlock_page / munlock_page references in comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-clean-up-mlock_page-munlock_page-references-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-clean-up-mlock_page-munlock_page-references-in-comments.patch

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
Subject: mm: clean up mlock_page / munlock_page references in comments
Date: Mon, 16 Jan 2023 19:28:27 +0000

Change documentation and comments that refer to now-renamed functions.

Link: https://lkml.kernel.org/r/20230116192827.2146732-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/unevictable-lru.rst~mm-clean-up-mlock_page-munlock_page-references-in-comments
+++ a/Documentation/mm/unevictable-lru.rst
@@ -298,7 +298,7 @@ treated as a no-op and mlock_fixup() sim
 If the VMA passes some filtering as described in "Filtering Special VMAs"
 below, mlock_fixup() will attempt to merge the VMA with its neighbors or split
 off a subset of the VMA if the range does not cover the entire VMA.  Any pages
-already present in the VMA are then marked as mlocked by mlock_page() via
+already present in the VMA are then marked as mlocked by mlock_folio() via
 mlock_pte_range() via walk_page_range() via mlock_vma_pages_range().
 
 Before returning from the system call, do_mlock() or mlockall() will call
@@ -373,20 +373,21 @@ Because of the VMA filtering discussed a
 any "special" VMAs.  So, those VMAs will be ignored for munlock.
 
 If the VMA is VM_LOCKED, mlock_fixup() again attempts to merge or split off the
-specified range.  All pages in the VMA are then munlocked by munlock_page() via
+specified range.  All pages in the VMA are then munlocked by munlock_folio() via
 mlock_pte_range() via walk_page_range() via mlock_vma_pages_range() - the same
 function used when mlocking a VMA range, with new flags for the VMA indicating
 that it is munlock() being performed.
 
-munlock_page() uses the mlock pagevec to batch up work to be done under
-lru_lock by  __munlock_page().  __munlock_page() decrements the page's
-mlock_count, and when that reaches 0 it clears PG_mlocked and clears
-PG_unevictable, moving the page from unevictable state to inactive LRU.
+munlock_folio() uses the mlock pagevec to batch up work to be done
+under lru_lock by  __munlock_folio().  __munlock_folio() decrements the
+folio's mlock_count, and when that reaches 0 it clears the mlocked flag
+and clears the unevictable flag, moving the folio from unevictable state
+to the inactive LRU.
 
-But in practice that may not work ideally: the page may not yet have reached
+But in practice that may not work ideally: the folio may not yet have reached
 "the unevictable LRU", or it may have been temporarily isolated from it.  In
 those cases its mlock_count field is unusable and must be assumed to be 0: so
-that the page will be rescued to an evictable LRU, then perhaps be mlocked
+that the folio will be rescued to an evictable LRU, then perhaps be mlocked
 again later if vmscan finds it in a VM_LOCKED VMA.
 
 
@@ -489,15 +490,16 @@ For each PTE (or PMD) being unmapped fro
 munlock_vma_folio(), which calls munlock_folio() when the VMA is VM_LOCKED
 (unless it was a PTE mapping of a part of a transparent huge page).
 
-munlock_page() uses the mlock pagevec to batch up work to be done under
-lru_lock by  __munlock_page().  __munlock_page() decrements the page's
-mlock_count, and when that reaches 0 it clears PG_mlocked and clears
-PG_unevictable, moving the page from unevictable state to inactive LRU.
+munlock_folio() uses the mlock pagevec to batch up work to be done
+under lru_lock by  __munlock_folio().  __munlock_folio() decrements the
+folio's mlock_count, and when that reaches 0 it clears the mlocked flag
+and clears the unevictable flag, moving the folio from unevictable state
+to the inactive LRU.
 
-But in practice that may not work ideally: the page may not yet have reached
+But in practice that may not work ideally: the folio may not yet have reached
 "the unevictable LRU", or it may have been temporarily isolated from it.  In
 those cases its mlock_count field is unusable and must be assumed to be 0: so
-that the page will be rescued to an evictable LRU, then perhaps be mlocked
+that the folio will be rescued to an evictable LRU, then perhaps be mlocked
 again later if vmscan finds it in a VM_LOCKED VMA.
 
 
--- a/mm/memory-failure.c~mm-clean-up-mlock_page-munlock_page-references-in-comments
+++ a/mm/memory-failure.c
@@ -2167,7 +2167,7 @@ try_again:
 	}
 
 	/*
-	 * __munlock_pagevec may clear a writeback page's LRU flag without
+	 * __munlock_folio() may clear a writeback page's LRU flag without
 	 * page_lock. We need wait writeback completion for this page or it
 	 * may trigger vfs BUG while evict inode.
 	 */
--- a/mm/swap.c~mm-clean-up-mlock_page-munlock_page-references-in-comments
+++ a/mm/swap.c
@@ -201,7 +201,7 @@ static void lru_add_fn(struct lruvec *lr
 	 * Is an smp_mb__after_atomic() still required here, before
 	 * folio_evictable() tests the mlocked flag, to rule out the possibility
 	 * of stranding an evictable folio on an unevictable LRU?  I think
-	 * not, because __munlock_page() only clears the mlocked flag
+	 * not, because __munlock_folio() only clears the mlocked flag
 	 * while the LRU lock is held.
 	 *
 	 * (That is not true of __page_cache_release(), and not necessarily
@@ -216,7 +216,7 @@ static void lru_add_fn(struct lruvec *lr
 		folio_set_unevictable(folio);
 		/*
 		 * folio->mlock_count = !!folio_test_mlocked(folio)?
-		 * But that leaves __mlock_page() in doubt whether another
+		 * But that leaves __mlock_folio() in doubt whether another
 		 * actor has already counted the mlock or not.  Err on the
 		 * safe side, underestimate, let page reclaim fix it, rather
 		 * than leaving a page on the unevictable LRU indefinitely.
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


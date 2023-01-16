Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D8AC54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjAPUGE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjAPUGC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:06:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035611722
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:06:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1C05B8109B
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A696C433D2;
        Mon, 16 Jan 2023 20:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899557;
        bh=YcsdeIvuA+0ewThvyP1JC4d1Z6LURYKBVWOltkhHr2M=;
        h=Date:To:From:Subject:From;
        b=gbrVUQhYZLwmCD79db/Vv8olf6enf97NSdDQATlHm9jZR9E1S+hEglWPhxxpgJVPY
         qjb5l+N2eooL307QvAnmuVYjr5R7FVaZPZKiNhfiP1jw4zxFR6sMHBUZw1S9QD3r4E
         ExH9/yIKdssKKTD8/3Ope25SSnDKvJAQW7SQbmbY=
Date:   Mon, 16 Jan 2023 12:05:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-mlock_vma_page.patch added to mm-unstable branch
Message-Id: <20230116200557.5A696C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove mlock_vma_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-mlock_vma_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-mlock_vma_page.patch

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
Subject: mm: remove mlock_vma_page()
Date: Mon, 16 Jan 2023 19:28:25 +0000

All callers now have a folio and can call mlock_vma_folio().  Update the
documentation to refer to mlock_vma_folio().

Link: https://lkml.kernel.org/r/20230116192827.2146732-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/unevictable-lru.rst~mm-remove-mlock_vma_page
+++ a/Documentation/mm/unevictable-lru.rst
@@ -311,7 +311,7 @@ do end up getting faulted into this VM_L
 fault path - which is also how mlock2()'s MLOCK_ONFAULT areas are handled.
 
 For each PTE (or PMD) being faulted into a VMA, the page add rmap function
-calls mlock_vma_page(), which calls mlock_folio() when the VMA is VM_LOCKED
+calls mlock_vma_folio(), which calls mlock_folio() when the VMA is VM_LOCKED
 (unless it is a PTE mapping of a part of a transparent huge page).  Or when
 it is a newly allocated anonymous page, folio_add_lru_vma() calls
 mlock_new_folio() instead: similar to mlock_folio(), but can make better
@@ -413,7 +413,7 @@ However, since mlock_vma_pages_range() s
 before mlocking any pages already present, if one of those pages were migrated
 before mlock_pte_range() reached it, it would get counted twice in mlock_count.
 To prevent that, mlock_vma_pages_range() temporarily marks the VMA as VM_IO,
-so that mlock_vma_page() will skip it.
+so that mlock_vma_folio() will skip it.
 
 To complete page migration, we place the old and new pages back onto the LRU
 afterwards.  The "unneeded" page - old page on success, new page on failure -
@@ -552,6 +552,6 @@ and node unevictable list.
 
 rmap's folio_referenced_one(), called via vmscan's shrink_active_list() or
 shrink_page_list(), and rmap's try_to_unmap_one() called via shrink_page_list(),
-check for (3) pages still mapped into VM_LOCKED VMAs, and call mlock_vma_page()
+check for (3) pages still mapped into VM_LOCKED VMAs, and call mlock_vma_folio()
 to correct them.  Such pages are culled to the unevictable list when released
 by the shrinker.
--- a/mm/internal.h~mm-remove-mlock_vma_page
+++ a/mm/internal.h
@@ -518,7 +518,7 @@ extern long faultin_vma_page_range(struc
 extern int mlock_future_check(struct mm_struct *mm, unsigned long flags,
 			      unsigned long len);
 /*
- * mlock_vma_page() and munlock_vma_page():
+ * mlock_vma_folio() and munlock_vma_folio():
  * should be called with vma's mmap_lock held for read or write,
  * under page table lock for the pte/pmd being added or removed.
  *
@@ -547,12 +547,6 @@ static inline void mlock_vma_folio(struc
 		mlock_folio(folio);
 }
 
-static inline void mlock_vma_page(struct page *page,
-			struct vm_area_struct *vma, bool compound)
-{
-	mlock_vma_folio(page_folio(page), vma, compound);
-}
-
 void munlock_folio(struct folio *folio);
 
 static inline void munlock_vma_folio(struct folio *folio,
@@ -656,8 +650,6 @@ static inline struct file *maybe_unlock_
 }
 #else /* !CONFIG_MMU */
 static inline void unmap_mapping_folio(struct folio *folio) { }
-static inline void mlock_vma_page(struct page *page,
-			struct vm_area_struct *vma, bool compound) { }
 static inline void munlock_vma_page(struct page *page,
 			struct vm_area_struct *vma, bool compound) { }
 static inline void mlock_new_folio(struct folio *folio) { }
--- a/mm/mlock.c~mm-remove-mlock_vma_page
+++ a/mm/mlock.c
@@ -370,9 +370,9 @@ static void mlock_vma_pages_range(struct
 	/*
 	 * There is a slight chance that concurrent page migration,
 	 * or page reclaim finding a page of this now-VM_LOCKED vma,
-	 * will call mlock_vma_page() and raise page's mlock_count:
+	 * will call mlock_vma_folio() and raise page's mlock_count:
 	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_page() with VM_IO,
+	 * Communicate this danger to mlock_vma_folio() with VM_IO,
 	 * which is a VM_SPECIAL flag not allowed on VM_LOCKED vmas.
 	 * mmap_lock is held in write mode here, so this weird
 	 * combination should not be visible to other mmap_lock users;
--- a/mm/rmap.c~mm-remove-mlock_vma_page
+++ a/mm/rmap.c
@@ -1260,7 +1260,7 @@ void page_add_anon_rmap(struct page *pag
 			__page_check_anon_rmap(page, vma, address);
 	}
 
-	mlock_vma_page(page, vma, compound);
+	mlock_vma_folio(folio, vma, compound);
 }
 
 /**
@@ -1351,7 +1351,7 @@ void page_add_file_rmap(struct page *pag
 	if (nr)
 		__lruvec_stat_mod_folio(folio, NR_FILE_MAPPED, nr);
 
-	mlock_vma_page(page, vma, compound);
+	mlock_vma_folio(folio, vma, compound);
 }
 
 /**
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


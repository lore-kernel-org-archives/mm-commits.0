Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1F5C54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjAPUGp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbjAPUGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:06:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F2A24112
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:06:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 04E9FCE109C
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C9EC433EF;
        Mon, 16 Jan 2023 20:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899587;
        bh=mzoRhT1F0BXlzKxK3iIx/NpToHznwGIbMNc9KH2q0kU=;
        h=Date:To:From:Subject:From;
        b=BggBKkWsQWpS0fQLuuZa6K9ymlx8m2Gou/PF4t5awszoRxUKEbf0xMynmTyCyCZEe
         e8p+vIgicCBULCQxwCkOaDs6z0Ud7tvklpNzZoAkhtyAikHmd0ixM8zGOZD+FQpkUo
         YTgSC0kM23Xz2Mzd8A4vfHC7Hg56iStQhPIBtRXI=
Date:   Mon, 16 Jan 2023 12:06:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rmap-add-folio-parameter-to-__page_set_anon_rmap.patch added to mm-unstable branch
Message-Id: <20230116200627.31C9EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: add folio parameter to __page_set_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     rmap-add-folio-parameter-to-__page_set_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rmap-add-folio-parameter-to-__page_set_anon_rmap.patch

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
Subject: rmap: add folio parameter to __page_set_anon_rmap()
Date: Mon, 16 Jan 2023 19:29:59 +0000

Avoid the compound_head() call in PageAnon() by passing in the folio that
all callers have.  Also save me from wondering whether page->mapping can
ever be overwritten on a tail page (I don't think it can, but I'm not 100%
sure).

Link: https://lkml.kernel.org/r/20230116192959.2147032-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/rmap.c~rmap-add-folio-parameter-to-__page_set_anon_rmap
+++ a/mm/rmap.c
@@ -1131,19 +1131,20 @@ void page_move_anon_rmap(struct page *pa
 
 /**
  * __page_set_anon_rmap - set up new anonymous rmap
- * @page:	Page or Hugepage to add to rmap
+ * @folio:	Folio which contains page.
+ * @page:	Page to add to rmap.
  * @vma:	VM area to add page to.
  * @address:	User virtual address of the mapping	
  * @exclusive:	the page is exclusively owned by the current process
  */
-static void __page_set_anon_rmap(struct page *page,
+static void __page_set_anon_rmap(struct folio *folio, struct page *page,
 	struct vm_area_struct *vma, unsigned long address, int exclusive)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 
 	BUG_ON(!anon_vma);
 
-	if (PageAnon(page))
+	if (folio_test_anon(folio))
 		goto out;
 
 	/*
@@ -1155,14 +1156,14 @@ static void __page_set_anon_rmap(struct
 		anon_vma = anon_vma->root;
 
 	/*
-	 * page_idle does a lockless/optimistic rmap scan on page->mapping.
+	 * page_idle does a lockless/optimistic rmap scan on folio->mapping.
 	 * Make sure the compiler doesn't split the stores of anon_vma and
 	 * the PAGE_MAPPING_ANON type identifier, otherwise the rmap code
 	 * could mistake the mapping for a struct address_space and crash.
 	 */
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
-	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
-	page->index = linear_page_index(vma, address);
+	WRITE_ONCE(folio->mapping, (struct address_space *) anon_vma);
+	folio->index = linear_page_index(vma, address);
 out:
 	if (exclusive)
 		SetPageAnonExclusive(page);
@@ -1254,7 +1255,7 @@ void page_add_anon_rmap(struct page *pag
 	if (likely(!folio_test_ksm(folio))) {
 		/* address might be in next vma when migration races vma_adjust */
 		if (first)
-			__page_set_anon_rmap(page, vma, address,
+			__page_set_anon_rmap(folio, page, vma, address,
 					     !!(flags & RMAP_EXCLUSIVE));
 		else
 			__page_check_anon_rmap(page, vma, address);
@@ -1297,7 +1298,7 @@ void folio_add_new_anon_rmap(struct foli
 	}
 
 	__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
-	__page_set_anon_rmap(&folio->page, vma, address, 1);
+	__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
 }
 
 /**
@@ -2542,7 +2543,7 @@ void hugepage_add_anon_rmap(struct page
 	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
 	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
 	if (first)
-		__page_set_anon_rmap(page, vma, address,
+		__page_set_anon_rmap(folio, page, vma, address,
 				     !!(flags & RMAP_EXCLUSIVE));
 }
 
@@ -2555,6 +2556,6 @@ void hugepage_add_new_anon_rmap(struct p
 	/* increment count (starts at -1) */
 	atomic_set(&folio->_entire_mapcount, 0);
 	folio_clear_hugetlb_restore_reserve(folio);
-	__page_set_anon_rmap(page, vma, address, 1);
+	__page_set_anon_rmap(folio, page, vma, address, 1);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
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
rmap-add-folio-parameter-to-__page_set_anon_rmap.patch


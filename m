Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE5DC54EBC
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjAKU7G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjAKU6m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:58:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3F91DF0C
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:58:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCE5C61E5D
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C98FC433D2;
        Wed, 11 Jan 2023 20:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470711;
        bh=kv2StiLvxy7mUDUng4WDtcdAu6qCMchxs1749pIthls=;
        h=Date:To:From:Subject:From;
        b=Pb1EMe+UiSAv1fPYByWBs0xsZ0c9x1yAtFHy7QNeXEYH826g/Wu4g3BpIKNfr5u1l
         BcP6s+WZ0TEQR3ZDKcjuQ9++FYt+bvPDd1r1ILpDOEV02kcD+Hq7d3YdThK3EOEklg
         9M2pYh6/zZ0KEO/8hha6JzwfDz68nu9fVOncu5jk=
Date:   Wed, 11 Jan 2023 12:58:30 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch added to mm-unstable branch
Message-Id: <20230111205831.2C98FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert total_compound_mapcount() to folio_total_mapcount()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch

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
Subject: mm: convert total_compound_mapcount() to folio_total_mapcount()
Date: Wed, 11 Jan 2023 14:28:50 +0000

Instead of enforcing that the argument must be a head page by naming,
enforce it with the compiler by making it a folio.  Also rename the
counter in struct folio from _compound_mapcount to _entire_mapcount.

Link: https://lkml.kernel.org/r/20230111142915.1001531-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    6 +++---
 include/linux/mm_types.h |    6 +++---
 mm/rmap.c                |   21 ++++++++++-----------
 3 files changed, 16 insertions(+), 17 deletions(-)

--- a/include/linux/mm.h~mm-convert-total_compound_mapcount-to-folio_total_mapcount
+++ a/include/linux/mm.h
@@ -871,7 +871,7 @@ static inline int page_mapcount(struct p
 	return head_compound_mapcount(page) + mapcount;
 }
 
-int total_compound_mapcount(struct page *head);
+int folio_total_mapcount(struct folio *folio);
 
 /**
  * folio_mapcount() - Calculate the number of mappings of this folio.
@@ -888,14 +888,14 @@ static inline int folio_mapcount(struct
 {
 	if (likely(!folio_test_large(folio)))
 		return atomic_read(&folio->_mapcount) + 1;
-	return total_compound_mapcount(&folio->page);
+	return folio_total_mapcount(folio);
 }
 
 static inline int total_mapcount(struct page *page)
 {
 	if (likely(!PageCompound(page)))
 		return atomic_read(&page->_mapcount) + 1;
-	return total_compound_mapcount(compound_head(page));
+	return folio_total_mapcount(page_folio(page));
 }
 
 static inline bool folio_large_is_mapped(struct folio *folio)
--- a/include/linux/mm_types.h~mm-convert-total_compound_mapcount-to-folio_total_mapcount
+++ a/include/linux/mm_types.h
@@ -306,7 +306,7 @@ static inline struct page *encoded_page_
  * @_head_1: Points to the folio.  Do not use.
  * @_folio_dtor: Which destructor to use for this folio.
  * @_folio_order: Do not use directly, call folio_order().
- * @_compound_mapcount: Do not use directly, call folio_entire_mapcount().
+ * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_nr_pages_mapped: Do not use directly, call folio_mapcount().
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
  * @_folio_nr_pages: Do not use directly, call folio_nr_pages().
@@ -360,7 +360,7 @@ struct folio {
 			unsigned long _head_1;
 			unsigned char _folio_dtor;
 			unsigned char _folio_order;
-			atomic_t _compound_mapcount;
+			atomic_t _entire_mapcount;
 			atomic_t _nr_pages_mapped;
 			atomic_t _pincount;
 #ifdef CONFIG_64BIT
@@ -403,7 +403,7 @@ FOLIO_MATCH(flags, _flags_1);
 FOLIO_MATCH(compound_head, _head_1);
 FOLIO_MATCH(compound_dtor, _folio_dtor);
 FOLIO_MATCH(compound_order, _folio_order);
-FOLIO_MATCH(compound_mapcount, _compound_mapcount);
+FOLIO_MATCH(compound_mapcount, _entire_mapcount);
 FOLIO_MATCH(subpages_mapcount, _nr_pages_mapped);
 FOLIO_MATCH(compound_pincount, _pincount);
 #ifdef CONFIG_64BIT
--- a/mm/rmap.c~mm-convert-total_compound_mapcount-to-folio_total_mapcount
+++ a/mm/rmap.c
@@ -1078,27 +1078,26 @@ int pfn_mkclean_range(unsigned long pfn,
 	return page_vma_mkclean_one(&pvmw);
 }
 
-int total_compound_mapcount(struct page *head)
+int folio_total_mapcount(struct folio *folio)
 {
-	struct folio *folio = (struct folio *)head;
-	int mapcount = head_compound_mapcount(head);
-	int nr_subpages;
+	int mapcount = folio_entire_mapcount(folio);
+	int nr_pages;
 	int i;
 
-	/* In the common case, avoid the loop when no subpages mapped by PTE */
+	/* In the common case, avoid the loop when no pages mapped by PTE */
 	if (folio_nr_pages_mapped(folio) == 0)
 		return mapcount;
 	/*
-	 * Add all the PTE mappings of those subpages mapped by PTE.
-	 * Limit the loop, knowing that only subpages_mapcount are mapped?
+	 * Add all the PTE mappings of those pages mapped by PTE.
+	 * Limit the loop to folio_nr_pages_mapped()?
 	 * Perhaps: given all the raciness, that may be a good or a bad idea.
 	 */
-	nr_subpages = thp_nr_pages(head);
-	for (i = 0; i < nr_subpages; i++)
-		mapcount += atomic_read(&head[i]._mapcount);
+	nr_pages = folio_nr_pages(folio);
+	for (i = 0; i < nr_pages; i++)
+		mapcount += atomic_read(&folio_page(folio, i)->_mapcount);
 
 	/* But each of those _mapcounts was based on -1 */
-	mapcount += nr_subpages;
+	mapcount += nr_pages;
 	return mapcount;
 }
 
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
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
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


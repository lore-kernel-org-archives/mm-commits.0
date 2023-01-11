Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCE2C54EBC
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjAKU7e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbjAKU7P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:59:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D919E1DF0C
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:59:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F068FCE1CFA
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F180C433D2;
        Wed, 11 Jan 2023 20:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470749;
        bh=60aRBQW3sQDHTBgyLsoc76dw0Ol1QN4apbeH/oOhIw4=;
        h=Date:To:From:Subject:From;
        b=qtMxGEyLx+eSRIBtN3gHoQ4l25FIfkrJ4oD51rQTrzJRG0OowDLBXdmEHAVKQqmiz
         tjqXd4jyE5PKwfcZ0psCZGDjNtgvkcDOLcUZUvjUzBeyWXHyliAf06mf+cGb89r4Vz
         ni1LnCaoFp6qxgEbT35RL4ujTX1Z7+6yZ5mkQN8k=
Date:   Wed, 11 Jan 2023 12:59:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-page_deferred_list.patch added to mm-unstable branch
Message-Id: <20230111205909.1F180C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: remove page_deferred_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-remove-page_deferred_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-page_deferred_list.patch

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
Subject: mm/huge_memory: remove page_deferred_list()
Date: Wed, 11 Jan 2023 14:29:11 +0000

Use folio->_deferred_list directly.

Link: https://lkml.kernel.org/r/20230111142915.1001531-26-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    8 --------
 mm/huge_memory.c        |   34 +++++++++++++++++-----------------
 2 files changed, 17 insertions(+), 25 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-remove-page_deferred_list
+++ a/include/linux/huge_mm.h
@@ -293,14 +293,6 @@ static inline bool thp_migration_support
 	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
 }
 
-static inline struct list_head *page_deferred_list(struct page *page)
-{
-	struct folio *folio = (struct folio *)page;
-
-	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
-	return &folio->_deferred_list;
-}
-
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
--- a/mm/huge_memory.c~mm-huge_memory-remove-page_deferred_list
+++ a/mm/huge_memory.c
@@ -580,12 +580,10 @@ static inline struct deferred_split *get
 
 void prep_transhuge_page(struct page *page)
 {
-	/*
-	 * we use page->mapping and page->index in second tail page
-	 * as list_head: assuming THP order >= 2
-	 */
+	struct folio *folio = (struct folio *)page;
 
-	INIT_LIST_HEAD(page_deferred_list(page));
+	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
+	INIT_LIST_HEAD(&folio->_deferred_list);
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
@@ -2802,13 +2800,14 @@ out:
 
 void free_transhuge_page(struct page *page)
 {
+	struct folio *folio = (struct folio *)page;
 	struct deferred_split *ds_queue = get_deferred_split_queue(page);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	if (!list_empty(page_deferred_list(page))) {
+	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
-		list_del(page_deferred_list(page));
+		list_del(&folio->_deferred_list);
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 	free_compound_page(page);
@@ -2816,38 +2815,39 @@ void free_transhuge_page(struct page *pa
 
 void deferred_split_huge_page(struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	struct deferred_split *ds_queue = get_deferred_split_queue(page);
 #ifdef CONFIG_MEMCG
-	struct mem_cgroup *memcg = page_memcg(compound_head(page));
+	struct mem_cgroup *memcg = folio_memcg(folio);
 #endif
 	unsigned long flags;
 
-	VM_BUG_ON_PAGE(!PageTransHuge(page), page);
+	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
 
 	/*
 	 * The try_to_unmap() in page reclaim path might reach here too,
 	 * this may cause a race condition to corrupt deferred split queue.
-	 * And, if page reclaim is already handling the same page, it is
+	 * And, if page reclaim is already handling the same folio, it is
 	 * unnecessary to handle it again in shrinker.
 	 *
-	 * Check PageSwapCache to determine if the page is being
-	 * handled by page reclaim since THP swap would add the page into
+	 * Check the swapcache flag to determine if the folio is being
+	 * handled by page reclaim since THP swap would add the folio into
 	 * swap cache before calling try_to_unmap().
 	 */
-	if (PageSwapCache(page))
+	if (folio_test_swapcache(folio))
 		return;
 
-	if (!list_empty(page_deferred_list(page)))
+	if (!list_empty(&folio->_deferred_list))
 		return;
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	if (list_empty(page_deferred_list(page))) {
+	if (list_empty(&folio->_deferred_list)) {
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
-		list_add_tail(page_deferred_list(page), &ds_queue->split_queue);
+		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
 		if (memcg)
-			set_shrinker_bit(memcg, page_to_nid(page),
+			set_shrinker_bit(memcg, folio_nid(folio),
 					 deferred_split_shrinker.id);
 #endif
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


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB37DC46467
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbjAKU7c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbjAKU7N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:59:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B38C11
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:59:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1A4561E4F
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E0EC433F0;
        Wed, 11 Jan 2023 20:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470751;
        bh=BhNZCVbZCA77M0uTglQ0VOEIoVtyhoKgAdLwloeAaNA=;
        h=Date:To:From:Subject:From;
        b=hwP9YzE1XVsuf/7sMNR3Zx8wh9g0jDBaw3hvG3EIQ88nQYmQf/S0g4ZSj6FuxmIvI
         DhwKMfN9SY3dYsV5SXufNQcX3uCjaP6XeWIRFnzxRzEXh34Nm1phtHD67da/tXSpzL
         Xn+GC5/LfWY8fX9ILmAcIUTCrl/WlTviWo+F1Yac=
Date:   Wed, 11 Jan 2023 12:59:10 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230111205911.09E0EC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: convert get_deferred_split_queue() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch

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
Subject: mm/huge_memory: convert get_deferred_split_queue() to take a folio
Date: Wed, 11 Jan 2023 14:29:12 +0000

Removes a few calls to compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-27-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio
+++ a/mm/huge_memory.c
@@ -559,10 +559,11 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 }
 
 #ifdef CONFIG_MEMCG
-static inline struct deferred_split *get_deferred_split_queue(struct page *page)
+static inline
+struct deferred_split *get_deferred_split_queue(struct folio *folio)
 {
-	struct mem_cgroup *memcg = page_memcg(compound_head(page));
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
+	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
 
 	if (memcg)
 		return &memcg->deferred_split_queue;
@@ -570,9 +571,10 @@ static inline struct deferred_split *get
 		return &pgdat->deferred_split_queue;
 }
 #else
-static inline struct deferred_split *get_deferred_split_queue(struct page *page)
+static inline
+struct deferred_split *get_deferred_split_queue(struct folio *folio)
 {
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
+	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
 
 	return &pgdat->deferred_split_queue;
 }
@@ -2650,7 +2652,7 @@ bool can_split_folio(struct folio *folio
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct folio *folio = page_folio(page);
-	struct deferred_split *ds_queue = get_deferred_split_queue(&folio->page);
+	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
@@ -2801,7 +2803,7 @@ out:
 void free_transhuge_page(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
-	struct deferred_split *ds_queue = get_deferred_split_queue(page);
+	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
@@ -2816,7 +2818,7 @@ void free_transhuge_page(struct page *pa
 void deferred_split_huge_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
-	struct deferred_split *ds_queue = get_deferred_split_queue(page);
+	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup *memcg = folio_memcg(folio);
 #endif
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


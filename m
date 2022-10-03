Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105DCC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJCVIP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJCVGV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D104D14E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 171A9B81122
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5C0C433D7;
        Mon,  3 Oct 2022 21:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831135;
        bh=qt7bfX/HC0OEztb+7CmjSk0bERfkCCkrS8+FEltH4hA=;
        h=Date:To:From:Subject:From;
        b=nFPZorT3aCA1skN9nJUWUDR3T0kE+1cJ7DIjjUfQDysY+rOwSrM+YNXg1mM91cXAR
         88HIC4IwYNxE9r22WCfOfvj8u9vrx2kxffPeKqnJT+PQdGBtskEgBrAtD+7ILk65LX
         vYSQ3z+S2OhFWn6rTmgH9VsO5Fc9KYxP82JlJ1Lc=
Date:   Mon, 03 Oct 2022 14:05:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210535.BC5C0C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: huge_memory: convert split_huge_page_to_list() to use a folio
has been removed from the -mm tree.  Its filename was
     huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: huge_memory: convert split_huge_page_to_list() to use a folio
Date: Fri, 2 Sep 2022 20:46:48 +0100

Saves many calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-53-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   49 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

--- a/mm/huge_memory.c~huge_memory-convert-split_huge_page_to_list-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -2622,27 +2622,26 @@ bool can_split_folio(struct folio *folio
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct folio *folio = page_folio(page);
-	struct page *head = &folio->page;
-	struct deferred_split *ds_queue = get_deferred_split_queue(head);
-	XA_STATE(xas, &head->mapping->i_pages, head->index);
+	struct deferred_split *ds_queue = get_deferred_split_queue(&folio->page);
+	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	int extra_pins, ret;
 	pgoff_t end;
 	bool is_hzp;
 
-	VM_BUG_ON_PAGE(!PageLocked(head), head);
-	VM_BUG_ON_PAGE(!PageCompound(head), head);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
-	is_hzp = is_huge_zero_page(head);
-	VM_WARN_ON_ONCE_PAGE(is_hzp, head);
+	is_hzp = is_huge_zero_page(&folio->page);
+	VM_WARN_ON_ONCE_FOLIO(is_hzp, folio);
 	if (is_hzp)
 		return -EBUSY;
 
-	if (PageWriteback(head))
+	if (folio_test_writeback(folio))
 		return -EBUSY;
 
-	if (PageAnon(head)) {
+	if (folio_test_anon(folio)) {
 		/*
 		 * The caller does not necessarily hold an mmap_lock that would
 		 * prevent the anon_vma disappearing so we first we take a
@@ -2651,7 +2650,7 @@ int split_huge_page_to_list(struct page
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = page_get_anon_vma(head);
+		anon_vma = page_get_anon_vma(&folio->page);
 		if (!anon_vma) {
 			ret = -EBUSY;
 			goto out;
@@ -2662,7 +2661,7 @@ int split_huge_page_to_list(struct page
 	} else {
 		gfp_t gfp;
 
-		mapping = head->mapping;
+		mapping = folio->mapping;
 
 		/* Truncated ? */
 		if (!mapping) {
@@ -2679,7 +2678,7 @@ int split_huge_page_to_list(struct page
 			goto out;
 		}
 
-		xas_split_alloc(&xas, head, compound_order(head), gfp);
+		xas_split_alloc(&xas, folio, folio_order(folio), gfp);
 		if (xas_error(&xas)) {
 			ret = xas_error(&xas);
 			goto out;
@@ -2693,7 +2692,7 @@ int split_huge_page_to_list(struct page
 		 * but on 32-bit, i_size_read() takes an irq-unsafe seqlock,
 		 * which cannot be nested inside the page tree lock. So note
 		 * end now: i_size itself may be changed at any moment, but
-		 * head page lock is good enough to serialize the trimming.
+		 * folio lock is good enough to serialize the trimming.
 		 */
 		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
 		if (shmem_mapping(mapping))
@@ -2709,38 +2708,38 @@ int split_huge_page_to_list(struct page
 		goto out_unlock;
 	}
 
-	unmap_page(head);
+	unmap_page(&folio->page);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
 	if (mapping) {
 		/*
-		 * Check if the head page is present in page cache.
-		 * We assume all tail are present too, if head is there.
+		 * Check if the folio is present in page cache.
+		 * We assume all tail are present too, if folio is there.
 		 */
 		xas_lock(&xas);
 		xas_reset(&xas);
-		if (xas_load(&xas) != head)
+		if (xas_load(&xas) != folio)
 			goto fail;
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
-	if (page_ref_freeze(head, 1 + extra_pins)) {
-		if (!list_empty(page_deferred_list(head))) {
+	if (folio_ref_freeze(folio, 1 + extra_pins)) {
+		if (!list_empty(page_deferred_list(&folio->page))) {
 			ds_queue->split_queue_len--;
-			list_del(page_deferred_list(head));
+			list_del(page_deferred_list(&folio->page));
 		}
 		spin_unlock(&ds_queue->split_queue_lock);
 		if (mapping) {
-			int nr = thp_nr_pages(head);
+			int nr = folio_nr_pages(folio);
 
-			xas_split(&xas, head, thp_order(head));
-			if (PageSwapBacked(head)) {
-				__mod_lruvec_page_state(head, NR_SHMEM_THPS,
+			xas_split(&xas, folio, folio_order(folio));
+			if (folio_test_swapbacked(folio)) {
+				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
 							-nr);
 			} else {
-				__mod_lruvec_page_state(head, NR_FILE_THPS,
+				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
 							-nr);
 				filemap_nr_thps_dec(mapping);
 			}
_

Patches currently in -mm which might be from willy@infradead.org are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D46C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbjBCGg6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjBCGgE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C467E691
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0225ECE2EA3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F5AC4339C;
        Fri,  3 Feb 2023 06:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406159;
        bh=+91FyA3WajVoa093xNIkibJR+x08RguWtbV2aqSMGaY=;
        h=Date:To:From:Subject:From;
        b=g4jn2X0vAcwTpi69Wy2AqT9q/5ZOYzJqyrLZM/XVypKgdxYvsY1uQ6vvwtm0fd2ZP
         BJNmex4LXVdlNLwZozpJ1sPLX1icvOMXowFbB1bDIAlYQinWAvCdoSwqrSNKaGVigI
         OVHNKCYG/F+m/J2mVkXBOaxnYZKSTtJsFsXQN6p0=
Date:   Thu, 02 Feb 2023 22:35:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-remove-page_deferred_list.patch removed from -mm tree
Message-Id: <20230203063559.46F5AC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: remove page_deferred_list()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-page_deferred_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/huge_memory: remove page_deferred_list()
Date: Wed, 11 Jan 2023 14:29:11 +0000

Use folio->_deferred_list directly.

Link: https://lkml.kernel.org/r/20230111142915.1001531-26-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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



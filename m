Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550ABC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjBCGgl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbjBCGgA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BEB80178
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7D8061D1D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C46C433D2;
        Fri,  3 Feb 2023 06:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406158;
        bh=iYzmnYmeIYB/3AdtUCVfr8D+WeS81xdi4rcJBvx3F6c=;
        h=Date:To:From:Subject:From;
        b=v3vPFfIR9UAkT1yMxPMLlb625aXvcbZHKV3ndpAKt9BSsSjMf72Rh8iLI47V93Q+4
         XO7zhlF0r28raFyYP4e8s+Z0dc4usTme+V8YoCJUi+XdIqd5t5/44pBnr8PKCCEN2H
         I6mugE4GoRRfQAscrRoy9g1YNSXq/obupoETlDQ4=
Date:   Thu, 02 Feb 2023 22:35:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-page-deferred_list-to-folio-_deferred_list.patch removed from -mm tree
Message-Id: <20230203063558.49C46C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move page->deferred_list to folio->_deferred_list
has been removed from the -mm tree.  Its filename was
     mm-move-page-deferred_list-to-folio-_deferred_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move page->deferred_list to folio->_deferred_list
Date: Wed, 11 Jan 2023 14:29:10 +0000

Remove the entire block of definitions for the second tail page, and add
the deferred list to the struct folio.  This actually moves _deferred_list
to a different offset in struct folio because I don't see a need to
include the padding.

This lets us use list_for_each_entry_safe() in deferred_split_scan()
and avoid a number of calls to compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-25-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/huge_mm.h~mm-move-page-deferred_list-to-folio-_deferred_list
+++ a/include/linux/huge_mm.h
@@ -295,11 +295,10 @@ static inline bool thp_migration_support
 
 static inline struct list_head *page_deferred_list(struct page *page)
 {
-	/*
-	 * See organization of tail pages of compound page in
-	 * "struct page" definition.
-	 */
-	return &page[2].deferred_list;
+	struct folio *folio = (struct folio *)page;
+
+	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
+	return &folio->_deferred_list;
 }
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
--- a/include/linux/mm_types.h~mm-move-page-deferred_list-to-folio-_deferred_list
+++ a/include/linux/mm_types.h
@@ -141,12 +141,6 @@ struct page {
 		struct {	/* Tail pages of compound page */
 			unsigned long compound_head;	/* Bit zero is set */
 		};
-		struct {	/* Second tail page of transparent huge page */
-			unsigned long _compound_pad_1;	/* compound_head */
-			unsigned long _compound_pad_2;
-			/* For both global and memcg */
-			struct list_head deferred_list;
-		};
 		struct {	/* Second tail page of hugetlb page */
 			unsigned long _hugetlb_pad_1;	/* compound_head */
 			void *hugetlb_subpool;
@@ -302,6 +296,7 @@ static inline struct page *encoded_page_
  * @_hugetlb_cgroup: Do not use directly, use accessor in hugetlb_cgroup.h.
  * @_hugetlb_cgroup_rsvd: Do not use directly, use accessor in hugetlb_cgroup.h.
  * @_hugetlb_hwpoison: Do not use directly, call raw_hwp_list_head().
+ * @_deferred_list: Folios to be split under memory pressure.
  *
  * A folio is a physically, virtually and logically contiguous set
  * of bytes.  It is a power-of-two in size, and it is aligned to that
@@ -368,6 +363,13 @@ struct folio {
 			void *_hugetlb_hwpoison;
 	/* private: the union with struct page is transitional */
 		};
+		struct {
+			unsigned long _flags_2a;
+			unsigned long _head_2a;
+	/* public: */
+			struct list_head _deferred_list;
+	/* private: the union with struct page is transitional */
+		};
 		struct page __page_2;
 	};
 };
--- a/mm/huge_memory.c~mm-move-page-deferred_list-to-folio-_deferred_list
+++ a/mm/huge_memory.c
@@ -2756,9 +2756,9 @@ int split_huge_page_to_list(struct page
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
-		if (!list_empty(page_deferred_list(&folio->page))) {
+		if (!list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
-			list_del(page_deferred_list(&folio->page));
+			list_del(&folio->_deferred_list);
 		}
 		spin_unlock(&ds_queue->split_queue_lock);
 		if (mapping) {
@@ -2873,8 +2873,8 @@ static unsigned long deferred_split_scan
 	struct pglist_data *pgdata = NODE_DATA(sc->nid);
 	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
 	unsigned long flags;
-	LIST_HEAD(list), *pos, *next;
-	struct page *page;
+	LIST_HEAD(list);
+	struct folio *folio, *next;
 	int split = 0;
 
 #ifdef CONFIG_MEMCG
@@ -2884,14 +2884,13 @@ static unsigned long deferred_split_scan
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	/* Take pin on all head pages to avoid freeing them under us */
-	list_for_each_safe(pos, next, &ds_queue->split_queue) {
-		page = list_entry((void *)pos, struct page, deferred_list);
-		page = compound_head(page);
-		if (get_page_unless_zero(page)) {
-			list_move(page_deferred_list(page), &list);
+	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
+							_deferred_list) {
+		if (folio_try_get(folio)) {
+			list_move(&folio->_deferred_list, &list);
 		} else {
-			/* We lost race with put_compound_page() */
-			list_del_init(page_deferred_list(page));
+			/* We lost race with folio_put() */
+			list_del_init(&folio->_deferred_list);
 			ds_queue->split_queue_len--;
 		}
 		if (!--sc->nr_to_scan)
@@ -2899,16 +2898,15 @@ static unsigned long deferred_split_scan
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
-	list_for_each_safe(pos, next, &list) {
-		page = list_entry((void *)pos, struct page, deferred_list);
-		if (!trylock_page(page))
+	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
+		if (!folio_trylock(folio))
 			goto next;
 		/* split_huge_page() removes page from list on success */
-		if (!split_huge_page(page))
+		if (!split_folio(folio))
 			split++;
-		unlock_page(page);
+		folio_unlock(folio);
 next:
-		put_page(page);
+		folio_put(folio);
 	}
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
_

Patches currently in -mm which might be from willy@infradead.org are



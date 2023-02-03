Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1ABC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjBCGgD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjBCGfl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D8C23D9C
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51495CE2EA3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70406C433EF;
        Fri,  3 Feb 2023 06:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406136;
        bh=QH8m7i6zhgqE2rBDAhGZuOI4bQJ+zI7kpjnOdy1bSPk=;
        h=Date:To:From:Subject:From;
        b=QaJsXiSbFhkK0njPuF33LvE2ijMH38rjebpEh0iIULta+MeoiiIl32Xso8TmXbf0o
         wC76N1HLTrWBrkS8aAQQX6Pgppl/p0llbU6cqHGVO7+PTSq0gWOz33BtgsB8iNtJBi
         JfkhKQ1dH+W40utFZQItcQxnJr1IO2mwbtpsWeek=
Date:   Thu, 02 Feb 2023 22:35:35 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch removed from -mm tree
Message-Id: <20230203063536.70406C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert total_compound_mapcount() to folio_total_mapcount()
has been removed from the -mm tree.  Its filename was
     mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



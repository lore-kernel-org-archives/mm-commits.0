Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BA5C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjBCGld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjBCGkW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8E48F509
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AE5061D99
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30ACC4339C;
        Fri,  3 Feb 2023 06:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406250;
        bh=tMJVSxw+KJlONKbvFNfEZGf7MFoeEfVo36afXbj9KNc=;
        h=Date:To:From:Subject:From;
        b=VUWDz8ng4CKHKlyEIBqXy5RFZYe62P5UiCs/nt22ijcZIz+zFthKeajfz6ee3xz4e
         QjBSrF/vxmld9ThZKwOwWj885L3JnPZgcmTbFP3hJMFszn13dImOiH3hON+bS9kP74
         Yexl4EPMekI2piSkF8T3I8vZMhDYPksuigml95Q4=
Date:   Thu, 02 Feb 2023 22:37:29 -0800
To:     mm-commits@vger.kernel.org, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-find_get_pages_range_tag.patch removed from -mm tree
Message-Id: <20230203063729.E30ACC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: remove find_get_pages_range_tag()
has been removed from the -mm tree.  Its filename was
     filemap-remove-find_get_pages_range_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: filemap: remove find_get_pages_range_tag()
Date: Wed, 4 Jan 2023 13:14:48 -0800

All callers to find_get_pages_range_tag(), find_get_pages_tag(),
pagevec_lookup_range_tag(), and pagevec_lookup_tag() have been removed.

Link: https://lkml.kernel.org/r/20230104211448.4804-24-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/pagemap.h~filemap-remove-find_get_pages_range_tag
+++ a/include/linux/pagemap.h
@@ -741,16 +741,6 @@ unsigned filemap_get_folios_contig(struc
 		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch);
-unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
-			pgoff_t end, xa_mark_t tag, unsigned int nr_pages,
-			struct page **pages);
-static inline unsigned find_get_pages_tag(struct address_space *mapping,
-			pgoff_t *index, xa_mark_t tag, unsigned int nr_pages,
-			struct page **pages)
-{
-	return find_get_pages_range_tag(mapping, index, (pgoff_t)-1, tag,
-					nr_pages, pages);
-}
 
 struct page *grab_cache_page_write_begin(struct address_space *mapping,
 			pgoff_t index);
--- a/include/linux/pagevec.h~filemap-remove-find_get_pages_range_tag
+++ a/include/linux/pagevec.h
@@ -26,14 +26,6 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		xa_mark_t tag);
-static inline unsigned pagevec_lookup_tag(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *index, xa_mark_t tag)
-{
-	return pagevec_lookup_range_tag(pvec, mapping, index, (pgoff_t)-1, tag);
-}
 
 static inline void pagevec_init(struct pagevec *pvec)
 {
--- a/mm/filemap.c~filemap-remove-find_get_pages_range_tag
+++ a/mm/filemap.c
@@ -2337,66 +2337,6 @@ out:
 }
 EXPORT_SYMBOL(filemap_get_folios_tag);
 
-/**
- * find_get_pages_range_tag - Find and return head pages matching @tag.
- * @mapping:	the address_space to search
- * @index:	the starting page index
- * @end:	The final page index (inclusive)
- * @tag:	the tag index
- * @nr_pages:	the maximum number of pages
- * @pages:	where the resulting pages are placed
- *
- * Like find_get_pages_range(), except we only return head pages which are
- * tagged with @tag.  @index is updated to the index immediately after the
- * last page we return, ready for the next iteration.
- *
- * Return: the number of pages which were found.
- */
-unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
-			pgoff_t end, xa_mark_t tag, unsigned int nr_pages,
-			struct page **pages)
-{
-	XA_STATE(xas, &mapping->i_pages, *index);
-	struct folio *folio;
-	unsigned ret = 0;
-
-	if (unlikely(!nr_pages))
-		return 0;
-
-	rcu_read_lock();
-	while ((folio = find_get_entry(&xas, end, tag))) {
-		/*
-		 * Shadow entries should never be tagged, but this iteration
-		 * is lockless so there is a window for page reclaim to evict
-		 * a page we saw tagged.  Skip over it.
-		 */
-		if (xa_is_value(folio))
-			continue;
-
-		pages[ret] = &folio->page;
-		if (++ret == nr_pages) {
-			*index = folio->index + folio_nr_pages(folio);
-			goto out;
-		}
-	}
-
-	/*
-	 * We come here when we got to @end. We take care to not overflow the
-	 * index @index as it confuses some of the callers. This breaks the
-	 * iteration when there is a page at index -1 but that is already
-	 * broken anyway.
-	 */
-	if (end == (pgoff_t)-1)
-		*index = (pgoff_t)-1;
-	else
-		*index = end + 1;
-out:
-	rcu_read_unlock();
-
-	return ret;
-}
-EXPORT_SYMBOL(find_get_pages_range_tag);
-
 /*
  * CD/DVDs are error prone. When a medium error occurs, the driver may fail
  * a _large_ part of the i/o request. Imagine the worst scenario:
--- a/mm/swap.c~filemap-remove-find_get_pages_range_tag
+++ a/mm/swap.c
@@ -1115,16 +1115,6 @@ void folio_batch_remove_exceptionals(str
 	fbatch->nr = j;
 }
 
-unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		xa_mark_t tag)
-{
-	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
-					PAGEVEC_SIZE, pvec->pages);
-	return pagevec_count(pvec);
-}
-EXPORT_SYMBOL(pagevec_lookup_range_tag);
-
 /*
  * Perform any setup for the swap system
  */
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch


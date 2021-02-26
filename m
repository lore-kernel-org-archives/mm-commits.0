Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B22C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B6B64F14
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhBZBRF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhBZBQw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:16:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0AF664F0D;
        Fri, 26 Feb 2021 01:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302157;
        bh=PgnEW4VsgopD3IOzrvbzBZ4bvzsRHqU3IuJM7DvOfzg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=K/swAv+s6WRv6A2c7oILCOVkv1G+d7ChTzOfvzcGrcBNVQHqNJ16Q5Oza1xsyHk2I
         2Mf0kCgFEroDvSZ7l1lubsTltzJln1mJH9rWLOz9rfzqnYL2IPB9vHNUn5cuVtGle/
         ojVU0wNQGfpp6J6/p1UsL8Jb7/BiNj9LFg/VxUmQ=
Date:   Thu, 25 Feb 2021 17:15:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 009/118] mm: add and use find_lock_entries
Message-ID: <20210226011556.cuHjWjWws%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add and use find_lock_entries

We have three functions (shmem_undo_range(), truncate_inode_pages_range()
and invalidate_mapping_pages()) which want exactly this function, so add
it to filemap.c.  Before this patch, shmem_undo_range() would split any
compound page which overlaps either end of the range being punched in both
the first and second loops through the address space.  After this patch,
that functionality is left for the second loop, which is arguably more
appropriate since the first loop is supposed to run through all the pages
quickly, and splitting a page can sleep.

[willy@infradead.org: add assertion]
  Link: https://lkml.kernel.org/r/20201124041507.28996-3-willy@infradead.org
Link: https://lkml.kernel.org/r/20201112212641.27837-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |   59 +++++++++++++++++++++++++++++++
 mm/internal.h |    3 +
 mm/shmem.c    |   22 ++---------
 mm/truncate.c |   91 +++++-------------------------------------------
 4 files changed, 78 insertions(+), 97 deletions(-)

--- a/mm/filemap.c~mm-add-and-use-find_lock_entries
+++ a/mm/filemap.c
@@ -1921,6 +1921,65 @@ unsigned find_get_entries(struct address
 }
 
 /**
+ * find_lock_entries - Find a batch of pagecache entries.
+ * @mapping:	The address_space to search.
+ * @start:	The starting page cache index.
+ * @end:	The final page index (inclusive).
+ * @pvec:	Where the resulting entries are placed.
+ * @indices:	The cache indices of the entries in @pvec.
+ *
+ * find_lock_entries() will return a batch of entries from @mapping.
+ * Swap, shadow and DAX entries are included.  Pages are returned
+ * locked and with an incremented refcount.  Pages which are locked by
+ * somebody else or under writeback are skipped.  Only the head page of
+ * a THP is returned.  Pages which are partially outside the range are
+ * not returned.
+ *
+ * The entries have ascending indexes.  The indices may not be consecutive
+ * due to not-present entries, THP pages, pages which could not be locked
+ * or pages under writeback.
+ *
+ * Return: The number of entries which were found.
+ */
+unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
+		pgoff_t end, struct pagevec *pvec, pgoff_t *indices)
+{
+	XA_STATE(xas, &mapping->i_pages, start);
+	struct page *page;
+
+	rcu_read_lock();
+	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
+		if (!xa_is_value(page)) {
+			if (page->index < start)
+				goto put;
+			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
+			if (page->index + thp_nr_pages(page) - 1 > end)
+				goto put;
+			if (!trylock_page(page))
+				goto put;
+			if (page->mapping != mapping || PageWriteback(page))
+				goto unlock;
+			VM_BUG_ON_PAGE(!thp_contains(page, xas.xa_index),
+					page);
+		}
+		indices[pvec->nr] = xas.xa_index;
+		if (!pagevec_add(pvec, page))
+			break;
+		goto next;
+unlock:
+		unlock_page(page);
+put:
+		put_page(page);
+next:
+		if (!xa_is_value(page) && PageTransHuge(page))
+			xas_set(&xas, page->index + thp_nr_pages(page));
+	}
+	rcu_read_unlock();
+
+	return pagevec_count(pvec);
+}
+
+/**
  * find_get_pages_range - gang pagecache lookup
  * @mapping:	The address_space to search
  * @start:	The starting page index
--- a/mm/internal.h~mm-add-and-use-find_lock_entries
+++ a/mm/internal.h
@@ -60,6 +60,9 @@ static inline void force_page_cache_read
 	force_page_cache_ra(&ractl, &file->f_ra, nr_to_read);
 }
 
+unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
+		pgoff_t end, struct pagevec *pvec, pgoff_t *indices);
+
 /**
  * page_evictable - test whether a page is evictable
  * @page: the page to test
--- a/mm/shmem.c~mm-add-and-use-find_lock_entries
+++ a/mm/shmem.c
@@ -907,12 +907,8 @@ static void shmem_undo_range(struct inod
 
 	pagevec_init(&pvec);
 	index = start;
-	while (index < end) {
-		pvec.nr = find_get_entries(mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE),
-			pvec.pages, indices);
-		if (!pvec.nr)
-			break;
+	while (index < end && find_lock_entries(mapping, index, end - 1,
+			&pvec, indices)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
@@ -927,18 +923,10 @@ static void shmem_undo_range(struct inod
 								index, page);
 				continue;
 			}
+			index += thp_nr_pages(page) - 1;
 
-			VM_BUG_ON_PAGE(page_to_pgoff(page) != index, page);
-
-			if (!trylock_page(page))
-				continue;
-
-			if ((!unfalloc || !PageUptodate(page)) &&
-			    page_mapping(page) == mapping) {
-				VM_BUG_ON_PAGE(PageWriteback(page), page);
-				if (shmem_punch_compound(page, start, end))
-					truncate_inode_page(mapping, page);
-			}
+			if (!unfalloc || !PageUptodate(page))
+				truncate_inode_page(mapping, page);
 			unlock_page(page);
 		}
 		pagevec_remove_exceptionals(&pvec);
--- a/mm/truncate.c~mm-add-and-use-find_lock_entries
+++ a/mm/truncate.c
@@ -326,51 +326,19 @@ void truncate_inode_pages_range(struct a
 
 	pagevec_init(&pvec);
 	index = start;
-	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE),
-			indices)) {
-		/*
-		 * Pagevec array has exceptional entries and we may also fail
-		 * to lock some pages. So we store pages that can be deleted
-		 * in a new pagevec.
-		 */
-		struct pagevec locked_pvec;
-
-		pagevec_init(&locked_pvec);
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
-
-			/* We rely upon deletion not changing page->index */
-			index = indices[i];
-			if (index >= end)
-				break;
-
-			if (xa_is_value(page))
-				continue;
-
-			if (!trylock_page(page))
-				continue;
-			WARN_ON(page_to_index(page) != index);
-			if (PageWriteback(page)) {
-				unlock_page(page);
-				continue;
-			}
-			if (page->mapping != mapping) {
-				unlock_page(page);
-				continue;
-			}
-			pagevec_add(&locked_pvec, page);
-		}
-		for (i = 0; i < pagevec_count(&locked_pvec); i++)
-			truncate_cleanup_page(mapping, locked_pvec.pages[i]);
-		delete_from_page_cache_batch(mapping, &locked_pvec);
-		for (i = 0; i < pagevec_count(&locked_pvec); i++)
-			unlock_page(locked_pvec.pages[i]);
+	while (index < end && find_lock_entries(mapping, index, end - 1,
+			&pvec, indices)) {
+		index = indices[pagevec_count(&pvec) - 1] + 1;
 		truncate_exceptional_pvec_entries(mapping, &pvec, indices, end);
+		for (i = 0; i < pagevec_count(&pvec); i++)
+			truncate_cleanup_page(mapping, pvec.pages[i]);
+		delete_from_page_cache_batch(mapping, &pvec);
+		for (i = 0; i < pagevec_count(&pvec); i++)
+			unlock_page(pvec.pages[i]);
 		pagevec_release(&pvec);
 		cond_resched();
-		index++;
 	}
+
 	if (partial_start) {
 		struct page *page = find_lock_page(mapping, start - 1);
 		if (page) {
@@ -539,9 +507,7 @@ static unsigned long __invalidate_mappin
 	int i;
 
 	pagevec_init(&pvec);
-	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
-			indices)) {
+	while (find_lock_entries(mapping, index, end, &pvec, indices)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
@@ -555,39 +521,7 @@ static unsigned long __invalidate_mappin
 							     page);
 				continue;
 			}
-
-			if (!trylock_page(page))
-				continue;
-
-			WARN_ON(page_to_index(page) != index);
-
-			/* Middle of THP: skip */
-			if (PageTransTail(page)) {
-				unlock_page(page);
-				continue;
-			} else if (PageTransHuge(page)) {
-				index += HPAGE_PMD_NR - 1;
-				i += HPAGE_PMD_NR - 1;
-				/*
-				 * 'end' is in the middle of THP. Don't
-				 * invalidate the page as the part outside of
-				 * 'end' could be still useful.
-				 */
-				if (index > end) {
-					unlock_page(page);
-					continue;
-				}
-
-				/* Take a pin outside pagevec */
-				get_page(page);
-
-				/*
-				 * Drop extra pins before trying to invalidate
-				 * the huge page.
-				 */
-				pagevec_remove_exceptionals(&pvec);
-				pagevec_release(&pvec);
-			}
+			index += thp_nr_pages(page) - 1;
 
 			ret = invalidate_inode_page(page);
 			unlock_page(page);
@@ -601,9 +535,6 @@ static unsigned long __invalidate_mappin
 				if (nr_pagevec)
 					(*nr_pagevec)++;
 			}
-
-			if (PageTransHuge(page))
-				put_page(page);
 			count += ret;
 		}
 		pagevec_remove_exceptionals(&pvec);
_

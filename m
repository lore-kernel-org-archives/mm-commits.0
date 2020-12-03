Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFDBC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E485A207A3
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgLCV6r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:58:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgLCV6r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 16:58:47 -0500
Date:   Thu, 03 Dec 2020 13:58:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607032686;
        bh=V7i1lSgtnBSrXKHIdUgXkRPvPN5vVYO6dPo5pqphttI=;
        h=From:To:Subject:From;
        b=P0QST0NL1naxuZCNiMXNiD7JNZsHaROKEG+aumAUypmlO8oevA8UcOCGwdQoPge5L
         ZglQdoMMnNmVfjSEcpEeLEr49wNCCY63SMZ6tmpCNBbLhv8e1BYMjDpw7hLI3KNOpK
         1mJvtw+Mn/lh7wgQwDAesa13SiIez2WBs3y5SYPI=
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [failures]
 mm-filemap-return-only-head-pages-from-find_get_entries.patch removed from
 -mm tree
Message-ID: <20201203215805.fsu91pCZV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: return only head pages from find_get_entries
has been removed from the -mm tree.  Its filename was
     mm-filemap-return-only-head-pages-from-find_get_entries.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: return only head pages from find_get_entries

All callers now expect head (and base) pages, and can handle multiple head
pages in a single batch, so make find_get_entries() behave that way.  Also
take the opportunity to make it use the pagevec infrastructure instead of
open-coding how pvecs behave.  This has the side-effect of being able to
append to a pagevec with existing contents, although we don't make use of
that functionality anywhere yet.

Link: https://lkml.kernel.org/r/20201112212641.27837-17-willy@infradead.org
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

 include/linux/pagemap.h |    2 --
 mm/filemap.c            |   36 ++++++++----------------------------
 mm/internal.h           |    2 ++
 3 files changed, 10 insertions(+), 30 deletions(-)

--- a/include/linux/pagemap.h~mm-filemap-return-only-head-pages-from-find_get_entries
+++ a/include/linux/pagemap.h
@@ -450,8 +450,6 @@ static inline struct page *find_subpage(
 	return head + (index & (thp_nr_pages(head) - 1));
 }
 
-unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
-		pgoff_t end, struct pagevec *pvec, pgoff_t *indices);
 unsigned find_get_pages_range(struct address_space *mapping, pgoff_t *start,
 			pgoff_t end, unsigned int nr_pages,
 			struct page **pages);
--- a/mm/filemap.c~mm-filemap-return-only-head-pages-from-find_get_entries
+++ a/mm/filemap.c
@@ -1886,49 +1886,29 @@ reset:
  * the mapping.  The entries are placed in @pvec.  find_get_entries()
  * takes a reference on any actual pages it returns.
  *
- * The search returns a group of mapping-contiguous page cache entries
- * with ascending indexes.  There may be holes in the indices due to
- * not-present pages.
+ * The entries have ascending indexes.  The indices may not be consecutive
+ * due to not-present entries or THPs.
  *
  * Any shadow entries of evicted pages, or swap entries from
  * shmem/tmpfs, are included in the returned array.
  *
- * If it finds a Transparent Huge Page, head or tail, find_get_entries()
- * stops at that page: the caller is likely to have a better way to handle
- * the compound page as a whole, and then skip its extent, than repeatedly
- * calling find_get_entries() to return all its tails.
- *
- * Return: the number of pages and shadow entries which were found.
+ * Return: The number of entries which were found.
  */
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
 		pgoff_t end, struct pagevec *pvec, pgoff_t *indices)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
-	unsigned int ret = 0;
-	unsigned nr_entries = PAGEVEC_SIZE;
 
 	rcu_read_lock();
 	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
-		/*
-		 * Terminate early on finding a THP, to allow the caller to
-		 * handle it all at once; but continue if this is hugetlbfs.
-		 */
-		if (!xa_is_value(page) && PageTransHuge(page) &&
-				!PageHuge(page)) {
-			page = find_subpage(page, xas.xa_index);
-			nr_entries = ret + 1;
-		}
-
-		indices[ret] = xas.xa_index;
-		pvec->pages[ret] = page;
-		if (++ret == nr_entries)
+		indices[pvec->nr] = xas.xa_index;
+		if (!pagevec_add(pvec, page))
 			break;
 	}
 	rcu_read_unlock();
 
-	pvec->nr = ret;
-	return ret;
+	return pagevec_count(pvec);
 }
 
 /**
@@ -1947,8 +1927,8 @@ unsigned find_get_entries(struct address
  * not returned.
  *
  * The entries have ascending indexes.  The indices may not be consecutive
- * due to not-present entries, THP pages, pages which could not be locked
- * or pages under writeback.
+ * due to not-present entries, THPs, pages which could not be locked or
+ * pages under writeback.
  *
  * Return: The number of entries which were found.
  */
--- a/mm/internal.h~mm-filemap-return-only-head-pages-from-find_get_entries
+++ a/mm/internal.h
@@ -60,6 +60,8 @@ static inline void force_page_cache_read
 	force_page_cache_ra(&ractl, &file->f_ra, nr_to_read);
 }
 
+unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
+		pgoff_t end, struct pagevec *pvec, pgoff_t *indices);
 unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 		pgoff_t end, struct pagevec *pvec, pgoff_t *indices);
 
_

Patches currently in -mm which might be from willy@infradead.org are

sparc-fix-handling-of-page-table-constructor-failure.patch
mm-move-free_unref_page-to-mm-internalh.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-support-thps-in-zero_user_segments.patch
mm-support-thps-in-zero_user_segments-fix.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch


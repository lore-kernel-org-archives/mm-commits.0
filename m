Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B155C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17AF964F26
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhBZBQb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:16:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhBZBQ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:16:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0780764EE4;
        Fri, 26 Feb 2021 01:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302146;
        bh=HLFVwss+VQySaWuX1zDyHVMMM6xebeYuJavtj5Pr4vY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q4mi66+LNzle8C4deJoPium9/ijLhtIak6FY0UKUvlb35h76OLR7vJEZQWAEERiHq
         HtrSUH/yqrcm4eArK2shW2mYQgDJzLXqAbCk2aX+w3dvmIdL4rYS8DoMVIoUl+PSt3
         Qwu/gIpEKf9MimXX3ZLRdLM+ZPfjKfe79WEddc+M=
Date:   Thu, 25 Feb 2021 17:15:44 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 006/118] mm/filemap: add helper for finding pages
Message-ID: <20210226011544.E1rCumDA1%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: add helper for finding pages

There is a lot of common code in find_get_entries(),
find_get_pages_range() and find_get_pages_range_tag().  Factor out
find_get_entry() which simplifies all three functions.

[willy@infradead.org: remove VM_BUG_ON_PAGE()]
  Link: https://lkml.kernel.org/r/20201124041507.28996-2-willy@infradead.orgLink: https://lkml.kernel.org/r/20201112212641.27837-7-willy@infradead.org
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

 mm/filemap.c |   97 +++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 55 deletions(-)

--- a/mm/filemap.c~mm-filemap-add-helper-for-finding-pages
+++ a/mm/filemap.c
@@ -1825,6 +1825,42 @@ no_page:
 }
 EXPORT_SYMBOL(pagecache_get_page);
 
+static inline struct page *find_get_entry(struct xa_state *xas, pgoff_t max,
+		xa_mark_t mark)
+{
+	struct page *page;
+
+retry:
+	if (mark == XA_PRESENT)
+		page = xas_find(xas, max);
+	else
+		page = xas_find_marked(xas, max, mark);
+
+	if (xas_retry(xas, page))
+		goto retry;
+	/*
+	 * A shadow entry of a recently evicted page, a swap
+	 * entry from shmem/tmpfs or a DAX entry.  Return it
+	 * without attempting to raise page count.
+	 */
+	if (!page || xa_is_value(page))
+		return page;
+
+	if (!page_cache_get_speculative(page))
+		goto reset;
+
+	/* Has the page moved or been split? */
+	if (unlikely(page != xas_reload(xas))) {
+		put_page(page);
+		goto reset;
+	}
+
+	return page;
+reset:
+	xas_reset(xas);
+	goto retry;
+}
+
 /**
  * find_get_entries - gang pagecache lookup
  * @mapping:	The address_space to search
@@ -1864,42 +1900,21 @@ unsigned find_get_entries(struct address
 		return 0;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, ULONG_MAX) {
-		if (xas_retry(&xas, page))
-			continue;
-		/*
-		 * A shadow entry of a recently evicted page, a swap
-		 * entry from shmem/tmpfs or a DAX entry.  Return it
-		 * without attempting to raise page count.
-		 */
-		if (xa_is_value(page))
-			goto export;
-
-		if (!page_cache_get_speculative(page))
-			goto retry;
-
-		/* Has the page moved or been split? */
-		if (unlikely(page != xas_reload(&xas)))
-			goto put_page;
-
+	while ((page = find_get_entry(&xas, ULONG_MAX, XA_PRESENT))) {
 		/*
 		 * Terminate early on finding a THP, to allow the caller to
 		 * handle it all at once; but continue if this is hugetlbfs.
 		 */
-		if (PageTransHuge(page) && !PageHuge(page)) {
+		if (!xa_is_value(page) && PageTransHuge(page) &&
+				!PageHuge(page)) {
 			page = find_subpage(page, xas.xa_index);
 			nr_entries = ret + 1;
 		}
-export:
+
 		indices[ret] = xas.xa_index;
 		entries[ret] = page;
 		if (++ret == nr_entries)
 			break;
-		continue;
-put_page:
-		put_page(page);
-retry:
-		xas_reset(&xas);
 	}
 	rcu_read_unlock();
 	return ret;
@@ -1938,30 +1953,16 @@ unsigned find_get_pages_range(struct add
 		return 0;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, end) {
-		if (xas_retry(&xas, page))
-			continue;
+	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
 		/* Skip over shadow, swap and DAX entries */
 		if (xa_is_value(page))
 			continue;
 
-		if (!page_cache_get_speculative(page))
-			goto retry;
-
-		/* Has the page moved or been split? */
-		if (unlikely(page != xas_reload(&xas)))
-			goto put_page;
-
 		pages[ret] = find_subpage(page, xas.xa_index);
 		if (++ret == nr_pages) {
 			*start = xas.xa_index + 1;
 			goto out;
 		}
-		continue;
-put_page:
-		put_page(page);
-retry:
-		xas_reset(&xas);
 	}
 
 	/*
@@ -2061,9 +2062,7 @@ unsigned find_get_pages_range_tag(struct
 		return 0;
 
 	rcu_read_lock();
-	xas_for_each_marked(&xas, page, end, tag) {
-		if (xas_retry(&xas, page))
-			continue;
+	while ((page = find_get_entry(&xas, end, tag))) {
 		/*
 		 * Shadow entries should never be tagged, but this iteration
 		 * is lockless so there is a window for page reclaim to evict
@@ -2072,23 +2071,11 @@ unsigned find_get_pages_range_tag(struct
 		if (xa_is_value(page))
 			continue;
 
-		if (!page_cache_get_speculative(page))
-			goto retry;
-
-		/* Has the page moved or been split? */
-		if (unlikely(page != xas_reload(&xas)))
-			goto put_page;
-
 		pages[ret] = page;
 		if (++ret == nr_pages) {
 			*index = page->index + thp_nr_pages(page);
 			goto out;
 		}
-		continue;
-put_page:
-		put_page(page);
-retry:
-		xas_reset(&xas);
 	}
 
 	/*
_

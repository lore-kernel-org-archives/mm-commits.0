Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85EC6C3279D
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C37B22203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633146;
	bh=TrMhcrRM571wPudVf3/K0OrGdaHK2UEU45I2NqDftow=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Wvh42SaNFgiZi6M7BpXCBd0qN/HinMMfpddS8+Jx4CeaPHJl+MZh7h+DLUY+bmTBE
	 qBvYTpEE+KG3CJRGv5pcYYQZpo/bdsxz0WHUk7Oui+eK5QSjPHvDDdFNGoEpIF5JOT
	 XCvY9nTn/FxM7FCH0Td0Wldz6lNgd/1sXuJrGsfQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgJMXwY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgJMXvh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B01921D81;
        Tue, 13 Oct 2020 23:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633095;
        bh=TrMhcrRM571wPudVf3/K0OrGdaHK2UEU45I2NqDftow=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c7PoGZnaFE+IWbipIJ2a5N63YCeq6eyX4EVA6sW7M/Ph1u0vz7mmbco0C4Sn1R1Zy
         h+qhv/cxuflFyPviKtN4tRLwyLxOb4nNz0+xAoUmAuMu0tfbkQlO/SBmWHHaJYdgbW
         0iBJt9fIOoDZG8QTPlUvUboDu/jk5Zdnhldd18ec=
Date:   Tue, 13 Oct 2020 16:51:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        chris@chris-wilson.co.uk, hannes@cmpxchg.org, hughd@google.com,
        jani.nikula@linux.intel.com, linux-mm@kvack.org,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 059/181] mm: convert find_get_entry to return the
 head page
Message-ID: <20201013235134.VlZijz_pA%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert find_get_entry to return the head page

There are only four callers remaining of find_get_entry().
get_shadow_from_swap_cache() only wants to see shadow entries and doesn't
care about which page is returned.  Push the find_subpage() call into
find_lock_entry(), find_get_incore_page() and pagecache_get_page().

[willy@infradead.org: fix oops]
  Link: https://lkml.kernel.org/r/20200914112738.GM6583@casper.infradead.org
Link: https://lkml.kernel.org/r/20200910183318.20139-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |   13 +++++++------
 mm/swap_state.c |    4 +++-
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/mm/filemap.c~mm-convert-find_get_entry-to-return-the-head-page
+++ a/mm/filemap.c
@@ -1645,19 +1645,19 @@ EXPORT_SYMBOL(page_cache_prev_miss);
 /**
  * find_get_entry - find and get a page cache entry
  * @mapping: the address_space to search
- * @offset: the page cache index
+ * @index: The page cache index.
  *
  * Looks up the page cache slot at @mapping & @offset.  If there is a
- * page cache page, it is returned with an increased refcount.
+ * page cache page, the head page is returned with an increased refcount.
  *
  * If the slot holds a shadow entry of a previously evicted page, or a
  * swap entry from shmem/tmpfs, it is returned.
  *
- * Return: the found page or shadow entry, %NULL if nothing is found.
+ * Return: The head page or shadow entry, %NULL if nothing is found.
  */
-struct page *find_get_entry(struct address_space *mapping, pgoff_t offset)
+struct page *find_get_entry(struct address_space *mapping, pgoff_t index)
 {
-	XA_STATE(xas, &mapping->i_pages, offset);
+	XA_STATE(xas, &mapping->i_pages, index);
 	struct page *page;
 
 	rcu_read_lock();
@@ -1685,7 +1685,6 @@ repeat:
 		put_page(page);
 		goto repeat;
 	}
-	page = find_subpage(page, offset);
 out:
 	rcu_read_unlock();
 
@@ -1722,6 +1721,7 @@ repeat:
 			put_page(page);
 			goto repeat;
 		}
+		page = find_subpage(page, offset);
 		VM_BUG_ON_PAGE(page_to_pgoff(page) != offset, page);
 	}
 	return page;
@@ -1768,6 +1768,7 @@ repeat:
 		page = NULL;
 	if (!page)
 		goto no_page;
+	page = find_subpage(page, index);
 
 	if (fgp_flags & FGP_LOCK) {
 		if (fgp_flags & FGP_NOWAIT) {
--- a/mm/swap_state.c~mm-convert-find_get_entry-to-return-the-head-page
+++ a/mm/swap_state.c
@@ -431,8 +431,10 @@ struct page *find_get_incore_page(struct
 	struct swap_info_struct *si;
 	struct page *page = find_get_entry(mapping, index);
 
-	if (!xa_is_value(page))
+	if (!page)
 		return page;
+	if (!xa_is_value(page))
+		return find_subpage(page, index);
 	if (!shmem_mapping(mapping))
 		return NULL;
 
_

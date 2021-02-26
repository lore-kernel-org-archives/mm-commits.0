Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEF1C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A742C64F26
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZBQb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:16:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhBZBQW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:16:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1D9464EFA;
        Fri, 26 Feb 2021 01:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302141;
        bh=3TXYHZVIwY7I/zCKDv5RkX1xTsh0Q196SwezecLggC0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=P8szYqzP5IJEw29+TbX1DuM7rtGr4l2Fsw+ON0eH5J5gvso7Icf1s6FGkuTFU8JYV
         LLKHkK86qwArL/bX/EmVudaRk3PCV093lSszgpCoF+K+boa5kahYhkVqmGn1hxiPv+
         IYFe73E8pNdkDCyZibwEEk3ZepadJzSVi2U8Z9HU=
Date:   Thu, 25 Feb 2021 17:15:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 005/118] mm/filemap: rename find_get_entry to
 mapping_get_entry
Message-ID: <20210226011540.ZpaUQBJsi%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: rename find_get_entry to mapping_get_entry

find_get_entry doesn't "find" anything.  It returns the entry at a
particular index.

Link: https://lkml.kernel.org/r/20201112212641.27837-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-filemap-rename-find_get_entry-to-mapping_get_entry
+++ a/mm/filemap.c
@@ -1659,7 +1659,7 @@ pgoff_t page_cache_prev_miss(struct addr
 EXPORT_SYMBOL(page_cache_prev_miss);
 
 /*
- * find_get_entry - find and get a page cache entry
+ * mapping_get_entry - Get a page cache entry.
  * @mapping: the address_space to search
  * @index: The page cache index.
  *
@@ -1671,7 +1671,8 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  *
  * Return: The head page or shadow entry, %NULL if nothing is found.
  */
-static struct page *find_get_entry(struct address_space *mapping, pgoff_t index)
+static struct page *mapping_get_entry(struct address_space *mapping,
+		pgoff_t index)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct page *page;
@@ -1747,7 +1748,7 @@ struct page *pagecache_get_page(struct a
 	struct page *page;
 
 repeat:
-	page = find_get_entry(mapping, index);
+	page = mapping_get_entry(mapping, index);
 	if (xa_is_value(page)) {
 		if (fgp_flags & FGP_ENTRY)
 			return page;
_

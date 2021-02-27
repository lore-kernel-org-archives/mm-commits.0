Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB36C43381
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109DC64F34
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhB0C3C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:29:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhB0C24 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:28:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9261964F17;
        Sat, 27 Feb 2021 02:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392895;
        bh=CLWiPuc3ezBjAAfxtF9Ag9Ic0CNRQuEmXcRNDnn6rK8=;
        h=Date:From:To:Subject:From;
        b=E46QHiLwKFtHmkjmAtLzSz6NpaUgQfL2M+IgY+O95lfclvtTPHVbdPk62CBvBqvDp
         Ngi/a0sYtxVaQ/FGE9sNeBxMhq8Vhjcbmy3QHWDHjP3v8PClc6fLuQHDW791USTC03
         dgPA6cHYRA/h4DJRbPWQOlNGmmWRKa/gp55UU6YA=
Date:   Fri, 26 Feb 2021 18:28:15 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch removed from
 -mm tree
Message-ID: <20210227022815.pOgQv2NhC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: rename find_get_entry to mapping_get_entry
has been removed from the -mm tree.  Its filename was
     mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are



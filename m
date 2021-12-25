Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F84C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 25 Dec 2021 05:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhLYFMw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Dec 2021 00:12:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49890 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhLYFMv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Dec 2021 00:12:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88FCBB80939
        for <mm-commits@vger.kernel.org>; Sat, 25 Dec 2021 05:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044EEC36AE5;
        Sat, 25 Dec 2021 05:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640409169;
        bh=TI0picrzibbqMhFp+eSd2X7fi+1cVTHZ5kuwfKFkfnc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XpC0QkjZBUlVNJZlkzWQbK/axWHAz/pco1S4LBzRz1TPN727JIQ0iZmrHeka36oeh
         CwHk9jeAkFUBGsvL8bBdImGPCrgMRDEpF2kzcpe3GOFsLE18sZ3lgHGzBK+9EpO8VC
         xpg1BgU1zRhmKsQHBhkODfUGOsvaKrTrfofhC1AY=
Date:   Fri, 24 Dec 2021 21:12:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 6/9] mm: delete unsafe BUG from
 page_cache_add_speculative()
Message-ID: <20211225051248.N-f4erWZF%akpm@linux-foundation.org>
In-Reply-To: <20211224211127.30b60764d059ff3b0afea38a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: delete unsafe BUG from page_cache_add_speculative()

It is not easily reproducible, but on 5.16-rc I have several times hit the
VM_BUG_ON_PAGE(PageTail(page), page) in page_cache_add_speculative():
usually from filemap_get_read_batch() for an ext4 read, yesterday from
next_uptodate_page() from filemap_map_pages() for a shmem fault.

That BUG used to be placed where page_ref_add_unless() had succeeded, but
now it is placed before folio_ref_add_unless() is attempted: that is not
safe, since it is only the acquired reference which makes the page safe
from racing THP collapse or split.

We could keep the BUG, checking PageTail only when folio_ref_try_add_rcu()
has succeeded; but I don't think it adds much value - just delete it.

Link: https://lkml.kernel.org/r/8b98fc6f-3439-8614-c3f3-945c659a1aba@google.com
Fixes: 020853b6f5ea ("mm: Add folio_try_get_rcu()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/pagemap.h~mm-delete-unsafe-bug-from-page_cache_add_speculative
+++ a/include/linux/pagemap.h
@@ -285,7 +285,6 @@ static inline struct inode *folio_inode(
 
 static inline bool page_cache_add_speculative(struct page *page, int count)
 {
-	VM_BUG_ON_PAGE(PageTail(page), page);
 	return folio_ref_try_add_rcu((struct folio *)page, count);
 }
 
_

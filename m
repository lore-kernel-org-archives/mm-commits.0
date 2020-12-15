Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F6EC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1925B22512
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgLODMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbgLODMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:41 -0500
Date:   Mon, 14 Dec 2020 19:11:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001869;
        bh=me3P6xy3I8JGn5T/2uCGRbNH+FzwyVezfIHnwi1XWqg=;
        h=From:To:Subject:In-Reply-To:From;
        b=Umrxgl82IUAvww5lcZKQAj7OnV7NqA9afIiyzLZrIedspe9jBtcVy7NO6O9SPtdfu
         /17QLMehHR0qfKJCsJ5YrhQ1UDtNMc+uwZGlhPyIh0F/6e+a1MUPxMCrEtjRdboM0B
         fi5j+SePb+Tf9sX658gD1VCCgNktX1i7JEhBdH/k=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 132/200] mm/page_alloc: add __free_pages()
 documentation
Message-ID: <20201215031109.HETudzx-2%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: add __free_pages() documentation

Provide some guidance towards when this might not be the right interface
to use.

Link: https://lkml.kernel.org/r/20201027025523.3235-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-__free_pages-documentation
+++ a/mm/page_alloc.c
@@ -5043,6 +5043,26 @@ static inline void free_the_page(struct
 		__free_pages_ok(page, order, FPI_NONE);
 }
 
+/**
+ * __free_pages - Free pages allocated with alloc_pages().
+ * @page: The page pointer returned from alloc_pages().
+ * @order: The order of the allocation.
+ *
+ * This function can free multi-page allocations that are not compound
+ * pages.  It does not check that the @order passed in matches that of
+ * the allocation, so it is easy to leak memory.  Freeing more memory
+ * than was allocated will probably emit a warning.
+ *
+ * If the last reference to this page is speculative, it will be released
+ * by put_page() which only frees the first page of a non-compound
+ * allocation.  To prevent the remaining pages from being leaked, we free
+ * the subsequent pages here.  If you want to use the page's reference
+ * count to decide when to free the allocation, you should allocate a
+ * compound page, and use put_page() instead of __free_pages().
+ *
+ * Context: May be called in interrupt context or while holding a normal
+ * spinlock, but not in NMI context or while holding a raw spinlock.
+ */
 void __free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page))
_

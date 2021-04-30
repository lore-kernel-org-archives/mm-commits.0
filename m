Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EB4C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F31B061493
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhD3GAR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhD3GAQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5A8F6148E;
        Fri, 30 Apr 2021 05:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762369;
        bh=5ouAOgqeam1rDN801mI+NEX4PxHyuFeHQizf1PV9c9U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M92Q2g0/O8SKHVTK7aUEx6+a83igJ7ee+3XUqt2vq+xjZqTUJ4aVdfPrwk/hxYfdH
         w7TDKAHcPC1cRd2O4VnqkDnW6AcJm/l6E/NOSEN2iB1w+/yrX6F+4hO7lz4aeOUE4u
         hr0NLrWECqgbzO+jw5VllqU0wgs3S390Mjg3Y4Js=
Date:   Thu, 29 Apr 2021 22:59:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 122/178] mm/doc: fix page_maybe_dma_pinned
 kerneldoc
Message-ID: <20210430055928.h6i6PhNGk%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/doc: fix page_maybe_dma_pinned kerneldoc

make htmldocs reports:

./include/linux/mm.h:1341: warning: Excess function parameter 'Return' description in 'page_maybe_dma_pinned'

Fix a few other formatting nits while I'm editing this description.

Link: https://lkml.kernel.org/r/20210322195022.2143603-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-doc-fix-page_maybe_dma_pinned-kerneldoc
+++ a/include/linux/mm.h
@@ -1271,10 +1271,11 @@ void unpin_user_page_range_dirty_lock(st
 void unpin_user_pages(struct page **pages, unsigned long npages);
 
 /**
- * page_maybe_dma_pinned() - report if a page is pinned for DMA.
+ * page_maybe_dma_pinned - Report if a page is pinned for DMA.
+ * @page: The page.
  *
  * This function checks if a page has been pinned via a call to
- * pin_user_pages*().
+ * a function in the pin_user_pages() family.
  *
  * For non-huge pages, the return value is partially fuzzy: false is not fuzzy,
  * because it means "definitely not pinned for DMA", but true means "probably
@@ -1292,9 +1293,8 @@ void unpin_user_pages(struct page **page
  *
  * For more information, please see Documentation/core-api/pin_user_pages.rst.
  *
- * @page:	pointer to page to be queried.
- * @Return:	True, if it is likely that the page has been "dma-pinned".
- *		False, if the page is definitely not dma-pinned.
+ * Return: True, if it is likely that the page has been "dma-pinned".
+ * False, if the page is definitely not dma-pinned.
  */
 static inline bool page_maybe_dma_pinned(struct page *page)
 {
_

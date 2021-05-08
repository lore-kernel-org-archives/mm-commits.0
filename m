Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9548C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A7B161415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhEHWon (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWon (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FE4461402;
        Sat,  8 May 2021 22:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513820;
        bh=thsX8ORtpqQXxXYc+8Xy/KTsRiZi2t08DknYWdJwDOU=;
        h=Date:From:To:Subject:From;
        b=hSbFHAc3QazeTI5SWPaEapGR/rhg523H99Sqf7rpVt6FHpR5LdgUquhKfdcvPDxa5
         P/S+fc6hyMubY9JexalvBWNT3MuCo6xm+JkFSQghRlOPbvO9RxS/kMZ+be/NVPRXBM
         OyYCGHuKv/0OoznyxhdBvINM4O2fw1YF9p6zY6Sw=
Date:   Sat, 08 May 2021 15:43:40 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, willy@infradead.org
Subject:  [merged] mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch
 removed from -mm tree
Message-ID: <20210508224340.fE5cDLyKr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/doc: fix page_maybe_dma_pinned kerneldoc
has been removed from the -mm tree.  Its filename was
     mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are



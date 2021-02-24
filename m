Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30378C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F317764F33
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhBXUEe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235399AbhBXUDG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8844164F11;
        Wed, 24 Feb 2021 20:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196953;
        bh=ZJP+b3ad9NR5VUxyODSnTAxkn39JSQ/wkrFSj1+3kz0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fEwUSy3WJ9Wjg4GITnWwqk5g6QCNQ2oz7ufFKjm/kXPCgi8LBbsNYYL0vOWdXIVzT
         dGsSvVPWGC8lVBJpVDN0W6xMOIQMQwDZt99cR/bv6IC54I/KoPBaFd0WPVCKCsu2Pl
         P9tEiOM8XofP4vDuqW53XRlh4Ax3JWhUhpXCx0tQ=
Date:   Wed, 24 Feb 2021 12:02:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 043/173] mm/filemap: split filemap_readahead out
 of filemap_get_pages
Message-ID: <20210224200232.DQJ_71Mup%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: split filemap_readahead out of filemap_get_pages

This simplifies the error handling.

Link: https://lkml.kernel.org/r/20210122160140.223228-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/mm/filemap.c~mm-filemap-split-filemap_readahead-out-of-filemap_get_pages
+++ a/mm/filemap.c
@@ -2330,6 +2330,17 @@ error:
 	return error;
 }
 
+static int filemap_readahead(struct kiocb *iocb, struct file *file,
+		struct address_space *mapping, struct page *page,
+		pgoff_t last_index)
+{
+	if (iocb->ki_flags & IOCB_NOIO)
+		return -EAGAIN;
+	page_cache_async_readahead(mapping, &file->f_ra, file, page,
+			page->index, last_index - page->index);
+	return 0;
+}
+
 static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
 		struct pagevec *pvec)
 {
@@ -2367,17 +2378,15 @@ find_page:
 got_pages:
 	{
 		struct page *page = pvec->pages[pvec->nr - 1];
-		pgoff_t pg_index = page->index;
 
 		if (PageReadahead(page)) {
-			if (iocb->ki_flags & IOCB_NOIO) {
+			err = filemap_readahead(iocb, filp, mapping, page,
+					last_index);
+			if (err) {
 				put_page(page);
 				pvec->nr--;
-				err = -EAGAIN;
 				goto err;
 			}
-			page_cache_async_readahead(mapping, ra, filp, page,
-					pg_index, last_index - pg_index);
 		}
 
 		if (!PageUptodate(page)) {
_

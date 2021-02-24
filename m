Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673E1C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB1964F39
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhBXUEm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235408AbhBXUDH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B9BD64F29;
        Wed, 24 Feb 2021 20:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196959;
        bh=ExvvksIdO4A/g3Doeu+xtkJ20UGN+WKkXDwwypdpzgk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ykLFk8/VuJylHJ+e77s8jaqnXXIVOmRpaGTfJoC/Yf8aBZuwdpmvgcvqOuIvU464a
         ZouQCUsMfqx7rEIFeSwqwaxH3oUEGxXMqI/yoITa8pisSTERJEXQHt3L5WcyCOn86Y
         MWzQ0S07OaU+Hn3z73T60rxL9P5Pi09LT0QokvyE=
Date:   Wed, 24 Feb 2021 12:02:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 045/173] mm/filemap: don't relock the page after
 calling readpage
Message-ID: <20210224200238.BXxudVT6w%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: don't relock the page after calling readpage

We don't need to get the page lock again; we just need to wait for the I/O
to finish, so use wait_on_page_locked_killable() like the other callers of
->readpage.

Link: https://lkml.kernel.org/r/20210122160140.223228-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/mm/filemap.c~mm-filemap-dont-relock-the-page-after-calling-readpage
+++ a/mm/filemap.c
@@ -2214,23 +2214,16 @@ static int filemap_read_page(struct file
 	error = mapping->a_ops->readpage(file, page);
 	if (error)
 		return error;
-	if (PageUptodate(page))
-		return 0;
 
-	error = lock_page_killable(page);
+	error = wait_on_page_locked_killable(page);
 	if (error)
 		return error;
-	if (!PageUptodate(page)) {
-		if (page->mapping == NULL) {
-			/* page truncated */
-			error = AOP_TRUNCATED_PAGE;
-		} else {
-			shrink_readahead_size_eio(&file->f_ra);
-			error = -EIO;
-		}
-	}
-	unlock_page(page);
-	return error;
+	if (PageUptodate(page))
+		return 0;
+	if (!page->mapping)	/* page truncated */
+		return AOP_TRUNCATED_PAGE;
+	shrink_readahead_size_eio(&file->f_ra);
+	return -EIO;
 }
 
 static bool filemap_range_uptodate(struct address_space *mapping,
_

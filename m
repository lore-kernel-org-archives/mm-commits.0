Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA9DC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C3A764F28
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbhBXUEB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235182AbhBXUDA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3222C64F08;
        Wed, 24 Feb 2021 20:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196939;
        bh=CdXgBHefHzbdNfMiTx+xiAkE87/5qlsEwwhQUWVm3yA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=X6DQ+bydTn1344ece3FBlJ7+1YJlSA2olm02i7d+cipmofYHNU/0tvuUqd9H/aiFj
         MN95DjIBi8MVbkWYYg6eLO4WPl1wxYTjNDqZdkm2bwvoX7WcJIhl+nj96edHMm6ibZ
         fFOTgewVsFsqRuIBu1vLcmT9zplKOQXiEW+zIMg4=
Date:   Wed, 24 Feb 2021 12:02:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 039/173] mm/filemap: change filemap_create_page
 calling conventions
Message-ID: <20210224200218.GOP7HnWLS%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: change filemap_create_page calling conventions

By moving the iocb flag checks to the caller, we can pass the file and the
page index instead of the iocb.  It never needed the iter.  By passing the
pagevec, we can return an errno (or AOP_TRUNCATED_PAGE) instead of an
ERR_PTR.

Link: https://lkml.kernel.org/r/20210122160140.223228-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   53 ++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

--- a/mm/filemap.c~mm-filemap-change-filemap_create_page-calling-conventions
+++ a/mm/filemap.c
@@ -2290,32 +2290,33 @@ truncated:
 	return NULL;
 }
 
-static struct page *filemap_create_page(struct kiocb *iocb,
-		struct iov_iter *iter)
+static int filemap_create_page(struct file *file,
+		struct address_space *mapping, pgoff_t index,
+		struct pagevec *pvec)
 {
-	struct file *filp = iocb->ki_filp;
-	struct address_space *mapping = filp->f_mapping;
-	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
 	struct page *page;
 	int error;
 
-	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ))
-		return ERR_PTR(-EAGAIN);
-
 	page = page_cache_alloc(mapping);
 	if (!page)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	error = add_to_page_cache_lru(page, mapping, index,
-				      mapping_gfp_constraint(mapping, GFP_KERNEL));
-	if (!error)
-		error = filemap_read_page(iocb->ki_filp, mapping, page);
-	if (!error)
-		return page;
+			mapping_gfp_constraint(mapping, GFP_KERNEL));
+	if (error == -EEXIST)
+		error = AOP_TRUNCATED_PAGE;
+	if (error)
+		goto error;
+
+	error = filemap_read_page(file, mapping, page);
+	if (error)
+		goto error;
+
+	pagevec_add(pvec, page);
+	return 0;
+error:
 	put_page(page);
-	if (error == -EEXIST || error == AOP_TRUNCATED_PAGE)
-		return NULL;
-	return ERR_PTR(error);
+	return error;
 }
 
 static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
@@ -2343,15 +2344,15 @@ find_page:
 	page_cache_sync_readahead(mapping, ra, filp, index, last_index - index);
 
 	filemap_get_read_batch(mapping, index, last_index, pvec);
-	if (pvec->nr)
-		goto got_pages;
-
-	pvec->pages[0] = filemap_create_page(iocb, iter);
-	err = PTR_ERR_OR_ZERO(pvec->pages[0]);
-	if (IS_ERR_OR_NULL(pvec->pages[0]))
-		goto err;
-	pvec->nr = 1;
-	return 0;
+	if (!pagevec_count(pvec)) {
+		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
+			return -EAGAIN;
+		err = filemap_create_page(filp, mapping,
+				iocb->ki_pos >> PAGE_SHIFT, pvec);
+		if (err == AOP_TRUNCATED_PAGE)
+			goto find_page;
+		return err;
+	}
 got_pages:
 	{
 		struct page *page = pvec->pages[pvec->nr - 1];
_

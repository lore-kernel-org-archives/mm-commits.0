Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62ACEC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D5F64F28
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhBXUD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhBXUDA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E89A364F0C;
        Wed, 24 Feb 2021 20:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196936;
        bh=NpsEh2E0z0A6UvwS4s+vZoh8U0eKngMLANkAqbqfZgk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AwtzEHDLgPnp92bJVZ8By9JDe3jrDR5QWWxynSZaNYk1OniKvhXPWV8aPCEUsYaLu
         yPg0GoGm/V0hQHXNuRKDVZagV3HuCTkDJNVmAAcDbKBd1fZJ7ZLLV8ZmwFoRqCSKH5
         aR2VqgoHAWokKm0vBxLYBFZQCdE67reEf4KUv7JE=
Date:   Wed, 24 Feb 2021 12:02:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 038/173] mm/filemap: change filemap_read_page
 calling conventions
Message-ID: <20210224200215.LkSqq8XQQ%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: change filemap_read_page calling conventions

Make this function more generic by passing the file instead of the iocb. 
Check in the callers whether we should call readpage or not.  Also make it
return an errno / 0 / AOP_TRUNCATED_PAGE, and make calling put_page() the
caller's responsibility.

Link: https://lkml.kernel.org/r/20210122160140.223228-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   89 +++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 47 deletions(-)

--- a/mm/filemap.c~mm-filemap-change-filemap_read_page-calling-conventions
+++ a/mm/filemap.c
@@ -2199,56 +2199,38 @@ retry:
 	rcu_read_unlock();
 }
 
-static struct page *filemap_read_page(struct kiocb *iocb, struct file *filp,
-		struct address_space *mapping, struct page *page)
+static int filemap_read_page(struct file *file, struct address_space *mapping,
+		struct page *page)
 {
-	struct file_ra_state *ra = &filp->f_ra;
 	int error;
 
-	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ)) {
-		unlock_page(page);
-		put_page(page);
-		return ERR_PTR(-EAGAIN);
-	}
-
 	/*
-	 * A previous I/O error may have been due to temporary
-	 * failures, eg. multipath errors.
-	 * PG_error will be set again if readpage fails.
+	 * A previous I/O error may have been due to temporary failures,
+	 * eg. multipath errors.  PG_error will be set again if readpage
+	 * fails.
 	 */
 	ClearPageError(page);
 	/* Start the actual read. The read will unlock the page. */
-	error = mapping->a_ops->readpage(filp, page);
-
-	if (unlikely(error)) {
-		put_page(page);
-		return error != AOP_TRUNCATED_PAGE ? ERR_PTR(error) : NULL;
-	}
+	error = mapping->a_ops->readpage(file, page);
+	if (error)
+		return error;
+	if (PageUptodate(page))
+		return 0;
 
+	error = lock_page_killable(page);
+	if (error)
+		return error;
 	if (!PageUptodate(page)) {
-		error = lock_page_killable(page);
-		if (unlikely(error)) {
-			put_page(page);
-			return ERR_PTR(error);
-		}
-		if (!PageUptodate(page)) {
-			if (page->mapping == NULL) {
-				/*
-				 * invalidate_mapping_pages got it
-				 */
-				unlock_page(page);
-				put_page(page);
-				return NULL;
-			}
-			unlock_page(page);
-			shrink_readahead_size_eio(ra);
-			put_page(page);
-			return ERR_PTR(-EIO);
+		if (page->mapping == NULL) {
+			/* page truncated */
+			error = AOP_TRUNCATED_PAGE;
+		} else {
+			shrink_readahead_size_eio(&file->f_ra);
+			error = -EIO;
 		}
-		unlock_page(page);
 	}
-
-	return page;
+	unlock_page(page);
+	return error;
 }
 
 static struct page *filemap_update_page(struct kiocb *iocb, struct file *filp,
@@ -2290,7 +2272,18 @@ uptodate:
 	return page;
 
 readpage:
-	return filemap_read_page(iocb, filp, mapping, page);
+	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ)) {
+		unlock_page(page);
+		put_page(page);
+		return ERR_PTR(-EAGAIN);
+	}
+	error = filemap_read_page(iocb->ki_filp, mapping, page);
+	if (!error)
+		return page;
+	put_page(page);
+	if (error == AOP_TRUNCATED_PAGE)
+		return NULL;
+	return ERR_PTR(error);
 truncated:
 	unlock_page(page);
 	put_page(page);
@@ -2306,7 +2299,7 @@ static struct page *filemap_create_page(
 	struct page *page;
 	int error;
 
-	if (iocb->ki_flags & IOCB_NOIO)
+	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ))
 		return ERR_PTR(-EAGAIN);
 
 	page = page_cache_alloc(mapping);
@@ -2315,12 +2308,14 @@ static struct page *filemap_create_page(
 
 	error = add_to_page_cache_lru(page, mapping, index,
 				      mapping_gfp_constraint(mapping, GFP_KERNEL));
-	if (error) {
-		put_page(page);
-		return error != -EEXIST ? ERR_PTR(error) : NULL;
-	}
-
-	return filemap_read_page(iocb, filp, mapping, page);
+	if (!error)
+		error = filemap_read_page(iocb->ki_filp, mapping, page);
+	if (!error)
+		return page;
+	put_page(page);
+	if (error == -EEXIST || error == AOP_TRUNCATED_PAGE)
+		return NULL;
+	return ERR_PTR(error);
 }
 
 static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
_

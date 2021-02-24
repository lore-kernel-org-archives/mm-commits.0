Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D84C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0428D64F28
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhBXUEL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:04:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235342AbhBXUDA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8306964F09;
        Wed, 24 Feb 2021 20:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196943;
        bh=0hLm6k8UHSFQXHvK/O2/yipiT2IcubYRnrUJk3x4j9w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iPhKYVP6BnX90nSy51BX5HA/RSJ1JNblKUfcLJAPDxYgCMHuwP9EOVUI+XTKBsuun
         x1XiYLb80ZIPNpYTvak16VjC7PZQIUIq7ittYvxn4Fp0K2jVkFhGgjqp2L9OepngVt
         sG1wwWOujRhhRrjhck+IkC8WlmOOii7+PZN9ZSdg=
Date:   Wed, 24 Feb 2021 12:02:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 040/173] mm/filemap: convert filemap_update_page
 to return an errno
Message-ID: <20210224200222.XcdktnE5J%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: convert filemap_update_page to return an errno

Use AOP_TRUNCATED_PAGE to indicate that no error occurred, but the page we
looked up is no longer valid.  In this case, the reference to the page
will have been removed; if we hit any other error, the caller will release
the reference.

Link: https://lkml.kernel.org/r/20210122160140.223228-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- a/mm/filemap.c~mm-filemap-convert-filemap_update_page-to-return-an-errno
+++ a/mm/filemap.c
@@ -2233,24 +2233,21 @@ static int filemap_read_page(struct file
 	return error;
 }
 
-static struct page *filemap_update_page(struct kiocb *iocb, struct file *filp,
-		struct iov_iter *iter, struct page *page, loff_t pos,
-		loff_t count)
+static int filemap_update_page(struct kiocb *iocb,
+		struct address_space *mapping, struct iov_iter *iter,
+		struct page *page, loff_t pos, loff_t count)
 {
-	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
 	int error;
 
 	if (iocb->ki_flags & IOCB_WAITQ) {
 		error = lock_page_async(page, iocb->ki_waitq);
-		if (error) {
-			put_page(page);
-			return ERR_PTR(error);
-		}
+		if (error)
+			return error;
 	} else {
 		if (!trylock_page(page)) {
 			put_and_wait_on_page_locked(page, TASK_KILLABLE);
-			return NULL;
+			return AOP_TRUNCATED_PAGE;
 		}
 	}
 
@@ -2269,25 +2266,21 @@ static struct page *filemap_update_page(
 		goto readpage;
 uptodate:
 	unlock_page(page);
-	return page;
+	return 0;
 
 readpage:
 	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ)) {
 		unlock_page(page);
-		put_page(page);
-		return ERR_PTR(-EAGAIN);
+		return -EAGAIN;
 	}
 	error = filemap_read_page(iocb->ki_filp, mapping, page);
-	if (!error)
-		return page;
-	put_page(page);
 	if (error == AOP_TRUNCATED_PAGE)
-		return NULL;
-	return ERR_PTR(error);
+		put_page(page);
+	return error;
 truncated:
 	unlock_page(page);
 	put_page(page);
-	return NULL;
+	return AOP_TRUNCATED_PAGE;
 }
 
 static int filemap_create_page(struct file *file,
@@ -2381,11 +2374,12 @@ got_pages:
 				goto err;
 			}
 
-			page = filemap_update_page(iocb, filp, iter, page,
+			err = filemap_update_page(iocb, mapping, iter, page,
 					pg_pos, pg_count);
-			if (IS_ERR_OR_NULL(page)) {
+			if (err) {
+				if (err < 0)
+					put_page(page);
 				pvec->nr--;
-				err = PTR_ERR_OR_ZERO(page);
 			}
 		}
 	}
@@ -2393,6 +2387,8 @@ got_pages:
 err:
 	if (likely(pvec->nr))
 		return 0;
+	if (err == AOP_TRUNCATED_PAGE)
+		goto find_page;
 	if (err)
 		return err;
 	/*
_

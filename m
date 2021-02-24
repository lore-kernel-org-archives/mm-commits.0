Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C80C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 365B964F34
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhBXUD4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235384AbhBXUCx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB9F864EC4;
        Wed, 24 Feb 2021 20:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196910;
        bh=2hPNHFAWK4SArcZOrl8XmoD8oHkK0U679kOXky30KlM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D+PvGpxneGSFeMozTOlaz69CIVKeZFK8bTqXhEzEPnzuF5h6Fovbl6PjdUlpABdMc
         /Q2YfOADjGRMGtbxr9kzeTnVj1DlC1xPj+GMtjGoTX9LVHrDCW8/264FYyGI7NJx/Y
         65CufEydGrTT7wwwk6KClJ83S9S7f6qYhpQ2+o/8=
Date:   Wed, 24 Feb 2021 12:01:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 030/173] mm/filemap: rename
 generic_file_buffered_read subfunctions
Message-ID: <20210224200149.q7jigblJl%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: rename generic_file_buffered_read subfunctions

Patch series "Refactor generic_file_buffered_read", v5.

This is a combination of Christoph's work to refactor
generic_file_buffered_read() and some of my large-page support
which was disrupted by Kent's refactoring of generic_file_buffered_read.


This patch (of 18):

The recent split of generic_file_buffered_read() created some very long
function names which are hard to distinguish from each other.  Rename as
follows:

generic_file_buffered_read_readpage -> filemap_read_page
generic_file_buffered_read_pagenotuptodate -> filemap_update_page
generic_file_buffered_read_no_cached_page -> filemap_create_page
generic_file_buffered_read_get_pages -> filemap_get_pages

Link: https://lkml.kernel.org/r/20210122160140.223228-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20210122160140.223228-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

--- a/mm/filemap.c~mm-filemap-rename-generic_file_buffered_read-subfunctions
+++ a/mm/filemap.c
@@ -2178,11 +2178,8 @@ static int lock_page_for_iocb(struct kio
 		return lock_page_killable(page);
 }
 
-static struct page *
-generic_file_buffered_read_readpage(struct kiocb *iocb,
-				    struct file *filp,
-				    struct address_space *mapping,
-				    struct page *page)
+static struct page *filemap_read_page(struct kiocb *iocb, struct file *filp,
+		struct address_space *mapping, struct page *page)
 {
 	struct file_ra_state *ra = &filp->f_ra;
 	int error;
@@ -2233,12 +2230,9 @@ generic_file_buffered_read_readpage(stru
 	return page;
 }
 
-static struct page *
-generic_file_buffered_read_pagenotuptodate(struct kiocb *iocb,
-					   struct file *filp,
-					   struct iov_iter *iter,
-					   struct page *page,
-					   loff_t pos, loff_t count)
+static struct page *filemap_update_page(struct kiocb *iocb, struct file *filp,
+		struct iov_iter *iter, struct page *page, loff_t pos,
+		loff_t count)
 {
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
@@ -2301,12 +2295,11 @@ page_not_up_to_date_locked:
 		return page;
 	}
 
-	return generic_file_buffered_read_readpage(iocb, filp, mapping, page);
+	return filemap_read_page(iocb, filp, mapping, page);
 }
 
-static struct page *
-generic_file_buffered_read_no_cached_page(struct kiocb *iocb,
-					  struct iov_iter *iter)
+static struct page *filemap_create_page(struct kiocb *iocb,
+		struct iov_iter *iter)
 {
 	struct file *filp = iocb->ki_filp;
 	struct address_space *mapping = filp->f_mapping;
@@ -2317,10 +2310,6 @@ generic_file_buffered_read_no_cached_pag
 	if (iocb->ki_flags & IOCB_NOIO)
 		return ERR_PTR(-EAGAIN);
 
-	/*
-	 * Ok, it wasn't cached, so we need to create a new
-	 * page..
-	 */
 	page = page_cache_alloc(mapping);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
@@ -2332,13 +2321,11 @@ generic_file_buffered_read_no_cached_pag
 		return error != -EEXIST ? ERR_PTR(error) : NULL;
 	}
 
-	return generic_file_buffered_read_readpage(iocb, filp, mapping, page);
+	return filemap_read_page(iocb, filp, mapping, page);
 }
 
-static int generic_file_buffered_read_get_pages(struct kiocb *iocb,
-						struct iov_iter *iter,
-						struct page **pages,
-						unsigned int nr)
+static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
+		struct page **pages, unsigned int nr)
 {
 	struct file *filp = iocb->ki_filp;
 	struct address_space *mapping = filp->f_mapping;
@@ -2365,7 +2352,7 @@ find_page:
 	if (nr_got)
 		goto got_pages;
 
-	pages[0] = generic_file_buffered_read_no_cached_page(iocb, iter);
+	pages[0] = filemap_create_page(iocb, iter);
 	err = PTR_ERR_OR_ZERO(pages[0]);
 	if (!IS_ERR_OR_NULL(pages[0]))
 		nr_got = 1;
@@ -2399,8 +2386,8 @@ got_pages:
 				break;
 			}
 
-			page = generic_file_buffered_read_pagenotuptodate(iocb,
-					filp, iter, page, pg_pos, pg_count);
+			page = filemap_update_page(iocb, filp, iter, page,
+					pg_pos, pg_count);
 			if (IS_ERR_OR_NULL(page)) {
 				for (j = i + 1; j < nr_got; j++)
 					put_page(pages[j]);
@@ -2479,8 +2466,7 @@ ssize_t generic_file_buffered_read(struc
 			iocb->ki_flags |= IOCB_NOWAIT;
 
 		i = 0;
-		pg_nr = generic_file_buffered_read_get_pages(iocb, iter,
-							     pages, nr_pages);
+		pg_nr = filemap_get_pages(iocb, iter, pages, nr_pages);
 		if (pg_nr < 0) {
 			error = pg_nr;
 			break;
_

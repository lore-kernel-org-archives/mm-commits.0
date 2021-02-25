Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5F7C43333
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC0EF64F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhBYTXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:23:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234772AbhBYTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2FD864F50;
        Thu, 25 Feb 2021 19:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280383;
        bh=0FsK0RCRCWNfwAyy8aDTVp7JoN8JaTtWXvVN0mAG1RY=;
        h=Date:From:To:Subject:From;
        b=zcUhVUdPK3XJHi8zFea3LXdW7g4iMlnllbtd12Xy3bw1cWcFhs7niQ1+BwKKn+eZG
         SN5Xo4UaNsAtnNuA4hkONNogplNjcS2lQwYDsnxq9lh4IsMgZx0ss8AsvTmlMm6KZW
         wPEqVpmvBNq4ArF1V3i38+JiwiaSgAAp5GnEO7rg=
Date:   Thu, 25 Feb 2021 11:13:02 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-change-filemap_create_page-calling-conventions.patch removed
 from -mm tree
Message-ID: <20210225191302.9ta8bNgef%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: change filemap_create_page calling conventions
has been removed from the -mm tree.  Its filename was
     mm-filemap-change-filemap_create_page-calling-conventions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189F5C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDCD222D07
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbhAXBuR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:50:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbhAXBuP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:50:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6047A22D37;
        Sun, 24 Jan 2021 01:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611452956;
        bh=z4qgELD/zE7W3OudWBOUKI1dcq6zPROle0idUZgmTbM=;
        h=Date:From:To:Subject:From;
        b=pXw6oAZ1wfnMvJ50HUA3lq1uRMlCYAIfgVtbyfDjFmCHFA3JyJEZAEweiaGMmlwN8
         BVjSjBL375a/lj1p61AK0ujLVkOB3e/p6KvNp1H9sdc/xpIJK8hj9muYel2AJqCC+I
         6ZCi6EkyB8FvWHSHvfYgEdJ30yvpl2p+OhzFJdGY=
Date:   Sat, 23 Jan 2021 17:49:14 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-filemap-change-filemap_read_page-calling-conventions.patch added to -mm
 tree
Message-ID: <20210124014914.uVtOYR6Qz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: change filemap_read_page calling conventions
has been added to the -mm tree.  Its filename is
     mm-filemap-change-filemap_read_page-calling-conventions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-change-filemap_read_page-calling-conventions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-change-filemap_read_page-calling-conventions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2193,56 +2193,38 @@ retry:
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
@@ -2284,7 +2266,18 @@ uptodate:
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
@@ -2300,7 +2293,7 @@ static struct page *filemap_create_page(
 	struct page *page;
 	int error;
 
-	if (iocb->ki_flags & IOCB_NOIO)
+	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ))
 		return ERR_PTR(-EAGAIN);
 
 	page = page_cache_alloc(mapping);
@@ -2309,12 +2302,14 @@ static struct page *filemap_create_page(
 
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

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-improve-memcg-debugging.patch
mm-filemap-rename-generic_file_buffered_read-subfunctions.patch
mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch
mm-filemap-convert-filemap_get_pages-to-take-a-pagevec.patch
mm-filemap-use-head-pages-in-generic_file_buffered_read.patch
mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked.patch
mm-filemap-support-readpage-splitting-a-page.patch
mm-filemap-inline-__wait_on_page_locked_async-into-caller.patch
mm-filemap-dont-call-readpage-if-iocb_waitq-is-set.patch
mm-filemap-change-filemap_read_page-calling-conventions.patch
mm-filemap-change-filemap_create_page-calling-conventions.patch
mm-filemap-convert-filemap_update_page-to-return-an-errno.patch
mm-filemap-move-the-iocb-checks-into-filemap_update_page.patch
mm-filemap-add-filemap_range_uptodate.patch
mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch
mm-filemap-restructure-filemap_get_pages.patch
mm-filemap-dont-relock-the-page-after-calling-readpage.patch
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


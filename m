Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9287DC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4716B64DE3
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhBYTUm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:20:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234379AbhBYTRg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3CE064F4E;
        Thu, 25 Feb 2021 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280356;
        bh=lbsUb5G0gke0eRBmTXHUNliVp+9Gqph9zo5wYigRQzk=;
        h=Date:From:To:Subject:From;
        b=0EgvVwbvG+czVohHFTwn8VG8NCYASEbdXVdAxV/GcAtnGyana8r8oQ0co/y5wNXd4
         1NhJYiKZ1/RiIbbGngHnydmHL27ZOT8vbaTlzCJTyvjkLTTyQPlwfy2BiQ2BPybfdJ
         8Co5/XPBbGCiYnpstwxlv02pMlvrWsiu0Q6DY78M=
Date:   Thu, 25 Feb 2021 11:12:35 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-rename-generic_file_buffered_read-subfunctions.patch removed
 from -mm tree
Message-ID: <20210225191235.RbulmMhvy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: rename generic_file_buffered_read subfunctions
has been removed from the -mm tree.  Its filename was
     mm-filemap-rename-generic_file_buffered_read-subfunctions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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


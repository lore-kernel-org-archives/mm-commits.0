Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06496C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DB5864DF2
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbhBYTUW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234392AbhBYTRg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A468664F47;
        Thu, 25 Feb 2021 19:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280362;
        bh=5Suj557d773Sss0QfTNOsNdyNmSjSdTnyUMPzn3u2ug=;
        h=Date:From:To:Subject:From;
        b=zeuWa0ugge6A5YFuUncTKWMaW0zlwheuX4N0XHh8vMm1EaDbofnM3JUbyL9fyOsjE
         NDU2gB3ixt1PwwnKzPHiJhlplftgmrzRsllvY69T4Temxs4AsQe1qsSKW8n85/e/+9
         BsuvtoLxPOS1oH4rJtI1voS+RUlsIL3ijOnnmtKk=
Date:   Thu, 25 Feb 2021 11:12:41 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-convert-filemap_get_pages-to-take-a-pagevec.patch removed from
 -mm tree
Message-ID: <20210225191241.1LXiotiKG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: convert filemap_get_pages to take a pagevec
has been removed from the -mm tree.  Its filename was
     mm-filemap-convert-filemap_get_pages-to-take-a-pagevec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: convert filemap_get_pages to take a pagevec

Using a pagevec lets us keep the pages and the number of pages together
which simplifies a lot of the calling conventions.

Link: https://lkml.kernel.org/r/20210122160140.223228-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   82 ++++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 44 deletions(-)

--- a/mm/filemap.c~mm-filemap-convert-filemap_get_pages-to-take-a-pagevec
+++ a/mm/filemap.c
@@ -2325,22 +2325,22 @@ static struct page *filemap_create_page(
 }
 
 static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
-		struct page **pages, unsigned int nr)
+		struct pagevec *pvec)
 {
 	struct file *filp = iocb->ki_filp;
 	struct address_space *mapping = filp->f_mapping;
 	struct file_ra_state *ra = &filp->f_ra;
 	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
 	pgoff_t last_index = (iocb->ki_pos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT;
-	int i, j, nr_got, err = 0;
+	unsigned int nr = min_t(unsigned long, last_index - index, PAGEVEC_SIZE);
+	int i, j, err = 0;
 
-	nr = min_t(unsigned long, last_index - index, nr);
 find_page:
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
-	nr_got = find_get_pages_contig(mapping, index, nr, pages);
-	if (nr_got)
+	pvec->nr = find_get_pages_contig(mapping, index, nr, pvec->pages);
+	if (pvec->nr)
 		goto got_pages;
 
 	if (iocb->ki_flags & IOCB_NOIO)
@@ -2348,17 +2348,17 @@ find_page:
 
 	page_cache_sync_readahead(mapping, ra, filp, index, last_index - index);
 
-	nr_got = find_get_pages_contig(mapping, index, nr, pages);
-	if (nr_got)
+	pvec->nr = find_get_pages_contig(mapping, index, nr, pvec->pages);
+	if (pvec->nr)
 		goto got_pages;
 
-	pages[0] = filemap_create_page(iocb, iter);
-	err = PTR_ERR_OR_ZERO(pages[0]);
-	if (!IS_ERR_OR_NULL(pages[0]))
-		nr_got = 1;
+	pvec->pages[0] = filemap_create_page(iocb, iter);
+	err = PTR_ERR_OR_ZERO(pvec->pages[0]);
+	if (!IS_ERR_OR_NULL(pvec->pages[0]))
+		pvec->nr = 1;
 got_pages:
-	for (i = 0; i < nr_got; i++) {
-		struct page *page = pages[i];
+	for (i = 0; i < pvec->nr; i++) {
+		struct page *page = pvec->pages[i];
 		pgoff_t pg_index = index + i;
 		loff_t pg_pos = max(iocb->ki_pos,
 				    (loff_t) pg_index << PAGE_SHIFT);
@@ -2366,9 +2366,9 @@ got_pages:
 
 		if (PageReadahead(page)) {
 			if (iocb->ki_flags & IOCB_NOIO) {
-				for (j = i; j < nr_got; j++)
-					put_page(pages[j]);
-				nr_got = i;
+				for (j = i; j < pvec->nr; j++)
+					put_page(pvec->pages[j]);
+				pvec->nr = i;
 				err = -EAGAIN;
 				break;
 			}
@@ -2379,9 +2379,9 @@ got_pages:
 		if (!PageUptodate(page)) {
 			if ((iocb->ki_flags & IOCB_NOWAIT) ||
 			    ((iocb->ki_flags & IOCB_WAITQ) && i)) {
-				for (j = i; j < nr_got; j++)
-					put_page(pages[j]);
-				nr_got = i;
+				for (j = i; j < pvec->nr; j++)
+					put_page(pvec->pages[j]);
+				pvec->nr = i;
 				err = -EAGAIN;
 				break;
 			}
@@ -2389,17 +2389,17 @@ got_pages:
 			page = filemap_update_page(iocb, filp, iter, page,
 					pg_pos, pg_count);
 			if (IS_ERR_OR_NULL(page)) {
-				for (j = i + 1; j < nr_got; j++)
-					put_page(pages[j]);
-				nr_got = i;
+				for (j = i + 1; j < pvec->nr; j++)
+					put_page(pvec->pages[j]);
+				pvec->nr = i;
 				err = PTR_ERR_OR_ZERO(page);
 				break;
 			}
 		}
 	}
 
-	if (likely(nr_got))
-		return nr_got;
+	if (likely(pvec->nr))
+		return 0;
 	if (err)
 		return err;
 	/*
@@ -2431,11 +2431,8 @@ ssize_t generic_file_buffered_read(struc
 	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
-	struct page *pages[PAGEVEC_SIZE];
-	unsigned int nr_pages = min_t(unsigned int, PAGEVEC_SIZE,
-			((iocb->ki_pos + iter->count + PAGE_SIZE - 1) >> PAGE_SHIFT) -
-			(iocb->ki_pos >> PAGE_SHIFT));
-	int i, pg_nr, error = 0;
+	struct pagevec pvec;
+	int i, error = 0;
 	bool writably_mapped;
 	loff_t isize, end_offset;
 
@@ -2457,12 +2454,9 @@ ssize_t generic_file_buffered_read(struc
 		if ((iocb->ki_flags & IOCB_WAITQ) && written)
 			iocb->ki_flags |= IOCB_NOWAIT;
 
-		i = 0;
-		pg_nr = filemap_get_pages(iocb, iter, pages, nr_pages);
-		if (pg_nr < 0) {
-			error = pg_nr;
+		error = filemap_get_pages(iocb, iter, &pvec);
+		if (error < 0)
 			break;
-		}
 
 		/*
 		 * i_size must be checked after we know the pages are Uptodate.
@@ -2478,9 +2472,9 @@ ssize_t generic_file_buffered_read(struc
 
 		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
 
-		while ((iocb->ki_pos >> PAGE_SHIFT) + pg_nr >
+		while ((iocb->ki_pos >> PAGE_SHIFT) + pvec.nr >
 		       (end_offset + PAGE_SIZE - 1) >> PAGE_SHIFT)
-			put_page(pages[--pg_nr]);
+			put_page(pvec.pages[--pvec.nr]);
 
 		/*
 		 * Once we start copying data, we don't want to be touching any
@@ -2494,11 +2488,11 @@ ssize_t generic_file_buffered_read(struc
 		 */
 		if (iocb->ki_pos >> PAGE_SHIFT !=
 		    ra->prev_pos >> PAGE_SHIFT)
-			mark_page_accessed(pages[0]);
-		for (i = 1; i < pg_nr; i++)
-			mark_page_accessed(pages[i]);
+			mark_page_accessed(pvec.pages[0]);
+		for (i = 1; i < pagevec_count(&pvec); i++)
+			mark_page_accessed(pvec.pages[i]);
 
-		for (i = 0; i < pg_nr; i++) {
+		for (i = 0; i < pagevec_count(&pvec); i++) {
 			unsigned int offset = iocb->ki_pos & ~PAGE_MASK;
 			unsigned int bytes = min_t(loff_t, end_offset - iocb->ki_pos,
 						   PAGE_SIZE - offset);
@@ -2510,9 +2504,9 @@ ssize_t generic_file_buffered_read(struc
 			 * before reading the page on the kernel side.
 			 */
 			if (writably_mapped)
-				flush_dcache_page(pages[i]);
+				flush_dcache_page(pvec.pages[i]);
 
-			copied = copy_page_to_iter(pages[i], offset, bytes, iter);
+			copied = copy_page_to_iter(pvec.pages[i], offset, bytes, iter);
 
 			written += copied;
 			iocb->ki_pos += copied;
@@ -2524,8 +2518,8 @@ ssize_t generic_file_buffered_read(struc
 			}
 		}
 put_pages:
-		for (i = 0; i < pg_nr; i++)
-			put_page(pages[i]);
+		for (i = 0; i < pagevec_count(&pvec); i++)
+			put_page(pvec.pages[i]);
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
 	file_accessed(filp);
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


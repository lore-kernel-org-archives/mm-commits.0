Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE86AC433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A981229F0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAXBug (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:50:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbhAXBuZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:50:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3662122D57;
        Sun, 24 Jan 2021 01:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611452973;
        bh=5ppEjoD8fNJMLi00JEHJeouc9SYv5TqyPab4GwzZSts=;
        h=Date:From:To:Subject:From;
        b=KKkk8rYkMTgZaTbj0E4SbJbULSgKAyfiFz7j46oAw2m4DZ4Lx25sQRW7aQKFGTaiZ
         BCBL12xeuJSt81Ko0V9Obel3K33F4+2HQ4+5DOTWUEkxiyKtW79Ujkv0QlpQla+IrF
         vn1m8I8+p4fYaqmlboDW+yRkfJT/+X4Oianhktfk=
Date:   Sat, 23 Jan 2021 17:49:32 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + mm-filemap-add-filemap_range_uptodate.patch added to
 -mm tree
Message-ID: <20210124014932.umt7MRp2z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: add filemap_range_uptodate
has been added to the -mm tree.  Its filename is
     mm-filemap-add-filemap_range_uptodate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-add-filemap_range_uptodate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-add-filemap_range_uptodate.patch

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
Subject: mm/filemap: add filemap_range_uptodate

Move the complicated condition and the calculations out of
filemap_update_page() into its own function.

Link: https://lkml.kernel.org/r/20210122160140.223228-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   68 ++++++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 28 deletions(-)

--- a/mm/filemap.c~mm-filemap-add-filemap_range_uptodate
+++ a/mm/filemap.c
@@ -2227,11 +2227,36 @@ static int filemap_read_page(struct file
 	return error;
 }
 
+static bool filemap_range_uptodate(struct address_space *mapping,
+		loff_t pos, struct iov_iter *iter, struct page *page)
+{
+	int count;
+
+	if (PageUptodate(page))
+		return true;
+	/* pipes can't handle partially uptodate pages */
+	if (iov_iter_is_pipe(iter))
+		return false;
+	if (!mapping->a_ops->is_partially_uptodate)
+		return false;
+	if (mapping->host->i_blkbits >= (PAGE_SHIFT + thp_order(page)))
+		return false;
+
+	count = iter->count;
+	if (page_offset(page) > pos) {
+		count -= page_offset(page) - pos;
+		pos = 0;
+	} else {
+		pos -= page_offset(page);
+	}
+
+	return mapping->a_ops->is_partially_uptodate(page, pos, count);
+}
+
 static int filemap_update_page(struct kiocb *iocb,
 		struct address_space *mapping, struct iov_iter *iter,
-		struct page *page, loff_t pos, loff_t count)
+		struct page *page)
 {
-	struct inode *inode = mapping->host;
 	int error;
 
 	if (!trylock_page(page)) {
@@ -2248,34 +2273,25 @@ static int filemap_update_page(struct ki
 
 	if (!page->mapping)
 		goto truncated;
-	if (PageUptodate(page))
-		goto uptodate;
-	if (inode->i_blkbits == PAGE_SHIFT ||
-			!mapping->a_ops->is_partially_uptodate)
-		goto readpage;
-	/* pipes can't handle partially uptodate pages */
-	if (unlikely(iov_iter_is_pipe(iter)))
-		goto readpage;
-	if (!mapping->a_ops->is_partially_uptodate(page,
-				pos & (thp_size(page) - 1), count))
-		goto readpage;
-uptodate:
-	unlock_page(page);
-	return 0;
 
-readpage:
-	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ)) {
-		unlock_page(page);
-		return -EAGAIN;
-	}
+	error = 0;
+	if (filemap_range_uptodate(mapping, iocb->ki_pos, iter, page))
+		goto unlock;
+
+	error = -EAGAIN;
+	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ))
+		goto unlock;
+
 	error = filemap_read_page(iocb->ki_filp, mapping, page);
 	if (error == AOP_TRUNCATED_PAGE)
 		put_page(page);
 	return error;
 truncated:
-	unlock_page(page);
+	error = AOP_TRUNCATED_PAGE;
 	put_page(page);
-	return AOP_TRUNCATED_PAGE;
+unlock:
+	unlock_page(page);
+	return error;
 }
 
 static int filemap_create_page(struct file *file,
@@ -2345,9 +2361,6 @@ got_pages:
 	{
 		struct page *page = pvec->pages[pvec->nr - 1];
 		pgoff_t pg_index = page->index;
-		loff_t pg_pos = max(iocb->ki_pos,
-				    (loff_t) pg_index << PAGE_SHIFT);
-		loff_t pg_count = iocb->ki_pos + iter->count - pg_pos;
 
 		if (PageReadahead(page)) {
 			if (iocb->ki_flags & IOCB_NOIO) {
@@ -2364,8 +2377,7 @@ got_pages:
 			if ((iocb->ki_flags & IOCB_WAITQ) &&
 			    pagevec_count(pvec) > 1)
 				iocb->ki_flags |= IOCB_NOWAIT;
-			err = filemap_update_page(iocb, mapping, iter, page,
-					pg_pos, pg_count);
+			err = filemap_update_page(iocb, mapping, iter, page);
 			if (err) {
 				if (err < 0)
 					put_page(page);
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


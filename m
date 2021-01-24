Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF957C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF7B229F0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbhAXBui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:50:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbhAXBu1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:50:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A6AA229F0;
        Sun, 24 Jan 2021 01:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611452977;
        bh=Pxp+bx6Eef9+xSPeJ2Y8R4PKPsl8q65tPfDCL6hDPik=;
        h=Date:From:To:Subject:From;
        b=h0Lilu6PydSkWP9+ucy5sgtiMiQTyB1AYGtWWv8HS3NPhICmyyhN0KcGVpYCmgHvI
         IaxAKavgae37o7uLEMBIzyUNbROH6UCLrNJQPucc0Cfw94gY3TfQRwJeO/sxTmeCYu
         fvY9sTtD2v4++7tZaqyooDA5E+MPWLbPAAPsuxCA=
Date:   Sat, 23 Jan 2021 17:49:36 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch added to
 -mm tree
Message-ID: <20210124014936.X2qLb_ZIV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: split filemap_readahead out of filemap_get_pages
has been added to the -mm tree.  Its filename is
     mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch

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
Subject: mm/filemap: split filemap_readahead out of filemap_get_pages

This simplifies the error handling.

Link: https://lkml.kernel.org/r/20210122160140.223228-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/mm/filemap.c~mm-filemap-split-filemap_readahead-out-of-filemap_get_pages
+++ a/mm/filemap.c
@@ -2323,6 +2323,17 @@ error:
 	return error;
 }
 
+static int filemap_readahead(struct kiocb *iocb, struct file *file,
+		struct address_space *mapping, struct page *page,
+		pgoff_t last_index)
+{
+	if (iocb->ki_flags & IOCB_NOIO)
+		return -EAGAIN;
+	page_cache_async_readahead(mapping, &file->f_ra, file, page,
+			page->index, last_index - page->index);
+	return 0;
+}
+
 static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
 		struct pagevec *pvec)
 {
@@ -2360,17 +2371,15 @@ find_page:
 got_pages:
 	{
 		struct page *page = pvec->pages[pvec->nr - 1];
-		pgoff_t pg_index = page->index;
 
 		if (PageReadahead(page)) {
-			if (iocb->ki_flags & IOCB_NOIO) {
+			err = filemap_readahead(iocb, filp, mapping, page,
+					last_index);
+			if (err) {
 				put_page(page);
 				pvec->nr--;
-				err = -EAGAIN;
 				goto err;
 			}
-			page_cache_async_readahead(mapping, ra, filp, page,
-					pg_index, last_index - pg_index);
 		}
 
 		if (!PageUptodate(page)) {
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


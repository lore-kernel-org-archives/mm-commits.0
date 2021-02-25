Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E7DC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10EE264F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhBYTWQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:22:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234766AbhBYTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7317164F4F;
        Thu, 25 Feb 2021 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280394;
        bh=6iTmPh+Yr22ED0+Mh19Op0CCA16KDe71cDilZmpa0a4=;
        h=Date:From:To:Subject:From;
        b=mWBmBPrnsDE9x0sQdqEAJgbLkTd+Qe4gyq8WoV7lAhVbMdLNUTU9sDyM39rT7Wben
         ioDz/Oy6bsvYtMTxPOqAvoXcanFPCnCpki1n5SpFw0oMiMcgE7BhgvadUJGLNaFZZN
         C4/FCMCPwNquCvzEIpo4psQcji4o4nyoKb0nU4vA=
Date:   Thu, 25 Feb 2021 11:13:14 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch removed
 from -mm tree
Message-ID: <20210225191314.Dx8IqSBFr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: split filemap_readahead out of filemap_get_pages
has been removed from the -mm tree.  Its filename was
     mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2330,6 +2330,17 @@ error:
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
@@ -2367,17 +2378,15 @@ find_page:
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


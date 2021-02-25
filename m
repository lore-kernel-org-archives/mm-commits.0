Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B92C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D77964F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhBYTWC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234754AbhBYTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A788064F52;
        Thu, 25 Feb 2021 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280397;
        bh=AFrnqJYvkB5E5PN40+k1WHbgjdVY56yUA1/6HGEyM4g=;
        h=Date:From:To:Subject:From;
        b=wA2FFoMxhmCJsSROPDuxY/osmaUnct5OxJSjgj4qh+qm3t8kzbpxSDODURi26evtY
         MMi8BgKa5fGE629NzJk7szJ6KHeqNZ+6v9x+kj99Jev7IcSjLoIUMVLWfnDR/Baat+
         CzDN6tCnGp62gTGRCVF6m77EV8Fuaq8/aAJwqG7I=
Date:   Thu, 25 Feb 2021 11:13:17 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged] mm-filemap-restructure-filemap_get_pages.patch
 removed from -mm tree
Message-ID: <20210225191317.yBdMSCP18%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: restructure filemap_get_pages
has been removed from the -mm tree.  Its filename was
     mm-filemap-restructure-filemap_get_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: restructure filemap_get_pages

Remove the got_pages label, remove indentation, rename find_page to retry,
simplify error handling.

Link: https://lkml.kernel.org/r/20210122160140.223228-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   71 +++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 43 deletions(-)

--- a/mm/filemap.c~mm-filemap-restructure-filemap_get_pages
+++ a/mm/filemap.c
@@ -2349,70 +2349,55 @@ static int filemap_get_pages(struct kioc
 	struct file_ra_state *ra = &filp->f_ra;
 	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
 	pgoff_t last_index;
+	struct page *page;
 	int err = 0;
 
 	last_index = DIV_ROUND_UP(iocb->ki_pos + iter->count, PAGE_SIZE);
-find_page:
+retry:
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
 	filemap_get_read_batch(mapping, index, last_index, pvec);
-	if (pvec->nr)
-		goto got_pages;
-
-	if (iocb->ki_flags & IOCB_NOIO)
-		return -EAGAIN;
-
-	page_cache_sync_readahead(mapping, ra, filp, index, last_index - index);
-
-	filemap_get_read_batch(mapping, index, last_index, pvec);
+	if (!pagevec_count(pvec)) {
+		if (iocb->ki_flags & IOCB_NOIO)
+			return -EAGAIN;
+		page_cache_sync_readahead(mapping, ra, filp, index,
+				last_index - index);
+		filemap_get_read_batch(mapping, index, last_index, pvec);
+	}
 	if (!pagevec_count(pvec)) {
 		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
 			return -EAGAIN;
 		err = filemap_create_page(filp, mapping,
 				iocb->ki_pos >> PAGE_SHIFT, pvec);
 		if (err == AOP_TRUNCATED_PAGE)
-			goto find_page;
+			goto retry;
 		return err;
 	}
-got_pages:
-	{
-		struct page *page = pvec->pages[pvec->nr - 1];
-
-		if (PageReadahead(page)) {
-			err = filemap_readahead(iocb, filp, mapping, page,
-					last_index);
-			if (err) {
-				put_page(page);
-				pvec->nr--;
-				goto err;
-			}
-		}
 
-		if (!PageUptodate(page)) {
-			if ((iocb->ki_flags & IOCB_WAITQ) &&
-			    pagevec_count(pvec) > 1)
-				iocb->ki_flags |= IOCB_NOWAIT;
-			err = filemap_update_page(iocb, mapping, iter, page);
-			if (err) {
-				if (err < 0)
-					put_page(page);
-				pvec->nr--;
-			}
-		}
+	page = pvec->pages[pagevec_count(pvec) - 1];
+	if (PageReadahead(page)) {
+		err = filemap_readahead(iocb, filp, mapping, page, last_index);
+		if (err)
+			goto err;
+	}
+	if (!PageUptodate(page)) {
+		if ((iocb->ki_flags & IOCB_WAITQ) && pagevec_count(pvec) > 1)
+			iocb->ki_flags |= IOCB_NOWAIT;
+		err = filemap_update_page(iocb, mapping, iter, page);
+		if (err)
+			goto err;
 	}
 
+	return 0;
 err:
-	if (likely(pvec->nr))
+	if (err < 0)
+		put_page(page);
+	if (likely(--pvec->nr))
 		return 0;
 	if (err == AOP_TRUNCATED_PAGE)
-		goto find_page;
-	if (err)
-		return err;
-	/*
-	 * No pages and no error means we raced and should retry:
-	 */
-	goto find_page;
+		goto retry;
+	return err;
 }
 
 /**
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


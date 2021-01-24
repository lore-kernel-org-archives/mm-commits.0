Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F47C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40A6F22D07
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbhAXBuH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbhAXBuG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:50:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BAE922D07;
        Sun, 24 Jan 2021 01:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611452943;
        bh=ycmRo+S9vVgot63VfAlioH8F/p7JVxHZlL2EjMqlWtM=;
        h=Date:From:To:Subject:From;
        b=Fa5QZWk8qHh1BQ0Om37sCeqcJaCGDA54LU9MpkhSQCoXTnS6bO/Wc62piIW4xjAkK
         1O733fcAp9u0cL88gDLWqlmqY1kFFvPRfNm0L9hmKk4w7IaQqRuKQwrnzxnJ1r+KGo
         bxNwSZiBT77K2IDscXygAgzlcCLYCsi0YmFK/hus=
Date:   Sat, 23 Jan 2021 17:49:02 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + mm-filemap-support-readpage-splitting-a-page.patch
 added to -mm tree
Message-ID: <20210124014902.s9a7rlhgd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: support readpage splitting a page
has been added to the -mm tree.  Its filename is
     mm-filemap-support-readpage-splitting-a-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-support-readpage-splitting-a-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-support-readpage-splitting-a-page.patch

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
Subject: mm/filemap: support readpage splitting a page

For page splitting to succeed, the thread asking to split the page has to
be the only one with a reference to the page.  Calling
wait_on_page_locked() while holding a reference to the page will
effectively prevent this from happening with sufficient threads waiting on
the same page.  Use put_and_wait_on_page_locked() to sleep without holding
a reference to the page, then retry the page lookup after the page is
unlocked.

Since we now get the page lock a little earlier in filemap_update_page(),
we can eliminate a number of duplicate checks.  The original intent
(commit ebded02788b5 ("avoid unnecessary calls to lock_page when waiting
for IO to complete during a read")) behind getting the page lock later was
to avoid re-locking the page after it has been brought uptodate by another
thread.  We still avoid that because we go through the normal lookup path
again after the winning thread has brought the page uptodate.

Link: https://lkml.kernel.org/r/20210122160140.223228-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   76 ++++++++++++++-----------------------------------
 1 file changed, 23 insertions(+), 53 deletions(-)

--- a/mm/filemap.c~mm-filemap-support-readpage-splitting-a-page
+++ a/mm/filemap.c
@@ -1367,14 +1367,6 @@ static int __wait_on_page_locked_async(s
 	return ret;
 }
 
-static int wait_on_page_locked_async(struct page *page,
-				     struct wait_page_queue *wait)
-{
-	if (!PageLocked(page))
-		return 0;
-	return __wait_on_page_locked_async(compound_head(page), wait, false);
-}
-
 /**
  * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
  * @page: The page to wait for.
@@ -2280,64 +2272,42 @@ static struct page *filemap_update_page(
 	struct inode *inode = mapping->host;
 	int error;
 
-	/*
-	 * See comment in do_read_cache_page on why
-	 * wait_on_page_locked is used to avoid unnecessarily
-	 * serialisations and why it's safe.
-	 */
 	if (iocb->ki_flags & IOCB_WAITQ) {
-		error = wait_on_page_locked_async(page,
-						iocb->ki_waitq);
+		error = lock_page_async(page, iocb->ki_waitq);
+		if (error) {
+			put_page(page);
+			return ERR_PTR(error);
+		}
 	} else {
-		error = wait_on_page_locked_killable(page);
-	}
-	if (unlikely(error)) {
-		put_page(page);
-		return ERR_PTR(error);
+		if (!trylock_page(page)) {
+			put_and_wait_on_page_locked(page, TASK_KILLABLE);
+			return NULL;
+		}
 	}
-	if (PageUptodate(page))
-		return page;
 
+	if (!page->mapping)
+		goto truncated;
+	if (PageUptodate(page))
+		goto uptodate;
 	if (inode->i_blkbits == PAGE_SHIFT ||
 			!mapping->a_ops->is_partially_uptodate)
-		goto page_not_up_to_date;
+		goto readpage;
 	/* pipes can't handle partially uptodate pages */
 	if (unlikely(iov_iter_is_pipe(iter)))
-		goto page_not_up_to_date;
-	if (!trylock_page(page))
-		goto page_not_up_to_date;
-	/* Did it get truncated before we got the lock? */
-	if (!page->mapping)
-		goto page_not_up_to_date_locked;
+		goto readpage;
 	if (!mapping->a_ops->is_partially_uptodate(page,
-				pos & ~PAGE_MASK, count))
-		goto page_not_up_to_date_locked;
+				pos & (thp_size(page) - 1), count))
+		goto readpage;
+uptodate:
 	unlock_page(page);
 	return page;
 
-page_not_up_to_date:
-	/* Get exclusive access to the page ... */
-	error = lock_page_for_iocb(iocb, page);
-	if (unlikely(error)) {
-		put_page(page);
-		return ERR_PTR(error);
-	}
-
-page_not_up_to_date_locked:
-	/* Did it get truncated before we got the lock? */
-	if (!page->mapping) {
-		unlock_page(page);
-		put_page(page);
-		return NULL;
-	}
-
-	/* Did somebody else fill it already? */
-	if (PageUptodate(page)) {
-		unlock_page(page);
-		return page;
-	}
-
+readpage:
 	return filemap_read_page(iocb, filp, mapping, page);
+truncated:
+	unlock_page(page);
+	put_page(page);
+	return NULL;
 }
 
 static struct page *filemap_create_page(struct kiocb *iocb,
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


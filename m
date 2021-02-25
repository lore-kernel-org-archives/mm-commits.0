Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452D8C4332B
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E52764F43
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhBYTW4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234775AbhBYTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 977CF64F4C;
        Thu, 25 Feb 2021 19:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280370;
        bh=+zdTvJ3bivIxhek/PcNQgKfZpLMfQX4VEax23zhNa6o=;
        h=Date:From:To:Subject:From;
        b=gRV1c12hWaGLflsh/onlZObG9MkeZQiwnAToIKYeiaIW7W5cxF+X6ZuZjAu25Voq0
         HtKZwvBdSVxgRIUUXAUTMgyi0bkL/Z2DLurT+KEOgsUwAN5IXBA3GpMUqNp0cmfOSp
         Mfg/RUC40wLgu2cueEhCTQVC7SPiRNmF1fX2VL0s=
Date:   Thu, 25 Feb 2021 11:12:50 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-support-readpage-splitting-a-page.patch removed from -mm tree
Message-ID: <20210225191250.VmBpftEuQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: support readpage splitting a page
has been removed from the -mm tree.  Its filename was
     mm-filemap-support-readpage-splitting-a-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1373,14 +1373,6 @@ static int __wait_on_page_locked_async(s
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
@@ -2286,64 +2278,42 @@ static struct page *filemap_update_page(
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


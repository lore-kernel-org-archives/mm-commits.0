Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03698C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B6464F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhBYTWz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234736AbhBYTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A61D264F58;
        Thu, 25 Feb 2021 19:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280376;
        bh=I9rIpx8KQ37ywEm7SbyLn8BkL0iLAPYkbAPJgpefno8=;
        h=Date:From:To:Subject:From;
        b=mvLUoSSv+u5o5Fud0ycwdOZWgj71VsGZDB1bl0BxALDxHnmSmkkn9+rjTdWFRr2aS
         cOVwNwWOa9o58yCMGncZeJvlp+nlQGvIs4T5Aoog1WtOgCBY48iqvlyvSUsNJKUnwc
         zHWrDJYRXPEemHjPjFjhxFR+xfN92F+RG1oQWY5A=
Date:   Thu, 25 Feb 2021 11:12:56 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-dont-call-readpage-if-iocb_waitq-is-set.patch removed from -mm
 tree
Message-ID: <20210225191256.d8onX-hzk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: don't call ->readpage if IOCB_WAITQ is set
has been removed from the -mm tree.  Its filename was
     mm-filemap-dont-call-readpage-if-iocb_waitq-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: don't call ->readpage if IOCB_WAITQ is set

The readpage operation can block in many (most?) filesystems, so we should
punt to a work queue instead of calling it.  This was the last caller of
lock_page_for_iocb(), so remove it.

Link: https://lkml.kernel.org/r/20210122160140.223228-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/mm/filemap.c~mm-filemap-dont-call-readpage-if-iocb_waitq-is-set
+++ a/mm/filemap.c
@@ -2154,16 +2154,6 @@ static void shrink_readahead_size_eio(st
 	ra->ra_pages /= 4;
 }
 
-static int lock_page_for_iocb(struct kiocb *iocb, struct page *page)
-{
-	if (iocb->ki_flags & IOCB_WAITQ)
-		return lock_page_async(page, iocb->ki_waitq);
-	else if (iocb->ki_flags & IOCB_NOWAIT)
-		return trylock_page(page) ? 0 : -EAGAIN;
-	else
-		return lock_page_killable(page);
-}
-
 /*
  * filemap_get_read_batch - Get a batch of pages for read
  *
@@ -2215,7 +2205,7 @@ static struct page *filemap_read_page(st
 	struct file_ra_state *ra = &filp->f_ra;
 	int error;
 
-	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
+	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ)) {
 		unlock_page(page);
 		put_page(page);
 		return ERR_PTR(-EAGAIN);
@@ -2236,7 +2226,7 @@ static struct page *filemap_read_page(st
 	}
 
 	if (!PageUptodate(page)) {
-		error = lock_page_for_iocb(iocb, page);
+		error = lock_page_killable(page);
 		if (unlikely(error)) {
 			put_page(page);
 			return ERR_PTR(error);
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


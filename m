Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A8EC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B47D364F2F
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhBXUDx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235344AbhBXUCq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B045D64F0D;
        Wed, 24 Feb 2021 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196933;
        bh=mv3sydC8iwPhnDe9IKvFJj2EroiDNW/Ic3ZTZGyBEC8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mbSBc69aFp6+S1Hl+gyzr1x/qyQMJVsc8m438HAdBWJ4ZKgPFG+az9xd2A9gu6ELp
         wP/9Mh0iQpK/QYbjYBuNPjrd07eqV8b8dQDl27/QyWuwIEjo0mSUO/Az6FzfqL03ER
         W1l4akPlxYAN5FRp3yZBnysleVLRZkjTpxdoPzNM=
Date:   Wed, 24 Feb 2021 12:02:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 037/173] mm/filemap: don't call ->readpage if
 IOCB_WAITQ is set
Message-ID: <20210224200212.It57cmiS5%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

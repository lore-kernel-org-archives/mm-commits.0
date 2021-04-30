Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082BEC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E222E61462
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhD3F4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhD3F4M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E4B261466;
        Fri, 30 Apr 2021 05:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762124;
        bh=kpzNCcG57QovQCy/AaKA3fwXd9iKuvPrR2ThqJUwguI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZuDgq9ML9pXGt/nYbZtiC9ztHrRChGwZCh2GBl2rwsvX0t3mjPisHc+m5e9Ogl45y
         gcE7plCfTwiWFRk9Kt3VrWaLkuBBuf8Ct/CwpAuoGym5us821+WW1LUZMMHzYnagTm
         NdFqh54nYgq8fHPyL4wk39iBXXQGTCDVX8slc4qI=
Date:   Thu, 29 Apr 2021 22:55:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 043/178] iomap: use
 filemap_range_needs_writeback() for O_DIRECT reads
Message-ID: <20210430055524.Z5Df0yuXI%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Subject: iomap: use filemap_range_needs_writeback() for O_DIRECT reads

For reads, use the better variant of checking for the need to call
filemap_write_and_wait_range() when doing O_DIRECT.  This avoids falling
back to the slow path for IOCB_NOWAIT, if there are no pages to wait for
(or write out).

Link: https://lkml.kernel.org/r/20210224164455.1096727-4-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap/direct-io.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/fs/iomap/direct-io.c~iomap-use-filemap_range_needs_writeback-for-o_direct-reads
+++ a/fs/iomap/direct-io.c
@@ -487,12 +487,28 @@ __iomap_dio_rw(struct kiocb *iocb, struc
 		if (pos >= dio->i_size)
 			goto out_free_dio;
 
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (filemap_range_needs_writeback(mapping, pos, end)) {
+				ret = -EAGAIN;
+				goto out_free_dio;
+			}
+			iomap_flags |= IOMAP_NOWAIT;
+		}
+
 		if (iter_is_iovec(iter))
 			dio->flags |= IOMAP_DIO_DIRTY;
 	} else {
 		iomap_flags |= IOMAP_WRITE;
 		dio->flags |= IOMAP_DIO_WRITE;
 
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (filemap_range_has_page(mapping, pos, end)) {
+				ret = -EAGAIN;
+				goto out_free_dio;
+			}
+			iomap_flags |= IOMAP_NOWAIT;
+		}
+
 		/* for data sync or sync, we need sync completion processing */
 		if (iocb->ki_flags & IOCB_DSYNC)
 			dio->flags |= IOMAP_DIO_NEED_SYNC;
@@ -507,14 +523,6 @@ __iomap_dio_rw(struct kiocb *iocb, struc
 			dio->flags |= IOMAP_DIO_WRITE_FUA;
 	}
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		if (filemap_range_has_page(mapping, pos, end)) {
-			ret = -EAGAIN;
-			goto out_free_dio;
-		}
-		iomap_flags |= IOMAP_NOWAIT;
-	}
-
 	if (dio_flags & IOMAP_DIO_OVERWRITE_ONLY) {
 		ret = -EAGAIN;
 		if (pos >= dio->i_size || pos + count > dio->i_size)
_

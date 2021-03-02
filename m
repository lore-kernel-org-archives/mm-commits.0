Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD3CC433E0
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2C5E64E87
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344705AbhCCNYo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:24:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233706AbhCBXzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:55:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC3A64F47;
        Tue,  2 Mar 2021 23:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614728634;
        bh=1EVkfKcwCqKmPMjOMWsibwBcgWYEMBqSEgEfMf8so6g=;
        h=Date:From:To:Subject:From;
        b=NR93xUBLxX8twK0RDumImHUK8/dBGy8AQwRaRxzpdc8m7sz/TjFx/9tqi6e77gKgC
         Zg79Jo4y89COuTe4EMLOh8CbJUzvxiYK3Y0KImG827iI8a/tYkoJl7eaohSVRcuIfh
         muTg0Q3qB1XrOvAC1e42Uoy7dAJkT8lBcLXAkfOk=
Date:   Tue, 02 Mar 2021 15:43:53 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, jack@suse.cz, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch added to
 -mm tree
Message-ID: <20210302234353.mWAUhQbdY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iomap: use filemap_range_needs_writeback() for O_DIRECT reads
has been added to the -mm tree.  Its filename is
     iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from axboe@kernel.dk are

swap-fix-swapfile-read-write-offset.patch
mm-provide-filemap_range_needs_writeback-helper.patch
mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch
iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch


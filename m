Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496C8C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29FBC61421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEHWld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229679AbhEHWla (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E556141E;
        Sat,  8 May 2021 22:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513628;
        bh=28fJMv6rOzBqJhh/S0R39Rb7xDxg+CWIhCiNrOAmAjU=;
        h=Date:From:To:Subject:From;
        b=M5etfw2QIqPeQe096oB7UWjlHhsa1JdEhCguOyG/9b8RG8sufpKenuS29YLbMIuZV
         1bMxi0ecTOn8MgCHztTdujmCyndDHqgWrvI2hjkLVPs5S0PBj6ZcuH+/rdbjbKZZKr
         NCdKrcJOzd5ceLm5EeZQZZDbZJHL/eatCzAcmJ80=
Date:   Sat, 08 May 2021 15:40:28 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, jack@suse.cz, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch removed
 from -mm tree
Message-ID: <20210508224028.5KDy4F0X4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iomap: use filemap_range_needs_writeback() for O_DIRECT reads
has been removed from the -mm tree.  Its filename was
     iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



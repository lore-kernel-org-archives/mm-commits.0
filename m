Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA17C77B60
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 19:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbjDDTcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 15:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbjDDTcY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 15:32:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9C13A9D
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 12:32:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66B94630C3
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 19:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05A6C433D2;
        Tue,  4 Apr 2023 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680636741;
        bh=ibKS6wGdc6fvHPiLy7RU8m0URBeLWmptJKbz5expqdI=;
        h=Date:To:From:Subject:From;
        b=hecnk3C4kxyz5cJawvZDjYhX1SLtz2m1vNXgGs0vXIZy+ecu0JtaP87KvZ+94ALzf
         0ApMMYS2Ydf8CrhuSQWPOhcAiQO+dLUFcIAh/W4yXv2Fw6hrL+Jo45NlPialipZwwc
         8Xm0Cs6U98uSSrWMrgAibLcPblRcf+LNsg0swSGE=
Date:   Tue, 04 Apr 2023 12:32:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mpage-split-bi_end_io-callback-for-reads-and-writes.patch removed from -mm tree
Message-Id: <20230404193221.C05A6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mpage: split bi_end_io callback for reads and writes
has been removed from the -mm tree.  Its filename was
     mpage-split-bi_end_io-callback-for-reads-and-writes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: mpage: split bi_end_io callback for reads and writes
Date: Mon, 3 Apr 2023 15:22:19 +0200

Split the bi_end_io handler for reads and writes similar to other aops. 
This is a prep patch before we convert end_io handlers to use folios.

Link: https://lkml.kernel.org/r/20230403132221.94921-4-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/fs/mpage.c~mpage-split-bi_end_io-callback-for-reads-and-writes
+++ a/fs/mpage.c
@@ -43,14 +43,28 @@
  * status of that page is hard.  See end_buffer_async_read() for the details.
  * There is no point in duplicating all that complexity.
  */
-static void mpage_end_io(struct bio *bio)
+static void mpage_read_end_io(struct bio *bio)
 {
 	struct bio_vec *bv;
 	struct bvec_iter_all iter_all;
 
 	bio_for_each_segment_all(bv, bio, iter_all) {
 		struct page *page = bv->bv_page;
-		page_endio(page, bio_op(bio),
+		page_endio(page, REQ_OP_READ,
+			   blk_status_to_errno(bio->bi_status));
+	}
+
+	bio_put(bio);
+}
+
+static void mpage_write_end_io(struct bio *bio)
+{
+	struct bio_vec *bv;
+	struct bvec_iter_all iter_all;
+
+	bio_for_each_segment_all(bv, bio, iter_all) {
+		struct page *page = bv->bv_page;
+		page_endio(page, REQ_OP_WRITE,
 			   blk_status_to_errno(bio->bi_status));
 	}
 
@@ -59,7 +73,11 @@ static void mpage_end_io(struct bio *bio
 
 static struct bio *mpage_bio_submit(struct bio *bio)
 {
-	bio->bi_end_io = mpage_end_io;
+	if (op_is_write(bio_op(bio)))
+		bio->bi_end_io = mpage_write_end_io;
+	else
+		bio->bi_end_io = mpage_read_end_io;
+
 	guard_bio_eod(bio);
 	submit_bio(bio);
 	return NULL;
_

Patches currently in -mm which might be from p.raghav@samsung.com are

mpage-use-folios-in-bio-end_io-handler.patch
filemap-remove-page_endio.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D39C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjDRXhU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjDRXfw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B89C671
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8613663A0D
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8A1C433EF;
        Tue, 18 Apr 2023 23:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860907;
        bh=S+sarjd/IaLA5Up9bKCyKkZu1+8XEOK4rhWDMsSr2yo=;
        h=Date:To:From:Subject:From;
        b=kiy8klCyeLTttiJmBGyhrJ73iQePmTqfH0f7PAOZ/oX5umg2RNR6DUyklHXA8LuaX
         C25CDdu8owWCEmTNbKJvr6FCo043tOyCI65psGChUco0xPzkVzkr9yl61RBgYf/JqF
         g4HWUz4LQomFXzuSDKgQXDlQASFFdfeIfe192v6g=
Date:   Tue, 18 Apr 2023 16:35:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mpage-use-folios-in-bio-end_io-handler.patch removed from -mm tree
Message-Id: <20230418233506.DF8A1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mpage: use folios in bio end_io handler
has been removed from the -mm tree.  Its filename was
     mpage-use-folios-in-bio-end_io-handler.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: mpage: use folios in bio end_io handler
Date: Tue, 11 Apr 2023 14:29:20 +0200

Use folios in the bio end_io handler.  This conversion does the
appropriate handling on the folios in the respective end_io callback and
removes the call to page_endio(), which is soon to be removed.

Link: https://lkml.kernel.org/r/20230411122920.30134-4-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

 fs/mpage.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/fs/mpage.c~mpage-use-folios-in-bio-end_io-handler
+++ a/fs/mpage.c
@@ -45,24 +45,32 @@
  */
 static void mpage_read_end_io(struct bio *bio)
 {
-	struct bio_vec *bv;
-	struct bvec_iter_all iter_all;
+	struct folio_iter fi;
+	int err = blk_status_to_errno(bio->bi_status);
 
-	bio_for_each_segment_all(bv, bio, iter_all)
-		page_endio(bv->bv_page, REQ_OP_READ,
-			   blk_status_to_errno(bio->bi_status));
+	bio_for_each_folio_all(fi, bio) {
+		if (err)
+			folio_set_error(fi.folio);
+		else
+			folio_mark_uptodate(fi.folio);
+		folio_unlock(fi.folio);
+	}
 
 	bio_put(bio);
 }
 
 static void mpage_write_end_io(struct bio *bio)
 {
-	struct bio_vec *bv;
-	struct bvec_iter_all iter_all;
+	struct folio_iter fi;
+	int err = blk_status_to_errno(bio->bi_status);
 
-	bio_for_each_segment_all(bv, bio, iter_all)
-		page_endio(bv->bv_page, REQ_OP_WRITE,
-			   blk_status_to_errno(bio->bi_status));
+	bio_for_each_folio_all(fi, bio) {
+		if (err) {
+			folio_set_error(fi.folio);
+			mapping_set_error(fi.folio->mapping, err);
+		}
+		folio_end_writeback(fi.folio);
+	}
 
 	bio_put(bio);
 }
_

Patches currently in -mm which might be from p.raghav@samsung.com are

fs-buffer-add-folio_set_bh-helper.patch
buffer-add-folio_alloc_buffers-helper.patch
fs-buffer-add-folio_create_empty_buffers-helper.patch
fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch


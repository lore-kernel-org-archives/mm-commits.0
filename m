Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE934C76188
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 20:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbjDCUnE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 16:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbjDCUm6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 16:42:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C1635B3
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 13:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1982662AE4
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 20:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71181C433EF;
        Mon,  3 Apr 2023 20:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680554570;
        bh=AdP7XRnAaLo47eosHDRLSMN9NcnfpZKR5KKVlHgrLts=;
        h=Date:To:From:Subject:From;
        b=urPcYRa+eoDfV2CHyaNnJ3+0k7GAIkiba66Op6XOcb5hf3B58JtYV5VPAycS5LnXH
         V50htIx5uDcVS4x91LipMmfx3p5vOBCKiNpvh/8y5xVAnGy3r4g9KHodC9lD11WzZI
         6RkpU3VS2gYy2L3x6aw+CeRKkoLke+FK0o56mCkg=
Date:   Mon, 03 Apr 2023 13:42:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mpage-use-folios-in-bio-end_io-handler.patch added to mm-unstable branch
Message-Id: <20230403204250.71181C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mpage: use folios in bio end_io handler
has been added to the -mm mm-unstable branch.  Its filename is
     mpage-use-folios-in-bio-end_io-handler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mpage-use-folios-in-bio-end_io-handler.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: mpage: use folios in bio end_io handler
Date: Mon, 3 Apr 2023 15:22:20 +0200

Use folios in the bio end_io handler.  This conversion does the
appropriate handling on the folios in the respective end_io callback and
removes the call to page_endio(), which is soon to be removed.

Link: https://lkml.kernel.org/r/20230403132221.94921-5-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/fs/mpage.c~mpage-use-folios-in-bio-end_io-handler
+++ a/fs/mpage.c
@@ -45,13 +45,15 @@
  */
 static void mpage_read_end_io(struct bio *bio)
 {
-	struct bio_vec *bv;
-	struct bvec_iter_all iter_all;
+	struct folio_iter fi;
+	int err = blk_status_to_errno(bio->bi_status);
 
-	bio_for_each_segment_all(bv, bio, iter_all) {
-		struct page *page = bv->bv_page;
-		page_endio(page, REQ_OP_READ,
-			   blk_status_to_errno(bio->bi_status));
+	bio_for_each_folio_all(fi, bio) {
+		if (!err)
+			folio_mark_uptodate(fi.folio);
+		else
+			folio_set_error(fi.folio);
+		folio_unlock(fi.folio);
 	}
 
 	bio_put(bio);
@@ -59,13 +61,15 @@ static void mpage_read_end_io(struct bio
 
 static void mpage_write_end_io(struct bio *bio)
 {
-	struct bio_vec *bv;
-	struct bvec_iter_all iter_all;
+	struct folio_iter fi;
+	int err = blk_status_to_errno(bio->bi_status);
 
-	bio_for_each_segment_all(bv, bio, iter_all) {
-		struct page *page = bv->bv_page;
-		page_endio(page, REQ_OP_WRITE,
-			   blk_status_to_errno(bio->bi_status));
+	bio_for_each_folio_all(fi, bio) {
+		if (err) {
+			folio_set_error(fi.folio);
+			mapping_set_error(fi.folio->mapping, err);
+		}
+		folio_end_writeback(fi.folio);
 	}
 
 	bio_put(bio);
_

Patches currently in -mm which might be from p.raghav@samsung.com are

zram-always-chain-bio-to-the-parent-in-read_from_bdev_async.patch
orangefs-use-folios-in-orangefs_readahead.patch
mpage-split-bi_end_io-callback-for-reads-and-writes.patch
mpage-use-folios-in-bio-end_io-handler.patch
filemap-remove-page_endio.patch


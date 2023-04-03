Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC37C76188
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 20:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjDCUmt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 16:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjDCUms (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 16:42:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0175AE1
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 13:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DD7562AEC
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 20:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E2EC433D2;
        Mon,  3 Apr 2023 20:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680554567;
        bh=d4H13ARZ5SvfsgZCtKdfJJyqbPxLcQubawLolMIsrQ8=;
        h=Date:To:From:Subject:From;
        b=LfK9pNmlvHjugHCe2JhujpdVBB6l0DlVHlB2L7MR5a6l8n2cfO0pQnXH4PnoikK53
         CpWc83Ev1NDCJWfKsWSKNZffyrNY9uLtbZI1RqshaGmIiSTrONy9IgxGY9pAdIEkZJ
         h/HP/dV1LN++cVPeHz4NLmRGnSuc6Ly44Y/v4bXo=
Date:   Mon, 03 Apr 2023 13:42:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + orangefs-use-folios-in-orangefs_readahead.patch added to mm-unstable branch
Message-Id: <20230403204246.E7E2EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: orangefs: use folios in orangefs_readahead
has been added to the -mm mm-unstable branch.  Its filename is
     orangefs-use-folios-in-orangefs_readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/orangefs-use-folios-in-orangefs_readahead.patch

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
Subject: orangefs: use folios in orangefs_readahead
Date: Mon, 3 Apr 2023 15:22:18 +0200

Convert orangefs_readahead() from using struct page to struct folio.  This
conversion removes the call to page_endio() which is soon to be removed,
and simplifies the final page handling.

The page error flags is not required to be set in the error case as
orangefs doesn't depend on them.

Link: https://lkml.kernel.org/r/20230403132221.94921-3-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Mike Marshall <hubcap@omnibond.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/orangefs/inode.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/orangefs/inode.c~orangefs-use-folios-in-orangefs_readahead
+++ a/fs/orangefs/inode.c
@@ -244,7 +244,7 @@ static void orangefs_readahead(struct re
 	struct iov_iter iter;
 	struct inode *inode = rac->mapping->host;
 	struct xarray *i_pages;
-	struct page *page;
+	struct folio *folio;
 	loff_t new_start = readahead_pos(rac);
 	int ret;
 	size_t new_len = 0;
@@ -275,9 +275,10 @@ static void orangefs_readahead(struct re
 		ret = 0;
 
 	/* clean up. */
-	while ((page = readahead_page(rac))) {
-		page_endio(page, false, ret);
-		put_page(page);
+	while ((folio = readahead_folio(rac))) {
+		if (!ret)
+			folio_mark_uptodate(folio);
+		folio_unlock(folio);
 	}
 }
 
_

Patches currently in -mm which might be from p.raghav@samsung.com are

zram-always-chain-bio-to-the-parent-in-read_from_bdev_async.patch
orangefs-use-folios-in-orangefs_readahead.patch
mpage-split-bi_end_io-callback-for-reads-and-writes.patch
mpage-use-folios-in-bio-end_io-handler.patch
filemap-remove-page_endio.patch


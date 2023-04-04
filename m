Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B85AC761A6
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 19:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbjDDTcX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 15:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbjDDTcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 15:32:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6542111
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 12:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDAC063404
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 19:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A82C433D2;
        Tue,  4 Apr 2023 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680636740;
        bh=F4XwSZ3B5eAkE89YcBfsaIE16pfJpYZK9q7DTl/1Nlc=;
        h=Date:To:From:Subject:From;
        b=0HL09A88znRz+FrHnhfzAHO6aGR1WTOVOoEm93QqNj1jc1YyVLEf4j80piqIw7Sv3
         lB4CzMpxY5fP+JQ/t7CV9WytVZIilGv5CIeG+QWg0oHQ6oMHGA6MFYX5n0cL4hQNHa
         7v2zWYQzpmDsZMJKzxKRyYxxUUcerxWSBiuKPwTE=
Date:   Tue, 04 Apr 2023 12:32:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] orangefs-use-folios-in-orangefs_readahead.patch removed from -mm tree
Message-Id: <20230404193220.38A82C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: orangefs: use folios in orangefs_readahead
has been removed from the -mm tree.  Its filename was
     orangefs-use-folios-in-orangefs_readahead.patch

This patch was dropped because an updated version will be merged

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

mpage-split-bi_end_io-callback-for-reads-and-writes.patch
mpage-use-folios-in-bio-end_io-handler.patch
filemap-remove-page_endio.patch


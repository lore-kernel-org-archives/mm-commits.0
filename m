Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFACC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjDRXhC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjDRXfw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687EBC667
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49EEB62BAD
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E0DC433EF;
        Tue, 18 Apr 2023 23:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860904;
        bh=TmPfAdrr+wtj6igC287WH+PaEBsUifyeUpvQMzFWNYU=;
        h=Date:To:From:Subject:From;
        b=LtcURBNlDcauJI4nA4MAzTSwQ+Q4oZ8DrnfHeUqg64UU7w5QanJsHhqyF2U3IDxad
         +ter9zkvp6mxKrXpTW/5qGqGUG+EGt1wZ6aB5Qc+pOyT4re4oML1EkxfP5YInSjY/h
         v84ZUfF3N8rVazuVNsXbhsWuE+CAEPh1SQK//7TI=
Date:   Tue, 18 Apr 2023 16:35:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] orangefs-use-folios-in-orangefs_readahead.patch removed from -mm tree
Message-Id: <20230418233504.A3E0DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: orangefs: use folios in orangefs_readahead
has been removed from the -mm tree.  Its filename was
     orangefs-use-folios-in-orangefs_readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: orangefs: use folios in orangefs_readahead
Date: Tue, 11 Apr 2023 14:29:18 +0200

Patch series "remove page_endio()", v3.

It was decided to remove the page_endio() as per the previous RFC
discussion[1] of this series and move that functionality into the caller
itself.  One of the side benefit of doing that is the callers have been
modified to directly work on folios as page_endio() already worked on
folios.

As Christoph is doing ZRAM cleanups[4] which will get rid of page_endio()
function usage, I removed the final patch that removes page_endio()[5].  I
will send it separately after rc-1 once the zram cleanups are merged.

mpage changes were tested with a simple boot testing and running a fio
workload on ext2 filesystem.  orangefs was tested by Mike Marshall (No
code changes since he tested).


This patch (of 3):

Convert orangefs_readahead() from using struct page to struct folio.  This
conversion removes the call to page_endio() which is soon to be removed,
and simplifies the final page handling.

The page error flags is not required to be set in the error case as
orangefs doesn't depend on them.

Link: https://lkml.kernel.org/r/20230411122920.30134-1-p.raghav@samsung.com
Link: https://lkml.kernel.org/r/20230411122920.30134-2-p.raghav@samsung.com
Link: https://lore.kernel.org/linux-mm/ZBHcl8Pz2ULb4RGD@infradead.org/ [1]
Link: https://lore.kernel.org/linux-mm/20230322135013.197076-1-p.raghav@samsung.com/ [2]
Link: https://lore.kernel.org/linux-mm/8adb0770-6124-e11f-2551-6582db27ed32@samsung.com/ [3]
Link: https://lore.kernel.org/linux-block/20230404150536.2142108-1-hch@lst.de/T/#t [4]
Link: https://lore.kernel.org/lkml/20230403132221.94921-6-p.raghav@samsung.com/ [5]
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Mike Marshall <hubcap@omnibond.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
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

mpage-split-submit_bio-and-bio-end_io-handler-for-reads-and-writes.patch
mpage-use-folios-in-bio-end_io-handler.patch
fs-buffer-add-folio_set_bh-helper.patch
buffer-add-folio_alloc_buffers-helper.patch
fs-buffer-add-folio_create_empty_buffers-helper.patch
fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch


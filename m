Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EADC76196
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 22:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjDKWOF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 18:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKWOF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 18:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D7F2D66
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 15:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F59A6135F
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 22:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62F0C433D2;
        Tue, 11 Apr 2023 22:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681251242;
        bh=4ghNnn0X8KjwDUq374Sl3qzH6CNdWYrZ8N8G9oJFHkg=;
        h=Date:To:From:Subject:From;
        b=IJ4A0iYWpunU0fWJ54TvcQlHIfFeOV6LR3+7Ir2a2EdBG6p2f+K8HneuD/PacCwaw
         NnPeLZl+tXgmV3jDTkFYz5JDLoMyGHUqg4NcAP6MAg4aojy2aWHZGdTkpHzciEFL25
         f1ehN4/S8uITUS1wyk9/KMr8/LG56UhD/raGp/fE=
Date:   Tue, 11 Apr 2023 15:14:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + orangefs-use-folios-in-orangefs_readahead.patch added to mm-unstable branch
Message-Id: <20230411221402.C62F0C433D2@smtp.kernel.org>
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

orangefs-use-folios-in-orangefs_readahead.patch
mpage-split-submit_bio-and-bio-end_io-handler-for-reads-and-writes.patch
mpage-use-folios-in-bio-end_io-handler.patch


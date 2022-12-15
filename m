Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57AFC10F1E
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiLOXKQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiLOXJm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271F14B994
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1FD2B81CD8
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EAAC433EF;
        Thu, 15 Dec 2022 23:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145772;
        bh=2tfzH5pfvaDgHFDeMu/x5ahzVVC4PMKdjdghKcct0Bs=;
        h=Date:To:From:Subject:From;
        b=AY0JjErPsF6woSII4E6NVY3av1zo9nwn3LeNrW6Ve5NmLzgDO1oGiBn7xmhRE8f9g
         RtESFlazywgwQw3U6SDSpm+S9GjJcynwM9G4FtjEF9xoIzYrplrE4aBnOhrtyRegZV
         pb6Q2G7sNCHrnxy0YAn7rEDYqNUxaeWaVLp6iP1k=
Date:   Thu, 15 Dec 2022 15:09:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-use-b_folio-in-end_buffer_async_write.patch added to mm-unstable branch
Message-Id: <20221215230932.90EAAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: use b_folio in end_buffer_async_write()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-use-b_folio-in-end_buffer_async_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-use-b_folio-in-end_buffer_async_write.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: use b_folio in end_buffer_async_write()
Date: Thu, 15 Dec 2022 21:43:55 +0000

Save 76 bytes from avoiding the call to compound_head() in SetPageError().
Also avoid the call to compound_head() in end_page_writeback().

Link: https://lkml.kernel.org/r/20221215214402.3522366-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/buffer.c~buffer-use-b_folio-in-end_buffer_async_write
+++ a/fs/buffer.c
@@ -344,21 +344,21 @@ void end_buffer_async_write(struct buffe
 	unsigned long flags;
 	struct buffer_head *first;
 	struct buffer_head *tmp;
-	struct page *page;
+	struct folio *folio;
 
 	BUG_ON(!buffer_async_write(bh));
 
-	page = bh->b_page;
+	folio = bh->b_folio;
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
 		buffer_io_error(bh, ", lost async page write");
 		mark_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);
-		SetPageError(page);
+		folio_set_error(folio);
 	}
 
-	first = page_buffers(page);
+	first = folio_buffers(folio);
 	spin_lock_irqsave(&first->b_uptodate_lock, flags);
 
 	clear_buffer_async_write(bh);
@@ -372,7 +372,7 @@ void end_buffer_async_write(struct buffe
 		tmp = tmp->b_this_page;
 	}
 	spin_unlock_irqrestore(&first->b_uptodate_lock, flags);
-	end_page_writeback(page);
+	folio_end_writeback(folio);
 	return;
 
 still_busy:
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch


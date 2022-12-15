Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E459FC46467
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiLOXKE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiLOXJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADDF29C97
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E31B81CD6
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EB2C433D2;
        Thu, 15 Dec 2022 23:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145770;
        bh=Hl2jGhd7SZ78wzhwvhfO4MKUxr+6l+BnBhiMN2SE8VA=;
        h=Date:To:From:Subject:From;
        b=kDgf2TergKT37hwmLqEaUVKioPlCWQfnFxSvty0qKWfc9jixtkQM9jP1uZ1Tr/lDT
         GZbgJ3rgiV8s3A135nA3LPXGnDB9RkaS3RVF9jObAmWBhc/SixI5TuEYvT8Rz6+aSQ
         IpP3nKxtY9JTWVvFh4fFyCAF2hP13jEb5sp3KaEc=
Date:   Thu, 15 Dec 2022 15:09:30 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-use-b_folio-in-end_buffer_async_read.patch added to mm-unstable branch
Message-Id: <20221215230930.C9EB2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: use b_folio in end_buffer_async_read()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-use-b_folio-in-end_buffer_async_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-use-b_folio-in-end_buffer_async_read.patch

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
Subject: buffer: use b_folio in end_buffer_async_read()
Date: Thu, 15 Dec 2022 21:43:54 +0000

Removes a call to compound_head() in SetPageError(), saving 76 bytes of
text.

Link: https://lkml.kernel.org/r/20221215214402.3522366-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/buffer.c~buffer-use-b_folio-in-end_buffer_async_read
+++ a/fs/buffer.c
@@ -246,18 +246,18 @@ static void end_buffer_async_read(struct
 	unsigned long flags;
 	struct buffer_head *first;
 	struct buffer_head *tmp;
-	struct page *page;
-	int page_uptodate = 1;
+	struct folio *folio;
+	int folio_uptodate = 1;
 
 	BUG_ON(!buffer_async_read(bh));
 
-	page = bh->b_page;
+	folio = bh->b_folio;
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
 		clear_buffer_uptodate(bh);
 		buffer_io_error(bh, ", async page read");
-		SetPageError(page);
+		folio_set_error(folio);
 	}
 
 	/*
@@ -265,14 +265,14 @@ static void end_buffer_async_read(struct
 	 * two buffer heads end IO at almost the same time and both
 	 * decide that the page is now completely done.
 	 */
-	first = page_buffers(page);
+	first = folio_buffers(folio);
 	spin_lock_irqsave(&first->b_uptodate_lock, flags);
 	clear_buffer_async_read(bh);
 	unlock_buffer(bh);
 	tmp = bh;
 	do {
 		if (!buffer_uptodate(tmp))
-			page_uptodate = 0;
+			folio_uptodate = 0;
 		if (buffer_async_read(tmp)) {
 			BUG_ON(!buffer_locked(tmp));
 			goto still_busy;
@@ -285,9 +285,9 @@ static void end_buffer_async_read(struct
 	 * If all of the buffers are uptodate then we can set the page
 	 * uptodate.
 	 */
-	if (page_uptodate)
-		SetPageUptodate(page);
-	unlock_page(page);
+	if (folio_uptodate)
+		folio_mark_uptodate(folio);
+	folio_unlock(folio);
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


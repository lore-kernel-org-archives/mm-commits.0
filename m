Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C66DC4167B
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiLOXKZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiLOXJn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4764A07B
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33489B81CD8
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD24FC433D2;
        Thu, 15 Dec 2022 23:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145779;
        bh=YvasGuTxP+DwLH337JD0Fyo6C68R1ovldz0nzL/boa4=;
        h=Date:To:From:Subject:From;
        b=myIPhHSadD3+mh4jFrOnAUKitJ++yR8s0lMt3g515Ws0eEGLXMxhN7JrjdYS7SvcQ
         M7YCs8iifl4Mlja2Q7WcP4+LEs43GYC+cs8OpsDsDrPnZ75sHcOQSVWtIDts6qY5MC
         XBNxmYm4+jKwNHK7FYq9cYPmMZlqbhOOHlsx6yUI=
Date:   Thu, 15 Dec 2022 15:09:39 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch added to mm-unstable branch
Message-Id: <20221215230939.CD24FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2: replace obvious uses of b_page with b_folio
has been added to the -mm mm-unstable branch.  Its filename is
     jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch

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
Subject: jbd2: replace obvious uses of b_page with b_folio
Date: Thu, 15 Dec 2022 21:43:59 +0000

These places just use b_page to get to the buffer's address_space or have
already been converted to folio.

Link: https://lkml.kernel.org/r/20221215214402.3522366-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/commit.c  |    8 ++------
 fs/jbd2/journal.c |    2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/fs/jbd2/commit.c~jbd2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/jbd2/commit.c
@@ -63,16 +63,12 @@ static void journal_end_buffer_io_sync(s
 static void release_buffer_page(struct buffer_head *bh)
 {
 	struct folio *folio;
-	struct page *page;
 
 	if (buffer_dirty(bh))
 		goto nope;
 	if (atomic_read(&bh->b_count) != 1)
 		goto nope;
-	page = bh->b_page;
-	if (!page)
-		goto nope;
-	folio = page_folio(page);
+	folio = bh->b_folio;
 	if (folio->mapping)
 		goto nope;
 
@@ -1040,7 +1036,7 @@ restart_loop:
 			 * already detached from the mapping and buffers cannot
 			 * get reused.
 			 */
-			mapping = READ_ONCE(bh->b_page->mapping);
+			mapping = READ_ONCE(bh->b_folio->mapping);
 			if (mapping && !sb_is_blkdev_sb(mapping->host->i_sb)) {
 				clear_buffer_mapped(bh);
 				clear_buffer_new(bh);
--- a/fs/jbd2/journal.c~jbd2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/jbd2/journal.c
@@ -2938,7 +2938,7 @@ repeat:
 	} else {
 		J_ASSERT_BH(bh,
 			(atomic_read(&bh->b_count) > 0) ||
-			(bh->b_page && bh->b_page->mapping));
+			(bh->b_folio && bh->b_folio->mapping));
 
 		if (!new_jh) {
 			jbd_unlock_bh_journal_head(bh);
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


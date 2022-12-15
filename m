Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A618C10F1E
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiLOXKD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiLOXJk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39699654C0
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A779461F88
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7FBC433D2;
        Thu, 15 Dec 2022 23:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145769;
        bh=K32XoFYac4IUKp0ylkdVUFXknta/tRoTJIrA4viDJY4=;
        h=Date:To:From:Subject:From;
        b=wdX/h8ChBLq5J+Sr7QGWqq71/bKPl61w0IUB53zfljursem6vgyCf5DeGQoLt8771
         BU2l4fcf63EjNnKyCOmY0VPBjOxDPpHsrrhSSGmaAGgkB5dgSHVvNCQiAUuaahmZXv
         0kaZ5+2A7CjFn6A6Vb+9HW7CI5nPV3XlRQFQKd/Y=
Date:   Thu, 15 Dec 2022 15:09:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-use-b_folio-in-touch_buffer.patch added to mm-unstable branch
Message-Id: <20221215230929.0B7FBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: use b_folio in touch_buffer()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-use-b_folio-in-touch_buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-use-b_folio-in-touch_buffer.patch

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
Subject: buffer: use b_folio in touch_buffer()
Date: Thu, 15 Dec 2022 21:43:53 +0000

Removes a call to compound_head() in this path.

Link: https://lkml.kernel.org/r/20221215214402.3522366-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/buffer.c~buffer-use-b_folio-in-touch_buffer
+++ a/fs/buffer.c
@@ -60,7 +60,7 @@ static void submit_bh_wbc(blk_opf_t opf,
 inline void touch_buffer(struct buffer_head *bh)
 {
 	trace_block_touch_buffer(bh);
-	mark_page_accessed(bh->b_page);
+	folio_mark_accessed(bh->b_folio);
 }
 EXPORT_SYMBOL(touch_buffer);
 
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


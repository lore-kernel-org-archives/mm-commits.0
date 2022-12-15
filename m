Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD2CC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiLOXKB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiLOXJk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232D162EB7
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D55E4B81CD5
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A397C433EF;
        Thu, 15 Dec 2022 23:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145765;
        bh=eoZbgtjBl8V08LxJpStlFh/SOLJecM21dc2T4HuWc8E=;
        h=Date:To:From:Subject:From;
        b=0oBjiWFk51AeJ7QkWDFN73kpTGcRAxPLK8VPjrfpQbDiSOz6C4jYAyUKaD6A8d3z/
         GH1KUkhiMitooBNi3y9ZqiPuG/88ph+nUnVgVr1dksi59cjE8ZOGPthhDyNqIiUBtB
         Uxlq4FHCWLE3ahZQ8Ii6FzzDwIg/Oqs1akXigm6c=
Date:   Thu, 15 Dec 2022 15:09:24 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-add-b_folio-as-an-alias-of-b_page.patch added to mm-unstable branch
Message-Id: <20221215230925.8A397C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: add b_folio as an alias of b_page
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-add-b_folio-as-an-alias-of-b_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-add-b_folio-as-an-alias-of-b_page.patch

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
Subject: buffer: add b_folio as an alias of b_page
Date: Thu, 15 Dec 2022 21:43:51 +0000

Patch series "Start converting buffer_heads to use folios".

I was hoping that filesystems would convert from buffer_heads to iomap,
but that's not happening particularly quickly.  So the buffer_head
infrastructure needs to be converted from being page-based to being
folio-based.


This patch (of 12):

Buffer heads point to the allocation (ie the folio), not the page.  This
is currently the same thing for all filesystems that use buffer heads, so
this is a safe transitional step.

Link: https://lkml.kernel.org/r/20221215214402.3522366-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20221215214402.3522366-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buffer_head.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/buffer_head.h~buffer-add-b_folio-as-an-alias-of-b_page
+++ a/include/linux/buffer_head.h
@@ -61,7 +61,10 @@ typedef void (bh_end_io_t)(struct buffer
 struct buffer_head {
 	unsigned long b_state;		/* buffer state bitmap (see above) */
 	struct buffer_head *b_this_page;/* circular list of page's buffers */
-	struct page *b_page;		/* the page this bh is mapped to */
+	union {
+		struct page *b_page;	/* the page this bh is mapped to */
+		struct folio *b_folio;	/* the folio this bh is mapped to */
+	};
 
 	sector_t b_blocknr;		/* start block number */
 	size_t b_size;			/* size of mapping */
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


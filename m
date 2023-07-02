Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F02EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 20:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjGBUJL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 16:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjGBUIp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 16:08:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5944212
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 13:07:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F24BA60C7A
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 20:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51742C433C7;
        Sun,  2 Jul 2023 20:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688328433;
        bh=vXBq07hcQJn3Q0AnpgcEQ2HPS5oOnvCbhjM+uBAobdA=;
        h=Date:To:From:Subject:From;
        b=q4Q+uNXXM4YgtyHyk6OyX9la4PnlN3dM3QKDXD5pw1ptXltGl2IYbVATu31MuQWQ8
         m7yOPRTirmv37vCm+UUZEJLp/IIBFMxMwG2n4OADwayemvqsf1dPfClQUZTaRkca7M
         GSLS3ypsNAFQnejad+znPp+LSEnnNU/lHkHtjt+4=
Date:   Sun, 02 Jul 2023 13:07:12 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        david@fromorbit.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-account-the-number-of-pages-written-back.patch added to mm-hotfixes-unstable branch
Message-Id: <20230702200713.51742C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: account the number of pages written back
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     writeback-account-the-number-of-pages-written-back.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-account-the-number-of-pages-written-back.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: writeback: account the number of pages written back
Date: Wed, 28 Jun 2023 19:55:48 +0100

nr_to_write is a count of pages, so we need to decrease it by the number
of pages in the folio we just wrote, not by 1.  Most callers specify
either LONG_MAX or 1, so are unaffected, but writeback_sb_inodes() might
end up writing 512x as many pages as it asked for.

Link: https://lkml.kernel.org/r/20230628185548.981888-1-willy@infradead.org
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/page-writeback.c~writeback-account-the-number-of-pages-written-back
+++ a/mm/page-writeback.c
@@ -2434,6 +2434,7 @@ int write_cache_pages(struct address_spa
 
 		for (i = 0; i < nr_folios; i++) {
 			struct folio *folio = fbatch.folios[i];
+			unsigned long nr;
 
 			done_index = folio->index;
 
@@ -2471,6 +2472,7 @@ continue_unlock:
 
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
 			error = writepage(folio, wbc, data);
+			nr = folio_nr_pages(folio);
 			if (unlikely(error)) {
 				/*
 				 * Handle errors according to the type of
@@ -2489,8 +2491,7 @@ continue_unlock:
 					error = 0;
 				} else if (wbc->sync_mode != WB_SYNC_ALL) {
 					ret = error;
-					done_index = folio->index +
-						folio_nr_pages(folio);
+					done_index = folio->index + nr;
 					done = 1;
 					break;
 				}
@@ -2504,7 +2505,8 @@ continue_unlock:
 			 * keep going until we have written all the pages
 			 * we tagged for writeback prior to entering this loop.
 			 */
-			if (--wbc->nr_to_write <= 0 &&
+			wbc->nr_to_write -= nr;
+			if (wbc->nr_to_write <= 0 &&
 			    wbc->sync_mode == WB_SYNC_NONE) {
 				done = 1;
 				break;
_

Patches currently in -mm which might be from willy@infradead.org are

writeback-account-the-number-of-pages-written-back.patch


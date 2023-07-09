Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456F1EB64DC
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjGIAag (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjGIAaZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46632E4C
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D446C60B67
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3213EC433C7;
        Sun,  9 Jul 2023 00:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862623;
        bh=3xS1xmG59a94tWHfc8XUMQekOmYAnCui2HbnYGe+dIY=;
        h=Date:To:From:Subject:From;
        b=i09BJhQJW5g2MkxhzCmCzKTm+nekvOLOqDzf9z2AiWgwOiFWIvvdoNMRS3kSF9Ieg
         wwNsZJRgsucaDVuuYjOnk9wGmJooWwU672GI93pZpxnf2yIKoiTM4UmlRxtv0h1431
         atAW7UHSkWM5KrLOGLDUp6LqIU1/v7KXqIjTL04E=
Date:   Sat, 08 Jul 2023 17:30:22 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        david@fromorbit.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] writeback-account-the-number-of-pages-written-back.patch removed from -mm tree
Message-Id: <20230709003023.3213EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: writeback: account the number of pages written back
has been removed from the -mm tree.  Its filename was
     writeback-account-the-number-of-pages-written-back.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: account the number of pages written back
Date: Wed, 28 Jun 2023 19:55:48 +0100

nr_to_write is a count of pages, so we need to decrease it by the number
of pages in the folio we just wrote, not by 1.  Most callers specify
either LONG_MAX or 1, so are unaffected, but writeback_sb_inodes() might
end up writing 512x as many pages as it asked for.

Dave added:

: XFS is the only filesystem this would affect, right?  AFAIA, nothing
: else enables large folios and uses writeback through
: write_cache_pages() at this point...
: 
: In which case, I'd be surprised if much difference, if any, gets
: noticed by anyone.

Link: https://lkml.kernel.org/r/20230628185548.981888-1-willy@infradead.org
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

rmap-pass-the-folio-to-__page_check_anon_rmap.patch


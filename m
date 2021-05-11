Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA1BC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B780461622
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhEKBMA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 21:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229628AbhEKBMA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 21:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA43D60233;
        Tue, 11 May 2021 01:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620695454;
        bh=/98A91o+Z2vIWD4r+/VBNDCeBgioSDRpX+pmy5/jGGg=;
        h=Date:From:To:Subject:From;
        b=D8o1xYlwwNgBK4BE7JL/E9h3T6/17YEhT/VeIemaYqtpE4+BsTFhWwV4GMHJPEp02
         QJZN638x0a777RK/EFXYnM0UiBhFqr31vc3+6Obokm9rx91Qm+NRmMcUuQUE2Zvkai
         yDyJ72O2i65S0ZkF7METjO+jN2R3n6o3wbVdpJIY=
Date:   Mon, 10 May 2021 18:10:54 -0700
From:   akpm@linux-foundation.org
To:     djwong@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  + mm-filemap-fix-readahead-return-types.patch added to
 -mm tree
Message-ID: <20210511011054.id35OJwTk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix readahead return types
has been added to the -mm tree.  Its filename is
     mm-filemap-fix-readahead-return-types.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-fix-readahead-return-types.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-fix-readahead-return-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: fix readahead return types

A readahead request will not allocate more memory than can be represented
by a size_t, even on systems that have HIGHMEM available.  Change the
length functions from returning an loff_t to a size_t.

Link: https://lkml.kernel.org/r/20210510201201.1558972-1-willy@infradead.org
Fixes: 32c0a6bcaa1f57 ("btrfs: add and use readahead_batch_length")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap/buffered-io.c  |    4 ++--
 include/linux/pagemap.h |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/iomap/buffered-io.c~mm-filemap-fix-readahead-return-types
+++ a/fs/iomap/buffered-io.c
@@ -394,7 +394,7 @@ void iomap_readahead(struct readahead_co
 {
 	struct inode *inode = rac->mapping->host;
 	loff_t pos = readahead_pos(rac);
-	loff_t length = readahead_length(rac);
+	size_t length = readahead_length(rac);
 	struct iomap_readpage_ctx ctx = {
 		.rac	= rac,
 	};
@@ -402,7 +402,7 @@ void iomap_readahead(struct readahead_co
 	trace_iomap_readahead(inode, readahead_count(rac));
 
 	while (length > 0) {
-		loff_t ret = iomap_apply(inode, pos, length, 0, ops,
+		ssize_t ret = iomap_apply(inode, pos, length, 0, ops,
 				&ctx, iomap_readahead_actor);
 		if (ret <= 0) {
 			WARN_ON_ONCE(ret == 0);
--- a/include/linux/pagemap.h~mm-filemap-fix-readahead-return-types
+++ a/include/linux/pagemap.h
@@ -997,9 +997,9 @@ static inline loff_t readahead_pos(struc
  * readahead_length - The number of bytes in this readahead request.
  * @rac: The readahead request.
  */
-static inline loff_t readahead_length(struct readahead_control *rac)
+static inline size_t readahead_length(struct readahead_control *rac)
 {
-	return (loff_t)rac->_nr_pages * PAGE_SIZE;
+	return rac->_nr_pages * PAGE_SIZE;
 }
 
 /**
@@ -1024,7 +1024,7 @@ static inline unsigned int readahead_cou
  * readahead_batch_length - The number of bytes in the current batch.
  * @rac: The readahead request.
  */
-static inline loff_t readahead_batch_length(struct readahead_control *rac)
+static inline size_t readahead_batch_length(struct readahead_control *rac)
 {
 	return rac->_batch_count * PAGE_SIZE;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-struct-page-layout-on-32-bit-systems.patch
mm-filemap-fix-readahead-return-types.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch


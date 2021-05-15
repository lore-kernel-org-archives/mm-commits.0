Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB06EC43460
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5EB61457
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhEOA2p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 20:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA2n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 20:28:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 213F561453;
        Sat, 15 May 2021 00:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038451;
        bh=zz/zyZ2G1to+2pAbY9GQ3rS3cev4qTMZxmsJUXxMR6U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HEySTcKiHSjNrIHHwlIbCZSMzGO5YlQr7b5MiT4cbtflBJ3M5NvuqzcOI1MaCGS+R
         wHW9L/l9OZCmmFb7qKVdHPMVovNlRF8Fi+hmDMYc/LYEPJYgjvDXGdBggnmd0N0inW
         GAHGDGloFvdchL4LIpnbCwjmyAxXehO95v4+ThSw=
Date:   Fri, 14 May 2021 17:27:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, djwong@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 10/13] mm/filemap: fix readahead return types
Message-ID: <20210515002730.MMtwMHtp5%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

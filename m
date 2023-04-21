Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B47CC77B7E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDUVwt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbjDUVwo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404E81BF6
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18093618F5
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8C4C4339B;
        Fri, 21 Apr 2023 21:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113962;
        bh=r5G1wpAiK3iqGl7MNx8gksHLPQuCH19Hz6eli+qgG+I=;
        h=Date:To:From:Subject:From;
        b=Re5RRvECxYmY9GhxhSzaNu2UHJyqYmpcx4lM+d0QHxAO3bzKSzc9/HfzOHtsUBfj9
         lkmMW5rPiKmVS2jjkeE5f9+Mcg3TRUT0b8/Vpzt/hpbvqJlK95ANyhcypy7hQL4UQC
         vrGex6fo+lWpM92wH/ZexFwVtyjIYUMpME94bqa8=
Date:   Fri, 21 Apr 2023 14:52:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mcgrof@kernel.org, hare@suse.de,
        brauner@kernel.org, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch removed from -mm tree
Message-Id: <20230421215242.6A8C4C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/buffer: convert create_page_buffers to folio_create_buffers
has been removed from the -mm tree.  Its filename was
     fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: fs/buffer: convert create_page_buffers to folio_create_buffers
Date: Mon, 17 Apr 2023 14:36:18 +0200

fs/buffer do not support large folios as there are many assumptions on the
folio size to be the host page size.  This conversion is one step towards
removing that assumption.  Also this conversion will reduce calls to
compound_head() if folio_create_buffers() calls
folio_create_empty_buffers().

Link: https://lkml.kernel.org/r/20230417123618.22094-5-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/fs/buffer.c~fs-buffer-convert-create_page_buffers-to-folio_create_buffers
+++ a/fs/buffer.c
@@ -1723,14 +1723,17 @@ static inline int block_size_bits(unsign
 	return ilog2(blocksize);
 }
 
-static struct buffer_head *create_page_buffers(struct page *page, struct inode *inode, unsigned int b_state)
+static struct buffer_head *folio_create_buffers(struct folio *folio,
+						struct inode *inode,
+						unsigned int b_state)
 {
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!folio_test_locked(folio));
 
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
-				     b_state);
-	return page_buffers(page);
+	if (!folio_buffers(folio))
+		folio_create_empty_buffers(folio,
+					   1 << READ_ONCE(inode->i_blkbits),
+					   b_state);
+	return folio_buffers(folio);
 }
 
 /*
@@ -1774,8 +1777,8 @@ int __block_write_full_page(struct inode
 	int nr_underway = 0;
 	blk_opf_t write_flags = wbc_to_write_flags(wbc);
 
-	head = create_page_buffers(page, inode,
-					(1 << BH_Dirty)|(1 << BH_Uptodate));
+	head = folio_create_buffers(page_folio(page), inode,
+				    (1 << BH_Dirty) | (1 << BH_Uptodate));
 
 	/*
 	 * Be very careful.  We have no exclusion from block_dirty_folio
@@ -2038,7 +2041,7 @@ int __block_write_begin_int(struct folio
 	BUG_ON(to > PAGE_SIZE);
 	BUG_ON(from > to);
 
-	head = create_page_buffers(&folio->page, inode, 0);
+	head = folio_create_buffers(folio, inode, 0);
 	blocksize = head->b_size;
 	bbits = block_size_bits(blocksize);
 
@@ -2324,7 +2327,7 @@ int block_read_full_folio(struct folio *
 
 	VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
 
-	head = create_page_buffers(&folio->page, inode, 0);
+	head = folio_create_buffers(folio, inode, 0);
 	blocksize = head->b_size;
 	bbits = block_size_bits(blocksize);
 
_

Patches currently in -mm which might be from p.raghav@samsung.com are



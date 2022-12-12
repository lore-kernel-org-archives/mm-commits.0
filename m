Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01569C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiLLCRO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiLLCPP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:15:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEF3DFA1
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB99660EC6
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F32DC433D2;
        Mon, 12 Dec 2022 02:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811287;
        bh=6l1Wi8VIRbQQxjXSQBlIfhVUpb2p1sLYe8v3AJDzGtI=;
        h=Date:To:From:Subject:From;
        b=1aUwh8VonmPoMwa8refw2Tfj220tnME/Pr2lehUWIBbEgJiHgLd5Ss6JDkszXL4mf
         DZpgOpxFaZc3Z44LwrthqzSI4cTRMYpeZ8sKkTuqx9V+aYjESb8paX8lIAKVVVVc0g
         Cy+eo7pnmMj8g/hkuU3Z+op/lKdUZ/eFCp1MBcMw=
Date:   Sun, 11 Dec 2022 18:14:46 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] jfs-remove-writepage.patch removed from -mm tree
Message-Id: <20221212021447.4F32DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: jfs: remove ->writepage
has been removed from the -mm tree.  Its filename was
     jfs-remove-writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: jfs: remove ->writepage
Date: Fri, 2 Dec 2022 11:26:43 +0100

->writepage is a very inefficient method to write back data, and only
used through write_cache_pages or a a fallback when no ->migrate_folio
method is present.

Set ->migrate_folio to the generic buffer_head based helper, and remove
the ->writepage implementation.

Link: https://lkml.kernel.org/r/20221202102644.770505-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/inode.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/fs/jfs/inode.c~jfs-remove-writepage
+++ a/fs/jfs/inode.c
@@ -264,11 +264,6 @@ int jfs_get_block(struct inode *ip, sect
 	return rc;
 }
 
-static int jfs_writepage(struct page *page, struct writeback_control *wbc)
-{
-	return block_write_full_page(page, jfs_get_block, wbc);
-}
-
 static int jfs_writepages(struct address_space *mapping,
 			struct writeback_control *wbc)
 {
@@ -355,12 +350,12 @@ const struct address_space_operations jf
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= jfs_read_folio,
 	.readahead	= jfs_readahead,
-	.writepage	= jfs_writepage,
 	.writepages	= jfs_writepages,
 	.write_begin	= jfs_write_begin,
 	.write_end	= jfs_write_end,
 	.bmap		= jfs_bmap,
 	.direct_IO	= jfs_direct_IO,
+	.migrate_folio	= buffer_migrate_folio,
 };
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are



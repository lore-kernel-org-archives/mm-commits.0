Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BE0C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjASBTe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjASBR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:17:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE406921E
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A176461B08
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0A8C433EF;
        Thu, 19 Jan 2023 01:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090942;
        bh=r+fQZu7VBoIeO5o7qUgWj08GYXuuL9atty3aDNIy0zs=;
        h=Date:To:From:Subject:From;
        b=NzQfDq1g0DvIWRzboxqsiiRVNPScWNwcvFJDgLs4N/8K/VR8KvVj4f3tm+jCQyBGL
         7VitLt4f3tBmF4MHyJlSnU6wIZWowTazdYihdVPfZ8d8yLsqWxe+cFONy11smXp4oO
         WPNUlBHJg9ET077Xw0QsPgWYoc9iGS0LP3dW6Qys=
Date:   Wed, 18 Jan 2023 17:15:41 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.com, almaz.alexandrovich@paragon-software.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ntfs3-remove-writepage.patch removed from -mm tree
Message-Id: <20230119011542.0B0A8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs3: remove ->writepage
has been removed from the -mm tree.  Its filename was
     ntfs3-remove-writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: ntfs3: remove ->writepage
Date: Thu, 29 Dec 2022 06:10:28 -1000

->writepage is a very inefficient method to write back data, and only used
through write_cache_pages or a a fallback when no ->migrate_folio method
is present.

Set ->migrate_folio to the generic buffer_head based helper, and remove
the ->writepage implementation.

Link: https://lkml.kernel.org/r/20221229161031.391878-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/inode.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

--- a/fs/ntfs3/inode.c~ntfs3-remove-writepage
+++ a/fs/ntfs3/inode.c
@@ -832,26 +832,6 @@ out:
 	return err;
 }
 
-static int ntfs_writepage(struct page *page, struct writeback_control *wbc)
-{
-	struct address_space *mapping = page->mapping;
-	struct inode *inode = mapping->host;
-	struct ntfs_inode *ni = ntfs_i(inode);
-	int err;
-
-	if (is_resident(ni)) {
-		ni_lock(ni);
-		err = attr_data_write_resident(ni, page);
-		ni_unlock(ni);
-		if (err != E_NTFS_NONRESIDENT) {
-			unlock_page(page);
-			return err;
-		}
-	}
-
-	return block_write_full_page(page, ntfs_get_block, wbc);
-}
-
 static int ntfs_resident_writepage(struct page *page,
 		struct writeback_control *wbc, void *data)
 {
@@ -2083,13 +2063,13 @@ const struct inode_operations ntfs_link_
 const struct address_space_operations ntfs_aops = {
 	.read_folio	= ntfs_read_folio,
 	.readahead	= ntfs_readahead,
-	.writepage	= ntfs_writepage,
 	.writepages	= ntfs_writepages,
 	.write_begin	= ntfs_write_begin,
 	.write_end	= ntfs_write_end,
 	.direct_IO	= ntfs_direct_IO,
 	.bmap		= ntfs_bmap,
 	.dirty_folio	= block_dirty_folio,
+	.migrate_folio	= buffer_migrate_folio,
 	.invalidate_folio = block_invalidate_folio,
 };
 
_

Patches currently in -mm which might be from hch@lst.de are



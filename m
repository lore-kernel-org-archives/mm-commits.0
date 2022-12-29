Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C3DC3DA7D
	for <mm-commits@archiver.kernel.org>; Thu, 29 Dec 2022 19:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiL2TzQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiL2TzI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2022 14:55:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222B716596
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 11:55:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8F84B81A23
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 19:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8FCC433EF;
        Thu, 29 Dec 2022 19:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672343704;
        bh=i62W1TbJKfopCVxF1pxI+VaYEZ6by2WX5WKiCzIBZTU=;
        h=Date:To:From:Subject:From;
        b=uLO1+dYuD/FC4uoV68GdIpr6M+wRFHbfXdbgwSfT/AbACIWzEDPQ6y2gbdc4JWBb4
         uO0rbOFvuDzZyolRG88xEM57ezR+YBmXvUyORNRR1OHIKxbUzW2ovXIBOUvsj5Gj70
         ms3asIZ+DP7Ky6d0NfZ+ErMRdc0VoBaMkqg01iaM=
Date:   Thu, 29 Dec 2022 11:55:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.com, almaz.alexandrovich@paragon-software.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs3-remove-writepage.patch added to mm-unstable branch
Message-Id: <20221229195504.6B8FCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs3: remove ->writepage
has been added to the -mm mm-unstable branch.  Its filename is
     ntfs3-remove-writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs3-remove-writepage.patch

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


--- a/fs/ntfs3/inode.c~ntfs3-remove-writepage
+++ a/fs/ntfs3/inode.c
@@ -826,26 +826,6 @@ out:
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
@@ -1946,13 +1926,13 @@ const struct inode_operations ntfs_link_
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

fs-remove-an-outdated-comment-on-mpage_writepages.patch
ntfs3-stop-using-generic_writepages.patch
ntfs3-remove-writepage.patch
jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2.patch
ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch
mm-remove-generic_writepages.patch


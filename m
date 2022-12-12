Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91741C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiLLCRO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiLLCPP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:15:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18E7DFA9
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B2B5B80A1F
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37887C433F0;
        Mon, 12 Dec 2022 02:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811286;
        bh=ZLP8VfOfSc95CSE1pzI+A4sePgod9P0loYC6zfkW1Kg=;
        h=Date:To:From:Subject:From;
        b=M7/MYbq5YJyF58nBxKJ2a6Mo1/o+9sCsBOuqHGxEqfUGQdX7YkXCaWYEYDqH6MY9/
         c50C1tQpr4DCBByRehLYlMoDFKIi0bgApvwM/s5Xn3V3OY84uKIuSONnO1yfo48rIK
         CSLeDcsGa9x3d+WwUxzXzo+LX5djyGbWXE4Xxias=
Date:   Sun, 11 Dec 2022 18:14:45 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hpfs-remove-writepage.patch removed from -mm tree
Message-Id: <20221212021446.37887C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hpfs: remove ->writepage
has been removed from the -mm tree.  Its filename was
     hpfs-remove-writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: hpfs: remove ->writepage
Date: Fri, 2 Dec 2022 11:26:42 +0100

->writepage is a very inefficient method to write back data, and only
used through write_cache_pages or a a fallback when no ->migrate_folio
method is present.

Set ->migrate_folio to the generic buffer_head based helper, and remove
the ->writepage implementation.

Link: https://lkml.kernel.org/r/20221202102644.770505-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/file.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/fs/hpfs/file.c~hpfs-remove-writepage
+++ a/fs/hpfs/file.c
@@ -163,11 +163,6 @@ static int hpfs_read_folio(struct file *
 	return mpage_read_folio(folio, hpfs_get_block);
 }
 
-static int hpfs_writepage(struct page *page, struct writeback_control *wbc)
-{
-	return block_write_full_page(page, hpfs_get_block, wbc);
-}
-
 static void hpfs_readahead(struct readahead_control *rac)
 {
 	mpage_readahead(rac, hpfs_get_block);
@@ -248,12 +243,12 @@ const struct address_space_operations hp
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio = hpfs_read_folio,
-	.writepage = hpfs_writepage,
 	.readahead = hpfs_readahead,
 	.writepages = hpfs_writepages,
 	.write_begin = hpfs_write_begin,
 	.write_end = hpfs_write_end,
-	.bmap = _hpfs_bmap
+	.bmap = _hpfs_bmap,
+	.migrate_folio = buffer_migrate_folio,
 };
 
 const struct file_operations hpfs_file_ops =
_

Patches currently in -mm which might be from hch@lst.de are



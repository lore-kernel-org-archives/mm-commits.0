Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB892C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiLBUMn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiLBULu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:11:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528ECF4E9B
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:11:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9415B82279
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80443C433C1;
        Fri,  2 Dec 2022 20:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670011907;
        bh=MXiU3y80J4y2a2ueT7mZMNWwpVq58FUklmP0xQ56Tms=;
        h=Date:To:From:Subject:From;
        b=gmacOwkbn0mBk9cKxT+ZzjE6PblleIoWKuyQXy/YXSaPBaLxjYdAeetJieHbfBH3z
         vy9m0ICaw6LICp+DzJkAi5KSrdowxZmWpFIgYL5bm+OcXYKBc7vQTG5NGNO4Z/1AIH
         Ur10xSVmQ1EFsagthwNZmYX6xzg0bb0cowso11/A=
Date:   Fri, 02 Dec 2022 12:11:46 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hpfs-remove-writepage.patch added to mm-unstable branch
Message-Id: <20221202201147.80443C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hpfs: remove ->writepage
has been added to the -mm mm-unstable branch.  Its filename is
     hpfs-remove-writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hpfs-remove-writepage.patch

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

extfat-remove-writepage.patch
fat-remove-writepage.patch
hfs-remove-writepage.patch
hfsplus-remove-writepage.patch
hpfs-remove-writepage.patch
jfs-remove-writepage.patch
omfs-remove-writepage.patch


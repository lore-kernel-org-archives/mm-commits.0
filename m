Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0ABC4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiLLCQw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiLLCOw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3548DF84
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6519D60EC7
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6B5C433D2;
        Mon, 12 Dec 2022 02:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811281;
        bh=bjkNU8x8YP6IAyyERinbQ0M9ZzqlkPcEFkVjATqkdC8=;
        h=Date:To:From:Subject:From;
        b=1+As6hWPlMIUFJnxtC5qZUrnjLOFwHtRX3n+ylecYIncDL7AZBK7gsowOZszeUEQ8
         3OQh8yq+Jqb/OBZZwJ4JyZdoQdxGYTHWbZqd5Bae7rstVroMdYHBIfVXcibD+kEqOd
         HQI8/UzY9z/ViE2aETLtAIIZ0DjwzFEHJfi+XQJg=
Date:   Sun, 11 Dec 2022 18:14:41 -0800
To:     mm-commits@vger.kernel.org, sj1557.seo@samsung.com,
        shaggy@kernel.org, mikulas@artax.karlin.mff.cuni.cz,
        me@bobcopeland.com, linkinjeon@kernel.org, jack@suse.com,
        hirofumi@mail.parknet.co.jp, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] extfat-remove-writepage.patch removed from -mm tree
Message-Id: <20221212021441.BA6B5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: extfat: remove ->writepage
has been removed from the -mm tree.  Its filename was
     extfat-remove-writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: extfat: remove ->writepage
Date: Fri, 2 Dec 2022 11:26:38 +0100

Patch series "start removing writepage instances v2".

The VM doesn't need or want ->writepage for writeback and is fine with
just having ->writepages as long as ->migrate_folio is implemented.

This series removes all ->writepage instances that use
block_write_full_page directly and also have a plain mpage_writepages
based ->writepages.


This patch (of 7):

->writepage is a very inefficient method to write back data, and only used
through write_cache_pages or a a fallback when no ->migrate_folio method
is present.

Set ->migrate_folio to the generic buffer_head based helper, and remove
the ->writepage implementation.

Link: https://lkml.kernel.org/r/20221202102644.770505-1-hch@lst.de
Link: https://lkml.kernel.org/r/20221202102644.770505-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Jan Kara <jack@suse.com>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exfat/inode.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/fs/exfat/inode.c~extfat-remove-writepage
+++ a/fs/exfat/inode.c
@@ -345,11 +345,6 @@ static void exfat_readahead(struct reada
 	mpage_readahead(rac, exfat_get_block);
 }
 
-static int exfat_writepage(struct page *page, struct writeback_control *wbc)
-{
-	return block_write_full_page(page, exfat_get_block, wbc);
-}
-
 static int exfat_writepages(struct address_space *mapping,
 		struct writeback_control *wbc)
 {
@@ -473,12 +468,12 @@ static const struct address_space_operat
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= exfat_read_folio,
 	.readahead	= exfat_readahead,
-	.writepage	= exfat_writepage,
 	.writepages	= exfat_writepages,
 	.write_begin	= exfat_write_begin,
 	.write_end	= exfat_write_end,
 	.direct_IO	= exfat_direct_IO,
-	.bmap		= exfat_aop_bmap
+	.bmap		= exfat_aop_bmap,
+	.migrate_folio	= buffer_migrate_folio,
 };
 
 static inline unsigned long exfat_hash(loff_t i_pos)
_

Patches currently in -mm which might be from hch@lst.de are



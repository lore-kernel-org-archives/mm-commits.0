Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCE0C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjBCGwS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjBCGva (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141A88D631
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A369561CC8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06424C433EF;
        Fri,  3 Feb 2023 06:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407081;
        bh=5Q3iMygew6H4o/tH+/Uh8NXhWo0UQOq0HMBCv6wQ464=;
        h=Date:To:From:Subject:From;
        b=XPYA9UHhemPQiu7duxQ6okeYI5qihcVcnNjHS/s0PG/H5g1akeojSr4DMl8WnFM/z
         Y1ZV3a2Qbubd4dwgBH76H2Ooab9rmW7PZPfEaG9CgZ9guzkNzSRfn3ud4xMlgES85N
         aoU2JfE3dcdqQa9M9oiTdiFsaok50trcosNkM4Mk=
Date:   Thu, 02 Feb 2023 22:51:20 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, hch@lst.de,
        jack@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-gracefully-handle-get_block-not-mapping-bh-in-__mpage_writepage.patch removed from -mm tree
Message-Id: <20230203065121.06424C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: gracefully handle ->get_block not mapping bh in __mpage_writepage
has been removed from the -mm tree.  Its filename was
     fs-gracefully-handle-get_block-not-mapping-bh-in-__mpage_writepage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fs: gracefully handle ->get_block not mapping bh in __mpage_writepage
Date: Thu, 26 Jan 2023 09:51:55 +0100

When filesystem's ->get_block function does not map the buffer head when
called from __mpage_writepage(), __mpage_writepage() will happily go and
pass bogus bdev and block number to bio allocation routines which leads to
crashes sooner or later.

E.g.  UDF can do this because it doesn't want to allocate blocks from
->writepages callbacks.  It allocates blocks on write or page fault but
writeback can still spot dirty buffers without underlying blocks allocated
e.g.  if blocksize < pagesize, the tail page is dirtied (which means all
its buffers are dirtied), and truncate extends the file so that some
buffer starts to be within i_size.

Link: https://lkml.kernel.org/r/20230126085155.26395-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/mpage.c~fs-gracefully-handle-get_block-not-mapping-bh-in-__mpage_writepage
+++ a/fs/mpage.c
@@ -532,6 +532,8 @@ static int __mpage_writepage(struct page
 		map_bh.b_size = 1 << blkbits;
 		if (mpd->get_block(inode, block_in_file, &map_bh, 1))
 			goto confused;
+		if (!buffer_mapped(&map_bh))
+			goto confused;
 		if (buffer_new(&map_bh))
 			clean_bdev_bh_alias(&map_bh);
 		if (buffer_boundary(&map_bh)) {
_

Patches currently in -mm which might be from jack@suse.cz are



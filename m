Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBF5C05027
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 19:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjAZTzV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 14:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAZTzU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 14:55:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8838C6B9A2
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 11:55:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21C97617CE
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 19:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B27C4339B;
        Thu, 26 Jan 2023 19:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674762918;
        bh=Uojc6vnge90aTDVWmPeTln6zJO0EbsK5i1yfc5j/hXs=;
        h=Date:To:From:Subject:From;
        b=njeAErNrSIHg0I8wcDbwl519NSMgSRr/ze0y3AhYw16IW1/851JJYn8uMsu5Th81e
         qVRPu+o8mWIhJreW+3bYFIpm19dNCR9MdQgBwVC7SjCG0NFmkAip3SsG+S/cTWvDyS
         UUcK0FjpTsKLVC9kPV3AA3c+ofqqZ/V0IilG1xPg=
Date:   Thu, 26 Jan 2023 11:55:18 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, hch@lst.de,
        jack@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-gracefully-handle-get_block-not-mapping-bh-in-__mpage_writepage.patch added to mm-nonmm-unstable branch
Message-Id: <20230126195518.77B27C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: gracefully handle ->get_block not mapping bh in __mpage_writepage
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-gracefully-handle-get_block-not-mapping-bh-in-__mpage_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-gracefully-handle-get_block-not-mapping-bh-in-__mpage_writepage.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

 fs/mpage.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/mpage.c~fs-gracefully-handle-get_block-not-mapping-bh-in-__mpage_writepage
+++ a/fs/mpage.c
@@ -533,6 +533,8 @@ static int __mpage_writepage(struct page
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

fs-gracefully-handle-get_block-not-mapping-bh-in-__mpage_writepage.patch


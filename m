Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EA0C4321E
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbiLBUMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbiLBULl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:11:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE55F1CE1
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DEC3622CB
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A708EC433C1;
        Fri,  2 Dec 2022 20:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670011899;
        bh=+j+Utw7RmagrbZphIlQ+dsfgCuVJEEFFK9ogvgnyG2c=;
        h=Date:To:From:Subject:From;
        b=AZZBnHdAuFjeTNoUnjPKmPUEj+jI9eng1npcbWR+aWuF487ii/KP/3iIWhWSgw+ka
         XHgIw9vEj+S+1rq7LQcxo3uowniqjnAlegGMYs43BuoZaSLDZb83ldpupFf0dgdN2y
         W3dg6f1qL7jozyKz8LyhUKZ9ZFRiJz0wTVtJ5XkU=
Date:   Fri, 02 Dec 2022 12:11:38 -0800
To:     mm-commits@vger.kernel.org, sj1557.seo@samsung.com,
        shaggy@kernel.org, mikulas@artax.karlin.mff.cuni.cz,
        me@bobcopeland.com, linkinjeon@kernel.org, jack@suse.com,
        hirofumi@mail.parknet.co.jp, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + extfat-remove-writepage.patch added to mm-unstable branch
Message-Id: <20221202201139.A708EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: extfat: remove ->writepage
has been added to the -mm mm-unstable branch.  Its filename is
     extfat-remove-writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/extfat-remove-writepage.patch

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

extfat-remove-writepage.patch
fat-remove-writepage.patch
hfs-remove-writepage.patch
hfsplus-remove-writepage.patch
hpfs-remove-writepage.patch
jfs-remove-writepage.patch
omfs-remove-writepage.patch


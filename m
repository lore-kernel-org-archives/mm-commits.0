Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C90C47088
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbiLBUMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbiLBULn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:11:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A188AF1CD6
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:11:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F12C622CB
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986A5C433C1;
        Fri,  2 Dec 2022 20:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670011901;
        bh=V7zWc0o191uc5xNmyglvKEQquArxvHLTeOS6YGbyHAc=;
        h=Date:To:From:Subject:From;
        b=HIImfWV+gf2HtP1OVNxi4OA19JRFIpZTv4RwVVXBq2I2RbVUY1ufpd2YpwuRwfYuz
         UjrNe9lrf/7h4n3JsErtgPIFdlweCjnYp/tZ4eDL/uqfWi2IdLMy29BQqAjIsuACmG
         kZUdTPpVHk1nsekYXAZ7LxbadfOV5Uy+xrtLpOzQ=
Date:   Fri, 02 Dec 2022 12:11:40 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-remove-writepage.patch added to mm-unstable branch
Message-Id: <20221202201141.986A5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: remove ->writepage
has been added to the -mm mm-unstable branch.  Its filename is
     fat-remove-writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-remove-writepage.patch

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
Subject: fat: remove ->writepage
Date: Fri, 2 Dec 2022 11:26:39 +0100

->writepage is a very inefficient method to write back data, and only
used through write_cache_pages or a a fallback when no ->migrate_folio
method is present.

Set ->migrate_folio to the generic buffer_head based helper, and remove
the ->writepage implementation.

Link: https://lkml.kernel.org/r/20221202102644.770505-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/fs/fat/inode.c~fat-remove-writepage
+++ a/fs/fat/inode.c
@@ -194,11 +194,6 @@ static int fat_get_block(struct inode *i
 	return 0;
 }
 
-static int fat_writepage(struct page *page, struct writeback_control *wbc)
-{
-	return block_write_full_page(page, fat_get_block, wbc);
-}
-
 static int fat_writepages(struct address_space *mapping,
 			  struct writeback_control *wbc)
 {
@@ -346,12 +341,12 @@ static const struct address_space_operat
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= fat_read_folio,
 	.readahead	= fat_readahead,
-	.writepage	= fat_writepage,
 	.writepages	= fat_writepages,
 	.write_begin	= fat_write_begin,
 	.write_end	= fat_write_end,
 	.direct_IO	= fat_direct_IO,
-	.bmap		= _fat_bmap
+	.bmap		= _fat_bmap,
+	.migrate_folio	= buffer_migrate_folio,
 };
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are

extfat-remove-writepage.patch
fat-remove-writepage.patch
hfs-remove-writepage.patch
hfsplus-remove-writepage.patch
hpfs-remove-writepage.patch
jfs-remove-writepage.patch
omfs-remove-writepage.patch


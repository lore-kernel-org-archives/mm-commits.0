Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA363C47088
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiLBUMo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbiLBUL4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:11:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146D8F4EA4
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:11:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0FC2B82279
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F89C433D6;
        Fri,  2 Dec 2022 20:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670011909;
        bh=agzOFQy67m/eNiUOJ64jTaawM8vWclNFb1UvFj6itwU=;
        h=Date:To:From:Subject:From;
        b=CILlVQLZG5Um32X+XnEJTkXETVgdrA6FAOuUhSRmHBWv8yNTLfq16F5Z97Jult9tw
         m1UZsIOCL6v2Z+J1MAiDlrY9yVsl8uxVKou/vtvTRLoa7KsDb3LktLGKltMfaYkOBD
         j53Hj0OBgwrkfP/gSL5MMpSHZXXt+zmOnc0wH+9I=
Date:   Fri, 02 Dec 2022 12:11:48 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + jfs-remove-writepage.patch added to mm-unstable branch
Message-Id: <20221202201149.76F89C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: jfs: remove ->writepage
has been added to the -mm mm-unstable branch.  Its filename is
     jfs-remove-writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/jfs-remove-writepage.patch

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

extfat-remove-writepage.patch
fat-remove-writepage.patch
hfs-remove-writepage.patch
hfsplus-remove-writepage.patch
hpfs-remove-writepage.patch
jfs-remove-writepage.patch
omfs-remove-writepage.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E68C4708D
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbiLBUMN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbiLBULr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:11:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58234F1CF7
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:11:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BF9CB82279
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B17BC433C1;
        Fri,  2 Dec 2022 20:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670011903;
        bh=Yl6jHu0Cs4DZep41wOlA77I84nVEhA0YZ7X/B+jLlIo=;
        h=Date:To:From:Subject:From;
        b=TjBO0EYzI5hpES7bO0XGrSsZg/MT/vaRV5x77zCHev2Tl6BpeZQmYI4k7do2WuXFF
         3hoiNfoua4sZVrTn3iIRTHdVXMsssp+ilh2wgrntmv0bYLTOZVmyDBeNmcAtv2mlSf
         ANmWc27qcoEWVnPlNfIkACmN3oTLrje4yvmz6YR8=
Date:   Fri, 02 Dec 2022 12:11:42 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfs-remove-writepage.patch added to mm-unstable branch
Message-Id: <20221202201143.8B17BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: remove ->writepage
has been added to the -mm mm-unstable branch.  Its filename is
     hfs-remove-writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfs-remove-writepage.patch

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
Subject: hfs: remove ->writepage
Date: Fri, 2 Dec 2022 11:26:40 +0100

->writepage is a very inefficient method to write back data, and only
used through write_cache_pages or a a fallback when no ->migrate_folio
method is present.

Set ->migrate_folio to the generic buffer_head based helper, and stop
wiring up ->writepage for hfs_aops.

Link: https://lkml.kernel.org/r/20221202102644.770505-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hfs/inode.c~hfs-remove-writepage
+++ a/fs/hfs/inode.c
@@ -173,12 +173,12 @@ const struct address_space_operations hf
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= hfs_read_folio,
-	.writepage	= hfs_writepage,
 	.write_begin	= hfs_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= hfs_bmap,
 	.direct_IO	= hfs_direct_IO,
 	.writepages	= hfs_writepages,
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


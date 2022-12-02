Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F92C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbiLBUMz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiLBUL7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:11:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387DAF4EA9
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB82EB82279
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D843C433C1;
        Fri,  2 Dec 2022 20:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670011911;
        bh=+0xQRjFiTDZAsxrTef528UZOiHj2NKFE6MBOcxgg84A=;
        h=Date:To:From:Subject:From;
        b=qzAP6LjsyF1R5G4qvrUCF/TVouUq/P7D6WV6QOEHQBjb2tW6Hpj5bnvPFgtk1uXTe
         ZfhQFFLIDkh/wFkEl42H/vccuO29hRS8D7btXEH4b/5X+vgFYMkfVfZIoqcZOGve9i
         v6kXu7TQGqSGOT2LLX3T5ofQg6PntL62LI7XvgXo=
Date:   Fri, 02 Dec 2022 12:11:50 -0800
To:     mm-commits@vger.kernel.org, me@bobcopeland.com, hannes@cmpxchg.org,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + omfs-remove-writepage.patch added to mm-unstable branch
Message-Id: <20221202201151.8D843C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: omfs: remove ->writepage
has been added to the -mm mm-unstable branch.  Its filename is
     omfs-remove-writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/omfs-remove-writepage.patch

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
Subject: omfs: remove ->writepage
Date: Fri, 2 Dec 2022 11:26:44 +0100

->writepage is a very inefficient method to write back data, and only
used through write_cache_pages or a a fallback when no ->migrate_folio
method is present.

Set ->migrate_folio to the generic buffer_head based helper, and remove
the ->writepage implementation.

Link: https://lkml.kernel.org/r/20221202102644.770505-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/file.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/fs/omfs/file.c~omfs-remove-writepage
+++ a/fs/omfs/file.c
@@ -294,11 +294,6 @@ static void omfs_readahead(struct readah
 	mpage_readahead(rac, omfs_get_block);
 }
 
-static int omfs_writepage(struct page *page, struct writeback_control *wbc)
-{
-	return block_write_full_page(page, omfs_get_block, wbc);
-}
-
 static int
 omfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
@@ -375,10 +370,10 @@ const struct address_space_operations om
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio = omfs_read_folio,
 	.readahead = omfs_readahead,
-	.writepage = omfs_writepage,
 	.writepages = omfs_writepages,
 	.write_begin = omfs_write_begin,
 	.write_end = generic_write_end,
 	.bmap = omfs_bmap,
+	.migrate_folio = buffer_migrate_folio,
 };
 
_

Patches currently in -mm which might be from hch@lst.de are

extfat-remove-writepage.patch
fat-remove-writepage.patch
hfs-remove-writepage.patch
hfsplus-remove-writepage.patch
hpfs-remove-writepage.patch
jfs-remove-writepage.patch
omfs-remove-writepage.patch


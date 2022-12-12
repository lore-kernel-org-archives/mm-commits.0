Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E85AC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiLLCQz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiLLCOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFD9DF93
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B7FD60EC8
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35AFC433EF;
        Mon, 12 Dec 2022 02:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811282;
        bh=Jf4KAzYq+xZ03njSThQgigPK1b6EgsCk+niZU1NJjuA=;
        h=Date:To:From:Subject:From;
        b=KAdxH5K1Oxv3MTcS2DN9LHCd1T5HZwhaBxT7mBaLAlCaSj/FUWj/mQu0OIZRJ9J63
         gva8WQf8gF6X2qWMhXbT3JyAP/bQyzTbQ8vTfJ4QjP1M+b6LX8aiyXEmYqVHpmOzA+
         k8ray1cIpW9fR8DDgTyvD+212JcX1fNSuhZz0Qno=
Date:   Sun, 11 Dec 2022 18:14:42 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fat-remove-writepage.patch removed from -mm tree
Message-Id: <20221212021442.D35AFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat: remove ->writepage
has been removed from the -mm tree.  Its filename was
     fat-remove-writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



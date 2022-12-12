Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899F7C10F1E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiLLCRP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiLLCPy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:15:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F311BDFB4
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0D56B80B67
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691D2C433D2;
        Mon, 12 Dec 2022 02:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811288;
        bh=uaE8Tef3k0k8knMzVh26JCcYTkA5mVb4KTNXJIyAhwo=;
        h=Date:To:From:Subject:From;
        b=auHBfAiFEIANnoUeZJLnz+VudAN+v/i4mlTey0txI+7gjpn4G0ZTmdvXez6qMspVc
         fMuc3erivT77DoXFx6FjYcV5Lk/coJLVdiLpkGeEkqm2UxMih/gmC1mQOvJMzCd+kj
         RLB9RAAFR+/2KpI66ivV5y9QPR0B9Jow3nj6Q8Qo=
Date:   Sun, 11 Dec 2022 18:14:47 -0800
To:     mm-commits@vger.kernel.org, me@bobcopeland.com, hannes@cmpxchg.org,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] omfs-remove-writepage.patch removed from -mm tree
Message-Id: <20221212021448.691D2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: omfs: remove ->writepage
has been removed from the -mm tree.  Its filename was
     omfs-remove-writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



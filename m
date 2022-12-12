Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26A5C001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiLLCRM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiLLCO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B67BC97
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94F1460EC7
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9D0C433EF;
        Mon, 12 Dec 2022 02:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811284;
        bh=xUUl6VxWfmzEAcUwkDeMSJsrdgGwPd8MjQ+GI6yfN6U=;
        h=Date:To:From:Subject:From;
        b=0WKsVHV460WwP3V5DVuMS+aAQBZPsRlWgYvTE4W7W+mOfmKovysQpnG+07QFjWMG/
         YvzvQ42DxpnVAibjqCuE2WwUHqpLCe25CuPx5pDLRf/mkf568VOFhpXDydG+Id525I
         ASKPPGe7i5Pj16Om2ng2RbtvpCWsdGANfyCTQhAw=
Date:   Sun, 11 Dec 2022 18:14:43 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hfs-remove-writepage.patch removed from -mm tree
Message-Id: <20221212021443.EB9D0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hfs: remove ->writepage
has been removed from the -mm tree.  Its filename was
     hfs-remove-writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



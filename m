Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052F0C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiBGVAZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiBGVAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E8DC0401D1
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0C236152D
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210D1C004E1;
        Mon,  7 Feb 2022 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267622;
        bh=hGGbR7ApzDz81HgPxqPQGDxoEVoLdQ8EvoCK7WnMFzY=;
        h=Date:To:From:Subject:From;
        b=FSIEcl6nvT7PnOO28k3jaEV0zZtklBJnp6VRT+l7n/eeTLrVltU+qVGXldeoglYYp
         bOmlF5NDgtGetbFllJ+qdDmzliThyzYZq6Yqqf8b1RpNEDdW5L8jp3leCoxagobKvP
         WUSyyGrwtCanlwnsoiCS2OTli0Z7lnzcpCJNPEh0=
Date:   Mon, 07 Feb 2022 13:00:21 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, neilb@suse.de,
        jack@suse.cz, colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + remove-bdi_congested-and-wb_congested-and-related-functions-fix-2.patch added to -mm tree
Message-Id: <20220207210022.210D1C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ext2: remove unused pointer bdi
has been added to the -mm tree.  Its filename is
     remove-bdi_congested-and-wb_congested-and-related-functions-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/remove-bdi_congested-and-wb_congested-and-related-functions-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/remove-bdi_congested-and-wb_congested-and-related-functions-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: ext2: remove unused pointer bdi

The call to bdi_congested has been removed and so the bdi pointer is no
longer required.  Remove it.

Link: https://lkml.kernel.org/r/20220207134039.337197-1-colin.i.king@gmail.com
Fixes: 9bbab3a63d49 ("mm/fs: remove bdi_congested() and wb_congested() and related functions")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ialloc.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/ext2/ialloc.c~remove-bdi_congested-and-wb_congested-and-related-functions-fix-2
+++ a/fs/ext2/ialloc.c
@@ -170,9 +170,6 @@ static void ext2_preread_inode(struct in
 	unsigned long offset;
 	unsigned long block;
 	struct ext2_group_desc * gdp;
-	struct backing_dev_info *bdi;
-
-	bdi = inode_to_bdi(inode);
 
 	block_group = (inode->i_ino - 1) / EXT2_INODES_PER_GROUP(inode->i_sb);
 	gdp = ext2_get_group_desc(inode->i_sb, block_group, NULL);
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

remove-bdi_congested-and-wb_congested-and-related-functions-fix-2.patch


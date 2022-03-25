Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD55C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357509AbiCYBhU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357508AbiCYBf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F7536B7F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D334F60A50
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFDAC340EE;
        Fri, 25 Mar 2022 01:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172041;
        bh=JEwOwHEsl4KxyLaT6pZjpDRu7HCS6WO4lMxfcYDIL8Y=;
        h=Date:To:From:Subject:From;
        b=EY8b81mdOYe2s2xvOZlnkqu3ZeiRCArVan0s+C26opvskLCJAPwjyuTFMPwm36i7L
         2QBkYM3R2R+kmeyFrTEItFzUbBOiny3kcIoGEJxDEUffq0L7jpz6I96zaMPwISK7oa
         Gr7qjdbZ5qB1R0ZSIkzAIVTWRIJ8XTMNHc2Ar22c=
Date:   Thu, 24 Mar 2022 18:34:00 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, colin.king@intel.com,
        christian.brauner@ubuntu.com, qhjin.dev@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] minix-fix-bug-when-opening-a-file-with-o_direct.patch removed from -mm tree
Message-Id: <20220325013401.3AFDAC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minix: fix bug when opening a file with O_DIRECT
has been removed from the -mm tree.  Its filename was
     minix-fix-bug-when-opening-a-file-with-o_direct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qinghua Jin <qhjin.dev@gmail.com>
Subject: minix: fix bug when opening a file with O_DIRECT

Testcase:
1. create a minix file system and mount it
2. open a file on the file system with O_RDWR|O_CREAT|O_TRUNC|O_DIRECT
3. open fails with -EINVAL but leaves an empty file behind. All other
open() failures don't leave the failed open files behind.

It is hard to check the direct_IO op before creating the inode.  Just as
ext4 and btrfs do, this patch will resolve the issue by allowing to create
the file with O_DIRECT but returning error when writing the file.

Link: https://lkml.kernel.org/r/20220107133626.413379-1-qhjin.dev@gmail.com
Signed-off-by: Qinghua Jin <qhjin.dev@gmail.com>
Reported-by: Colin Ian King <colin.king@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/minix/inode.c~minix-fix-bug-when-opening-a-file-with-o_direct
+++ a/fs/minix/inode.c
@@ -447,7 +447,8 @@ static const struct address_space_operat
 	.writepage = minix_writepage,
 	.write_begin = minix_write_begin,
 	.write_end = generic_write_end,
-	.bmap = minix_bmap
+	.bmap = minix_bmap,
+	.direct_IO = noop_direct_IO
 };
 
 static const struct inode_operations minix_symlink_inode_operations = {
_

Patches currently in -mm which might be from qhjin.dev@gmail.com are



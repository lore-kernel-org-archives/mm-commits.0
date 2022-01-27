Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9597FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 02:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiA0Cki (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 21:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiA0Ckh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 21:40:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEBEC06161C
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 18:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D765B820F7
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 02:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF12CC340E7;
        Thu, 27 Jan 2022 02:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643251235;
        bh=nixskFMV0H38S6TbGekkpetulMax+1ONorSzyi/ON2o=;
        h=Date:From:To:Subject:From;
        b=ykeL/Xu0y80yU/9zh7WvatbB8TxYS3ddaRfPWltgmaaMdjes+vJHVKX7OGkl5FsrJ
         ejsWLW01aELLXjRQ5hjB2id091/F2XRuYogUEfvDH+T17qerRcdOUwckn2SgySErqk
         /JIlytORA2gMPikvp/TH14eIciAO+g9Qnll8fBms=
Date:   Wed, 26 Jan 2022 18:40:34 -0800
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, colin.king@intel.com, jack@suse.cz,
        mm-commits@vger.kernel.org, qhjin.dev@gmail.com
Subject:  + minix-fix-bug-when-opening-a-file-with-o_direct.patch
 added to -mm tree
Message-ID: <20220127024034.ZvVV9Ujtp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minix: fix bug when opening a file with O_DIRECT
has been added to the -mm tree.  Its filename is
     minix-fix-bug-when-opening-a-file-with-o_direct.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/minix-fix-bug-when-opening-a-file-with-o_direct.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/minix-fix-bug-when-opening-a-file-with-o_direct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

minix-fix-bug-when-opening-a-file-with-o_direct.patch


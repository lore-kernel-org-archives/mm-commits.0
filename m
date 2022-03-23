Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB4FC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbiCWXII (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345476AbiCWXIB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CEA90FC3
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B3DB82182
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6016BC340E9;
        Wed, 23 Mar 2022 23:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076784;
        bh=tN4p0J3FdsIJcTqpYHQYhslGR1cMY0pflMq2Wwx8foY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=qNt92sH3G/TRnit530UcJmVcVLAZiV8GcmV3zwdbByGBWRBsWw4EOXhhXhcefYJV6
         /6E+bIrrlLI8Nc2m7nWviubtJiJoB4R1v/tz6xo78g5HnumO9gUHM3KgxdkZifxbJE
         O4AIh/DENp3TRmzc92+KqKRpYWq4SVS+X5LEf0AU=
Date:   Wed, 23 Mar 2022 16:06:23 -0700
To:     jack@suse.cz, colin.king@intel.com, christian.brauner@ubuntu.com,
        qhjin.dev@gmail.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 22/41] minix: fix bug when opening a file with O_DIRECT
Message-Id: <20220323230624.6016BC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

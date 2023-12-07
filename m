Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6FCC10DC1
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441850AbjLGANa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441925AbjLGANU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE22CCA
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:25 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9266C433C7;
        Thu,  7 Dec 2023 00:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908005;
        bh=0yrhy8BBRE3JMMO1wlBRZxyMrmPZY2AFWc5ojCtUNe0=;
        h=Date:To:From:Subject:From;
        b=wHCt9R7u0ZXPG/fXTSRwVWHrlE6usCy8dj5zXvZI3VaSju5AwtAHugZHDJF8NjZ4F
         sGP9veRCQLfdQaw0c+InWFORudKuz3H/NU1Kgq6AX5MfRYS0rchgxTx00HxOVr/X40
         t0aTgmiPqpLS2+GrijOIcgdbw/6yQlHOw6WzF1Po=
Date:   Wed, 06 Dec 2023 16:13:25 -0800
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        lizhi.xu@windriver.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] squashfs-squashfs_read_data-need-to-check-if-the-length-is-0.patch removed from -mm tree
Message-Id: <20231207001325.A9266C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: squashfs_read_data need to check if the length is 0
has been removed from the -mm tree.  Its filename was
     squashfs-squashfs_read_data-need-to-check-if-the-length-is-0.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lizhi Xu <lizhi.xu@windriver.com>
Subject: squashfs: squashfs_read_data need to check if the length is 0
Date: Thu, 16 Nov 2023 11:13:52 +0800

When the length passed in is 0, the pagemap_scan_test_walk() caller should
bail.  This error causes at least a WARN_ON().

Link: https://lkml.kernel.org/r/20231116031352.40853-1-lizhi.xu@windriver.com
Reported-by: syzbot+32d3767580a1ea339a81@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000000526f2060a30a085@google.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-squashfs_read_data-need-to-check-if-the-length-is-0
+++ a/fs/squashfs/block.c
@@ -321,7 +321,7 @@ int squashfs_read_data(struct super_bloc
 		TRACE("Block @ 0x%llx, %scompressed size %d\n", index - 2,
 		      compressed ? "" : "un", length);
 	}
-	if (length < 0 || length > output->length ||
+	if (length <= 0 || length > output->length ||
 			(index + length) > msblk->bytes_used) {
 		res = -EIO;
 		goto out;
_

Patches currently in -mm which might be from lizhi.xu@windriver.com are



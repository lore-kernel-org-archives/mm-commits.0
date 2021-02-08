Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B575C433E6
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E23AE64EA6
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhBHVuc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 16:50:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236865AbhBHVt6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 16:49:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3486F64DE1;
        Mon,  8 Feb 2021 21:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612820958;
        bh=966UjBGd4Zki52c4u5i6M5QUGdW8B9cNs7mZTbbJWzE=;
        h=Date:From:To:Subject:From;
        b=wgIrcsws7+jIhRWu8AUZTu+fyivPcm6Mnpu6MaIBz7SqnbqerGAMm3a1B9IyUeAkQ
         d8V1WvaYWlQh0z3iGdOAY9+h70tHa0Z3N6x7u3ZkCbrhkZSfykiW052P45Lnx40+wi
         DQuqdF4fFpzlLntyxKl7YoJ1IXpSItzc+v1TOtc8=
Date:   Mon, 08 Feb 2021 13:49:17 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk
Subject:  +
 squashfs-add-more-sanity-checks-in-inode-lookup-v2.patch added to -mm tree
Message-ID: <20210208214917.NmYTheKRq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Squashfs: add more sanity checks in inode lookup
has been added to the -mm tree.  Its filename is
     squashfs-add-more-sanity-checks-in-inode-lookup-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/squashfs-add-more-sanity-checks-in-inode-lookup-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/squashfs-add-more-sanity-checks-in-inode-lookup-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: add more sanity checks in inode lookup

fix checkpatch issue

Link: https://lkml.kernel.org/r/527909353.754618.1612769948607@webmail.123-reg.co.uk
Reported-by: syzbot+04419e3ff19d2970ea28@syzkaller.appspotmail.com
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/export.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/export.c~squashfs-add-more-sanity-checks-in-inode-lookup-v2
+++ a/fs/squashfs/export.c
@@ -47,7 +47,7 @@ static long long squashfs_inode_lookup(s
 
 	TRACE("Entered squashfs_inode_lookup, inode_number = %d\n", ino_num);
 
-	if(ino_num == 0 || (ino_num - 1) >= msblk->inodes)
+	if (ino_num == 0 || (ino_num - 1) >= msblk->inodes)
 		return -EINVAL;
 
 	start = le64_to_cpu(msblk->inode_lookup_table[blk]);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-avoid-out-of-bounds-writes-in-decompressors.patch
squashfs-add-more-sanity-checks-in-id-lookup.patch
squashfs-add-more-sanity-checks-in-inode-lookup.patch
squashfs-add-more-sanity-checks-in-inode-lookup-v2.patch
squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch
squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2.patch


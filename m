Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA2EC433E6
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 23:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0D3A64DA5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 23:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhBIXI6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 18:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234557AbhBIWb6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 17:31:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB1F064E74;
        Tue,  9 Feb 2021 21:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906129;
        bh=SugMuWYFjtJ/nQcNV7RwsKNcyGP2L3FIX9QtkLH4sYY=;
        h=Date:From:To:Subject:From;
        b=qWFscEv1Q3ybO6UT0ZXNCGrrJEBLQNjcCiXn9GggKQgmErvH4ZFBJ5ph2RYuDxzUn
         Ez2ocgnLqkgnIm4QpgYnKYTU/1uhbQsXLO0XckypPAfbezQUbURO7LcUn/WuaFfcHn
         m+bn3F8adzp+wEYtT4DosJTLyWp3zmkYR5FkyuI0=
Date:   Tue, 09 Feb 2021 13:28:48 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk
Subject:  [folded-merged]
 squashfs-add-more-sanity-checks-in-inode-lookup-v2.patch removed from -mm
 tree
Message-ID: <20210209212848.FEWtGp42J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Squashfs: add more sanity checks in inode lookup
has been removed from the -mm tree.  Its filename was
     squashfs-add-more-sanity-checks-in-inode-lookup-v2.patch

This patch was dropped because it was folded into squashfs-add-more-sanity-checks-in-inode-lookup.patch

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
squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch
squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2.patch


Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09960C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B3F20B1F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266280;
	bh=mhMH2MNfhL+woMUzcJZxil/pqKH3XMqdQ09l8W6G0tA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dpTN7iV8m05VKgZv4Fr49+IHh5QWwGSDqEHIW5MsPU6On5TZwsXS50VmLUo2Km6Au
	 8CPrVHkT4+BVDmquGffYyz/wWLg/hI1gSW+KTGJfTZRHvw8N/p2Q/1stLCR6Szzell
	 eh0OIg+B8+ejYLpsHtooMrzLYccxInJtXs0RYzjw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHLVEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHLVEk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:40 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61993207F7;
        Wed, 12 Aug 2020 21:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266279;
        bh=mhMH2MNfhL+woMUzcJZxil/pqKH3XMqdQ09l8W6G0tA=;
        h=Date:From:To:Subject:From;
        b=SFmeyPFYbVMsLKowbhQfscwQdT5r2ATNYWs6GIKSzw1PReOw54AyEc2kWxcOsXyjD
         DYavHyd/8YhuLnCxooKZb5INO+UtCWpb5/yehw8uMofTk+FAwJI+s+3bIqmeoiPoO8
         JQtlG4P/Bxsa5yTvfOcrgGkrO346pLSLYHKEPj9I=
Date:   Wed, 12 Aug 2020 14:04:39 -0700
From:   akpm@linux-foundation.org
To:     anenbupt@gmail.com, ebiggers@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 fs-minix-reject-too-large-maximum-file-size.patch removed from -mm tree
Message-ID: <20200812210439.H8TEzkZx7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/minix: reject too-large maximum file size
has been removed from the -mm tree.  Its filename was
     fs-minix-reject-too-large-maximum-file-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fs/minix: reject too-large maximum file size

If the minix filesystem tries to map a very large logical block number to
its on-disk location, block_to_path() can return offsets that are too
large, causing out-of-bounds memory accesses when accessing indirect index
blocks.  This should be prevented by the check against the maximum file
size, but this doesn't work because the maximum file size is read directly
from the on-disk superblock and isn't validated itself.

Fix this by validating the maximum file size at mount time.

Link: http://lkml.kernel.org/r/20200628060846.682158-4-ebiggers@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+c7d9ec7a1a7272dd71b3@syzkaller.appspotmail.com
Reported-by: syzbot+3b7b03a0c28948054fb5@syzkaller.appspotmail.com
Reported-by: syzbot+6e056ee473568865f3e6@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/fs/minix/inode.c~fs-minix-reject-too-large-maximum-file-size
+++ a/fs/minix/inode.c
@@ -150,6 +150,23 @@ static int minix_remount (struct super_b
 	return 0;
 }
 
+static bool minix_check_superblock(struct minix_sb_info *sbi)
+{
+	if (sbi->s_imap_blocks == 0 || sbi->s_zmap_blocks == 0)
+		return false;
+
+	/*
+	 * s_max_size must not exceed the block mapping limitation.  This check
+	 * is only needed for V1 filesystems, since V2/V3 support an extra level
+	 * of indirect blocks which places the limit well above U32_MAX.
+	 */
+	if (sbi->s_version == MINIX_V1 &&
+	    sbi->s_max_size > (7 + 512 + 512*512) * BLOCK_SIZE)
+		return false;
+
+	return true;
+}
+
 static int minix_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct buffer_head *bh;
@@ -228,11 +245,12 @@ static int minix_fill_super(struct super
 	} else
 		goto out_no_fs;
 
+	if (!minix_check_superblock(sbi))
+		goto out_illegal_sb;
+
 	/*
 	 * Allocate the buffer map to keep the superblock small.
 	 */
-	if (sbi->s_imap_blocks == 0 || sbi->s_zmap_blocks == 0)
-		goto out_illegal_sb;
 	i = (sbi->s_imap_blocks + sbi->s_zmap_blocks) * sizeof(bh);
 	map = kzalloc(i, GFP_KERNEL);
 	if (!map)
_

Patches currently in -mm which might be from ebiggers@google.com are



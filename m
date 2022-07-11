Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2AEC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Jul 2022 20:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiGKUlb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jul 2022 16:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGKUlb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2022 16:41:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4778F6716C
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 13:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E67B1B81205
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 20:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65342C341C0;
        Mon, 11 Jul 2022 20:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657572087;
        bh=4V0nkB5qWSkmNjmmJ+mcXE7gaE5PswREflGrhHohfP8=;
        h=Date:To:From:Subject:From;
        b=r7dH7L6EKvYxqWMWZSyisGPaE7ooxleDV023M5zHAuSbXvq2xSwAn+XoAUh1qg9UZ
         r3BuOGMWvEbrS7uKRQM4Pc92zO2WDB8IDvxbJEzIKudNwuPd024flK+vwDXZOPZJFp
         2ewvfc/P53RyQy+2N9LEZOkTQtoXq4H25ntk/920=
Date:   Mon, 11 Jul 2022 13:41:26 -0700
To:     mm-commits@vger.kernel.org, zhangxiaoxu5@huawei.com,
        yi.zhang@huawei.com, yin31149@gmail.com, liuyongqiang13@huawei.com,
        anton@tuxera.com, chenxiaosong2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20220711204127.65342C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: ChenXiaoSong <chenxiaosong2@huawei.com>
Subject: ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3
Date: Sat, 9 Jul 2022 14:45:11 +0800

Cleanup quggested by Hawkins Jiawei

Link: https://lkml.kernel.org/r/20220709064511.3304299-1-chenxiaosong2@huawei.com
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/attrib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs/attrib.c~ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3
+++ a/fs/ntfs/attrib.c
@@ -595,7 +595,7 @@ static int ntfs_attr_find(const ATTR_TYP
 		u8 *mrec_end = (u8 *)ctx->mrec +
 		               le32_to_cpu(ctx->mrec->bytes_allocated);
 		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
-		               a->name_length;
+		               a->name_length * sizeof(ntfschar);
 		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
 		    name_end > mrec_end)
 			break;
_

Patches currently in -mm which might be from chenxiaosong2@huawei.com are

ntfs-fix-use-after-free-in-ntfs_ucsncmp.patch
ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3.patch


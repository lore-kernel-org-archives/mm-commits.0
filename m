Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5380C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 30 Sep 2022 22:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiI3WYE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Sep 2022 18:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbiI3WYA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2022 18:24:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E1F1A2A10
        for <mm-commits@vger.kernel.org>; Fri, 30 Sep 2022 15:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC611B82A72
        for <mm-commits@vger.kernel.org>; Fri, 30 Sep 2022 22:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52170C433C1;
        Fri, 30 Sep 2022 22:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664576636;
        bh=f64V+e2HstmYGB5trzzCTgYmQanUsBTDYHxeQHY9qio=;
        h=Date:To:From:Subject:From;
        b=BCxiQzuJbAGzrKh6szuCJ5CimpsCKnX2UMtgCamiSFHDJiUaZAAhk0+pckHX0Gchh
         Se3fIakQJyh0juNzXYCWY2EvCKrw9H8m+WN3OmgcPsKYdPlb2uz3gh08K55i94btZ7
         +qajZ/aB8uyxlCTLkfJQxOHpqIV4BtZWWt8f1/BI=
Date:   Fri, 30 Sep 2022 15:23:55 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+1631f09646bc214d2e76@syzkaller.appspotmail.com,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] fs-ntfs3-fix-negative-shift-size-in-true_sectors_per_clst.patch removed from -mm tree
Message-Id: <20220930222356.52170C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/ntfs3: fix negative shift size in true_sectors_per_clst()
has been removed from the -mm tree.  Its filename was
     fs-ntfs3-fix-negative-shift-size-in-true_sectors_per_clst.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: fs/ntfs3: fix negative shift size in true_sectors_per_clst()
Date: Wed, 21 Sep 2022 00:59:27 +0900

syzbot is reporting shift-out-of-bounds in true_sectors_per_clst() [1],
for commit a3b774342fa752a5 ("fs/ntfs3: validate BOOT
sectors_per_clusters") did not address that (0 -
boot->sectors_per_clusters) < 0 because "u8" was chosen for type of
boot->sectors_per_clusters because 0x80 needs to be positive in order to
support 64K clusters.  Use "s8" cast in order to make sure that (0 - (s8)
boot->sectors_per_clusters) > 0.

Link: https://syzkaller.appspot.com/bug?extid=1631f09646bc214d2e76 [1]
Link: https://lkml.kernel.org/r/4b37f037-3b10-b4e4-0644-73441c8fa0af@I-love.SAKURA.ne.jp
Fixes: a3b774342fa752a5 ("fs/ntfs3: validate BOOT sectors_per_clusters")
Reported-by: syzbot <syzbot+1631f09646bc214d2e76@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+1631f09646bc214d2e76@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/super.c~fs-ntfs3-fix-negative-shift-size-in-true_sectors_per_clst
+++ a/fs/ntfs3/super.c
@@ -672,7 +672,7 @@ static u32 true_sectors_per_clst(const s
 	if (boot->sectors_per_clusters <= 0x80)
 		return boot->sectors_per_clusters;
 	if (boot->sectors_per_clusters >= 0xf4) /* limit shift to 2MB max */
-		return 1U << (0 - boot->sectors_per_clusters);
+		return 1U << (0 - (s8) boot->sectors_per_clusters);
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are



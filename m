Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37382C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 20:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiIUUBW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 16:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiIUUBU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 16:01:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA8E86724
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 13:01:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51C5CB828F1
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 20:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8ABC433C1;
        Wed, 21 Sep 2022 20:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663790476;
        bh=PZJcrKqmFUJVWDZjf8d/Dxa7jMsI10clU5NKRtg3J9Y=;
        h=Date:To:From:Subject:From;
        b=zxADMaKKdYuErRPe9JrbVNKJGR4P9ooy6DxcIh0Q6D1xHoJ+mYwlPcyNa6zr/gp1h
         cwmP1TKXsep6gAO8UNEFuRvX22rEBlcCri+5pI+enALuTWcIoZUxQra+kU7esHcMRL
         xGh8ELZlytERp4Bjv1r8ZUCLPpa9yIUJS02JFFjs=
Date:   Wed, 21 Sep 2022 13:01:14 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+1631f09646bc214d2e76@syzkaller.appspotmail.com,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ntfs3-fix-negative-shift-size-in-true_sectors_per_clst.patch added to mm-nonmm-unstable branch
Message-Id: <20220921200116.8F8ABC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs3: fix negative shift size in true_sectors_per_clst()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-ntfs3-fix-negative-shift-size-in-true_sectors_per_clst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-ntfs3-fix-negative-shift-size-in-true_sectors_per_clst.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

fs-ntfs3-fix-negative-shift-size-in-true_sectors_per_clst.patch


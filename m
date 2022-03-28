Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B68C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 21:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiC1Vdt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 17:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiC1Vds (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 17:33:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4E5164D30
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 14:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3011461507
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 21:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B20AC340F0;
        Mon, 28 Mar 2022 21:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648502934;
        bh=9L2C6WM0JWxVoyzj4+12O1Sy2xp7jwUocF1PkrWAiCY=;
        h=Date:To:From:Subject:From;
        b=grTmHnU1fXu2eSuqYeXhYdDPwqllMuEXxLB8977E3v0jCJnjomUpKgEnZGcJ4LGnr
         dVkBXn0JM3A0wWC3gejJhZCP5m1mdLfkyR83jwxFDuaHtIZnFhZ6xdxvz1l3BxKC0Z
         fp/w3aiwmZj4K3z+9rPNTP5XI1MATDAiVsHO/yRY=
Date:   Mon, 28 Mar 2022 14:28:53 -0700
To:     mm-commits@vger.kernel.org, hulkci@huawei.com,
        hirofumi@mail.parknet.co.jp, fengyubo3@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fatfs-remove-redundant-judgment.patch added to -mm tree
Message-Id: <20220328212854.7B20AC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fatfs: remove redundant judgment
has been added to the -mm tree.  Its filename is
     fatfs-remove-redundant-judgment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fatfs-remove-redundant-judgment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fatfs-remove-redundant-judgment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yubo Feng <fengyubo3@huawei.com>
Subject: fatfs: remove redundant judgment

iput() has already judged the incoming parameter, so there is no need to
repeat outside.

Link: https://lkml.kernel.org/r/1648265418-76563-1-git-send-email-fengyubo3@huawei.com
Signed-off-by: Yubo Feng <fengyubo3@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/fat/inode.c~fatfs-remove-redundant-judgment
+++ a/fs/fat/inode.c
@@ -1889,10 +1889,8 @@ out_invalid:
 		fat_msg(sb, KERN_INFO, "Can't find a valid FAT filesystem");
 
 out_fail:
-	if (fsinfo_inode)
-		iput(fsinfo_inode);
-	if (fat_inode)
-		iput(fat_inode);
+	iput(fsinfo_inode);
+	iput(fat_inode);
 	unload_nls(sbi->nls_io);
 	unload_nls(sbi->nls_disk);
 	fat_reset_iocharset(&sbi->options);
_

Patches currently in -mm which might be from fengyubo3@huawei.com are

fatfs-remove-redundant-judgment.patch


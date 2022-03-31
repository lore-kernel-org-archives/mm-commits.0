Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512D6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 02:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiCaCrs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 22:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiCaCrr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 22:47:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA96B1AAF
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 19:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94D7760B4C
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE13C340EC;
        Thu, 31 Mar 2022 02:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648694759;
        bh=HKd4oIh9OOVPxZkSWRGbsTgh1n8arR1ABFkM1vQB+xc=;
        h=Date:To:From:Subject:From;
        b=Cn9ZHpArkd0tj1qBo9C1R1p0G8LGk7RhUH75k1SNOsc51r5YnzIU0HzlZ0TcW40bN
         BCf9hlwnvD5TzRCb3E5QsmXXWPVmcAcxj/UMJNnVN+ZUE9r/V4wY5BHUtckIRAHI3a
         BUtrbI1efH6VkO+1+D9hcYeWIJneeruKG3Db0m7w=
Date:   Wed, 30 Mar 2022 19:45:58 -0700
To:     mm-commits@vger.kernel.org, qianfanguijin@163.com,
        hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-add-ratelimit-to-fat_ent_bread.patch added to -mm tree
Message-Id: <20220331024558.DFE13C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add ratelimit to fat*_ent_bread()
has been added to the -mm tree.  Its filename is
     fat-add-ratelimit-to-fat_ent_bread.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fat-add-ratelimit-to-fat_ent_bread.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fat-add-ratelimit-to-fat_ent_bread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: add ratelimit to fat*_ent_bread()

fat*_ent_bread() can be the cause of too many report on I/O error path. 
So use fat_msg_ratelimit() instead.

Link: https://lkml.kernel.org/r/87bkxogfeq.fsf@mail.parknet.co.jp
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: qianfan <qianfanguijin@163.com>
Tested-by: qianfan <qianfanguijin@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/fat/fatent.c~fat-add-ratelimit-to-fat_ent_bread
+++ a/fs/fat/fatent.c
@@ -94,7 +94,8 @@ static int fat12_ent_bread(struct super_
 err_brelse:
 	brelse(bhs[0]);
 err:
-	fat_msg(sb, KERN_ERR, "FAT read failed (blocknr %llu)", (llu)blocknr);
+	fat_msg_ratelimit(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
+			  (llu)blocknr);
 	return -EIO;
 }
 
@@ -107,8 +108,8 @@ static int fat_ent_bread(struct super_bl
 	fatent->fat_inode = MSDOS_SB(sb)->fat_inode;
 	fatent->bhs[0] = sb_bread(sb, blocknr);
 	if (!fatent->bhs[0]) {
-		fat_msg(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
-		       (llu)blocknr);
+		fat_msg_ratelimit(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
+				  (llu)blocknr);
 		return -EIO;
 	}
 	fatent->nr_bhs = 1;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-add-ratelimit-to-fat_ent_bread.patch


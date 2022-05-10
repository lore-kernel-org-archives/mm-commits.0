Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31638C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiEJEYA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbiEJEXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22E11C9ADA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C0F61758
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2846C385A6;
        Tue, 10 May 2022 04:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156270;
        bh=f0+z5S2IGxGwaL2CcUjUM4oO2CED80OsuqoO2fSEi8g=;
        h=Date:To:From:Subject:From;
        b=jrsG58UPHqWQiX2wuCeEa4Kccl6mR41lfjO+YhZzCS+scOUlebqles/KA/7lyzGDq
         L2VhEmHLupIGP28p8ai3S0pq2MjqxIPl1fQQAsgyQZbP3TFDxguZ8wGaNdGBnhek5p
         hoT3u0fLkwNmMt3qwEcli9vHlJAy3CrINjnXWgA0=
Date:   Mon, 09 May 2022 21:17:50 -0700
To:     mm-commits@vger.kernel.org, qianfanguijin@163.com,
        hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-add-ratelimit-to-fat_ent_bread.patch removed from -mm tree
Message-Id: <20220510041750.D2846C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat: add ratelimit to fat*_ent_bread()
has been removed from the -mm tree.  Its filename was
     fat-add-ratelimit-to-fat_ent_bread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA361C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbiEJEYE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiEJEXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D541C9AD0
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30858B81AFD
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6320C385C5;
        Tue, 10 May 2022 04:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156268;
        bh=ySMWIEcFzD7fUkf8G7ml7iiXQ4mpoKCGzIBwKCrHqUw=;
        h=Date:To:From:Subject:From;
        b=cbT68DqkOJM8nmZvCIbL4KemVV0aA1Z+Wu24kGNzbz249gE+pzqCqP1awt7NCKVC9
         Kr8Ua+49MozKO3yLNARmZCdEJ7l9mVXTsERgXRIxMdreFGg9GE1fp0wGNKMsMqOEGS
         QIroqxUJCEYbxHCMfPNg6YEwi6+Dec/woReSv5Hk=
Date:   Mon, 09 May 2022 21:17:48 -0700
To:     mm-commits@vger.kernel.org, hulkci@huawei.com,
        hirofumi@mail.parknet.co.jp, fengyubo3@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fatfs-remove-redundant-judgment.patch removed from -mm tree
Message-Id: <20220510041748.D6320C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fatfs: remove redundant judgment
has been removed from the -mm tree.  Its filename was
     fatfs-remove-redundant-judgment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A24C2BBD4
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49FB223428
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgLPRLA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgLPRLA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:00 -0500
Date:   Wed, 16 Dec 2020 09:10:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138644;
        bh=V53wq5QSEy1/PokADIxQn1QQ3s2jcLJ6a9V6kW+V6zU=;
        h=From:To:Subject:From;
        b=AEK6BLmP8uV6xT0NMzJGqC1rAZI+HRcZnJbJh+eTRlpHpfiYGre8ws3iRVTnpd74j
         UZbNG7s6urZYUEulRH20bEGdzvrdkAG6RmJmG6DLyjKvkiUQOrrFHeGRyJu4Uj1aei
         mw4u8/sbiiU36bLsduNupEV2oyGLIL3K7irpHZfI=
From:   akpm@linux-foundation.org
To:     aivazian.tigran@gmail.com, dvyukov@google.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        viro@ZenIV.linux.org.uk
Subject:  [merged]
 bfs-dont-use-warning-string-when-its-just-info.patch removed from -mm tree
Message-ID: <20201216171044.OAfIMDCgI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bfs: don't use WARNING: string when it's just info.
has been removed from the -mm tree.  Its filename was
     bfs-dont-use-warning-string-when-its-just-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: bfs: don't use WARNING: string when it's just info.

Make the printk() [bfs "printf" macro] seem less severe by changing
"WARNING:" to "NOTE:".

<asm-generic/bug.h> warns us about using WARNING or BUG in a format string
other than in WARN() or BUG() family macros.  bfs/inode.c is doing just
that in a normal printk() call, so change the "WARNING" string to be
"NOTE".

Link: https://lkml.kernel.org/r/20201203212634.17278-1-rdunlap@infradead.org
Reported-by: syzbot+3fd34060f26e766536ff@syzkaller.appspotmail.com
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/bfs/inode.c~bfs-dont-use-warning-string-when-its-just-info
+++ a/fs/bfs/inode.c
@@ -350,7 +350,7 @@ static int bfs_fill_super(struct super_b
 
 	info->si_lasti = (le32_to_cpu(bfs_sb->s_start) - BFS_BSIZE) / sizeof(struct bfs_inode) + BFS_ROOT_INO - 1;
 	if (info->si_lasti == BFS_MAX_LASTI)
-		printf("WARNING: filesystem %s was created with 512 inodes, the real maximum is 511, mounting anyway\n", s->s_id);
+		printf("NOTE: filesystem %s was created with 512 inodes, the real maximum is 511, mounting anyway\n", s->s_id);
 	else if (info->si_lasti > BFS_MAX_LASTI) {
 		printf("Impossible last inode number %lu > %d on %s\n", info->si_lasti, BFS_MAX_LASTI, s->s_id);
 		goto out1;
_

Patches currently in -mm which might be from rdunlap@infradead.org are



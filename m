Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 317B6C3526C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E83C223339
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgLPEqA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgLPEqA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:00 -0500
Date:   Tue, 15 Dec 2020 20:45:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093945;
        bh=J13pXi+FK8M3uhcaqYPrCWOj1ZBxbjyz3nDIMDNuETQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=qSIMSAbi/sHZF+zPL8Vp+2NzCAYsyiirdEfV/KipCmdK4d/Nkj/5QXlYwm1FPBVVF
         +VdzuEuGItvt1uVydzigwNd/OfXopSviZl3qbCcLX5i+0sPUDijXmM0qr8k+t94T96
         jMGd5H6/QFcGbdEz6O4SwdjkcBdTo4xTBeELcMJY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aivazian.tigran@gmail.com, akpm@linux-foundation.org,
        dvyukov@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        viro@ZenIV.linux.org.uk
Subject:  [patch 63/95] bfs: don't use WARNING: string when it's
 just info.
Message-ID: <20201216044544.kpB6oGQaN%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

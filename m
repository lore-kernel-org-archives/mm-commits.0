From: akpm@linux-foundation.org
Subject: [merged] minixfs-fix-block-limit-check.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:56 -0700
Message-ID: <20120731185256.E907D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63080 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2GaSw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:58 -0400
Received: by wgbdt11 with SMTP id dt11so291205wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phcoder@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: minixfs: fix block limit check
has been removed from the -mm tree.  Its filename was
     minixfs-fix-block-limit-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Serbinenko  <phcoder@gmail.com>
Subject: minixfs: fix block limit check

On minix2 and minix3 usually max_size is 7fffffff and the check in
question prohibits creation of last block spanning right before 7fffffff,
due to downward rounding during the division.  Fix it by using
multiplication instead.

[akpm@linux-foundation.org: fix up code layout, use local `sb']
Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/itree_v2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/minix/itree_v2.c~minixfs-fix-block-limit-check fs/minix/itree_v2.c
--- a/fs/minix/itree_v2.c~minixfs-fix-block-limit-check
+++ a/fs/minix/itree_v2.c
@@ -32,7 +32,8 @@ static int block_to_path(struct inode * 
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
 			block, bdevname(sb->s_bdev, b));
-	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/sb->s_blocksize)) {
+	} else if ((u64)block * (u64)sb->s_blocksize >=
+			minix_sb(sb)->s_max_size) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %s\n",
_

Patches currently in -mm which might be from phcoder@gmail.com are

origin.patch


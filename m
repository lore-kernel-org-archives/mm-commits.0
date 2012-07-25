From: akpm@linux-foundation.org
Subject: + minixfs-fix-block-limit-check.patch added to -mm tree
Date: Wed, 25 Jul 2012 14:14:17 -0700
Message-ID: <20120725211418.74EFF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59623 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2GYVOU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 17:14:20 -0400
Received: by eekd4 with SMTP id d4so52768eek.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 14:14:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phcoder@gmail.com


The patch titled
     Subject: minixfs: fix block limit check
has been added to the -mm tree.  Its filename is
     minixfs-fix-block-limit-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Serbinenko <phcoder@gmail.com>
Subject: minixfs: fix block limit check

On minix2 and minix3 usually max_size is 7fffffff and the check in
question prohibits creation of last block spanning right before 7fffffff,
due to downward rounding during the division.  Fix it by using
multiplication instead.

Signed-off-by: Vladimir Serbinenko  <phcoder@gmail.com>
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
+    } else if ((u64) block * (u64) sb->s_blocksize
+           >= minix_sb(inode->i_sb)->s_max_size) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %s\n",
_
Subject: Subject: minixfs: fix block limit check

Patches currently in -mm which might be from phcoder@gmail.com are

minixfs-fix-block-limit-check.patch
minixfs-fix-block-limit-check-fix.patch


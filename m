From: akpm@linux-foundation.org
Subject: [merged]
 fs-befs-linuxvfsc-befs_iget-remove-unneeded-raw_inode-initialization-to-null.patch removed from -mm tree
Date: Fri, 27 May 2016 11:42:30 -0700
Message-ID: <57489516.4+Hn0HlCKTysggxl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbcE0Smb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c:befs_iget(): remove unneeded raw_inode initialization to NULL
has been removed from the -mm tree.  Its filename was
     fs-befs-linuxvfsc-befs_iget-remove-unneeded-raw_inode-initialization-to-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/linuxvfs.c:befs_iget(): remove unneeded raw_inode initialization to NULL

raw_inode is reinitialized to bh->b_data so no need to init it
with NULL in the beginning of befs_iget()

Link: http://lkml.kernel.org/r/0a66baaaacb6b7e5fcea5b31b57b649261152281.1462842887.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-befs_iget-remove-unneeded-raw_inode-initialization-to-null fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-befs_iget-remove-unneeded-raw_inode-initialization-to-null
+++ a/fs/befs/linuxvfs.c
@@ -295,7 +295,7 @@ static void init_once(void *foo)
 static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct buffer_head *bh;
-	befs_inode *raw_inode = NULL;
+	befs_inode *raw_inode;
 	struct befs_sb_info *befs_sb = BEFS_SB(sb);
 	struct befs_inode_info *befs_ino = NULL;
 	struct inode *inode;
_

Patches currently in -mm which might be from salah.triki@acm.org are



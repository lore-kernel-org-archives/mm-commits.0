From: akpm@linux-foundation.org
Subject: [patch 09/84] fs/befs/linuxvfs.c:befs_iget(): remove unneeded
 raw_inode initialization to NULL
Date: Mon, 23 May 2016 16:22:46 -0700
Message-ID: <574390c6.H69bQ91gR4q8E6NX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbcEWXWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:22:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, salah.triki@acm.org

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

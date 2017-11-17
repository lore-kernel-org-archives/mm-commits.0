From: akpm@linux-foundation.org
Subject: [patch 60/94] nilfs2: use octal for unreadable permission
 macro
Date: Fri, 17 Nov 2017 15:29:46 -0800
Message-ID: <20171117232946.5haUlQ2Yx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965833AbdKQX3s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:29:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: use octal for unreadable permission macro

Replace S_IRWXUGO with 0777 because symbolic permissions are considered
harmful:

 https://lwn.net/Articles/696229/

Link: http://lkml.kernel.org/r/1509367935-3086-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/namei.c~nilfs2-use-octal-for-unreadable-permission-macro fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-use-octal-for-unreadable-permission-macro
+++ a/fs/nilfs2/namei.c
@@ -150,7 +150,7 @@ static int nilfs_symlink(struct inode *d
 	if (err)
 		return err;
 
-	inode = nilfs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	inode = nilfs_new_inode(dir, S_IFLNK | 0777);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out;
_

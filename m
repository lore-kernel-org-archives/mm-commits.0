From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-use-octal-for-unreadable-permission-macro.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:25:35 -0800
Message-ID: <20171120212535.giYpMg2N1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752739AbdKTVZh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:25:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use octal for unreadable permission macro
has been removed from the -mm tree.  Its filename was
     nilfs2-use-octal-for-unreadable-permission-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are



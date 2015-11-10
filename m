From: akpm@linux-foundation.org
Subject: [merged] fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:32 -0800
Message-ID: <5642549c.YJF7NfMMIxVXsjdj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbKJUdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hpfs/namei.c: remove unnecessary new_valid_dev() check
has been removed from the -mm tree.  Its filename was
     fs-hpfs-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/hpfs/namei.c: remove unnecessary new_valid_dev() check

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/namei.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/hpfs/namei.c~fs-hpfs-remove-unnecessary-new_valid_dev-check fs/hpfs/namei.c
--- a/fs/hpfs/namei.c~fs-hpfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/hpfs/namei.c
@@ -227,8 +227,6 @@ static int hpfs_mknod(struct inode *dir,
 	int err;
 	if ((err = hpfs_chk_name(name, &len))) return err==-ENOENT ? -EINVAL : err;
 	if (hpfs_sb(dir->i_sb)->sb_eas < 2) return -EPERM;
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
 	hpfs_lock(dir->i_sb);
 	err = -ENOSPC;
 	fnode = hpfs_alloc_fnode(dir->i_sb, hpfs_i(dir)->i_dno, &fno, &bh);
_

Patches currently in -mm which might be from bywxiaobai@163.com are



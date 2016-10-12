From: akpm@linux-foundation.org
Subject: [merged] autofs-remove-ino-free-in-autofs4_dir_symlink.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:45 -0700
Message-ID: <57fe8dc1.FbJCpcsWe17CSWKS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755972AbcJLTYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, kusumi.tomohiro@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove ino free in autofs4_dir_symlink()
has been removed from the -mm tree.  Its filename was
     autofs-remove-ino-free-in-autofs4_dir_symlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: remove ino free in autofs4_dir_symlink()

The inode allocation failure case in autofs4_dir_symlink() frees the
autofs dentry info of the dentry without setting ->d_fsdata to NULL.

That could lead to a double free so just get rid of the free and leave it
to ->d_release().

Link: http://lkml.kernel.org/r/20160812024759.12352.10653.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/autofs4/root.c~autofs-remove-ino-free-in-autofs4_dir_symlink fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-remove-ino-free-in-autofs4_dir_symlink
+++ a/fs/autofs4/root.c
@@ -577,8 +577,6 @@ static int autofs4_dir_symlink(struct in
 	inode = autofs4_get_inode(dir->i_sb, S_IFLNK | 0555);
 	if (!inode) {
 		kfree(cp);
-		if (!dentry->d_fsdata)
-			kfree(ino);
 		return -ENOMEM;
 	}
 	inode->i_private = cp;
_

Patches currently in -mm which might be from raven@themaw.net are



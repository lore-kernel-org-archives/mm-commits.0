From: akpm@linux-foundation.org
Subject: [patch 034/102] autofs: remove ino free in autofs4_dir_symlink()
Date: Tue, 11 Oct 2016 13:52:39 -0700
Message-ID: <57fd5117.V38uZgl0tTdI1wLv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37955 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcJKUxG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, raven@themaw.net, kusumi.tomohiro@gmail.com

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

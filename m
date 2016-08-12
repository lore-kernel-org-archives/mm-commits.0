From: akpm@linux-foundation.org
Subject: + autofs-remove-ino-free-in-autofs4_dir_symlink.patch added to
 -mm tree
Date: Thu, 11 Aug 2016 20:07:10 -0700
Message-ID: <57ad3d5e.AmtB4Eksp0qAKhrk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbcHLDHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 23:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, kusumi.tomohiro@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove ino free in autofs4_dir_symlink()
has been added to the -mm tree.  Its filename is
     autofs-remove-ino-free-in-autofs4_dir_symlink.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-remove-ino-free-in-autofs4_dir_symlink.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-remove-ino-free-in-autofs4_dir_symlink.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

autofs-fix-autofs4_fill_super-error-exit-handling.patch
autofs-remove-ino-free-in-autofs4_dir_symlink.patch
autofs-fix-dev-ioctl-number-range-check.patch
autofs-add-autofs_dev_ioctl_version-for-autofs_dev_ioctl_version_cmd.patch
autofs4-move-linux-auto_dev-ioctlh-to-uapi-linux.patch


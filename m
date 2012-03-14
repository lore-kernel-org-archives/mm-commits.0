From: akpm@linux-foundation.org
Subject: [merged] vfs-correctly-set-the-dir-i_mutex-lockdep-class.patch removed from -mm tree
Date: Wed, 14 Mar 2012 14:24:46 -0700
Message-ID: <20120314212446.6A2D5A076E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:65523 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030915Ab2CNVYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 17:24:48 -0400
Received: by faaa19 with SMTP id a19so98071faa.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 14:24:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tyhicks@canonical.com, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: correctly set the dir i_mutex lockdep class
has been removed from the -mm tree.  Its filename was
     vfs-correctly-set-the-dir-i_mutex-lockdep-class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tyler Hicks <tyhicks@canonical.com>
Subject: vfs: correctly set the dir i_mutex lockdep class

9a7aa12f39 ("vfs: Set special lockdep map for dirs only if not set by fs")
introduced additional logic around setting the i_mutex lockdep class for
directory inodes.  The idea was that some filesystems may want their own
special lockdep class for different directory inodes and calling
unlock_new_inode() should not clobber one of those special classes.

I believe that the added conditional, around the *negated* return value of
lockdep_match_class(), caused directory inodes to be placed in the wrong
lockdep class.

inode_init_always() sets the i_mutex lockdep class with i_mutex_key for
all inodes.  If the filesystem did not change the class during inode
initialization, then the conditional mentioned above was false and the
directory inode was incorrectly left in the non-directory lockdep class. 
If the filesystem did set a special lockdep class, then the conditional
mentioned above was true and that class was clobbered with
i_mutex_dir_key.

This patch removes the negation from the conditional so that the i_mutex
lockdep class is properly set for directory inodes.  Special classes are
preserved and directory inodes with unmodified classes are set with
i_mutex_dir_key.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/inode.c~vfs-correctly-set-the-dir-i_mutex-lockdep-class fs/inode.c
--- a/fs/inode.c~vfs-correctly-set-the-dir-i_mutex-lockdep-class
+++ a/fs/inode.c
@@ -938,8 +938,7 @@ void lockdep_annotate_inode_mutex_key(st
 		struct file_system_type *type = inode->i_sb->s_type;
 
 		/* Set new key only if filesystem hasn't already changed it */
-		if (!lockdep_match_class(&inode->i_mutex,
-		    &type->i_mutex_key)) {
+		if (lockdep_match_class(&inode->i_mutex, &type->i_mutex_key)) {
 			/*
 			 * ensure nobody is actually holding i_mutex
 			 */
_

Patches currently in -mm which might be from tyhicks@canonical.com are

origin.patch
linux-next.patch


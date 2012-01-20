From: akpm@linux-foundation.org
Subject: + vfs-correctly-set-the-dir-i_mutex-lockdep-class.patch added to -mm tree
Date: Fri, 20 Jan 2012 14:37:30 -0800
Message-ID: <20120120223730.AD3F61E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60142 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2ATWhb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 17:37:31 -0500
Received: by ghbg20 with SMTP id g20so86706ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 14:37:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tyhicks@canonical.com, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: vfs: correctly set the dir i_mutex lockdep class
has been added to the -mm tree.  Its filename is
     vfs-correctly-set-the-dir-i_mutex-lockdep-class.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: vfs: correctly set the dir i_mutex lockdep class

Patches currently in -mm which might be from tyhicks@canonical.com are

linux-next.patch
vfs-correctly-set-the-dir-i_mutex-lockdep-class.patch


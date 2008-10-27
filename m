From: akpm@linux-foundation.org
Subject: + autofs4-correct-offset-mount-expire-check.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:33:03 -0700
Message-ID: <200810272033.m9RKX3uC017390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbYJ0UdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:33:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: correct offset mount expire check
has been added to the -mm tree.  Its filename is
     autofs4-correct-offset-mount-expire-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: correct offset mount expire check
From: Ian Kent <raven@themaw.net>

When checking a directory tree in autofs_tree_busy() we can incorrectly
decide that the tree isn't busy.  This happens for the case of an active
offset mount as autofs4_follow_mount() follows past the active offset
mount, which has an open file handle used for expires, causing the file
handle not to count toward the busyness check.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN fs/autofs4/expire.c~autofs4-correct-offset-mount-expire-check fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-correct-offset-mount-expire-check
+++ a/fs/autofs4/expire.c
@@ -56,12 +56,23 @@ static int autofs4_mount_busy(struct vfs
 	mntget(mnt);
 	dget(dentry);
 
-	if (!autofs4_follow_mount(&mnt, &dentry))
+	if (!follow_down(&mnt, &dentry))
 		goto done;
 
-	/* This is an autofs submount, we can't expire it */
-	if (is_autofs4_dentry(dentry))
-		goto done;
+	if (is_autofs4_dentry(dentry)) {
+		struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+
+		/* This is an autofs submount, we can't expire it */
+		if (sbi->type == AUTOFS_TYPE_INDIRECT)
+			goto done;
+
+		/*
+		 * Otherwise it's an offset mount and we need to check
+		 * if we can umount its mount, if there is one.
+		 */
+		if (!d_mountpoint(dentry))
+			goto done;
+	}
 
 	/* Update the expiry counter if fs is busy */
 	if (!may_umount_tree(mnt)) {
_

Patches currently in -mm which might be from raven@themaw.net are

linux-next.patch
autofs4-correct-offset-mount-expire-check.patch
autofs4-remove-string-terminator-check.patch
autofs4-collect-version-check-return.patch


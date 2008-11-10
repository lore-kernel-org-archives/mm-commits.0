From: akpm@linux-foundation.org
Subject: - autofs4-correct-offset-mount-expire-check.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:05 -0800
Message-ID: <200811102032.mAAKW5h3023741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbYKJUi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: correct offset mount expire check
has been removed from the -mm tree.  Its filename was
     autofs4-correct-offset-mount-expire-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
autofs4-improve-parameter-usage.patch
autofs4-fix-var-shadowed-by-local-delaration.patch
autofs4-make-autofs-type-usage-explicit.patch
autofs4-fix-string-validation-check-order.patch


From: akpm@linux-foundation.org
Subject: [merged] autofs4-fix-lookup-deadlock.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:39 -0700
Message-ID: <200904011841.n31IfdaG009437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933572AbZDASnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix lookup deadlock
has been removed from the -mm tree.  Its filename was
     autofs4-fix-lookup-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix lookup deadlock
From: Ian Kent <raven@themaw.net>

A deadlock can occur when user space uses a signal (autofs version 4 uses
SIGCHLD for this) to effect expire completion.

The order of events is:

Expire process completes, but before being able to send SIGCHLD to it's parent
...

Another process walks onto a different mount point and drops the directory
inode semaphore prior to sending the request to the daemon as it must ...

A third process does an lstat on on the expired mount point causing it to wait
on expire completion (unfortunately) holding the directory semaphore.

The mount request then arrives at the daemon which does an lstat and,
deadlock.

For some time I was concerned about releasing the directory semaphore around
the expire wait in autofs4_lookup as well as for the mount call back.  I
finally realized that the last round of changes in this function made the
expiring dentry and the lookup dentry separate and distinct so the check and
possible wait can be done anywhere prior to the mount call back.  This patch
moves the check to just before the mount call back and inside the directory
inode mutex release.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-fix-lookup-deadlock fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-lookup-deadlock
+++ a/fs/autofs4/root.c
@@ -485,22 +485,6 @@ static struct dentry *autofs4_lookup(str
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
-	expiring = autofs4_lookup_expiring(sbi, dentry->d_parent, &dentry->d_name);
-	if (expiring) {
-		/*
-		 * If we are racing with expire the request might not
-		 * be quite complete but the directory has been removed
-		 * so it must have been successful, so just wait for it.
-		 */
-		ino = autofs4_dentry_ino(expiring);
-		autofs4_expire_wait(expiring);
-		spin_lock(&sbi->lookup_lock);
-		if (!list_empty(&ino->expiring))
-			list_del_init(&ino->expiring);
-		spin_unlock(&sbi->lookup_lock);
-		dput(expiring);
-	}
-
 	unhashed = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
 	if (unhashed)
 		dentry = unhashed;
@@ -538,14 +522,31 @@ static struct dentry *autofs4_lookup(str
 	}
 
 	if (!oz_mode) {
+		mutex_unlock(&dir->i_mutex);
+		expiring = autofs4_lookup_expiring(sbi,
+						   dentry->d_parent,
+						   &dentry->d_name);
+		if (expiring) {
+			/*
+			 * If we are racing with expire the request might not
+			 * be quite complete but the directory has been removed
+			 * so it must have been successful, so just wait for it.
+			 */
+			ino = autofs4_dentry_ino(expiring);
+			autofs4_expire_wait(expiring);
+			spin_lock(&sbi->lookup_lock);
+			if (!list_empty(&ino->expiring))
+				list_del_init(&ino->expiring);
+			spin_unlock(&sbi->lookup_lock);
+			dput(expiring);
+		}
+
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
 		spin_unlock(&dentry->d_lock);
-		if (dentry->d_op && dentry->d_op->d_revalidate) {
-			mutex_unlock(&dir->i_mutex);
+		if (dentry->d_op && dentry->d_op->d_revalidate)
 			(dentry->d_op->d_revalidate)(dentry, nd);
-			mutex_lock(&dir->i_mutex);
-		}
+		mutex_lock(&dir->i_mutex);
 	}
 
 	/*
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch
writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks.patch
writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks-try-2.patch


From: akpm@linux-foundation.org
Subject: - autofs4-deadlock-during-create.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:51 -0700
Message-ID: <200708242056.l7OKup6b014103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762291AbXHXVIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: deadlock during create
has been removed from the -mm tree.  Its filename was
     autofs4-deadlock-during-create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: autofs4: deadlock during create
From: Ian Kent <raven@themaw.net>

Due to inconsistent locking in the VFS between calls to lookup and
revalidate deadlock can occur in the automounter.

The inconsistency is that the directory inode mutex is held for both lookup
and revalidate calls when called via lookup_hash whereas it is held only
for lookup during a path walk.  Consequently, if the mutex is held during a
call to revalidate autofs4 can't release the mutex to callback the daemon
as it can't know whether it owns the mutex.

This situation happens when a process tries to create a directory within an
automount and a second process also tries to create the same directory
between the lookup and the mkdir.  Since the first process has dropped the
mutex for the daemon callback, the second process takes it during
revalidate leading to deadlock between the autofs daemon and the second
process when the daemon tries to create the mount point directory.

After spending quite a bit of time trying to resolve this on more than one
occassion, using rather complex and ulgy approaches, it turns out that just
delaying the hashing of the dentry until the create operation works fine.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-deadlock-during-create fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-deadlock-during-create
+++ a/fs/autofs4/root.c
@@ -587,19 +587,20 @@ static struct dentry *autofs4_lookup(str
 	unhashed = autofs4_lookup_unhashed(sbi, dentry->d_parent, &dentry->d_name);
 	if (!unhashed) {
 		/*
-		 * Mark the dentry incomplete, but add it. This is needed so
-		 * that the VFS layer knows about the dentry, and we can count
-		 * on catching any lookups through the revalidate.
-		 *
-		 * Let all the hard work be done by the revalidate function that
-		 * needs to be able to do this anyway..
-		 *
-		 * We need to do this before we release the directory semaphore.
+		 * Mark the dentry incomplete but don't hash it. We do this
+		 * to serialize our inode creation operations (symlink and
+		 * mkdir) which prevents deadlock during the callback to
+		 * the daemon. Subsequent user space lookups for the same
+		 * dentry are placed on the wait queue while the daemon
+		 * itself is allowed passage unresticted so the create
+		 * operation itself can then hash the dentry. Finally,
+		 * we check for the hashed dentry and return the newly
+		 * hashed dentry.
 		 */
 		dentry->d_op = &autofs4_root_dentry_operations;
 
 		dentry->d_fsdata = NULL;
-		d_add(dentry, NULL);
+		d_instantiate(dentry, NULL);
 	} else {
 		struct autofs_info *ino = autofs4_dentry_ino(unhashed);
 		DPRINTK("rehash %p with %p", dentry, unhashed);
@@ -607,15 +608,17 @@ static struct dentry *autofs4_lookup(str
 		 * If we are racing with expire the request might not
 		 * be quite complete but the directory has been removed
 		 * so it must have been successful, so just wait for it.
+		 * We need to ensure the AUTOFS_INF_EXPIRING flag is clear
+		 * before continuing as revalidate may fail when calling
+		 * try_to_fill_dentry (returning EAGAIN) if we don't.
 		 */
-		if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
+		while (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
 			DPRINTK("wait for incomplete expire %p name=%.*s",
 				unhashed, unhashed->d_name.len,
 				unhashed->d_name.name);
 			autofs4_wait(sbi, unhashed, NFY_NONE);
 			DPRINTK("request completed");
 		}
-		d_rehash(unhashed);
 		dentry = unhashed;
 	}
 
@@ -658,7 +661,7 @@ static struct dentry *autofs4_lookup(str
 	 * for all system calls, but it should be OK for the operations
 	 * we permit from an autofs.
 	 */
-	if (dentry->d_inode && d_unhashed(dentry)) {
+	if (!oz_mode && d_unhashed(dentry)) {
 		/*
 		 * A user space application can (and has done in the past)
 		 * remove and re-create this directory during the callback.
@@ -716,7 +719,7 @@ static int autofs4_dir_symlink(struct in
 	strcpy(cp, symname);
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
-	d_instantiate(dentry, inode);
+	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
 		dentry->d_op = &autofs4_root_dentry_operations;
@@ -844,7 +847,7 @@ static int autofs4_dir_mkdir(struct inod
 		return -ENOSPC;
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
-	d_instantiate(dentry, inode);
+	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
 		dentry->d_op = &autofs4_root_dentry_operations;
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
autofs4-reinstate-negatitive-timeout-of-mount-fails.patch
autofs4-reinstate-negatitive-timeout-of-mount-fails-fix.patch

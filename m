From: akpm@linux-foundation.org
Subject: [merged]
 autofs4-factor-should_expire-out-of-autofs4_expire_indirect.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:20:07 -0700
Message-ID: <543d6957.tFFz1g1AYmv8pNcp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaJNSUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: factor should_expire() out of autofs4_expire_indirect.
has been removed from the -mm tree.  Its filename was
     autofs4-factor-should_expire-out-of-autofs4_expire_indirect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: autofs4: factor should_expire() out of autofs4_expire_indirect.

Future patch will potentially call this twice, so make it separate.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Ian Kent <raven@themaw.net>
Tested-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |  162 ++++++++++++++++++++++--------------------
 1 file changed, 88 insertions(+), 74 deletions(-)

diff -puN fs/autofs4/expire.c~autofs4-factor-should_expire-out-of-autofs4_expire_indirect fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-factor-should_expire-out-of-autofs4_expire_indirect
+++ a/fs/autofs4/expire.c
@@ -339,6 +339,89 @@ out:
 	return NULL;
 }
 
+/* Check if 'dentry' should expire, or return a nearby
+ * dentry that is suitable.
+ * If returned dentry is different from arg dentry,
+ * then a dget() reference was taken, else not.
+ */
+static struct dentry *should_expire(struct dentry *dentry,
+				    struct vfsmount *mnt,
+				    unsigned long timeout,
+				    int how)
+{
+	int do_now = how & AUTOFS_EXP_IMMEDIATE;
+	int exp_leaves = how & AUTOFS_EXP_LEAVES;
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	unsigned int ino_count;
+
+	/* No point expiring a pending mount */
+	if (ino->flags & AUTOFS_INF_PENDING)
+		return NULL;
+
+	/*
+	 * Case 1: (i) indirect mount or top level pseudo direct mount
+	 *	   (autofs-4.1).
+	 *	   (ii) indirect mount with offset mount, check the "/"
+	 *	   offset (autofs-5.0+).
+	 */
+	if (d_mountpoint(dentry)) {
+		DPRINTK("checking mountpoint %p %.*s",
+			dentry, (int)dentry->d_name.len, dentry->d_name.name);
+
+		/* Can we umount this guy */
+		if (autofs4_mount_busy(mnt, dentry))
+			return NULL;
+
+		/* Can we expire this guy */
+		if (autofs4_can_expire(dentry, timeout, do_now))
+			return dentry;
+		return NULL;
+	}
+
+	if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
+		DPRINTK("checking symlink %p %.*s",
+			dentry, (int)dentry->d_name.len, dentry->d_name.name);
+		/*
+		 * A symlink can't be "busy" in the usual sense so
+		 * just check last used for expire timeout.
+		 */
+		if (autofs4_can_expire(dentry, timeout, do_now))
+			return dentry;
+		return NULL;
+	}
+
+	if (simple_empty(dentry))
+		return NULL;
+
+	/* Case 2: tree mount, expire iff entire tree is not busy */
+	if (!exp_leaves) {
+		/* Path walk currently on this dentry? */
+		ino_count = atomic_read(&ino->count) + 1;
+		if (d_count(dentry) > ino_count)
+			return NULL;
+
+		if (!autofs4_tree_busy(mnt, dentry, timeout, do_now))
+			return dentry;
+	/*
+	 * Case 3: pseudo direct mount, expire individual leaves
+	 *	   (autofs-4.1).
+	 */
+	} else {
+		/* Path walk currently on this dentry? */
+		struct dentry *expired;
+		ino_count = atomic_read(&ino->count) + 1;
+		if (d_count(dentry) > ino_count)
+			return NULL;
+
+		expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
+		if (expired) {
+			if (expired == dentry)
+				dput(dentry);
+			return expired;
+		}
+	}
+	return NULL;
+}
 /*
  * Find an eligible tree to time-out
  * A tree is eligible if :-
@@ -353,11 +436,8 @@ struct dentry *autofs4_expire_indirect(s
 	unsigned long timeout;
 	struct dentry *root = sb->s_root;
 	struct dentry *dentry;
-	struct dentry *expired = NULL;
-	int do_now = how & AUTOFS_EXP_IMMEDIATE;
-	int exp_leaves = how & AUTOFS_EXP_LEAVES;
+	struct dentry *expired;
 	struct autofs_info *ino;
-	unsigned int ino_count;
 
 	if (!root)
 		return NULL;
@@ -368,78 +448,12 @@ struct dentry *autofs4_expire_indirect(s
 	dentry = NULL;
 	while ((dentry = get_next_positive_subdir(dentry, root))) {
 		spin_lock(&sbi->fs_lock);
-		ino = autofs4_dentry_ino(dentry);
-		/* No point expiring a pending mount */
-		if (ino->flags & AUTOFS_INF_PENDING)
-			goto next;
-
-		/*
-		 * Case 1: (i) indirect mount or top level pseudo direct mount
-		 *	   (autofs-4.1).
-		 *	   (ii) indirect mount with offset mount, check the "/"
-		 *	   offset (autofs-5.0+).
-		 */
-		if (d_mountpoint(dentry)) {
-			DPRINTK("checking mountpoint %p %.*s",
-				dentry, (int)dentry->d_name.len, dentry->d_name.name);
-
-			/* Can we umount this guy */
-			if (autofs4_mount_busy(mnt, dentry))
-				goto next;
-
-			/* Can we expire this guy */
-			if (autofs4_can_expire(dentry, timeout, do_now)) {
-				expired = dentry;
-				goto found;
-			}
-			goto next;
-		}
-
-		if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
-			DPRINTK("checking symlink %p %.*s",
-				dentry, (int)dentry->d_name.len, dentry->d_name.name);
-			/*
-			 * A symlink can't be "busy" in the usual sense so
-			 * just check last used for expire timeout.
-			 */
-			if (autofs4_can_expire(dentry, timeout, do_now)) {
-				expired = dentry;
-				goto found;
-			}
-			goto next;
-		}
-
-		if (simple_empty(dentry))
-			goto next;
-
-		/* Case 2: tree mount, expire iff entire tree is not busy */
-		if (!exp_leaves) {
-			/* Path walk currently on this dentry? */
-			ino_count = atomic_read(&ino->count) + 1;
-			if (d_count(dentry) > ino_count)
-				goto next;
-
-			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
-				expired = dentry;
-				goto found;
-			}
-		/*
-		 * Case 3: pseudo direct mount, expire individual leaves
-		 *	   (autofs-4.1).
-		 */
-		} else {
-			/* Path walk currently on this dentry? */
-			ino_count = atomic_read(&ino->count) + 1;
-			if (d_count(dentry) > ino_count)
-				goto next;

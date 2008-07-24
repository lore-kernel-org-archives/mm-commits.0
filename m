From: akpm@linux-foundation.org
Subject: - autofs4-fix-indirect-mount-pending-expire-race.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:44 -0700
Message-ID: <200807242329.m6ONTi9N011407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977AbYGXXaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix indirect mount pending expire race
has been removed from the -mm tree.  Its filename was
     autofs4-fix-indirect-mount-pending-expire-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix indirect mount pending expire race
From: Ian Kent <raven@themaw.net>

The selection of a dentry for expiration and the setting of the
AUTOFS_INF_EXPIRING flag isn't done atomically which can lead to lookups
walking into an expiring mount.

What happens is that an expire is initiated by the daemon and a dentry is
selected for expire but, since there is no lock held between the selection
and setting of the expiring flag, a process may find the flag clear and
continue walking into the mount tree at the same time the daemon attempts
the expire it.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |   10 ++------
 fs/autofs4/expire.c   |   46 ++++++++++++++++++++++++++++++----------
 fs/autofs4/root.c     |   32 +++++++++++++++++++++++----
 3 files changed, 65 insertions(+), 23 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-fix-indirect-mount-pending-expire-race fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-fix-indirect-mount-pending-expire-race
+++ a/fs/autofs4/autofs_i.h
@@ -138,18 +138,14 @@ static inline int autofs4_oz_mode(struct
 static inline int autofs4_ispending(struct dentry *dentry)
 {
 	struct autofs_info *inf = autofs4_dentry_ino(dentry);
-	int pending = 0;
 
 	if (dentry->d_flags & DCACHE_AUTOFS_PENDING)
 		return 1;
 
-	if (inf) {
-		spin_lock(&inf->sbi->fs_lock);
-		pending = inf->flags & AUTOFS_INF_EXPIRING;
-		spin_unlock(&inf->sbi->fs_lock);
-	}
+	if (inf->flags & AUTOFS_INF_EXPIRING)
+		return 1;
 
-	return pending;
+	return 0;
 }
 
 static inline void autofs4_copy_atime(struct file *src, struct file *dst)
diff -puN fs/autofs4/expire.c~autofs4-fix-indirect-mount-pending-expire-race fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-fix-indirect-mount-pending-expire-race
+++ a/fs/autofs4/expire.c
@@ -292,6 +292,8 @@ static struct dentry *autofs4_expire_ind
 	struct list_head *next;
 	int do_now = how & AUTOFS_EXP_IMMEDIATE;
 	int exp_leaves = how & AUTOFS_EXP_LEAVES;
+	struct autofs_info *ino;
+	unsigned int ino_count;
 
 	if (!root)
 		return NULL;
@@ -316,6 +318,9 @@ static struct dentry *autofs4_expire_ind
 		dentry = dget(dentry);
 		spin_unlock(&dcache_lock);
 
+		spin_lock(&sbi->fs_lock);
+		ino = autofs4_dentry_ino(dentry);
+
 		/*
 		 * Case 1: (i) indirect mount or top level pseudo direct mount
 		 *	   (autofs-4.1).
@@ -326,6 +331,11 @@ static struct dentry *autofs4_expire_ind
 			DPRINTK("checking mountpoint %p %.*s",
 				dentry, (int)dentry->d_name.len, dentry->d_name.name);
 
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 2;
+			if (atomic_read(&dentry->d_count) > ino_count)
+				goto next;
+
 			/* Can we umount this guy */
 			if (autofs4_mount_busy(mnt, dentry))
 				goto next;
@@ -343,23 +353,25 @@ static struct dentry *autofs4_expire_ind
 
 		/* Case 2: tree mount, expire iff entire tree is not busy */
 		if (!exp_leaves) {
-			/* Lock the tree as we must expire as a whole */
-			spin_lock(&sbi->fs_lock);
-			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
-				struct autofs_info *inf = autofs4_dentry_ino(dentry);
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 1;
+			if (atomic_read(&dentry->d_count) > ino_count)
+				goto next;
 
-				/* Set this flag early to catch sys_chdir and the like */
-				inf->flags |= AUTOFS_INF_EXPIRING;
-				spin_unlock(&sbi->fs_lock);
+			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
 				expired = dentry;
 				goto found;
 			}
-			spin_unlock(&sbi->fs_lock);
 		/*
 		 * Case 3: pseudo direct mount, expire individual leaves
 		 *	   (autofs-4.1).
 		 */
 		} else {
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 1;
+			if (atomic_read(&dentry->d_count) > ino_count)
+				goto next;
+
 			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
 			if (expired) {
 				dput(dentry);
@@ -367,6 +379,7 @@ static struct dentry *autofs4_expire_ind
 			}
 		}
 next:
+		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
 		spin_lock(&dcache_lock);
 		next = next->next;
@@ -377,6 +390,9 @@ next:
 found:
 	DPRINTK("returning %p %.*s",
 		expired, (int)expired->d_name.len, expired->d_name.name);
+	ino = autofs4_dentry_ino(expired);
+	ino->flags |= AUTOFS_INF_EXPIRING;
+	spin_unlock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
 	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
 	spin_unlock(&dcache_lock);
@@ -390,7 +406,9 @@ int autofs4_expire_run(struct super_bloc
 		      struct autofs_packet_expire __user *pkt_p)
 {
 	struct autofs_packet_expire pkt;
+	struct autofs_info *ino;
 	struct dentry *dentry;
+	int ret = 0;
 
 	memset(&pkt,0,sizeof pkt);
 
@@ -406,9 +424,14 @@ int autofs4_expire_run(struct super_bloc
 	dput(dentry);
 
 	if ( copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)) )
-		return -EFAULT;
+		ret = -EFAULT;
 
-	return 0;
+	spin_lock(&sbi->fs_lock);
+	ino = autofs4_dentry_ino(dentry);
+	ino->flags &= ~AUTOFS_INF_EXPIRING;
+	spin_unlock(&sbi->fs_lock);
+
+	return ret;
 }
 
 /* Call repeatedly until it returns -EAGAIN, meaning there's nothing
@@ -433,9 +456,10 @@ int autofs4_expire_multi(struct super_bl
 
 		/* This is synchronous because it makes the daemon a
                    little easier */
-		ino->flags |= AUTOFS_INF_EXPIRING;
 		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
+		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
+		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
 	}
 
diff -puN fs/autofs4/root.c~autofs4-fix-indirect-mount-pending-expire-race fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-indirect-mount-pending-expire-race
+++ a/fs/autofs4/root.c
@@ -133,7 +133,10 @@ static int try_to_fill_dentry(struct den
 	/* Block on any pending expiry here; invalidate the dentry
            when expiration is done to trigger mount request with a new
            dentry */
-	if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
+	spin_lock(&sbi->fs_lock);
+	if (ino->flags & AUTOFS_INF_EXPIRING) {
+		spin_unlock(&sbi->fs_lock);
+
 		DPRINTK("waiting for expire %p name=%.*s",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 
@@ -149,8 +152,11 @@ static int try_to_fill_dentry(struct den
 		status = d_invalidate(dentry);
 		if (status != -EBUSY)
 			return -EAGAIN;
-	}
 
+		goto cont;
+	}
+	spin_unlock(&sbi->fs_lock);
+cont:
 	DPRINTK("dentry=%p %.*s ino=%p",
 		 dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
 
@@ -229,15 +235,21 @@ static void *autofs4_follow_link(struct 
 		goto done;
 
 	/* If an expire request is pending wait for it. */
-	if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
+	spin_lock(&sbi->fs_lock);
+	if (ino->flags & AUTOFS_INF_EXPIRING) {
+		spin_unlock(&sbi->fs_lock);
+
 		DPRINTK("waiting for active request %p name=%.*s",
 			dentry, dentry->d_name.len, dentry->d_name.name);
 
 		status = autofs4_wait(sbi, dentry, NFY_NONE);
 
 		DPRINTK("request done status=%d", status);
-	}
 
+		goto cont;
+	}
+	spin_unlock(&sbi->fs_lock);
+cont:
 	/*
 	 * If the dentry contains directories then it is an
 	 * autofs multi-mount with no root mount offset. So
@@ -292,8 +304,11 @@ static int autofs4_revalidate(struct den
 	int status = 1;
 
 	/* Pending dentry */
+	spin_lock(&sbi->fs_lock);
 	if (autofs4_ispending(dentry)) {
 		/* The daemon never causes a mount to trigger */
+		spin_unlock(&sbi->fs_lock);
+
 		if (oz_mode)
 			return 1;
 
@@ -316,6 +331,7 @@ static int autofs4_revalidate(struct den
 
 		return status;
 	}
+	spin_unlock(&sbi->fs_lock);
 
 	/* Negative dentry.. invalidate if "old" */
 	if (dentry->d_inode == NULL)
@@ -329,6 +345,7 @@ static int autofs4_revalidate(struct den
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 		spin_unlock(&dcache_lock);
+
 		/* The daemon never causes a mount to trigger */
 		if (oz_mode)
 			return 1;
@@ -521,13 +538,18 @@ static struct dentry *autofs4_lookup(str
 		 * so it must have been successful, so just wait for it.
 		 */
 		ino = autofs4_dentry_ino(expiring);
-		while (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
+		spin_lock(&sbi->fs_lock);
+		if (ino->flags & AUTOFS_INF_EXPIRING) {
+			spin_unlock(&sbi->fs_lock);
 			DPRINTK("wait for incomplete expire %p name=%.*s",
 				expiring, expiring->d_name.len,
 				expiring->d_name.name);
 			autofs4_wait(sbi, expiring, NFY_NONE);
 			DPRINTK("request completed");
+			goto cont;
 		}
+		spin_unlock(&sbi->fs_lock);
+cont:
 		spin_lock(&sbi->lookup_lock);
 		if (!list_empty(&ino->expiring))
 			list_del_init(&ino->expiring);
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch


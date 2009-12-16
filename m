From: akpm@linux-foundation.org
Subject: [merged] autofs4-use-autofs_info-for-pending-flag.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:33:47 -0800
Message-ID: <200912162033.nBGKXlXC012973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbZLPUeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: use autofs_info for pending flag
has been removed from the -mm tree.  Its filename was
     autofs4-use-autofs_info-for-pending-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: use autofs_info for pending flag
From: Ian Kent <raven@themaw.net>

Eliminate the use of the d_lock spin lock by using the autofs super block
info spin lock.  This reduces the number of spin locks we use by one and
makes the code for the following patch (to redirect ->d_revalidate() to
->lookup()) a little simpler.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    3 +-
 fs/autofs4/expire.c   |    2 -
 fs/autofs4/root.c     |   58 ++++++++++++++++++++++------------------
 3 files changed, 35 insertions(+), 28 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-use-autofs_info-for-pending-flag fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-use-autofs_info-for-pending-flag
+++ a/fs/autofs4/autofs_i.h
@@ -97,6 +97,7 @@ struct autofs_info {
 
 #define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
 #define AUTOFS_INF_MOUNTPOINT	(1<<1) /* mountpoint status for direct expire */
+#define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
 
 struct autofs_wait_queue {
 	wait_queue_head_t queue;
@@ -163,7 +164,7 @@ static inline int autofs4_ispending(stru
 {
 	struct autofs_info *inf = autofs4_dentry_ino(dentry);
 
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING)
+	if (inf->flags & AUTOFS_INF_PENDING)
 		return 1;
 
 	if (inf->flags & AUTOFS_INF_EXPIRING)
diff -puN fs/autofs4/expire.c~autofs4-use-autofs_info-for-pending-flag fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-use-autofs_info-for-pending-flag
+++ a/fs/autofs4/expire.c
@@ -27,7 +27,7 @@ static inline int autofs4_can_expire(str
 		return 0;
 
 	/* No point expiring a pending mount */
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING)
+	if (ino->flags & AUTOFS_INF_PENDING)
 		return 0;
 
 	if (!do_now) {
diff -puN fs/autofs4/root.c~autofs4-use-autofs_info-for-pending-flag fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-use-autofs_info-for-pending-flag
+++ a/fs/autofs4/root.c
@@ -166,32 +166,32 @@ static int try_to_fill_dentry(struct den
 
 		/* Turn this into a real negative dentry? */
 		if (status == -ENOENT) {
-			spin_lock(&dentry->d_lock);
-			dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-			spin_unlock(&dentry->d_lock);
+			spin_lock(&sbi->fs_lock);
+			ino->flags &= ~AUTOFS_INF_PENDING;
+			spin_unlock(&sbi->fs_lock);
 			return status;
 		} else if (status) {
 			/* Return a negative dentry, but leave it "pending" */
 			return status;
 		}
 	/* Trigger mount for path component or follow link */
-	} else if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
+	} else if (ino->flags & AUTOFS_INF_PENDING ||
 			autofs4_need_mount(flags) ||
 			current->link_count) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
 
-		spin_lock(&dentry->d_lock);
-		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
-		spin_unlock(&dentry->d_lock);
+		spin_lock(&sbi->fs_lock);
+		ino->flags |= AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
 		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
 
 		DPRINTK("mount done status=%d", status);
 
 		if (status) {
-			spin_lock(&dentry->d_lock);
-			dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-			spin_unlock(&dentry->d_lock);
+			spin_lock(&sbi->fs_lock);
+			ino->flags &= ~AUTOFS_INF_PENDING;
+			spin_unlock(&sbi->fs_lock);
 			return status;
 		}
 	}
@@ -200,9 +200,9 @@ static int try_to_fill_dentry(struct den
 	if (ino)
 		ino->last_used = jiffies;
 
-	spin_lock(&dentry->d_lock);
-	dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-	spin_unlock(&dentry->d_lock);
+	spin_lock(&sbi->fs_lock);
+	ino->flags &= ~AUTOFS_INF_PENDING;
+	spin_unlock(&sbi->fs_lock);
 
 	return 0;
 }
@@ -243,18 +243,23 @@ static void *autofs4_follow_link(struct 
 
 	/* We trigger a mount for almost all flags */
 	lookup_type = autofs4_need_mount(nd->flags);
-	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
+	spin_lock(&sbi->fs_lock);
+	spin_lock(&dcache_lock);
+	if (!(lookup_type || ino->flags & AUTOFS_INF_PENDING)) {
+		spin_unlock(&dcache_lock);
+		spin_unlock(&sbi->fs_lock);
 		goto follow;
+	}
 
 	/*
 	 * If the dentry contains directories then it is an autofs
 	 * multi-mount with no root mount offset. So don't try to
 	 * mount it again.
 	 */
-	spin_lock(&dcache_lock);
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
+	if (ino->flags & AUTOFS_INF_PENDING ||
 	    (!d_mountpoint(dentry) && __simple_empty(dentry))) {
 		spin_unlock(&dcache_lock);
+		spin_unlock(&sbi->fs_lock);
 
 		status = try_to_fill_dentry(dentry, 0);
 		if (status)
@@ -263,6 +268,7 @@ static void *autofs4_follow_link(struct 
 		goto follow;
 	}
 	spin_unlock(&dcache_lock);
+	spin_unlock(&sbi->fs_lock);
 follow:
 	/*
 	 * If there is no root mount it must be an autofs
@@ -525,9 +531,10 @@ static struct dentry *autofs4_lookup(str
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
 	unhashed = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
-	if (unhashed)
+	if (unhashed) {
 		dentry = unhashed;
-	else {
+		ino = autofs4_dentry_ino(dentry);
+	} else {
 		/*
 		 * Mark the dentry incomplete but don't hash it. We do this
 		 * to serialize our inode creation operations (symlink and
@@ -569,15 +576,14 @@ static struct dentry *autofs4_lookup(str
 			 * be quite complete but the directory has been removed
 			 * so it must have been successful, so just wait for it.
 			 */
-			ino = autofs4_dentry_ino(expiring);
 			autofs4_expire_wait(expiring);
 			autofs4_del_expiring(expiring);
 			dput(expiring);
 		}
 
-		spin_lock(&dentry->d_lock);
-		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
-		spin_unlock(&dentry->d_lock);
+		spin_lock(&sbi->fs_lock);
+		ino->flags |= AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
 		if (dentry->d_op && dentry->d_op->d_revalidate)
 			(dentry->d_op->d_revalidate)(dentry, nd);
 		mutex_lock(&dir->i_mutex);
@@ -587,7 +593,7 @@ static struct dentry *autofs4_lookup(str
 	 * If we are still pending, check if we had to handle
 	 * a signal. If so we can force a restart..
 	 */
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING) {
+	if (ino->flags & AUTOFS_INF_PENDING) {
 		/* See if we were interrupted */
 		if (signal_pending(current)) {
 			sigset_t *sigset = &current->pending.signal;
@@ -600,9 +606,9 @@ static struct dentry *autofs4_lookup(str
 			}
 		}
 		if (!oz_mode) {
-			spin_lock(&dentry->d_lock);
-			dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-			spin_unlock(&dentry->d_lock);
+			spin_lock(&sbi->fs_lock);
+			ino->flags &= ~AUTOFS_INF_PENDING;
+			spin_unlock(&sbi->fs_lock);
 		}
 	}
 
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch


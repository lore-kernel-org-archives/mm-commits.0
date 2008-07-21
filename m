From: akpm@linux-foundation.org
Subject: + autofs4-fix-direct-mount-pending-expire-race.patch added to -mm tree
Date: Sun, 20 Jul 2008 23:35:29 -0700
Message-ID: <200807210635.m6L6ZTN8021574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564AbYGUGgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 02:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: fix direct mount pending expire race
has been added to the -mm tree.  Its filename is
     autofs4-fix-direct-mount-pending-expire-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix direct mount pending expire race
From: Ian Kent <raven@themaw.net>

For direct and offset type mounts that are covered by another mount we
cannot check the AUTOFS_INF_EXPIRING flag during a path walk which leads
to lookups walking into an expiring mount while it is being expired.

For example, for the direct multi-mount map entry with a couple of
offsets:

/race/mm1  /      <server1>:/<path1>
           /om1   <server2>:/<path2>
           /om2   <server1>:/<path3>

an autofs trigger mount is mounted on /race/mm1 and when accessed it is
over mounted and trigger mounts made for /race/mm1/om1 and /race/mm1/om2. 
So it isn't possible for path walks to see the expiring flag at all and
they happily walk into the file system while it is expiring.

When expiring these mounts follow_down() must stop at the autofs mount and
all processes must block in the ->follow_link() method (except the daemon)
until the expire is complete.  This is done by decrementing the d_mounted
field of the autofs trigger mount root dentry until the expire is
completed.  In ->follow_link() all processes wait on the expire and the
mount following is completed for the daemon until the expire is complete.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    3 +
 fs/autofs4/expire.c   |   16 +++++++-
 fs/autofs4/root.c     |   72 +++++++++++++++++++++++++++-------------
 3 files changed, 65 insertions(+), 26 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-fix-direct-mount-pending-expire-race fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-fix-direct-mount-pending-expire-race
+++ a/fs/autofs4/autofs_i.h
@@ -52,6 +52,8 @@ struct autofs_info {
 
 	int		flags;
 
+	struct completion expire_complete;
+
 	struct list_head active;
 	struct list_head expiring;
 
@@ -69,6 +71,7 @@ struct autofs_info {
 };
 
 #define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
+#define AUTOFS_INF_MOUNTPOINT	(1<<1) /* mountpoint status for direct expire */
 
 struct autofs_wait_queue {
 	wait_queue_head_t queue;
diff -puN fs/autofs4/expire.c~autofs4-fix-direct-mount-pending-expire-race fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-fix-direct-mount-pending-expire-race
+++ a/fs/autofs4/expire.c
@@ -259,13 +259,15 @@ static struct dentry *autofs4_expire_dir
 	now = jiffies;
 	timeout = sbi->exp_timeout;
 
-	/* Lock the tree as we must expire as a whole */
 	spin_lock(&sbi->fs_lock);
 	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
 		struct autofs_info *ino = autofs4_dentry_ino(root);
-
-		/* Set this flag early to catch sys_chdir and the like */
+		if (d_mountpoint(root)) {
+			ino->flags |= AUTOFS_INF_MOUNTPOINT;
+			root->d_mounted--;
+		}
 		ino->flags |= AUTOFS_INF_EXPIRING;
+		init_completion(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
 		return root;
 	}
@@ -392,6 +394,7 @@ found:
 		expired, (int)expired->d_name.len, expired->d_name.name);
 	ino = autofs4_dentry_ino(expired);
 	ino->flags |= AUTOFS_INF_EXPIRING;
+	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
 	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
@@ -429,6 +432,7 @@ int autofs4_expire_run(struct super_bloc
 	spin_lock(&sbi->fs_lock);
 	ino = autofs4_dentry_ino(dentry);
 	ino->flags &= ~AUTOFS_INF_EXPIRING;
+	complete_all(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 
 	return ret;
@@ -457,8 +461,14 @@ int autofs4_expire_multi(struct super_bl
 		/* This is synchronous because it makes the daemon a
                    little easier */
 		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
+
 		spin_lock(&sbi->fs_lock);
+		if (ino->flags & AUTOFS_INF_MOUNTPOINT) {
+			sb->s_root->d_mounted++;
+			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
+		}
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
+		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
 	}
diff -puN fs/autofs4/root.c~autofs4-fix-direct-mount-pending-expire-race fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-direct-mount-pending-expire-race
+++ a/fs/autofs4/root.c
@@ -141,6 +141,7 @@ static int try_to_fill_dentry(struct den
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 
 		status = autofs4_wait(sbi, dentry, NFY_NONE);
+		wait_for_completion(&ino->expire_complete);
 
 		DPRINTK("expire done status=%d", status);
 
@@ -227,14 +228,32 @@ static void *autofs4_follow_link(struct 
 	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
 		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
 		nd->flags);
-
-	/* If it's our master or we shouldn't trigger a mount we're done */
-	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
-	if (oz_mode ||
-	    !(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
+	/*
+	 * For an expire of a covered direct or offset mount we need
+	 * to beeak out of follow_down() at the autofs mount trigger
+	 * (d_mounted--), so we can see the expiring flag, and manage
+	 * the blocking and following here until the expire is completed.
+	 */
+	if (oz_mode) {
+		spin_lock(&sbi->fs_lock);
+		if (ino->flags & AUTOFS_INF_EXPIRING) {
+			spin_unlock(&sbi->fs_lock);
+			/* Follow down to our covering mount. */
+			if (!follow_down(&nd->path.mnt, &nd->path.dentry))
+				goto done;
+			/*
+			 * We shouldn't need to do this but we have no way
+			 * of knowing what may have been done so try a follow
+			 * just in case.
+			 */
+			autofs4_follow_mount(&nd->path.mnt, &nd->path.dentry);
+			goto done;
+		}
+		spin_unlock(&sbi->fs_lock);
 		goto done;
+	}
 
-	/* If an expire request is pending wait for it. */
+	/* If an expire request is pending everyone must wait. */
 	spin_lock(&sbi->fs_lock);
 	if (ino->flags & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
@@ -243,6 +262,7 @@ static void *autofs4_follow_link(struct 
 			dentry, dentry->d_name.len, dentry->d_name.name);
 
 		status = autofs4_wait(sbi, dentry, NFY_NONE);
+		wait_for_completion(&ino->expire_complete);
 
 		DPRINTK("request done status=%d", status);
 
@@ -250,10 +270,15 @@ static void *autofs4_follow_link(struct 
 	}
 	spin_unlock(&sbi->fs_lock);
 cont:
+	/* We trigger a mount for almost all flags */
+	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
+	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
+		goto done;
+
 	/*
-	 * If the dentry contains directories then it is an
-	 * autofs multi-mount with no root mount offset. So
-	 * don't try to mount it again.
+	 * If the dentry contains directories then it is an autofs
+	 * multi-mount with no root mount offset. So don't try to
+	 * mount it again.
 	 */
 	spin_lock(&dcache_lock);
 	if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
@@ -264,22 +289,22 @@ cont:
 		if (status)
 			goto out_error;
 
-		/*
-		 * The mount succeeded but if there is no root mount
-		 * it must be an autofs multi-mount with no root offset
-		 * so we don't need to follow the mount.
-		 */
-		if (d_mountpoint(dentry)) {
-			if (!autofs4_follow_mount(&nd->path.mnt,
-						  &nd->path.dentry)) {
-				status = -ENOENT;
-				goto out_error;
-			}
-		}
-
-		goto done;
+		goto follow;
 	}
 	spin_unlock(&dcache_lock);
+follow:
+	/*
+	 * If there is no root mount it must be an autofs
+	 * multi-mount with no root offset so we don't need
+	 * to follow it.
+	 */
+	if (d_mountpoint(dentry)) {
+		if (!autofs4_follow_mount(&nd->path.mnt,
+					  &nd->path.dentry)) {
+			status = -ENOENT;
+			goto out_error;
+		}
+	}
 
 done:
 	return NULL;
@@ -545,6 +570,7 @@ static struct dentry *autofs4_lookup(str
 				expiring, expiring->d_name.len,
 				expiring->d_name.name);
 			autofs4_wait(sbi, expiring, NFY_NONE);
+			wait_for_completion(&ino->expire_complete);
 			DPRINTK("request completed");
 			goto cont;
 		}
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-dont-make-expiring-dentry-negative.patch
autofs4-dont-make-expiring-dentry-negative-fix.patch
autofs4-revert-redo-lookup-in-ttfd.patch
autofs4-use-look-aside-list-for-lookups.patch
autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch
autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
autofs4-use-struct-qstr-in-waitqc.patch
autofs4-fix-waitq-locking.patch
autofs4-fix-pending-mount-race.patch
autofs4-fix-pending-mount-race-fix.patch
autofs4-check-kernel-communication-pipe-is-valid-for-write.patch
autofs4-fix-waitq-memory-leak.patch
autofs4-detect-invalid-direct-mount-requests.patch
autofs4-indirect-dentry-must-almost-always-be-positive.patch
autofs4-cleanup-redundant-readir-code.patch
autofs4-fix-pending-checks.patch
autofs4-fix-indirect-mount-pending-expire-race.patch
autofs4-fix-direct-mount-pending-expire-race.patch
autofs4-reorganize-expire-pending-wait-function-calls.patch
autofs4-remove-unused-ioctls.patch


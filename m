From: akpm@linux-foundation.org
Subject: + autofs4-reorganize-expire-pending-wait-function-calls.patch added to -mm tree
Date: Sun, 20 Jul 2008 23:35:31 -0700
Message-ID: <200807210635.m6L6ZV7a021582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbYGUGfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 02:35:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: reorganize expire pending wait function calls
has been added to the -mm tree.  Its filename is
     autofs4-reorganize-expire-pending-wait-function-calls.patch

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
Subject: autofs4: reorganize expire pending wait function calls
From: Ian Kent <raven@themaw.net>

This patch re-orgnirzes the checking for and waiting on active expires and
elininates redundant checks.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    1 
 fs/autofs4/expire.c   |   29 +++++++++++++++
 fs/autofs4/root.c     |   75 +++++-----------------------------------
 3 files changed, 40 insertions(+), 65 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-reorganize-expire-pending-wait-function-calls fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-reorganize-expire-pending-wait-function-calls
+++ a/fs/autofs4/autofs_i.h
@@ -163,6 +163,7 @@ void autofs4_free_ino(struct autofs_info
 
 /* Expiration */
 int is_autofs4_dentry(struct dentry *);
+int autofs4_expire_wait(struct dentry *dentry);
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *,
 			struct autofs_packet_expire __user *);
diff -puN fs/autofs4/expire.c~autofs4-reorganize-expire-pending-wait-function-calls fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-reorganize-expire-pending-wait-function-calls
+++ a/fs/autofs4/expire.c
@@ -402,6 +402,35 @@ found:
 	return expired;
 }
 
+int autofs4_expire_wait(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	int status;
+
+	/* Block on any pending expire */
+	spin_lock(&sbi->fs_lock);
+	if (ino->flags & AUTOFS_INF_EXPIRING) {
+		spin_unlock(&sbi->fs_lock);
+
+		DPRINTK("waiting for expire %p name=%.*s",
+			 dentry, dentry->d_name.len, dentry->d_name.name);
+
+		status = autofs4_wait(sbi, dentry, NFY_NONE);
+		wait_for_completion(&ino->expire_complete);
+
+		DPRINTK("expire done status=%d", status);
+
+		if (d_unhashed(dentry))
+			return -EAGAIN;
+
+		return status;
+	}
+	spin_unlock(&sbi->fs_lock);
+
+	return 0;
+}
+
 /* Perform an expiry operation */
 int autofs4_expire_run(struct super_block *sb,
 		      struct vfsmount *mnt,
diff -puN fs/autofs4/root.c~autofs4-reorganize-expire-pending-wait-function-calls fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-reorganize-expire-pending-wait-function-calls
+++ a/fs/autofs4/root.c
@@ -130,34 +130,6 @@ static int try_to_fill_dentry(struct den
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status;
 
-	/* Block on any pending expiry here; invalidate the dentry
-           when expiration is done to trigger mount request with a new
-           dentry */
-	spin_lock(&sbi->fs_lock);
-	if (ino->flags & AUTOFS_INF_EXPIRING) {
-		spin_unlock(&sbi->fs_lock);
-
-		DPRINTK("waiting for expire %p name=%.*s",
-			 dentry, dentry->d_name.len, dentry->d_name.name);
-
-		status = autofs4_wait(sbi, dentry, NFY_NONE);
-		wait_for_completion(&ino->expire_complete);
-
-		DPRINTK("expire done status=%d", status);
-
-		/*
-		 * If the directory still exists the mount request must
-		 * continue otherwise it can't be followed at the right
-		 * time during the walk.
-		 */
-		status = d_invalidate(dentry);
-		if (status != -EBUSY)
-			return -EAGAIN;
-
-		goto cont;
-	}
-	spin_unlock(&sbi->fs_lock);
-cont:
 	DPRINTK("dentry=%p %.*s ino=%p",
 		 dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
 
@@ -254,22 +226,8 @@ static void *autofs4_follow_link(struct 
 	}
 
 	/* If an expire request is pending everyone must wait. */
-	spin_lock(&sbi->fs_lock);
-	if (ino->flags & AUTOFS_INF_EXPIRING) {
-		spin_unlock(&sbi->fs_lock);
-
-		DPRINTK("waiting for active request %p name=%.*s",
-			dentry, dentry->d_name.len, dentry->d_name.name);
-
-		status = autofs4_wait(sbi, dentry, NFY_NONE);
-		wait_for_completion(&ino->expire_complete);
+	autofs4_expire_wait(dentry);
 
-		DPRINTK("request done status=%d", status);
-
-		goto cont;
-	}
-	spin_unlock(&sbi->fs_lock);
-cont:
 	/* We trigger a mount for almost all flags */
 	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
 	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
@@ -338,6 +296,14 @@ static int autofs4_revalidate(struct den
 			return 1;
 
 		/*
+		 * If the directory has gone away due to an expire
+		 * we have been called as ->d_revalidate() and so
+		 * we need to return false and proceed to ->lookup().
+		 */
+		if (autofs4_expire_wait(dentry) == -EAGAIN)
+			return 0;
+
+		/*
 		 * A zero status is success otherwise we have a
 		 * negative error code.
 		 */
@@ -345,15 +311,6 @@ static int autofs4_revalidate(struct den
 		if (status == 0)
 			return 1;
 
-		/*
-		 * A status of EAGAIN here means that the dentry has gone
-		 * away while waiting for an expire to complete. If we are
-		 * racing with expire lookup will wait for it so this must
-		 * be a revalidate and we need to send it to lookup.
-		 */
-		if (status == -EAGAIN)
-			return 0;
-
 		return status;
 	}
 	spin_unlock(&sbi->fs_lock);
@@ -563,19 +520,7 @@ static struct dentry *autofs4_lookup(str
 		 * so it must have been successful, so just wait for it.
 		 */
 		ino = autofs4_dentry_ino(expiring);
-		spin_lock(&sbi->fs_lock);
-		if (ino->flags & AUTOFS_INF_EXPIRING) {
-			spin_unlock(&sbi->fs_lock);
-			DPRINTK("wait for incomplete expire %p name=%.*s",
-				expiring, expiring->d_name.len,
-				expiring->d_name.name);
-			autofs4_wait(sbi, expiring, NFY_NONE);
-			wait_for_completion(&ino->expire_complete);
-			DPRINTK("request completed");
-			goto cont;
-		}
-		spin_unlock(&sbi->fs_lock);
-cont:
+		autofs4_expire_wait(expiring);
 		spin_lock(&sbi->lookup_lock);
 		if (!list_empty(&ino->expiring))
 			list_del_init(&ino->expiring);
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


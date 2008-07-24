From: akpm@linux-foundation.org
Subject: - autofs4-reorganize-expire-pending-wait-function-calls.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:51 -0700
Message-ID: <200807242329.m6ONTpr8011419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756364AbYGXXaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: reorganize expire pending wait function calls
has been removed from the -mm tree.  Its filename was
     autofs4-reorganize-expire-pending-wait-function-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -248,22 +220,8 @@ static void *autofs4_follow_link(struct 
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
@@ -332,6 +290,14 @@ static int autofs4_revalidate(struct den
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
@@ -339,15 +305,6 @@ static int autofs4_revalidate(struct den
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
@@ -557,19 +514,7 @@ static struct dentry *autofs4_lookup(str
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

origin.patch


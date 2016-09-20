From: akpm@linux-foundation.org
Subject: [merged]
 autofs-use-dentry-flags-to-block-walks-during-expire.patch removed from -mm tree
Date: Tue, 20 Sep 2016 12:30:33 -0700
Message-ID: <57e18e59.JsWEl3qpEMS+jJY7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48667 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753080AbcITTae (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 15:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, neilb@suse.com, stable@vger.kernel.org, tiwai@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: use dentry flags to block walks during expire
has been removed from the -mm tree.  Its filename was
     autofs-use-dentry-flags-to-block-walks-during-expire.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: use dentry flags to block walks during expire

Somewhere along the way the autofs expire operation has changed to hold a
spin lock over expired dentry selection.  The autofs indirect mount
expired dentry selection is complicated and quite lengthy so it isn't
appropriate to hold a spin lock over the operation.

Commit 47be6184 ("fs/dcache.c: avoid soft-lockup in dput()") added a
might_sleep() to dput() causing a WARN_ONCE() about this usage to be
issued.

But the spin lock doesn't need to be held over this check, the autofs
dentry info.  flags are enough to block walks into dentrys during the
expire.

I've left the direct mount expire as it is (for now) because it is much
simpler and quicker than the indirect mount expire and adding spin lock
release and re-aquires would do nothing more than add overhead.

Fixes: 47be61845c77 ("fs/dcache.c: avoid soft-lockup in dput()")
Link: http://lkml.kernel.org/r/20160912014017.1773.73060.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Reported-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Takashi Iwai <tiwai@suse.de>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: NeilBrown <neilb@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |   55 ++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff -puN fs/autofs4/expire.c~autofs-use-dentry-flags-to-block-walks-during-expire fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs-use-dentry-flags-to-block-walks-during-expire
+++ a/fs/autofs4/expire.c
@@ -417,6 +417,7 @@ static struct dentry *should_expire(stru
 	}
 	return NULL;
 }
+
 /*
  * Find an eligible tree to time-out
  * A tree is eligible if :-
@@ -432,6 +433,7 @@ struct dentry *autofs4_expire_indirect(s
 	struct dentry *root = sb->s_root;
 	struct dentry *dentry;
 	struct dentry *expired;
+	struct dentry *found;
 	struct autofs_info *ino;
 
 	if (!root)
@@ -442,31 +444,46 @@ struct dentry *autofs4_expire_indirect(s
 
 	dentry = NULL;
 	while ((dentry = get_next_positive_subdir(dentry, root))) {
+		int flags = how;
+
 		spin_lock(&sbi->fs_lock);
 		ino = autofs4_dentry_ino(dentry);
-		if (ino->flags & AUTOFS_INF_WANT_EXPIRE)
-			expired = NULL;
-		else
-			expired = should_expire(dentry, mnt, timeout, how);
-		if (!expired) {
+		if (ino->flags & AUTOFS_INF_WANT_EXPIRE) {
 			spin_unlock(&sbi->fs_lock);
 			continue;
 		}
+		spin_unlock(&sbi->fs_lock);
+
+		expired = should_expire(dentry, mnt, timeout, flags);
+		if (!expired)
+			continue;
+
+		spin_lock(&sbi->fs_lock);
 		ino = autofs4_dentry_ino(expired);
 		ino->flags |= AUTOFS_INF_WANT_EXPIRE;
 		spin_unlock(&sbi->fs_lock);
 		synchronize_rcu();
-		spin_lock(&sbi->fs_lock);
-		if (should_expire(expired, mnt, timeout, how)) {
-			if (expired != dentry)
-				dput(dentry);
-			goto found;
-		}
 
+		/* Make sure a reference is not taken on found if
+		 * things have changed.
+		 */
+		flags &= ~AUTOFS_EXP_LEAVES;
+		found = should_expire(expired, mnt, timeout, how);
+		if (!found || found != expired)
+			/* Something has changed, continue */
+			goto next;
+
+		if (expired != dentry)
+			dput(dentry);
+
+		spin_lock(&sbi->fs_lock);
+		goto found;
+next:
+		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_WANT_EXPIRE;
+		spin_unlock(&sbi->fs_lock);
 		if (expired != dentry)
 			dput(expired);
-		spin_unlock(&sbi->fs_lock);
 	}
 	return NULL;
 
@@ -483,6 +500,7 @@ int autofs4_expire_wait(struct dentry *d
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status;
+	int state;
 
 	/* Block on any pending expire */
 	if (!(ino->flags & AUTOFS_INF_WANT_EXPIRE))
@@ -490,8 +508,19 @@ int autofs4_expire_wait(struct dentry *d
 	if (rcu_walk)
 		return -ECHILD;
 
+retry:
 	spin_lock(&sbi->fs_lock);
-	if (ino->flags & AUTOFS_INF_EXPIRING) {
+	state = ino->flags & (AUTOFS_INF_WANT_EXPIRE | AUTOFS_INF_EXPIRING);
+	if (state == AUTOFS_INF_WANT_EXPIRE) {
+		spin_unlock(&sbi->fs_lock);
+		/*
+		 * Possibly being selected for expire, wait until
+		 * it's selected or not.
+		 */
+		schedule_timeout_uninterruptible(HZ/10);
+		goto retry;
+	}
+	if (state & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
 
 		pr_debug("waiting for expire %p name=%pd\n", dentry, dentry);
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-fix-autofs4_fill_super-error-exit-handling.patch
autofs-remove-ino-free-in-autofs4_dir_symlink.patch
autofs-fix-dev-ioctl-number-range-check.patch
autofs-add-autofs_dev_ioctl_version-for-autofs_dev_ioctl_version_cmd.patch
autofs4-move-linux-auto_dev-ioctlh-to-uapi-linux.patch
fs-make-is_local_mountpoint-usable-by-others.patch
fs-add-have_local_submounts.patch
autofs-make-mountpoint-checks-namespace-aware.patch
fs-remove-unused-have_submounts-function.patch


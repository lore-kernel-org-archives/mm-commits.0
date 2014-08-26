From: akpm@linux-foundation.org
Subject: + autofs4-allow-rcu-walk-to-walk-through-autofs4.patch added to
 -mm tree
Date: Tue, 26 Aug 2014 15:17:02 -0700
Message-ID: <53fd075e.h3vSWLdFSL/mDNml%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:42384 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbaHZWRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 18:17:03 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so4100036pde.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 15:17:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: allow RCU-walk to walk through autofs4
has been added to the -mm tree.  Its filename is
     autofs4-allow-rcu-walk-to-walk-through-autofs4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-allow-rcu-walk-to-walk-through-autofs4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-allow-rcu-walk-to-walk-through-autofs4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: autofs4: allow RCU-walk to walk through autofs4

This series teaches autofs about RCU-walk so that we don't drop straight
into REF-walk when we hit an autofs directory, and so that we avoid
spinlocks as much as possible when performing an RCU-walk.

This is needed so that the benefits of the recent NFS support for RCU-walk
are fully available when NFS filesystems are automounted.

Patches have been carefully reviewed and tested both with test suites and
in production - thanks a lot to Ian Kent for his support there.



This patch (of 6):

Any attempt to look up a pathname that passes though an autofs4 mount is
currently forced out of RCU-walk into REF-walk.

This can significantly hurt performance of many-thread work loads on
many-core systems, especially if the automounted filesystem supports
RCU-walk but doesn't get to benefit from it.

So if autofs4_d_manage is called with rcu_walk set, only fail with -ECHILD
if it is necessary to wait longer than a spinlock.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Ian Kent <raven@themaw.net>
Tested-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h  |    2 -
 fs/autofs4/dev-ioctl.c |    2 -
 fs/autofs4/expire.c    |    4 ++-
 fs/autofs4/root.c      |   44 +++++++++++++++++++++++++--------------
 4 files changed, 34 insertions(+), 18 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-allow-rcu-walk-to-walk-through-autofs4 fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-allow-rcu-walk-to-walk-through-autofs4
+++ a/fs/autofs4/autofs_i.h
@@ -148,7 +148,7 @@ void autofs4_free_ino(struct autofs_info
 
 /* Expiration */
 int is_autofs4_dentry(struct dentry *);
-int autofs4_expire_wait(struct dentry *dentry);
+int autofs4_expire_wait(struct dentry *dentry, int rcu_walk);
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *,
 			struct autofs_packet_expire __user *);
diff -puN fs/autofs4/dev-ioctl.c~autofs4-allow-rcu-walk-to-walk-through-autofs4 fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-allow-rcu-walk-to-walk-through-autofs4
+++ a/fs/autofs4/dev-ioctl.c
@@ -450,7 +450,7 @@ static int autofs_dev_ioctl_requester(st
 	ino = autofs4_dentry_ino(path.dentry);
 	if (ino) {
 		err = 0;
-		autofs4_expire_wait(path.dentry);
+		autofs4_expire_wait(path.dentry, 0);
 		spin_lock(&sbi->fs_lock);
 		param->requester.uid = from_kuid_munged(current_user_ns(), ino->uid);
 		param->requester.gid = from_kgid_munged(current_user_ns(), ino->gid);
diff -puN fs/autofs4/expire.c~autofs4-allow-rcu-walk-to-walk-through-autofs4 fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-allow-rcu-walk-to-walk-through-autofs4
+++ a/fs/autofs4/expire.c
@@ -467,7 +467,7 @@ found:
 	return expired;
 }
 
-int autofs4_expire_wait(struct dentry *dentry)
+int autofs4_expire_wait(struct dentry *dentry, int rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
@@ -477,6 +477,8 @@ int autofs4_expire_wait(struct dentry *d
 	spin_lock(&sbi->fs_lock);
 	if (ino->flags & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
+		if (rcu_walk)
+			return -ECHILD;
 
 		DPRINTK("waiting for expire %p name=%.*s",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
diff -puN fs/autofs4/root.c~autofs4-allow-rcu-walk-to-walk-through-autofs4 fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-allow-rcu-walk-to-walk-through-autofs4
+++ a/fs/autofs4/root.c
@@ -210,7 +210,8 @@ next:
 	return NULL;
 }
 
-static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
+static struct dentry *autofs4_lookup_expiring(struct dentry *dentry,
+					      bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct dentry *parent = dentry->d_parent;
@@ -229,6 +230,11 @@ static struct dentry *autofs4_lookup_exp
 		struct dentry *expiring;
 		struct qstr *qstr;
 
+		if (rcu_walk) {
+			spin_unlock(&sbi->lookup_lock);
+			return ERR_PTR(-ECHILD);
+		}
+
 		ino = list_entry(p, struct autofs_info, expiring);
 		expiring = ino->dentry;
 
@@ -264,13 +270,15 @@ next:
 	return NULL;
 }
 
-static int autofs4_mount_wait(struct dentry *dentry)
+static int autofs4_mount_wait(struct dentry *dentry, bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status = 0;
 
 	if (ino->flags & AUTOFS_INF_PENDING) {
+		if (rcu_walk)
+			return -ECHILD;
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
 		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
@@ -280,20 +288,22 @@ static int autofs4_mount_wait(struct den
 	return status;
 }
 
-static int do_expire_wait(struct dentry *dentry)
+static int do_expire_wait(struct dentry *dentry, bool rcu_walk)
 {
 	struct dentry *expiring;
 
-	expiring = autofs4_lookup_expiring(dentry);
+	expiring = autofs4_lookup_expiring(dentry, rcu_walk);
+	if (IS_ERR(expiring))
+		return PTR_ERR(expiring);
 	if (!expiring)
-		return autofs4_expire_wait(dentry);
+		return autofs4_expire_wait(dentry, rcu_walk);
 	else {
 		/*
 		 * If we are racing with expire the request might not
 		 * be quite complete, but the directory has been removed
 		 * so it must have been successful, just wait for it.
 		 */
-		autofs4_expire_wait(expiring);
+		autofs4_expire_wait(expiring, 0);
 		autofs4_del_expiring(expiring);
 		dput(expiring);
 	}
@@ -345,7 +355,7 @@ static struct vfsmount *autofs4_d_automo
 	 * and the directory was removed, so just go ahead and try
 	 * the mount.
 	 */
-	status = do_expire_wait(dentry);
+	status = do_expire_wait(dentry, 0);
 	if (status && status != -EAGAIN)
 		return NULL;
 
@@ -353,7 +363,7 @@ static struct vfsmount *autofs4_d_automo
 	spin_lock(&sbi->fs_lock);
 	if (ino->flags & AUTOFS_INF_PENDING) {
 		spin_unlock(&sbi->fs_lock);
-		status = autofs4_mount_wait(dentry);
+		status = autofs4_mount_wait(dentry, 0);
 		if (status)
 			return ERR_PTR(status);
 		goto done;
@@ -394,7 +404,7 @@ static struct vfsmount *autofs4_d_automo
 		}
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
-		status = autofs4_mount_wait(dentry);
+		status = autofs4_mount_wait(dentry, 0);
 		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_PENDING;
 		if (status) {
@@ -430,21 +440,25 @@ static int autofs4_d_manage(struct dentr
 		return 0;
 	}
 
-	/* We need to sleep, so we need pathwalk to be in ref-mode */
-	if (rcu_walk)
-		return -ECHILD;
-
 	/* Wait for pending expires */
-	do_expire_wait(dentry);
+	if (do_expire_wait(dentry, rcu_walk) == -ECHILD)
+		return -ECHILD;
 
 	/*
 	 * This dentry may be under construction so wait on mount
 	 * completion.
 	 */
-	status = autofs4_mount_wait(dentry);
+	status = autofs4_mount_wait(dentry, rcu_walk);
 	if (status)
 		return status;
 
+	if (rcu_walk)
+		/* it is always safe to return 0 as the worst that
+		 * will happen is we retry in REF-walk mode.
+		 * Better than always taking a lock.
+		 */
+		return 0;
+
 	spin_lock(&sbi->fs_lock);
 	/*
 	 * If the dentry has been selected for expire while we slept
_

Patches currently in -mm which might be from neilb@suse.de are

autofs4-allow-rcu-walk-to-walk-through-autofs4.patch
autofs4-factor-should_expire-out-of-autofs4_expire_indirect.patch
autofs4-make-autofs4_can_expire-idempotent.patch
autofs4-avoid-taking-fs_lock-during-rcu-walk.patch
autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch
autofs-the-documentation-i-wanted-to-read.patch
linux-next.patch


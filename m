From: akpm@linux-foundation.org
Subject: + autofs-change-autofs4_expire_wait-to-take-struct-path.patch
 added to -mm tree
Date: Wed, 19 Oct 2016 12:40:48 -0700
Message-ID: <5807cc40.yFgXfopJzACMaVs8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60711 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941037AbcJSTkt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 15:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: change autofs4_expire_wait() to take struct path
has been added to the -mm tree.  Its filename is
     autofs-change-autofs4_expire_wait-to-take-struct-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-change-autofs4_expire_wait-to-take-struct-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-change-autofs4_expire_wait-to-take-struct-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <ikent@redhat.com>
Subject: autofs: change autofs4_expire_wait() to take struct path

In order to use the functions path_is_mountpoint() (or it's rcu-walk
variant) and path_has_submounts() autofs needs to pass a struct path in
several places.

Start by changing autofs4_expire_wait() to take a struct path instead of a
struct dentry.

Link: http://lkml.kernel.org/r/20161011053408.27645.40091.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h  |    2 +-
 fs/autofs4/dev-ioctl.c |    2 +-
 fs/autofs4/expire.c    |    3 ++-
 fs/autofs4/root.c      |   12 +++++++-----
 4 files changed, 11 insertions(+), 8 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs-change-autofs4_expire_wait-to-take-struct-path fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs-change-autofs4_expire_wait-to-take-struct-path
+++ a/fs/autofs4/autofs_i.h
@@ -145,7 +145,7 @@ void autofs4_free_ino(struct autofs_info
 
 /* Expiration */
 int is_autofs4_dentry(struct dentry *);
-int autofs4_expire_wait(struct dentry *dentry, int rcu_walk);
+int autofs4_expire_wait(struct path *path, int rcu_walk);
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
 		       struct autofs_sb_info *,
 		       struct autofs_packet_expire __user *);
diff -puN fs/autofs4/dev-ioctl.c~autofs-change-autofs4_expire_wait-to-take-struct-path fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-change-autofs4_expire_wait-to-take-struct-path
+++ a/fs/autofs4/dev-ioctl.c
@@ -468,7 +468,7 @@ static int autofs_dev_ioctl_requester(st
 	ino = autofs4_dentry_ino(path.dentry);
 	if (ino) {
 		err = 0;
-		autofs4_expire_wait(path.dentry, 0);
+		autofs4_expire_wait(&path, 0);
 		spin_lock(&sbi->fs_lock);
 		param->requester.uid =
 			from_kuid_munged(current_user_ns(), ino->uid);
diff -puN fs/autofs4/expire.c~autofs-change-autofs4_expire_wait-to-take-struct-path fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs-change-autofs4_expire_wait-to-take-struct-path
+++ a/fs/autofs4/expire.c
@@ -495,8 +495,9 @@ found:
 	return expired;
 }
 
-int autofs4_expire_wait(struct dentry *dentry, int rcu_walk)
+int autofs4_expire_wait(struct path *path, int rcu_walk)
 {
+	struct dentry *dentry = path->dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status;
diff -puN fs/autofs4/root.c~autofs-change-autofs4_expire_wait-to-take-struct-path fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-change-autofs4_expire_wait-to-take-struct-path
+++ a/fs/autofs4/root.c
@@ -286,22 +286,24 @@ static int autofs4_mount_wait(struct den
 	return status;
 }
 
-static int do_expire_wait(struct dentry *dentry, bool rcu_walk)
+static int do_expire_wait(struct path *path, bool rcu_walk)
 {
+	struct dentry *dentry = path->dentry;
 	struct dentry *expiring;
 
 	expiring = autofs4_lookup_expiring(dentry, rcu_walk);
 	if (IS_ERR(expiring))
 		return PTR_ERR(expiring);
 	if (!expiring)
-		return autofs4_expire_wait(dentry, rcu_walk);
+		return autofs4_expire_wait(path, rcu_walk);
 	else {
+		struct path this = { .mnt = path->mnt, .dentry = expiring };
 		/*
 		 * If we are racing with expire the request might not
 		 * be quite complete, but the directory has been removed
 		 * so it must have been successful, just wait for it.
 		 */
-		autofs4_expire_wait(expiring, 0);
+		autofs4_expire_wait(&this, 0);
 		autofs4_del_expiring(expiring);
 		dput(expiring);
 	}
@@ -354,7 +356,7 @@ static struct vfsmount *autofs4_d_automo
 	 * and the directory was removed, so just go ahead and try
 	 * the mount.
 	 */
-	status = do_expire_wait(dentry, 0);
+	status = do_expire_wait(path, 0);
 	if (status && status != -EAGAIN)
 		return NULL;
 
@@ -438,7 +440,7 @@ static int autofs4_d_manage(struct path
 	}
 
 	/* Wait for pending expires */
-	if (do_expire_wait(dentry, rcu_walk) == -ECHILD)
+	if (do_expire_wait(path, rcu_walk) == -ECHILD)
 		return -ECHILD;
 
 	/*
_

Patches currently in -mm which might be from ikent@redhat.com are

vfs-change-d_manage-to-take-a-struct-path.patch
vfs-add-path_is_mountpoint-helper.patch
vfs-add-path_has_submounts.patch
autofs-change-autofs4_expire_wait-to-take-struct-path.patch
autofs-change-autofs4_wait-to-take-struct-path.patch
autofs-use-path_is_mountpoint-to-fix-unreliable-d_mountpoint-checks.patch
autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks.patch
vfs-remove-unused-have_submounts-function.patch


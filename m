From: akpm@linux-foundation.org
Subject: + autofs-change-autofs4_wait-to-take-struct-path.patch added to
 -mm tree
Date: Wed, 19 Oct 2016 12:40:50 -0700
Message-ID: <5807cc42.B9mng8F6cIJaFCKT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941037AbcJSTkv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 15:40:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: change autofs4_wait() to take struct path
has been added to the -mm tree.  Its filename is
     autofs-change-autofs4_wait-to-take-struct-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-change-autofs4_wait-to-take-struct-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-change-autofs4_wait-to-take-struct-path.patch

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
Subject: autofs: change autofs4_wait() to take struct path

In order to use the functions path_is_mountpoint() (or its rcu-walk
variant) and path_has_submounts() autofs needs to pass a struct path in
several places.

Now change autofs4_wait() to take a struct path instead of a struct
dentry.

Link: http://lkml.kernel.org/r/20161011053413.27645.84666.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    2 +-
 fs/autofs4/expire.c   |    5 +++--
 fs/autofs4/root.c     |   16 ++++++++--------
 fs/autofs4/waitq.c    |    3 ++-
 4 files changed, 14 insertions(+), 12 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs-change-autofs4_wait-to-take-struct-path fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs-change-autofs4_wait-to-take-struct-path
+++ a/fs/autofs4/autofs_i.h
@@ -217,7 +217,7 @@ static inline int autofs_prepare_pipe(st
 
 /* Queue management functions */
 
-int autofs4_wait(struct autofs_sb_info *, struct dentry *, enum autofs_notify);
+int autofs4_wait(struct autofs_sb_info *, struct path *, enum autofs_notify);
 int autofs4_wait_release(struct autofs_sb_info *, autofs_wqt_t, int);
 void autofs4_catatonic_mode(struct autofs_sb_info *);
 
diff -puN fs/autofs4/expire.c~autofs-change-autofs4_wait-to-take-struct-path fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs-change-autofs4_wait-to-take-struct-path
+++ a/fs/autofs4/expire.c
@@ -526,7 +526,7 @@ retry:
 
 		pr_debug("waiting for expire %p name=%pd\n", dentry, dentry);
 
-		status = autofs4_wait(sbi, dentry, NFY_NONE);
+		status = autofs4_wait(sbi, path, NFY_NONE);
 		wait_for_completion(&ino->expire_complete);
 
 		pr_debug("expire done status=%d\n", status);
@@ -593,11 +593,12 @@ int autofs4_do_expire_multi(struct super
 
 	if (dentry) {
 		struct autofs_info *ino = autofs4_dentry_ino(dentry);
+		struct path path = { .mnt = mnt, .dentry = dentry };
 
 		/* This is synchronous because it makes the daemon a
 		 * little easier
 		 */
-		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
+		ret = autofs4_wait(sbi, &path, NFY_EXPIRE);
 
 		spin_lock(&sbi->fs_lock);
 		/* avoid rapid-fire expire attempts if expiry fails */
diff -puN fs/autofs4/root.c~autofs-change-autofs4_wait-to-take-struct-path fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-change-autofs4_wait-to-take-struct-path
+++ a/fs/autofs4/root.c
@@ -269,17 +269,17 @@ next:
 	return NULL;
 }
 
-static int autofs4_mount_wait(struct dentry *dentry, bool rcu_walk)
+static int autofs4_mount_wait(struct path *path, bool rcu_walk)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs4_sbi(path->dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(path->dentry);
 	int status = 0;
 
 	if (ino->flags & AUTOFS_INF_PENDING) {
 		if (rcu_walk)
 			return -ECHILD;
-		pr_debug("waiting for mount name=%pd\n", dentry);
-		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
+		pr_debug("waiting for mount name=%pd\n", path->dentry);
+		status = autofs4_wait(sbi, path, NFY_MOUNT);
 		pr_debug("mount wait done status=%d\n", status);
 	}
 	ino->last_used = jiffies;
@@ -364,7 +364,7 @@ static struct vfsmount *autofs4_d_automo
 	spin_lock(&sbi->fs_lock);
 	if (ino->flags & AUTOFS_INF_PENDING) {
 		spin_unlock(&sbi->fs_lock);
-		status = autofs4_mount_wait(dentry, 0);
+		status = autofs4_mount_wait(path, 0);
 		if (status)
 			return ERR_PTR(status);
 		goto done;
@@ -405,7 +405,7 @@ static struct vfsmount *autofs4_d_automo
 		}
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
-		status = autofs4_mount_wait(dentry, 0);
+		status = autofs4_mount_wait(path, 0);
 		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_PENDING;
 		if (status) {
@@ -447,7 +447,7 @@ static int autofs4_d_manage(struct path
 	 * This dentry may be under construction so wait on mount
 	 * completion.
 	 */
-	status = autofs4_mount_wait(dentry, rcu_walk);
+	status = autofs4_mount_wait(path, rcu_walk);
 	if (status)
 		return status;
 
diff -puN fs/autofs4/waitq.c~autofs-change-autofs4_wait-to-take-struct-path fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs-change-autofs4_wait-to-take-struct-path
+++ a/fs/autofs4/waitq.c
@@ -345,8 +345,9 @@ static int validate_request(struct autof
 }
 
 int autofs4_wait(struct autofs_sb_info *sbi,
-		 struct dentry *dentry, enum autofs_notify notify)
+		 struct path *path, enum autofs_notify notify)
 {
+	struct dentry *dentry = path->dentry;
 	struct autofs_wait_queue *wq;
 	struct qstr qstr;
 	char *name;
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


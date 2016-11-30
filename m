From: akpm@linux-foundation.org
Subject: +
 autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait.patch added to -mm tree
Date: Wed, 30 Nov 2016 14:25:37 -0800
Message-ID: <583f51e1.ICp9UFCtzrxb1sPt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35866 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754354AbcK3W0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 17:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: change struct path to const in autofs4_expire_wait() and autofs4_wait()
has been added to the -mm tree.  Its filename is
     autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait.patch

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
Subject: autofs: change struct path to const in autofs4_expire_wait() and autofs4_wait()

The functions autofs4_expire_wait() and autofs4_wait() don't modify
the passed struct path so change it to a const.

Link: http://lkml.kernel.org/r/148029911911.27779.6329959807249612394.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    5 +++--
 fs/autofs4/expire.c   |    4 ++--
 fs/autofs4/root.c     |    6 +++---
 fs/autofs4/waitq.c    |    4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait
+++ a/fs/autofs4/autofs_i.h
@@ -145,7 +145,7 @@ void autofs4_free_ino(struct autofs_info
 
 /* Expiration */
 int is_autofs4_dentry(struct dentry *);
-int autofs4_expire_wait(struct path *path, int rcu_walk);
+int autofs4_expire_wait(const struct path *path, int rcu_walk);
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
 		       struct autofs_sb_info *,
 		       struct autofs_packet_expire __user *);
@@ -217,7 +217,8 @@ static inline int autofs_prepare_pipe(st
 
 /* Queue management functions */
 
-int autofs4_wait(struct autofs_sb_info *, struct path *, enum autofs_notify);
+int autofs4_wait(struct autofs_sb_info *,
+		 const struct path *, enum autofs_notify);
 int autofs4_wait_release(struct autofs_sb_info *, autofs_wqt_t, int);
 void autofs4_catatonic_mode(struct autofs_sb_info *);
 
diff -puN fs/autofs4/expire.c~autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait
+++ a/fs/autofs4/expire.c
@@ -495,7 +495,7 @@ found:
 	return expired;
 }
 
-int autofs4_expire_wait(struct path *path, int rcu_walk)
+int autofs4_expire_wait(const struct path *path, int rcu_walk)
 {
 	struct dentry *dentry = path->dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
@@ -593,7 +593,7 @@ int autofs4_do_expire_multi(struct super
 
 	if (dentry) {
 		struct autofs_info *ino = autofs4_dentry_ino(dentry);
-		struct path path = { .mnt = mnt, .dentry = dentry };
+		const struct path path = { .mnt = mnt, .dentry = dentry };
 
 		/* This is synchronous because it makes the daemon a
 		 * little easier
diff -puN fs/autofs4/root.c~autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait
+++ a/fs/autofs4/root.c
@@ -272,7 +272,7 @@ next:
 	return NULL;
 }
 
-static int autofs4_mount_wait(struct path *path, bool rcu_walk)
+static int autofs4_mount_wait(const struct path *path, bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(path->dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(path->dentry);
@@ -289,7 +289,7 @@ static int autofs4_mount_wait(struct pat
 	return status;
 }
 
-static int do_expire_wait(struct path *path, bool rcu_walk)
+static int do_expire_wait(const struct path *path, bool rcu_walk)
 {
 	struct dentry *dentry = path->dentry;
 	struct dentry *expiring;
@@ -300,7 +300,7 @@ static int do_expire_wait(struct path *p
 	if (!expiring)
 		return autofs4_expire_wait(path, rcu_walk);
 	else {
-		struct path this = { .mnt = path->mnt, .dentry = expiring };
+		const struct path this = { .mnt = path->mnt, .dentry = expiring };
 		/*
 		 * If we are racing with expire the request might not
 		 * be quite complete, but the directory has been removed
diff -puN fs/autofs4/waitq.c~autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait
+++ a/fs/autofs4/waitq.c
@@ -250,7 +250,7 @@ autofs4_find_wait(struct autofs_sb_info
 static int validate_request(struct autofs_wait_queue **wait,
 			    struct autofs_sb_info *sbi,
 			    const struct qstr *qstr,
-			    struct path *path, enum autofs_notify notify)
+			    const struct path *path, enum autofs_notify notify)
 {
 	struct dentry *dentry = path->dentry;
 	struct autofs_wait_queue *wq;
@@ -349,7 +349,7 @@ static int validate_request(struct autof
 }
 
 int autofs4_wait(struct autofs_sb_info *sbi,
-		 struct path *path, enum autofs_notify notify)
+		 const struct path *path, enum autofs_notify notify)
 {
 	struct dentry *dentry = path->dentry;
 	struct autofs_wait_queue *wq;
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
vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu.patch
autofs-make-struct-path-const-in-autofs4_dir_open.patch
autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait.patch
vfs-change-struct-path-to-const-in-d_manage.patch
vfs-constify-path-parameter-of-path_has_submounts.patch
autofs-dont-hold-spin-lock-over-direct-mount-expire.patch
vfs-make-may_umount_tree-mount-propogation-aware.patch


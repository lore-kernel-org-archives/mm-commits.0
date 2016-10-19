From: akpm@linux-foundation.org
Subject: +
 autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks.patch
 added to -mm tree
Date: Wed, 19 Oct 2016 12:40:54 -0700
Message-ID: <5807cc46./zERjR9Adp3b80QR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60725 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941037AbcJSTkz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 15:40:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: use path_has_submounts() to fix unreliable have_submount() checks
has been added to the -mm tree.  Its filename is
     autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks.patch

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
Subject: autofs: use path_has_submounts() to fix unreliable have_submount() checks

If an automount mount is clone(2)ed into a file system that is propagation
private, when it later expires in the originating namespace, subsequent
calls to autofs ->d_automount() for that dentry in the original namespace
will return ELOOP until the mount is umounted in the cloned namespace.

Now that a struct path is available where needed use path_has_submounts()
instead of have_submounts() so we don't get false positives when checking
if a dentry is a mount point or contains mounts in the current namespace.

Link: http://lkml.kernel.org/r/20161011053423.27645.91233.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    2 +-
 fs/autofs4/root.c      |   14 +++++++-------
 fs/autofs4/waitq.c     |   10 +++++++---
 3 files changed, 15 insertions(+), 11 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks
+++ a/fs/autofs4/dev-ioctl.c
@@ -575,7 +575,7 @@ static int autofs_dev_ioctl_ismountpoint
 
 		devid = new_encode_dev(dev);
 
-		err = have_submounts(path.dentry);
+		err = path_has_submounts(&path);
 
 		if (follow_down_one(&path))
 			magic = path.dentry->d_sb->s_magic;
diff -puN fs/autofs4/root.c~autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks
+++ a/fs/autofs4/root.c
@@ -387,16 +387,16 @@ static struct vfsmount *autofs4_d_automo
 		/*
 		 * It's possible that user space hasn't removed directories
 		 * after umounting a rootless multi-mount, although it
-		 * should. For v5 have_submounts() is sufficient to handle
-		 * this because the leaves of the directory tree under the
-		 * mount never trigger mounts themselves (they have an autofs
-		 * trigger mount mounted on them). But v4 pseudo direct mounts
-		 * do need the leaves to trigger mounts. In this case we
-		 * have no choice but to use the list_empty() check and
+		 * should. For v5 path_has_submounts() is sufficient to
+		 * handle this because the leaves of the directory tree under
+		 * the mount never trigger mounts themselves (they have an
+		 * autofs trigger mount mounted on them). But v4 pseudo direct
+		 * mounts do need the leaves to trigger mounts. In this case
+		 * we have no choice but to use the list_empty() check and
 		 * require user space behave.
 		 */
 		if (sbi->version > 4) {
-			if (have_submounts(dentry)) {
+			if (path_has_submounts(path)) {
 				spin_unlock(&sbi->fs_lock);
 				goto done;
 			}
diff -puN fs/autofs4/waitq.c~autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks
+++ a/fs/autofs4/waitq.c
@@ -250,8 +250,9 @@ autofs4_find_wait(struct autofs_sb_info
 static int validate_request(struct autofs_wait_queue **wait,
 			    struct autofs_sb_info *sbi,
 			    const struct qstr *qstr,
-			    struct dentry *dentry, enum autofs_notify notify)
+			    struct path *path, enum autofs_notify notify)
 {
+	struct dentry *dentry = path->dentry;
 	struct autofs_wait_queue *wq;
 	struct autofs_info *ino;
 
@@ -314,6 +315,7 @@ static int validate_request(struct autof
 	 */
 	if (notify == NFY_MOUNT) {
 		struct dentry *new = NULL;
+		struct path this;
 		int valid = 1;
 
 		/*
@@ -333,7 +335,9 @@ static int validate_request(struct autof
 					dentry = new;
 			}
 		}
-		if (have_submounts(dentry))
+		this.mnt = path->mnt;
+		this.dentry = dentry;
+		if (path_has_submounts(&this))
 			valid = 0;
 
 		if (new)
@@ -406,7 +410,7 @@ int autofs4_wait(struct autofs_sb_info *
 		return -EINTR;
 	}
 
-	ret = validate_request(&wq, sbi, &qstr, dentry, notify);
+	ret = validate_request(&wq, sbi, &qstr, path, notify);
 	if (ret <= 0) {
 		if (ret != -EINTR)
 			mutex_unlock(&sbi->wq_mutex);
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


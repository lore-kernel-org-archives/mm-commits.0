From: akpm@linux-foundation.org
Subject: + autofs-make-mountpoint-checks-namespace-aware.patch added to
 -mm tree
Date: Wed, 14 Sep 2016 15:38:42 -0700
Message-ID: <57d9d172.c+NZpD5ANoLHazTa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756435AbcINWin (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2016 18:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, ebiederm@xmission.com, osandov@osandov.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: make mountpoint checks namespace aware
has been added to the -mm tree.  Its filename is
     autofs-make-mountpoint-checks-namespace-aware.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-make-mountpoint-checks-namespace-aware.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-make-mountpoint-checks-namespace-aware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: make mountpoint checks namespace aware

If an automount mount is clone(2)ed into a file system that is propagation
private, when it later expires in the originating namespace subsequent
calls to autofs ->d_automount() for that dentry in the original namespace
will return ELOOP until the mount is manually umounted in the cloned
namespace.

In the same way, if an autofs mount is triggered by automount(8) running
within a container the dentry will be seen as mounted in the root init
namespace and calls to ->d_automount() in that namespace will return ELOOP
until the mount is umounted within the container.

Also, have_submounts() can return an incorect result when a mount exists
in a namespace other than the one being checked.

Link: http://lkml.kernel.org/r/20160914061445.24714.68331.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    2 +-
 fs/autofs4/expire.c    |    4 ++--
 fs/autofs4/root.c      |   30 +++++++++++++++---------------
 fs/autofs4/waitq.c     |    2 +-
 4 files changed, 19 insertions(+), 19 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-make-mountpoint-checks-namespace-aware fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-make-mountpoint-checks-namespace-aware
+++ a/fs/autofs4/dev-ioctl.c
@@ -575,7 +575,7 @@ static int autofs_dev_ioctl_ismountpoint
 
 		devid = new_encode_dev(dev);
 
-		err = have_submounts(path.dentry);
+		err = have_local_submounts(path.dentry);
 
 		if (follow_down_one(&path))
 			magic = path.dentry->d_sb->s_magic;
diff -puN fs/autofs4/expire.c~autofs-make-mountpoint-checks-namespace-aware fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs-make-mountpoint-checks-namespace-aware
+++ a/fs/autofs4/expire.c
@@ -236,7 +236,7 @@ static int autofs4_tree_busy(struct vfsm
 		 * count for the autofs dentry.
 		 * If the fs is busy update the expiry counter.
 		 */
-		if (d_mountpoint(p)) {
+		if (is_local_mountpoint(p)) {
 			if (autofs4_mount_busy(mnt, p)) {
 				top_ino->last_used = jiffies;
 				dput(p);
@@ -280,7 +280,7 @@ static struct dentry *autofs4_check_leav
 	while ((p = get_next_positive_dentry(p, parent))) {
 		pr_debug("dentry %p %pd\n", p, p);
 
-		if (d_mountpoint(p)) {
+		if (is_local_mountpoint(p)) {
 			/* Can we umount this guy */
 			if (autofs4_mount_busy(mnt, p))
 				continue;
diff -puN fs/autofs4/root.c~autofs-make-mountpoint-checks-namespace-aware fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-make-mountpoint-checks-namespace-aware
+++ a/fs/autofs4/root.c
@@ -123,7 +123,7 @@ static int autofs4_dir_open(struct inode
 	 * it.
 	 */
 	spin_lock(&sbi->lookup_lock);
-	if (!d_mountpoint(dentry) && simple_empty(dentry)) {
+	if (!is_local_mountpoint(dentry) && simple_empty(dentry)) {
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOENT;
 	}
@@ -370,28 +370,28 @@ static struct vfsmount *autofs4_d_automo
 
 	/*
 	 * If the dentry is a symlink it's equivalent to a directory
-	 * having d_mountpoint() true, so there's no need to call back
-	 * to the daemon.
+	 * having is_local_mountpoint() true, so there's no need to
+	 * call back to the daemon.
 	 */
 	if (d_really_is_positive(dentry) && d_is_symlink(dentry)) {
 		spin_unlock(&sbi->fs_lock);
 		goto done;
 	}
 
-	if (!d_mountpoint(dentry)) {
+	if (!is_local_mountpoint(dentry)) {
 		/*
 		 * It's possible that user space hasn't removed directories
 		 * after umounting a rootless multi-mount, although it
-		 * should. For v5 have_submounts() is sufficient to handle
-		 * this because the leaves of the directory tree under the
-		 * mount never trigger mounts themselves (they have an autofs
-		 * trigger mount mounted on them). But v4 pseudo direct mounts
-		 * do need the leaves to trigger mounts. In this case we
-		 * have no choice but to use the list_empty() check and
-		 * require user space behave.
+		 * should. For v5 have_local_submounts() is sufficient to
+		 * handle this because the leaves of the directory tree under
+		 * the mount never trigger mounts themselves (they have an
+		 * autofs trigger mount mounted on them). But v4 pseudo
+		 * direct mounts do need the leaves to trigger mounts. In
+		 * this case we have no choice but to use the list_empty()
+		 * check and require user space behave.
 		 */
 		if (sbi->version > 4) {
-			if (have_submounts(dentry)) {
+			if (have_local_submounts(dentry)) {
 				spin_unlock(&sbi->fs_lock);
 				goto done;
 			}
@@ -431,7 +431,7 @@ static int autofs4_d_manage(struct dentr
 
 	/* The daemon never waits. */
 	if (autofs4_oz_mode(sbi)) {
-		if (!d_mountpoint(dentry))
+		if (!is_local_mountpoint(dentry))
 			return -EISDIR;
 		return 0;
 	}
@@ -460,7 +460,7 @@ static int autofs4_d_manage(struct dentr
 
 		if (ino->flags & AUTOFS_INF_WANT_EXPIRE)
 			return 0;
-		if (d_mountpoint(dentry))
+		if (is_local_mountpoint(dentry))
 			return 0;
 		inode = d_inode_rcu(dentry);
 		if (inode && S_ISLNK(inode->i_mode))
@@ -487,7 +487,7 @@ static int autofs4_d_manage(struct dentr
 		 * we can avoid needless calls ->d_automount() and avoid
 		 * an incorrect ELOOP error return.
 		 */
-		if ((!d_mountpoint(dentry) && !simple_empty(dentry)) ||
+		if ((!is_local_mountpoint(dentry) && !simple_empty(dentry)) ||
 		    (d_really_is_positive(dentry) && d_is_symlink(dentry)))
 			status = -EISDIR;
 	}
diff -puN fs/autofs4/waitq.c~autofs-make-mountpoint-checks-namespace-aware fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs-make-mountpoint-checks-namespace-aware
+++ a/fs/autofs4/waitq.c
@@ -333,7 +333,7 @@ static int validate_request(struct autof
 					dentry = new;
 			}
 		}
-		if (have_submounts(dentry))
+		if (have_local_submounts(dentry))
 			valid = 0;
 
 		if (new)
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-use-dentry-flags-to-block-walks-during-expire.patch
autofs-fix-autofs4_fill_super-error-exit-handling.patch
autofs-remove-ino-free-in-autofs4_dir_symlink.patch
autofs-fix-dev-ioctl-number-range-check.patch
autofs-add-autofs_dev_ioctl_version-for-autofs_dev_ioctl_version_cmd.patch
autofs4-move-linux-auto_dev-ioctlh-to-uapi-linux.patch
fs-make-is_local_mountpoint-usable-by-others.patch
fs-add-have_local_submounts.patch
autofs-make-mountpoint-checks-namespace-aware.patch
fs-remove-unused-have_submounts-function.patch


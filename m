From: akpm@linux-foundation.org
Subject: +
 autofs-use-path_is_mountpoint-to-fix-unreliable-d_mountpoint-checks.patch
 added to -mm tree
Date: Wed, 19 Oct 2016 12:40:52 -0700
Message-ID: <5807cc44.xusiRixb2w9i9em/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60723 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942983AbcJSTkx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 15:40:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: use path_is_mountpoint() to fix unreliable d_mountpoint() checks
has been added to the -mm tree.  Its filename is
     autofs-use-path_is_mountpoint-to-fix-unreliable-d_mountpoint-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-use-path_is_mountpoint-to-fix-unreliable-d_mountpoint-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-use-path_is_mountpoint-to-fix-unreliable-d_mountpoint-checks.patch

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
Subject: autofs: use path_is_mountpoint() to fix unreliable d_mountpoint() checks

If an automount mount is clone(2)ed into a file system that is propagation
private, when it later expires in the originating namespace, subsequent
calls to autofs ->d_automount() for that dentry in the original namespace
will return ELOOP until the mount is umounted in the cloned namespace.

Now that a struct path is available where needed use path_is_mountpoint()
instead of d_mountpoint() so we don't get false positives when checking if
a dentry is a mount point in the current namespace.

Link: http://lkml.kernel.org/r/20161011053418.27645.15241.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN fs/autofs4/root.c~autofs-use-path_is_mountpoint-to-fix-unreliable-d_mountpoint-checks fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-use-path_is_mountpoint-to-fix-unreliable-d_mountpoint-checks
+++ a/fs/autofs4/root.c
@@ -107,12 +107,15 @@ static int autofs4_dir_open(struct inode
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct path path;
 
 	pr_debug("file=%p dentry=%p %pd\n", file, dentry, dentry);
 
 	if (autofs4_oz_mode(sbi))
 		goto out;
 
+	path = file->f_path;
+
 	/*
 	 * An empty directory in an autofs file system is always a
 	 * mount point. The daemon must have failed to mount this
@@ -123,7 +126,7 @@ static int autofs4_dir_open(struct inode
 	 * it.
 	 */
 	spin_lock(&sbi->lookup_lock);
-	if (!d_mountpoint(dentry) && simple_empty(dentry)) {
+	if (!path_is_mountpoint(&path) && simple_empty(dentry)) {
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOENT;
 	}
@@ -372,15 +375,15 @@ static struct vfsmount *autofs4_d_automo
 
 	/*
 	 * If the dentry is a symlink it's equivalent to a directory
-	 * having d_mountpoint() true, so there's no need to call back
-	 * to the daemon.
+	 * having path_is_mountpoint() true, so there's no need to call
+	 * back to the daemon.
 	 */
 	if (d_really_is_positive(dentry) && d_is_symlink(dentry)) {
 		spin_unlock(&sbi->fs_lock);
 		goto done;
 	}
 
-	if (!d_mountpoint(dentry)) {
+	if (!path_is_mountpoint(path)) {
 		/*
 		 * It's possible that user space hasn't removed directories
 		 * after umounting a rootless multi-mount, although it
@@ -434,8 +437,13 @@ static int autofs4_d_manage(struct path
 
 	/* The daemon never waits. */
 	if (autofs4_oz_mode(sbi)) {
-		if (!d_mountpoint(dentry))
-			return -EISDIR;
+		if (rcu_walk) {
+			if (!path_is_mountpoint_rcu(path))
+				return -EISDIR;
+		} else {
+			if (!path_is_mountpoint(path))
+				return -EISDIR;
+		}
 		return 0;
 	}
 
@@ -463,7 +471,7 @@ static int autofs4_d_manage(struct path
 
 		if (ino->flags & AUTOFS_INF_WANT_EXPIRE)
 			return 0;
-		if (d_mountpoint(dentry))
+		if (path_is_mountpoint_rcu(path))
 			return 0;
 		inode = d_inode_rcu(dentry);
 		if (inode && S_ISLNK(inode->i_mode))
@@ -490,7 +498,7 @@ static int autofs4_d_manage(struct path
 		 * we can avoid needless calls ->d_automount() and avoid
 		 * an incorrect ELOOP error return.
 		 */
-		if ((!d_mountpoint(dentry) && !simple_empty(dentry)) ||
+		if ((!path_is_mountpoint(path) && !simple_empty(dentry)) ||
 		    (d_really_is_positive(dentry) && d_is_symlink(dentry)))
 			status = -EISDIR;
 	}
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


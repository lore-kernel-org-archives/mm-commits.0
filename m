From: akpm@linux-foundation.org
Subject: + autofs-make-struct-path-const-in-autofs4_dir_open.patch added
 to -mm tree
Date: Wed, 30 Nov 2016 14:25:35 -0800
Message-ID: <583f51df.xhO1BlRq5kcyzYl0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751631AbcK3W0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 17:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: make struct path const in autofs4_dir_open()
has been added to the -mm tree.  Its filename is
     autofs-make-struct-path-const-in-autofs4_dir_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-make-struct-path-const-in-autofs4_dir_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-make-struct-path-const-in-autofs4_dir_open.patch

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
Subject: autofs: make struct path const in autofs4_dir_open()

There's no reason to copy the file->f_path in autofs4_dir_open() and
f_path is not modified so change it to a "const struct path *".

Link: http://lkml.kernel.org/r/148029911386.27779.14131036159082881283.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/autofs4/root.c~autofs-make-struct-path-const-in-autofs4_dir_open fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-make-struct-path-const-in-autofs4_dir_open
+++ a/fs/autofs4/root.c
@@ -107,14 +107,14 @@ static int autofs4_dir_open(struct inode
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct path path;
+	const struct path *path;
 
 	pr_debug("file=%p dentry=%p %pd\n", file, dentry, dentry);
 
 	if (autofs4_oz_mode(sbi))
 		goto out;
 
-	path = file->f_path;
+	path = &file->f_path;
 
 	/*
 	 * An empty directory in an autofs file system is always a
@@ -126,7 +126,7 @@ static int autofs4_dir_open(struct inode
 	 * it.
 	 */
 	spin_lock(&sbi->lookup_lock);
-	if (!path_is_mountpoint(&path) && simple_empty(dentry)) {
+	if (!path_is_mountpoint(path) && simple_empty(dentry)) {
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOENT;
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
vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu.patch
autofs-make-struct-path-const-in-autofs4_dir_open.patch
autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait.patch
vfs-change-struct-path-to-const-in-d_manage.patch
vfs-constify-path-parameter-of-path_has_submounts.patch
autofs-dont-hold-spin-lock-over-direct-mount-expire.patch
vfs-make-may_umount_tree-mount-propogation-aware.patch


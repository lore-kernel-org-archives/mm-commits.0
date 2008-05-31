From: akpm@linux-foundation.org
Subject: + cgroup-dont-call-vfs_mkdir.patch added to -mm tree
Date: Fri, 30 May 2008 17:13:03 -0700
Message-ID: <200805310013.m4V0D41Q018526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbYEaANY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:13:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, balbir@in.ibm.com, hch@lst.de, menage@google.com, viro@zeniv.linux.org.uk


The patch titled
     cgroup: dont call vfs_mkdir
has been added to the -mm tree.  Its filename is
     cgroup-dont-call-vfs_mkdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: dont call vfs_mkdir
From: Miklos Szeredi <mszeredi@suse.cz>

cgroup_clone() calls vfs_mkdir() to create a directory in the cgroup
filesystem.  Replace with explicit call to cgroup_mkdir() and
fsnotify_mkdir().

This is equivalent, except that the following functions are not called
before cgroup_mkdir():

 - may_create()
 - security_inode_mkdir()
 - DQUOT_INIT()

Permission to clone the cgroup has already been checked in
copy_namespaces() (requiring CAP_SYS_ADMIN).  Additional file system
related capability checks are inappropriate and confusing.

The quota check is unnecessary, as quotas don't make any sense for
this filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Paul Menage <menage@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-dont-call-vfs_mkdir kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-dont-call-vfs_mkdir
+++ a/kernel/cgroup.c
@@ -25,6 +25,7 @@
 #include <linux/cgroup.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/fsnotify.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
@@ -2930,7 +2931,9 @@ int cgroup_clone(struct task_struct *tsk
 	}
 
 	/* Create the cgroup directory, which also creates the cgroup */
-	ret = vfs_mkdir(inode, dentry, S_IFDIR | 0755);
+	ret = cgroup_mkdir(inode, dentry, S_IFDIR);
+	if (!ret)
+		fsnotify_mkdir(inode, dentry);
 	child = __d_cgrp(dentry);
 	dput(dentry);
 	if (ret) {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch
nfsd-clean-up-mnt_want_write-calls.patch
cgroup-dont-call-vfs_mkdir.patch
reiserfs-dont-call-vfs_rmdir.patch
reiserfs-dont-call-notify_change.patch
sysfs-dont-call-notify_change.patch
hpfs-dont-call-notify_change.patch
fat-dont-call-notify_change.patch
hpfs-dont-call-permission.patch
hppfs-remove-hppfs_permission.patch
gfs2-dont-call-permission.patch
vfs-immutable-inode-checking-cleanup.patch
vfs-truncate-dont-check-immutable-twice.patch
vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch


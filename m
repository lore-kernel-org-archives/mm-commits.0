From: akpm@linux-foundation.org
Subject: + fs-remove-unused-have_submounts-function.patch added to -mm
 tree
Date: Wed, 14 Sep 2016 15:38:45 -0700
Message-ID: <57d9d175.dVxkjDWE3E5BtbnM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43533 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755229AbcINWiq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2016 18:38:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, ebiederm@xmission.com, osandov@osandov.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: remove unused have_submounts() function
has been added to the -mm tree.  Its filename is
     fs-remove-unused-have_submounts-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-remove-unused-have_submounts-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-remove-unused-have_submounts-function.patch

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
Subject: fs: remove unused have_submounts() function

Having added the have_local_submounts() function there are no remaining
users of have_submounts() so remove it.

Link: http://lkml.kernel.org/r/20160914061450.24714.99912.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |   33 ---------------------------------
 include/linux/dcache.h |    1 -
 2 files changed, 34 deletions(-)

diff -puN fs/dcache.c~fs-remove-unused-have_submounts-function fs/dcache.c
--- a/fs/dcache.c~fs-remove-unused-have_submounts-function
+++ a/fs/dcache.c
@@ -1279,39 +1279,6 @@ rename_retry:
  * list is non-empty and continue searching.
  */
 
-static enum d_walk_ret check_mount(void *data, struct dentry *dentry)
-{
-	int *ret = data;
-	if (d_mountpoint(dentry)) {
-		*ret = 1;
-		return D_WALK_QUIT;
-	}
-	return D_WALK_CONTINUE;
-}
-
-/**
- * have_submounts - check for mounts over a dentry
- * @parent: dentry to check.
- *
- * Return true if the parent or its subdirectories contain
- * a mount point
- */
-int have_submounts(struct dentry *parent)
-{
-	int ret = 0;
-
-	d_walk(parent, &ret, check_mount, NULL);
-
-	return ret;
-}
-EXPORT_SYMBOL(have_submounts);
-
-/*
- * Search for at least 1 mount point in the dentry's subdirs.
- * We descend to the next level whenever the d_subdirs
- * list is non-empty and continue searching.
- */
-
 static enum d_walk_ret check_local_mount(void *data, struct dentry *dentry)
 {
 	int *ret = data;
diff -puN include/linux/dcache.h~fs-remove-unused-have_submounts-function include/linux/dcache.h
--- a/include/linux/dcache.h~fs-remove-unused-have_submounts-function
+++ a/include/linux/dcache.h
@@ -254,7 +254,6 @@ extern struct dentry *d_find_alias(struc
 extern void d_prune_aliases(struct inode *);
 
 /* test whether we have any submounts in a subdir tree */
-extern int have_submounts(struct dentry *);
 extern int have_local_submounts(struct dentry *);
 
 /*
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


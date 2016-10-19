From: akpm@linux-foundation.org
Subject: + vfs-remove-unused-have_submounts-function.patch added to -mm
 tree
Date: Wed, 19 Oct 2016 12:40:56 -0700
Message-ID: <5807cc48.VWbg5PC0+1cgsS5M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945199AbcJSTk5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 15:40:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: remove unused have_submounts() function
has been added to the -mm tree.  Its filename is
     vfs-remove-unused-have_submounts-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-remove-unused-have_submounts-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-remove-unused-have_submounts-function.patch

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
Subject: vfs: remove unused have_submounts() function

Now that path_has_submounts() has been added have_submounts() is no
longer used so remove it.

Link: http://lkml.kernel.org/r/20161011053428.27645.12310.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |   33 ---------------------------------
 include/linux/dcache.h |    1 -
 2 files changed, 34 deletions(-)

diff -puN fs/dcache.c~vfs-remove-unused-have_submounts-function fs/dcache.c
--- a/fs/dcache.c~vfs-remove-unused-have_submounts-function
+++ a/fs/dcache.c
@@ -1273,39 +1273,6 @@ rename_retry:
 	goto again;
 }
 
-/*
- * Search for at least 1 mount point in the dentry's subdirs.
- * We descend to the next level whenever the d_subdirs
- * list is non-empty and continue searching.
- */
-
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
 struct check_mount {
 	struct vfsmount *mnt;
 	unsigned int mounted;
diff -puN include/linux/dcache.h~vfs-remove-unused-have_submounts-function include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-remove-unused-have_submounts-function
+++ a/include/linux/dcache.h
@@ -254,7 +254,6 @@ extern struct dentry *d_find_alias(struc
 extern void d_prune_aliases(struct inode *);
 
 /* test whether we have any submounts in a subdir tree */
-extern int have_submounts(struct dentry *);
 extern int path_has_submounts(struct path *);
 
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


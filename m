From: akpm@linux-foundation.org
Subject: + vfs-constify-path-parameter-of-path_has_submounts.patch added
 to -mm tree
Date: Wed, 30 Nov 2016 14:25:42 -0800
Message-ID: <583f51e6.Ofa+yrmquBRLshN1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754830AbcK3W0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 17:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: constify path parameter of path_has_submounts()
has been added to the -mm tree.  Its filename is
     vfs-constify-path-parameter-of-path_has_submounts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-constify-path-parameter-of-path_has_submounts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-constify-path-parameter-of-path_has_submounts.patch

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
Subject: vfs: constify path parameter of path_has_submounts()

path_has_submounts() doesn't modify the passed in path parameter,
and shouldn't need to, make that usage explicit.

Link: http://lkml.kernel.org/r/148029912941.27779.3775940087450770440.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |    2 +-
 include/linux/dcache.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~vfs-constify-path-parameter-of-path_has_submounts fs/dcache.c
--- a/fs/dcache.c~vfs-constify-path-parameter-of-path_has_submounts
+++ a/fs/dcache.c
@@ -1298,7 +1298,7 @@ static enum d_walk_ret path_check_mount(
  * Return true if the parent or its subdirectories contain
  * a mount point in the current namespace.
  */
-int path_has_submounts(struct path *parent)
+int path_has_submounts(const struct path *parent)
 {
 	struct check_mount data = { .mnt = parent->mnt, .mounted = 0 };
 
diff -puN include/linux/dcache.h~vfs-constify-path-parameter-of-path_has_submounts include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-constify-path-parameter-of-path_has_submounts
+++ a/include/linux/dcache.h
@@ -254,7 +254,7 @@ extern struct dentry *d_find_alias(struc
 extern void d_prune_aliases(struct inode *);
 
 /* test whether we have any submounts in a subdir tree */
-extern int path_has_submounts(struct path *);
+extern int path_has_submounts(const struct path *);
 
 /*
  * This adds the entry to the hash queues.
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


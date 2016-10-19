From: akpm@linux-foundation.org
Subject: + vfs-add-path_has_submounts.patch added to -mm tree
Date: Wed, 19 Oct 2016 12:40:46 -0700
Message-ID: <5807cc3e.x+A2nm9dcXAnIW36%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941037AbcJSTkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 15:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: add path_has_submounts()
has been added to the -mm tree.  Its filename is
     vfs-add-path_has_submounts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-add-path_has_submounts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-add-path_has_submounts.patch

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
Subject: vfs: add path_has_submounts()

d_mountpoint() can only be used reliably to establish if a dentry is
not mounted in any namespace. It isn't aware of the possibility there
may be multiple mounts using the given dentry, possibly in a different
namespace.

Add function, path_has_submounts(), that checks is a struct path contains
mounts (or is a mountpoint itself) to handle this case.

Link: http://lkml.kernel.org/r/20161011053403.27645.55242.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |   35 +++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    1 +
 2 files changed, 36 insertions(+)

diff -puN fs/dcache.c~vfs-add-path_has_submounts fs/dcache.c
--- a/fs/dcache.c~vfs-add-path_has_submounts
+++ a/fs/dcache.c
@@ -1306,6 +1306,41 @@ int have_submounts(struct dentry *parent
 }
 EXPORT_SYMBOL(have_submounts);
 
+struct check_mount {
+	struct vfsmount *mnt;
+	unsigned int mounted;
+};
+
+static enum d_walk_ret path_check_mount(void *data, struct dentry *dentry)
+{
+	struct check_mount *info = data;
+	struct path path = { .mnt = info->mnt, .dentry = dentry };
+
+	if (path_is_mountpoint(&path)) {
+		info->mounted = 1;
+		return D_WALK_QUIT;
+	}
+	return D_WALK_CONTINUE;
+}
+
+/**
+ * path_has_submounts - check for mounts over a dentry in the
+ *                      current namespace.
+ * @parent: path to check.
+ *
+ * Return true if the parent or its subdirectories contain
+ * a mount point in the current namespace.
+ */
+int path_has_submounts(struct path *parent)
+{
+	struct check_mount data = { .mnt = parent->mnt, .mounted = 0 };
+
+	d_walk(parent->dentry, &data, path_check_mount, NULL);
+
+	return data.mounted;
+}
+EXPORT_SYMBOL(path_has_submounts);
+
 /*
  * Called by mount code to set a mountpoint and check if the mountpoint is
  * reachable (e.g. NFS can unhash a directory dentry and then the complete
diff -puN include/linux/dcache.h~vfs-add-path_has_submounts include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-add-path_has_submounts
+++ a/include/linux/dcache.h
@@ -255,6 +255,7 @@ extern void d_prune_aliases(struct inode
 
 /* test whether we have any submounts in a subdir tree */
 extern int have_submounts(struct dentry *);
+extern int path_has_submounts(struct path *);
 
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


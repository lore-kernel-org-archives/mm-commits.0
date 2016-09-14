From: akpm@linux-foundation.org
Subject: + fs-add-have_local_submounts.patch added to -mm tree
Date: Wed, 14 Sep 2016 15:38:40 -0700
Message-ID: <57d9d170.DurV30EWV3zIwWri%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43523 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756110AbcINWil (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2016 18:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, ebiederm@xmission.com, osandov@osandov.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: add have_local_submounts()
has been added to the -mm tree.  Its filename is
     fs-add-have_local_submounts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-add-have_local_submounts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-add-have_local_submounts.patch

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
Subject: vfs: add have_local_submounts()

have_submounts() checks if a dentry is a mountpoint in any namespace but
autofs needs to know if the dentry is a mountpoint within the current
namespace.

Add have_local_submounts() to to do this.

Link: http://lkml.kernel.org/r/20160914061440.24714.82139.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |   34 ++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    1 +
 2 files changed, 35 insertions(+)

diff -puN fs/dcache.c~fs-add-have_local_submounts fs/dcache.c
--- a/fs/dcache.c~fs-add-have_local_submounts
+++ a/fs/dcache.c
@@ -1307,6 +1307,40 @@ int have_submounts(struct dentry *parent
 EXPORT_SYMBOL(have_submounts);
 
 /*
+ * Search for at least 1 mount point in the dentry's subdirs.
+ * We descend to the next level whenever the d_subdirs
+ * list is non-empty and continue searching.
+ */
+
+static enum d_walk_ret check_local_mount(void *data, struct dentry *dentry)
+{
+	int *ret = data;
+	if (is_local_mountpoint(dentry)) {
+		*ret = 1;
+		return D_WALK_QUIT;
+	}
+	return D_WALK_CONTINUE;
+}
+
+/**
+ * have_local_submounts - check for mounts over a dentry
+ * 			  in the current namespace
+ * @parent: dentry to check.
+ *
+ * Return true if the parent or its subdirectories contain
+ * a mount point
+ */
+int have_local_submounts(struct dentry *parent)
+{
+	int ret = 0;
+
+	d_walk(parent, &ret, check_local_mount, NULL);
+
+	return ret;
+}
+EXPORT_SYMBOL(have_local_submounts);
+
+/*
  * Called by mount code to set a mountpoint and check if the mountpoint is
  * reachable (e.g. NFS can unhash a directory dentry and then the complete
  * subtree can become unreachable).
diff -puN include/linux/dcache.h~fs-add-have_local_submounts include/linux/dcache.h
--- a/include/linux/dcache.h~fs-add-have_local_submounts
+++ a/include/linux/dcache.h
@@ -255,6 +255,7 @@ extern void d_prune_aliases(struct inode
 
 /* test whether we have any submounts in a subdir tree */
 extern int have_submounts(struct dentry *);
+extern int have_local_submounts(struct dentry *);
 
 /*
  * This adds the entry to the hash queues.
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


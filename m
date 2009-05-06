From: akpm@linux-foundation.org
Subject: [merged] dcache-extrace-and-use-d_unlinked.patch removed from -mm tree
Date: Wed, 06 May 2009 13:47:36 -0700
Message-ID: <200905062047.n46Kla50011124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757717AbZEFUuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 16:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     dcache: extrace and use d_unlinked()
has been removed from the -mm tree.  Its filename was
     dcache-extrace-and-use-d_unlinked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dcache: extrace and use d_unlinked()
From: Alexey Dobriyan <adobriyan@gmail.com>

d_unlinked() will be used in middle-term to ban checkpointing when opened
but unlinked file is detected, and in long term, to detect such situation
and special case on it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |    7 +++----
 fs/namespace.c         |    8 ++++----
 include/linux/dcache.h |    5 +++++
 3 files changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/dcache.c~dcache-extrace-and-use-d_unlinked fs/dcache.c
--- a/fs/dcache.c~dcache-extrace-and-use-d_unlinked
+++ a/fs/dcache.c
@@ -1910,7 +1910,7 @@ char *__d_path(const struct path *path, 
 
 	spin_lock(&vfsmount_lock);
 	prepend(&end, &buflen, "\0", 1);
-	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
 
@@ -2035,7 +2035,7 @@ char *dentry_path(struct dentry *dentry,
 
 	spin_lock(&dcache_lock);
 	prepend(&end, &buflen, "\0", 1);
-	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, "//deleted", 9) != 0))
 			goto Elong;
 	if (buflen < 1)
@@ -2097,9 +2097,8 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	read_unlock(&current->fs->lock);
 
 	error = -ENOENT;
-	/* Has the current directory has been unlinked? */
 	spin_lock(&dcache_lock);
-	if (IS_ROOT(pwd.dentry) || !d_unhashed(pwd.dentry)) {
+	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
 		char * cwd;
diff -puN fs/namespace.c~dcache-extrace-and-use-d_unlinked fs/namespace.c
--- a/fs/namespace.c~dcache-extrace-and-use-d_unlinked
+++ a/fs/namespace.c
@@ -1415,7 +1415,7 @@ static int graft_tree(struct vfsmount *m
 		goto out_unlock;
 
 	err = -ENOENT;
-	if (IS_ROOT(path->dentry) || !d_unhashed(path->dentry))
+	if (!d_unlinked(path->dentry))
 		err = attach_recursive_mnt(mnt, path, NULL);
 out_unlock:
 	mutex_unlock(&path->dentry->d_inode->i_mutex);
@@ -1597,7 +1597,7 @@ static int do_move_mount(struct path *pa
 	if (IS_DEADDIR(path->dentry->d_inode))
 		goto out1;
 
-	if (!IS_ROOT(path->dentry) && d_unhashed(path->dentry))
+	if (d_unlinked(path->dentry))
 		goto out1;
 
 	err = -EINVAL;
@@ -2160,9 +2160,9 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	error = -ENOENT;
 	if (IS_DEADDIR(new.dentry->d_inode))
 		goto out2;
-	if (d_unhashed(new.dentry) && !IS_ROOT(new.dentry))
+	if (d_unlinked(new.dentry))
 		goto out2;
-	if (d_unhashed(old.dentry) && !IS_ROOT(old.dentry))
+	if (d_unlinked(old.dentry))
 		goto out2;
 	error = -EBUSY;
 	if (new.mnt == root.mnt ||
diff -puN include/linux/dcache.h~dcache-extrace-and-use-d_unlinked include/linux/dcache.h
--- a/include/linux/dcache.h~dcache-extrace-and-use-d_unlinked
+++ a/include/linux/dcache.h
@@ -351,6 +351,11 @@ static inline int d_unhashed(struct dent
 	return (dentry->d_flags & DCACHE_UNHASHED);
 }
 
+static inline int d_unlinked(struct dentry *dentry)
+{
+	return d_unhashed(dentry) && !IS_ROOT(dentry);
+}
+
 static inline struct dentry *dget_parent(struct dentry *dentry)
 {
 	struct dentry *ret;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch
nsproxy-extract-create_nsproxy.patch


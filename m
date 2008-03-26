From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-create-helper-to-drop-file-write-access.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:16 -0700
Message-ID: <200803261840.m2QIeGaa028647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760930AbYCZSkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, bfields@fieldses.org, ezk@cs.sunysb.edu, hch@lst.de, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: create helper to drop file write access
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-create-helper-to-drop-file-write-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: create helper to drop file write access
From: Dave Hansen <haveblue@us.ibm.com>

If someone decides to demote a file from r/w to just r/o, they can use this
same code as __fput().

NFS does just that, and will use this in the next patch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J Bruce Fields" <bfields@fieldses.org>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c      |   19 ++++++++++++++++++-
 fs/nfsd/nfs4state.c  |    3 ++-
 include/linux/file.h |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-create-helper-to-drop-file-write-access fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-create-helper-to-drop-file-write-access
+++ a/fs/file_table.c
@@ -211,6 +211,23 @@ void fput(struct file *file)
 
 EXPORT_SYMBOL(fput);
 
+/**
+ * drop_file_write_access - give up ability to write to a file
+ * @file: the file to which we will stop writing
+ *
+ * This is a central place which will give up the ability
+ * to write to @file, along with access to write through
+ * its vfsmount.
+ */
+void drop_file_write_access(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+
+	put_write_access(inode);
+}
+EXPORT_SYMBOL_GPL(drop_file_write_access);
+
 /* __fput is called from task context when aio completion releases the last
  * last use of a struct file *.  Do not use otherwise.
  */
@@ -237,7 +254,7 @@ void __fput(struct file *file)
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
 	if (file->f_mode & FMODE_WRITE)
-		put_write_access(inode);
+		drop_file_write_access(file);
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN fs/nfsd/nfs4state.c~r-o-bind-mounts-create-helper-to-drop-file-write-access fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~r-o-bind-mounts-create-helper-to-drop-file-write-access
+++ a/fs/nfsd/nfs4state.c
@@ -41,6 +41,7 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/cache.h>
+#include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/workqueue.h>
 #include <linux/smp_lock.h>
@@ -1239,7 +1240,7 @@ static inline void
 nfs4_file_downgrade(struct file *filp, unsigned int share_access)
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
-		put_write_access(filp->f_path.dentry->d_inode);
+		drop_file_write_access(filp);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
 	}
 }
diff -puN include/linux/file.h~r-o-bind-mounts-create-helper-to-drop-file-write-access include/linux/file.h
--- a/include/linux/file.h~r-o-bind-mounts-create-helper-to-drop-file-write-access
+++ a/include/linux/file.h
@@ -61,6 +61,7 @@ extern struct kmem_cache *filp_cachep;
 
 extern void __fput(struct file *);
 extern void fput(struct file *);
+extern void drop_file_write_access(struct file *file);
 
 struct file_operations;
 struct vfsmount;
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch


From: akpm@linux-foundation.org
Subject: - create-file_drop_write_access-helper.patch removed from -mm tree
Date: Thu, 14 Feb 2008 21:31:39 -0800
Message-ID: <200802150531.m1F5Vdd6021813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754023AbYBOFiq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 00:38:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, bfields@fieldses.org, ezk@cs.sunysb.edu, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     create file_drop_write_access() helper
has been removed from the -mm tree.  Its filename was
     create-file_drop_write_access-helper.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: create file_drop_write_access() helper
From: Dave Hansen <haveblue@us.ibm.com>

These should fix the bug that Erez Zadok <ezk@cs.sunysb.edu>
reported:

Stopping RPC idmapd:

kernel: __fput() of writeable file with no mnt_want_write()
kernel: WARNING: at fs/file_table.c:262 __fput()
kernel:  [<c010283e>] show_trace_log_lvl+0x12/0x25
kernel:  [<c0103042>] show_trace+0xd/0x10
...

The actual bug was a missed mnt_want_write() when a
filp was allocated with get_empty_filp() and then
made writable.  Using alloc_file(), instead, fixes
that.

--

If someone decides to demote a file from r/w to just
r/o, they can use this same code as __fput().

NFS does just that, and will use this in the next
patch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c      |   46 +++++++++++++++++++++++++++--------------
 include/linux/file.h |    1 
 2 files changed, 32 insertions(+), 15 deletions(-)

diff -puN fs/file_table.c~create-file_drop_write_access-helper fs/file_table.c
--- a/fs/file_table.c~create-file_drop_write_access-helper
+++ a/fs/file_table.c
@@ -223,6 +223,34 @@ void fput(struct file *file)
 
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
+	struct vfsmount *mnt = file->f_path.mnt;
+	struct inode *inode = dentry->d_inode;
+
+	put_write_access(inode);
+	if (!special_file(inode->i_mode)) {
+		if (file->f_mnt_write_state == FILE_MNT_WRITE_TAKEN) {
+			mnt_drop_write(mnt);
+			file->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
+		} else {
+			printk(KERN_WARNING "dropping write access on "
+					"file with no mnt_want_write()\n");
+			WARN_ON(1);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(drop_file_write_access);
+
 /* __fput is called from task context when aio completion releases the last
  * last use of a struct file *.  Do not use otherwise.
  */
@@ -248,21 +276,9 @@ void __fput(struct file *file)
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
-	if (file->f_mode & FMODE_WRITE) {
-		put_write_access(inode);
-		if (!special_file(inode->i_mode)) {
-			if (file->f_mnt_write_state == FILE_MNT_WRITE_TAKEN) {
-				mnt_drop_write(mnt);
-				file->f_mnt_write_state |=
-					FILE_MNT_WRITE_RELEASED;
-			} else {
-				printk(KERN_WARNING "__fput() of writeable "
-						"file with no "
-						"mnt_want_write()\n");
-				WARN_ON(1);
-			}
-		}
-	}
+	if (file->f_mode & FMODE_WRITE)
+		drop_file_write_access(file);
+
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN include/linux/file.h~create-file_drop_write_access-helper include/linux/file.h
--- a/include/linux/file.h~create-file_drop_write_access-helper
+++ a/include/linux/file.h
@@ -61,6 +61,7 @@ extern struct kmem_cache *filp_cachep;
 
 extern void __fput(struct file *);
 extern void fput(struct file *);
+extern void drop_file_write_access(struct file *file);
 
 struct file_operations;
 struct vfsmount;
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

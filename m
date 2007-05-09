From: akpm@linux-foundation.org
Subject: - revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch removed from -mm tree
Date: Wed, 09 May 2007 02:56:10 -0700
Message-ID: <200705090956.l499uAZp020552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916AbXEIJ4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revoke: change revoke_table to fileset and revoke_details
has been removed from the -mm tree.  Its filename was
     revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: revoke: change revoke_table to fileset and revoke_details
From: Pekka Enberg <penberg@cs.helsinki.fi>

The revoke_table struct is overloaded because it serves two purposes: it
manages the pre-allocated set of files and tracks the revoke operation so
that we know where to start restore if the operation fails.  This splits
file set management to separate struct fileset and renames struct
revoke_table to revoke_details.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |  171 +++++++++++++++++++++++++++++---------------------
 1 files changed, 101 insertions(+), 70 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-change-revoke_table-to-fileset-and-revoke_details fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-change-revoke_table-to-fileset-and-revoke_details
+++ a/fs/revoke.c
@@ -18,19 +18,71 @@
 #include <linux/revoked_fs_i.h>
 #include <linux/syscalls.h>
 
-/*
- * This is used for pre-allocating an array of file pointers so that we don't
- * have to do memory allocation under tasklist_lock.
+/**
+ * fileset - an array of file pointers.
+ * @files:    the array of file pointers
+ * @nr:               number of elements in the array
+ * @end:      index to next unused file pointer
+ */
+struct fileset {
+	struct file	**files;
+	unsigned long	nr;
+	unsigned long	end;
+};
+
+/**
+ * revoke_details - details of the revoke operation
+ * @inode:            invalidate open file descriptors of this inode
+ * @fset:             set of files that point to a revoked inode
+ * @restore_start:    index to the first file pointer that is currently in
+ *                    use by a file descriptor but the real file has not
+ *                    been revoked
  */
-struct revoke_table {
-	struct file **files;
-	unsigned long size;
-	unsigned long end;
-	unsigned long restore_start;
+struct revoke_details {
+	struct fileset	*fset;
+	unsigned long	restore_start;
 };
 
 static struct kmem_cache *revokefs_inode_cache;
 
+static inline bool fset_is_full(struct fileset *set)
+{
+	return set->nr == set->end;
+}
+
+static inline struct file *fset_get_filp(struct fileset *set)
+{
+	return set->files[set->end++];
+}
+
+static struct fileset *alloc_fset(unsigned long size)
+{
+	struct fileset *fset;
+
+	fset = kzalloc(sizeof *fset, GFP_KERNEL);
+	if (!fset)
+		return NULL;
+
+	fset->files = kcalloc(size, sizeof(struct file *), GFP_KERNEL);
+	if (!fset->files) {
+		kfree(fset);
+		return NULL;
+	}
+	fset->nr = size;
+	return fset;
+}
+
+static void free_fset(struct fileset *fset)
+{
+      int i;
+
+      for (i = fset->end; i < fset->nr; i++)
+              fput(fset->files[i]);
+
+      kfree(fset->files);
+      kfree(fset);
+}
+
 /*
  * Revoked file descriptors point to inodes in the revokefs filesystem.
  */
@@ -84,22 +136,12 @@ static inline bool can_revoke_file(struc
 	return file->f_dentry->d_inode == inode;
 }
 
-static inline bool revoke_table_is_full(struct revoke_table *table)
-{
-	return table->end == table->size;
-}
-
-static inline struct file *revoke_table_get(struct revoke_table *table)
-{
-	return table->files[table->end++];
-}
-
 /*
  * 	LOCKING: task_lock(owner)
  */
 static int revoke_fds(struct task_struct *owner,
 		      struct inode *inode,
-		      struct file *to_exclude, struct revoke_table *table)
+		      struct file *to_exclude, struct fileset *fset)
 {
 	struct files_struct *files;
 	struct fdtable *fdt;
@@ -127,12 +169,12 @@ static int revoke_fds(struct task_struct
 			goto failed;
 		}
 
-		if (revoke_table_is_full(table)) {
+		if (fset_is_full(fset)) {
 			err = -ENOMEM;
 			goto failed;
 		}
 
-		new_filp = revoke_table_get(table);
+		new_filp = fset_get_filp(fset);
 
 		/*
 		 * Replace original struct file pointer with a pointer to
@@ -208,17 +250,17 @@ static int __revoke_break_cow(struct tas
 	return err;
 }
 
-static int revoke_break_cow(struct revoke_table *table, struct inode *inode,
+static int revoke_break_cow(struct fileset *fset, struct inode *inode,
 			    struct file *to_exclude)
 {
 	unsigned long i;
 	int err = 0;
 
-	for (i = 0; i < table->end; i++) {
+	for (i = 0; i < fset->end; i++) {
 		struct revokefs_inode_info *info;
 		struct file *this;
 
-		this = table->files[i];
+		this = fset->files[i];
 		info = revokefs_i(this->f_dentry->d_inode);
 
 		err = __revoke_break_cow(info->owner, inode, to_exclude);
@@ -399,32 +441,32 @@ static void restore_file(struct revokefs
 	info->owner = NULL;	/* To avoid double-restore. */
 }
 
-static void restore_files(struct revoke_table *table)
+static void restore_files(struct revoke_details *details)
 {
 	unsigned long i;
 
-	for (i = table->restore_start; i < table->end; i++) {
+	for (i = details->restore_start; i < details->fset->end; i++) {
 		struct revokefs_inode_info *info;
 		struct file *filp;
 
-		filp = table->files[i];
+		filp = details->fset->files[i];
 		info = revokefs_i(filp->f_dentry->d_inode);
 
 		restore_file(info);
 	}
 }
 
-static int revoke_files(struct revoke_table *table)
+static int revoke_files(struct revoke_details *details)
 {
 	unsigned long i;
 	int err = 0;
 
-	for (i = 0; i < table->end; i++) {
+	for (i = 0; i < details->fset->end; i++) {
 		struct revokefs_inode_info *info;
 		struct file *this, *filp;
 		struct inode *inode;
 
-		this = table->files[i];
+		this = details->fset->files[i];
 		inode = this->f_dentry->d_inode;
 		info = revokefs_i(inode);
 
@@ -432,7 +474,7 @@ static int revoke_files(struct revoke_ta
 		 * Increase count before attempting to close file as
 		 * an partially closed file can no longer be restored.
 		 */
-		table->restore_start++;
+		details->restore_start++;
 		filp = info->file;
 		err = filp->f_op->revoke(filp, inode->i_mapping);
 		put_task_struct(info->owner);
@@ -481,50 +523,31 @@ static unsigned long inode_fds(struct in
 	return nr_fds;
 }
 
-static void free_revoke_table(struct revoke_table *table)
-{
-	int i;
-
-	for (i = table->end; i < table->size; i++)
-		fput(table->files[i]);
-
-	kfree(table->files);
-	kfree(table);
-}
-
-static struct revoke_table *__alloc_revoke_table(unsigned long size)
+static struct fileset *__alloc_revoke_fset(unsigned long size)
 {
-	struct revoke_table *table;
+	struct fileset *fset;
 	int i;
 
-	table = kzalloc(sizeof *table, GFP_KERNEL);
-	if (!table)
-		return NULL;
-
-	table->size = size;
-	table->files = kcalloc(size, sizeof(struct file *), GFP_KERNEL);
-	if (!table->files) {
-		kfree(table);
+	fset = alloc_fset(size);
+	if (!fset)
 		return NULL;
-	}
 
-	for (i = 0; i < table->size; i++) {
+	for (i = 0; i < fset->nr; i++) {
 		struct file *filp;
 
 		filp = get_revoked_file();
 		if (!filp)
 			goto err;
 
-		table->files[i] = filp;
+		fset->files[i] = filp;
 	}
-	return table;
+	return fset;
   err:
-	free_revoke_table(table);
+	free_fset(fset);
 	return NULL;
 }
 
-static struct revoke_table *alloc_revoke_table(struct inode *inode,
-					       struct file *to_exclude)
+static struct fileset *alloc_revoke_fset(struct inode *inode, struct file *to_exclude)
 {
 	unsigned long nr_fds;
 
@@ -532,12 +555,13 @@ static struct revoke_table *alloc_revoke
 	nr_fds = inode_fds(inode, to_exclude);
 	read_unlock(&tasklist_lock);
 
-	return __alloc_revoke_table(nr_fds);
+	return __alloc_revoke_fset(nr_fds);
 }
 
 static int do_revoke(struct inode *inode, struct file *to_exclude)
 {
-	struct revoke_table *table = NULL;
+	struct revoke_details details;
+	struct fileset *fset = NULL;
 	struct task_struct *g, *p;
 	int err = 0;
 
@@ -552,8 +576,12 @@ static int do_revoke(struct inode *inode
 		goto out;
 	}
 
-	table = alloc_revoke_table(inode, to_exclude);
-	if (!table) {
+	/*
+	 * Pre-allocate memory because the first pass is done under
+	 * tasklist_lock.
+	 */
+	fset = alloc_revoke_fset(inode, to_exclude);
+	if (!fset) {
 		err = -ENOMEM;
 		goto out;
 	}
@@ -563,9 +591,9 @@ static int do_revoke(struct inode *inode
 	/*
 	 * If someone forked while we were allocating memory, try again.
 	 */
-	if (inode_fds(inode, to_exclude) > table->size) {
+	if (inode_fds(inode, to_exclude) > fset->nr) {
 		read_unlock(&tasklist_lock);
-		free_revoke_table(table);
+		free_fset(fset);
 		goto retry;
 	}
 
@@ -574,7 +602,7 @@ static int do_revoke(struct inode *inode
 	 * new operations on them.
 	 */
 	do_each_thread(g, p) {
-		err = revoke_fds(p, inode, to_exclude, table);
+		err = revoke_fds(p, inode, to_exclude, fset);
 		if (err)
 			goto exit_loop;
 	}
@@ -593,24 +621,27 @@ static int do_revoke(struct inode *inode
 	/*
  	 * Break COW for private mappings.
  	 */
-	err = revoke_break_cow(table, inode, to_exclude);
+	err = revoke_break_cow(fset, inode, to_exclude);
 	if (err)
 		goto out_restore;
 
+	details.fset = fset;
+	details.restore_start = 0;
+
 	/*
 	 * Now, revoke the files for good.
 	 */
-	err = revoke_files(table);
+	err = revoke_files(&details);
 	if (err)
 		goto out_restore;
 
   out_free_table:
-	free_revoke_table(table);
+	free_fset(fset);
   out:
 	return err;
 
   out_restore:
-	restore_files(table);
+	restore_files(&details);
 	goto out_free_table;
 }
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
krealloc-fix-kerneldoc-comments.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch

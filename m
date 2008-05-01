From: akpm@linux-foundation.org
Subject: - reiser4-granulate-rw-serialization-when-accessing-file-conversion-set.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:26 -0700
Message-ID: <200805010923.m419NQfS030094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755254AbYEAJYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: granulate rw-serialization when accessing file conversion set
has been removed from the -mm tree.  Its filename was
     reiser4-granulate-rw-serialization-when-accessing-file-conversion-set.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: granulate rw-serialization when accessing file conversion set
From: Edward Shishkin <edward.shishkin@gmail.com>

Split common file plugin conversion procedure into
. plugin scheduling part
. plugin conversion part
Move the last one to the plugin-independent file operation
(reiser4_write_careful) with active protection of file
conversion set (conv_sem held).

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/cluster.h              |    2 
 fs/reiser4/plugin/file/cryptcompress.c   |  102 +++----
 fs/reiser4/plugin/file/cryptcompress.h   |   16 -
 fs/reiser4/plugin/file/file.c            |   31 --
 fs/reiser4/plugin/file/file.h            |   21 +
 fs/reiser4/plugin/file/file_conversion.c |  296 +++++++++++----------
 fs/reiser4/plugin/file/tail_conversion.c |    4 
 fs/reiser4/plugin/object.c               |    2 
 fs/reiser4/plugin/plugin.h               |    9 
 9 files changed, 253 insertions(+), 230 deletions(-)

diff -puN fs/reiser4/plugin/cluster.h~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set
+++ a/fs/reiser4/plugin/cluster.h
@@ -333,6 +333,8 @@ int set_cluster_by_page(struct cluster_h
 			int count);
 int prepare_page_cluster(struct inode *inode, struct cluster_handle * clust,
 			 rw_op rw);
+void __put_page_cluster(int from, int count,
+			struct page ** pages, struct inode  * inode);
 void put_page_cluster(struct cluster_handle * clust,
 		      struct inode  * inode, rw_op rw);
 void put_cluster_handle(struct cluster_handle * clust);
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -1343,8 +1343,8 @@ static void truncate_page_cluster_range(
 }
 
 /* Put @count pages starting from @from offset */
-static void __put_page_cluster(int from, int count,
-			       struct page ** pages, struct inode  * inode)
+void __put_page_cluster(int from, int count,
+			struct page ** pages, struct inode  * inode)
 {
 	int i;
 	assert("edward-1468", pages != NULL);
@@ -2637,7 +2637,7 @@ void reset_cluster_params(struct cluster
 /* the heart of write_cryptcompress */
 static loff_t do_write_cryptcompress(struct file *file, struct inode *inode,
 				     const char __user *buf, size_t to_write,
-				     loff_t pos, int *conv_occured)
+				     loff_t pos, struct psched_context *cont)
 {
 	int i;
 	hint_t *hint;
@@ -2647,6 +2647,7 @@ static loff_t do_write_cryptcompress(str
 	struct cluster_handle clust;
 	struct cryptcompress_info * info;
 
+	assert("edward-154", buf != NULL);
 	assert("edward-161", reiser4_schedulable());
 	assert("edward-748", cryptcompress_inode_ok(inode));
 	assert("edward-159", current_blocksize == PAGE_CACHE_SIZE);
@@ -2677,10 +2678,10 @@ static loff_t do_write_cryptcompress(str
 	if (next_window_stat(&win) == HOLE_WINDOW) {
 		/* write hole in this iteration
 		   separated from the loop below */
-		result = write_conversion_hook(file, inode,
-					       pos,
-					       &clust,
-					       NULL);
+		result = write_pschedule_hook(file, inode,
+					      pos,
+					      &clust,
+					      cont);
 		if (result)
 			goto out;
 		result = prepare_logical_cluster(inode, pos, count, &clust,
@@ -2694,12 +2695,15 @@ static loff_t do_write_cryptcompress(str
 
 		assert("edward-750", reiser4_schedulable());
 
-		result = write_conversion_hook(file, inode,
-					       pos + to_write - count,
-					       &clust,
-					       conv_occured);
-		if (result || *conv_occured)
+		result = write_pschedule_hook(file, inode,
+					      pos + to_write - count,
+					      &clust,
+					      cont);
+		if (result)
 			goto out;
+		if (cont->state == PSCHED_ASSIGNED_NEW)
+			goto out_no_release;
+
 		result = prepare_logical_cluster(inode, pos, count, &clust,
 						 LC_APPOV);
 		if (result)
@@ -2768,30 +2772,16 @@ static loff_t do_write_cryptcompress(str
 		break;
 	} while (count);
  out:
-	/*
-	 * NOTE: at this point file may have
-	 * another (unix-file) plugin installed
-	 */
 	done_lh(&hint->lh);
-	if (result == -EEXIST)
-		warning("edward-1407", "write returns EEXIST!\n");
-
-	put_cluster_handle(&clust);
+	mutex_unlock(&info->checkin_mutex);
 	save_file_hint(file, hint);
+ out_no_release:
 	kfree(hint);
-	/*
-	 * don't release cryptcompress-specific
-	 * checkin_mutex, if conversion occured
-	 */
-	if (*conv_occured == 0)
-		mutex_unlock(&info->checkin_mutex);
-	if (buf) {
-		/* if nothing were written - there must be an error */
-		assert("edward-195", ergo((to_write == count),
-					  (result < 0 || *conv_occured)));
-		return (to_write - count) ? (to_write - count) : result;
-	}
-	return result;
+	put_cluster_handle(&clust);
+	assert("edward-195",
+	       ergo((to_write == count),
+		    (result < 0 || cont->state == PSCHED_ASSIGNED_NEW)));
+	return (to_write - count) ? (to_write - count) : result;
 }
 
 /**
@@ -2802,7 +2792,8 @@ static loff_t do_write_cryptcompress(str
  * @off: position in file to write to
  */
 ssize_t write_cryptcompress(struct file *file, const char __user *buf,
-			    size_t count, loff_t *off, int *conv)
+			    size_t count, loff_t *off,
+			    struct psched_context *cont)
 {
 	ssize_t result;
 	struct inode *inode;
@@ -2810,41 +2801,37 @@ ssize_t write_cryptcompress(struct file 
   	loff_t pos = *off;
   	struct cryptcompress_info *info;
 
-  	assert("edward-1449", *conv == 0);
+  	assert("edward-1449", cont->state == PSCHED_INVAL_STATE);
 
 	inode = file->f_dentry->d_inode;
 	assert("edward-196", cryptcompress_inode_ok(inode));
 
 	info = cryptcompress_inode_data(inode);
-
-	ctx = reiser4_init_context(inode->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
- 	mutex_lock(&inode->i_mutex);
+	ctx = get_current_context();
 
 	result = generic_write_checks(file, &pos, &count, 0);
-  	if (unlikely(result != 0))
-		goto out;
+  	if (unlikely(result != 0)) {
+		context_set_commit_async(ctx);
+		return result;
+	}
   	if (unlikely(count == 0))
-		goto out;
+		return 0;
 	result = remove_suid(file->f_dentry);
-	if (unlikely(result != 0))
-		goto out;
+	if (unlikely(result != 0)) {
+		context_set_commit_async(ctx);
+		return result;
+	}
 	/* remove_suid might create a transaction */
 	reiser4_txn_restart(ctx);
 
-	result = do_write_cryptcompress(file, inode, buf, count, pos, conv);
+	result = do_write_cryptcompress(file, inode, buf, count, pos, cont);
 
-  	if (result < 0)
-		goto out;
+  	if (unlikely(result < 0)) {
+		context_set_commit_async(ctx);
+		return result;
+	}
   	/* update position in a file */
   	*off = pos + result;
- out:
-	mutex_unlock(&inode->i_mutex);
-
-	context_set_commit_async(ctx);
-	reiser4_exit_context(ctx);
 	return result;
 }
 
@@ -3705,7 +3692,12 @@ int setattr_cryptcompress(struct dentry 
 			ctx = reiser4_init_context(dentry->d_inode->i_sb);
 			if (IS_ERR(ctx))
 				return PTR_ERR(ctx);
-
+			result = setattr_pschedule_hook(inode);
+			if (result) {
+				context_set_commit_async(ctx);
+				reiser4_exit_context(ctx);
+				return result;
+			}
 			old_size = i_size_read(inode);
 			inode_check_scale(inode, old_size, attr->ia_size);
 
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -448,6 +448,16 @@ static inline int alloc_cluster_pgset(st
 	return 0;
 }
 
+static inline void move_cluster_pgset(struct cluster_handle *clust,
+				      struct page ***pages, int * nr_pages)
+{
+	assert("edward-1545", clust != NULL && clust->pages != NULL);
+	assert("edward-1546", pages != NULL && *pages == NULL);
+	*pages = clust->pages;
+	*nr_pages = clust->nr_pages;
+	clust->pages = NULL;
+}
+
 static inline void free_cluster_pgset(struct cluster_handle * clust)
 {
 	assert("edward-951", clust->pages != NULL);
@@ -552,8 +562,10 @@ int bind_cryptcompress(struct inode *chi
 void destroy_inode_cryptcompress(struct inode * inode);
 int grab_page_cluster(struct inode *inode, struct cluster_handle * clust,
 		      rw_op rw);
-int write_conversion_hook(struct file *file, struct inode * inode, loff_t pos,
- 			  struct cluster_handle * clust, int * progress);
+int write_pschedule_hook(struct file *file, struct inode * inode,
+			 loff_t pos, struct cluster_handle * clust,
+			 struct psched_context * cont);
+int setattr_pschedule_hook(struct inode * inode);
 struct reiser4_crypto_info * inode_crypto_info(struct inode * inode);
 void inherit_crypto_info_common(struct inode * parent, struct inode * object,
 				int (*can_inherit)(struct inode * child,
diff -puN fs/reiser4/plugin/file/file.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set
+++ a/fs/reiser4/plugin/file/file.c
@@ -2077,17 +2077,17 @@ static void drop_access(struct unix_file
 			      __FILE__, __LINE__, __FUNCTION__, ## __VA_ARGS__)
 
 /**
- * write_unix_file - write of struct file_operations
+ * write_unix_file - private ->write() method of unix_file plugin.
+ *
  * @file: file to write to
  * @buf: address of user-space buffer
- * @write_amount: number of bytes to write
- * @off: position in file to write to
- *
- * This is implementation of vfs's write method of struct file_operations for
- * unix file plugin.
+ * @count: number of bytes to write
+ * @pos: position in file to write to
+ * @cont: unused argument, as we don't perform plugin conversion when being
+ * managed by unix_file plugin.
  */
 ssize_t write_unix_file(struct file *file, const char __user *buf,
-			size_t count, loff_t *pos, int *conv)
+			size_t count, loff_t *pos, struct psched_context *cont)
 {
 	int result;
 	reiser4_context *ctx;
@@ -2102,12 +2102,8 @@ ssize_t write_unix_file(struct file *fil
 	int ea;
 	loff_t new_size;
 
+	ctx = get_current_context();
 	inode = file->f_dentry->d_inode;
-	ctx = reiser4_init_context(inode->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
-	mutex_lock(&inode->i_mutex);
 
 	assert("vs-947", !reiser4_inode_get_flag(inode, REISER4_NO_SD));
 	assert("vs-9471", (!reiser4_inode_get_flag(inode, REISER4_PART_MIXED)));
@@ -2115,17 +2111,13 @@ ssize_t write_unix_file(struct file *fil
 	/* check amount of bytes to write and writing position */
 	result = generic_write_checks(file, pos, &count, 0);
 	if (result) {
-		mutex_unlock(&inode->i_mutex);
 		context_set_commit_async(ctx);
-		reiser4_exit_context(ctx);
 		return result;
 	}
 
 	result = remove_suid(file->f_dentry);
 	if (result) {
-		mutex_unlock(&inode->i_mutex);
 		context_set_commit_async(ctx);
-		reiser4_exit_context(ctx);
 		return result;
 	}
 	/* remove_suid might create a transaction */
@@ -2249,11 +2241,9 @@ ssize_t write_unix_file(struct file *fil
 		file_update_time(file);
 		result = reiser4_update_sd(inode);
 		if (result) {
-			mutex_unlock(&inode->i_mutex);
 			current->backing_dev_info = NULL;
 			drop_access(uf_info);
 			context_set_commit_async(ctx);
-			reiser4_exit_context(ctx);
 			return result;
 		}
 		drop_access(uf_info);
@@ -2272,9 +2262,6 @@ ssize_t write_unix_file(struct file *fil
 		buf += written;
 		*pos += written;
 	}
-
-	mutex_unlock(&inode->i_mutex);
-
 	if (result == 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		reiser4_txn_restart_current();
 		grab_space_enable();
@@ -2287,8 +2274,6 @@ ssize_t write_unix_file(struct file *fil
 
 	current->backing_dev_info = NULL;
 
-	reiser4_exit_context(ctx);
-
 	/*
 	 * return number of written bytes or error code if nothing is
 	 * written. Note, that it does not work correctly in case when
diff -puN fs/reiser4/plugin/file/file.h~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set
+++ a/fs/reiser4/plugin/file/file.h
@@ -8,6 +8,20 @@
 #if !defined( __REISER4_FILE_H__ )
 #define __REISER4_FILE_H__
 
+/* possible states when scheduling a new file plugin */
+typedef enum {
+	PSCHED_INVAL_STATE,    /* invalid state */
+	PSCHED_SCHED_POINT,    /* scheduling point has been achieved */
+	PSCHED_REMAINS_OLD,    /* made a decision to be managed by old plugin */
+	PSCHED_ASSIGNED_NEW    /* new plugin has been scheduled */
+} psched_state;
+
+struct psched_context {
+	int nr_pages;
+	struct page **pages;
+	psched_state state;
+};
+
 /**
  * Declarations of common/careful/generic methods.
  * Suppose ->foo() is a vs method (of f_ops, i_ops, or a_ops);
@@ -26,7 +40,7 @@
  */
 
 /* inode operations */
-int reiser4_setattr_careful(struct dentry *, struct iattr *);
+int reiser4_setattr(struct dentry *, struct iattr *);
 
 /* file operations */
 ssize_t reiser4_read_careful(struct file *, char __user *buf,
@@ -64,7 +78,7 @@ int setattr_unix_file(struct dentry *, s
 ssize_t read_unix_file(struct file *, char __user *buf, size_t read_amount,
 		       loff_t *off);
 ssize_t write_unix_file(struct file *, const char __user *buf, size_t write_amount,
-			loff_t * off, int * conv);
+			loff_t * off, struct psched_context * cont);
 int ioctl_unix_file(struct inode *, struct file *, unsigned int cmd,
 		    unsigned long arg);
 int mmap_unix_file(struct file *, struct vm_area_struct *);
@@ -101,7 +115,8 @@ int setattr_cryptcompress(struct dentry 
 ssize_t read_cryptcompress(struct file *, char __user *buf,
 			   size_t count, loff_t *off);
 ssize_t write_cryptcompress(struct file *, const char __user *buf,
-			    size_t count, loff_t * off, int *conv);
+			    size_t count, loff_t * off,
+			    struct psched_context *cont);
 int ioctl_cryptcompress(struct inode *, struct file *, unsigned int cmd,
 			unsigned long arg);
 int mmap_cryptcompress(struct file *, struct vm_area_struct *);
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -1,17 +1,25 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser,
    licensing governed by reiser4/README */
 
-/* *
- * This file contains a converter cryptcompress->unix_file, and O(1)-heuristic,
- * which allows to assign for a regular file the most reasonable plugin to be
- * managed by. Note, that we don't perform back conversion because of
- * compatibility reasons (see http://dev.namesys.com/Version4.X.Y for details).
- *
- * Currently used heuristic is very simple: if first complete logical cluster
- * (64K by default) of a file is incompressible, then we make a decision, that
- * the whole file is incompressible (*). When creating a file the conversion
- * is enabled by default via installing a special "permitting" compression mode
- * plugin (**) (CONVX_COMPRESSION_MODE_ID, see plugin/compress/compress_mode.c
+/**
+ * This file contains plugin schedule hooks, and plugin conversion methods.
+ *
+ * Plugin schedule hook makes a decision (at plugin schedule point) about the
+ * most reasonable plugins for managing a regular file. Usually such decisions
+ * is made by some O(1)-heuristic.
+ *
+ * By default we assign a unix_file plugin id when writing incompressible file
+ * managed by cryptcompress plugin id. Currently used heuristic for estimating
+ * compressibility is very simple: if first complete logical cluster (64K by
+ * default) of a file is incompressible, then we make a decision, that the whole
+ * file is incompressible (*).
+ *
+ * To enable a conversion we install a special "magic" compression mode plugin
+ * (CONVX_COMPRESSION_MODE_ID, see plugin/compress/compress_mode.c for details)
+ * at file creation time (**).
+ *
+ * Note, that we don't perform back conversion (unix_file->cryptcompress)
+ * because of compatibility reasons (see http://dev.namesys.com/Version4.X.Y
  * for details).
  *
  * The conversion is accompanied by rebuilding disk structures of a file, so it
@@ -19,11 +27,12 @@
  * don't expect them to be in such inconsistent state. For this to be protected
  * we serialize readers and writers of a file's conversion set (FCS).
  *
- * We define FCS as a file plugin id installed in inode's pset all structures
- * specific for this id (like stat-data, etc. items). Note, that FCS is defined
- * per file.
+ * We define FCS as a file plugin installed in inode's pset plus file's data
+ * and metadata that this file plugin manipulates with (items, etc).
+ * Note, that FCS is defined per file.
  * FCS reader is defined as a set of instruction of the following type:
- * inode_file_plugin(inode)->method();
+ * {inode_file_plugin(inode)->method()} (I.e. retrieving a file plugin id
+ * conjoined with all method's instructions should be atomic).
  * FCS writer is a set of instructions that perform file plugin conversion
  * (convert items, update pset, etc).
  * Example:
@@ -48,7 +57,7 @@
  *
  * ---
  * (*)  This heuristic can be changed to a better one (benchmarking is needed).
- * (**) Such solution allows to keep enable/disable state on disk.
+ * (**) Such technique allows to keep enable/disable state on disk.
  */
 
 #include "../../inode.h"
@@ -71,9 +80,10 @@
 	 file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID) &&		\
 	 conversion_enabled(inode))
 /**
- * We'll speak about "passive" protection for readers and "active"
- * protection for writers. All methods with active or passive protection
- * has suffix "careful".
+ * To avoid confusion with read/write file operations, we'll speak about
+ * "passive" protection for FCS readers and "active" protection for FCS
+ * writers. All methods with active or passive protection have suffix
+ * "careful".
  */
 /**
  * Macros for passive protection.
@@ -117,33 +127,6 @@
 		up_read(guard);						\
 })
 
-/**
- * This macro is for invariant methods which can be decomposed
- * into "active expression" that goes first and contains pset
- * writers (and, hence, needs serialization), and generic plugin
- * method which doesn't need serialization.
- *
- * The macro accepts the following lexemes:
- * @type - type of the value represented by the compound statement;
- * @method - name of invariant operation supplied to VFS;
- * @active_expr - name of "active expression", usually some O(1) -
- * heuristic for disabling a conversion.
- */
-#define PROT_ACTIVE(type, method, args, active_expr)			\
-({	                 						\
-	type _result = 0;						\
-	struct rw_semaphore * guard =					\
-		&reiser4_inode_data(inode)->conv_sem;			\
-									\
-	if (should_protect(inode)) {					\
-		down_write(guard);					\
-		if (should_protect(inode))				\
-			_result = active_expr;				\
-		up_write(guard);					\
-	}								\
-	_result = inode_file_plugin(inode)->method args;                \
-})
-
 /* Pass management to the unix-file plugin with "notail" policy */
 static int __cryptcompress2unixfile(struct file *file, struct inode * inode)
 {
@@ -206,9 +189,14 @@ static int disabled_conversion_inode_ok(
 }
 #endif
 
-/* Assign another mode that will control
-   compression at flush time only */
-static int disable_conversion_no_update_sd(struct inode * inode)
+/**
+ * Disable future attempts to schedule/convert file plugin.
+ * This function is called by plugin schedule hooks.
+ *
+ * To disable conversion we assign any compression mode plugin id
+ * different from CONVX_COMPRESSION_MODE_ID.
+ */
+static int disable_conversion(struct inode * inode)
 {
 	int result;
 	result =
@@ -221,17 +209,14 @@ static int disable_conversion_no_update_
 	return result;
 }
 
-/* Disable future attempts to check/convert. This function is called by
-   conversion hooks. */
-static int disable_conversion(struct inode * inode)
-{
-	return disable_conversion_no_update_sd(inode);
-}
-
-static int check_position(struct inode * inode,
-			  loff_t pos /* position in the file to write from */,
-			  struct cluster_handle * clust,
-			  int * check_compress)
+/**
+ * Check if we really have achieved plugin scheduling point
+ */
+static int check_psched_point(struct inode * inode,
+			      loff_t pos /* position in the
+					    file to write from */,
+			      struct cluster_handle * clust,
+			      struct psched_context * cont)
 {
 	assert("edward-1505", conversion_enabled(inode));
 	/*
@@ -255,8 +240,10 @@ static int check_position(struct inode *
 	assert("edward-1498",
 	       pos == inode->i_size &&
 	       pos == inode_cluster_size(inode));
+	assert("edward-1539", cont != NULL);
+	assert("edward-1540", cont->state == PSCHED_INVAL_STATE);
 
-	*check_compress = 1;
+	cont->state = PSCHED_SCHED_POINT;
 	return 0;
 }
 
@@ -310,17 +297,18 @@ static int prepped_dclust_ok(hint_t * hi
  * A simple O(1)-heuristic for compressibility.
  * This is called not more then one time per file's life.
  * Read first logical cluster (of index #0) and estimate its compressibility.
- * Save estimation result in @compressible.
+ * Save estimation result in @cont.
  */
 static int read_check_compressibility(struct inode * inode,
 				      struct cluster_handle * clust,
-				      int * compressible)
+				      struct psched_context * cont)
 {
 	int i;
 	int result;
 	__u32 dst_len;
 	hint_t tmp_hint;
 	hint_t * cur_hint = clust->hint;
+	assert("edward-1541", cont->state == PSCHED_SCHED_POINT);
 
 	start_check_compressibility(inode, clust, &tmp_hint);
 
@@ -383,8 +371,10 @@ static int read_check_compressibility(st
 		       dst_len <= tfm_stream_size(tc, OUTPUT_STREAM));
 	}
 	finish_check_compressibility(inode, clust, cur_hint);
-	*compressible = data_is_compressible(dst_len,
-					     inode_cluster_size(inode));
+	cont->state =
+		(data_is_compressible(dst_len, inode_cluster_size(inode)) ?
+		 PSCHED_REMAINS_OLD :
+		 PSCHED_ASSIGNED_NEW);
 	return 0;
  error:
 	put_page_cluster(clust, inode, READ_OP);
@@ -461,18 +451,17 @@ static int complete_file_conversion(stru
 	return 0;
 }
 
-
-/* do conversion */
+/**
+ * Convert cryptcompress file plugin to unix_file plugin.
+ */
 static int cryptcompress2unixfile(struct file * file, struct inode * inode,
-				  struct cluster_handle * clust)
+				  struct psched_context * cont)
 {
 	int i;
 	int result = 0;
 	struct cryptcompress_info *cr_info;
 	struct unix_file_info *uf_info;
-
-	assert("edward-1516", clust->pages[0]->index == 0);
-	assert("edward-1517", clust->hint != NULL);
+	assert("edward-1516", cont->pages[0]->index == 0);
 
 	/* release all cryptcompress-specific resources */
 	cr_info = cryptcompress_inode_data(inode);
@@ -480,7 +469,6 @@ static int cryptcompress2unixfile(struct
 	if (result)
 		goto out;
 	reiser4_inode_set_flag(inode, REISER4_FILE_CONV_IN_PROGRESS);
-	reiser4_unset_hint(clust->hint);
 	result = cut_disk_cluster(inode, 0);
 	if (result)
 		goto out;
@@ -496,13 +484,13 @@ static int cryptcompress2unixfile(struct
 	uf_info = unix_file_inode_data(inode);
 
 	assert("edward-1518",
-	       ergo(jprivate(clust->pages[0]),
-		    !jnode_is_cluster_page(jprivate(clust->pages[0]))));
-	for(i = 0; i < clust->nr_pages; i++) {
-		assert("edward-1519", clust->pages[i]);
-		assert("edward-1520", PageUptodate(clust->pages[i]));
+	       ergo(jprivate(cont->pages[0]),
+		    !jnode_is_cluster_page(jprivate(cont->pages[0]))));
+	for(i = 0; i < cont->nr_pages; i++) {
+		assert("edward-1519", cont->pages[i]);
+		assert("edward-1520", PageUptodate(cont->pages[i]));
 
-		result = find_or_create_extent(clust->pages[i]);
+		result = find_or_create_extent(cont->pages[i]);
 		if (result)
 			break;
 	}
@@ -518,42 +506,62 @@ static int cryptcompress2unixfile(struct
 	return result;
 }
 
-/* Check, then perform or disable conversion if needed */
-int write_conversion_hook(struct file * file, struct inode * inode, loff_t pos,
-			  struct cluster_handle * clust, int * progress)
+/**
+ * This is called by ->write() method of a cryptcompress file plugin.
+ * Make a decision about the most reasonable file plugin id to manage
+ * the file.
+ */
+int write_pschedule_hook(struct file * file, struct inode * inode,
+			 loff_t pos, struct cluster_handle * clust,
+			 struct psched_context * cont)
 {
 	int result;
-	int check_compress = 0;
-	int compressible = 0;
-
 	if (!conversion_enabled(inode))
 		return 0;
-	result = check_position(inode, pos, clust, &check_compress);
-	if (result || !check_compress)
+	result = check_psched_point(inode, pos, clust, cont);
+	if (result || cont->state != PSCHED_SCHED_POINT)
 		return result;
-	result = read_check_compressibility(inode, clust, &compressible);
+	result = read_check_compressibility(inode, clust, cont);
 	if (result)
 		return result;
-
-	/* At this point page cluster is grabbed and uptodate */
-	if (!compressible) {
-		result = cryptcompress2unixfile(file, inode, clust);
-		if (result == 0)
-			*progress = 1;
+	if (cont->state == PSCHED_REMAINS_OLD) {
+		put_page_cluster(clust, inode, READ_OP);
+		return disable_conversion(inode);
 	}
-	else
-		result = disable_conversion(inode);
+	assert("edward-1543", cont->state == PSCHED_ASSIGNED_NEW);
+	/*
+	 * page cluster is grabbed and uptodate. It will be
+	 * released with a pgset after plugin conversion is
+	 * finished, see put_psched_context().
+	 */
+	reiser4_unset_hint(clust->hint);
+	move_cluster_pgset(clust, &cont->pages, &cont->nr_pages);
+	return 0;
+}
 
-	reiser4_txn_restart_current();
-	put_page_cluster(clust, inode, READ_OP);
-	return result;
+/**
+ * This is called by ->setattr() method of cryptcompress file plugin.
+ */
+int setattr_pschedule_hook(struct inode * inode)
+{
+	if (conversion_enabled(inode))
+		return disable_conversion(inode);
+	return 0;
 }
 
-static int setattr_conversion_hook(struct inode * inode, struct iattr *attr)
+static inline void init_psched_context(struct psched_context * cont)
 {
-	return (attr->ia_valid & ATTR_SIZE ? disable_conversion(inode) : 0);
+	memset(cont, 0, sizeof(*cont));
 }
 
+static inline void done_psched_context(struct psched_context * cont,
+				       struct inode * inode)
+{
+	if (cont->pages) {
+		__put_page_cluster(0, cont->nr_pages, cont->pages, inode);
+		kfree(cont->pages);
+	}
+}
 /**
  * Here are wrappers with "protection", aka Reiser4 "careful" methods.
  * They are used by vfs (as methods of file_ops, inode_ops or as_ops),
@@ -564,51 +572,58 @@ static int setattr_conversion_hook(struc
  * Wrappers with active protection for:
  *
  * ->write();
- * ->setattr();
  */
 
 /*
- * Reiser4 invariant ->write() method supplied to VFS.
- * Write a file in 2 steps:
- *  . start write with initial file plugin,
- *    switch to a new (more resonable) file plugin (if any);
- *  . finish write with the new plugin.
+ * ->write() file operation supplied to VFS.
+ * Write a file in 3 steps (some of them can be optional).
  */
 ssize_t reiser4_write_careful(struct file *file, const char __user *buf,
 			      size_t count, loff_t *off)
 {
-	int prot = 0;
-	int conv = 0;
-	ssize_t written_old = 0; /* bytes written with old plugin */
+	int result;
+	reiser4_context *ctx;
+	ssize_t written_old = 0; /* bytes written with initial plugin */
 	ssize_t written_new = 0; /* bytes written with new plugin */
+	struct psched_context cont;
 	struct inode * inode = file->f_dentry->d_inode;
-	struct rw_semaphore * guard = &reiser4_inode_data(inode)->conv_sem;
 
+	ctx = reiser4_init_context(inode->i_sb);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	init_psched_context(&cont);
+	mutex_lock(&inode->i_mutex);
 	/**
 	 * First step.
-	 * Check, if conversion is possible.
-	 * If yes, then ->write() method contains pset
-	 * writers, so active protection is required.
+	 * Start write with initial file plugin.
+	 * Keep a plugin schedule status at @cont (if any).
 	 */
-	if (should_protect(inode)) {
-		prot = 1;
-		down_write(guard);
-	}
 	written_old = inode_file_plugin(inode)->write(file,
 						      buf,
 						      count,
 						      off,
-						      &conv);
-	if (prot)
-		up_write(guard);
-	if (written_old < 0 || conv == 0)
-		return written_old;
+						      &cont);
+	if (cont.state != PSCHED_ASSIGNED_NEW || written_old < 0)
+		goto exit;
+	/**
+	 * Second step.
+	 * New file plugin has been scheduled.
+	 * Perform conversion to the new plugin.
+	 */
+	down_read(&reiser4_inode_data(inode)->conv_sem);
+	result = cryptcompress2unixfile(file, inode, &cont);
+	up_read(&reiser4_inode_data(inode)->conv_sem);
+	if (result) {
+		warning("edward-1544", "file conversion failed: %d", result);
+		context_set_commit_async(ctx);
+		goto exit;
+	}
+	reiser4_txn_restart(ctx);
 	/**
-	 * Conversion occurred.
-	 * Back conversion is impossible, so at
-	 * this step protection is not required.
+	 * Third step:
+	 * Finish write with the new file plugin.
 	 */
-	assert("edward-1532",
+	assert("edward-1536",
 	       inode_file_plugin(inode) ==
 	       file_plugin_by_id(UNIX_FILE_PLUGIN_ID));
 
@@ -617,21 +632,12 @@ ssize_t reiser4_write_careful(struct fil
 						      count - written_old,
 						      off,
 						      NULL);
-	return written_old + (written_new < 0 ? 0 : written_new);
-}
-
-int reiser4_setattr_careful(struct dentry *dentry, struct iattr *attr)
-{
-	int result;
-	struct inode * inode = dentry->d_inode;
-	reiser4_context * ctx =	reiser4_init_context(inode->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
-	result = PROT_ACTIVE(int, setattr, (dentry, attr),
-			     setattr_conversion_hook(inode, attr));
+ exit:
+	mutex_unlock(&inode->i_mutex);
+	done_psched_context(&cont, inode);
 	reiser4_exit_context(ctx);
-	return result;
+
+	return written_old + (written_new < 0 ? 0 : written_new);
 }
 
 /* Wrappers with passive protection for:
@@ -680,6 +686,16 @@ sector_t reiser4_bmap_careful(struct add
 }
 
 /*
+ * Wrappers without protection for:
+ *
+ * ->setattr()
+ */
+int reiser4_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	return inode_file_plugin(dentry->d_inode)->setattr(dentry, attr);
+}
+
+/*
   Local variables:
   c-indentation-style: "K&R"
   mode-name: "LC"
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -646,9 +646,9 @@ int extent2tail(struct file * file, stru
 		while (count) {
 			loff_t pos = start_byte;
 
-			assert("edward-1533",
+			assert("edward-1537",
 			       file != NULL && file->f_dentry != NULL);
-			assert("edward-1534",
+			assert("edward-1538",
 			       file->f_dentry->d_inode == inode);
 
 			result = reiser4_write_tail(file,
diff -puN fs/reiser4/plugin/object.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set
+++ a/fs/reiser4/plugin/object.c
@@ -91,7 +91,7 @@ static struct address_space_operations n
 /* VFS methods for regular files */
 static struct inode_operations regular_file_i_ops = {
 	.permission = reiser4_permission_common,
-	.setattr = reiser4_setattr_careful,
+	.setattr = reiser4_setattr,
 	.getattr = reiser4_getattr_common
 };
 static struct file_operations regular_file_f_ops = {
diff -puN fs/reiser4/plugin/plugin.h~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-granulate-rw-serialization-when-accessing-file-conversion-set
+++ a/fs/reiser4/plugin/plugin.h
@@ -228,11 +228,12 @@ typedef struct file_plugin {
 	int (*open) (struct inode * inode, struct file * file);
 	ssize_t (*read) (struct file *, char __user *buf, size_t read_amount,
 			loff_t *off);
-	/* write a file;
-	 * perform file plugin conversion (if needed);
-	 * set @*conv to 1, if the conversion occurred */
+	/* write as much as possible bytes from nominated @write_amount
+	 * before plugin scheduling is occurred. Save scheduling state
+	 * in @cont */
 	ssize_t (*write) (struct file *, const char __user *buf,
-			  size_t write_amount, loff_t * off, int * conv);
+			  size_t write_amount, loff_t * off,
+			  struct psched_context * cont);
 	int (*ioctl) (struct inode *inode, struct file *filp,
 		      unsigned int cmd, unsigned long arg);
 	int (*mmap) (struct file *, struct vm_area_struct *);
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

origin.patch
reiser4.patch
reiser4-granulate-rw-serialization-when-accessing-file-conversion-set.patch
reiser4-fix-disk-cluster-synchronization.patch
reiser4-use-balance_dirty_pages_ratelimited_nr.patch
reiser4-correct-references-to-filemap_nopage.patch
reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch
reiser4-code-cleanups.patch


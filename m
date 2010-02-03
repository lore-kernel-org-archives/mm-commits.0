From: akpm@linux-foundation.org
Subject: [folded] reiser4-rename-psched-to-dispatch.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:19:58 -0800
Message-ID: <201002032019.o13KJwKo016709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343Ab0BCUUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:20:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: rename psched to dispatch
has been removed from the -mm tree.  Its filename was
     reiser4-rename-psched-to-dispatch.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: rename psched to dispatch
From: Edward Shishkin <edward.shishkin@gmail.com>

. Rename confusing "psched" to "dispatch";
. Cleanups.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c   |   27 +---
 fs/reiser4/plugin/file/cryptcompress.h   |    8 -
 fs/reiser4/plugin/file/file.c            |    6 
 fs/reiser4/plugin/file/file.h            |   20 +--
 fs/reiser4/plugin/file/file_conversion.c |  136 ++++++++-------------
 fs/reiser4/plugin/plugin.h               |    2 
 6 files changed, 83 insertions(+), 116 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-rename-psched-to-dispatch fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-rename-psched-to-dispatch
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -2642,7 +2642,7 @@ void reset_cluster_params(struct cluster
 /* the heart of write_cryptcompress */
 static loff_t do_write_cryptcompress(struct file *file, struct inode *inode,
 				     const char __user *buf, size_t to_write,
-				     loff_t pos, struct psched_context *cont)
+				     loff_t pos, struct dispatch_context *cont)
 {
 	int i;
 	hint_t *hint;
@@ -2683,10 +2683,8 @@ static loff_t do_write_cryptcompress(str
 	if (next_window_stat(&win) == HOLE_WINDOW) {
 		/* write hole in this iteration
 		   separated from the loop below */
-		result = write_pschedule_hook(file, inode,
-					      pos,
-					      &clust,
-					      cont);
+		result = write_dispatch_hook(file, inode,
+					     pos, &clust, cont);
 		if (result)
 			goto out;
 		result = prepare_logical_cluster(inode, pos, count, &clust,
@@ -2700,14 +2698,13 @@ static loff_t do_write_cryptcompress(str
 
 		assert("edward-750", reiser4_schedulable());
 
-		result = write_pschedule_hook(file, inode,
-					      pos + to_write - count,
-					      &clust,
-					      cont);
+		result = write_dispatch_hook(file, inode,
+					     pos + to_write - count,
+					     &clust, cont);
 		if (result)
 			goto out;
-		if (cont->state == PSCHED_ASSIGNED_NEW)
-			/* done_lh was called in write_pschedule_hook */
+		if (cont->state == DISPATCH_ASSIGNED_NEW)
+			/* done_lh was called in write_dispatch_hook */
 			goto out_no_longterm_lock;
 
 		result = prepare_logical_cluster(inode, pos, count, &clust,
@@ -2787,7 +2784,7 @@ static loff_t do_write_cryptcompress(str
 	put_cluster_handle(&clust);
 	assert("edward-195",
 	       ergo((to_write == count),
-		    (result < 0 || cont->state == PSCHED_ASSIGNED_NEW)));
+		    (result < 0 || cont->state == DISPATCH_ASSIGNED_NEW)));
 	return (to_write - count) ? (to_write - count) : result;
 }
 
@@ -2800,7 +2797,7 @@ static loff_t do_write_cryptcompress(str
  */
 ssize_t write_cryptcompress(struct file *file, const char __user *buf,
 			    size_t count, loff_t *off,
-			    struct psched_context *cont)
+			    struct dispatch_context *cont)
 {
 	ssize_t result;
 	struct inode *inode;
@@ -2808,7 +2805,7 @@ ssize_t write_cryptcompress(struct file 
   	loff_t pos = *off;
   	struct cryptcompress_info *info;
 
-  	assert("edward-1449", cont->state == PSCHED_INVAL_STATE);
+  	assert("edward-1449", cont->state == DISPATCH_INVAL_STATE);
 
 	inode = file->f_dentry->d_inode;
 	assert("edward-196", cryptcompress_inode_ok(inode));
@@ -3701,7 +3698,7 @@ int setattr_cryptcompress(struct dentry 
 			ctx = reiser4_init_context(dentry->d_inode->i_sb);
 			if (IS_ERR(ctx))
 				return PTR_ERR(ctx);
-			result = setattr_pschedule_hook(inode);
+			result = setattr_dispatch_hook(inode);
 			if (result) {
 				context_set_commit_async(ctx);
 				reiser4_exit_context(ctx);
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-rename-psched-to-dispatch fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-rename-psched-to-dispatch
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -562,10 +562,10 @@ int bind_cryptcompress(struct inode *chi
 void destroy_inode_cryptcompress(struct inode * inode);
 int grab_page_cluster(struct inode *inode, struct cluster_handle * clust,
 		      rw_op rw);
-int write_pschedule_hook(struct file *file, struct inode * inode,
-			 loff_t pos, struct cluster_handle * clust,
-			 struct psched_context * cont);
-int setattr_pschedule_hook(struct inode * inode);
+int write_dispatch_hook(struct file *file, struct inode * inode,
+			loff_t pos, struct cluster_handle * clust,
+			struct dispatch_context * cont);
+int setattr_dispatch_hook(struct inode * inode);
 struct reiser4_crypto_info * inode_crypto_info(struct inode * inode);
 void inherit_crypto_info_common(struct inode * parent, struct inode * object,
 				int (*can_inherit)(struct inode * child,
diff -puN fs/reiser4/plugin/file/file.c~reiser4-rename-psched-to-dispatch fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-rename-psched-to-dispatch
+++ a/fs/reiser4/plugin/file/file.c
@@ -2059,8 +2059,10 @@ static void drop_access(struct unix_file
  * @cont: unused argument, as we don't perform plugin conversion when being
  * managed by unix_file plugin.
  */
-ssize_t write_unix_file(struct file *file, const char __user *buf,
-			size_t count, loff_t *pos, struct psched_context *cont)
+ssize_t write_unix_file(struct file *file,
+			const char __user *buf,
+			size_t count, loff_t *pos,
+			struct dispatch_context *cont)
 {
 	int result;
 	reiser4_context *ctx;
diff -puN fs/reiser4/plugin/file/file.h~reiser4-rename-psched-to-dispatch fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-rename-psched-to-dispatch
+++ a/fs/reiser4/plugin/file/file.h
@@ -8,18 +8,18 @@
 #if !defined( __REISER4_FILE_H__ )
 #define __REISER4_FILE_H__
 
-/* possible states when scheduling a new file plugin */
+/* possible states in dispatching process */
 typedef enum {
-	PSCHED_INVAL_STATE,    /* invalid state */
-	PSCHED_SCHED_POINT,    /* scheduling point has been achieved */
-	PSCHED_REMAINS_OLD,    /* made a decision to be managed by old plugin */
-	PSCHED_ASSIGNED_NEW    /* new plugin has been scheduled */
-} psched_state;
+	DISPATCH_INVAL_STATE,  /* invalid state */
+	DISPATCH_POINT,        /* dispatching point has been achieved */
+	DISPATCH_REMAINS_OLD,  /* made a decision to manage by old plugin */
+	DISPATCH_ASSIGNED_NEW  /* a new plugin has been assigned */
+} dispatch_state;
 
-struct psched_context {
+struct dispatch_context {
 	int nr_pages;
 	struct page **pages;
-	psched_state state;
+	dispatch_state state;
 };
 
 /**
@@ -82,7 +82,7 @@ int setattr_unix_file(struct dentry *, s
 ssize_t read_unix_file(struct file *, char __user *buf, size_t read_amount,
 		       loff_t *off);
 ssize_t write_unix_file(struct file *, const char __user *buf, size_t write_amount,
-			loff_t * off, struct psched_context * cont);
+			loff_t * off, struct dispatch_context * cont);
 int ioctl_unix_file(struct inode *, struct file *, unsigned int cmd,
 		    unsigned long arg);
 int mmap_unix_file(struct file *, struct vm_area_struct *);
@@ -121,7 +121,7 @@ ssize_t read_cryptcompress(struct file *
 			   size_t count, loff_t *off);
 ssize_t write_cryptcompress(struct file *, const char __user *buf,
 			    size_t count, loff_t * off,
-			    struct psched_context *cont);
+			    struct dispatch_context *cont);
 int ioctl_cryptcompress(struct inode *, struct file *, unsigned int cmd,
 			unsigned long arg);
 int mmap_cryptcompress(struct file *, struct vm_area_struct *);
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-rename-psched-to-dispatch fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-rename-psched-to-dispatch
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -2,62 +2,30 @@
    licensing governed by reiser4/README */
 
 /**
- * This file contains plugin schedule hooks, and plugin conversion methods.
+ * This file contains dispatching hooks, and conversion methods, which
+ * implement transitions in the FILE interface.
  *
- * Plugin schedule hook makes a decision (at plugin schedule point) about the
- * most reasonable plugins for managing a regular file. Usually such decisions
- * is made by some O(1)-heuristic.
- *
- * By default we assign a unix_file plugin id when writing incompressible file
- * managed by cryptcompress plugin id. Currently used heuristic for estimating
- * compressibility is very simple: if first complete logical cluster (64K by
- * default) of a file is incompressible, then we make a decision, that the whole
- * file is incompressible (*).
- *
- * To enable a conversion we install a special "magic" compression mode plugin
- * (CONVX_COMPRESSION_MODE_ID, see plugin/compress/compress_mode.c for details)
- * at file creation time (**).
- *
- * Note, that we don't perform back conversion (unix_file->cryptcompress)
- * because of compatibility reasons (see http://dev.namesys.com/Version4.X.Y
- * for details).
- *
- * The conversion is accompanied by rebuilding disk structures of a file, so it
- * is important to protect them from being interacted with other plugins which
- * don't expect them to be in such inconsistent state. For this to be protected
- * we serialize readers and writers of a file's conversion set (FCS).
- *
- * We define FCS as a file plugin installed in inode's pset plus file's data
- * and metadata that this file plugin manipulates with (items, etc).
- * Note, that FCS is defined per file.
- * FCS reader is defined as a set of instruction of the following type:
- * {inode_file_plugin(inode)->method()} (I.e. retrieving a file plugin id
- * conjoined with all method's instructions should be atomic).
- * FCS writer is a set of instructions that perform file plugin conversion
- * (convert items, update pset, etc).
- * Example:
- * reiser4_write_careful() supplied to VFS as a ->write() file operation is
- * composed of the following (optional) instructions:
- *             1              2                         3
- * *********************** ####### -------------------------------------------->
- *
- * 1) "****" are instructions performed on behalf of cryptcompress file plugin;
- * 2) "####" is a FCS writer (performing a conversion cryptcompress->unix_file);
- * 3) "----" are instructions performed on behalf of unix_file plugin;
- * Here (1) and (3) are FCS readers.
- *
- * In this example FCS readers and writers are already serialized (by design),
- * however there can be readers and writers executing at the same time in
- * different contexts, so we need a common mechanism of serialization.
- *
- * Currently serialization of FCS readers and writers is performed via acquiring
- * a special per-inode rw-semaphore (conv_sem). And yes, {down, up}_read is for
- * FCS readers, and  {down, up}_write is for FCS writers, see the macros below
- * for passive/active protection.
- *
- * ---
- * (*)  This heuristic can be changed to a better one (benchmarking is needed).
- * (**) Such technique allows to keep enable/disable state on disk.
+ * Dispatching hook makes a decision (at dispatching point) about the
+ * most reasonable plugin. Such decision is made in accordance with some
+ * O(1)-heuristic.
+ *
+ * We implement a transition CRYPTCOMPRESS -> UNIX_FILE for files with
+ * incompressible data. Current heuristic to estimate compressibility is
+ * very simple: if first complete logical cluster (64K by default) of a
+ * file is incompressible, then we make a decision, that the whole file
+ * is incompressible.
+ *
+ * To enable dispatching we install a special "magic" compression mode
+ * plugin CONVX_COMPRESSION_MODE_ID at file creation time.
+ *
+ * Note, that we don't perform back conversion (UNIX_FILE->CRYPTCOMPRESS)
+ * because of compatibility reasons).
+ *
+ * In conversion time we protect CS, the conversion set (file's (meta)data
+ * and plugin table (pset)) via special per-inode rw-semaphore (conv_sem).
+ * The methods which implement conversion are CS writers. The methods of FS
+ * interface (file_operations, inode_operations, address_space_operations)
+ * are CS readers.
  */
 
 #include "../../inode.h"
@@ -212,11 +180,11 @@ static int disable_conversion(struct ino
 /**
  * Check if we really have achieved plugin scheduling point
  */
-static int check_psched_point(struct inode * inode,
-			      loff_t pos /* position in the
-					    file to write from */,
-			      struct cluster_handle * clust,
-			      struct psched_context * cont)
+static int check_dispatch_point(struct inode * inode,
+				loff_t pos /* position in the
+					      file to write from */,
+				struct cluster_handle * clust,
+				struct dispatch_context * cont)
 {
 	assert("edward-1505", conversion_enabled(inode));
 	/*
@@ -241,9 +209,9 @@ static int check_psched_point(struct ino
 	       pos == inode->i_size &&
 	       pos == inode_cluster_size(inode));
 	assert("edward-1539", cont != NULL);
-	assert("edward-1540", cont->state == PSCHED_INVAL_STATE);
+	assert("edward-1540", cont->state == DISPATCH_INVAL_STATE);
 
-	cont->state = PSCHED_SCHED_POINT;
+	cont->state = DISPATCH_POINT;
 	return 0;
 }
 
@@ -301,14 +269,14 @@ static int prepped_dclust_ok(hint_t * hi
  */
 static int read_check_compressibility(struct inode * inode,
 				      struct cluster_handle * clust,
-				      struct psched_context * cont)
+				      struct dispatch_context * cont)
 {
 	int i;
 	int result;
 	__u32 dst_len;
 	hint_t tmp_hint;
 	hint_t * cur_hint = clust->hint;
-	assert("edward-1541", cont->state == PSCHED_SCHED_POINT);
+	assert("edward-1541", cont->state == DISPATCH_POINT);
 
 	start_check_compressibility(inode, clust, &tmp_hint);
 
@@ -373,8 +341,8 @@ static int read_check_compressibility(st
 	finish_check_compressibility(inode, clust, cur_hint);
 	cont->state =
 		(data_is_compressible(dst_len, inode_cluster_size(inode)) ?
-		 PSCHED_REMAINS_OLD :
-		 PSCHED_ASSIGNED_NEW);
+		 DISPATCH_REMAINS_OLD :
+		 DISPATCH_ASSIGNED_NEW);
 	return 0;
  error:
 	put_page_cluster(clust, inode, READ_OP);
@@ -433,8 +401,8 @@ static int reserve_cryptcompress2unixfil
 /**
  * Convert cryptcompress file plugin to unix_file plugin.
  */
-static int cryptcompress2unixfile(struct file * file, struct inode * inode,
-				  struct psched_context * cont)
+static int cryptcompress2unixfile(struct file *file, struct inode *inode,
+				  struct dispatch_context *cont)
 {
 	int i;
 	int result = 0;
@@ -490,28 +458,28 @@ static int cryptcompress2unixfile(struct
  * Make a decision about the most reasonable file plugin id to manage
  * the file.
  */
-int write_pschedule_hook(struct file * file, struct inode * inode,
-			 loff_t pos, struct cluster_handle * clust,
-			 struct psched_context * cont)
+int write_dispatch_hook(struct file *file, struct inode *inode,
+			loff_t pos, struct cluster_handle *clust,
+			struct dispatch_context *cont)
 {
 	int result;
 	if (!conversion_enabled(inode))
 		return 0;
-	result = check_psched_point(inode, pos, clust, cont);
-	if (result || cont->state != PSCHED_SCHED_POINT)
+	result = check_dispatch_point(inode, pos, clust, cont);
+	if (result || cont->state != DISPATCH_POINT)
 		return result;
 	result = read_check_compressibility(inode, clust, cont);
 	if (result)
 		return result;
-	if (cont->state == PSCHED_REMAINS_OLD) {
+	if (cont->state == DISPATCH_REMAINS_OLD) {
 		put_page_cluster(clust, inode, READ_OP);
 		return disable_conversion(inode);
 	}
-	assert("edward-1543", cont->state == PSCHED_ASSIGNED_NEW);
+	assert("edward-1543", cont->state == DISPATCH_ASSIGNED_NEW);
 	/*
 	 * page cluster is grabbed and uptodate. It will be
 	 * released with a pgset after plugin conversion is
-	 * finished, see put_psched_context().
+	 * finished, see put_dispatch_context().
 	 */
 	reiser4_unset_hint(clust->hint);
 	move_cluster_pgset(clust, &cont->pages, &cont->nr_pages);
@@ -521,20 +489,20 @@ int write_pschedule_hook(struct file * f
 /**
  * This is called by ->setattr() method of cryptcompress file plugin.
  */
-int setattr_pschedule_hook(struct inode * inode)
+int setattr_dispatch_hook(struct inode * inode)
 {
 	if (conversion_enabled(inode))
 		return disable_conversion(inode);
 	return 0;
 }
 
-static inline void init_psched_context(struct psched_context * cont)
+static inline void init_dispatch_context(struct dispatch_context * cont)
 {
 	memset(cont, 0, sizeof(*cont));
 }
 
-static inline void done_psched_context(struct psched_context * cont,
-				       struct inode * inode)
+static inline void done_dispatch_context(struct dispatch_context * cont,
+					 struct inode * inode)
 {
 	if (cont->pages) {
 		__put_page_cluster(0, cont->nr_pages, cont->pages, inode);
@@ -564,13 +532,13 @@ ssize_t reiser4_write_careful(struct fil
 	reiser4_context *ctx;
 	ssize_t written_old = 0; /* bytes written with initial plugin */
 	ssize_t written_new = 0; /* bytes written with new plugin */
-	struct psched_context cont;
+	struct dispatch_context cont;
 	struct inode * inode = file->f_dentry->d_inode;
 
 	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
-	init_psched_context(&cont);
+	init_dispatch_context(&cont);
 	mutex_lock(&inode->i_mutex);
 	/**
 	 * First step.
@@ -582,7 +550,7 @@ ssize_t reiser4_write_careful(struct fil
 						      count,
 						      off,
 						      &cont);
-	if (cont.state != PSCHED_ASSIGNED_NEW || written_old < 0)
+	if (cont.state != DISPATCH_ASSIGNED_NEW || written_old < 0)
 		goto exit;
 	/**
 	 * Second step.
@@ -616,7 +584,7 @@ ssize_t reiser4_write_careful(struct fil
 						      NULL);
  exit:
 	mutex_unlock(&inode->i_mutex);
-	done_psched_context(&cont, inode);
+	done_dispatch_context(&cont, inode);
 	reiser4_exit_context(ctx);
 
 	return written_old + (written_new < 0 ? 0 : written_new);
diff -puN fs/reiser4/plugin/plugin.h~reiser4-rename-psched-to-dispatch fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-rename-psched-to-dispatch
+++ a/fs/reiser4/plugin/plugin.h
@@ -235,7 +235,7 @@ typedef struct file_plugin {
 	 * in @cont */
 	ssize_t (*write) (struct file *, const char __user *buf,
 			  size_t write_amount, loff_t * off,
-			  struct psched_context * cont);
+			  struct dispatch_context * cont);
 	int (*ioctl) (struct inode *inode, struct file *filp,
 		      unsigned int cmd, unsigned long arg);
 	int (*mmap) (struct file *, struct vm_area_struct *);
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-improve-writeback_inodes_wb.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch
reiser4-rename-psched-to-dispatch.patch
reiser4-drop-journal-info.patch
reiser4-fix-compile-warnings.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup.patch
reiser4-some-changes-from-reiser4-2631-patch.patch
reiser4-some-comments-were-still-mentioning-pdflush.patch
reiser4-writeback_inodes-implementation.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch


From: akpm@linux-foundation.org
Subject: - reiser4-drop-unused-semaphores.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:04:51 -0800
Message-ID: <200703060204.l2624pFj008857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46816 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965738AbXCFCE6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:04:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: drop unused semaphores
has been removed from the -mm tree.  Its filename was
     reiser4-drop-unused-semaphores.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: drop unused semaphores
From: Edward Shishkin <edward@namesys.com>

. Drop artefact semaphores:
   - mutex_write (in common part of reiser4 inode)
   - lock (in cryptcompress specific part of reiser4 inode)

. Add missed remove_suid() in write_cryptcompress()

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/inode.h                       |   11 -----
 fs/reiser4/plugin/file/cryptcompress.c   |   46 +++++----------------
 fs/reiser4/plugin/file/cryptcompress.h   |    1 
 fs/reiser4/plugin/file/file.c            |    9 ----
 fs/reiser4/plugin/file/file_conversion.c |    3 -
 fs/reiser4/plugin/item/extent_file_ops.c |    2 
 fs/reiser4/super_ops.c                   |    1 
 7 files changed, 13 insertions(+), 60 deletions(-)

diff -puN fs/reiser4/inode.h~reiser4-drop-unused-semaphores fs/reiser4/inode.h
--- a/fs/reiser4/inode.h~reiser4-drop-unused-semaphores
+++ a/fs/reiser4/inode.h
@@ -136,17 +136,6 @@ struct reiser4_inode {
 		cryptcompress_info_t cryptcompress_info;
 	} file_plugin_data;
 
- 	/* this semaphore is used to serialize writes of any file plugin,
-	 * and should be invariant during file plugin conversion (which
-	 * is going in the context of ->write()).
- 	 * inode->i_mutex can not be used for the serialization, because
- 	 * write_unix_file uses get_user_pages which is to be used under
- 	 * mm->mmap_sem and because it is required to take mm->mmap_sem before
- 	 * inode->i_mutex, so inode->i_mutex would have to be up()-ed before
- 	 * calling to get_user_pages which is unacceptable.
-	 */
- 	struct semaphore mutex_write;
-
 	/* this semaphore is to serialize readers and writers of @pset->file
 	 * when file plugin conversion is enabled
 	 */
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-drop-unused-semaphores fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-drop-unused-semaphores
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -38,7 +38,6 @@ void init_inode_data_cryptcompress(struc
 
 	memset(data, 0, sizeof(*data));
 
-	init_rwsem(&data->lock);
 	toggle_compression(data, 1);
 	init_inode_ordering(inode, crd, create);
 }
@@ -2783,24 +2782,28 @@ ssize_t write_cryptcompress(struct file 
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-  	down(&reiser4_inode_data(inode)->mutex_write);
+ 	mutex_lock(&inode->i_mutex);
 
 	result = generic_write_checks(file, &pos, &count, 0);
   	if (unlikely(result != 0))
 		goto out;
   	if (unlikely(count == 0))
 		goto out;
-	down_write(&info->lock);
+	result = remove_suid(file->f_dentry);
+	if (unlikely(result != 0))
+		goto out;
+	/* remove_suid might create a transaction */
+	reiser4_txn_restart(ctx);
+
 	result = write_cryptcompress_flow(file, inode, buf, count, pos, conv);
-  	if (*conv == 0)
-  		up_write(&info->lock);
 
   	if (result < 0)
 		goto out;
   	/* update position in a file */
   	*off = pos + result;
  out:
-	up(&reiser4_inode_data(inode)->mutex_write);
+	mutex_unlock(&inode->i_mutex);
+
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
 	return result;
@@ -2871,12 +2874,10 @@ ssize_t read_cryptcompress(struct file *
 		return result;
 	}
 
-	down_read(&info->lock);
 	LOCK_CNT_INC(inode_sem_r);
 
 	result = do_sync_read(file, buf, size, off);
 
-	up_read(&info->lock);
 	LOCK_CNT_DEC(inode_sem_r);
 
 	context_set_commit_async(ctx);
@@ -3562,16 +3563,6 @@ writepages_cryptcompress(struct address_
 	do {
 		reiser4_context *ctx;
 
-		if (is_in_reiser4_context()) {
-			/* It can be in the context of write system call from
-			   balance_dirty_pages() */
-			if (down_read_trylock(&info->lock) == 0) {
-				result = RETERR(-EBUSY);
-				break;
-			}
-		} else
-			down_read(&info->lock);
-
 		ctx = reiser4_init_context(inode->i_sb);
 		if (IS_ERR(ctx)) {
 			result = PTR_ERR(ctx);
@@ -3588,10 +3579,6 @@ writepages_cryptcompress(struct address_
 		    capture_anonymous_clusters(inode->i_mapping, &index,
 					       to_capture);
 
-		up_read(&info->lock);
-
-		LOCK_CNT_DEC(inode_sem_r);
-
 		if (result != 0 || wbc->sync_mode != WB_SYNC_ALL) {
 			reiser4_exit_context(ctx);
 			break;
@@ -3647,13 +3634,12 @@ int mmap_cryptcompress(struct file *file
 int delete_object_cryptcompress(struct inode *inode)
 {
 	int result;
-	cryptcompress_info_t *info = cryptcompress_inode_data(inode);
+
 	assert("edward-429", inode->i_nlink == 0);
 
 	reiser4_txn_restart_current();
-	down_write(&info->lock);
+
 	result = cryptcompress_truncate(inode, 0, 0);
-	up_write(&info->lock);
 	if (result) {
 		warning("edward-430",
 			"cannot truncate cryptcompress file  %lli: %i",
@@ -3677,16 +3663,11 @@ int setattr_cryptcompress(struct dentry 
 		if (inode->i_size != attr->ia_size) {
 			reiser4_context *ctx;
 			loff_t old_size;
-			cryptcompress_info_t *info =
-			    cryptcompress_inode_data(inode);
 
 			ctx = reiser4_init_context(dentry->d_inode->i_sb);
 			if (IS_ERR(ctx))
 				return PTR_ERR(ctx);
 
-			down_write(&info->lock);
-			LOCK_CNT_INC(inode_sem_w);
-
 			inode_check_scale(inode, inode->i_size, attr->ia_size);
 
 			old_size = inode->i_size;
@@ -3702,8 +3683,6 @@ int setattr_cryptcompress(struct dentry 
 					get_inode_oid(inode), old_size,
 					attr->ia_size, result);
 			}
-			up_write(&info->lock);
-			LOCK_CNT_DEC(inode_sem_w);
 			context_set_commit_async(ctx);
 			reiser4_exit_context(ctx);
 		} else
@@ -3736,9 +3715,8 @@ sendfile_cryptcompress(struct file *file
 	if (result)
 		goto exit;
 	info = cryptcompress_inode_data(inode);
-	down_read(&info->lock);
+
 	result = generic_file_sendfile(file, ppos, count, actor, target);
-	up_read(&info->lock);
  exit:
 	reiser4_exit_context(ctx);
 	return result;
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-drop-unused-semaphores fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-drop-unused-semaphores
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -445,7 +445,6 @@ static inline void dec_keyload_count(cry
 
 /* cryptcompress specific part of reiser4_inode */
 typedef struct cryptcompress_info {
-	struct rw_semaphore lock;
 	crypto_stat_t *crypt;
 	int compress_toggle;      /* current status of compressibility
 				     is set by compression mode plugin */
diff -puN fs/reiser4/plugin/file/file.c~reiser4-drop-unused-semaphores fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-drop-unused-semaphores
+++ a/fs/reiser4/plugin/file/file.c
@@ -1933,7 +1933,6 @@ int mmap_unix_file(struct file *file, st
 
 	uf_info = unix_file_inode_data(inode);
 
-	down(&reiser4_inode_data(inode)->mutex_write);
 	get_exclusive_access(uf_info);
 
 	if (!IS_RDONLY(inode) && (vma->vm_flags & (VM_MAYWRITE | VM_SHARED))) {
@@ -1945,7 +1944,6 @@ int mmap_unix_file(struct file *file, st
 		result = find_file_state(inode, uf_info);
 		if (result != 0) {
 			drop_exclusive_access(uf_info);
-			up(&reiser4_inode_data(inode)->mutex_write);
 			reiser4_exit_context(ctx);
 			return result;
 		}
@@ -1961,7 +1959,6 @@ int mmap_unix_file(struct file *file, st
 			result = check_pages_unix_file(file, inode);
 			if (result) {
 				drop_exclusive_access(uf_info);
-				up(&reiser4_inode_data(inode)->mutex_write);
 				reiser4_exit_context(ctx);
 				return result;
 			}
@@ -1976,7 +1973,6 @@ int mmap_unix_file(struct file *file, st
 	result = reiser4_grab_space_force(needed, BA_CAN_COMMIT);
 	if (result) {
 		drop_exclusive_access(uf_info);
-		up(&reiser4_inode_data(inode)->mutex_write);
 		reiser4_exit_context(ctx);
 		return result;
 	}
@@ -1988,7 +1984,6 @@ int mmap_unix_file(struct file *file, st
 	}
 
 	drop_exclusive_access(uf_info);
-	up(&reiser4_inode_data(inode)->mutex_write);
 	reiser4_exit_context(ctx);
 	return result;
 }
@@ -2368,7 +2363,6 @@ int release_unix_file(struct inode *inod
 	if (in_reiser4 == 0) {
 		uf_info = unix_file_inode_data(inode);
 
-		down(&reiser4_inode_data(inode)->mutex_write);
 		get_exclusive_access(uf_info);
 		if (atomic_read(&file->f_dentry->d_count) == 1 &&
 		    uf_info->container == UF_CONTAINER_EXTENTS &&
@@ -2384,7 +2378,6 @@ int release_unix_file(struct inode *inod
 			}
 		}
 		drop_exclusive_access(uf_info);
-		up(&reiser4_inode_data(inode)->mutex_write);
 	} else {
 		/*
 		   we are within reiser4 context already. How latter is
@@ -2679,11 +2672,9 @@ int setattr_unix_file(struct dentry *den
 			return PTR_ERR(ctx);
 
 		uf_info = unix_file_inode_data(dentry->d_inode);
-		down(&reiser4_inode_data(dentry->d_inode)->mutex_write);
 		get_exclusive_access(uf_info);
 		result = setattr_truncate(dentry->d_inode, attr);
 		drop_exclusive_access(uf_info);
-		up(&reiser4_inode_data(dentry->d_inode)->mutex_write);
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
 	} else
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-drop-unused-semaphores fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-drop-unused-semaphores
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -443,14 +443,12 @@ static int cryptcompress2unixfile(struct
 	   reserved disk space) were released by ->kill_hook() method
 	   of the item plugin */
 
-	up_write(&cr_info->lock);
 	result = __cryptcompress2unixfile(file, inode);
 	if (result)
 		goto out;
 	/* At this point file is managed by unix file plugin */
 
 	uf_info = unix_file_inode_data(inode);
-	//	get_exclusive_access(uf_info);
 
 	assert("edward-1518",
 	       ergo(jprivate(clust->pages[0]),
@@ -467,7 +465,6 @@ static int cryptcompress2unixfile(struct
 		uf_info->container = UF_CONTAINER_EXTENTS;
 		complete_file_conversion(inode);
 	}
-	//	drop_exclusive_access(uf_info);
  out:
 	all_grabbed2free();
 	if (result)
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-drop-unused-semaphores fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-drop-unused-semaphores
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1030,9 +1030,9 @@ ssize_t reiser4_write_extent(struct file
 				/* wait for read completion */
 				lock_page(page);
 				BUG_ON(!PageUptodate(page));
-				unlock_page(page);
 			} else
 				result = 0;
+			unlock_page(page);
 		}
 
 		BUG_ON(get_current_context()->trans->atom != NULL);
diff -puN fs/reiser4/super_ops.c~reiser4-drop-unused-semaphores fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-drop-unused-semaphores
+++ a/fs/reiser4/super_ops.c
@@ -44,7 +44,6 @@ static void init_once(void *obj, struct 
 		 * etc. that will be added to our private inode part.
 		 */
 		INIT_LIST_HEAD(get_readdir_list(&info->vfs_inode));
-		sema_init(&info->p.mutex_write, 1);
 		init_rwsem(&info->p.conv_sem);
 		/* init semaphore which is used during inode loading */
 		loading_init_once(&info->p);
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch

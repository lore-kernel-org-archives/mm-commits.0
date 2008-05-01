From: akpm@linux-foundation.org
Subject: - reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:36 -0700
Message-ID: <200805010923.m419NaDp030106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757564AbYEAJk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix null pointer dereference in reiser4_write_extent
has been removed from the -mm tree.  Its filename was
     reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: fix null pointer dereference in reiser4_write_extent
From: Edward Shishkin <edward.shishkin@gmail.com>

Problem:
Oops when starting kde4:
BUG: unable to handle kernel NULL pointer dereference
at virtual address 0000000c
printing eip: c025eba5 *pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /devices/pci0000:00/0000:00:1e.0/0000:04:04.0/resource
Modules linked in: thermal processor fan button

Pid: 3705, comm: kwrite Not tainted (2.6.23-mm1 #8)
EIP: 0060:[<c025eba5>] EFLAGS: 00010246 CPU: 0
EIP is at update_extents+0x44/0x2e7

Bug:
Trying to look at not persistent struct file in the
case of expanded truncate via sys_truncate64(path, length).

The fixup:
. Don't look at struct file at truncate_file_body();
. Add an inode *inode argument to the following
  functions to handle the case of not persistent
  struct file.
  . reiser4_write_extent();
  . reiser4_write_tail();
  . reiser4_update_extents();
Other changes:
. Add missesd identifier in some asserts.
. Comments cleanups.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c   |    8 -
 fs/reiser4/plugin/file/file.c            |  115 +++++++++++----------
 fs/reiser4/plugin/file/file.h            |    8 -
 fs/reiser4/plugin/file/tail_conversion.c |    2 
 fs/reiser4/plugin/item/extent.h          |    4 
 fs/reiser4/plugin/item/extent_file_ops.c |   15 +-
 fs/reiser4/plugin/item/item.h            |    3 
 fs/reiser4/plugin/item/tail.c            |    9 -
 fs/reiser4/plugin/item/tail.h            |    4 
 9 files changed, 86 insertions(+), 82 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -3198,11 +3198,11 @@ static int cryptcompress_append_hole(str
 	return result;
 }
 
-static int
-update_cryptcompress_size(struct inode *inode, reiser4_key * key, int update_sd)
+static int update_cryptcompress_size(struct inode *inode, loff_t new_size,
+				     int update_sd)
 {
-	return (get_key_offset(key) & ((loff_t) (inode_cluster_size(inode)) - 1)
-		? 0 : reiser4_update_file_size(inode, key, update_sd));
+	return (new_size & ((loff_t) (inode_cluster_size(inode)) - 1)
+		? 0 : reiser4_update_file_size(inode, new_size, update_sd));
 }
 
 /* Prune cryptcompress file in two steps:
diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent
+++ a/fs/reiser4/plugin/file/file.c
@@ -328,9 +328,14 @@ static int find_file_state(struct inode 
 	return result;
 }
 
-/* estimate and reserve space needed to truncate page which gets partially truncated: one block for page itself, stat
-   data update (estimate_one_insert_into_item) and one item insertion (estimate_one_insert_into_item) which may happen
-   if page corresponds to hole extent and unallocated one will have to be created */
+/**
+ * Estimate and reserve space needed to truncate page
+ * which gets partially truncated: one block for page
+ * itself, stat-data update (estimate_one_insert_into_item)
+ * and one item insertion (estimate_one_insert_into_item)
+ * which may happen if page corresponds to hole extent and
+ * unallocated one will have to be created
+ */
 static int reserve_partial_page(reiser4_tree * tree)
 {
 	grab_space_enable();
@@ -355,12 +360,12 @@ static int reserve_cut_iteration(reiser4
 				     BA_CAN_COMMIT);
 }
 
-int reiser4_update_file_size(struct inode *inode, reiser4_key * key,
+int reiser4_update_file_size(struct inode *inode, loff_t new_size,
 			     int update_sd)
 {
 	int result = 0;
 
-	INODE_SET_SIZE(inode, get_key_offset(key));
+	INODE_SET_SIZE(inode, new_size);
 	if (update_sd) {
 		inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 		result = reiser4_update_sd(inode);
@@ -368,12 +373,14 @@ int reiser4_update_file_size(struct inod
 	return result;
 }
 
-/* cut file items one by one starting from the last one until new file size (inode->i_size) is reached. Reserve space
-   and update file stat data on every single cut from the tree */
-int
-cut_file_items(struct inode *inode, loff_t new_size, int update_sd,
-	       loff_t cur_size, int (*update_actor) (struct inode *,
-						     reiser4_key *, int))
+/**
+ * Cut file items one by one starting from the last one until
+ * new file size (inode->i_size) is reached. Reserve space
+ * and update file stat data on every single cut from the tree
+ */
+int cut_file_items(struct inode *inode, loff_t new_size,
+		   int update_sd, loff_t cur_size,
+		   int (*update_actor) (struct inode *, loff_t, int))
 {
 	reiser4_key from_key, to_key;
 	reiser4_key smallest_removed;
@@ -398,21 +405,25 @@ cut_file_items(struct inode *inode, loff
 						 &smallest_removed, inode, 1,
 						 &progress);
 		if (result == -E_REPEAT) {
-			/* -E_REPEAT is a signal to interrupt a long file truncation process */
+			/**
+			 * -E_REPEAT is a signal to interrupt a long
+			 * file truncation process
+			 */
 			if (progress) {
-				result =
-				    update_actor(inode, &smallest_removed,
-						 update_sd);
+				result = update_actor(inode,
+					      get_key_offset(&smallest_removed),
+					      update_sd);
 				if (result)
 					break;
 			}
-
-			/* the below does up(sbinfo->delete_mutex). Do not get folled */
+			/* the below does up(sbinfo->delete_mutex).
+			 * Do not get folled */
 			reiser4_release_reserved(inode->i_sb);
-
-			/* reiser4_cut_tree_object() was interrupted probably because
-			 * current atom requires commit, we have to release
-			 * transaction handle to allow atom commit. */
+			/**
+			 * reiser4_cut_tree_object() was interrupted probably
+			 * because current atom requires commit, we have to
+			 * release transaction handle to allow atom commit.
+			 */
 			reiser4_txn_restart_current();
 			continue;
 		}
@@ -423,7 +434,8 @@ cut_file_items(struct inode *inode, loff
 
 		set_key_offset(&smallest_removed, new_size);
 		/* Final sd update after the file gets its correct size */
-		result = update_actor(inode, &smallest_removed, update_sd);
+		result = update_actor(inode, get_key_offset(&smallest_removed),
+				      update_sd);
 		break;
 	}
 
@@ -573,11 +585,8 @@ static int truncate_file_body(struct ino
 
 	if (inode->i_size < new_size) {
 		/* expanding truncate */
-		struct file * file = attr->ia_file;
 		struct unix_file_info *uf_info = unix_file_inode_data(inode);
 
-		assert("edward-1532", attr->ia_valid & ATTR_FILE);
-
 		result = find_file_state(inode, uf_info);
 		if (result)
 			return result;
@@ -610,31 +619,28 @@ static int truncate_file_body(struct ino
 						return result;
 				}
 			}
-			result = reiser4_write_extent(file, NULL, 0,
-						      &new_size);
+			result = reiser4_write_extent(NULL, inode, NULL,
+						      0, &new_size);
 			if (result)
 				return result;
 			uf_info->container = UF_CONTAINER_EXTENTS;
 		} else {
 			if (uf_info->container ==  UF_CONTAINER_EXTENTS) {
-				result = reiser4_write_extent(file, NULL, 0,
-							      &new_size);
+				result = reiser4_write_extent(NULL, inode, NULL,
+							      0, &new_size);
 				if (result)
 					return result;
 			} else {
-				result = reiser4_write_tail(file, NULL, 0,
-							    &new_size);
+				result = reiser4_write_tail(NULL, inode, NULL,
+							    0, &new_size);
 				if (result)
 					return result;
 				uf_info->container = UF_CONTAINER_TAILS;
 			}
 		}
 		BUG_ON(result > 0);
-		INODE_SET_FIELD(inode, i_size, new_size);
-		file_update_time(file);
-		result = reiser4_update_sd(inode);
+		result = reiser4_update_file_size(inode, new_size, 1);
 		BUG_ON(result != 0);
-		reiser4_free_file_fsdata(file);
 	} else
 		result = shorten_file(inode, new_size);
 	return result;
@@ -771,13 +777,10 @@ hint_validate(hint_t * hint, const reise
 }
 
 /**
- * find_or_create_extent -
- * @page:
- *
- *
+ * Look for place at twig level for extent corresponding to page,
+ * call extent's writepage method to create unallocated extent if
+ * it does not exist yet, initialize jnode, capture page
  */
-/* look for place at twig level for extent corresponding to page, call extent's writepage method to create
-   unallocated extent if it does not exist yet, initialize jnode, capture page */
 int find_or_create_extent(struct page *page)
 {
 	int result;
@@ -805,7 +808,8 @@ int find_or_create_extent(struct page *p
 		if (result) {
  			JF_CLR(node, JNODE_WRITE_PREPARED);
 			jput(node);
-			warning("", "reiser4_update_extent failed: %d", result);
+			warning("edward-1549",
+				"reiser4_update_extent failed: %d", result);
 			return result;
 		}
 		if (plugged_hole)
@@ -1138,12 +1142,13 @@ static int sync_page_list(struct inode *
 		found =
 		    radix_tree_gang_lookup(&mapping->page_tree, (void **)&page,
 					   from, 1);
-		assert("", found < 2);
+		assert("edward-1550", found < 2);
 		if (found == 0)
 			break;
-
-		/* page may not leave radix tree because it is protected from truncating by inode->i_mutex locked by
-		   sys_fsync */
+		/**
+		 * page may not leave radix tree because it is protected from
+		 * truncating by inode->i_mutex locked by sys_fsync
+		 */
 		page_cache_get(page);
 		read_unlock_irq(&mapping->tree_lock);
 
@@ -1270,8 +1275,8 @@ int writepages_unix_file(struct address_
 		/* avoid recursive calls to ->sync_inodes */
 		ctx->nobalance = 1;
 		assert("zam-760", lock_stack_isclean(get_current_lock_stack()));
-		assert("", LOCK_CNT_NIL(inode_sem_w));
-		assert("", LOCK_CNT_NIL(inode_sem_r));
+		assert("edward-1551", LOCK_CNT_NIL(inode_sem_w));
+		assert("edward-1552", LOCK_CNT_NIL(inode_sem_r));
 
 		reiser4_txn_restart_current();
 
@@ -2097,7 +2102,8 @@ ssize_t write_unix_file(struct file *fil
 	int try_free_space;
 	int to_write = PAGE_CACHE_SIZE * WRITE_GRANULARITY;
 	size_t left;
-	ssize_t (*write_op)(struct file *, const char __user *, size_t,
+	ssize_t (*write_op)(struct file *, struct inode *,
+			    const char __user *, size_t,
 			    loff_t *pos);
 	int ea;
 	loff_t new_size;
@@ -2212,7 +2218,7 @@ ssize_t write_unix_file(struct file *fil
 			write_op = reiser4_write_tail;
 		}
 
-		written = write_op(file, buf, to_write, pos);
+		written = write_op(file, inode, buf, to_write, pos);
 		if (written == -ENOSPC && try_free_space) {
 			drop_access(uf_info);
 			txnmgr_force_commit_all(inode->i_sb, 0);
@@ -2226,14 +2232,14 @@ ssize_t write_unix_file(struct file *fil
 		}
 		/* something is written. */
 		if (uf_info->container == UF_CONTAINER_EMPTY) {
-			assert("", ea == EA_OBTAINED);
+			assert("edward-1553", ea == EA_OBTAINED);
 			uf_info->container =
 				(write_op == reiser4_write_extent) ?
 				UF_CONTAINER_EXTENTS : UF_CONTAINER_TAILS;
 		} else {
-			assert("", ergo(uf_info->container == UF_CONTAINER_EXTENTS,
+			assert("edward-1554", ergo(uf_info->container == UF_CONTAINER_EXTENTS,
 					write_op == reiser4_write_extent));
-			assert("", ergo(uf_info->container == UF_CONTAINER_TAILS,
+			assert("edward-1555", ergo(uf_info->container == UF_CONTAINER_TAILS,
 					write_op == reiser4_write_tail));
 		}
 		if (*pos + written > inode->i_size)
@@ -2669,7 +2675,8 @@ int delete_object_unix_file(struct inode
 	drop_exclusive_access(uf_info);
 
 	if (result)
-		warning("", "failed to truncate file (%llu) on removal: %d",
+		warning("edward-1556",
+			"failed to truncate file (%llu) on removal: %d",
 			get_inode_oid(inode), result);
 
 	/* remove stat data and safe link */
diff -puN fs/reiser4/plugin/file/file.h~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent
+++ a/fs/reiser4/plugin/file/file.h
@@ -280,10 +280,10 @@ void reiser4_set_hint(hint_t *, const re
 int hint_is_set(const hint_t *);
 void reiser4_unset_hint(hint_t *);
 
-int reiser4_update_file_size(struct inode *, reiser4_key *, int update_sd);
-int cut_file_items(struct inode *, loff_t new_size, int update_sd,
-		   loff_t cur_size, int (*update_actor) (struct inode *,
-							 reiser4_key *, int));
+int reiser4_update_file_size(struct inode *, loff_t, int update_sd);
+int cut_file_items(struct inode *, loff_t new_size,
+		   int update_sd, loff_t cur_size,
+		   int (*update_actor) (struct inode *, loff_t, int));
 #if REISER4_DEBUG
 
 /* return 1 is exclusive access is obtained, 0 - otherwise */
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -651,7 +651,7 @@ int extent2tail(struct file * file, stru
 			assert("edward-1538",
 			       file->f_dentry->d_inode == inode);
 
-			result = reiser4_write_tail(file,
+			result = reiser4_write_tail(file, inode,
 						    (char __user *)kmap(page),
 						    count, &pos);
 			reiser4_free_file_fsdata(file);
diff -puN fs/reiser4/plugin/item/extent.h~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent fs/reiser4/plugin/item/extent.h
--- a/fs/reiser4/plugin/item/extent.h~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent
+++ a/fs/reiser4/plugin/item/extent.h
@@ -131,8 +131,8 @@ void item_stat_extent(const coord_t * co
 int reiser4_check_extent(const coord_t * coord, const char **error);
 
 /* plugin->u.item.s.file.* */
-ssize_t reiser4_write_extent(struct file *, const char __user *,
-			     size_t, loff_t *);
+ssize_t reiser4_write_extent(struct file *, struct inode * inode,
+			     const char __user *, size_t, loff_t *);
 int reiser4_read_extent(struct file *, flow_t *, hint_t *);
 int reiser4_readpage_extent(void *, struct page *);
 int reiser4_do_readpage_extent(reiser4_extent*, reiser4_block_nr, struct page*);
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -814,9 +814,9 @@ int reiser4_update_extent(struct inode *
  * @off:
  *
  */
-static int update_extents(struct file *file, jnode **jnodes, int count, loff_t pos)
+static int update_extents(struct file *file, struct inode *inode,
+			  jnode **jnodes, int count, loff_t pos)
 {
-	struct inode *inode;
 	struct hint hint;
 	reiser4_key key;
 	int result;
@@ -825,7 +825,6 @@ static int update_extents(struct file *f
 	result = load_file_hint(file, &hint);
 	BUG_ON(result != 0);
 
-	inode = file->f_dentry->d_inode;
 	if (count != 0)
 		/*
 		 * count == 0 is special case: expanding truncate
@@ -969,14 +968,13 @@ filemap_copy_from_user(struct page *page
  * @pos: position in file to write to
  *
  */
-ssize_t reiser4_write_extent(struct file *file, const char __user *buf,
-			     size_t count, loff_t *pos)
+ssize_t reiser4_write_extent(struct file *file, struct inode * inode,
+			     const char __user *buf, size_t count, loff_t *pos)
 {
 	int have_to_update_extent;
 	int nr_pages, nr_dirty;
 	struct page *page;
 	jnode *jnodes[WRITE_GRANULARITY + 1];
-	struct inode *inode;
 	unsigned long index;
 	unsigned long end;
 	int i;
@@ -984,13 +982,12 @@ ssize_t reiser4_write_extent(struct file
 	size_t left, written;
 	int result = 0;
 
-	inode = file->f_dentry->d_inode;
 	if (write_extent_reserve_space(inode))
 		return RETERR(-ENOSPC);
 
 	if (count == 0) {
 		/* truncate case */
-		update_extents(file, jnodes, 0, *pos);
+		update_extents(file, inode, jnodes, 0, *pos);
 		return 0;
 	}
 
@@ -1090,7 +1087,7 @@ ssize_t reiser4_write_extent(struct file
 	}
 
 	if (have_to_update_extent) {
-		update_extents(file, jnodes, nr_dirty, *pos);
+		update_extents(file, inode, jnodes, nr_dirty, *pos);
 	} else {
 		for (i = 0; i < nr_dirty; i ++) {
 			int ret;
diff -puN fs/reiser4/plugin/item/item.h~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent fs/reiser4/plugin/item/item.h
--- a/fs/reiser4/plugin/item/item.h~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent
+++ a/fs/reiser4/plugin/item/item.h
@@ -233,7 +233,8 @@ struct dir_entry_iops {
 
 /* operations specific to items regular (unix) file metadata are built of */
 struct file_iops{
-	int (*write) (struct file *, const char __user *, size_t, loff_t *pos);
+	int (*write) (struct file *, struct inode *,
+		      const char __user *, size_t, loff_t *pos);
 	int (*read) (struct file *, flow_t *, hint_t *);
 	int (*readpage) (void *, struct page *);
 	int (*get_block) (const coord_t *, sector_t, sector_t *);
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent
+++ a/fs/reiser4/plugin/item/tail.c
@@ -626,7 +626,7 @@ static loff_t faultin_user_pages(const c
 }
 
 /**
- * reiser4_write_extent - write method of tail item plugin
+ * reiser4_write_tail - write method of tail item plugin
  * @file: file to write to
  * @buf: address of user-space buffer
  * @count: number of bytes to write
@@ -634,10 +634,9 @@ static loff_t faultin_user_pages(const c
  *
  * Returns number of written bytes or error code.
  */
-ssize_t reiser4_write_tail(struct file *file, const char __user *buf,
-			   size_t count, loff_t *pos)
+ssize_t reiser4_write_tail(struct file *file, struct inode * inode,
+			   const char __user *buf, size_t count, loff_t *pos)
 {
-	struct inode *inode;
 	struct hint hint;
 	int result;
 	flow_t flow;
@@ -645,7 +644,7 @@ ssize_t reiser4_write_tail(struct file *
 	lock_handle *lh;
 	znode *loaded;
 
-	inode = file->f_dentry->d_inode;
+	assert("edward-1548", inode != NULL);
 
 	if (write_extent_reserve_space(inode))
 		return RETERR(-ENOSPC);
diff -puN fs/reiser4/plugin/item/tail.h~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent fs/reiser4/plugin/item/tail.h
--- a/fs/reiser4/plugin/item/tail.h~reiser4-fix-null-pointer-dereference-in-reiser4_write_extent
+++ a/fs/reiser4/plugin/item/tail.h
@@ -33,8 +33,8 @@ int kill_units_tail(coord_t *, pos_in_no
 reiser4_key *unit_key_tail(const coord_t *, reiser4_key *);
 
 /* plugin->u.item.s.* */
-ssize_t reiser4_write_tail(struct file *file, const char __user *buf,
-			   size_t count, loff_t *pos);
+ssize_t reiser4_write_tail(struct file *file, struct inode * inode,
+			   const char __user *buf, size_t count, loff_t *pos);
 int reiser4_read_tail(struct file *, flow_t *, hint_t *);
 int readpage_tail(void *vp, struct page *page);
 reiser4_key *append_key_tail(const coord_t *, reiser4_key *);
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

origin.patch
reiser4.patch
reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch
reiser4-code-cleanups.patch


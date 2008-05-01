From: akpm@linux-foundation.org
Subject: - reiserfs-some-functions-mustnt-be-inline.patch removed from -mm tree
Date: Thu, 01 May 2008 01:16:08 -0700
Message-ID: <200805010816.m418G8Ld027829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYEAIQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 04:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     reiserfs: inlining cleanups
has been removed from the -mm tree.  Its filename was
     reiserfs-some-functions-mustnt-be-inline.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: inlining cleanups
From: Edward Shishkin <edward.shishkin@gmail.com>

Make the following functions static inline:

. do_balance_mark_leaf_dirty
. set_de_name_and_namelen
. comp_short_keys
. B_IS_IN_TREE
. copy_item_head
. le_key2cpu_key
. decrement_bcount

Should also fix this:

/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/do_balan.c: In function \u2018balance_leaf\u2019:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/do_balan.c:34: sorry, unimplemented: inlining failed in call to \u2018do_balance_mark_leaf_dirty\u2019: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/do_balan.c:1018: sorry, unimplemented: called from here

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/do_balan.c      |   10 ---
 fs/reiserfs/inode.c         |    8 +-
 fs/reiserfs/namei.c         |   12 ----
 fs/reiserfs/stree.c         |   77 --------------------------
 include/linux/reiserfs_fs.h |   99 +++++++++++++++++++++++++++++-----
 5 files changed, 93 insertions(+), 113 deletions(-)

diff -puN fs/reiserfs/do_balan.c~reiserfs-some-functions-mustnt-be-inline fs/reiserfs/do_balan.c
--- a/fs/reiserfs/do_balan.c~reiserfs-some-functions-mustnt-be-inline
+++ a/fs/reiserfs/do_balan.c
@@ -29,16 +29,6 @@ struct tree_balance *cur_tb = NULL;	/* d
 					   is interrupting do_balance */
 #endif
 
-inline void do_balance_mark_leaf_dirty(struct tree_balance *tb,
-				       struct buffer_head *bh, int flag)
-{
-	journal_mark_dirty(tb->transaction_handle,
-			   tb->transaction_handle->t_super, bh);
-}
-
-#define do_balance_mark_internal_dirty do_balance_mark_leaf_dirty
-#define do_balance_mark_sb_dirty do_balance_mark_leaf_dirty
-
 /* summary: 
  if deleting something ( tb->insert_size[0] < 0 )
    return(balance_leaf_when_delete()); (flag d handled here)
diff -puN fs/reiserfs/inode.c~reiserfs-some-functions-mustnt-be-inline fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-some-functions-mustnt-be-inline
+++ a/fs/reiserfs/inode.c
@@ -101,10 +101,10 @@ void make_cpu_key(struct cpu_key *key, s
 //
 // when key is 0, do not set version and short key
 //
-inline void make_le_item_head(struct item_head *ih, const struct cpu_key *key,
-			      int version,
-			      loff_t offset, int type, int length,
-			      int entry_count /*or ih_free_space */ )
+void make_le_item_head(struct item_head *ih, const struct cpu_key *key,
+		       int version,
+		       loff_t offset, int type, int length,
+		       int entry_count /*or ih_free_space */ )
 {
 	if (key) {
 		ih->ih_key.k_dir_id = cpu_to_le32(key->on_disk_key.k_dir_id);
diff -puN fs/reiserfs/namei.c~reiserfs-some-functions-mustnt-be-inline fs/reiserfs/namei.c
--- a/fs/reiserfs/namei.c~reiserfs-some-functions-mustnt-be-inline
+++ a/fs/reiserfs/namei.c
@@ -62,18 +62,6 @@ static inline void set_de_item_location(
 }
 
 // de_bh, de_ih, de_deh (points to first element of array), de_item_num is set
-inline void set_de_name_and_namelen(struct reiserfs_dir_entry *de)
-{
-	struct reiserfs_de_head *deh = de->de_deh + de->de_entry_num;
-
-	BUG_ON(de->de_entry_num >= ih_entry_count(de->de_ih));
-
-	de->de_entrylen = entry_length(de->de_bh, de->de_ih, de->de_entry_num);
-	de->de_namelen = de->de_entrylen - (de_with_sd(deh) ? SD_SIZE : 0);
-	de->de_name = B_I_PITEM(de->de_bh, de->de_ih) + deh_location(deh);
-	if (de->de_name[de->de_namelen - 1] == 0)
-		de->de_namelen = strlen(de->de_name);
-}
 
 // what entry points to
 static inline void set_de_object_key(struct reiserfs_dir_entry *de)
diff -puN fs/reiserfs/stree.c~reiserfs-some-functions-mustnt-be-inline fs/reiserfs/stree.c
--- a/fs/reiserfs/stree.c~reiserfs-some-functions-mustnt-be-inline
+++ a/fs/reiserfs/stree.c
@@ -11,18 +11,13 @@
 /*
  *  This file contains functions dealing with S+tree
  *
- * B_IS_IN_TREE
- * copy_item_head
- * comp_short_keys
  * comp_keys
  * comp_short_le_keys
- * le_key2cpu_key
  * comp_le_keys
  * bin_search
  * get_lkey
  * get_rkey
  * key_in_buffer
- * decrement_bcount
  * decrement_counters_in_path
  * reiserfs_check_path
  * pathrelse_and_restore
@@ -56,48 +51,6 @@
 #include <linux/buffer_head.h>
 #include <linux/quotaops.h>
 
-/* Does the buffer contain a disk block which is in the tree. */
-inline int B_IS_IN_TREE(const struct buffer_head *p_s_bh)
-{
-
-	RFALSE(B_LEVEL(p_s_bh) > MAX_HEIGHT,
-	       "PAP-1010: block (%b) has too big level (%z)", p_s_bh, p_s_bh);
-
-	return (B_LEVEL(p_s_bh) != FREE_LEVEL);
-}
-
-//
-// to gets item head in le form
-//
-inline void copy_item_head(struct item_head *p_v_to,
-			   const struct item_head *p_v_from)
-{
-	memcpy(p_v_to, p_v_from, IH_SIZE);
-}
-
-/* k1 is pointer to on-disk structure which is stored in little-endian
-   form. k2 is pointer to cpu variable. For key of items of the same
-   object this returns 0.
-   Returns: -1 if key1 < key2 
-   0 if key1 == key2
-   1 if key1 > key2 */
-inline int comp_short_keys(const struct reiserfs_key *le_key,
-			   const struct cpu_key *cpu_key)
-{
-	__u32 n;
-	n = le32_to_cpu(le_key->k_dir_id);
-	if (n < cpu_key->on_disk_key.k_dir_id)
-		return -1;
-	if (n > cpu_key->on_disk_key.k_dir_id)
-		return 1;
-	n = le32_to_cpu(le_key->k_objectid);
-	if (n < cpu_key->on_disk_key.k_objectid)
-		return -1;
-	if (n > cpu_key->on_disk_key.k_objectid)
-		return 1;
-	return 0;
-}
-
 /* k1 is pointer to on-disk structure which is stored in little-endian
    form. k2 is pointer to cpu variable.
    Compare keys using all 4 key fields.
@@ -150,19 +103,6 @@ inline int comp_short_le_keys(const stru
 	return 0;
 }
 
-inline void le_key2cpu_key(struct cpu_key *to, const struct reiserfs_key *from)
-{
-	int version;
-	to->on_disk_key.k_dir_id = le32_to_cpu(from->k_dir_id);
-	to->on_disk_key.k_objectid = le32_to_cpu(from->k_objectid);
-
-	// find out version of the key
-	version = le_key_version(from);
-	to->version = version;
-	to->on_disk_key.k_offset = le_key_k_offset(version, from);
-	to->on_disk_key.k_type = le_key_k_type(version, from);
-}
-
 // this does not say which one is bigger, it only returns 1 if keys
 // are not equal, 0 otherwise
 inline int comp_le_keys(const struct reiserfs_key *k1,
@@ -289,8 +229,8 @@ static inline const struct reiserfs_key 
 }
 
 /* Get delimiting key of the buffer at the path and its right neighbor. */
-inline const struct reiserfs_key *get_rkey(const struct treepath *p_s_chk_path,
-					   const struct super_block *p_s_sb)
+const struct reiserfs_key *get_rkey(const struct treepath *p_s_chk_path,
+				    const struct super_block *p_s_sb)
 {
 	int n_position, n_path_offset = p_s_chk_path->path_length;
 	struct buffer_head *p_s_parent;
@@ -359,19 +299,6 @@ static inline int key_in_buffer(struct t
 	return 1;
 }
 
-inline void decrement_bcount(struct buffer_head *p_s_bh)
-{
-	if (p_s_bh) {
-		if (atomic_read(&(p_s_bh->b_count))) {
-			put_bh(p_s_bh);
-			return;
-		}
-		reiserfs_panic(NULL,
-			       "PAP-5070: decrement_bcount: trying to free free buffer %b",
-			       p_s_bh);
-	}
-}
-
 /* Decrement b_count field of the all buffers in the path. */
 void decrement_counters_in_path(struct treepath *p_s_search_path)
 {
diff -puN include/linux/reiserfs_fs.h~reiserfs-some-functions-mustnt-be-inline include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-some-functions-mustnt-be-inline
+++ a/include/linux/reiserfs_fs.h
@@ -1770,14 +1770,37 @@ void reiserfs_release_objectid(struct re
 int reiserfs_convert_objectid_map_v1(struct super_block *);
 
 /* stree.c */
-int B_IS_IN_TREE(const struct buffer_head *);
-extern void copy_item_head(struct item_head *p_v_to,
-			   const struct item_head *p_v_from);
-
-// first key is in cpu form, second - le
-extern int comp_short_keys(const struct reiserfs_key *le_key,
-			   const struct cpu_key *cpu_key);
-extern void le_key2cpu_key(struct cpu_key *to, const struct reiserfs_key *from);
+
+/* to get item head in le form */
+static inline void copy_item_head(struct item_head *p_v_to,
+				  const struct item_head *p_v_from)
+{
+	memcpy(p_v_to, p_v_from, IH_SIZE);
+}
+
+/* first key is in cpu form, second - le */
+/* k1 is pointer to on-disk structure which is stored in little-endian
+   form. k2 is pointer to cpu variable. For key of items of the same
+   object this returns 0.
+   Returns: -1 if key1 < key2
+   0 if key1 == key2
+   1 if key1 > key2 */
+static inline int comp_short_keys(const struct reiserfs_key *le_key,
+				  const struct cpu_key *cpu_key)
+{
+	__u32 n;
+	n = le32_to_cpu(le_key->k_dir_id);
+	if (n < cpu_key->on_disk_key.k_dir_id)
+		return -1;
+	if (n > cpu_key->on_disk_key.k_dir_id)
+		return 1;
+	n = le32_to_cpu(le_key->k_objectid);
+	if (n < cpu_key->on_disk_key.k_objectid)
+		return -1;
+	if (n > cpu_key->on_disk_key.k_objectid)
+		return 1;
+	return 0;
+}
 
 // both are in le form
 extern int comp_le_keys(const struct reiserfs_key *,
@@ -1801,6 +1824,20 @@ static inline int le_key_version(const s
 
 }
 
+static inline void le_key2cpu_key(struct cpu_key *to,
+				  const struct reiserfs_key *from)
+{
+	int version;
+	to->on_disk_key.k_dir_id = le32_to_cpu(from->k_dir_id);
+	to->on_disk_key.k_objectid = le32_to_cpu(from->k_objectid);
+
+	// find out version of the key
+	version = le_key_version(from);
+	to->version = version;
+	to->on_disk_key.k_offset = le_key_k_offset(version, from);
+	to->on_disk_key.k_type = le_key_k_type(version, from);
+}
+
 static inline void copy_key(struct reiserfs_key *to,
 			    const struct reiserfs_key *from)
 {
@@ -1816,7 +1853,6 @@ int search_by_key(struct super_block *, 
 int search_for_position_by_key(struct super_block *p_s_sb,
 			       const struct cpu_key *p_s_cpu_key,
 			       struct treepath *p_s_search_path);
-extern void decrement_bcount(struct buffer_head *p_s_bh);
 void decrement_counters_in_path(struct treepath *p_s_search_path);
 void pathrelse(struct treepath *p_s_search_path);
 int reiserfs_check_path(struct treepath *p);
@@ -1913,7 +1949,19 @@ void i_attrs_to_sd_attrs(struct inode *i
 int reiserfs_setattr(struct dentry *dentry, struct iattr *attr);
 
 /* namei.c */
-void set_de_name_and_namelen(struct reiserfs_dir_entry *de);
+static inline void set_de_name_and_namelen(struct reiserfs_dir_entry *de)
+{
+	struct reiserfs_de_head *deh = de->de_deh + de->de_entry_num;
+
+	BUG_ON(de->de_entry_num >= ih_entry_count(de->de_ih));
+
+	de->de_entrylen = entry_length(de->de_bh, de->de_ih, de->de_entry_num);
+	de->de_namelen = de->de_entrylen - (de_with_sd(deh) ? SD_SIZE : 0);
+	de->de_name = B_I_PITEM(de->de_bh, de->de_ih) + deh_location(deh);
+	if (de->de_name[de->de_namelen - 1] == 0)
+		de->de_namelen = strlen(de->de_name);
+}
+
 int search_by_entry_key(struct super_block *sb, const struct cpu_key *key,
 			struct treepath *path, struct reiserfs_dir_entry *de);
 struct dentry *reiserfs_get_parent(struct dentry *);
@@ -2030,8 +2078,12 @@ int balance_internal(struct tree_balance
 		     struct buffer_head **);
 
 /* do_balance.c */
-void do_balance_mark_leaf_dirty(struct tree_balance *tb,
-				struct buffer_head *bh, int flag);
+static inline void do_balance_mark_leaf_dirty(struct tree_balance *tb,
+				struct buffer_head *bh, int flag)
+{
+	journal_mark_dirty(tb->transaction_handle,
+			   tb->transaction_handle->t_super, bh);
+}
 #define do_balance_mark_internal_dirty do_balance_mark_leaf_dirty
 #define do_balance_mark_sb_dirty do_balance_mark_leaf_dirty
 
@@ -2148,6 +2200,29 @@ void reiserfs_discard_prealloc(struct re
 void reiserfs_discard_all_prealloc(struct reiserfs_transaction_handle *th);
 #endif
 
+static inline void decrement_bcount(struct buffer_head *p_s_bh)
+{
+	if (p_s_bh) {
+		if (atomic_read(&(p_s_bh->b_count))) {
+			put_bh(p_s_bh);
+			return;
+		}
+		reiserfs_panic(NULL,
+		    "PAP-5070: decrement_bcount: trying to free free buffer %b",
+			       p_s_bh);
+	}
+}
+
+/* Does the buffer contain a disk block which is in the tree. */
+static inline int B_IS_IN_TREE(const struct buffer_head *p_s_bh)
+{
+
+	RFALSE(B_LEVEL(p_s_bh) > MAX_HEIGHT,
+	       "PAP-1010: block (%b) has too big level (%z)", p_s_bh, p_s_bh);
+
+	return (B_LEVEL(p_s_bh) != FREE_LEVEL);
+}
+
 /* hashes.c */
 __u32 keyed_hash(const signed char *msg, int len);
 __u32 yura_hash(const signed char *msg, int len);
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiserfs-use-open_bdev_excl.patch
reiserfs-some-functions-mustnt-be-inline.patch
reiser4-kgdb-fix.patch
reiser4-replace-uid==0-check-with-capability.patch
reiser4-new-export_ops-fixup.patch
reiser4-specify-splice-file-operations.patch
reiser4-fix-dummy-ioctl_cryptcompress.patch
reiser4-granulate-rw-serialization-when-accessing-file-conversion-set.patch
reiser4-fix-disk-cluster-synchronization.patch
reiser4-use-balance_dirty_pages_ratelimited_nr.patch
reiser4-correct-references-to-filemap_nopage.patch
reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch
reiser4-code-cleanups.patch


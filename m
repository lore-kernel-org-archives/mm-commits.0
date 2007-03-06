From: akpm@linux-foundation.org
Subject: - reiser4-fix-gcc-ws-compains.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:28 -0800
Message-ID: <200703060159.l261xSba008606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46548 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964826AbXCFB7k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix "gcc -W"'s complaints
has been removed from the -mm tree.  Its filename was
     reiser4-fix-gcc-ws-compains.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix "gcc -W"'s complaints
From: Vladimir Saveliev <vs@namesys.com>

Cleans up a few initializations, eliminates comparisons which are always
true and removes empty statements.  It also includes a fix for a bug in
error handling code path of file read.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/eottl.c                    |    3 +--
 fs/reiser4/lock.c                     |    6 +++---
 fs/reiser4/plugin/dir_plugin_common.c |    4 ++--
 fs/reiser4/plugin/file/file.c         |   13 +++++++------
 fs/reiser4/plugin/node/node40.c       |    2 --
 fs/reiser4/plugin/object.c            |   14 +++++++-------
 fs/reiser4/plugin/plugin_set.c        |    8 ++++----
 fs/reiser4/plugin/space/bitmap.c      |    1 -
 fs/reiser4/search.c                   |    4 +---
 fs/reiser4/txnmgr.c                   |    2 +-
 10 files changed, 26 insertions(+), 31 deletions(-)

diff -puN fs/reiser4/eottl.c~reiser4-fix-gcc-ws-compains fs/reiser4/eottl.c
--- a/fs/reiser4/eottl.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/eottl.c
@@ -348,8 +348,7 @@ add_empty_leaf(coord_t *insert_coord, lo
 					write_unlock_tree(tree);
 					result =
 					    connect_znode(insert_coord, node);
-					if (result == 0)
-						ON_DEBUG(check_dkeys(node));
+					ON_DEBUG(if (result == 0) check_dkeys(node););
 
 					done_lh(lh);
 					move_lh(lh, &local_lh);
diff -puN fs/reiser4/lock.c~reiser4-fix-gcc-ws-compains fs/reiser4/lock.c
--- a/fs/reiser4/lock.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/lock.c
@@ -615,7 +615,7 @@ void longterm_unlock_znode(lock_handle *
 	 */
 
 	/* was this lock of hi or lo priority */
-	hipri = oldowner->curpri ? -1 : 0;
+	hipri = oldowner->curpri ? 1 : 0;
 	/* number of readers */
 	readers = node->lock.nr_readers;
 	/* +1 if write lock, -1 if read lock */
@@ -628,8 +628,8 @@ void longterm_unlock_znode(lock_handle *
 	assert("zam-101", znode_is_locked(node));
 
 	/* Adjust a number of high priority owners of this lock */
-	node->lock.nr_hipri_owners += hipri;
-	assert("nikita-1836", node->lock.nr_hipri_owners >= 0);
+	assert("nikita-1836", node->lock.nr_hipri_owners >= hipri);
+	node->lock.nr_hipri_owners -= hipri;
 
 	/* Handle znode deallocation on last write-lock release. */
 	if (znode_is_wlocked_once(node)) {
diff -puN fs/reiser4/plugin/dir_plugin_common.c~reiser4-fix-gcc-ws-compains fs/reiser4/plugin/dir_plugin_common.c
--- a/fs/reiser4/plugin/dir_plugin_common.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/plugin/dir_plugin_common.c
@@ -396,8 +396,8 @@ int detach_common(struct inode *object, 
 	reiser4_free_dentry_fsdata(&goodby_dots);
 	if (result == 0) {
 		/* the dot should be the only entry remaining at this time... */
-		assert("nikita-3400", object->i_size == 1 &&
-		       (object->i_nlink >= 0 && object->i_nlink <= 2));
+		assert("nikita-3400",
+		       object->i_size == 1 && object->i_nlink <= 2);
 #if 0
 		/* and, together with the only name directory can have, they
 		 * provides for the last 2 remaining references. If we get
diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-gcc-ws-compains fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/plugin/file/file.c
@@ -1601,10 +1601,10 @@ static reiser4_block_nr unix_file_estima
 }
 
 /* this is called with nonexclusive access obtained, file's container can not change */
-static size_t read_file(hint_t * hint, struct file *file,	/* file to read from to */
-			char __user *buf,	/* address of user-space buffer */
-			size_t count,	/* number of bytes to read */
-			loff_t * off)
+static ssize_t read_file(hint_t *hint, struct file *file,	/* file to read from to */
+			 char __user *buf,	/* address of user-space buffer */
+			 size_t count,	/* number of bytes to read */
+			 loff_t *off)
 {
 	int result;
 	struct inode *inode;
@@ -1685,7 +1685,8 @@ ssize_t read_unix_file(struct file *file
 	struct inode *inode;
 	hint_t *hint;
 	unix_file_info_t *uf_info;
-	size_t count, read, left;
+	size_t count, left;
+	ssize_t read;
 	reiser4_block_nr needed;
 	loff_t size;
 
@@ -1737,7 +1738,7 @@ ssize_t read_unix_file(struct file *file
 		result = fault_in_pages_writeable(buf, left > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : left);
 		if (result) {
 			drop_nonexclusive_access(uf_info);
-			return RETERR(-EFAULT);
+			break;
 		}
 
 		read = read_file(hint, file, buf,
diff -puN fs/reiser4/plugin/node/node40.c~reiser4-fix-gcc-ws-compains fs/reiser4/plugin/node/node40.c
--- a/fs/reiser4/plugin/node/node40.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/plugin/node/node40.c
@@ -679,8 +679,6 @@ int parse_node40(znode * node /* node to
 		node->nr_items = node40_num_of_items_internal(node);
 		result = 0;
 	}
-	if (unlikely(result != 0))
-		/* print_znode("node", node) */ ;
 	return RETERR(result);
 }
 
diff -puN fs/reiser4/plugin/object.c~reiser4-fix-gcc-ws-compains fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/plugin/object.c
@@ -159,9 +159,9 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.desc = "directory",
 			.linkage = {NULL, NULL}
 		},
-		.inode_ops = {NULL,},
-		.file_ops = {NULL,},
-		.as_ops = {NULL,},
+		.inode_ops = {.create = NULL},
+		.file_ops = {.owner = NULL},
+		.as_ops = {.writepage = NULL},
 
 		.write_sd_by_inode = write_sd_by_inode_common,
 		.flow_by_inode = bugop,
@@ -210,8 +210,8 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.getattr = getattr_common
 		},
 		/* inode->i_fop of symlink is initialized by NULL in setup_inode_ops */
-		.file_ops = {NULL,},
-		.as_ops = {NULL,},
+		.file_ops = {.owner = NULL},
+		.as_ops = {.writepage = NULL},
 
 		.write_sd_by_inode = write_sd_by_inode_common,
 		.set_plug_in_inode = set_plug_in_inode_common,
@@ -257,8 +257,8 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		},
 		/* file_ops of special files (sockets, block, char, fifo) are
 		   initialized by init_special_inode. */
-		.file_ops = {NULL,},
-		.as_ops = {NULL,},
+		.file_ops = {.owner = NULL},
+		.as_ops = {.writepage = NULL},
 
 		.write_sd_by_inode = write_sd_by_inode_common,
 		.set_plug_in_inode = set_plug_in_inode_common,
diff -puN fs/reiser4/plugin/plugin_set.c~reiser4-fix-gcc-ws-compains fs/reiser4/plugin/plugin_set.c
--- a/fs/reiser4/plugin/plugin_set.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/plugin/plugin_set.c
@@ -273,14 +273,14 @@ static struct {
 #if REISER4_DEBUG
 static reiser4_plugin_type pset_member_to_type(pset_member memb)
 {
-	assert("nikita-3501", 0 <= memb && memb < PSET_LAST);
+	assert("nikita-3501", memb < PSET_LAST);
 	return pset_descr[memb].type;
 }
 #endif
 
 reiser4_plugin_type pset_member_to_type_unsafe(pset_member memb)
 {
-	if (0 <= memb && memb < PSET_LAST)
+	if (memb < PSET_LAST)
 		return pset_descr[memb].type;
 	else
 		return REISER4_PLUGIN_TYPES;
@@ -291,7 +291,7 @@ int pset_set(plugin_set ** set, pset_mem
 	assert("nikita-3492", set != NULL);
 	assert("nikita-3493", *set != NULL);
 	assert("nikita-3494", plugin != NULL);
-	assert("nikita-3495", 0 <= memb && memb < PSET_LAST);
+	assert("nikita-3495", memb < PSET_LAST);
 	assert("nikita-3496", plugin->h.type_id == pset_member_to_type(memb));
 
 	return plugin_set_field(set,
@@ -301,7 +301,7 @@ int pset_set(plugin_set ** set, pset_mem
 reiser4_plugin *pset_get(plugin_set * set, pset_member memb)
 {
 	assert("nikita-3497", set != NULL);
-	assert("nikita-3498", 0 <= memb && memb < PSET_LAST);
+	assert("nikita-3498", memb < PSET_LAST);
 
 	return *(reiser4_plugin **) (((char *)set) + pset_descr[memb].offset);
 }
diff -puN fs/reiser4/plugin/space/bitmap.c~reiser4-fix-gcc-ws-compains fs/reiser4/plugin/space/bitmap.c
--- a/fs/reiser4/plugin/space/bitmap.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/plugin/space/bitmap.c
@@ -308,7 +308,6 @@ reiser4_find_last_set_bit(bmap_off_t * r
 	int last_bit;
 	int nr;
 
-	assert("zam-961", high_off >= 0);
 	assert("zam-962", high_off >= low_off);
 
 	last_word = high_off >> LONG_INT_SHIFT;
diff -puN fs/reiser4/search.c~reiser4-fix-gcc-ws-compains fs/reiser4/search.c
--- a/fs/reiser4/search.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/search.c
@@ -613,9 +613,7 @@ static int prepare_object_lookup(cbk_han
 				}
 			}
 		}
-	} else
-		/* long-term locking failed. Restart. */
-		;
+	}
 
 	zput(vroot);
 
diff -puN fs/reiser4/txnmgr.c~reiser4-fix-gcc-ws-compains fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-fix-gcc-ws-compains
+++ a/fs/reiser4/txnmgr.c
@@ -1517,7 +1517,7 @@ void atom_set_stage(txn_atom * atom, txn
 {
 	assert("nikita-3535", atom != NULL);
 	assert_spin_locked(&(atom->alock));
-	assert("nikita-3536", ASTAGE_FREE <= stage && stage <= ASTAGE_INVALID);
+	assert("nikita-3536", stage <= ASTAGE_INVALID);
 	/* Excelsior! */
 	assert("nikita-3537", stage >= atom->stage);
 	if (atom->stage != stage) {
_

Patches currently in -mm which might be from vs@namesys.com are

reiser4.patch
reiser4-fix-gcc-ws-compains.patch
fs-reiser4-possible-cleanups.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-possible-cleanups-2.patch
reiser4-temp-fix.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-freeze-and-corruption.patch

From: akpm@linux-foundation.org
Subject: - reiser4-bug-fixes.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:25 -0800
Message-ID: <200703060159.l261xPZW008600@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46539 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965675AbXCFB7d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4 bug fixes
has been removed from the -mm tree.  Its filename was
     reiser4-bug-fixes.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Reiser4 bug fixes
From: Vladimir Saveliev <vs@namesys.com>

- missing long term lock unlock on read' error handling code path is added

- truncate_inode_pages is now called with embedded mapping.  It is needed
  to deal properly with block device special files.

- copy_to_user might be called for more bytes than was prefaulted with
  fault_in_pages_writeable.  That caused undesirable major page faults.

- readdir bug similar to the previous one: call to filldir might lead to
  deadlock due to major page fault.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Signed-off-by: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/file/file.c        |   21 ++++++++++++++++-----
 fs/reiser4/plugin/file_ops_readdir.c |    3 ++-
 fs/reiser4/super_ops.c               |    2 +-
 3 files changed, 19 insertions(+), 7 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-bug-fixes fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-bug-fixes
+++ a/fs/reiser4/plugin/file/file.c
@@ -783,9 +783,12 @@ int find_or_create_extent(struct page *p
 
 	lock_page(page);
 	node = jnode_of_page(page);
-	unlock_page(page);
-	if (IS_ERR(node))
+	if (IS_ERR(node)) {
+		unlock_page(page);
 		return PTR_ERR(node);
+	}
+	JF_SET(node, JNODE_WRITE_PREPARED);
+	unlock_page(page);
 
 	if (node->blocknr == 0) {
 		plugged_hole = 0;
@@ -793,6 +796,7 @@ int find_or_create_extent(struct page *p
 				       (loff_t)page->index << PAGE_CACHE_SHIFT,
 				       &plugged_hole);
 		if (result) {
+ 			JF_CLR(node, JNODE_WRITE_PREPARED);
 			jput(node);
 			warning("", "update_extent failed: %d", result);
 			return result;
@@ -808,6 +812,7 @@ int find_or_create_extent(struct page *p
 	}
 
 	BUG_ON(node->atom == NULL);
+	JF_CLR(node, JNODE_WRITE_PREPARED);
 	jput(node);
 
 	if (get_current_context()->entd) {
@@ -1633,14 +1638,18 @@ static size_t read_file(hint_t * hint, s
 			/* error happened */
 			break;
 
-		if (coord->between != AT_UNIT)
+		if (coord->between != AT_UNIT) {
 			/* there were no items corresponding to given offset */
+			done_lh(hint->ext_coord.lh);
 			break;
+		}
 
 		loaded = coord->node;
 		result = zload(loaded);
-		if (unlikely(result))
+		if (unlikely(result)) {
+			done_lh(hint->ext_coord.lh);
 			break;
+		}
 
 		if (hint->ext_coord.valid == 0)
 			validate_extended_coord(&hint->ext_coord,
@@ -1731,7 +1740,9 @@ ssize_t read_unix_file(struct file *file
 			return RETERR(-EFAULT);
 		}
 
-		read = read_file(hint, file, buf, left, off);
+		read = read_file(hint, file, buf,
+				 left > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : left,
+				 off);
 
  		drop_nonexclusive_access(uf_info);
 
diff -puN fs/reiser4/plugin/file_ops_readdir.c~reiser4-bug-fixes fs/reiser4/plugin/file_ops_readdir.c
--- a/fs/reiser4/plugin/file_ops_readdir.c~reiser4-bug-fixes
+++ a/fs/reiser4/plugin/file_ops_readdir.c
@@ -349,6 +349,7 @@ feed_entry(struct file *f,
 	 */
 	assert("nikita-3436", lock_stack_isclean(get_current_lock_stack()));
 
+	txn_restart_current();
 	result = filldir(dirent, name, (int)strlen(name),
 			 /* offset of this entry */
 			 f->f_pos,
@@ -630,7 +631,7 @@ int readdir_common(struct file *f /* dir
 	detach_fsdata(f);
 
 	/* try to update directory's atime */
-	if (reiser4_grab_space(inode_file_plugin(inode)->estimate.update(inode),
+	if (reiser4_grab_space_force(inode_file_plugin(inode)->estimate.update(inode),
 			       BA_CAN_COMMIT) != 0)
 		warning("", "failed to update atime on readdir: %llu",
 			get_inode_oid(inode));
diff -puN fs/reiser4/super_ops.c~reiser4-bug-fixes fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-bug-fixes
+++ a/fs/reiser4/super_ops.c
@@ -200,7 +200,7 @@ static void reiser4_delete_inode(struct 
 			fplug->delete_object(inode);
 	}
 
-	truncate_inode_pages(inode->i_mapping, 0);
+	truncate_inode_pages(&inode->i_data, 0);
 	inode->i_blocks = 0;
 	clear_inode(inode);
 	reiser4_exit_context(ctx);
_

Patches currently in -mm which might be from vs@namesys.com are

reiser4.patch
reiser4-bug-fixes.patch
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

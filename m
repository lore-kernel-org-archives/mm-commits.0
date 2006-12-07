From: akpm@osdl.org
Subject: - reiserfs-do-not-add-save-links-for-o_direct-writes.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:46 -0800
Message-ID: <200612072307.kB7N7kmO030396@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1164197AbWLGXLP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:11:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, amitarora@in.ibm.com, jeffm@suse.com, mason@suse.com, suzuki@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: do not add save links for O_DIRECT writes
has been removed from the -mm tree.  Its filename was
     reiserfs-do-not-add-save-links-for-o_direct-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: do not add save links for O_DIRECT writes
From: Vladimir V. Saveliev <vs@namesys.com>

We add a save link for O_DIRECT writes to protect the i_size against the
crashes before we actually finish the I/O.  If we hit an -ENOSPC in
aops->prepare_write(), we would do a truncate() to release the blocks which
might have got initialized.  Now the truncate would add another save link
for the same inode causing a reiserfs panic for having multiple save links
for the same inode.

Signed-off-by: Vladimir V. Saveliev <vs@namesys.com>
Signed-off-by: Amit Arora <amitarora@in.ibm.com>
Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <mason@suse.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiserfs/file.c |   54 +++----------------------------------------
 1 file changed, 4 insertions(+), 50 deletions(-)

diff -puN fs/reiserfs/file.c~reiserfs-do-not-add-save-links-for-o_direct-writes fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~reiserfs-do-not-add-save-links-for-o_direct-writes
+++ a/fs/reiserfs/file.c
@@ -406,6 +406,8 @@ static int reiserfs_allocate_blocks_for_
 				   we restart it. This will also free the path. */
 				if (journal_transaction_should_end
 				    (th, th->t_blocks_allocated)) {
+					inode->i_size = cpu_key_k_offset(&key) +
+						(to_paste << inode->i_blkbits);
 					res =
 					    restart_transaction(th, inode,
 								&path);
@@ -1310,56 +1312,8 @@ static ssize_t reiserfs_file_write(struc
 			count = MAX_NON_LFS - (unsigned long)*ppos;
 	}
 
-	if (file->f_flags & O_DIRECT) {	// Direct IO needs treatment
-		ssize_t result, after_file_end = 0;
-		if ((*ppos + count >= inode->i_size)
-		    || (file->f_flags & O_APPEND)) {
-			/* If we are appending a file, we need to put this savelink in here.
-			   If we will crash while doing direct io, finish_unfinished will
-			   cut the garbage from the file end. */
-			reiserfs_write_lock(inode->i_sb);
-			err =
-			    journal_begin(&th, inode->i_sb,
-					  JOURNAL_PER_BALANCE_CNT);
-			if (err) {
-				reiserfs_write_unlock(inode->i_sb);
-				return err;
-			}
-			reiserfs_update_inode_transaction(inode);
-			add_save_link(&th, inode, 1 /* Truncate */ );
-			after_file_end = 1;
-			err =
-			    journal_end(&th, inode->i_sb,
-					JOURNAL_PER_BALANCE_CNT);
-			reiserfs_write_unlock(inode->i_sb);
-			if (err)
-				return err;
-		}
-		result = do_sync_write(file, buf, count, ppos);
-
-		if (after_file_end) {	/* Now update i_size and remove the savelink */
-			struct reiserfs_transaction_handle th;
-			reiserfs_write_lock(inode->i_sb);
-			err = journal_begin(&th, inode->i_sb, 1);
-			if (err) {
-				reiserfs_write_unlock(inode->i_sb);
-				return err;
-			}
-			reiserfs_update_inode_transaction(inode);
-			mark_inode_dirty(inode);
-			err = journal_end(&th, inode->i_sb, 1);
-			if (err) {
-				reiserfs_write_unlock(inode->i_sb);
-				return err;
-			}
-			err = remove_save_link(inode, 1 /* truncate */ );
-			reiserfs_write_unlock(inode->i_sb);
-			if (err)
-				return err;
-		}
-
-		return result;
-	}
+	if (file->f_flags & O_DIRECT)
+		return do_sync_write(file, buf, count, ppos);
 
 	if (unlikely((ssize_t) count < 0))
 		return -EINVAL;
_

Patches currently in -mm which might be from vs@namesys.com are

origin.patch
reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-fix-trivial-tyops-which-were-hard-to-hit.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
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


From: akpm@linux-foundation.org
Subject: + reiserfs-use-is_reusable-to-catch-corruption.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:04:09 -0700
Message-ID: <200710182104.l9IL49bZ031023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758120AbXJRVEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:04:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com


The patch titled
     reiserfs: use is_reusable to catch corruption
has been added to the -mm tree.  Its filename is
     reiserfs-use-is_reusable-to-catch-corruption.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: use is_reusable to catch corruption
From: Jeff Mahoney <jeffm@suse.com>

Build in is_reusable() unconditionally and use it to catch corruption before
it reaches the block freeing paths.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-use-is_reusable-to-catch-corruption fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-use-is_reusable-to-catch-corruption
+++ a/fs/reiserfs/bitmap.c
@@ -56,7 +56,6 @@ static inline void get_bit_address(struc
 	*offset = block & ((s->s_blocksize << 3) - 1);
 }
 
-#ifdef CONFIG_REISERFS_CHECK
 int is_reusable(struct super_block *s, b_blocknr_t block, int bit_value)
 {
 	int bmap, offset;
@@ -106,7 +105,6 @@ int is_reusable(struct super_block *s, b
 
 	return 1;
 }
-#endif				/* CONFIG_REISERFS_CHECK */
 
 /* searches in journal structures for a given block number (bmap, off). If block
    is found in reiserfs journal it suggests next free block candidate to test. */
@@ -434,12 +432,19 @@ void reiserfs_free_block(struct reiserfs
 			 int for_unformatted)
 {
 	struct super_block *s = th->t_super;
-
 	BUG_ON(!th->t_trans_id);
 
 	RFALSE(!s, "vs-4061: trying to free block on nonexistent device");
-	RFALSE(is_reusable(s, block, 1) == 0,
-	       "vs-4071: can not free such block");
+	if (!is_reusable(s, block, 1))
+		return;
+
+	if (block > sb_block_count(REISERFS_SB(s)->s_rs)) {
+		reiserfs_panic(th->t_super, "bitmap-4072",
+			       "Trying to free block outside file system "
+			       "boundaries (%lu > %lu)",
+			       block, sb_block_count(REISERFS_SB(s)->s_rs));
+		return;
+	}
 	/* mark it before we clear it, just in case */
 	journal_mark_freed(th, s, block);
 	_reiserfs_free_block(th, inode, block, for_unformatted);
@@ -449,11 +454,11 @@ void reiserfs_free_block(struct reiserfs
 static void reiserfs_free_prealloc_block(struct reiserfs_transaction_handle *th,
 					 struct inode *inode, b_blocknr_t block)
 {
+	BUG_ON(!th->t_trans_id);
 	RFALSE(!th->t_super,
 	       "vs-4060: trying to free block on nonexistent device");
-	RFALSE(is_reusable(th->t_super, block, 1) == 0,
-	       "vs-4070: can not free such block");
-	BUG_ON(!th->t_trans_id);
+	if (!is_reusable(th->t_super, block, 1))
+		return;
 	_reiserfs_free_block(th, inode, block, 1);
 }
 
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
reiserfs-fix-up-lockdep-warnings.patch
reiserfs-dont-use-bug-when-panicking.patch
reiserfs-use-is_reusable-to-catch-corruption.patch
reiserfs-fix-memset-byte-count-during-resize.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers.patch
reiserfs-remove-first_zero_hint.patch
reiserfs-ignore-on-disk-s_bmap_nr-value.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch

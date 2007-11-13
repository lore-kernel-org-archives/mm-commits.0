From: akpm@linux-foundation.org
Subject: - fs-buffer-trylock-rename.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:50:38 -0800
Message-ID: <200711130457.lAD4vaFH026948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757128AbXKME5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:57:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     fs: buffer trylock rename
has been removed from the -mm tree.  Its filename was
     fs-buffer-trylock-rename.patch

This patch was dropped because of too much breakage

------------------------------------------------------
Subject: fs: buffer trylock rename
From: Nick Piggin <npiggin@suse.de>

Converting the buffer lock to new bitops also requires name change, so convert
the raw test_and_set bitop to a trylock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    4 ++--
 fs/jbd/commit.c             |    2 +-
 fs/jbd2/commit.c            |    2 +-
 fs/ntfs/aops.c              |    2 +-
 fs/ntfs/compress.c          |    2 +-
 fs/ntfs/mft.c               |    4 ++--
 fs/reiserfs/inode.c         |    2 +-
 fs/reiserfs/journal.c       |    4 ++--
 include/linux/buffer_head.h |    8 ++++++--
 9 files changed, 17 insertions(+), 13 deletions(-)

diff -puN fs/buffer.c~fs-buffer-trylock-rename fs/buffer.c
--- a/fs/buffer.c~fs-buffer-trylock-rename
+++ a/fs/buffer.c
@@ -1688,7 +1688,7 @@ static int __block_write_full_page(struc
 		 */
 		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
 			lock_buffer(bh);
-		} else if (test_set_buffer_locked(bh)) {
+		} else if (!trylock_buffer(bh)) {
 			redirty_page_for_writepage(wbc, page);
 			continue;
 		}
@@ -2927,7 +2927,7 @@ void ll_rw_block(int rw, int nr, struct 
 
 		if (rw == SWRITE)
 			lock_buffer(bh);
-		else if (test_set_buffer_locked(bh))
+		else if (!trylock_buffer(bh))
 			continue;
 
 		if (rw == WRITE || rw == SWRITE) {
diff -puN fs/jbd/commit.c~fs-buffer-trylock-rename fs/jbd/commit.c
--- a/fs/jbd/commit.c~fs-buffer-trylock-rename
+++ a/fs/jbd/commit.c
@@ -208,7 +208,7 @@ write_out_data:
 		 * blocking lock_buffer().
 		 */
 		if (buffer_dirty(bh)) {
-			if (test_set_buffer_locked(bh)) {
+			if (!trylock_buffer(bh)) {
 				BUFFER_TRACE(bh, "needs blocking lock");
 				spin_unlock(&journal->j_list_lock);
 				/* Write out all data to prevent deadlocks */
diff -puN fs/jbd2/commit.c~fs-buffer-trylock-rename fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~fs-buffer-trylock-rename
+++ a/fs/jbd2/commit.c
@@ -208,7 +208,7 @@ write_out_data:
 		 * blocking lock_buffer().
 		 */
 		if (buffer_dirty(bh)) {
-			if (test_set_buffer_locked(bh)) {
+			if (!trylock_buffer(bh)) {
 				BUFFER_TRACE(bh, "needs blocking lock");
 				spin_unlock(&journal->j_list_lock);
 				/* Write out all data to prevent deadlocks */
diff -puN fs/ntfs/aops.c~fs-buffer-trylock-rename fs/ntfs/aops.c
--- a/fs/ntfs/aops.c~fs-buffer-trylock-rename
+++ a/fs/ntfs/aops.c
@@ -1194,7 +1194,7 @@ lock_retry_remap:
 		tbh = bhs[i];
 		if (!tbh)
 			continue;
-		if (unlikely(test_set_buffer_locked(tbh)))
+		if (!trylock_buffer(tbh))
 			BUG();
 		/* The buffer dirty state is now irrelevant, just clean it. */
 		clear_buffer_dirty(tbh);
diff -puN fs/ntfs/compress.c~fs-buffer-trylock-rename fs/ntfs/compress.c
--- a/fs/ntfs/compress.c~fs-buffer-trylock-rename
+++ a/fs/ntfs/compress.c
@@ -665,7 +665,7 @@ lock_retry_remap:
 	for (i = 0; i < nr_bhs; i++) {
 		struct buffer_head *tbh = bhs[i];
 
-		if (unlikely(test_set_buffer_locked(tbh)))
+		if (!trylock_buffer(tbh))
 			continue;
 		if (unlikely(buffer_uptodate(tbh))) {
 			unlock_buffer(tbh);
diff -puN fs/ntfs/mft.c~fs-buffer-trylock-rename fs/ntfs/mft.c
--- a/fs/ntfs/mft.c~fs-buffer-trylock-rename
+++ a/fs/ntfs/mft.c
@@ -586,7 +586,7 @@ int ntfs_sync_mft_mirror(ntfs_volume *vo
 		for (i_bhs = 0; i_bhs < nr_bhs; i_bhs++) {
 			struct buffer_head *tbh = bhs[i_bhs];
 
-			if (unlikely(test_set_buffer_locked(tbh)))
+			if (!trylock_buffer(tbh))
 				BUG();
 			BUG_ON(!buffer_uptodate(tbh));
 			clear_buffer_dirty(tbh);
@@ -779,7 +779,7 @@ int write_mft_record_nolock(ntfs_inode *
 	for (i_bhs = 0; i_bhs < nr_bhs; i_bhs++) {
 		struct buffer_head *tbh = bhs[i_bhs];
 
-		if (unlikely(test_set_buffer_locked(tbh)))
+		if (!trylock_buffer(tbh))
 			BUG();
 		BUG_ON(!buffer_uptodate(tbh));
 		clear_buffer_dirty(tbh);
diff -puN fs/reiserfs/inode.c~fs-buffer-trylock-rename fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~fs-buffer-trylock-rename
+++ a/fs/reiserfs/inode.c
@@ -2433,7 +2433,7 @@ static int reiserfs_write_full_page(stru
 		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
 			lock_buffer(bh);
 		} else {
-			if (test_set_buffer_locked(bh)) {
+			if (!trylock_buffer(bh)) {
 				redirty_page_for_writepage(wbc, page);
 				continue;
 			}
diff -puN fs/reiserfs/journal.c~fs-buffer-trylock-rename fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~fs-buffer-trylock-rename
+++ a/fs/reiserfs/journal.c
@@ -857,7 +857,7 @@ static int write_ordered_buffers(spinloc
 		jh = JH_ENTRY(list->next);
 		bh = jh->bh;
 		get_bh(bh);
-		if (test_set_buffer_locked(bh)) {
+		if (!trylock_buffer(bh)) {
 			if (!buffer_dirty(bh)) {
 				list_move(&jh->list, &tmp);
 				goto loop_next;
@@ -3877,7 +3877,7 @@ int reiserfs_prepare_for_journal(struct 
 {
 	PROC_INFO_INC(p_s_sb, journal.prepare);
 
-	if (test_set_buffer_locked(bh)) {
+	if (!trylock_buffer(bh)) {
 		if (!wait)
 			return 0;
 		lock_buffer(bh);
diff -puN include/linux/buffer_head.h~fs-buffer-trylock-rename include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fs-buffer-trylock-rename
+++ a/include/linux/buffer_head.h
@@ -115,7 +115,6 @@ BUFFER_FNS(Uptodate, uptodate)
 BUFFER_FNS(Dirty, dirty)
 TAS_BUFFER_FNS(Dirty, dirty)
 BUFFER_FNS(Lock, locked)
-TAS_BUFFER_FNS(Lock, locked)
 BUFFER_FNS(Req, req)
 TAS_BUFFER_FNS(Req, req)
 BUFFER_FNS(Mapped, mapped)
@@ -318,10 +317,15 @@ static inline void wait_on_buffer(struct
 		__wait_on_buffer(bh);
 }
 
+static inline int trylock_buffer(struct buffer_head *bh)
+{
+	return likely(!test_and_set_bit(BH_Lock, &bh->b_state));
+}
+
 static inline void lock_buffer(struct buffer_head *bh)
 {
 	might_sleep();
-	if (test_set_buffer_locked(bh))
+	if (!trylock_buffer(bh))
 		__lock_buffer(bh);
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
rd-fix-data-corruption-on-memory-pressure.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
fs-buffer-trylock-rename.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4.patch

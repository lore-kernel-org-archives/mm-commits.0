From: akpm@linux-foundation.org
Subject: + buffer_head-fix-private_list-handling.patch added to -mm tree
Date: Mon, 04 Feb 2008 13:28:05 -0800
Message-ID: <200802042128.m14LS5AI018050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195AbYBDV2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 16:28:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, npiggin@suse.de


The patch titled
     buffer_head: fix private_list handling
has been added to the -mm tree.  Its filename is
     buffer_head-fix-private_list-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: buffer_head: fix private_list handling
From: Jan Kara <jack@suse.cz>

There are two possible races in handling of private_list in buffer cache.

1) When fsync_buffers_list() processes a private_list, it clears
   b_assoc_mapping and moves buffer to its private list.  Now
   drop_buffers() comes, sees a buffer is on list so it calls
   __remove_assoc_queue() which complains about b_assoc_mapping being
   cleared (as it cannot propagate possible IO error).  This race has been
   actually observed in the wild.

2) When fsync_buffers_list() processes a private_list,
   mark_buffer_dirty_inode() can be called on bh which is already on the
   private list of fsync_buffers_list().  As buffer is on some list (note
   that the check is performed without private_lock), it is not readded to
   the mapping's private_list and after fsync_buffers_list() finishes, we
   have a dirty buffer which should be on private_list but it isn't.  This
   race has not been reported, probably because most (but not all) callers
   of mark_buffer_dirty_inode() hold i_mutex and thus are serialized with
   fsync().

Fix these issues by not clearing b_assoc_map when fsync_buffers_list()
moves buffer to a dedicated list and by reinserting buffer in private_list
when it is found dirty after we have submitted buffer for IO.  We also
change the tests whether a buffer is on a private list from
!list_empty(&bh->b_assoc_buffers) to bh->b_assoc_map so that they are
single word reads and hence lockless checks are safe.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN fs/buffer.c~buffer_head-fix-private_list-handling fs/buffer.c
--- a/fs/buffer.c~buffer_head-fix-private_list-handling
+++ a/fs/buffer.c
@@ -678,7 +678,7 @@ void mark_buffer_dirty_inode(struct buff
 	} else {
 		BUG_ON(mapping->assoc_mapping != buffer_mapping);
 	}
-	if (list_empty(&bh->b_assoc_buffers)) {
+	if (!bh->b_assoc_map) {
 		spin_lock(&buffer_mapping->private_lock);
 		list_move_tail(&bh->b_assoc_buffers,
 				&mapping->private_list);
@@ -794,6 +794,7 @@ static int fsync_buffers_list(spinlock_t
 {
 	struct buffer_head *bh;
 	struct list_head tmp;
+	struct address_space *mapping;
 	int err = 0, err2;
 
 	INIT_LIST_HEAD(&tmp);
@@ -801,9 +802,14 @@ static int fsync_buffers_list(spinlock_t
 	spin_lock(lock);
 	while (!list_empty(list)) {
 		bh = BH_ENTRY(list->next);
+		mapping = bh->b_assoc_map;
 		__remove_assoc_queue(bh);
+		/* Avoid race with mark_buffer_dirty_inode() which does
+		 * a lockless check and we rely on seeing the dirty bit */
+		smp_mb();
 		if (buffer_dirty(bh) || buffer_locked(bh)) {
 			list_add(&bh->b_assoc_buffers, &tmp);
+			bh->b_assoc_map = mapping;
 			if (buffer_dirty(bh)) {
 				get_bh(bh);
 				spin_unlock(lock);
@@ -822,8 +828,17 @@ static int fsync_buffers_list(spinlock_t
 
 	while (!list_empty(&tmp)) {
 		bh = BH_ENTRY(tmp.prev);
-		list_del_init(&bh->b_assoc_buffers);
 		get_bh(bh);
+		mapping = bh->b_assoc_map;
+		__remove_assoc_queue(bh);
+		/* Avoid race with mark_buffer_dirty_inode() which does
+		 * a lockless check and we rely on seeing the dirty bit */
+		smp_mb();
+		if (buffer_dirty(bh)) {
+			list_add(&bh->b_assoc_buffers,
+				 &bh->b_assoc_map->private_list);
+			bh->b_assoc_map = mapping;
+		}
 		spin_unlock(lock);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
@@ -1195,7 +1210,7 @@ void __brelse(struct buffer_head * buf)
 void __bforget(struct buffer_head *bh)
 {
 	clear_buffer_dirty(bh);
-	if (!list_empty(&bh->b_assoc_buffers)) {
+	if (bh->b_assoc_map) {
 		struct address_space *buffer_mapping = bh->b_page->mapping;
 
 		spin_lock(&buffer_mapping->private_lock);
@@ -3020,7 +3035,7 @@ drop_buffers(struct page *page, struct b
 	do {
 		struct buffer_head *next = bh->b_this_page;
 
-		if (!list_empty(&bh->b_assoc_buffers))
+		if (bh->b_assoc_map)
 			__remove_assoc_queue(bh);
 		bh = next;
 	} while (bh != head);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
ext3-fix-lock-inversion-in-direct-io.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
use-pgoff_t-instead-of-unsigned-long.patch
write_inode_now-avoid-unnecessary-synchronous-write.patch
udf-fix-coding-style-of-superc.patch
udf-remove-some-ugly-macros.patch
udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
udf-check-if-udf_load_logicalvol-failed.patch
udf-convert-macros-related-to-bitmaps-to-functions.patch
udf-move-calculating-of-nr_groups-into-helper-function.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
udf-fix-coding-style.patch
udf-create-common-function-for-tag-checksumming.patch
udf-create-common-function-for-changing-free-space-counter.patch
udf-replace-loops-coded-with-goto-to-real-loops.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
udf-improve-readability-of-udf_load_partition.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-avoid-unnecessary-synchronous-writes.patch
udf-cleanup-directory-offset-handling.patch
udf-fix-adding-entry-to-a-directory.patch
change-udf-maintainer.patch
isofs-implement-dmode-option.patch
isofs-implement-dmode-option-fix.patch
mount-options-fix-ext2.patch
mount-options-fix-isofs.patch
mount-options-fix-udf.patch
buffer_head-fix-private_list-handling.patch

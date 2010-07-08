From: akpm@linux-foundation.org
Subject: + reiser4-writeback_inodes-implementation-adjust-to-writeback-changes.patch added to -mm tree
Date: Thu, 08 Jul 2010 15:09:11 -0700
Message-ID: <201007082209.o68M9Bqk031946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124Ab0GHWJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 18:09:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: adjust to writeback changes
has been added to the -mm tree.  Its filename is
     reiser4-writeback_inodes-implementation-adjust-to-writeback-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: adjust to writeback changes
From: Edward Shishkin <edward.shishkin@gmail.com>

Adjust reiser4 to the latest vfs changes:
. Change reiser4_writeback_inodes();
. Use writeback_inodes_wb() instead of writeback_inodes_wbc().

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/entd.c       |    5 ++---
 fs/reiser4/page_cache.c |    3 ---
 fs/reiser4/super_ops.c  |    5 +++--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/reiser4/entd.c~reiser4-writeback_inodes-implementation-adjust-to-writeback-changes fs/reiser4/entd.c
--- a/fs/reiser4/entd.c~reiser4-writeback_inodes-implementation-adjust-to-writeback-changes
+++ a/fs/reiser4/entd.c
@@ -237,14 +237,13 @@ static void entd_flush(struct super_bloc
 		(ENTD_CAPTURE_APAGE_BURST << PAGE_CACHE_SHIFT);
 	tmp = rq->wbc->nr_to_write;
 
-	assert("edward-1561", super == rq->wbc->sb);
-
 	rq->mapping->a_ops->writepages(rq->mapping, rq->wbc);
 
 	if (rq->wbc->nr_to_write > 0) {
 		rq->wbc->range_start = 0;
 		rq->wbc->range_end = LLONG_MAX;
-		writeback_inodes_wbc(rq->wbc);
+		writeback_inodes_wb(&rq->mapping->backing_dev_info->wb,
+				    rq->wbc);
 	}
 	rq->wbc->nr_to_write = ENTD_CAPTURE_APAGE_BURST;
 
diff -puN fs/reiser4/page_cache.c~reiser4-writeback_inodes-implementation-adjust-to-writeback-changes fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-writeback_inodes-implementation-adjust-to-writeback-changes
+++ a/fs/reiser4/page_cache.c
@@ -492,9 +492,6 @@ int reiser4_writepage(struct page *page,
 	 */
 	assert("vs-828", PageLocked(page));
 
-	wbc->sb = page->mapping->host->i_sb;
-	wbc->bdi = page->mapping->backing_dev_info;
-
 	return write_page_by_ent(page, wbc);
 }
 
diff -puN fs/reiser4/super_ops.c~reiser4-writeback_inodes-implementation-adjust-to-writeback-changes fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-writeback_inodes-implementation-adjust-to-writeback-changes
+++ a/fs/reiser4/super_ops.c
@@ -391,7 +391,8 @@ static void reiser4_clear_inode(struct i
  */
 static int reiser4_writeback_inodes(struct super_block *super,
 				    struct bdi_writeback *wb,
-				    struct writeback_control *wbc)
+				    struct writeback_control *wbc,
+				    bool only_this_sb)
 {
 	int ret;
 	long to_write;
@@ -415,7 +416,7 @@ static int reiser4_writeback_inodes(stru
 	 * dirty pages into transactions if they were not yet.
 	 */
 	spin_lock(&inode_lock);
-	ret = generic_writeback_sb_inodes(super, wb, wbc);
+	ret = generic_writeback_sb_inodes(super, wb, wbc, only_this_sb);
 	spin_unlock(&inode_lock);
 
 	wbc->nr_to_write = to_write;
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-add-super-operation-writeback_inodes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch
reiser4-writeback_inodes-implementation.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-writeback_inodes-implementation-adjust-to-writeback-changes.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch
reiser4-fixups.patch
reiser4-broke.patch
vfs-change-writeback_inodes-signature.patch
reiser4-rename-quota-methods.patch
reiser4-remove-inode_setattr.patch
reiser4-change-fsync-signature.patch
reiser4-enable.patch


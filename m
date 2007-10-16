From: akpm@linux-foundation.org
Subject: - block_dev-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:27 -0700
Message-ID: <200710162032.l9GKWR5x014603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935092AbXJPVip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:38:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     block_dev: convert to new aops
has been removed from the -mm tree.  Its filename was
     block_dev-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: block_dev: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN fs/block_dev.c~block_dev-convert-to-new-aops fs/block_dev.c
--- a/fs/block_dev.c~block_dev-convert-to-new-aops
+++ a/fs/block_dev.c
@@ -378,14 +378,26 @@ static int blkdev_readpage(struct file *
 	return block_read_full_page(page, blkdev_get_block);
 }
 
-static int blkdev_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
+static int blkdev_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	return block_prepare_write(page, from, to, blkdev_get_block);
+	*pagep = NULL;
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				blkdev_get_block);
 }
 
-static int blkdev_commit_write(struct file *file, struct page *page, unsigned from, unsigned to)
+static int blkdev_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
-	return block_commit_write(page, from, to);
+	int ret;
+	ret = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+
+	unlock_page(page);
+	page_cache_release(page);
+
+	return ret;
 }
 
 /*
@@ -1327,8 +1339,8 @@ const struct address_space_operations de
 	.readpage	= blkdev_readpage,
 	.writepage	= blkdev_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= blkdev_prepare_write,
-	.commit_write	= blkdev_commit_write,
+	.write_begin	= blkdev_write_begin,
+	.write_end	= blkdev_write_end,
 	.writepages	= generic_writepages,
 	.direct_IO	= blkdev_direct_IO,
 };
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch

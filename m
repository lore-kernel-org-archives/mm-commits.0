From: akpm@linux-foundation.org
Subject: - bfs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:52 -0700
Message-ID: <200710162032.l9GKWqIQ014658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35254 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016AbXJPVmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, tigran@aivazian.fsnet.co.uk, mm-commits@vger.kernel.org


The patch titled
     bfs: convert to new aops
has been removed from the -mm tree.  Its filename was
     bfs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/file.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/bfs/file.c~bfs-convert-to-new-aops fs/bfs/file.c
--- a/fs/bfs/file.c~bfs-convert-to-new-aops
+++ a/fs/bfs/file.c
@@ -145,9 +145,13 @@ static int bfs_readpage(struct file *fil
 	return block_read_full_page(page, bfs_get_block);
 }
 
-static int bfs_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
+static int bfs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	return block_prepare_write(page, from, to, bfs_get_block);
+	*pagep = NULL;
+	return block_write_begin(file, mapping, pos, len, flags,
+					pagep, fsdata, bfs_get_block);
 }
 
 static sector_t bfs_bmap(struct address_space *mapping, sector_t block)
@@ -159,8 +163,8 @@ const struct address_space_operations bf
 	.readpage	= bfs_readpage,
 	.writepage	= bfs_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= bfs_prepare_write,
-	.commit_write	= generic_commit_write,
+	.write_begin	= bfs_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= bfs_bmap,
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

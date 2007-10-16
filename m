From: akpm@linux-foundation.org
Subject: - qnx4-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:54 -0700
Message-ID: <200710162032.l9GKWstW014661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965963AbXJPVoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:44:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, al@alarsen.net, mm-commits@vger.kernel.org


The patch titled
     qnx4: convert to new aops
has been removed from the -mm tree.  Its filename was
     qnx4-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qnx4: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Anders Larsen <al@alarsen.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx4/inode.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN fs/qnx4/inode.c~qnx4-convert-to-new-aops fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~qnx4-convert-to-new-aops
+++ a/fs/qnx4/inode.c
@@ -433,16 +433,21 @@ static int qnx4_writepage(struct page *p
 {
 	return block_write_full_page(page,qnx4_get_block, wbc);
 }
+
 static int qnx4_readpage(struct file *file, struct page *page)
 {
 	return block_read_full_page(page,qnx4_get_block);
 }
-static int qnx4_prepare_write(struct file *file, struct page *page,
-			      unsigned from, unsigned to)
-{
-	struct qnx4_inode_info *qnx4_inode = qnx4_i(page->mapping->host);
-	return cont_prepare_write(page, from, to, qnx4_get_block,
-				  &qnx4_inode->mmu_private);
+
+static int qnx4_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	struct qnx4_inode_info *qnx4_inode = qnx4_i(mapping->host);
+	*pagep = NULL;
+	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				qnx4_get_block,
+				&qnx4_inode->mmu_private);
 }
 static sector_t qnx4_bmap(struct address_space *mapping, sector_t block)
 {
@@ -452,8 +457,8 @@ static const struct address_space_operat
 	.readpage	= qnx4_readpage,
 	.writepage	= qnx4_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= qnx4_prepare_write,
-	.commit_write	= generic_commit_write,
+	.write_begin	= qnx4_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= qnx4_bmap
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

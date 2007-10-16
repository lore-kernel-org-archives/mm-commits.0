From: akpm@linux-foundation.org
Subject: - hpfs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:50 -0700
Message-ID: <200710162032.l9GKWoJg014655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966202AbXJPVnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mikulas@artax.karlin.mff.cuni.cz, mm-commits@vger.kernel.org


The patch titled
     hpfs: convert to new aops
has been removed from the -mm tree.  Its filename was
     hpfs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hpfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/file.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN fs/hpfs/file.c~hpfs-convert-to-new-aops fs/hpfs/file.c
--- a/fs/hpfs/file.c~hpfs-convert-to-new-aops
+++ a/fs/hpfs/file.c
@@ -86,25 +86,33 @@ static int hpfs_writepage(struct page *p
 {
 	return block_write_full_page(page,hpfs_get_block, wbc);
 }
+
 static int hpfs_readpage(struct file *file, struct page *page)
 {
 	return block_read_full_page(page,hpfs_get_block);
 }
-static int hpfs_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
-{
-	return cont_prepare_write(page,from,to,hpfs_get_block,
-		&hpfs_i(page->mapping->host)->mmu_private);
+
+static int hpfs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				hpfs_get_block,
+				&hpfs_i(mapping->host)->mmu_private);
 }
+
 static sector_t _hpfs_bmap(struct address_space *mapping, sector_t block)
 {
 	return generic_block_bmap(mapping,block,hpfs_get_block);
 }
+
 const struct address_space_operations hpfs_aops = {
 	.readpage = hpfs_readpage,
 	.writepage = hpfs_writepage,
 	.sync_page = block_sync_page,
-	.prepare_write = hpfs_prepare_write,
-	.commit_write = generic_commit_write,
+	.write_begin = hpfs_write_begin,
+	.write_end = generic_write_end,
 	.bmap = _hpfs_bmap
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

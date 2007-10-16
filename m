From: akpm@linux-foundation.org
Subject: - xfs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:35 -0700
Message-ID: <200710162032.l9GKWZfU014617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45994 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966343AbXJPVuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, dgc@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: convert to new aops
has been removed from the -mm tree.  Its filename was
     xfs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_aops.c |   19 +++++++++++-------
 fs/xfs/linux-2.6/xfs_lrw.c  |   35 +++++++++++-----------------------
 2 files changed, 24 insertions(+), 30 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_aops.c~xfs-convert-to-new-aops fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~xfs-convert-to-new-aops
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -1508,13 +1508,18 @@ xfs_vm_direct_IO(
 }
 
 STATIC int
-xfs_vm_prepare_write(
+xfs_vm_write_begin(
 	struct file		*file,
-	struct page		*page,
-	unsigned int		from,
-	unsigned int		to)
+	struct address_space	*mapping,
+	loff_t			pos,
+	unsigned		len,
+	unsigned		flags,
+	struct page		**pagep,
+	void			**fsdata)
 {
-	return block_prepare_write(page, from, to, xfs_get_blocks);
+	*pagep = NULL;
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+								xfs_get_blocks);
 }
 
 STATIC sector_t
@@ -1568,8 +1573,8 @@ const struct address_space_operations xf
 	.sync_page		= block_sync_page,
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
-	.prepare_write		= xfs_vm_prepare_write,
-	.commit_write		= generic_commit_write,
+	.write_begin		= xfs_vm_write_begin,
+	.write_end		= generic_write_end,
 	.bmap			= xfs_vm_bmap,
 	.direct_IO		= xfs_vm_direct_IO,
 	.migratepage		= buffer_migrate_page,
diff -puN fs/xfs/linux-2.6/xfs_lrw.c~xfs-convert-to-new-aops fs/xfs/linux-2.6/xfs_lrw.c
--- a/fs/xfs/linux-2.6/xfs_lrw.c~xfs-convert-to-new-aops
+++ a/fs/xfs/linux-2.6/xfs_lrw.c
@@ -134,45 +134,34 @@ xfs_iozero(
 	loff_t			pos,	/* offset in file		*/
 	size_t			count)	/* size of data to zero		*/
 {
-	unsigned		bytes;
 	struct page		*page;
 	struct address_space	*mapping;
 	int			status;
 
 	mapping = ip->i_mapping;
 	do {
-		unsigned long index, offset;
+		unsigned offset, bytes;
+		void *fsdata;
 
 		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = PAGE_CACHE_SIZE - offset;
 		if (bytes > count)
 			bytes = count;
 
-		status = -ENOMEM;
-		page = grab_cache_page(mapping, index);
-		if (!page)
-			break;
-
-		status = mapping->a_ops->prepare_write(NULL, page, offset,
-							offset + bytes);
+		status = pagecache_write_begin(NULL, mapping, pos, bytes,
+					AOP_FLAG_UNINTERRUPTIBLE,
+					&page, &fsdata);
 		if (status)
-			goto unlock;
+			break;
 
 		zero_user_page(page, offset, bytes, KM_USER0);
 
-		status = mapping->a_ops->commit_write(NULL, page, offset,
-							offset + bytes);
-		if (!status) {
-			pos += bytes;
-			count -= bytes;
-		}
-
-unlock:
-		unlock_page(page);
-		page_cache_release(page);
-		if (status)
-			break;
+		status = pagecache_write_end(NULL, mapping, pos, bytes, bytes,
+					page, fsdata);
+		WARN_ON(status <= 0); /* can't return less than zero! */
+		pos += bytes;
+		count -= bytes;
+		status = 0;
 	} while (count);
 
 	return (-status);
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

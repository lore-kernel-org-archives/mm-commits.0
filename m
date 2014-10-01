From: akpm@linux-foundation.org
Subject: + fs-affs-filec-fix-shadow-warnings.patch added to -mm tree
Date: Wed, 01 Oct 2014 14:43:28 -0700
Message-ID: <542c7580.3utE7LIzF2Q10HAv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaJAVn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:43:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: fix shadow warnings
has been added to the -mm tree.  Its filename is
     fs-affs-filec-fix-shadow-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-filec-fix-shadow-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-filec-fix-shadow-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: fix shadow warnings

4 functions declared variables twice resulting in shadow warnings.  This
patch renames internal variables and adds blank line after declarations.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-fix-shadow-warnings fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-fix-shadow-warnings
+++ a/fs/affs/file.c
@@ -584,11 +584,14 @@ affs_extent_file_ofs(struct inode *inode
 		bh->b_state &= ~(1UL << BH_New);
 		mark_buffer_dirty_inode(bh, inode);
 		if (prev_bh) {
-			u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
-			if (tmp)
-				affs_warning(sb, "extent_file_ofs", "next block already set for %d (%d)", bidx, tmp);
+			u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
+
+			if (tmp_next)
+				affs_warning(sb, "extent_file_ofs",
+					     "next block already set for %d (%d)",
+					     bidx, tmp_next);
 			AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
-			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
+			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
 			mark_buffer_dirty_inode(prev_bh, inode);
 			affs_brelse(prev_bh);
 		}
@@ -727,11 +730,14 @@ static int affs_write_end_ofs(struct fil
 			AFFS_DATA_HEAD(bh)->next = 0;
 			bh->b_state &= ~(1UL << BH_New);
 			if (prev_bh) {
-				u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
-				if (tmp)
-					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, tmp);
+				u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
+
+				if (tmp_next)
+					affs_warning(sb, "commit_write_ofs",
+						     "next block already set for %d (%d)",
+						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
-				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
+				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
 				mark_buffer_dirty_inode(prev_bh, inode);
 			}
 		}
@@ -758,11 +764,14 @@ static int affs_write_end_ofs(struct fil
 			AFFS_DATA_HEAD(bh)->next = 0;
 			bh->b_state &= ~(1UL << BH_New);
 			if (prev_bh) {
-				u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
-				if (tmp)
-					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, tmp);
+				u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
+
+				if (tmp_next)
+					affs_warning(sb, "commit_write_ofs",
+						     "next block already set for %d (%d)",
+						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
-				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
+				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
 				mark_buffer_dirty_inode(prev_bh, inode);
 			}
 		} else if (be32_to_cpu(AFFS_DATA_HEAD(bh)->size) < tmp)
@@ -842,12 +851,12 @@ affs_truncate(struct inode *inode)
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		loff_t size = inode->i_size;
+		loff_t isize = inode->i_size;
 		int res;
 
-		res = mapping->a_ops->write_begin(NULL, mapping, size, 0, 0, &page, &fsdata);
+		res = mapping->a_ops->write_begin(NULL, mapping, isize, 0, 0, &page, &fsdata);
 		if (!res)
-			res = mapping->a_ops->write_end(NULL, mapping, size, 0, 0, page, fsdata);
+			res = mapping->a_ops->write_end(NULL, mapping, isize, 0, 0, page, fsdata);
 		else
 			inode->i_size = AFFS_I(inode)->mmu_private;
 		mark_inode_dirty(inode);
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ufs-ballocc-remove-unused-variable.patch
fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch
fat-remove-redundant-sys_tz-declaration.patch
fs-affs-superc-remove-unused-variable.patch
fs-affs-inodec-remove-unused-variable.patch
fs-affs-filec-fix-shadow-warnings.patch
fs-omfs-block-number-sanity-check-during-fill_super-operation.patch
linux-next.patch


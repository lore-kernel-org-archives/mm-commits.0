From: akpm@linux-foundation.org
Subject: [merged] ext4-start-transaction-before-calling-into-dax.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:23 -0700
Message-ID: <55f08bdb./A4zwx+mdRTnGIiw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbIITnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: start transaction before calling into DAX
has been removed from the -mm tree.  Its filename was
     ext4-start-transaction-before-calling-into-dax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: ext4: start transaction before calling into DAX

Jan Kara pointed out that in the case where we are writing to a hole, we
can end up with a lock inversion between the page lock and the journal
lock.  We can avoid this by starting the transaction in ext4 before
calling into DAX.  The journal lock nests inside the superblock pagefault
lock, so we have to duplicate that code from dax_fault, like XFS does.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |   55 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff -puN fs/ext4/file.c~ext4-start-transaction-before-calling-into-dax fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-start-transaction-before-calling-into-dax
+++ a/fs/ext4/file.c
@@ -207,14 +207,63 @@ static void ext4_end_io_unwritten(struct
 
 static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_fault(vma, vmf, ext4_get_block_dax, ext4_end_io_unwritten);
+	int result;
+	handle_t *handle = NULL;
+	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+
+	if (write) {
+		sb_start_pagefault(sb);
+		file_update_time(vma->vm_file);
+		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
+						EXT4_DATA_TRANS_BLOCKS(sb));
+	}
+
+	if (IS_ERR(handle))
+		result = VM_FAULT_SIGBUS;
+	else
+		result = __dax_fault(vma, vmf, ext4_get_block_dax,
+						ext4_end_io_unwritten);
+
+	if (write) {
+		if (!IS_ERR(handle))
+			ext4_journal_stop(handle);
+		sb_end_pagefault(sb);
+	}
+
+	return result;
 }
 
 static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 						pmd_t *pmd, unsigned int flags)
 {
-	return dax_pmd_fault(vma, addr, pmd, flags, ext4_get_block_dax,
-				ext4_end_io_unwritten);
+	int result;
+	handle_t *handle = NULL;
+	struct inode *inode = file_inode(vma->vm_file);
+	struct super_block *sb = inode->i_sb;
+	bool write = flags & FAULT_FLAG_WRITE;
+
+	if (write) {
+		sb_start_pagefault(sb);
+		file_update_time(vma->vm_file);
+		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
+				ext4_chunk_trans_blocks(inode,
+							PMD_SIZE / PAGE_SIZE));
+	}
+
+	if (IS_ERR(handle))
+		result = VM_FAULT_SIGBUS;
+	else
+		result = __dax_pmd_fault(vma, addr, pmd, flags,
+				ext4_get_block_dax, ext4_end_io_unwritten);
+
+	if (write) {
+		if (!IS_ERR(handle))
+			ext4_journal_stop(handle);
+		sb_end_pagefault(sb);
+	}
+
+	return result;
 }
 
 static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
_

Patches currently in -mm which might be from willy@linux.intel.com are



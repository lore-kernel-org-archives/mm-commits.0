From: akpm@linux-foundation.org
Subject: [merged] fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:38 -0700
Message-ID: <200904011838.n31Icc0a008299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759659AbZDASlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs: fix page_mkwrite error cases in core code and btrfs
has been removed from the -mm tree.  Its filename was
     fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: fix page_mkwrite error cases in core code and btrfs
From: Nick Piggin <npiggin@suse.de>

page_mkwrite is called with neither the page lock nor the ptl held.  This
means a page can be concurrently truncated or invalidated out from
underneath it.  Callers are supposed to prevent truncate races themselves,
however previously the only thing they can do in case they hit one is to
raise a SIGBUS.  A sigbus is wrong for the case that the page has been
invalidated or truncated within i_size (eg.  hole punched).  Callers may
also have to perform memory allocations in this path, where again, SIGBUS
would be wrong.

The previous patch ("mm: page_mkwrite change prototype to match fault")
made it possible to properly specify errors.  Convert the generic buffer.c
code and btrfs to return sane error values (in the case of page removed
from pagecache, VM_FAULT_NOPAGE will cause the fault handler to exit
without doing anything, and the fault will be retried properly).

This fixes core code, and converts btrfs as a template/example.  All other
filesystems defining their own page_mkwrite should be fixed in a similar
manner.

Acked-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/inode.c |   11 +++++++----
 fs/buffer.c      |   12 ++++++++----
 2 files changed, 15 insertions(+), 8 deletions(-)

diff -puN fs/btrfs/inode.c~fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs
+++ a/fs/btrfs/inode.c
@@ -4307,10 +4307,15 @@ int btrfs_page_mkwrite(struct vm_area_st
 	u64 page_end;
 
 	ret = btrfs_check_data_free_space(root, inode, PAGE_CACHE_SIZE);
-	if (ret)
+	if (ret) {
+		if (ret == -ENOMEM)
+			ret = VM_FAULT_OOM;
+		else /* -ENOSPC, -EIO, etc */
+			ret = VM_FAULT_SIGBUS;
 		goto out;
+	}
 
-	ret = -EINVAL;
+	ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
 again:
 	lock_page(page);
 	size = i_size_read(inode);
@@ -4363,8 +4368,6 @@ again:
 out_unlock:
 	unlock_page(page);
 out:
-	if (ret)
-		ret = VM_FAULT_SIGBUS;
 	return ret;
 }
 
diff -puN fs/buffer.c~fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs fs/buffer.c
--- a/fs/buffer.c~fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs
+++ a/fs/buffer.c
@@ -2320,7 +2320,7 @@ block_page_mkwrite(struct vm_area_struct
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	unsigned long end;
 	loff_t size;
-	int ret = -EINVAL;
+	int ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
 
 	lock_page(page);
 	size = i_size_read(inode);
@@ -2340,10 +2340,14 @@ block_page_mkwrite(struct vm_area_struct
 	if (!ret)
 		ret = block_commit_write(page, 0, end);
 
-out_unlock:
-	if (ret)
-		ret = VM_FAULT_SIGBUS;
+	if (unlikely(ret)) {
+		if (ret == -ENOMEM)
+			ret = VM_FAULT_OOM;
+		else /* -ENOSPC, -EIO, etc */
+			ret = VM_FAULT_SIGBUS;
+	}
 
+out_unlock:
 	unlock_page(page);
 	return ret;
 }
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault-fix-page_mkwrite-error-cases.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


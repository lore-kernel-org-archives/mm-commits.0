From: akpm@linux-foundation.org
Subject: + fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:55:40 -0700
Message-ID: <200903112055.n2BKteDI002950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbZCKU5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 16:57:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com


The patch titled
     fs: fix page_mkwrite error cases in core code and btrfs
has been added to the -mm tree.  Its filename is
     fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs.patch

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
@@ -2466,7 +2466,7 @@ block_page_mkwrite(struct vm_area_struct
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	unsigned long end;
 	loff_t size;
-	int ret = -EINVAL;
+	int ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
 
 	lock_page(page);
 	size = i_size_read(inode);
@@ -2486,10 +2486,14 @@ block_page_mkwrite(struct vm_area_struct
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

fs-new-inode-i_state-corruption-fix.patch
linux-next.patch
slqb-use-correct-name-for-rcu-callback.patch
slqb-cleanup-for-concatenating-kmlist.patch
fs-avoid-i_new-inodes.patch
vmap-remove-needless-lock-and-list-in-vmap.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
mm-page_mkwrite-change-prototype-to-match-fault.patch
fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


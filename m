From: akpm@linux-foundation.org
Subject: - tmpfs-fix-kernel-bug-in-shmem_delete_inode.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:29:33 -0700
Message-ID: <200807292029.m6TKTX4m019710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYG2U36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:29:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, kel@otaku42.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     tmpfs: fix kernel BUG in shmem_delete_inode
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-kernel-bug-in-shmem_delete_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: fix kernel BUG in shmem_delete_inode
From: Hugh Dickins <hugh@veritas.com>

SuSE's insserve initscript ordering program hits kernel BUG at mm/shmem.c:814
on 2.6.26.  It's using posix_fadvise on directories, and the shmem_readpage
method added in 2.6.23 is letting POSIX_FADV_WILLNEED allocate useless pages
to a tmpfs directory, incrementing i_blocks count but never decrementing it.

Fix this by assigning shmem_aops (pointing to readpage and writepage and
set_page_dirty) only when it's needed, on a regular file or a long symlink.

Many thanks to Kel for outstanding bugreport and steps to reproduce it.

Reported-by: Kel Modderman <kel@otaku42.de>
Tested-by: Kel Modderman <kel@otaku42.de>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-fix-kernel-bug-in-shmem_delete_inode mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-kernel-bug-in-shmem_delete_inode
+++ a/mm/shmem.c
@@ -1513,7 +1513,6 @@ shmem_get_inode(struct super_block *sb, 
 		inode->i_uid = current->fsuid;
 		inode->i_gid = current->fsgid;
 		inode->i_blocks = 0;
-		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inode->i_generation = get_seconds();
@@ -1528,6 +1527,7 @@ shmem_get_inode(struct super_block *sb, 
 			init_special_inode(inode, mode, dev);
 			break;
 		case S_IFREG:
+			inode->i_mapping->a_ops = &shmem_aops;
 			inode->i_op = &shmem_inode_operations;
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy,
@@ -1929,6 +1929,7 @@ static int shmem_symlink(struct inode *d
 			return error;
 		}
 		unlock_page(page);
+		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
 		kaddr = kmap_atomic(page, KM_USER0);
 		memcpy(kaddr, symname, len);
_

Patches currently in -mm which might be from hugh@veritas.com are

vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
powerpc-lockless-get_user_pages.patch
git-unionfs.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
prio_tree-debugging-patch.patch


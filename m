From: akpm@linux-foundation.org
Subject: - mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:03 -0700
Message-ID: <200810012150.m91Lo3hY005816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612AbYJAVuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, hugh@veritas.com, mingo@elte.hu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     mm: tiny-shmem fix lock ordering: mmap_sem vs i_mutex
has been removed from the -mm tree.  Its filename was
     mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: tiny-shmem fix lock ordering: mmap_sem vs i_mutex
From: Nick Piggin <npiggin@suse.de>

tiny-shmem calls do_truncate in shmem_file_setup.  do_truncate takes
i_mutex, and shmem_file_setup is called with mmap_sem held.  However
i_mutex nests outside mmap_sem.

Copy the code in shmem.c to avoid this problem.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/tiny-shmem.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN mm/tiny-shmem.c~mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex
+++ a/mm/tiny-shmem.c
@@ -65,31 +65,25 @@ struct file *shmem_file_setup(char *name
 	if (!dentry)
 		goto put_memory;
 
-	error = -ENOSPC;
-	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
-	if (!inode)
-		goto put_dentry;
-
-	d_instantiate(dentry, inode);
 	error = -ENFILE;
-	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-			&ramfs_file_operations);
+	file = get_empty_filp();
 	if (!file)
 		goto put_dentry;
 
-	inode->i_nlink = 0;	/* It is unlinked */
-
-	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
-	if (error < 0)
+	error = -ENOSPC;
+	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
+	if (!inode)
 		goto close_file;
 
+	d_instantiate(dentry, inode);
+	inode->i_size = size;
+	inode->i_nlink = 0;	/* It is unlinked */
+	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
+			&ramfs_file_operations);
 	return file;
 
 close_file:
 	put_filp(file);
-	return ERR_PTR(error);
-
 put_dentry:
 	dput(dentry);
 put_memory:
_

Patches currently in -mm which might be from npiggin@suse.de are

inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem.patch
git-x86.patch
git-cifs.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
mm-pagecache-insertion-fewer-atomics.patch
mm-unlockless-reclaim.patch
mm-page-lock-use-lock-bitops.patch
fs-buffer-lock-use-lock-bitops.patch
mm-page-allocator-minor-speedup.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch


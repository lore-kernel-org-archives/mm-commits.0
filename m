From: akpm@linux-foundation.org
Subject: - mm-tiny-shmem-nommu-fix.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:28:54 -0700
Message-ID: <200810032128.m93LSsfW016647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbYJCV3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:29:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, dhowells@redhat.com, hugh@veritas.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     mm: tiny-shmem nommu fix
has been removed from the -mm tree.  Its filename was
     mm-tiny-shmem-nommu-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: tiny-shmem nommu fix
From: Nick Piggin <npiggin@suse.de>

The previous patch db203d53d474aa068984e409d807628f5841da1b ("mm:
tiny-shmem fix lock ordering: mmap_sem vs i_mutex") to fix the lock
ordering in tiny-shmem breaks shared anonymous and IPC memory on NOMMU
architectures because it was using the expanding truncate to signal ramfs
to allocate a physically contiguous RAM backing the inode (otherwise it is
unusable for "memory mapping" it to userspace).

However do_truncate is what caused the lock ordering error, due to it
taking i_mutex.  In this case, we can actually just call ramfs directly to
allocate memory for the mapping, rather than go via truncate.

Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    2 +-
 include/linux/ramfs.h |    1 +
 mm/tiny-shmem.c       |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/ramfs/file-nommu.c~mm-tiny-shmem-nommu-fix fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~mm-tiny-shmem-nommu-fix
+++ a/fs/ramfs/file-nommu.c
@@ -58,7 +58,7 @@ const struct inode_operations ramfs_file
  * size 0 on the assumption that it's going to be used for an mmap of shared
  * memory
  */
-static int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
+int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 {
 	struct pagevec lru_pvec;
 	unsigned long npages, xpages, loop, limit;
diff -puN include/linux/ramfs.h~mm-tiny-shmem-nommu-fix include/linux/ramfs.h
--- a/include/linux/ramfs.h~mm-tiny-shmem-nommu-fix
+++ a/include/linux/ramfs.h
@@ -6,6 +6,7 @@ extern int ramfs_get_sb(struct file_syst
 	 int flags, const char *dev_name, void *data, struct vfsmount *mnt);
 
 #ifndef CONFIG_MMU
+extern int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize);
 extern unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 						   unsigned long addr,
 						   unsigned long len,
diff -puN mm/tiny-shmem.c~mm-tiny-shmem-nommu-fix mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~mm-tiny-shmem-nommu-fix
+++ a/mm/tiny-shmem.c
@@ -80,6 +80,12 @@ struct file *shmem_file_setup(char *name
 	inode->i_nlink = 0;	/* It is unlinked */
 	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
 			&ramfs_file_operations);
+
+#ifndef CONFIG_MMU
+	error = ramfs_nommu_expand_for_mapping(inode, size);
+	if (error)
+		goto close_file;
+#endif
 	return file;
 
 close_file:
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
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
ecryptfs-convert-to-use-new-aops.patch
ecryptfs-convert-to-use-new-aops-update.patch
afs-convert-to-new-aops.patch
afs-convert-to-new-aops-update.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch


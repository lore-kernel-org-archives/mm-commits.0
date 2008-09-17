From: akpm@linux-foundation.org
Subject: + mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex.patch added to -mm tree
Date: Wed, 17 Sep 2008 13:14:25 -0700
Message-ID: <200809172014.m8HKEPqe028496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbYIQUPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 16:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, a.p.zijlstra@chello.nl, hugh@veritas.com, mingo@elte.hu, mpm@selenic.com


The patch titled
     mm: tiny-shmem fix lock ordering: mmap_sem vs i_mutex
has been added to the -mm tree.  Its filename is
     mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: tiny-shmem fix lock ordering: mmap_sem vs i_mutex
From: Nick Piggin <npiggin@suse.de>

tiny-shmem calls do_truncate in shmem_file_setup.  do_truncate takes
i_mutex, and shmem_file_setup is called with mmap_sem held.  However
i_mutex nests outside mmap_sem.

Copy the code in shmem.c to avoid this problem.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/tiny-shmem.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff -puN mm/tiny-shmem.c~mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex
+++ a/mm/tiny-shmem.c
@@ -65,31 +65,25 @@ struct file *shmem_file_setup(char *name
 	if (!dentry)
 		goto put_memory;
 
+        error = -ENFILE;
+        file = get_empty_filp();
+        if (!file)
+                goto put_dentry;
+
 	error = -ENOSPC;
 	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
-		goto put_dentry;
-
-	d_instantiate(dentry, inode);
-	error = -ENFILE;
-	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-			&ramfs_file_operations);
-	if (!file)
-		goto put_dentry;
-
-	inode->i_nlink = 0;	/* It is unlinked */
-
-	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
-	if (error < 0)
 		goto close_file;
 
+        d_instantiate(dentry, inode);
+        inode->i_size = size;
+        inode->i_nlink = 0;     /* It is unlinked */
+        init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
+                        &ramfs_file_operations);
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

linux-next.patch
sysfs-fix-deadlock.patch
inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem.patch
mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex.patch
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


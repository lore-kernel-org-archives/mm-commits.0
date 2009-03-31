From: akpm@linux-foundation.org
Subject: [nacked] mm-shmemc-fix-division-by-zero.patch removed from -mm tree
Date: Tue, 31 Mar 2009 13:08:46 -0700
Message-ID: <200903312008.n2VK8lZj018230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbZCaULJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 16:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yur@emcraft.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm/shmem.c: fix division by zero
has been removed from the -mm tree.  Its filename was
     mm-shmemc-fix-division-by-zero.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/shmem.c: fix division by zero
From: Yuri Tikhonov <yur@emcraft.com>

Fix a division by zero which we have in shmem_truncate_range() and
shmem_unuse_inode() when using big PAGE_SIZE values (e.g.  256KB on ppc44x).

With 256KB PAGE_SIZE the ENTRIES_PER_PAGEPAGE constant becomes too large
(0x1.0000.0000), so this patch just changes the types from 'ulong' to
'ullong' where it's necessary.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/shmem.c~mm-shmemc-fix-division-by-zero mm/shmem.c
--- a/mm/shmem.c~mm-shmemc-fix-division-by-zero
+++ a/mm/shmem.c
@@ -66,7 +66,7 @@ static struct vfsmount *shm_mnt;
 #include <asm/pgtable.h>
 
 #define ENTRIES_PER_PAGE (PAGE_CACHE_SIZE/sizeof(unsigned long))
-#define ENTRIES_PER_PAGEPAGE (ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
+#define ENTRIES_PER_PAGEPAGE ((unsigned long long)ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
 #define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 
 #define SHMEM_MAX_INDEX  (SHMEM_NR_DIRECT + (ENTRIES_PER_PAGEPAGE/2) * (ENTRIES_PER_PAGE+1))
@@ -104,7 +104,7 @@ static unsigned long shmem_default_max_i
 }
 #endif
 
-static int shmem_getpage(struct inode *inode, unsigned long idx,
+static int shmem_getpage(struct inode *inode, unsigned long long idx,
 			 struct page **pagep, enum sgp_type sgp, int *type);
 
 static inline struct page *shmem_dir_alloc(gfp_t gfp_mask)
@@ -542,7 +542,7 @@ static void shmem_truncate_range(struct 
 	int punch_hole;
 	spinlock_t *needs_lock;
 	spinlock_t *punch_lock;
-	unsigned long upper_limit;
+	unsigned long long upper_limit;
 
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 	idx = (start + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
@@ -1188,7 +1188,7 @@ static inline struct mempolicy *shmem_ge
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache
  */
-static int shmem_getpage(struct inode *inode, unsigned long idx,
+static int shmem_getpage(struct inode *inode, unsigned long long idx,
 			struct page **pagep, enum sgp_type sgp, int *type)
 {
 	struct address_space *mapping = inode->i_mapping;
_

Patches currently in -mm which might be from yur@emcraft.com are

origin.patch
mm-shmemc-fix-division-by-zero.patch


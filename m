From: akpm@linux-foundation.org
Subject: [patch 035/102] xfs: use memalloc_nofs_{save,restore}
 instead of memalloc_noio*
Date: Wed, 03 May 2017 14:53:19 -0700
Message-ID: <20170503215319.ctTXUQE17%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECVxj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:53:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bfoster@redhat.com, clm@fb.com, darrick.wong@oracle.com, david@fromorbit.com, dsterba@suse.cz, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, nborisov@suse.com, peterz@infradead.org, torvalds@linux-foundation.org, tytso@mit.edu, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: xfs: use memalloc_nofs_{save,restore} instead of memalloc_noio*

kmem_zalloc_large and _xfs_buf_map_pages use memalloc_noio_{save,restore}
API to prevent from reclaim recursion into the fs because vmalloc can
invoke unconditional GFP_KERNEL allocations and these functions might be
called from the NOFS contexts.  The memalloc_noio_save will enforce
GFP_NOIO context which is even weaker than GFP_NOFS and that seems to be
unnecessary.  Let's use memalloc_nofs_{save,restore} instead as it should
provide exactly what we need here - implicit GFP_NOFS context.

Link: http://lkml.kernel.org/r/20170306131408.9828-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/kmem.c    |   12 ++++++------
 fs/xfs/xfs_buf.c |    8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/xfs/kmem.c~xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio fs/xfs/kmem.c
--- a/fs/xfs/kmem.c~xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio
+++ a/fs/xfs/kmem.c
@@ -48,7 +48,7 @@ kmem_alloc(size_t size, xfs_km_flags_t f
 void *
 kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 {
-	unsigned noio_flag = 0;
+	unsigned nofs_flag = 0;
 	void	*ptr;
 	gfp_t	lflags;
 
@@ -60,17 +60,17 @@ kmem_zalloc_large(size_t size, xfs_km_fl
 	 * __vmalloc() will allocate data pages and auxillary structures (e.g.
 	 * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context
 	 * here. Hence we need to tell memory reclaim that we are in such a
-	 * context via PF_MEMALLOC_NOIO to prevent memory reclaim re-entering
+	 * context via PF_MEMALLOC_NOFS to prevent memory reclaim re-entering
 	 * the filesystem here and potentially deadlocking.
 	 */
-	if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
-		noio_flag = memalloc_noio_save();
+	if (flags & KM_NOFS)
+		nofs_flag = memalloc_nofs_save();
 
 	lflags = kmem_flags_convert(flags);
 	ptr = __vmalloc(size, lflags | __GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
 
-	if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
-		memalloc_noio_restore(noio_flag);
+	if (flags & KM_NOFS)
+		memalloc_nofs_restore(nofs_flag);
 
 	return ptr;
 }
diff -puN fs/xfs/xfs_buf.c~xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio fs/xfs/xfs_buf.c
--- a/fs/xfs/xfs_buf.c~xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio
+++ a/fs/xfs/xfs_buf.c
@@ -443,17 +443,17 @@ _xfs_buf_map_pages(
 		bp->b_addr = NULL;
 	} else {
 		int retried = 0;
-		unsigned noio_flag;
+		unsigned nofs_flag;
 
 		/*
 		 * vm_map_ram() will allocate auxillary structures (e.g.
 		 * pagetables) with GFP_KERNEL, yet we are likely to be under
 		 * GFP_NOFS context here. Hence we need to tell memory reclaim
-		 * that we are in such a context via PF_MEMALLOC_NOIO to prevent
+		 * that we are in such a context via PF_MEMALLOC_NOFS to prevent
 		 * memory reclaim re-entering the filesystem here and
 		 * potentially deadlocking.
 		 */
-		noio_flag = memalloc_noio_save();
+		nofs_flag = memalloc_nofs_save();
 		do {
 			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
 						-1, PAGE_KERNEL);
@@ -461,7 +461,7 @@ _xfs_buf_map_pages(
 				break;
 			vm_unmap_aliases();
 		} while (retried++ <= 1);
-		memalloc_noio_restore(noio_flag);
+		memalloc_nofs_restore(nofs_flag);
 
 		if (!bp->b_addr)
 			return -ENOMEM;
_

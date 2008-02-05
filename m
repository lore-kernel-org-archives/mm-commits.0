From: akpm@linux-foundation.org
Subject: - tmpfs-allocate-on-read-when-stacked.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:35 -0800
Message-ID: <200802052230.m15MUGZw012055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53371 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932071AbYBEWmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: allocate on read when stacked
has been removed from the -mm tree.  Its filename was
     tmpfs-allocate-on-read-when-stacked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: allocate on read when stacked
From: Hugh Dickins <hugh@veritas.com>

tmpfs is expected to limit the memory used (unless mounted with nr_blocks=0 or
size=0).  But if a stacked filesystem such as unionfs gets pages from a sparse
tmpfs file by reading holes, and then writes to them, it can easily exceed any
such limit at present.

So suppress the SGP_READ "don't allocate page" ZERO_PAGE optimization when
reading for the kernel (a KERNEL_DS check, ugh, sorry about that).  Indeed,
pessimistically mark such pages as dirty, so they cannot get reclaimed and
unaccounted by mistake.  The venerable shmem_recalc_inode code (originally to
account for the reclaim of clean pages) suffices to get the accounting right
when swappages are dropped in favour of more uptodate filepages.

This also fixes the NULL shmem_swp_entry BUG or oops in shmem_writepage,
caused by unionfs writing to a very sparse tmpfs file: to minimize memory
allocation in swapout, tmpfs requires the swap vector be allocated upfront,
which wasn't always happening in this stacked case.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-allocate-on-read-when-stacked mm/shmem.c
--- a/mm/shmem.c~tmpfs-allocate-on-read-when-stacked
+++ a/mm/shmem.c
@@ -80,6 +80,7 @@
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
+	SGP_DIRTY,	/* like SGP_CACHE, but set new page dirty */
 	SGP_WRITE,	/* may exceed i_size, may allocate page */
 };
 
@@ -1333,6 +1334,8 @@ repeat:
 		clear_highpage(filepage);
 		flush_dcache_page(filepage);
 		SetPageUptodate(filepage);
+		if (sgp == SGP_DIRTY)
+			set_page_dirty(filepage);
 	}
 done:
 	*pagep = filepage;
@@ -1518,6 +1521,15 @@ static void do_shmem_file_read(struct fi
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
 	unsigned long index, offset;
+	enum sgp_type sgp = SGP_READ;
+
+	/*
+	 * Might this read be for a stacking filesystem?  Then when reading
+	 * holes of a sparse file, we actually need to allocate those pages,
+	 * and even mark them dirty, so it cannot exceed the max_blocks limit.
+	 */
+	if (segment_eq(get_fs(), KERNEL_DS))
+		sgp = SGP_DIRTY;
 
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
@@ -1536,7 +1548,7 @@ static void do_shmem_file_read(struct fi
 				break;
 		}
 
-		desc->error = shmem_getpage(inode, index, &page, SGP_READ, NULL);
+		desc->error = shmem_getpage(inode, index, &page, sgp, NULL);
 		if (desc->error) {
 			if (desc->error == -EINVAL)
 				desc->error = 0;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch

From: akpm@linux-foundation.org
Subject: [merged] xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:10:25 -0700
Message-ID: <20170504191025.IQwPsQgkJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753796AbdEDTK2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfoster@redhat.com, clm@fb.com, darrick.wong@oracle.com, david@fromorbit.com, dsterba@suse.cz, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, nborisov@suse.com, peterz@infradead.org, tytso@mit.edu, vbabka@suse.cz


The patch titled
     Subject: xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS
has been removed from the -mm tree.  Its filename was
     xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS

xfs has defined PF_FSTRANS to declare a scope GFP_NOFS semantic quite some
time ago.  We would like to make this concept more generic and use it for
other filesystems as well.  Let's start by giving the flag a more generic
name PF_MEMALLOC_NOFS which is in line with an exiting PF_MEMALLOC_NOIO
already used for the same purpose for GFP_NOIO contexts.  Replace all
PF_FSTRANS usage from the xfs code in the first step before we introduce a
full API for it as xfs uses the flag directly anyway.

This patch doesn't introduce any functional change.

Link: http://lkml.kernel.org/r/20170306131408.9828-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

 fs/xfs/kmem.c             |    4 ++--
 fs/xfs/kmem.h             |    2 +-
 fs/xfs/libxfs/xfs_btree.c |    2 +-
 fs/xfs/xfs_aops.c         |    6 +++---
 fs/xfs/xfs_trans.c        |   12 ++++++------
 include/linux/sched.h     |    2 ++
 6 files changed, 15 insertions(+), 13 deletions(-)

diff -puN fs/xfs/kmem.c~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs fs/xfs/kmem.c
--- a/fs/xfs/kmem.c~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs
+++ a/fs/xfs/kmem.c
@@ -63,13 +63,13 @@ kmem_zalloc_large(size_t size, xfs_km_fl
 	 * context via PF_MEMALLOC_NOIO to prevent memory reclaim re-entering
 	 * the filesystem here and potentially deadlocking.
 	 */
-	if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
+	if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
 		noio_flag = memalloc_noio_save();
 
 	lflags = kmem_flags_convert(flags);
 	ptr = __vmalloc(size, lflags | __GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
 
-	if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
+	if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
 		memalloc_noio_restore(noio_flag);
 
 	return ptr;
diff -puN fs/xfs/kmem.h~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs fs/xfs/kmem.h
--- a/fs/xfs/kmem.h~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs
+++ a/fs/xfs/kmem.h
@@ -50,7 +50,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
 		lflags = GFP_ATOMIC | __GFP_NOWARN;
 	} else {
 		lflags = GFP_KERNEL | __GFP_NOWARN;
-		if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
+		if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
 			lflags &= ~__GFP_FS;
 	}
 
diff -puN fs/xfs/libxfs/xfs_btree.c~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs fs/xfs/libxfs/xfs_btree.c
--- a/fs/xfs/libxfs/xfs_btree.c~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs
+++ a/fs/xfs/libxfs/xfs_btree.c
@@ -2886,7 +2886,7 @@ xfs_btree_split_worker(
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
 	unsigned long		pflags;
-	unsigned long		new_pflags = PF_FSTRANS;
+	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
 
 	/*
 	 * we are in a transaction context here, but may also be doing work
diff -puN fs/xfs/xfs_aops.c~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs
+++ a/fs/xfs/xfs_aops.c
@@ -189,7 +189,7 @@ xfs_setfilesize_trans_alloc(
 	 * We hand off the transaction to the completion thread now, so
 	 * clear the flag here.
 	 */
-	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	return 0;
 }
 
@@ -252,7 +252,7 @@ xfs_setfilesize_ioend(
 	 * thus we need to mark ourselves as being in a transaction manually.
 	 * Similarly for freeze protection.
 	 */
-	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
 
 	/* we abort the update if there was an IO error */
@@ -1016,7 +1016,7 @@ xfs_do_writepage(
 	 * Given that we do not allow direct reclaim to call us, we should
 	 * never be called while in a filesystem transaction.
 	 */
-	if (WARN_ON_ONCE(current->flags & PF_FSTRANS))
+	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
 		goto redirty;
 
 	/*
diff -puN fs/xfs/xfs_trans.c~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs fs/xfs/xfs_trans.c
--- a/fs/xfs/xfs_trans.c~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs
+++ a/fs/xfs/xfs_trans.c
@@ -134,7 +134,7 @@ xfs_trans_reserve(
 	bool		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
 	/* Mark this thread as being in a transaction */
-	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 
 	/*
 	 * Attempt to reserve the needed disk blocks by decrementing
@@ -144,7 +144,7 @@ xfs_trans_reserve(
 	if (blocks > 0) {
 		error = xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
 		if (error != 0) {
-			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+			current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 			return -ENOSPC;
 		}
 		tp->t_blk_res += blocks;
@@ -221,7 +221,7 @@ undo_blocks:
 		tp->t_blk_res = 0;
 	}
 
-	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 
 	return error;
 }
@@ -914,7 +914,7 @@ __xfs_trans_commit(
 
 	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
 
-	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free(tp);
 
 	/*
@@ -944,7 +944,7 @@ out_unreserve:
 		if (commit_lsn == -1 && !error)
 			error = -EIO;
 	}
-	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free_items(tp, NULLCOMMITLSN, !!error);
 	xfs_trans_free(tp);
 
@@ -998,7 +998,7 @@ xfs_trans_cancel(
 		xfs_log_done(mp, tp->t_ticket, NULL, false);
 
 	/* mark this thread as no longer being in a transaction */
-	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 
 	xfs_trans_free_items(tp, NULLCOMMITLSN, dirty);
 	xfs_trans_free(tp);
diff -puN include/linux/sched.h~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs include/linux/sched.h
--- a/include/linux/sched.h~xfs-abstract-pf_fstrans-to-pf_memalloc_nofs
+++ a/include/linux/sched.h
@@ -1237,6 +1237,8 @@ extern struct pid *cad_pid;
 #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
 
+#define PF_MEMALLOC_NOFS PF_FSTRANS	/* Transition to a more generic GFP_NOFS scope semantic */
+
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
  * tasks can access tsk->flags in readonly mode for example
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-introduce-kvalloc-helpers.patch
mm-vmalloc-properly-track-vmalloc-users.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch
mm-vmalloc-use-__gfp_highmem-implicitly.patch


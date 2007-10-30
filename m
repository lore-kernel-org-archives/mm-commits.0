From: akpm@linux-foundation.org
Subject: - fix-tmpfs-bug-and-aop_writepage_activate.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:29 -0700
Message-ID: <200710301806.l9UI6TRh020525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbXJ3SUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:20:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, ezk@cs.sunysb.edu, penberg@cs.helsinki.fi, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE
has been removed from the -mm tree.  Its filename was
     fix-tmpfs-bug-and-aop_writepage_activate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE
From: Hugh Dickins <hugh@veritas.com>

It's possible to provoke unionfs (not yet in mainline, though in mm and
some distros) to hit shmem_writepage's BUG_ON(page_mapped(page)).  I expect
it's possible to provoke the 2.6.23 ecryptfs in the same way (but the
2.6.24 ecryptfs no longer calls lower level's ->writepage).

This came to light with the recent find that AOP_WRITEPAGE_ACTIVATE could
leak from tmpfs via write_cache_pages and unionfs to userspace.  There's
already a fix (e423003028183df54f039dfda8b58c49e78c89d7 - writeback: don't
propagate AOP_WRITEPAGE_ACTIVATE) in the tree for that, and it's okay so
far as it goes; but insufficient because it doesn't address the underlying
issue, that shmem_writepage expects to be called only by vmscan (relying on
backing_dev_info capabilities to prevent the normal writeback path from
ever approaching it).

That's an increasingly fragile assumption, and ramdisk_writepage (the other
source of AOP_WRITEPAGE_ACTIVATEs) is already careful to check
wbc->for_reclaim before returning it.  Make the same check in
shmem_writepage, thereby sidestepping the page_mapped BUG also.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: <stable@kernel.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN mm/shmem.c~fix-tmpfs-bug-and-aop_writepage_activate mm/shmem.c
--- a/mm/shmem.c~fix-tmpfs-bug-and-aop_writepage_activate
+++ a/mm/shmem.c
@@ -915,6 +915,21 @@ static int shmem_writepage(struct page *
 	struct inode *inode;
 
 	BUG_ON(!PageLocked(page));
+	/*
+	 * shmem_backing_dev_info's capabilities prevent regular writeback or
+	 * sync from ever calling shmem_writepage; but a stacking filesystem
+	 * may use the ->writepage of its underlying filesystem, in which case
+	 * we want to do nothing when that underlying filesystem is tmpfs
+	 * (writing out to swap is useful as a response to memory pressure, but
+	 * of no use to stabilize the data) - just redirty the page, unlock it
+	 * and claim success in this case.  AOP_WRITEPAGE_ACTIVATE, and the
+	 * page_mapped check below, must be avoided unless we're in reclaim.
+	 */
+	if (!wbc->for_reclaim) {
+		set_page_dirty(page);
+		unlock_page(page);
+		return 0;
+	}
 	BUG_ON(page_mapped(page));
 
 	mapping = page->mapping;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
memory-controller-memory-accounting-v7.patch
prio_tree-debugging-patch.patch

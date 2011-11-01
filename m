From: akpm@linux-foundation.org
Subject: [merged] xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:09:11 -0700
Message-ID: <201111012109.pA1L9B2X025560@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15456 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab1KAVJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, min


The patch titled
     Subject: xfs: warn if direct reclaim tries to writeback pages
has been removed from the -mm tree.  Its filename was
     xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: xfs: warn if direct reclaim tries to writeback pages

Direct reclaim should never writeback pages.  For now, handle the
situation and warn about it.  Ultimately, this will be a BUG_ON.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alex Elder <aelder@sgi.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_aops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/xfs/xfs_aops.c~xfs-warn-if-direct-reclaim-tries-to-writeback-pages fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~xfs-warn-if-direct-reclaim-tries-to-writeback-pages
+++ a/fs/xfs/xfs_aops.c
@@ -902,11 +902,11 @@ xfs_vm_writepage(
 	 * random callers for direct reclaim or memcg reclaim.  We explicitly
 	 * allow reclaim from kswapd as the stack usage there is relatively low.
 	 *
-	 * This should really be done by the core VM, but until that happens
-	 * filesystems like XFS, btrfs and ext4 have to take care of this
-	 * by themselves.
+	 * This should never happen except in the case of a VM regression so
+	 * warn about it.
 	 */
-	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
+	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
+			PF_MEMALLOC))
 		goto redirty;
 
 	/*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch


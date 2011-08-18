From: akpm@linux-foundation.org
Subject: + xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch added to -mm tree
Date: Thu, 18 Aug 2011 16:54:45 -0700
Message-ID: <201108182354.p7INsjAW002677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261Ab1HRXzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 19:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, riel@redhat.com, tytso@mit.edu


The patch titled
     xfs: warn if direct reclaim tries to writeback pages
has been added to the -mm tree.  Its filename is
     xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: warn if direct reclaim tries to writeback pages
From: Mel Gorman <mgorman@suse.de>

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
Signed-off-by: Andrew Morton <>
---

 fs/xfs/xfs_aops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/xfs/xfs_aops.c~xfs-warn-if-direct-reclaim-tries-to-writeback-pages fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~xfs-warn-if-direct-reclaim-tries-to-writeback-pages
+++ a/fs/xfs/xfs_aops.c
@@ -925,11 +925,11 @@ xfs_vm_writepage(
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

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
hugepages-fix-race-between-hugetlbfs-umount-and-quota-update-checkpatch-fixes.patch


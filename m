From: akpm@linux-foundation.org
Subject: [folded] writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:24:40 -0800
Message-ID: <201101132324.p0DNOesZ006877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756980Ab1AMXZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:25:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, axboe@kernel.dk, david@fromorbit.com, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, jengelh@medozas.de, mm-commits@vger.kernel.org


The patch titled
     writeback-stop-background-kupdate-works-from-livelocking-other-works-update
has been removed from the -mm tree.  Its filename was
     writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch

This patch was dropped because it was folded into writeback-stop-background-kupdate-works-from-livelocking-other-works.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback-stop-background-kupdate-works-from-livelocking-other-works-update
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de> 
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~writeback-stop-background-kupdate-works-from-livelocking-other-works-update fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-stop-background-kupdate-works-from-livelocking-other-works-update
+++ a/fs/fs-writeback.c
@@ -651,9 +651,10 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		/*
-		 * Background writeout and kupdate-style writeback are
-		 * easily livelockable. Stop them if there is other work
-		 * to do so that e.g. sync can proceed.
+		 * Background writeout and kupdate-style writeback may
+		 * run forever. Stop them if there is other work to do
+		 * so that e.g. sync can proceed. They'll be restarted
+		 * after the other works are all done.
 		 */
 		if ((work->for_background || work->for_kupdate) &&
 		    !list_empty(&wb->bdi->work_list))
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-avoid-livelocking-wb_sync_all-writeback-update.patch
mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch
mm-find_get_pages_contig-fixlet.patch
mm-smaps-export-mlock-information.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-use-zalloc-rather-than-mallocmemset.patch


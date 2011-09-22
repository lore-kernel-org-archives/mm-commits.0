From: akpm@google.com
Subject: [merged] mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread.patch removed from -mm tree
Date: Thu, 22 Sep 2011 14:00:56 -0700
Message-ID: <201109222100.p8ML0u5u019275@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:11104 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1IVVBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:01:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add comment explaining task state setting in bdi_forker_thread()
has been removed from the -mm tree.  Its filename was
     mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: add comment explaining task state setting in bdi_forker_thread()

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/backing-dev.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/backing-dev.c~mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread mm/backing-dev.c
--- a/mm/backing-dev.c~mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread
+++ a/mm/backing-dev.c
@@ -401,6 +401,13 @@ static int bdi_forker_thread(void *ptr)
 		}
 
 		spin_lock_bh(&bdi_lock);
+		/*
+		 * In the following loop we are going to check whether we have
+		 * some work to do without any synchronization with tasks
+		 * waking us up to do work for them. So we have to set task
+		 * state already here so that we don't miss wakeups coming
+		 * after we verify some condition.
+		 */
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		list_for_each_entry(bdi, &bdi_list, bdi_list) {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch


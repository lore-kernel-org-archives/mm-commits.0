From: akpm@linux-foundation.org
Subject: [merged]
 mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:20:07 -0700
Message-ID: <51dc9aa7.F4v90ypRzH6/tKCa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3GIXUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, fengguang.wu@intel.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,fengguang.wu@intel.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:07 -0700


The patch titled
     Subject: mm/writeback: don't check force_wait to handle bdi->work_list
has been removed from the -mm tree.  Its filename was
     mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/writeback: don't check force_wait to handle bdi->work_list

After 839a8e86 ("writeback: replace custom worker pool implementation with
unbound workqueue"), bdi_writeback_workfn runs off bdi_writeback->dwork,
on each execution, it processes bdi->work_list and reschedules if there
are more things to do instead of flush any work that race with us
existing.  It is unecessary to check force_wait in wb_do_writeback since
it is always 0 after the mentioned commit.  This patch remove the
force_wait in wb_do_writeback.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN fs/fs-writeback.c~mm-writeback-dont-check-force_wait-to-handle-bdi-work_list fs/fs-writeback.c
--- a/fs/fs-writeback.c~mm-writeback-dont-check-force_wait-to-handle-bdi-work_list
+++ a/fs/fs-writeback.c
@@ -963,7 +963,7 @@ static long wb_check_old_data_flush(stru
 /*
  * Retrieve work items and do the writeback they describe
  */
-static long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
+static long wb_do_writeback(struct bdi_writeback *wb)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct wb_writeback_work *work;
@@ -971,12 +971,6 @@ static long wb_do_writeback(struct bdi_w
 
 	set_bit(BDI_writeback_running, &wb->bdi->state);
 	while ((work = get_next_work_item(bdi)) != NULL) {
-		/*
-		 * Override sync mode, in case we must wait for completion
-		 * because this thread is exiting now.
-		 */
-		if (force_wait)
-			work->sync_mode = WB_SYNC_ALL;
 
 		trace_writeback_exec(bdi, work);
 
@@ -1025,7 +1019,7 @@ void bdi_writeback_workfn(struct work_st
 		 * rescuer as work_list needs to be drained.
 		 */
 		do {
-			pages_written = wb_do_writeback(wb, 0);
+			pages_written = wb_do_writeback(wb);
 			trace_writeback_pages_written(pages_written);
 		} while (!list_empty(&bdi->work_list));
 	} else {
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: +
 mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch added to
 -mm tree
Date: Tue, 25 Jun 2013 15:23:47 -0700
Message-ID: <51ca1873.vHqfrr9Fe86kOAud%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3FYWXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 18:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, fengguang.wu@intel.com, liwanp@linux.vnet.ibm.com

Subject: + mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,fengguang.wu@intel.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 15:23:47 -0700


The patch titled
     Subject: mm/writeback: don't check force_wait to handle bdi->work_list
has been added to the -mm tree.  Its filename is
     mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -959,7 +959,7 @@ static long wb_check_old_data_flush(stru
 /*
  * Retrieve work items and do the writeback they describe
  */
-static long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
+static long wb_do_writeback(struct bdi_writeback *wb)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct wb_writeback_work *work;
@@ -967,12 +967,6 @@ static long wb_do_writeback(struct bdi_w
 
 	set_bit(BDI_writeback_running, &wb->bdi->state);
 	while ((work = get_next_work_item(bdi)) != NULL) {
-		/*
-		 * Override sync mode, in case we must wait for completion
-		 * because this thread is exiting now.
-		 */
-		if (force_wait)
-			work->sync_mode = WB_SYNC_ALL;
 
 		trace_writeback_exec(bdi, work);
 
@@ -1021,7 +1015,7 @@ void bdi_writeback_workfn(struct work_st
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

mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix.patch
mm-pageblock-remove-get-set_pageblock_flags.patch
mm-hugetlb-remove-hugetlb_prefault.patch
mm-hugetlb-use-already-exist-interface-huge_page_shift.patch
mm-writeback-remove-wb_reason_name.patch
mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch
mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch
mm-page_alloc-fix-doc-for-numa_zonelist_order.patch
mm-thp-fix-doc-for-transparent-huge-zero-page.patch
mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch


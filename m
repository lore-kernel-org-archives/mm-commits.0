From: akpm@linux-foundation.org
Subject: [patch 126/131] writeback: remove unused function
 parameter
Date: Wed, 15 Nov 2017 17:39:03 -0800
Message-ID: <20171116013903.vg2Yhg1-u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40740 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933297AbdKPBjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:39:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, jack@suse.cz, mm-commits@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org, wanglong19@meituan.com

From: Wang Long <wanglong19@meituan.com>
Subject: writeback: remove unused function parameter

The parameter `struct bdi_writeback *wb` is not been used in the function
body.  Remove it.

Link: http://lkml.kernel.org/r/1509685485-15278-1-git-send-email-wanglong19@meituan.com
Signed-off-by: Wang Long <wanglong19@meituan.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    2 +-
 mm/page-writeback.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/backing-dev.h~writeback-remove-the-unused-function-parameter include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~writeback-remove-the-unused-function-parameter
+++ a/include/linux/backing-dev.h
@@ -93,7 +93,7 @@ extern void wb_writeout_inc(struct bdi_w
 /*
  * maximal error of a stat counter.
  */
-static inline unsigned long wb_stat_error(struct bdi_writeback *wb)
+static inline unsigned long wb_stat_error(void)
 {
 #ifdef CONFIG_SMP
 	return nr_cpu_ids * WB_STAT_BATCH;
diff -puN mm/page-writeback.c~writeback-remove-the-unused-function-parameter mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-remove-the-unused-function-parameter
+++ a/mm/page-writeback.c
@@ -1545,7 +1545,7 @@ static inline void wb_dirty_limits(struc
 	 * actually dirty; with m+n sitting in the percpu
 	 * deltas.
 	 */
-	if (dtc->wb_thresh < 2 * wb_stat_error(wb)) {
+	if (dtc->wb_thresh < 2 * wb_stat_error()) {
 		wb_reclaimable = wb_stat_sum(wb, WB_RECLAIMABLE);
 		dtc->wb_dirty = wb_reclaimable + wb_stat_sum(wb, WB_WRITEBACK);
 	} else {
@@ -1803,7 +1803,7 @@ pause:
 		 * more page. However wb_dirty has accounting errors.  So use
 		 * the larger and more IO friendly wb_stat_error.
 		 */
-		if (sdtc->wb_dirty <= wb_stat_error(wb))
+		if (sdtc->wb_dirty <= wb_stat_error())
 			break;
 
 		if (fatal_signal_pending(current))
_

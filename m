From: akpm@linux-foundation.org
Subject: + as-fix-antic_expire-check.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:53:39 -0800
Message-ID: <200703151853.l2FIrfnr023438@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35785 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbXCOSxu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au, dingxn@cse.ohio-state.edu, jens.axboe@oracle.com, npiggin@suse.de


The patch titled
     as: fix antic_expire check
has been added to the -mm tree.  Its filename is
     as-fix-antic_expire-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: as: fix antic_expire check
From: Nick Piggin <nickpiggin@yahoo.com.au>

Fix units mismatch (jiffies vs msecs) in as-iosched.c, spotted by Xiaoning
Ding <dingxn@cse.ohio-state.edu>.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/as-iosched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN block/as-iosched.c~as-fix-antic_expire-check block/as-iosched.c
--- a/block/as-iosched.c~as-fix-antic_expire-check
+++ a/block/as-iosched.c
@@ -569,7 +569,7 @@ static void as_update_iohist(struct as_d
 static int as_close_req(struct as_data *ad, struct as_io_context *aic,
 			struct request *rq)
 {
-	unsigned long delay;	/* milliseconds */
+	unsigned long delay;	/* jiffies */
 	sector_t last = ad->last_sector[ad->batch_data_dir];
 	sector_t next = rq->sector;
 	sector_t delta; /* acceptable close offset (in sectors) */
@@ -578,11 +578,11 @@ static int as_close_req(struct as_data *
 	if (ad->antic_status == ANTIC_OFF || !ad->ioc_finished)
 		delay = 0;
 	else
-		delay = ((jiffies - ad->antic_start) * 1000) / HZ;
+		delay = jiffies - ad->antic_start;
 
 	if (delay == 0)
 		delta = 8192;
-	else if (delay <= 20 && delay <= ad->antic_expire)
+	else if (delay <= (20 * HZ / 1000) && delay <= ad->antic_expire)
 		delta = 8192 << delay;
 	else
 		return 1;
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

dio-invalidate-clean-pages-before-dio-write.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
splice-partial-write-handling-fix.patch
as-fix-antic_expire-check.patch
kblockd-use-flush_work.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-implement-180-bit-sched-bitmap.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-implement-rsdl-cpu-scheduler-accounting-fixes.patch
sched-document-rsdl-cpu-scheduler.patch
sched2-sched-domain-sysctl.patch

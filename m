From: akpm@linux-foundation.org
Subject: - as-fix-antic_expire-check.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:51 -0700
Message-ID: <200705090246.l492kp1N008906@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301AbXEICq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, dingxn@cse.ohio-state.edu, jens.axboe@oracle.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     as: fix antic_expire check
has been removed from the -mm tree.  Its filename was
     as-fix-antic_expire-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ia64-race-flushing-icache-in-do_no_page-path.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
kblockd-use-flush_work.patch
sched2-sched-domain-sysctl.patch
futex-new-private-futexes.patch
revoke-core-code-break-cow-fixes.patch

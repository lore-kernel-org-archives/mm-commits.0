From: akpm@linux-foundation.org
Subject: [merged] getdelays-show-average-cpu-io-swap-reclaim-delays.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:30 -0700
Message-ID: <201105271955.p4RJtZ5m017471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab1E0T4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@linux.vnet.ibm.com, satoru.moriya@hds.com, mm-commits@vger.kernel.org


The patch titled
     getdelays: show average CPU/IO/SWAP/RECLAIM delays
has been removed from the -mm tree.  Its filename was
     getdelays-show-average-cpu-io-swap-reclaim-delays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: getdelays: show average CPU/IO/SWAP/RECLAIM delays
From: Wu Fengguang <fengguang.wu@intel.com>

I find it very handy to show the average delays in milliseconds.

Example output (on 100 concurrent dd reading sparse files):

CPU             count     real total  virtual total    delay total  delay average
                  986     3223509952     3207643301    38863410579         39.415ms
IO              count    delay total  delay average
                    0              0              0ms
SWAP            count    delay total  delay average
                    0              0              0ms
RECLAIM         count    delay total  delay average
                 1059     5131834899              4ms
dd: read=0, write=0, cancelled_write=0

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Reviewed-by: Satoru Moriya <satoru.moriya@hds.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |   33 +++++++++++++++----------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff -puN Documentation/accounting/getdelays.c~getdelays-show-average-cpu-io-swap-reclaim-delays Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~getdelays-show-average-cpu-io-swap-reclaim-delays
+++ a/Documentation/accounting/getdelays.c
@@ -193,30 +193,37 @@ static int get_family_id(int sd)
 	return id;
 }
 
+#define average_ms(t, c) (t / 1000000ULL / (c ? c : 1))
+
 static void print_delayacct(struct taskstats *t)
 {
-	printf("\n\nCPU   %15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15llu%15llu\n"
-	       "IO    %15s%15s\n"
-	       "      %15llu%15llu\n"
-	       "SWAP  %15s%15s\n"
-	       "      %15llu%15llu\n"
-	       "RECLAIM  %12s%15s\n"
-	       "      %15llu%15llu\n",
-	       "count", "real total", "virtual total", "delay total",
+	printf("\n\nCPU   %15s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15llu%15llu%15.3fms\n"
+	       "IO    %15s%15s%15s\n"
+	       "      %15llu%15llu%15llums\n"
+	       "SWAP  %15s%15s%15s\n"
+	       "      %15llu%15llu%15llums\n"
+	       "RECLAIM  %12s%15s%15s\n"
+	       "      %15llu%15llu%15llums\n",
+	       "count", "real total", "virtual total",
+	       "delay total", "delay average",
 	       (unsigned long long)t->cpu_count,
 	       (unsigned long long)t->cpu_run_real_total,
 	       (unsigned long long)t->cpu_run_virtual_total,
 	       (unsigned long long)t->cpu_delay_total,
-	       "count", "delay total",
+	       average_ms((double)t->cpu_delay_total, t->cpu_count),
+	       "count", "delay total", "delay average",
 	       (unsigned long long)t->blkio_count,
 	       (unsigned long long)t->blkio_delay_total,
-	       "count", "delay total",
+	       average_ms(t->blkio_delay_total, t->blkio_count),
+	       "count", "delay total", "delay average",
 	       (unsigned long long)t->swapin_count,
 	       (unsigned long long)t->swapin_delay_total,
-	       "count", "delay total",
+	       average_ms(t->swapin_delay_total, t->swapin_count),
+	       "count", "delay total", "delay average",
 	       (unsigned long long)t->freepages_count,
-	       (unsigned long long)t->freepages_delay_total);
+	       (unsigned long long)t->freepages_delay_total,
+	       average_ms(t->freepages_delay_total, t->freepages_count));
 }
 
 static void task_context_switch_counts(struct taskstats *t)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-pass-writeback_control-down-to-move_expired_inodes.patch
writeback-introduce-writeback_controlinodes_cleaned.patch
writeback-try-more-writeback-as-long-as-something-was-written.patch
writeback-the-kupdate-expire-timestamp-should-be-a-moving-target.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-refill-b_io-iff-empty.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
writeback-elevate-queue_io-into-wb_writeback.patch
writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage.patch
writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock.patch
writeback-avoid-extra-sync-work-at-enqueue-time.patch


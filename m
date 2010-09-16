From: akpm@linux-foundation.org
Subject: + writeback-account-for-time-spent-congestion_waited.patch added to -mm tree
Date: Thu, 16 Sep 2010 15:28:27 -0700
Message-ID: <201009162228.o8GMSRXk017332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208Ab0IPWi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 18:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     writeback: account for time spent congestion_waited
has been added to the -mm tree.  Its filename is
     writeback-account-for-time-spent-congestion_waited.patch

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
Subject: writeback: account for time spent congestion_waited
From: Mel Gorman <mel@csn.ul.ie>

There is strong evidence to indicate a lot of time is being spent in
congestion_wait(), some of it unnecessarily.  This patch adds a tracepoint
for congestion_wait to record when congestion_wait() was called, how long
the timeout was for and how long it actually slept.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/writeback.h |   28 ++++++++++++++++++++++++++++
 mm/backing-dev.c                 |    5 +++++
 2 files changed, 33 insertions(+)

diff -puN include/trace/events/writeback.h~writeback-account-for-time-spent-congestion_waited include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~writeback-account-for-time-spent-congestion_waited
+++ a/include/trace/events/writeback.h
@@ -151,6 +151,34 @@ DEFINE_WBC_EVENT(wbc_balance_dirty_writt
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+DECLARE_EVENT_CLASS(writeback_congest_waited_template,
+
+	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
+
+	TP_ARGS(usec_timeout, usec_delayed),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	usec_timeout	)
+		__field(	unsigned int,	usec_delayed	)
+	),
+
+	TP_fast_assign(
+		__entry->usec_timeout	= usec_timeout;
+		__entry->usec_delayed	= usec_delayed;
+	),
+
+	TP_printk("usec_timeout=%u usec_delayed=%u",
+			__entry->usec_timeout,
+			__entry->usec_delayed)
+);
+
+DEFINE_EVENT(writeback_congest_waited_template, writeback_congestion_wait,
+
+	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
+
+	TP_ARGS(usec_timeout, usec_delayed)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */
diff -puN mm/backing-dev.c~writeback-account-for-time-spent-congestion_waited mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-account-for-time-spent-congestion_waited
+++ a/mm/backing-dev.c
@@ -762,12 +762,17 @@ EXPORT_SYMBOL(set_bdi_congested);
 long congestion_wait(int sync, long timeout)
 {
 	long ret;
+	unsigned long start = jiffies;
 	DEFINE_WAIT(wait);
 	wait_queue_head_t *wqh = &congestion_wqh[sync];
 
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = io_schedule_timeout(timeout);
 	finish_wait(wqh, &wait);
+
+	trace_writeback_congestion_wait(jiffies_to_usecs(timeout),
+					jiffies_to_usecs(jiffies - start));
+
 	return ret;
 }
 EXPORT_SYMBOL(congestion_wait);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton.patch
mm-compaction-fix-compactpagefailed-counting.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
mm-fix-typo-in-mmh-when-node_not_in_page_flags.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch


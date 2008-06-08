From: akpm@linux-foundation.org
Subject: + per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:41:45 -0700
Message-ID: <200806082041.m58KfjWm019568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbYFHUlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kobayashi.kk@ncos.nec.co.jp


The patch titled
     per-task-delay-accounting: update taskstats for memory reclaim delay
has been added to the -mm tree.  Its filename is
     per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: per-task-delay-accounting: update taskstats for memory reclaim delay
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

Add members for memory reclaim delay to taskstats, and accumulate them in
__delayacct_add_tsk() .

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/taskstats-struct.txt |    6 ++++++
 include/linux/taskstats.h                     |    6 +++++-
 kernel/delayacct.c                            |    3 +++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff -puN Documentation/accounting/taskstats-struct.txt~per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay Documentation/accounting/taskstats-struct.txt
--- a/Documentation/accounting/taskstats-struct.txt~per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay
+++ a/Documentation/accounting/taskstats-struct.txt
@@ -24,6 +24,8 @@ There are three different groups of fiel
 
 4) Per-task and per-thread context switch count statistics
 
+6) Extended delay accounting fields for memory reclaim
+
 Future extension should add fields to the end of the taskstats struct, and
 should not change the relative position of each field within the struct.
 
@@ -164,4 +166,8 @@ struct taskstats {
 	__u64	nvcsw;			/* Context voluntary switch counter */
 	__u64	nivcsw;			/* Context involuntary switch counter */
 
+6) Extended delay accounting fields for memory reclaim
+	/* Delay waiting for memory reclaim */
+	__u64	freepages_count;
+	__u64	freepages_delay_total;
 }
diff -puN include/linux/taskstats.h~per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay include/linux/taskstats.h
--- a/include/linux/taskstats.h~per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay
+++ a/include/linux/taskstats.h
@@ -31,7 +31,7 @@
  */
 
 
-#define TASKSTATS_VERSION	6
+#define TASKSTATS_VERSION	7
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -157,6 +157,10 @@ struct taskstats {
 	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
 	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
 	__u64	cpu_scaled_run_real_total; /* scaled cpu_run_real_total */
+
+	/* Delay waiting for memory reclaim */
+	__u64	freepages_count;
+	__u64	freepages_delay_total;
 };
 
 
diff -puN kernel/delayacct.c~per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay kernel/delayacct.c
--- a/kernel/delayacct.c~per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay
+++ a/kernel/delayacct.c
@@ -145,8 +145,11 @@ int __delayacct_add_tsk(struct taskstats
 	d->blkio_delay_total = (tmp < d->blkio_delay_total) ? 0 : tmp;
 	tmp = d->swapin_delay_total + tsk->delays->swapin_delay;
 	d->swapin_delay_total = (tmp < d->swapin_delay_total) ? 0 : tmp;
+	tmp = d->freepages_delay_total + tsk->delays->freepages_delay;
+	d->freepages_delay_total = (tmp < d->freepages_delay_total) ? 0 : tmp;
 	d->blkio_count += tsk->delays->blkio_count;
 	d->swapin_count += tsk->delays->swapin_count;
+	d->freepages_count += tsk->delays->freepages_count;
 	spin_unlock_irqrestore(&tsk->delays->lock, flags);
 
 done:
_

Patches currently in -mm which might be from kobayashi.kk@ncos.nec.co.jp are

per-task-delay-accounting-add-memory-reclaim-delay.patch
per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch


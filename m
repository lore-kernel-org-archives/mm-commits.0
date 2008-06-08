From: akpm@linux-foundation.org
Subject: + per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:45:44 -0700
Message-ID: <200806082045.m58Kjivq019723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbYFHUvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:51:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kobayashi.kk@ncos.nec.co.jp, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     per-task-delay-accounting: update document and getdelays.c for memory reclaim
has been added to the -mm tree.  Its filename is
     per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch

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
Subject: per-task-delay-accounting: update document and getdelays.c for memory reclaim
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

Update document and make getdelays.c show delay accounting for memory reclaim.

For making a distinction between "swapping in pages" and "memory reclaim"
in getdelays.c, MEM is changed to SWAP.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.txt |   11 ++++++++---
 Documentation/accounting/getdelays.c          |    8 ++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff -puN Documentation/accounting/delay-accounting.txt~per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim Documentation/accounting/delay-accounting.txt
--- a/Documentation/accounting/delay-accounting.txt~per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim
+++ a/Documentation/accounting/delay-accounting.txt
@@ -11,6 +11,7 @@ the delays experienced by a task while
 a) waiting for a CPU (while being runnable)
 b) completion of synchronous block I/O initiated by the task
 c) swapping in pages
+d) memory reclaim
 
 and makes these statistics available to userspace through
 the taskstats interface.
@@ -41,7 +42,7 @@ this structure. See
      include/linux/taskstats.h
 for a description of the fields pertaining to delay accounting.
 It will generally be in the form of counters returning the cumulative
-delay seen for cpu, sync block I/O, swapin etc.
+delay seen for cpu, sync block I/O, swapin, memory reclaim etc.
 
 Taking the difference of two successive readings of a given
 counter (say cpu_delay_total) for a task will give the delay
@@ -94,7 +95,9 @@ CPU	count	real total	virtual total	delay
 	7876	92005750	100000000	24001500
 IO	count	delay total
 	0	0
-MEM	count	delay total
+SWAP	count	delay total
+	0	0
+RECLAIM	count	delay total
 	0	0
 
 Get delays seen in executing a given simple command
@@ -108,5 +111,7 @@ CPU	count	real total	virtual total	delay
 	6	4000250		4000000		0
 IO	count	delay total
 	0	0
-MEM	count	delay total
+SWAP	count	delay total
+	0	0
+RECLAIM	count	delay total
 	0	0
diff -puN Documentation/accounting/getdelays.c~per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim
+++ a/Documentation/accounting/getdelays.c
@@ -196,14 +196,18 @@ void print_delayacct(struct taskstats *t
 	       "      %15llu%15llu%15llu%15llu\n"
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
-	       "MEM   %15s%15s\n"
+	       "SWAP  %15s%15s\n"
+	       "      %15llu%15llu\n"
+	       "RECLAIM  %12s%15s\n"
 	       "      %15llu%15llu\n",
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
 	       "count", "delay total",
 	       t->blkio_count, t->blkio_delay_total,
-	       "count", "delay total", t->swapin_count, t->swapin_delay_total);
+	       "count", "delay total", t->swapin_count, t->swapin_delay_total,
+	       "count", "delay total",
+	       t->freepages_count, t->freepages_delay_total);
 }
 
 void task_context_switch_counts(struct taskstats *t)
_

Patches currently in -mm which might be from kobayashi.kk@ncos.nec.co.jp are

per-task-delay-accounting-add-memory-reclaim-delay.patch
per-task-delay-accounting-update-taskstats-for-memory-reclaim-delay.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch


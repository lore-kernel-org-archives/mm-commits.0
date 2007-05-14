From: akpm@linux-foundation.org
Subject: + fix-ucb1x00-driver-to-use-sched_setscheduler.patch added to -mm tree
Date: Mon, 14 May 2007 14:43:20 -0700
Message-ID: <200705142143.l4ELhKm0026894@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbXENVna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 17:43:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takeuchi_satoru@jp.fujitsu.com, dtor@mail.ru, pavel@ucw.cz


The patch titled
     Fix UCB1x00 driver to use sched_setscheduler
has been added to the -mm tree.  Its filename is
     fix-ucb1x00-driver-to-use-sched_setscheduler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix UCB1x00 driver to use sched_setscheduler
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Fix Touchscreen driver for UCB1x00-based touchscreens to use
sched_setscheduler() instead of setting the fields of task_struct directly.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/ucb1x00-ts.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/ucb1x00-ts.c~fix-ucb1x00-driver-to-use-sched_setscheduler drivers/mfd/ucb1x00-ts.c
--- a/drivers/mfd/ucb1x00-ts.c~fix-ucb1x00-driver-to-use-sched_setscheduler
+++ a/drivers/mfd/ucb1x00-ts.c
@@ -213,8 +213,9 @@ static int ucb1x00_thread(void *_ts)
 	 * We could run as a real-time thread.  However, thus far
 	 * this doesn't seem to be necessary.
 	 */
-//	tsk->policy = SCHED_FIFO;
-//	tsk->rt_priority = 1;
+//	struct sched_param param = { .sched_priority = 1 };
+//
+//	sched_setscheduler(tsk, SCHED_FIFO, &param);
 
 	valid = 0;
 
_

Patches currently in -mm which might be from takeuchi_satoru@jp.fujitsu.com are

fix-philips-ucb1400-driver-to-use-sched_setscheduler.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
fix-ucb1x00-driver-to-use-sched_setscheduler.patch

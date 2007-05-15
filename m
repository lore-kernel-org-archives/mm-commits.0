From: akpm@linux-foundation.org
Subject: - fix-ucb1x00-driver-to-use-sched_setscheduler.patch removed from -mm tree
Date: Tue, 15 May 2007 01:49:53 -0700
Message-ID: <200705150849.l4F8nqGR005546@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759179AbXEOIu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 04:50:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takeuchi_satoru@jp.fujitsu.com, dtor@mail.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Fix UCB1x00 driver to use sched_setscheduler
has been removed from the -mm tree.  Its filename was
     fix-ucb1x00-driver-to-use-sched_setscheduler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-input.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch

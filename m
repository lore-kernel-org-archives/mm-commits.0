From: akpm@linux-foundation.org
Subject: - fix-philips-ucb1400-driver-to-use-sched_setscheduler.patch removed from -mm tree
Date: Tue, 15 May 2007 01:49:50 -0700
Message-ID: <200705150849.l4F8nnMR005543@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759493AbXEOIuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 04:50:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takeuchi_satoru@jp.fujitsu.com, cbrake@bec-systems.com, dtor@mail.ru, nico@cam.org, mm-commits@vger.kernel.org


The patch titled
     Fix Philips UCB1400 driver to use sched_setscheduler
has been removed from the -mm tree.  Its filename was
     fix-philips-ucb1400-driver-to-use-sched_setscheduler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix Philips UCB1400 driver to use sched_setscheduler
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Fix Philips UCB1400 driver to use sched_setscheduler() instead of setting
the fields of task_struct directly.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Cliff Brake <cbrake@bec-systems.com>
Cc: Nicolas Pitre <nico@cam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ucb1400_ts.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/touchscreen/ucb1400_ts.c~fix-philips-ucb1400-driver-to-use-sched_setscheduler drivers/input/touchscreen/ucb1400_ts.c
--- a/drivers/input/touchscreen/ucb1400_ts.c~fix-philips-ucb1400-driver-to-use-sched_setscheduler
+++ a/drivers/input/touchscreen/ucb1400_ts.c
@@ -288,9 +288,9 @@ static int ucb1400_ts_thread(void *_ucb)
 	struct ucb1400 *ucb = _ucb;
 	struct task_struct *tsk = current;
 	int valid = 0;
+	struct sched_param param = { .sched_priority = 1 };
 
-	tsk->policy = SCHED_FIFO;
-	tsk->rt_priority = 1;
+	sched_setscheduler(tsk, SCHED_FIFO, &param);
 
 	while (!kthread_should_stop()) {
 		unsigned int x, y, p;
_

Patches currently in -mm which might be from takeuchi_satoru@jp.fujitsu.com are

git-input.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch

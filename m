From: akpm@linux-foundation.org
Subject: [merged] time-schedc-tick_nohz_update_jiffies-should-be-static.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:07 -0800
Message-ID: <200901261904.n0QJ47Ix029533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbZAZTJb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:09:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@infradead.org, jaswinderrajput@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time-sched.c: tick_nohz_update_jiffies should be static
has been removed from the -mm tree.  Its filename was
     time-schedc-tick_nohz_update_jiffies-should-be-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time-sched.c: tick_nohz_update_jiffies should be static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
 kernel/time/tick-sched.c:137:6: warning: symbol 'tick_nohz_update_jiffies' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~time-schedc-tick_nohz_update_jiffies-should-be-static kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~time-schedc-tick_nohz_update_jiffies-should-be-static
+++ a/kernel/time/tick-sched.c
@@ -134,7 +134,7 @@ __setup("nohz=", setup_tick_nohz);
  * value. We do this unconditionally on any cpu, as we don't know whether the
  * cpu, which has the update task assigned is in a long sleep.
  */
-void tick_nohz_update_jiffies(void)
+static void tick_nohz_update_jiffies(void)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
_

Patches currently in -mm which might be from jaswinder@infradead.org are

linux-next.patch


From: akpm@linux-foundation.org
Subject: + time-schedc-tick_nohz_update_jiffies-should-be-static.patch added to -mm tree
Date: Thu, 15 Jan 2009 16:02:46 -0800
Message-ID: <200901160002.n0G02k7j030098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935780AbZAPAD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 19:03:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@infradead.org, jaswinderrajput@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time-sched.c: tick_nohz_update_jiffies should be static
has been added to the -mm tree.  Its filename is
     time-schedc-tick_nohz_update_jiffies-should-be-static.patch

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

origin.patch
include-of-linux-typesh-is-preferred-over-asm-typesh.patch
linux-next.patch
time-schedc-tick_nohz_update_jiffies-should-be-static.patch
capabilityh-externs-make-no-sense-in-userspace.patch


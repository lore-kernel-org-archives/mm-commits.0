From: akpm@linux-foundation.org
Subject: + sched_clock-widen-the-max-and-min-time.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:12:58 -0700
Message-ID: <200807130612.m6D6CwU8007400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091AbYGMGNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:13:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, peterz@infradead.org, srostedt@redhat.com, tglx@linutronix.de


The patch titled
     sched_clock: widen the max and min time
has been added to the -mm tree.  Its filename is
     sched_clock-widen-the-max-and-min-time.patch

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
Subject: sched_clock: widen the max and min time
From: Steven Rostedt <rostedt@goodmis.org>

With keeping the max and min sched time within one jiffy of the gtod clock
was too tight.  Just before a schedule tick the max could easily be hit,
as well as just after a schedule_tick the min could be hit.  This caused
the clock to jump around by a jiffy.

This patch widens the minimum to
   last gtod + (delta_jiffies ? delta_jiffies - 1 : 0) * TICK_NSECS

and the maximum to
    last gtod + (2 + delta_jiffies) * TICK_NSECS

This keeps the minum to gtod or if one jiffy less than delta jiffies and
the maxim 2 jiffies ahead of gtod.  This may cause unstable TSCs to be a
bit more sporadic, but it helps keep a clock with a stable TSC working
well.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_clock.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN kernel/sched_clock.c~sched_clock-widen-the-max-and-min-time kernel/sched_clock.c
--- a/kernel/sched_clock.c~sched_clock-widen-the-max-and-min-time
+++ a/kernel/sched_clock.c
@@ -96,14 +96,21 @@ static void __update_sched_clock(struct 
 	s64 delta = now - scd->prev_raw;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	min_clock = scd->tick_gtod + delta_jiffies * TICK_NSEC;
+
+	min_clock = scd->tick_gtod +
+		(delta_jiffies ? delta_jiffies - 1 : 0) * TICK_NSEC;
 
 	if (unlikely(delta < 0)) {
 		clock++;
 		goto out;
 	}
 
-	max_clock = min_clock + TICK_NSEC;
+	/*
+	 * The clock must stay within a jiffie of the gtod.
+	 * But since we may be at the start of a jiffy or the end of one
+	 * we add another jiffy buffer.
+	 */
+	max_clock = scd->tick_gtod + (2 + delta_jiffies) * TICK_NSEC;
 
 	if (unlikely(clock + delta > max_clock)) {
 		if (clock < max_clock)
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
sched_clock-record-from-last-tick.patch
sched_clock-widen-the-max-and-min-time.patch
sched_clock-stop-maximum-check-on-no-hz.patch
sched_clock-fix-calculation-of-other-cpu.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch


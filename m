From: akpm@google.com
Subject: + memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage.patch added to -mm tree
Date: Mon, 26 Sep 2011 16:46:03 -0700
Message-ID: <201109262346.p8QNk3EL029371@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:61862 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1IZXqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2011 19:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srostedt@redhat.com, balbir@linux.vnet.ibm.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     Subject: memcg: Fix race condition in memcg_check_events() with this_cpu usage
has been added to the -mm tree.  Its filename is
     memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage.patch

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
From: Steven Rostedt <srostedt@redhat.com>
Subject: memcg: Fix race condition in memcg_check_events() with this_cpu usage

Various code in memcontrol.c () calls this_cpu_read() on the calculations
to be done from two different percpu variables, or does an open-coded
read-modify-write on a single percpu variable.

Disable preemption throughout these operations so that the writes go to
the correct palces.

[ Added this_cpu to __this_cpu conversion by Johannes ]

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage
+++ a/mm/memcontrol.c
@@ -687,8 +687,8 @@ static bool __memcg_event_check(struct m
 {
 	unsigned long val, next;
 
-	val = this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
-	next = this_cpu_read(memcg->stat->targets[target]);
+	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	next = __this_cpu_read(memcg->stat->targets[target]);
 	/* from time_after() in jiffies.h */
 	return ((long)next - (long)val < 0);
 }
@@ -697,7 +697,7 @@ static void __mem_cgroup_target_update(s
 {
 	unsigned long val, next;
 
-	val = this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 
 	switch (target) {
 	case MEM_CGROUP_TARGET_THRESH:
@@ -713,7 +713,7 @@ static void __mem_cgroup_target_update(s
 		return;
 	}
 
-	this_cpu_write(memcg->stat->targets[target], next);
+	__this_cpu_write(memcg->stat->targets[target], next);
 }
 
 /*
@@ -722,6 +722,7 @@ static void __mem_cgroup_target_update(s
  */
 static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 {
+	preempt_disable();
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(__memcg_event_check(memcg, MEM_CGROUP_TARGET_THRESH))) {
 		mem_cgroup_threshold(memcg);
@@ -741,6 +742,7 @@ static void memcg_check_events(struct me
 		}
 #endif
 	}
+	preempt_enable();
 }
 
 static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
_
Subject: Subject: memcg: Fix race condition in memcg_check_events() with this_cpu usage

Patches currently in -mm which might be from srostedt@redhat.com are

linux-next.patch
memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage.patch


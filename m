From: akpm@linux-foundation.org
Subject: + memcg-remove-unneeded-preempt_disable.patch added to -mm tree
Date: Thu, 18 Aug 2011 14:47:26 -0700
Message-ID: <201108182147.p7ILlQA4029541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400Ab1HRVrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 17:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, Valdis.Kletnieks@vt.edu, bsingharora@gmail.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: remove unneeded preempt_disable
has been added to the -mm tree.  Its filename is
     memcg-remove-unneeded-preempt_disable.patch

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
Subject: memcg: remove unneeded preempt_disable
From: Greg Thelen <gthelen@google.com>

Both mem_cgroup_charge_statistics() and mem_cgroup_move_account() were
unnecessarily disabling preemption when adjusting per-cpu counters:
    preempt_disable()
    __this_cpu_xxx()
    __this_cpu_yyy()
    preempt_enable()

This change does not disable preemption and thus CPU switch is possible
within these routines.  This does not cause a problem because the total
of all cpu counters is summed when reporting stats.  Now both
mem_cgroup_charge_statistics() and mem_cgroup_move_account() look like:
    this_cpu_xxx()
    this_cpu_yyy()

akpm: this is an optimisation for x86 and a deoptimisation for non-x86. 
The non-x86 situation will be fixed as architectures implement their
atomic this_cpu_foo() operations.

Signed-off-by: Greg Thelen <gthelen@google.com>
Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-unneeded-preempt_disable mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unneeded-preempt_disable
+++ a/mm/memcontrol.c
@@ -664,26 +664,22 @@ static unsigned long mem_cgroup_read_eve
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 					 bool file, int nr_pages)
 {
-	preempt_disable();
-
 	if (file)
-		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
+		this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
 				nr_pages);
 	else
-		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
+		this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
 				nr_pages);
 
 	/* pagein of a big page is an event. So, ignore page size */
-	if (nr_pages > 0)
-		__this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
-	else {
-		__this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
+	if (nr_pages > 0) {
+		this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
+	} else {
+		this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
 		nr_pages = -nr_pages; /* for event */
 	}
 
-	__this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);

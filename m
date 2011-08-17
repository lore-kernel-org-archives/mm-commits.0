From: akpm@linux-foundation.org
Subject: + memcg-pin-execution-to-current-cpu-while-draining-stock.patch added to -mm tree
Date: Wed, 17 Aug 2011 13:03:40 -0700
Message-ID: <201108172003.p7HK3e1Q025013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab1HQUE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 16:04:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, stable@kernel.org


The patch titled
     memcg: pin execution to current cpu while draining stock
has been added to the -mm tree.  Its filename is
     memcg-pin-execution-to-current-cpu-while-draining-stock.patch

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
Subject: memcg: pin execution to current cpu while draining stock
From: Johannes Weiner <jweiner@redhat.com>

Commit d1a05b6 ("memcg do not try to drain per-cpu caches without pages")
added a drain_local_stock() call to a preemptible section.

The draining task looks up the cpu-local stock twice to set the
draining-flag, then to drain the stock and clear the flag again.  If the
task is migrated to a different CPU in between, noone will clear the flag
on the first stock and it will be forever undrainable.  Its charge can not
be recovered and the cgroup can not be deleted anymore.

Properly pin the task to the executing CPU while draining stocks.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com
Cc: Michal Hocko <mhocko@suse.cz>
Cc: <stable@kernel.org>		[3.0.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-pin-execution-to-current-cpu-while-draining-stock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-pin-execution-to-current-cpu-while-draining-stock
+++ a/mm/memcontrol.c
@@ -2169,13 +2169,7 @@ static void drain_all_stock(struct mem_c
 
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
-	/*
-	 * Get a hint for avoiding draining charges on the current cpu,
-	 * which must be exhausted by our charging.  It is not required that
-	 * this be a precise check, so we use raw_smp_processor_id() instead of
-	 * getcpu()/putcpu().
-	 */
-	curcpu = raw_smp_processor_id();
+	curcpu = get_cpu();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *mem;
@@ -2192,6 +2186,7 @@ static void drain_all_stock(struct mem_c
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
+	put_cpu();
 
 	if (!sync)
 		goto out;
_

Patches currently in -mm which might be from jweiner@redhat.com are

memcg-pin-execution-to-current-cpu-while-draining-stock.patch
linux-next.patch


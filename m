From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-fix-excessive-complexity-in-memorystat-reporting-fix.patch
 removed from -mm tree
Date: Wed, 31 Jan 2018 15:49:35 -0800
Message-ID: <5a72560f.l5lIufgpCzwI0590%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56068 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754076AbeAaXth (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:49:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fix-excessive-complexity-in-memorystat-reporting-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-excessive-complexity-in-memorystat-reporting-fix.patch

This patch was dropped because it was folded into mm-memcontrol-fix-excessive-complexity-in-memorystat-reporting.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-fix-excessive-complexity-in-memorystat-reporting-fix

The memcg cpu_dead callback can be called early during startup
(CONFIG_DEBUG_HOTPLUG_CPU0) with preemption enabled, which triggers a
warning in its __this_cpu_xchg() calls. But CPU locality is always
guaranteed, which is the only thing we really care about here.

Using the preemption-safe this_cpu_xchg() addresses this problem.

Link: http://lkml.kernel.org/r/20171201135750.GB8097@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-excessive-complexity-in-memorystat-reporting-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-excessive-complexity-in-memorystat-reporting-fix
+++ a/mm/memcontrol.c
@@ -1836,7 +1836,7 @@ static int memcg_hotplug_cpu_dead(unsign
 			int nid;
 			long x;
 
-			x = __this_cpu_xchg(memcg->stat_cpu->count[i], 0);
+			x = this_cpu_xchg(memcg->stat_cpu->count[i], 0);
 			if (x)
 				atomic_long_add(x, &memcg->stat[i]);
 
@@ -1847,7 +1847,7 @@ static int memcg_hotplug_cpu_dead(unsign
 				struct mem_cgroup_per_node *pn;
 
 				pn = mem_cgroup_nodeinfo(memcg, nid);
-				x = __this_cpu_xchg(pn->lruvec_stat_cpu->count[i], 0);
+				x = this_cpu_xchg(pn->lruvec_stat_cpu->count[i], 0);
 				if (x)
 					atomic_long_add(x, &pn->lruvec_stat[i]);
 			}
@@ -1856,7 +1856,7 @@ static int memcg_hotplug_cpu_dead(unsign
 		for (i = 0; i < MEMCG_NR_EVENTS; i++) {
 			long x;
 
-			x = __this_cpu_xchg(memcg->stat_cpu->events[i], 0);
+			x = this_cpu_xchg(memcg->stat_cpu->events[i], 0);
 			if (x)
 				atomic_long_add(x, &memcg->events[i]);
 		}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-eliminate-raw-access-to-stat-and-event-counters.patch
mm-memcontrol-implement-lruvec-stat-functions-on-top-of-each-other.patch
mm-memcontrol-fix-excessive-complexity-in-memorystat-reporting.patch


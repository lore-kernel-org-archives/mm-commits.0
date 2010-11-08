From: akpm@linux-foundation.org
Subject: + memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch added to -mm tree
Date: Mon, 08 Nov 2010 15:29:14 -0800
Message-ID: <201011082329.oA8NTE8j016152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755871Ab0KHXaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 18:30:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, gthelen@google.com, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: catch negative per-cpu sums in dirty info
has been added to the -mm tree.  Its filename is
     memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch

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
Subject: memcg: catch negative per-cpu sums in dirty info
From: Johannes Weiner <hannes@cmpxchg.org>

Folding the per-cpu counters can yield a negative value in case of
accounting races between CPUs.

When collecting the dirty info, the code would read those sums into an
unsigned variable and then check for it being negative, which can not
work.

Instead, fold the counters into a signed local variable, make the
check, and only then assign it.

This way, the function signals correctly when there are insane values
instead of leaking them out to the caller.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Dave Young <hidave.darkstar@gmail.com>
Reviewed-by: Greg Thelen <gthelen@google.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info
+++ a/mm/memcontrol.c
@@ -1256,14 +1256,15 @@ bool mem_cgroup_dirty_info(unsigned long
 			(dirty_param.dirty_background_ratio *
 			       available_mem) / 100;
 
-	info->nr_reclaimable =
-		mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
-	if (info->nr_reclaimable < 0)
+	value = mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
+	if (value < 0)
 		return false;
+	info->nr_reclaimable = value;
 
-	info->nr_writeback = mem_cgroup_page_stat(MEMCG_NR_WRITEBACK);
-	if (info->nr_writeback < 0)
+	value = mem_cgroup_page_stat(MEMCG_NR_WRITEBACK);
+	if (value < 0)
 		return false;
+	info->nr_writeback = value;
 
 	return true;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch


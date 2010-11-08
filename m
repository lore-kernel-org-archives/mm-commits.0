From: akpm@linux-foundation.org
Subject: + memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch added to -mm tree
Date: Mon, 08 Nov 2010 15:29:12 -0800
Message-ID: <201011082329.oA8NTC4d016149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755871Ab0KHXaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 18:30:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, gthelen@google.com, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: use native word to represent dirtyable pages
has been added to the -mm tree.  Its filename is
     memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch

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
Subject: memcg: use native word to represent dirtyable pages
From: Johannes Weiner <hannes@cmpxchg.org>

The memory cgroup dirty info calculation currently uses a signed 64-bit
type to represent the amount of dirtyable memory in pages.

This can instead be changed to an unsigned word, which will allow the
formula to function correctly with up to 160G of LRU pages on a 32-bit
system, assuming 4k pages.  That should be plenty even when taking racy
folding of the per-cpu counters into account.

This fixes a compilation error on 32-bit systems as this code tries to do
64-bit division.

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

 mm/memcontrol.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages
+++ a/mm/memcontrol.c
@@ -1217,9 +1217,10 @@ static void __mem_cgroup_dirty_param(str
 bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 			   struct dirty_info *info)
 {
-	s64 available_mem;
 	struct vm_dirty_param dirty_param;
+	unsigned long available_mem;
 	struct mem_cgroup *memcg;
+	s64 value;
 
 	if (mem_cgroup_disabled())
 		return false;
@@ -1233,11 +1234,11 @@ bool mem_cgroup_dirty_info(unsigned long
 	__mem_cgroup_dirty_param(&dirty_param, memcg);
 	rcu_read_unlock();
 
-	available_mem = mem_cgroup_page_stat(MEMCG_NR_DIRTYABLE_PAGES);
-	if (available_mem < 0)
+	value = mem_cgroup_page_stat(MEMCG_NR_DIRTYABLE_PAGES);
+	if (value < 0)
 		return false;
 
-	available_mem = min((unsigned long)available_mem, sys_available_mem);
+	available_mem = min((unsigned long)value, sys_available_mem);
 
 	if (dirty_param.dirty_bytes)
 		info->dirty_thresh =
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch


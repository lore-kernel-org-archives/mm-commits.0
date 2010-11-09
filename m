From: akpm@linux-foundation.org
Subject: + memcg-add-dirty-limits-to-mem_cgroup-div-fix.patch added to -mm tree
Date: Mon, 08 Nov 2010 16:17:29 -0800
Message-ID: <201011090017.oA90HTY1018200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321Ab0KIAST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 19:18:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, gthelen@google.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-add-dirty-limits-to-mem_cgroup-div-fix
has been added to the -mm tree.  Its filename is
     memcg-add-dirty-limits-to-mem_cgroup-div-fix.patch

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
Subject: memcg-add-dirty-limits-to-mem_cgroup-div-fix
From: Minchan Kim <minchan.kim@gmail.com>

mm/built-in.o: In function `mem_cgroup_dirty_info':
mm/memcontrol.c:1251: undefined reference to `__divdi3'
mm/memcontrol.c:1259: undefined reference to `__divdi3'

We should have used do_div.
Below patch solve the problem?

Reported-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-div-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-div-fix
+++ a/mm/memcontrol.c
@@ -1243,18 +1243,19 @@ bool mem_cgroup_dirty_info(unsigned long
 	if (dirty_param.dirty_bytes)
 		info->dirty_thresh =
 			DIV_ROUND_UP(dirty_param.dirty_bytes, PAGE_SIZE);
-	else
-		info->dirty_thresh =
-			(dirty_param.dirty_ratio * available_mem) / 100;
+	else {
+		info->dirty_thresh = dirty_param.dirty_ratio * available_mem;
+		do_div(info->dirty_thresh, 100);
+       }
 
 	if (dirty_param.dirty_background_bytes)
 		info->background_thresh =
 			DIV_ROUND_UP(dirty_param.dirty_background_bytes,
 				     PAGE_SIZE);
-	else
-		info->background_thresh =
-			(dirty_param.dirty_background_ratio *
-			       available_mem) / 100;
+	else {
+		info->background_thresh = dirty_param.dirty_background_ratio * available_mem;
+		do_div(info->background_thresh, 100);
+	}
 
 	value = mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
 	if (value < 0)
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
mm-vfs-revalidate-page-mapping-in-do_generic_file_read.patch
mm-vmap-area-cache.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-add-dirty-limits-to-mem_cgroup-div-fix.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch


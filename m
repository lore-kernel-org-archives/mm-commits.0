From: akpm@linux-foundation.org
Subject: + memcg-use-native-word-page-statistics-counters-fix.patch added to -mm tree
Date: Mon, 08 Nov 2010 15:32:39 -0800
Message-ID: <201011082332.oA8NWdSj016295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab0KHXc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 18:32:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-use-native-word-page-statistics-counters-fix
has been added to the -mm tree.  Its filename is
     memcg-use-native-word-page-statistics-counters-fix.patch

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
Subject: memcg-use-native-word-page-statistics-counters-fix
From: Greg Thelen <gthelen@google.com>

Ooops.  I missed something in my review.

mem_cgroup_page_stat() appears twice in memcontrol.h The return value
should match regardless of if CONFIG_CGROUP_MEM_RES_CTLR is set.

I suggest integrating the following into you patch ([patch 4/4] memcg:
use native word page statistics counters):

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-use-native-word-page-statistics-counters-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-use-native-word-page-statistics-counters-fix
+++ a/include/linux/memcontrol.h
@@ -351,7 +351,7 @@ static inline bool mem_cgroup_dirty_info
 	return false;
 }
 
-static inline s64 mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
+static inline long mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
 {
 	return -ENOSYS;
 }
_

Patches currently in -mm which might be from gthelen@google.com are

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
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch


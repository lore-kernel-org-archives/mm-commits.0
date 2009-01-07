From: akpm@linux-foundation.org
Subject: - memcg-fix-calclation-of-active_ratio-build-error-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:17:51 -0800
Message-ID: <200901072317.n07NHpRb002184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763521AbZAGXSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:18:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix calculation of active_ratio build error fix
has been removed from the -mm tree.  Its filename was
     memcg-fix-calclation-of-active_ratio-build-error-fix.patch

This patch was dropped because it was folded into memcg-fix-calclation-of-active_ratio.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix calculation of active_ratio build error fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

fix following build error

	  CC      mm/vmscan.o
	mm/vmscan.c: In function 'inactive_anon_is_low':
	mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-fix-calclation-of-active_ratio-build-error-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-calclation-of-active_ratio-build-error-fix
+++ a/include/linux/memcontrol.h
@@ -251,7 +251,7 @@ static inline bool mem_cgroup_oom_called
 }
 
 static inline int
-mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
+mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
 {
 	return 1;
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
devices-cgroup-allow-mkfifo.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


From: akpm@linux-foundation.org
Subject: [merged]
 vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:26 -0800
Message-ID: <569973b6.+48PsGUrti3zeZHT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcAOWd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: do not force-scan file lru if its absolute size is small
has been removed from the -mm tree.  Its filename was
     vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: vmscan: do not force-scan file lru if its absolute size is small

We assume there is enough inactive page cache if the size of inactive
file lru is greater than the size of active file lru, in which case we
force-scan file lru ignoring anonymous pages. While this logic works
fine when there are plenty of page cache pages, it fails if the size of
file lru is small (several MB): in this case (lru_size >> prio) will be
0 for normal scan priorities, as a result, if inactive file lru happens
to be larger than active file lru, anonymous pages of a cgroup will
never get evicted unless the system experiences severe memory pressure,
even if there are gigabytes of unused anonymous memory there, which is
unfair in respect to other cgroups, whose workloads might be page cache
oriented.

This patch attempts to fix this by elaborating the "enough inactive page
cache" check: it makes it not only check that inactive lru size > active
lru size, but also that we will scan something from the cgroup at the
current scan priority. If these conditions do not hold, we proceed to
SCAN_FRACT as usual.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small mm/vmscan.c
--- a/mm/vmscan.c~vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small
+++ a/mm/vmscan.c
@@ -2043,10 +2043,16 @@ static void get_scan_count(struct lruvec
 	}
 
 	/*
-	 * There is enough inactive page cache, do not reclaim
-	 * anything from the anonymous working set right now.
+	 * If there is enough inactive page cache, i.e. if the size of the
+	 * inactive list is greater than that of the active list *and* the
+	 * inactive list actually has some pages to scan on this priority, we
+	 * do not reclaim anything from the anonymous working set right now.
+	 * Without the second condition we could end up never scanning an
+	 * lruvec even if it has plenty of old anonymous pages unless the
+	 * system is under heavy pressure.
 	 */
-	if (!inactive_file_is_low(lruvec)) {
+	if (!inactive_file_is_low(lruvec) &&
+	    get_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-add-page_check_address_transhuge-helper.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch


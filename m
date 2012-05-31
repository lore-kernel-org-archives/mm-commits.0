From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:48 -0700
Message-ID: <20120531191648.72AC8A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54769 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab2EaTQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:49 -0400
Received: by qcsp5 with SMTP id p5so136321qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, mhocko@suse.cz, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: scanning_global_lru means mem_cgroup_disabled
has been removed from the -mm tree.  Its filename was
     mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memcg: scanning_global_lru means mem_cgroup_disabled

Although one has to admire the skill with which it has been concealed,
scanning_global_lru(mz) is actually just an interesting way to test
mem_cgroup_disabled().  Too many developer hours have been wasted on
confusing it with global_reclaim(): just use mem_cgroup_disabled().

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~mm-memcg-scanning_global_lru-means-mem_cgroup_disabled mm/vmscan.c
--- a/mm/vmscan.c~mm-memcg-scanning_global_lru-means-mem_cgroup_disabled
+++ a/mm/vmscan.c
@@ -140,26 +140,16 @@ static bool global_reclaim(struct scan_c
 {
 	return !sc->target_mem_cgroup;
 }
-
-static bool scanning_global_lru(struct mem_cgroup_zone *mz)
-{
-	return !mz->mem_cgroup;
-}
 #else
 static bool global_reclaim(struct scan_control *sc)
 {
 	return true;
 }
-
-static bool scanning_global_lru(struct mem_cgroup_zone *mz)
-{
-	return true;
-}
 #endif
 
 static struct zone_reclaim_stat *get_reclaim_stat(struct mem_cgroup_zone *mz)
 {
-	if (!scanning_global_lru(mz))
+	if (!mem_cgroup_disabled())
 		return mem_cgroup_get_reclaim_stat(mz->mem_cgroup, mz->zone);
 
 	return &mz->zone->reclaim_stat;
@@ -168,7 +158,7 @@ static struct zone_reclaim_stat *get_rec
 static unsigned long zone_nr_lru_pages(struct mem_cgroup_zone *mz,
 				       enum lru_list lru)
 {
-	if (!scanning_global_lru(mz))
+	if (!mem_cgroup_disabled())
 		return mem_cgroup_zone_nr_lru_pages(mz->mem_cgroup,
 						    zone_to_nid(mz->zone),
 						    zone_idx(mz->zone),
@@ -1589,7 +1579,7 @@ static int inactive_anon_is_low(struct m
 	if (!total_swap_pages)
 		return 0;
 
-	if (!scanning_global_lru(mz))
+	if (!mem_cgroup_disabled())
 		return mem_cgroup_inactive_anon_is_low(mz->mem_cgroup,
 						       mz->zone);
 
@@ -1628,7 +1618,7 @@ static int inactive_file_is_low_global(s
  */
 static int inactive_file_is_low(struct mem_cgroup_zone *mz)
 {
-	if (!scanning_global_lru(mz))
+	if (!mem_cgroup_disabled())
 		return mem_cgroup_inactive_file_is_low(mz->mem_cgroup,
 						       mz->zone);
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch


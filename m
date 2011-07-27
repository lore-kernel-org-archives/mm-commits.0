From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-vmscan-count-in-small-memcgs.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:10 -0700
Message-ID: <201107271926.p6RJQuwg003157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558Ab1G0T1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix vmscan count in small memcgs
has been removed from the -mm tree.  Its filename was
     memcg-fix-vmscan-count-in-small-memcgs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix vmscan count in small memcgs
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

246e87a ("memcg: fix get_scan_count() for small targets") fixes the
memcg/kswapd behavior against small targets and prevent vmscan priority
too high.

But implementation is too naive and adds another problem to small memcg. 
It always force scan to 32 pages of file/anon and doesn't handle
swappiness and other rotate_info.  It makes vmscan to scan anon LRU
regardless of swappiness and make reclaim bad.  This patch fixes it by
adjusting scanning count with regard to swappiness at el.

At a test "cat 1G file under 300M limit." (swappiness=20)
 before patch
        scanned_pages_by_limit 360919
        scanned_anon_pages_by_limit 180469
        scanned_file_pages_by_limit 180450
        rotated_pages_by_limit 31
        rotated_anon_pages_by_limit 25
        rotated_file_pages_by_limit 6
        freed_pages_by_limit 180458
        freed_anon_pages_by_limit 19
        freed_file_pages_by_limit 180439
        elapsed_ns_by_limit 429758872
 after patch
        scanned_pages_by_limit 180674
        scanned_anon_pages_by_limit 24
        scanned_file_pages_by_limit 180650
        rotated_pages_by_limit 35
        rotated_anon_pages_by_limit 24
        rotated_file_pages_by_limit 11
        freed_pages_by_limit 180634
        freed_anon_pages_by_limit 0
        freed_file_pages_by_limit 180634
        elapsed_ns_by_limit 367119089
        scanned_pages_by_system 0

the numbers of scanning anon are decreased(as expected), and elapsed time
reduced. By this patch, small memcgs will work better.
(*) Because the amount of file-cache is much bigger than anon,
    recalaim_stat's rotate-scan counter make scanning files more.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~memcg-fix-vmscan-count-in-small-memcgs mm/vmscan.c
--- a/mm/vmscan.c~memcg-fix-vmscan-count-in-small-memcgs
+++ a/mm/vmscan.c
@@ -1795,6 +1795,7 @@ static void get_scan_count(struct zone *
 	enum lru_list l;
 	int noswap = 0;
 	int force_scan = 0;
+	unsigned long nr_force_scan[2];
 
 
 	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
@@ -1817,6 +1818,8 @@ static void get_scan_count(struct zone *
 		fraction[0] = 0;
 		fraction[1] = 1;
 		denominator = 1;
+		nr_force_scan[0] = 0;
+		nr_force_scan[1] = SWAP_CLUSTER_MAX;
 		goto out;
 	}
 
@@ -1828,6 +1831,8 @@ static void get_scan_count(struct zone *
 			fraction[0] = 1;
 			fraction[1] = 0;
 			denominator = 1;
+			nr_force_scan[0] = SWAP_CLUSTER_MAX;
+			nr_force_scan[1] = 0;
 			goto out;
 		}
 	}
@@ -1876,6 +1881,11 @@ static void get_scan_count(struct zone *
 	fraction[0] = ap;
 	fraction[1] = fp;
 	denominator = ap + fp + 1;
+	if (force_scan) {
+		unsigned long scan = SWAP_CLUSTER_MAX;
+		nr_force_scan[0] = div64_u64(scan * ap, denominator);
+		nr_force_scan[1] = div64_u64(scan * fp, denominator);
+	}
 out:
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
@@ -1896,12 +1906,8 @@ out:
 		 * memcg, priority drop can cause big latency. So, it's better
 		 * to scan small amount. See may_noscan above.
 		 */
-		if (!scan && force_scan) {
-			if (file)
-				scan = SWAP_CLUSTER_MAX;
-			else if (!noswap)
-				scan = SWAP_CLUSTER_MAX;
-		}
+		if (!scan && force_scan)
+			scan = nr_force_scan[file];
 		nr[l] = scan;
 	}
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-mempolicyc-make-copy_from_user-provably-correct.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch


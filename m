From: akpm@linux-foundation.org
Subject: + memcg-fix-vmscan-count-in-small-memcgs.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:27:12 -0700
Message-ID: <201107222227.p6MMRCW0018752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab1GVW14 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:27:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     memcg: fix vmscan count in small memcgs
has been added to the -mm tree.  Its filename is
     memcg-fix-vmscan-count-in-small-memcgs.patch

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

mm-mempolicyc-make-copy_from_user-provably-correct.patch
mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch
oom-make-deprecated-use-of-oom_adj-more-verbose.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
memcg-make-oom_lock-0-and-1-based-rather-than-counter.patch
memcg-change-memcg_oom_mutex-to-spinlock.patch
memcg-fix-vmscan-count-in-small-memcgs.patch
memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch
memcg-unify-sync-and-async-per-cpu-charge-cache-draining.patch
memcg-add-mem_cgroup_same_or_subtree-helper.patch
memcg-get-rid-of-percpu_charge_mutex-lock.patch
fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch


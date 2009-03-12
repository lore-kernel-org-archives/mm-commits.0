From: akpm@linux-foundation.org
Subject: + memcg-use-correct-scan-number-at-reclaim.patch added to -mm tree
Date: Thu, 12 Mar 2009 00:25:20 -0700
Message-ID: <200903120725.n2C7PKDt026019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbZCLH1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 03:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: use correct scan number at reclaim
has been added to the -mm tree.  Its filename is
     memcg-use-correct-scan-number-at-reclaim.patch

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
Subject: memcg: use correct scan number at reclaim
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Even when page reclaim is under mem_cgroup, # of scan page is determined by
status of global LRU. Fix that.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~memcg-use-correct-scan-number-at-reclaim mm/vmscan.c
--- a/mm/vmscan.c~memcg-use-correct-scan-number-at-reclaim
+++ a/mm/vmscan.c
@@ -1469,7 +1469,7 @@ static void shrink_zone(int priority, st
 		int file = is_file_lru(l);
 		int scan;
 
-		scan = zone_page_state(zone, NR_LRU_BASE + l);
+		scan = zone_nr_pages(zone, sc, l);
 		if (priority) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch
memcg-use-correct-scan-number-at-reclaim.patch
linux-next.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-remove-pagevec_swap_free.patch
memdup_user-introduce.patch
memdup_user-introduce-fix.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


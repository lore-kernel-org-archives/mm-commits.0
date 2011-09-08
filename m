From: akpm@linux-foundation.org
Subject: + memcg-close-race-between-charge-and-putback.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:58:09 -0700
Message-ID: <201109082358.p88NwA1e016182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980Ab1IHX6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     memcg: close race between charge and putback
has been added to the -mm tree.  Its filename is
     memcg-close-race-between-charge-and-putback.patch

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
Subject: memcg: close race between charge and putback
From: Johannes Weiner <jweiner@redhat.com>

There is a potential race between a thread charging a page and another
thread putting it back to the LRU list:

charge:                         putback:
SetPageCgroupUsed               SetPageLRU
PageLRU && add to memcg LRU     PageCgroupUsed && add to memcg LRU

The order of setting one flag and checking the other is crucial, otherwise
the charge may observe !PageLRU while the putback observes !PageCgroupUsed
and the page is not linked to the memcg LRU at all.

Global memory pressure may fix this by trying to isolate and putback the
page for reclaim, where that putback would link it to the memcg LRU again.
 Without that, the memory cgroup is undeletable due to a charge whose
physical page can not be found and moved out.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Cc: Ying Han <yinghan@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-close-race-between-charge-and-putback mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-close-race-between-charge-and-putback
+++ a/mm/memcontrol.c
@@ -994,6 +994,16 @@ void mem_cgroup_add_lru_list(struct page
 		return;
 	pc = lookup_page_cgroup(page);
 	VM_BUG_ON(PageCgroupAcctLRU(pc));
+	/*
+	 * putback:				charge:
+	 * SetPageLRU				SetPageCgroupUsed
+	 * smp_mb				smp_mb
+	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
+	 *
+	 * Ensure that one of the two sides adds the page to the memcg
+	 * LRU during a race.
+	 */
+	smp_mb();
 	if (!PageCgroupUsed(pc))
 		return;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
@@ -1045,7 +1055,16 @@ static void mem_cgroup_lru_add_after_com
 	unsigned long flags;
 	struct zone *zone = page_zone(page);
 	struct page_cgroup *pc = lookup_page_cgroup(page);
-
+	/*
+	 * putback:				charge:
+	 * SetPageLRU				SetPageCgroupUsed
+	 * smp_mb				smp_mb
+	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
+	 *
+	 * Ensure that one of the two sides adds the page to the memcg
+	 * LRU during a race.
+	 */
+	smp_mb();
 	/* taking care of that the page is added to LRU while we commit it */
 	if (likely(!PageLRU(page)))
 		return;
_

Patches currently in -mm which might be from jweiner@redhat.com are

mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
memcg-revert-memcg-add-memoryvmscan_stat.patch
mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-page-writebackc-document-bdi_min_ratio.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-compaction-compact-unevictable-pages.patch
mm-compaction-accounting-fix.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch
memcg-close-race-between-charge-and-putback.patch


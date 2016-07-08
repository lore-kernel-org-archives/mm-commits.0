From: akpm@linux-foundation.org
Subject: + mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch added
 to -mm tree
Date: Fri, 08 Jul 2016 13:34:19 -0700
Message-ID: <57800e4b.JQq0bwZcGY9V3xgS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbcGHUeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: print node-based stats in zoneinfo file
has been added to the -mm tree.  Its filename is
     mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmstat: print node-based stats in zoneinfo file

There are a number of stats that were previously accessible via zoneinfo
that are now invisible. While it is possible to create a new file for the
node stats, this may be missed by users. Instead this patch prints the
stats under the first populated zone in /proc/zoneinfo.

Link: http://lkml.kernel.org/r/1467970510-21195-34-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN mm/vmstat.c~mm-vmstat-print-node-based-stats-in-zoneinfo-file mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-print-node-based-stats-in-zoneinfo-file
+++ a/mm/vmstat.c
@@ -1415,11 +1415,35 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
+static bool is_zone_first_populated(pg_data_t *pgdat, struct zone *zone)
+{
+	int zid;
+
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		struct zone *compare = &pgdat->node_zones[zid];
+
+		if (populated_zone(compare))
+			return zone == compare;
+	}
+
+	/* The zone must be somewhere! */
+	WARN_ON_ONCE(1);
+	return false;
+}
+
 static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 							struct zone *zone)
 {
 	int i;
 	seq_printf(m, "Node %d, zone %8s", pgdat->node_id, zone->name);
+	if (is_zone_first_populated(pgdat, zone)) {
+		seq_printf(m, "\n  per-node stats");
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+			seq_printf(m, "\n      %-12s %lu",
+				vmstat_text[i + NR_VM_ZONE_STAT_ITEMS],
+				node_page_state(pgdat, i));
+		}
+	}
 	seq_printf(m,
 		   "\n  pages free     %lu"
 		   "\n        min      %lu"
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch
mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
mm-meminit-remove-early_page_nid_uninitialised.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-mmzone-clarify-the-usage-of-zone-padding.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch


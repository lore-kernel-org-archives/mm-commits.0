From: akpm@linux-foundation.org
Subject: + mm-move-most-file-based-accounting-to-the-node-fix.patch added
 to -mm tree
Date: Wed, 13 Jul 2016 14:05:53 -0700
Message-ID: <5786ad31.NYezm+O/FT6k2ZQ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbcGMVFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:05:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move most file-based accounting to the node -fix
has been added to the -mm tree.  Its filename is
     mm-move-most-file-based-accounting-to-the-node-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-most-file-based-accounting-to-the-node-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-most-file-based-accounting-to-the-node-fix.patch

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
Subject: mm: move most file-based accounting to the node -fix

As noted by Johannes Weiner, NR_ZONE_WRITE_PENDING gets decremented twice
during migration instead of a dec(old) -> inc(new) cycle as intended.

This is a fix to mmotm patch
mm-move-most-file-based-accounting-to-the-node.patch

Note that it'll cause a conflict with
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch
but that the resolution is trivial.

Link: http://lkml.kernel.org/r/1468404004-5085-5-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-move-most-file-based-accounting-to-the-node-fix mm/migrate.c
--- a/mm/migrate.c~mm-move-most-file-based-accounting-to-the-node-fix
+++ a/mm/migrate.c
@@ -515,7 +515,7 @@ int migrate_page_move_mapping(struct add
 			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
 			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
 			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
-			__dec_zone_state(newzone, NR_ZONE_WRITE_PENDING);
+			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
 		}
 	}
 	local_irq_enable();
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
mm-move-most-file-based-accounting-to-the-node-fix.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit-fix.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch


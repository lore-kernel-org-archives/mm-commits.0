From: akpm@linux-foundation.org
Subject: [merged]
 mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch removed
 from -mm tree
Date: Tue, 19 Jul 2016 11:10:23 -0700
Message-ID: <578e6d0f.uYF/XUGQd7hDCL60%akpm__31158.2309463576$1468951836$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbcGSSKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 14:10:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, meminit: always return a valid node from early_pfn_to_nid
has been removed from the -mm tree.  Its filename was
     mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, meminit: always return a valid node from early_pfn_to_nid

early_pfn_to_nid can return node 0 if a PFN is invalid on machines that
has no node 0.  A machine with only node 1 was observed to crash with the
following message

 BUG: unable to handle kernel paging request at 000000000002a3c8
 PGD 0
 Modules linked in:
 Hardware name: Supermicro H8DSP-8/H8DSP-8, BIOS 080011  06/30/2006
 task: ffffffff81c0d500 ti: ffffffff81c00000 task.ti: ffffffff81c00000
 RIP: 0010:[<ffffffff816dbd63>]  [<ffffffff816dbd63>] reserve_bootmem_region+0x6a/0xef
 RSP: 0000:ffffffff81c03eb0  EFLAGS: 00010086
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: ffffffff81c03ec0 RSI: ffffffff81d205c0 RDI: ffffffff8213ee60
 R13: ffffea0000000000 R14: ffffea0000000020 R15: ffffea0000000020
 FS:  0000000000000000(0000) GS:ffff8800fba00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000000002a3c8 CR3: 0000000001c06000 CR4: 00000000000006b0
 Stack:
  ffffffff81c03f00 0000000000000400 ffff8800fbfc3200 ffffffff81e2a2c0
  ffffffff81c03fb0 ffffffff81c03f20 ffffffff81dadf7d ffffea0002000040
  ffffea0000000000 0000000000000000 000000000000ffff 0000000000000001
 Call Trace:
  [<ffffffff81dadf7d>] free_all_bootmem+0x4b/0x12a
  [<ffffffff81d97122>] mem_init+0x70/0xa3
  [<ffffffff81d78f21>] start_kernel+0x25b/0x49b

The problem is that early_page_uninitialised uses the early_pfn_to_nid
helper which returns node 0 for invalid PFNs. No caller of early_pfn_to_nid
cares except early_page_uninitialised. This patch has early_pfn_to_nid
always return a valid node.

Link: http://lkml.kernel.org/r/1468008031-3848-3-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid
+++ a/mm/page_alloc.c
@@ -1273,7 +1273,7 @@ int __meminit early_pfn_to_nid(unsigned
 	spin_lock(&early_pfn_lock);
 	nid = __early_pfn_to_nid(pfn, &early_pfnnid_cache);
 	if (nid < 0)
-		nid = 0;
+		nid = first_online_node;
 	spin_unlock(&early_pfn_lock);
 
 	return nid;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

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
mm-vmscan-make-shrink_node-decisions-more-node-centric-fix.patch
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
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready-fix.patch
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
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries-fix.patch
mm-pagevec-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch
mm-vmscan-remove-redundant-check-in-shrink_zones.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change.patch


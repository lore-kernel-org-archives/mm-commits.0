From: akpm@google.com
Subject: + vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch added to -mm tree
Date: Mon, 10 Oct 2011 16:37:36 -0700
Message-ID: <201110102337.p9ANbaiY001716@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:11699 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1JJXht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2011 19:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, aarcange@redhat.com, mgorman@suse.de, minchan.kim@gmail.com


The patch titled
     Subject: vmscan-limit-direct-reclaim-for-higher-order-allocations-fix
has been added to the -mm tree.  Its filename is
     vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch

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
From: Johannes Weiner <jweiner@redhat.com>
Subject: vmscan-limit-direct-reclaim-for-higher-order-allocations-fix

change comment to explain the order check

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-limit-direct-reclaim-for-higher-order-allocations-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-limit-direct-reclaim-for-higher-order-allocations-fix
+++ a/mm/vmscan.c
@@ -2115,8 +2115,14 @@ static void shrink_zones(int priority, s
 				continue;	/* Let kswapd poll it */
 			if (COMPACTION_BUILD) {
 				/*
-				 * If we already have plenty of memory free
-				 * for compaction, don't free any more.
+				 * If we already have plenty of memory
+				 * free for compaction, don't free any
+				 * more.  Even though compaction is
+				 * invoked for any non-zero order,
+				 * only frequent costly order
+				 * reclamation is disruptive enough to
+				 * become a noticable problem, like
+				 * transparent huge page allocations.
 				 */
 				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
 					(compaction_suitable(zone, sc->order) ||
_
Subject: Subject: vmscan-limit-direct-reclaim-for-higher-order-allocations-fix

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
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
mm-add-extra-free-kbytes-tunable.patch
vmscanc-fix-invalid-strict_strtoul-check-in-write_scan_unevictable_node.patch
mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch
mm-huge_memoryc-quiet-sparse-noise.patch
vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch
memcg-close-race-between-charge-and-putback.patch


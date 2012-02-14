From: akpm@linux-foundation.org
Subject: + mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch added to -mm tree
Date: Tue, 14 Feb 2012 12:38:38 -0800
Message-ID: <20120214203838.8E4D8A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49194 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab2BNUij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 15:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux.com, hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, smf.linux@ntlworld.com, stable@vger.kernel.org


The patch titled
     Subject: mm: vmscan: forcibly scan highmem if there are too many buffer_heads pinning highmem
has been added to the -mm tree.  Its filename is
     mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mel@csn.ul.ie>
Subject: mm: vmscan: forcibly scan highmem if there are too many buffer_heads pinning highmem

Stuart Foster reported on https://bugzilla.kernel.org/show_bug.cgi?id=42578
that copying large amounts of data from NTFS caused an OOM kill on 32-bit
X86 with 16G of memory. Andrew Morton correctly identified that the problem
was NTFS was using 512 blocks meaning each page had 8 buffer_heads in low
memory pinning it.

In the past, direct reclaim used to scan highmem even if the allocating
process did not specify __GFP_HIGHMEM but not any more.  kswapd no longer
will reclaim from zones that are above the high watermark.  The intention
in both cases was to minimise unnecessary reclaim.  The downside is on
machines with large amounts of highmem that lowmem can be fully consumed
by buffer_heads with nothing trying to free them.

The following patch is based on a suggestion by Andrew Morton to extend
the buffer_heads_over_limit case to force kswapd and direct reclaim to
scan the highmem zone regardless of the allocation request or watermarks.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=42578

Reported-by: Stuart Foster <smf.linux@ntlworld.com>
Tested-by: Stuart Foster <smf.linux@ntlworld.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN mm/vmscan.c~mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem
+++ a/mm/vmscan.c
@@ -2238,6 +2238,14 @@ static bool shrink_zones(int priority, s
 	unsigned long nr_soft_scanned;
 	bool aborted_reclaim = false;
 
+	/*
+	 * If the number of buffer_heads in the machine exceeds the maximum
+	 * allowed level, force direct reclaim to scan the highmem zone as
+	 * highmem pages could be pinning lowmem pages storing buffer_heads
+	 */
+	if (buffer_heads_over_limit)
+		sc->gfp_mask |= __GFP_HIGHMEM;
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
@@ -2727,6 +2735,17 @@ loop_again:
 			 */
 			age_active_anon(zone, &sc, priority);
 
+			/*
+			 * If the number of buffer_heads in the machine
+			 * exceeds the maximum allowed level and this node
+			 * has a highmem zone, force kswapd to reclaim from
+			 * it to relieve lowmem pressure.
+			 */
+			if (buffer_heads_over_limit && is_highmem_idx(i)) {
+				end_zone = i;
+				break;
+			}
+
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
_
Subject: Subject: mm: vmscan: forcibly scan highmem if there are too many buffer_heads pinning highmem

Patches currently in -mm which might be from mel@csn.ul.ie are

make-swapin-readahead-skip-over-holes-fix.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
add-debugging-aid-for-memory-initialisation-problems.patch


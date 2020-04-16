From: akpm@linux-foundation.org
Subject: +
 mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty.patch
 added to -mm tree
Date: Wed, 15 Apr 2020 20:52:23 -0700
Message-ID: <20200416035223.VPHE77lqv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403808AbgDPDwY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 23:52:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: clear out zone->lowmem_reserve[] if the zone is empty
has been added to the -mm tree.  Its filename is
     mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/page_alloc.c: clear out zone->lowmem_reserve[] if the zone is empty

When requesting memory allocation from a specific zone is not satisfied,
it will fall to lower zone to try allocating memory.  In this case, lower
zone's ->lowmem_reserve[] will help protect its own memory resource.  The
higher the relevant ->lowmem_reserve[] is, the harder the upper zone can
get memory from this lower zone.

However, this protection mechanism should be applied to populated zone,
but not an empty zone. So filling ->lowmem_reserve[] for empty zone is
not necessary, and may mislead people that it's valid data in that zone.

Node 2, zone      DMA
  pages free     0
        min      0
        low      0
        high     0
        spanned  0
        present  0
        managed  0
        protection: (0, 0, 1024, 1024)
Node 2, zone    DMA32
  pages free     0
        min      0
        low      0
        high     0
        spanned  0
        present  0
        managed  0
        protection: (0, 0, 1024, 1024)
Node 2, zone   Normal
  per-node stats
      nr_inactive_anon 0
      nr_active_anon 143
      nr_inactive_file 0
      nr_active_file 0
      nr_unevictable 0
      nr_slab_reclaimable 45
      nr_slab_unreclaimable 254

Here clear out zone->lowmem_reserve[] if zone is empty.

Link: http://lkml.kernel.org/r/20200402140113.3696-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty
+++ a/mm/page_alloc.c
@@ -7702,8 +7702,10 @@ static void setup_per_zone_lowmem_reserv
 				idx--;
 				lower_zone = pgdat->node_zones + idx;
 
-				if (!sysctl_lowmem_reserve_ratio[idx]) {
+				if (!sysctl_lowmem_reserve_ratio[idx] ||
+				    !zone_managed_pages(lower_zone)) {
 					lower_zone->lowmem_reserve[j] = 0;
+					continue;
 				} else {
 					lower_zone->lowmem_reserve[j] =
 						managed_pages / sysctl_lowmem_reserve_ratio[idx];
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch
mm-remove-unused-free_bootmem_with_active_regions.patch
mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it.patch
mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty.patch
mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch

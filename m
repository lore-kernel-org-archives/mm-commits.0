From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 040/131] mm/page_alloc.c: clear out
 zone->lowmem_reserve[] if the zone is empty
Date: Wed, 03 Jun 2020 15:58:52 -0700
Message-ID: <20200603225852.6Gh1tflS0%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW6y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:58:54 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -7704,8 +7704,10 @@ static void setup_per_zone_lowmem_reserv
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

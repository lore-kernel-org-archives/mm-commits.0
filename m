From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch
 added to -mm tree
Date: Mon, 06 Feb 2017 15:30:01 -0800
Message-ID: <589906f9.qQpQBwhlwnOK0Jp/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdBFXaC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 18:30:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: return 0 in case this node has no page within the zone
has been added to the -mm tree.  Its filename is
     mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: return 0 in case this node has no page within the zone

The whole memory space is divided into several zones and nodes may have no
page in some zones.  In this case, the __absent_pages_in_range() would
return 0, since the range it is searching for is an empty range.

Also this happens more often to those nodes with higher memory range when
there are more nodes, which is a trend for future architectures.

This patch checks the zone range after clamp and adjustment, return 0 if
the range is an empty range.

Link: http://lkml.kernel.org/r/20170206154314.15705-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone
+++ a/mm/page_alloc.c
@@ -5730,6 +5730,11 @@ static unsigned long __meminit zone_abse
 	adjust_zone_range_for_zone_movable(nid, zone_type,
 			node_start_pfn, node_end_pfn,
 			&zone_start_pfn, &zone_end_pfn);
+
+	/* If this node has no page within this zone, return 0. */
+	if (zone_start_pfn == zone_end_pfn)
+		return 0;
+
 	nr_absent = __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 
 	/*
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch
mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch


From: akpm@linux-foundation.org
Subject: + power-add-zone-range-overlapping-check.patch added to -mm tree
Date: Fri, 01 Apr 2016 15:57:09 -0700
Message-ID: <56fefcc5.CmgCj/dqbw0qMKWf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbcDAW5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2016 18:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, rjw@rjwysocki.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: power: add zone range overlapping check
has been added to the -mm tree.  Its filename is
     power-add-zone-range-overlapping-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/power-add-zone-range-overlapping-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/power-add-zone-range-overlapping-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: power: add zone range overlapping check

There is a system thats node's pfns are overlapped as follows:

-----pfn-------->
N0 N1 N2 N0 N1 N2

Therefore, we need to care this overlapping when iterating pfn range.

mark_free_pages() iterates requested zone's pfn range and unset all
range's bitmap first.  And then it marks freepages in a zone to the
bitmap.  If there is an overlapping zone, above unset could clear previous
marked bit and reference to this bitmap in the future will cause the
problem.  To prevent it, this patch adds a zone check in
mark_free_pages().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~power-add-zone-range-overlapping-check mm/page_alloc.c
--- a/mm/page_alloc.c~power-add-zone-range-overlapping-check
+++ a/mm/page_alloc.c
@@ -2156,6 +2156,10 @@ void mark_free_pages(struct zone *zone)
 	for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 		if (pfn_valid(pfn)) {
 			page = pfn_to_page(pfn);
+
+			if (page_zone(page) != zone)
+				continue;
+
 			if (!swsusp_page_is_forbidden(page))
 				swsusp_unset_page_free(page);
 		}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch
mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch
mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug.patch
mm-vmstat-add-zone-range-overlapping-check.patch
mm-page_owner-add-zone-range-overlapping-check.patch
power-add-zone-range-overlapping-check.patch


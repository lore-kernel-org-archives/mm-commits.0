From: akpm@linux-foundation.org
Subject: [patch 064/117] mm/memory_hotplug: add comment to some functions
 related to memory hotplug
Date: Thu, 19 May 2016 17:12:06 -0700
Message-ID: <573e5656.RLtWdjf1YPNwxwq2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbcETAMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, rjw@rjwysocki.net, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/memory_hotplug: add comment to some functions related to memory hotplug

__offline_isolated_pages() and test_pages_isolated() are used by memory
hotplug.  These functions require that range is in a single zone but there
is no code to do this because memory hotplug checks it before calling
these functions.  To avoid confusing future user of these functions, this
patch adds comments to them.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
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

 mm/page_alloc.c     |    3 ++-
 mm/page_isolation.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug
+++ a/mm/page_alloc.c
@@ -7176,7 +7176,8 @@ void zone_pcp_reset(struct zone *zone)
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
- * All pages in the range must be isolated before calling this.
+ * All pages in the range must be in a single zone and isolated
+ * before calling this.
  */
 void
 __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
diff -puN mm/page_isolation.c~mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug mm/page_isolation.c
--- a/mm/page_isolation.c~mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug
+++ a/mm/page_isolation.c
@@ -246,6 +246,7 @@ __test_page_isolated_in_pageblock(unsign
 	return pfn;
 }
 
+/* Caller should ensure that requested range is in a single zone */
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			bool skip_hwpoisoned_pages)
 {
_

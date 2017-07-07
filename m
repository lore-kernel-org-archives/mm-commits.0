From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:10:18 -0700
Message-ID: <20170707191018.6PJmPMZnE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdGGTKb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mka@chromium.org, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm/page_alloc.c: mark bad_range() and meminit_pfn_in_nid() as __maybe_unused
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: mm/page_alloc.c: mark bad_range() and meminit_pfn_in_nid() as __maybe_unused

The functions are not used in some configurations.  Adding the attribute
fixes the following warnings when building with clang:

mm/page_alloc.c:409:19: error: function 'bad_range' is not needed and
    will not be emitted [-Werror,-Wunneeded-internal-declaration]

mm/page_alloc.c:1106:30: error: unused function 'meminit_pfn_in_nid'
    [-Werror,-Wunused-function]

Link: http://lkml.kernel.org/r/20170518182030.165633-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused
+++ a/mm/page_alloc.c
@@ -511,7 +511,7 @@ static int page_is_consistent(struct zon
 /*
  * Temporary debugging check for pages not lying within a given zone.
  */
-static int bad_range(struct zone *zone, struct page *page)
+static int __maybe_unused bad_range(struct zone *zone, struct page *page)
 {
 	if (page_outside_zone_boundaries(zone, page))
 		return 1;
@@ -521,7 +521,7 @@ static int bad_range(struct zone *zone,
 	return 0;
 }
 #else
-static inline int bad_range(struct zone *zone, struct page *page)
+static inline int __maybe_unused bad_range(struct zone *zone, struct page *page)
 {
 	return 0;
 }
@@ -1297,8 +1297,9 @@ int __meminit early_pfn_to_nid(unsigned
 #endif
 
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
-static inline bool __meminit meminit_pfn_in_nid(unsigned long pfn, int node,
-					struct mminit_pfnnid_cache *state)
+static inline bool __meminit __maybe_unused
+meminit_pfn_in_nid(unsigned long pfn, int node,
+		   struct mminit_pfnnid_cache *state)
 {
 	int nid;
 
@@ -1320,8 +1321,9 @@ static inline bool __meminit early_pfn_i
 {
 	return true;
 }
-static inline bool __meminit meminit_pfn_in_nid(unsigned long pfn, int node,
-					struct mminit_pfnnid_cache *state)
+static inline bool __meminit  __maybe_unused
+meminit_pfn_in_nid(unsigned long pfn, int node,
+		   struct mminit_pfnnid_cache *state)
 {
 	return true;
 }
_

Patches currently in -mm which might be from mka@chromium.org are



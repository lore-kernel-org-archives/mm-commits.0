From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused.patch added to -mm tree
Date: Thu, 18 May 2017 12:29:18 -0700
Message-ID: <591df60e.E8uqG6BnDMbWrrX6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57648 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754793AbdERT3T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 15:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: mark bad_range() and meminit_pfn_in_nid() as __maybe_unused
has been added to the -mm tree.  Its filename is
     mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -500,7 +500,7 @@ static int page_is_consistent(struct zon
 /*
  * Temporary debugging check for pages not lying within a given zone.
  */
-static int bad_range(struct zone *zone, struct page *page)
+static int __maybe_unused bad_range(struct zone *zone, struct page *page)
 {
 	if (page_outside_zone_boundaries(zone, page))
 		return 1;
@@ -510,7 +510,7 @@ static int bad_range(struct zone *zone,
 	return 0;
 }
 #else
-static inline int bad_range(struct zone *zone, struct page *page)
+static inline int __maybe_unused bad_range(struct zone *zone, struct page *page)
 {
 	return 0;
 }
@@ -1286,8 +1286,9 @@ int __meminit early_pfn_to_nid(unsigned
 #endif
 
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
-static inline bool __meminit meminit_pfn_in_nid(unsigned long pfn, int node,
-					struct mminit_pfnnid_cache *state)
+static inline bool __meminit __maybe_unused
+meminit_pfn_in_nid(unsigned long pfn, int node,
+		   struct mminit_pfnnid_cache *state)
 {
 	int nid;
 
@@ -1309,8 +1310,9 @@ static inline bool __meminit early_pfn_i
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

frv-declare-jiffies-to-be-located-in-the-data-section.patch
mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused.patch


From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 01/11] mm, thp: tweak reclaim/compaction effort of
 local-only and all-node allocations
Date: Mon, 13 Jan 2020 16:29:04 -0800
Message-ID: <20200114002904.h9bSo%akpm__21904.1851743654$1578961831$gmane$org@linux-foundation.org>
References: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgANA3F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:05 -0500
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.com, mgorman@suse.de, kirill@shutemov.name, aarcange@redhat.com, vbabka@suse.cz, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, thp: tweak reclaim/compaction effort of local-only and all-node allocations

THP page faults now attempt a __GFP_THISNODE allocation first, which
should only compact existing free memory, followed by another attempt that
can allocate from any node using reclaim/compaction effort specified by
global defrag setting and madvise.

This patch makes the following changes to the scheme:

- before the patch, the first allocation relies on a check for pageblock
  order and __GFP_IO to prevent excessive reclaim.  This however affects
  also the second attempt, which is not limited to single node.  Instead
  of that, reuse the existing check for costly order __GFP_NORETRY
  allocations, and make sure the first THP attempt uses __GFP_NORETRY.  As
  a side-effect, all costly order __GFP_NORETRY allocations will bail out
  if compaction needs reclaim, while previously they only bailed out when
  compaction was deferred due to previous failures.  This should be still
  acceptable within the __GFP_NORETRY semantics.

- before the patch, the second allocation attempt (on all nodes) was
  passing __GFP_NORETRY.  This is redundant as the check for pageblock
  order (discussed above) was stronger.  It's also contrary to
  madvise(MADV_HUGEPAGE) which means some effort to allocate THP is
  requested.  After this patch, the second attempt doesn't pass
  __GFP_THISNODE nor __GFP_NORETRY.

To sum up, THP page faults now try the following attempts:

1. local node only THP allocation with no reclaim, just compaction.
2. for madvised VMA's or when synchronous compaction is enabled always - THP
   allocation from any node with effort determined by global defrag setting
   and VMA madvise
3. fallback to base pages on any node

Link: http://lkml.kernel.org/r/08a3f4dd-c3ce-0009-86c5-9ee51aba8557@suse.cz
Fixes: b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction may not succeed")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c  |   10 +++++++---
 mm/page_alloc.c |   24 +++++-------------------
 2 files changed, 12 insertions(+), 22 deletions(-)

--- a/mm/mempolicy.c~mm-thp-tweak-reclaim-compaction-effort-of-local-only-and-all-node-allocations
+++ a/mm/mempolicy.c
@@ -2148,18 +2148,22 @@ alloc_pages_vma(gfp_t gfp, int order, st
 		nmask = policy_nodemask(gfp, pol);
 		if (!nmask || node_isset(hpage_node, *nmask)) {
 			mpol_cond_put(pol);
+			/*
+			 * First, try to allocate THP only on local node, but
+			 * don't reclaim unnecessarily, just compact.
+			 */
 			page = __alloc_pages_node(hpage_node,
-						gfp | __GFP_THISNODE, order);
+				gfp | __GFP_THISNODE | __GFP_NORETRY, order);
 
 			/*
 			 * If hugepage allocations are configured to always
 			 * synchronous compact or the vma has been madvised
 			 * to prefer hugepage backing, retry allowing remote
-			 * memory as well.
+			 * memory with both reclaim and compact as well.
 			 */
 			if (!page && (gfp & __GFP_DIRECT_RECLAIM))
 				page = __alloc_pages_node(hpage_node,
-						gfp | __GFP_NORETRY, order);
+								gfp, order);
 
 			goto out;
 		}
--- a/mm/page_alloc.c~mm-thp-tweak-reclaim-compaction-effort-of-local-only-and-all-node-allocations
+++ a/mm/page_alloc.c
@@ -4476,8 +4476,11 @@ retry_cpuset:
 		if (page)
 			goto got_pg;
 
-		 if (order >= pageblock_order && (gfp_mask & __GFP_IO) &&
-		     !(gfp_mask & __GFP_RETRY_MAYFAIL)) {
+		/*
+		 * Checks for costly allocations with __GFP_NORETRY, which
+		 * includes some THP page fault allocations
+		 */
+		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
 			/*
 			 * If allocating entire pageblock(s) and compaction
 			 * failed because all zones are below low watermarks
@@ -4498,23 +4501,6 @@ retry_cpuset:
 			if (compact_result == COMPACT_SKIPPED ||
 			    compact_result == COMPACT_DEFERRED)
 				goto nopage;
-		}

From: akpm@linux-foundation.org
Subject: + mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch added to -mm tree
Date: Fri, 01 May 2009 15:45:45 -0700
Message-ID: <200905012245.n41Mjjga017501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754476AbZEAWs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2009 18:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux.com, hugh@veritas.com


The patch titled
     mm: use alloc_pages_exact() in alloc_large_system_hash() to avoid duplicated logic
has been added to the -mm tree.  Its filename is
     mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch

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
Subject: mm: use alloc_pages_exact() in alloc_large_system_hash() to avoid duplicated logic
From: Mel Gorman <mel@csn.ul.ie>

alloc_large_system_hash() has logic for freeing pages at the end of an
excessively large power-of-two buffer that is a duplicate of what is in
alloc_pages_exact().  This patch converts alloc_large_system_hash() to use
alloc_pages_exact().

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff -puN mm/page_alloc.c~mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic
+++ a/mm/page_alloc.c
@@ -4749,26 +4749,13 @@ void *__init alloc_large_system_hash(con
 		else if (hashdist)
 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
 		else {
-			unsigned long order = get_order(size);
-
-			if (order < MAX_ORDER)
-				table = (void *)__get_free_pages(GFP_ATOMIC,
-								order);
 			/*
 			 * If bucketsize is not a power-of-two, we may free
-			 * some pages at the end of hash table.
+			 * some pages at the end of hash table which
+			 * alloc_pages_exact() automatically does
 			 */
-			if (table) {
-				unsigned long alloc_end = (unsigned long)table +
-						(PAGE_SIZE << order);
-				unsigned long used = (unsigned long)table +
-						PAGE_ALIGN(size);
-				split_page(virt_to_page(table), order);
-				while (used < alloc_end) {
-					free_page(used);
-					used += PAGE_SIZE;
-				}
-			}
+			if (get_order(size) < MAX_ORDER)
+				table = alloc_pages_exact(size, GFP_ATOMIC);
 		}
 	} while (!table && size > PAGE_SIZE && --log2qty);
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-fix-committed_as-underfolow-on-large-nr_cpus-environment.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
add-debugging-aid-for-memory-initialisation-problems.patch


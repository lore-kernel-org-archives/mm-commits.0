From: akpm@linux-foundation.org
Subject: [merged] mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:36 -0700
Message-ID: <200906171834.n5HIYadc000618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181AbZFQSfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux.com, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     mm: use alloc_pages_exact() in alloc_large_system_hash() to avoid duplicated logic
has been removed from the -mm tree.  Its filename was
     mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use alloc_pages_exact() in alloc_large_system_hash() to avoid duplicated logic
From: Mel Gorman <mel@csn.ul.ie>

alloc_large_system_hash() has logic for freeing pages at the end of an
excessively large power-of-two buffer that is a duplicate of what is in
alloc_pages_exact().  This patch converts alloc_large_system_hash() to use
alloc_pages_exact().

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff -puN mm/page_alloc.c~mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic
+++ a/mm/page_alloc.c
@@ -4699,26 +4699,13 @@ void *__init alloc_large_system_hash(con
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

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch


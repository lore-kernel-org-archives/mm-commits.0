Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FF2EB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjFXAAx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjFXAAe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1172727
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23E64614A8
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C01FC433C0;
        Sat, 24 Jun 2023 00:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564827;
        bh=0O3VWhP9fx8+vgrQ5VqQKtmcXiCQl46+RobVT0hZkCE=;
        h=Date:To:From:Subject:From;
        b=fualhyLvZqfJjZKHKxdKqyKVnsFOByXC6azAs+p7bZGLsD97k7nZ/MWg/LR79A7AN
         hrk/FllXo+oaOS6I+ZlFctRFpsNwQ+R/5lNGufGGcrNmxgeC8vXmMelxiTMMXLB4Y+
         2mBAacM2y3iXRPKazXtuhpOd2BrNrhFNNRbQhJSU=
Date:   Fri, 23 Jun 2023 17:00:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-references-to-pagevec.patch removed from -mm tree
Message-Id: <20230624000027.7C01FC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove references to pagevec
has been removed from the -mm tree.  Its filename was
     mm-remove-references-to-pagevec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove references to pagevec
Date: Wed, 21 Jun 2023 17:45:56 +0100

Most of these should just refer to the LRU cache rather than the data
structure used to implement the LRU cache.

Link: https://lkml.kernel.org/r/20230621164557.3510324-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c    |    2 +-
 mm/khugepaged.c     |    6 +++---
 mm/ksm.c            |    6 +++---
 mm/memory.c         |    6 +++---
 mm/migrate_device.c |    2 +-
 mm/swap.c           |    2 +-
 mm/truncate.c       |    2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)

--- a/mm/huge_memory.c~mm-remove-references-to-pagevec
+++ a/mm/huge_memory.c
@@ -1344,7 +1344,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	/*
 	 * See do_wp_page(): we can only reuse the folio exclusively if
 	 * there are no additional references. Note that we always drain
-	 * the LRU pagevecs immediately after adding a THP.
+	 * the LRU cache immediately after adding a THP.
 	 */
 	if (folio_ref_count(folio) >
 			1 + folio_test_swapcache(folio) * folio_nr_pages(folio))
--- a/mm/khugepaged.c~mm-remove-references-to-pagevec
+++ a/mm/khugepaged.c
@@ -1051,7 +1051,7 @@ static int __collapse_huge_page_swapin(s
 	if (pte)
 		pte_unmap(pte);
 
-	/* Drain LRU add pagevec to remove extra pin on the swapped in pages */
+	/* Drain LRU cache to remove extra pin on the swapped in pages */
 	if (swapped_in)
 		lru_add_drain();
 
@@ -1972,7 +1972,7 @@ static int collapse_file(struct mm_struc
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
-				/* drain pagevecs to help isolate_lru_page() */
+				/* drain lru cache to help isolate_lru_page() */
 				lru_add_drain();
 				page = folio_file_page(folio, index);
 			} else if (trylock_page(page)) {
@@ -1988,7 +1988,7 @@ static int collapse_file(struct mm_struc
 				page_cache_sync_readahead(mapping, &file->f_ra,
 							  file, index,
 							  end - index);
-				/* drain pagevecs to help isolate_lru_page() */
+				/* drain lru cache to help isolate_lru_page() */
 				lru_add_drain();
 				page = find_lock_page(mapping, index);
 				if (unlikely(page == NULL)) {
--- a/mm/ksm.c~mm-remove-references-to-pagevec
+++ a/mm/ksm.c
@@ -932,7 +932,7 @@ static int remove_stable_node(struct ksm
 		 * The stable node did not yet appear stale to get_ksm_page(),
 		 * since that allows for an unmapped ksm page to be recognized
 		 * right up until it is freed; but the node is safe to remove.
-		 * This page might be in a pagevec waiting to be freed,
+		 * This page might be in an LRU cache waiting to be freed,
 		 * or it might be PageSwapCache (perhaps under writeback),
 		 * or it might have been removed from swapcache a moment ago.
 		 */
@@ -2303,8 +2303,8 @@ static struct ksm_rmap_item *scan_get_ne
 		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
 
 		/*
-		 * A number of pages can hang around indefinitely on per-cpu
-		 * pagevecs, raised page count preventing write_protect_page
+		 * A number of pages can hang around indefinitely in per-cpu
+		 * LRU cache, raised page count preventing write_protect_page
 		 * from merging them.  Though it doesn't really matter much,
 		 * it is puzzling to see some stuck in pages_volatile until
 		 * other activity jostles them out, and they also prevented
--- a/mm/memory.c~mm-remove-references-to-pagevec
+++ a/mm/memory.c
@@ -3401,8 +3401,8 @@ static vm_fault_t do_wp_page(struct vm_f
 			goto copy;
 		if (!folio_test_lru(folio))
 			/*
-			 * Note: We cannot easily detect+handle references from
-			 * remote LRU pagevecs or references to LRU folios.
+			 * We cannot easily detect+handle references from
+			 * remote LRU caches or references to LRU folios.
 			 */
 			lru_add_drain();
 		if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
@@ -3880,7 +3880,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * If we want to map a page that's in the swapcache writable, we
 		 * have to detect via the refcount if we're really the exclusive
 		 * owner. Try removing the extra reference from the local LRU
-		 * pagevecs if required.
+		 * caches if required.
 		 */
 		if ((vmf->flags & FAULT_FLAG_WRITE) && folio == swapcache &&
 		    !folio_test_ksm(folio) && !folio_test_lru(folio))
--- a/mm/migrate_device.c~mm-remove-references-to-pagevec
+++ a/mm/migrate_device.c
@@ -376,7 +376,7 @@ static unsigned long migrate_device_unma
 		/* ZONE_DEVICE pages are not on LRU */
 		if (!is_zone_device_page(page)) {
 			if (!PageLRU(page) && allow_drain) {
-				/* Drain CPU's pagevec */
+				/* Drain CPU's lru cache */
 				lru_add_drain_all();
 				allow_drain = false;
 			}
--- a/mm/swap.c~mm-remove-references-to-pagevec
+++ a/mm/swap.c
@@ -76,7 +76,7 @@ static DEFINE_PER_CPU(struct cpu_fbatche
 
 /*
  * This path almost never happens for VM activity - pages are normally freed
- * via pagevecs.  But it gets used by networking - and for compound pages.
+ * in batches.  But it gets used by networking - and for compound pages.
  */
 static void __page_cache_release(struct folio *folio)
 {
--- a/mm/truncate.c~mm-remove-references-to-pagevec
+++ a/mm/truncate.c
@@ -565,7 +565,7 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
  * invalidation guarantees, and cannot afford to leave pages behind because
  * shrink_page_list() has a temp ref on them, or because they're transiently
- * sitting in the folio_add_lru() pagevecs.
+ * sitting in the folio_add_lru() caches.
  */
 static int invalidate_complete_folio2(struct address_space *mapping,
 					struct folio *folio)
_

Patches currently in -mm which might be from willy@infradead.org are



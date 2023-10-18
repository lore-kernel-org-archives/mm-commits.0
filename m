Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D147CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbjJRVgw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E84A13E
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BD1C433C8;
        Wed, 18 Oct 2023 21:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664918;
        bh=4X1qVBckaduQ0V6ec014ZoAtuhjM9FCaNgfEJXnUn1M=;
        h=Date:To:From:Subject:From;
        b=GKT2x5pKrNJ/27g6LtxzUl5XDpy0w2RkjYGsGbcp/AJGgNoEB8QWiKJhhq0qkCtdq
         O8g5jn5DxuxeAmYcCO0Tq4hfNNvwRAbBEolr1385GBCw2MYmN5CEjHnH+CwwiaTV86
         BzYc7pjAggnhagMDJ633KC86jk3A7vOjglvanqyk=
Date:   Wed, 18 Oct 2023 14:35:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch removed from -mm tree
Message-Id: <20231018213518.30BD1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory: move exclusivity detection in do_wp_page() into wp_can_reuse_anon_folio()
has been removed from the -mm tree.  Its filename was
     memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: memory: move exclusivity detection in do_wp_page() into wp_can_reuse_anon_folio()
Date: Mon, 2 Oct 2023 16:29:49 +0200

Let's clean up do_wp_page() a bit, removing two labels and making it a
easier to read.

wp_can_reuse_anon_folio() now only operates on the whole folio.  Move the
SetPageAnonExclusive() out into do_wp_page().  No need to do this under
page lock -- the page table lock is sufficient.

Link: https://lkml.kernel.org/r/20231002142949.235104-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   88 +++++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 43 deletions(-)

--- a/mm/memory.c~memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio
+++ a/mm/memory.c
@@ -3355,6 +3355,44 @@ static vm_fault_t wp_page_shared(struct
 	return ret;
 }
 
+static bool wp_can_reuse_anon_folio(struct folio *folio,
+				    struct vm_area_struct *vma)
+{
+	/*
+	 * We have to verify under folio lock: these early checks are
+	 * just an optimization to avoid locking the folio and freeing
+	 * the swapcache if there is little hope that we can reuse.
+	 *
+	 * KSM doesn't necessarily raise the folio refcount.
+	 */
+	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
+		return false;
+	if (!folio_test_lru(folio))
+		/*
+		 * We cannot easily detect+handle references from
+		 * remote LRU caches or references to LRU folios.
+		 */
+		lru_add_drain();
+	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
+		return false;
+	if (!folio_trylock(folio))
+		return false;
+	if (folio_test_swapcache(folio))
+		folio_free_swap(folio);
+	if (folio_test_ksm(folio) || folio_ref_count(folio) != 1) {
+		folio_unlock(folio);
+		return false;
+	}
+	/*
+	 * Ok, we've got the only folio reference from our mapping
+	 * and the folio is locked, it's dark out, and we're wearing
+	 * sunglasses. Hit it.
+	 */
+	folio_move_anon_rmap(folio, vma);
+	folio_unlock(folio);
+	return true;
+}
+
 /*
  * This routine handles present pages, when
  * * users try to write to a shared page (FAULT_FLAG_WRITE)
@@ -3441,49 +3479,14 @@ static vm_fault_t do_wp_page(struct vm_f
 	/*
 	 * Private mapping: create an exclusive anonymous page copy if reuse
 	 * is impossible. We might miss VM_WRITE for FOLL_FORCE handling.
+	 *
+	 * If we encounter a page that is marked exclusive, we must reuse
+	 * the page without further checks.
 	 */
-	if (folio && folio_test_anon(folio)) {
-		/*
-		 * If the page is exclusive to this process we must reuse the
-		 * page without further checks.
-		 */
-		if (PageAnonExclusive(vmf->page))
-			goto reuse;
-
-		/*
-		 * We have to verify under folio lock: these early checks are
-		 * just an optimization to avoid locking the folio and freeing
-		 * the swapcache if there is little hope that we can reuse.
-		 *
-		 * KSM doesn't necessarily raise the folio refcount.
-		 */
-		if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
-			goto copy;
-		if (!folio_test_lru(folio))
-			/*
-			 * We cannot easily detect+handle references from
-			 * remote LRU caches or references to LRU folios.
-			 */
-			lru_add_drain();
-		if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
-			goto copy;
-		if (!folio_trylock(folio))
-			goto copy;
-		if (folio_test_swapcache(folio))
-			folio_free_swap(folio);
-		if (folio_test_ksm(folio) || folio_ref_count(folio) != 1) {
-			folio_unlock(folio);
-			goto copy;
-		}
-		/*
-		 * Ok, we've got the only folio reference from our mapping
-		 * and the folio is locked, it's dark out, and we're wearing
-		 * sunglasses. Hit it.
-		 */
-		folio_move_anon_rmap(folio, vma);
-		SetPageAnonExclusive(vmf->page);
-		folio_unlock(folio);
-reuse:
+	if (folio && folio_test_anon(folio) &&
+	    (PageAnonExclusive(vmf->page) || wp_can_reuse_anon_folio(folio, vma))) {
+		if (!PageAnonExclusive(vmf->page))
+			SetPageAnonExclusive(vmf->page);
 		if (unlikely(unshare)) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return 0;
@@ -3491,7 +3494,6 @@ reuse:
 		wp_page_reuse(vmf);
 		return 0;
 	}
-copy:
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
_

Patches currently in -mm which might be from david@redhat.com are



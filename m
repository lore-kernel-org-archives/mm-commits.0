Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C375C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B9DC613DD
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhEEBdp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229799AbhEEBdo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:33:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD860613CC;
        Wed,  5 May 2021 01:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178369;
        bh=jepdlDGeRjnbTN7aO6jeWPO83y65rIl4VATat+NxURg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gB+WFwzL5+hBS1iun2aR7loDusWjnmm9FalkfcO3bKEQxm4DHXiwkcqiyMWArMbQi
         MfLToqvPDFBDgb3Klf0jy8IZoUkdrVhO9UU4zIVudyqkebdUXKK2/7Bt1Ecggfo/xv
         CQ5CTpFLAkh9byYfsxo86ONk0NLoCn+B59fOGmIg=
Date:   Tue, 04 May 2021 18:32:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  [patch 002/143] mm: stop accounting shadow entries
Message-ID: <20210505013248.5s3M8UuFQ%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: stop accounting shadow entries

We no longer need to keep track of how many shadow entries are present in
a mapping.  This saves a few writes to the inode and memory barriers.

Link: https://lkml.kernel.org/r/20201026151849.24232-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |   13 -------------
 mm/swap_state.c |    4 ----
 mm/truncate.c   |    1 -
 mm/workingset.c |    1 -
 4 files changed, 19 deletions(-)

--- a/mm/filemap.c~mm-stop-accounting-shadow-entries
+++ a/mm/filemap.c
@@ -142,17 +142,6 @@ static void page_cache_delete(struct add
 
 	page->mapping = NULL;
 	/* Leave page->index set: truncation lookup relies upon it */
-
-	if (shadow) {
-		mapping->nrexceptional += nr;
-		/*
-		 * Make sure the nrexceptional update is committed before
-		 * the nrpages update so that final truncate racing
-		 * with reclaim does not see both counters 0 at the
-		 * same time and miss a shadow entry.
-		 */
-		smp_wmb();
-	}
 	mapping->nrpages -= nr;
 }
 
@@ -925,8 +914,6 @@ noinline int __add_to_page_cache_locked(
 		if (xas_error(&xas))
 			goto unlock;
 
-		if (old)
-			mapping->nrexceptional--;
 		mapping->nrpages++;
 
 		/* hugetlb pages do not participate in page cache accounting */
--- a/mm/swap_state.c~mm-stop-accounting-shadow-entries
+++ a/mm/swap_state.c
@@ -132,7 +132,6 @@ int add_to_swap_cache(struct page *page,
 			xas_store(&xas, page);
 			xas_next(&xas);
 		}
-		address_space->nrexceptional -= nr_shadows;
 		address_space->nrpages += nr;
 		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
 		__mod_lruvec_page_state(page, NR_SWAPCACHE, nr);
@@ -172,8 +171,6 @@ void __delete_from_swap_cache(struct pag
 		xas_next(&xas);
 	}
 	ClearPageSwapCache(page);
-	if (shadow)
-		address_space->nrexceptional += nr;
 	address_space->nrpages -= nr;
 	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
 	__mod_lruvec_page_state(page, NR_SWAPCACHE, -nr);
@@ -275,7 +272,6 @@ void clear_shadow_from_swap_cache(int ty
 			xas_store(&xas, NULL);
 			nr_shadows++;
 		}
-		address_space->nrexceptional -= nr_shadows;
 		xa_unlock_irq(&address_space->i_pages);
 
 		/* search the next swapcache until we meet end */
--- a/mm/truncate.c~mm-stop-accounting-shadow-entries
+++ a/mm/truncate.c
@@ -40,7 +40,6 @@ static inline void __clear_shadow_entry(
 	if (xas_load(&xas) != entry)
 		return;
 	xas_store(&xas, NULL);
-	mapping->nrexceptional--;
 }
 
 static void clear_shadow_entry(struct address_space *mapping, pgoff_t index,
--- a/mm/workingset.c~mm-stop-accounting-shadow-entries
+++ a/mm/workingset.c
@@ -554,7 +554,6 @@ static enum lru_status shadow_lru_isolat
 		goto out_invalid;
 	if (WARN_ON_ONCE(node->count != node->nr_values))
 		goto out_invalid;
-	mapping->nrexceptional -= node->nr_values;
 	xa_delete_node(node, workingset_update_node);
 	__inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
 
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67514C04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiI2EAX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiI2EAS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241ABAE76
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA113B8232E
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FA9C433C1;
        Thu, 29 Sep 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424014;
        bh=GRJmbUZNCpgz2SoOcgenxT13n16O549HuiVnj7p7y9g=;
        h=Date:To:From:Subject:From;
        b=RSK9IYqE3ACSL9OSUjQS7P+MBpdCkMnouiD0Ww5fvzJiNv9SqGtdoZDHEUqdKu6Qv
         bq0Ha/En0cCbhz2osRYgvXK9HsrRljYrGyPIoHy0IwFHpjjoXPb4SrFDgkyU0NtcPf
         ZN3EA+FaP+XSIXhglr7ng13CakyGAO+79cbEsaSc=
Date:   Wed, 28 Sep 2022 21:00:13 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch removed from -mm tree
Message-Id: <20220929040014.67FA9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-vmscan-fix-a-lot-of-comments-vs-mglru
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch

This patch was dropped because it was folded into mm-vmscan-fix-a-lot-of-comments.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-fix-a-lot-of-comments-vs-mglru
Date: Fri Sep  2 03:39:50 PM PDT 2022

fixups for mglru additions

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-a-lot-of-comments-vs-mglru
+++ a/mm/vmscan.c
@@ -3644,7 +3644,7 @@ static int folio_update_gen(struct folio
 	do {
 		/* lru_gen_del_folio() has isolated this page? */
 		if (!(old_flags & LRU_GEN_MASK)) {
-			/* for shrink_page_list() */
+			/* for shrink_folio_list() */
 			new_flags = old_flags | BIT(PG_referenced);
 			continue;
 		}
@@ -4571,7 +4571,7 @@ static void lru_gen_age_node(struct pgli
 }
 
 /*
- * This function exploits spatial locality when shrink_page_list() walks the
+ * This function exploits spatial locality when shrink_folio_list() walks the
  * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages. If
  * the scan was done cacheline efficiently, it adds the PMD entry pointing to
  * the PTE table to the Bloom filter. This forms a feedback loop between the
@@ -4792,7 +4792,7 @@ static bool isolate_folio(struct lruvec
 	if (!folio_test_referenced(folio))
 		set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
 
-	/* for shrink_page_list() */
+	/* for shrink_folio_list() */
 	folio_clear_reclaim(folio);
 	folio_clear_referenced(folio);
 
@@ -4995,7 +4995,7 @@ static int evict_folios(struct lruvec *l
 	if (list_empty(&list))
 		return scanned;
 
-	reclaimed = shrink_page_list(&list, pgdat, sc, &stat, false);
+	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false);
 
 	list_for_each_entry(folio, &list, lru) {
 		/* restore LRU_REFS_FLAGS cleared by isolate_folio() */
@@ -5012,7 +5012,7 @@ static int evict_folios(struct lruvec *l
 
 	spin_lock_irq(&lruvec->lru_lock);
 
-	move_pages_to_lru(lruvec, &list);
+	move_folios_to_lru(lruvec, &list);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-fix-a-lot-of-comments.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch


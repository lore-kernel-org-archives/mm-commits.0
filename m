Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94487C678DD
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 05:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjATFaH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjATF3P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 00:29:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4EE72C17
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:23:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CA1DB82754
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCF9C433EF;
        Thu, 19 Jan 2023 22:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168475;
        bh=6R+K1LRA16Pq8hqbAb34C+yytx6Pbq0uiKOXryiYWvk=;
        h=Date:To:From:Subject:From;
        b=Is9M/AzuGhXT+klrKmeDpM6hC9LD+TYvT+hY22/rb6rLpW7e3PMCrKiIhvifSSvQC
         3iuFQQtbzFO4tZDyydSSrf3LFTNsLFTThLhBwF5TWKL/GY2T0YBJG1iX3vNq69u04n
         WzABYO8mwsfj/yZ3v/CCvXa/xpWs4K2oQj9kyVr8=
Date:   Thu, 19 Jan 2023 14:47:55 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-simplify-lru_gen_look_around.patch added to mm-unstable branch
Message-Id: <20230119224755.CDCF9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: simplify lru_gen_look_around()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-simplify-lru_gen_look_around.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-simplify-lru_gen_look_around.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: simplify lru_gen_look_around()
Date: Wed, 18 Jan 2023 00:18:27 +0000

Update the folio generation in place with or without
current->reclaim_state->mm_walk.  The LRU lock is held for longer, if
mm_walk is NULL and the number of folios to update is more than
PAGEVEC_SIZE.

This causes a measurable regression from the LRU lock contention during a
microbencmark.  But a tiny regression is not worth the complexity.

Link: https://lkml.kernel.org/r/20230118001827.1040870-8-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-multi-gen-lru-simplify-lru_gen_look_around
+++ a/mm/vmscan.c
@@ -4587,13 +4587,12 @@ static void lru_gen_age_node(struct pgli
 void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
 	int i;
-	pte_t *pte;
 	unsigned long start;
 	unsigned long end;
-	unsigned long addr;
 	struct lru_gen_mm_walk *walk;
 	int young = 0;
-	unsigned long bitmap[BITS_TO_LONGS(MIN_LRU_BATCH)] = {};
+	pte_t *pte = pvmw->pte;
+	unsigned long addr = pvmw->address;
 	struct folio *folio = pfn_folio(pvmw->pfn);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
@@ -4610,25 +4609,28 @@ void lru_gen_look_around(struct page_vma
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
-	start = max(pvmw->address & PMD_MASK, pvmw->vma->vm_start);
-	end = min(pvmw->address | ~PMD_MASK, pvmw->vma->vm_end - 1) + 1;
+	start = max(addr & PMD_MASK, pvmw->vma->vm_start);
+	end = min(addr | ~PMD_MASK, pvmw->vma->vm_end - 1) + 1;
 
 	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
-		if (pvmw->address - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
+		if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
 			end = start + MIN_LRU_BATCH * PAGE_SIZE;
-		else if (end - pvmw->address < MIN_LRU_BATCH * PAGE_SIZE / 2)
+		else if (end - addr < MIN_LRU_BATCH * PAGE_SIZE / 2)
 			start = end - MIN_LRU_BATCH * PAGE_SIZE;
 		else {
-			start = pvmw->address - MIN_LRU_BATCH * PAGE_SIZE / 2;
-			end = pvmw->address + MIN_LRU_BATCH * PAGE_SIZE / 2;
+			start = addr - MIN_LRU_BATCH * PAGE_SIZE / 2;
+			end = addr + MIN_LRU_BATCH * PAGE_SIZE / 2;
 		}
 	}
 
-	pte = pvmw->pte - (pvmw->address - start) / PAGE_SIZE;
+	/* folio_update_gen() requires stable folio_memcg() */
+	if (!mem_cgroup_trylock_pages(memcg))
+		return;
 
-	rcu_read_lock();
 	arch_enter_lazy_mmu_mode();
 
+	pte -= (addr - start) / PAGE_SIZE;
+
 	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
 		unsigned long pfn;
 
@@ -4653,56 +4655,27 @@ void lru_gen_look_around(struct page_vma
 		      !folio_test_swapcache(folio)))
 			folio_mark_dirty(folio);
 
+		if (walk) {
+			old_gen = folio_update_gen(folio, new_gen);
+			if (old_gen >= 0 && old_gen != new_gen)
+				update_batch_size(walk, folio, old_gen, new_gen);
+
+			continue;
+		}
+
 		old_gen = folio_lru_gen(folio);
 		if (old_gen < 0)
 			folio_set_referenced(folio);
 		else if (old_gen != new_gen)
-			__set_bit(i, bitmap);
+			folio_activate(folio);
 	}
 
 	arch_leave_lazy_mmu_mode();
-	rcu_read_unlock();
+	mem_cgroup_unlock_pages();
 
 	/* feedback from rmap walkers to page table walkers */
 	if (suitable_to_scan(i, young))
 		update_bloom_filter(lruvec, max_seq, pvmw->pmd);
-
-	if (!walk && bitmap_weight(bitmap, MIN_LRU_BATCH) < PAGEVEC_SIZE) {
-		for_each_set_bit(i, bitmap, MIN_LRU_BATCH) {
-			folio = pfn_folio(pte_pfn(pte[i]));
-			folio_activate(folio);
-		}
-		return;
-	}
-
-	/* folio_update_gen() requires stable folio_memcg() */
-	if (!mem_cgroup_trylock_pages(memcg))
-		return;
-
-	if (!walk) {
-		spin_lock_irq(&lruvec->lru_lock);
-		new_gen = lru_gen_from_seq(lruvec->lrugen.max_seq);
-	}
-
-	for_each_set_bit(i, bitmap, MIN_LRU_BATCH) {
-		folio = pfn_folio(pte_pfn(pte[i]));
-		if (folio_memcg_rcu(folio) != memcg)
-			continue;
-
-		old_gen = folio_update_gen(folio, new_gen);
-		if (old_gen < 0 || old_gen == new_gen)
-			continue;
-
-		if (walk)
-			update_batch_size(walk, folio, old_gen, new_gen);
-		else
-			lru_gen_update_size(lruvec, folio, old_gen, new_gen);
-	}
-
-	if (!walk)
-		spin_unlock_irq(&lruvec->lru_lock);
-
-	mem_cgroup_unlock_pages();
 }
 
 /******************************************************************************
_

Patches currently in -mm which might be from talumbau@google.com are

mm-multi-gen-lru-section-for-working-set-protection.patch
mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch
mm-multi-gen-lru-section-for-bloom-filters.patch
mm-multi-gen-lru-section-for-memcg-lru.patch
mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch
mm-multi-gen-lru-improve-walk_pmd_range.patch
mm-multi-gen-lru-simplify-lru_gen_look_around.patch


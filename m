Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2023EC46467
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 23:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjASXAF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 18:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjASW7P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:59:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2510F7C866
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:47:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B650D61D78
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19128C433D2;
        Thu, 19 Jan 2023 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168474;
        bh=dBDBUMnbZXIZAIAYQg+ijcKe6Kq6cQBZ3/quPiHUefU=;
        h=Date:To:From:Subject:From;
        b=RD8m+ugzf8IdHsgQOC0Y06hYIdYwPJGBJeE+t5JUF2daC0bPFQ2rIzcZ6sYAEfAo3
         FoQ+JUvkEggAmHFecvlBMNzaceE4C0bZvtxhZBKtwuDlsJFEENyYj+E48YERn++Lvc
         qC8gSuOqg1Mj1+zkr8DHvw0XtlJE63rQPoDQaEJ0=
Date:   Thu, 19 Jan 2023 14:47:53 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-improve-walk_pmd_range.patch added to mm-unstable branch
Message-Id: <20230119224754.19128C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: improve walk_pmd_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-improve-walk_pmd_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-improve-walk_pmd_range.patch

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
Subject: mm: multi-gen LRU: improve walk_pmd_range()
Date: Wed, 18 Jan 2023 00:18:26 +0000

Improve readability of walk_pmd_range() and walk_pmd_range_locked().

Link: https://lkml.kernel.org/r/20230118001827.1040870-7-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-multi-gen-lru-improve-walk_pmd_range
+++ a/mm/vmscan.c
@@ -3999,8 +3999,8 @@ restart:
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
-static void walk_pmd_range_locked(pud_t *pud, unsigned long next, struct vm_area_struct *vma,
-				  struct mm_walk *args, unsigned long *bitmap, unsigned long *start)
+static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
+				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
 	int i;
 	pmd_t *pmd;
@@ -4013,18 +4013,19 @@ static void walk_pmd_range_locked(pud_t
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
 	/* try to batch at most 1+MIN_LRU_BATCH+1 entries */
-	if (*start == -1) {
-		*start = next;
+	if (*first == -1) {
+		*first = addr;
+		bitmap_zero(bitmap, MIN_LRU_BATCH);
 		return;
 	}
 
-	i = next == -1 ? 0 : pmd_index(next) - pmd_index(*start);
+	i = addr == -1 ? 0 : pmd_index(addr) - pmd_index(*first);
 	if (i && i <= MIN_LRU_BATCH) {
 		__set_bit(i - 1, bitmap);
 		return;
 	}
 
-	pmd = pmd_offset(pud, *start);
+	pmd = pmd_offset(pud, *first);
 
 	ptl = pmd_lockptr(args->mm, pmd);
 	if (!spin_trylock(ptl))
@@ -4035,15 +4036,16 @@ static void walk_pmd_range_locked(pud_t
 	do {
 		unsigned long pfn;
 		struct folio *folio;
-		unsigned long addr = i ? (*start & PMD_MASK) + i * PMD_SIZE : *start;
+
+		/* don't round down the first address */
+		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
 
 		pfn = get_pmd_pfn(pmd[i], vma, addr);
 		if (pfn == -1)
 			goto next;
 
 		if (!pmd_trans_huge(pmd[i])) {
-			if (arch_has_hw_nonleaf_pmd_young() &&
-			    get_cap(LRU_GEN_NONLEAF_YOUNG))
+			if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG))
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
@@ -4072,12 +4074,11 @@ next:
 	arch_leave_lazy_mmu_mode();
 	spin_unlock(ptl);
 done:
-	*start = -1;
-	bitmap_zero(bitmap, MIN_LRU_BATCH);
+	*first = -1;
 }
 #else
-static void walk_pmd_range_locked(pud_t *pud, unsigned long next, struct vm_area_struct *vma,
-				  struct mm_walk *args, unsigned long *bitmap, unsigned long *start)
+static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
+				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
 }
 #endif
@@ -4090,9 +4091,9 @@ static void walk_pmd_range(pud_t *pud, u
 	unsigned long next;
 	unsigned long addr;
 	struct vm_area_struct *vma;
-	unsigned long pos = -1;
+	unsigned long bitmap[BITS_TO_LONGS(MIN_LRU_BATCH)];
+	unsigned long first = -1;
 	struct lru_gen_mm_walk *walk = args->private;
-	unsigned long bitmap[BITS_TO_LONGS(MIN_LRU_BATCH)] = {};
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -4131,18 +4132,17 @@ restart:
 			if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
 				continue;
 
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &pos);
+			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 			continue;
 		}
 #endif
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-		if (arch_has_hw_nonleaf_pmd_young() &&
-		    get_cap(LRU_GEN_NONLEAF_YOUNG)) {
+		if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG)) {
 			if (!pmd_young(val))
 				continue;
 
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &pos);
+			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 		}
 
 		if (!walk->force_scan && !test_bloom_filter(walk->lruvec, walk->max_seq, pmd + i))
@@ -4159,7 +4159,7 @@ restart:
 		update_bloom_filter(walk->lruvec, walk->max_seq + 1, pmd + i);
 	}
 
-	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &pos);
+	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
 
 	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
_

Patches currently in -mm which might be from talumbau@google.com are

mm-multi-gen-lru-section-for-working-set-protection.patch
mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch
mm-multi-gen-lru-section-for-bloom-filters.patch
mm-multi-gen-lru-section-for-memcg-lru.patch
mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch
mm-multi-gen-lru-improve-walk_pmd_range.patch
mm-multi-gen-lru-simplify-lru_gen_look_around.patch


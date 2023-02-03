Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6005C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjBCGn3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjBCGlx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631D4FF07
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1A4061DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554A7C433EF;
        Fri,  3 Feb 2023 06:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406294;
        bh=TUzxMV1s8NaA0us6fe5sGtR9asY0XFanMm8silDFg80=;
        h=Date:To:From:Subject:From;
        b=qwQRGOnaYiPIIOYPCSGzHiL+0dO/jCipwVjndCdec0Taz9oVnI+IsEhpX7KvVGu+J
         7zI2+JhZLWwahNgauJhuDblSVDlJl37iSDH6cn0smWk/5T9JYnQPA7o78set9Mfkp3
         arNVE6azp36DjLexF6Zc/dOmS4floSCx4qN8/73U=
Date:   Thu, 02 Feb 2023 22:38:13 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-improve-walk_pmd_range.patch removed from -mm tree
Message-Id: <20230203063814.554A7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: improve walk_pmd_range()
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-improve-walk_pmd_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F7CC636F9
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 22:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiK3Wvz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 17:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiK3Wvu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 17:51:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218B091C0A
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 14:51:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF60DB81D4E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 22:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDD4C433B5;
        Wed, 30 Nov 2022 22:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848703;
        bh=v+JDlxWRcMY5Fl38euiA6AVFRpRQaynbIGpNPDcttwg=;
        h=Date:To:From:Subject:From;
        b=Ieawu+NJA914PUQyxmfeZC6jEe0D637OseVeBMQt76Ts2QtJSGrKya8GyYPcmGph9
         uVFqLQnjO7laHndsTNkKLwC9IbY1ZtBCCwIIkWwax8aKZXVHii47Vm53YTphP5jQWw
         2WYkLDcbPjXr17AyZ7PcU5R5JKYMGqv61O+WJwTI=
Date:   Wed, 30 Nov 2022 14:51:42 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        linux@eikelenboom.it, david@redhat.com, jgross@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-introduce-arch_has_hw_nonleaf_pmd_young.patch removed from -mm tree
Message-Id: <20221130225143.7FDD4C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: introduce arch_has_hw_nonleaf_pmd_young()
has been removed from the -mm tree.  Its filename was
     mm-introduce-arch_has_hw_nonleaf_pmd_young.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Juergen Gross <jgross@suse.com>
Subject: mm: introduce arch_has_hw_nonleaf_pmd_young()
Date: Wed, 23 Nov 2022 07:45:10 +0100

When running as a Xen PV guests commit eed9a328aa1a ("mm: x86: add
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG") can cause a protection violation in
pmdp_test_and_clear_young():

 BUG: unable to handle page fault for address: ffff8880083374d0
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0003) - permissions violation
 PGD 3026067 P4D 3026067 PUD 3027067 PMD 7fee5067 PTE 8010000008337065
 Oops: 0003 [#1] PREEMPT SMP NOPTI
 CPU: 7 PID: 158 Comm: kswapd0 Not tainted 6.1.0-rc5-20221118-doflr+ #1
 RIP: e030:pmdp_test_and_clear_young+0x25/0x40

This happens because the Xen hypervisor can't emulate direct writes to
page table entries other than PTEs.

This can easily be fixed by introducing arch_has_hw_nonleaf_pmd_young()
similar to arch_has_hw_pte_young() and test that instead of
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG.

Link: https://lkml.kernel.org/r/20221123064510.16225-1-jgross@suse.com
Fixes: eed9a328aa1a ("mm: x86: add CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Acked-by: Yu Zhao <yuzhao@google.com>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Acked-by: David Hildenbrand <david@redhat.com>	[core changes]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    8 ++++++++
 include/linux/pgtable.h        |   11 +++++++++++
 mm/vmscan.c                    |   10 +++++-----
 3 files changed, 24 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-introduce-arch_has_hw_nonleaf_pmd_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1439,6 +1439,14 @@ static inline bool arch_has_hw_pte_young
 	return true;
 }
 
+#ifdef CONFIG_XEN_PV
+#define arch_has_hw_nonleaf_pmd_young arch_has_hw_nonleaf_pmd_young
+static inline bool arch_has_hw_nonleaf_pmd_young(void)
+{
+	return !cpu_feature_enabled(X86_FEATURE_XENPV);
+}
+#endif
+
 #ifdef CONFIG_PAGE_TABLE_CHECK
 static inline bool pte_user_accessible_page(pte_t pte)
 {
--- a/include/linux/pgtable.h~mm-introduce-arch_has_hw_nonleaf_pmd_young
+++ a/include/linux/pgtable.h
@@ -267,6 +267,17 @@ static inline int pmdp_clear_flush_young
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
+#ifndef arch_has_hw_nonleaf_pmd_young
+/*
+ * Return whether the accessed bit in non-leaf PMD entries is supported on the
+ * local CPU.
+ */
+static inline bool arch_has_hw_nonleaf_pmd_young(void)
+{
+	return IS_ENABLED(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG);
+}
+#endif
+
 #ifndef arch_has_hw_pte_young
 /*
  * Return whether the accessed bit is supported on the local CPU.
--- a/mm/vmscan.c~mm-introduce-arch_has_hw_nonleaf_pmd_young
+++ a/mm/vmscan.c
@@ -3987,7 +3987,7 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (!pmd_trans_huge(pmd[i])) {
-			if (IS_ENABLED(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG) &&
+			if (arch_has_hw_nonleaf_pmd_young() &&
 			    get_cap(LRU_GEN_NONLEAF_YOUNG))
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
@@ -4085,14 +4085,14 @@ restart:
 #endif
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-#ifdef CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG
-		if (get_cap(LRU_GEN_NONLEAF_YOUNG)) {
+		if (arch_has_hw_nonleaf_pmd_young() &&
+		    get_cap(LRU_GEN_NONLEAF_YOUNG)) {
 			if (!pmd_young(val))
 				continue;
 
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &pos);
 		}
-#endif
+
 		if (!walk->force_scan && !test_bloom_filter(walk->lruvec, walk->max_seq, pmd + i))
 			continue;
 
@@ -5392,7 +5392,7 @@ static ssize_t show_enabled(struct kobje
 	if (arch_has_hw_pte_young() && get_cap(LRU_GEN_MM_WALK))
 		caps |= BIT(LRU_GEN_MM_WALK);
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG) && get_cap(LRU_GEN_NONLEAF_YOUNG))
+	if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG))
 		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
 
 	return snprintf(buf, PAGE_SIZE, "0x%04x\n", caps);
_

Patches currently in -mm which might be from jgross@suse.com are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1DFC7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbjFIXcI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjFIXbW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFD044BB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BE9063EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66365C433D2;
        Fri,  9 Jun 2023 23:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353348;
        bh=dE79sprVK63aqm1RwPyeVDF15PyWt8XTbZE93Iodnkc=;
        h=Date:To:From:Subject:From;
        b=iX5q64Qelck+QuP/FaJEZZHw43Umy7FxTQETu/KLj83sUkwdSmJIPJMlTgb81Y4wM
         VJl+WEclLnUtZMoIMOaoevzZrQYCRfGwgxHV9dJ3/IOx7XGiAH+3/hxihdORLxHZFs
         EKIJSmcB381/gE+iQYlXx6QsCzMwK2difTQke99Y=
Date:   Fri, 09 Jun 2023 16:29:07 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, yuanchu@google.com,
        david@redhat.com, talumbau@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-add-helpers-in-page-table-walks.patch removed from -mm tree
Message-Id: <20230609232908.66365C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: add helpers in page table walks
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-add-helpers-in-page-table-walks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: add helpers in page table walks
Date: Mon, 22 May 2023 11:20:57 +0000

Add helpers to page table walking code:
 - Clarifies intent via name "should_walk_mmu" and "should_clear_pmd_young"
 - Avoids repeating same logic in two places

Link: https://lkml.kernel.org/r/20230522112058.2965866-3-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Reviewed-by: Yuanchu Xie <yuanchu@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-add-helpers-in-page-table-walks
+++ a/mm/vmscan.c
@@ -3234,6 +3234,16 @@ DEFINE_STATIC_KEY_ARRAY_FALSE(lru_gen_ca
 #define get_cap(cap)	static_branch_unlikely(&lru_gen_caps[cap])
 #endif
 
+static bool should_walk_mmu(void)
+{
+	return arch_has_hw_pte_young() && get_cap(LRU_GEN_MM_WALK);
+}
+
+static bool should_clear_pmd_young(void)
+{
+	return arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG);
+}
+
 /******************************************************************************
  *                          shorthand helpers
  ******************************************************************************/
@@ -4098,7 +4108,7 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (!pmd_trans_huge(pmd[i])) {
-			if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG))
+			if (should_clear_pmd_young())
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
@@ -4191,7 +4201,7 @@ restart:
 #endif
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-		if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG)) {
+		if (should_clear_pmd_young()) {
 			if (!pmd_young(val))
 				continue;
 
@@ -4493,7 +4503,7 @@ static bool try_to_inc_max_seq(struct lr
 	 * handful of PTEs. Spreading the work out over a period of time usually
 	 * is less efficient, but it avoids bursty page faults.
 	 */
-	if (!arch_has_hw_pte_young() || !get_cap(LRU_GEN_MM_WALK)) {
+	if (!should_walk_mmu()) {
 		success = iterate_mm_list_nowalk(lruvec, max_seq);
 		goto done;
 	}
@@ -5730,10 +5740,10 @@ static ssize_t enabled_show(struct kobje
 	if (get_cap(LRU_GEN_CORE))
 		caps |= BIT(LRU_GEN_CORE);
 
-	if (arch_has_hw_pte_young() && get_cap(LRU_GEN_MM_WALK))
+	if (should_walk_mmu())
 		caps |= BIT(LRU_GEN_MM_WALK);
 
-	if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG))
+	if (should_clear_pmd_young())
 		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
 
 	return sysfs_emit(buf, "0x%04x\n", caps);
_

Patches currently in -mm which might be from talumbau@google.com are



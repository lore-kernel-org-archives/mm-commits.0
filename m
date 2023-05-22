Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC54FC77B75
	for <mm-commits@archiver.kernel.org>; Mon, 22 May 2023 20:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjEVUsR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 May 2023 16:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbjEVUsQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2023 16:48:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3694294
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 13:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C067F62282
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 20:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BBAC433D2;
        Mon, 22 May 2023 20:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684788491;
        bh=XRN9D/GHqH98SKtYz9+VTSPSefjkvIqCmqleu3Sfyd4=;
        h=Date:To:From:Subject:From;
        b=mYpLFKnPg1wf2d0BVt8PiqGGZ24wrAAmzrCa74njImy2uzLa9V3zC67AtM21vEAC8
         cQ61YtE2MS5fbuh4YE4X/M0xqAQ+ZPMWjnBTd1IqGe2ELf7POWUr3GB4mbH07RiaOa
         j7ZrEeoLAIx8ycSPt/MKeTodLKxreac2Cnco9uLo=
Date:   Mon, 22 May 2023 13:48:10 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, yuanchu@google.com,
        david@redhat.com, talumbau@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-add-helpers-in-page-table-walks.patch added to mm-unstable branch
Message-Id: <20230522204811.24BBAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: add helpers in page table walks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-add-helpers-in-page-table-walks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-add-helpers-in-page-table-walks.patch

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
Subject: mm: multi-gen LRU: add helpers in page table walks
Date: Mon, 22 May 2023 11:20:57 +0000

Add helpers to page table walking code:
 - Clarifies intent via name "should_walk_mmu" and "should_clear_pmd_young"
 - Avoids repeating same logic in two places

Link: https://lkml.kernel.org/r/20230522112058.2965866-3-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yuanchu Xie <yuanchu@google.com>
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

mm-multi-gen-lru-use-macro-for-bitmap.patch
mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim.patch
mm-multi-gen-lru-add-helpers-in-page-table-walks.patch
mm-multi-gen-lru-cleanup-lru_gen_test_recent.patch


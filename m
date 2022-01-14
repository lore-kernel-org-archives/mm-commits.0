Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790B6C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiANVij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:38:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59492 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiANVii (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:38:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B8FE61FB5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD707C36AE9;
        Fri, 14 Jan 2022 21:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642196318;
        bh=E6j5EBLx34lh+Wmbf2uzeV3iOasybTW8qkQ7p9Yd6p8=;
        h=Date:From:To:Subject:From;
        b=bvLiCa2YzotZFqUUOL6jWcqSP8wvHZhInM/L8QFq8PK+Q2ktR3R/u1/5Zpw8RrIKC
         Dl+5QH2Lse6Dml/3DNJznDo1m2X2NPaya2LKN5AiJcv8xZad70ievlSfN2rbeC3Ppr
         g1S2zOUKTsg4NayBZ4Arp4QiazF05CT+E3XEpWi4=
Date:   Fri, 14 Jan 2022 13:38:37 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        sfr@canb.auug.org.au, sj@kernel.org
Subject:  [folded-merged]
 mm-damon-add-access-checking-for-hugetlb-pages-v3.patch removed from -mm
 tree
Message-ID: <20220114213837.xR0SVBpzA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-add-access-checking-for-hugetlb-pages-v3
has been removed from the -mm tree.  Its filename was
     mm-damon-add-access-checking-for-hugetlb-pages-v3.patch

This patch was dropped because it was folded into mm-damon-add-access-checking-for-hugetlb-pages.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-damon-add-access-checking-for-hugetlb-pages-v3

Link: https://lkml.kernel.org/r/486927ecaaaecf2e3a7fbe0378ec6e1c58b50747.1640852276.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-add-access-checking-for-hugetlb-pages-v3
+++ a/mm/damon/vaddr.c
@@ -409,7 +409,8 @@ static void damon_hugetlb_mkold(pte_t *p
 	}
 
 #ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(mm, addr, addr + huge_page_size(hstate_vma(vma))))
+	if (mmu_notifier_clear_young(mm, addr,
+				     addr + huge_page_size(hstate_vma(vma))))
 		referenced = true;
 #endif /* CONFIG_MMU_NOTIFIER */
 
@@ -441,7 +442,7 @@ out:
 }
 #else
 #define damon_mkold_hugetlb_entry NULL
-#endif
+#endif /* CONFIG_HUGETLB_PAGE */
 
 static const struct mm_walk_ops damon_mkold_ops = {
 	.pmd_entry = damon_mkold_pmd_entry,
@@ -576,7 +577,7 @@ out:
 }
 #else
 #define damon_young_hugetlb_entry NULL
-#endif
+#endif /* CONFIG_HUGETLB_PAGE */
 
 static const struct mm_walk_ops damon_young_ops = {
 	.pmd_entry = damon_young_pmd_entry,
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-the-return-value-of-migrate_pages.patch
mm-migrate-correct-the-hugetlb-migration-stats.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch
mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch
mm-damon-add-access-checking-for-hugetlb-pages.patch


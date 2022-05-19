Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A755EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245312AbiESW0b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245529AbiESW0O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:26:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2CF36B53
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:26:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 58E76CE282C
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B22C385AA;
        Thu, 19 May 2022 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999164;
        bh=/RJMxNDv1MCqszLBsLRWseXkxZ55VbyqeVeyiO1i8X8=;
        h=Date:To:From:Subject:From;
        b=YVsMV0Yow7MJdAxE3aUdQiemUeJChAgSBG4vSm3luHbraLiujH59Vpoam3+fLJqgN
         ndheRpVXFXe6eoUZg1KzOFE4OSGA6hb28sVviBTkZiXwlwpPWETnITST7rGiDB3qi7
         rhKa9Wyzb1z5bN90xhvQIuuazcaMDppa1KNqBHWA=
Date:   Thu, 19 May 2022 15:26:04 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-use-hpage_pmd_size.patch removed from -mm tree
Message-Id: <20220519222604.B5B22C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: damon: use HPAGE_PMD_SIZE
has been removed from the -mm tree.  Its filename was
     mm-damon-use-hpage_pmd_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: damon: use HPAGE_PMD_SIZE
Date: Tue, 17 May 2022 22:51:20 +0800

Use HPAGE_PMD_SIZE instead of open coding.

Link: https://lkml.kernel.org/r/20220517145120.118523-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    3 +--
 mm/damon/paddr.c      |    2 +-
 mm/damon/vaddr.c      |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-use-hpage_pmd_size
+++ a/mm/damon/ops-common.c
@@ -73,8 +73,7 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 	}
 
 #ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(mm, addr,
-				addr + ((1UL) << HPAGE_PMD_SHIFT)))
+	if (mmu_notifier_clear_young(mm, addr, addr + HPAGE_PMD_SIZE))
 		referenced = true;
 #endif /* CONFIG_MMU_NOTIFIER */
 
--- a/mm/damon/paddr.c~mm-damon-use-hpage_pmd_size
+++ a/mm/damon/paddr.c
@@ -106,7 +106,7 @@ static bool __damon_pa_young(struct foli
 			result->accessed = pmd_young(*pvmw.pmd) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
-			result->page_sz = ((1UL) << HPAGE_PMD_SHIFT);
+			result->page_sz = HPAGE_PMD_SIZE;
 #else
 			WARN_ON_ONCE(1);
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
--- a/mm/damon/vaddr.c~mm-damon-use-hpage_pmd_size
+++ a/mm/damon/vaddr.c
@@ -442,7 +442,7 @@ static int damon_young_pmd_entry(pmd_t *
 		if (pmd_young(*pmd) || !page_is_idle(page) ||
 					mmu_notifier_test_young(walk->mm,
 						addr)) {
-			*priv->page_sz = ((1UL) << HPAGE_PMD_SHIFT);
+			*priv->page_sz = HPAGE_PMD_SIZE;
 			priv->young = true;
 		}
 		put_page(page);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are



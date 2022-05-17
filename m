Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76441C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 18:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242864AbiEQSs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 14:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345464AbiEQSs0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 14:48:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3369641FBA
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 11:48:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAE5F615F1
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 18:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E743CC385B8;
        Tue, 17 May 2022 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652813304;
        bh=kQHDK0oP88nP144tLCc8arzXDnAbdt98G1T14LOQaVQ=;
        h=Date:To:From:Subject:From;
        b=k3uDsgUlpUlE6bW+rXvisvKXyCWI/iEYkRcIcslz+jNF7gjmAYL8+hNZcx6j43BAg
         WGuwpkqhhR1WtBbHaaH6061RKHgKLnz+tNthce8/REahBeArQAqqWRp5S629900dL9
         uDlKh2dRdbJe7kxELzlbfcAq1Fp+dBsVmFDxAW5E=
Date:   Tue, 17 May 2022 11:48:23 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-use-hpage_pmd_size.patch added to mm-unstable branch
Message-Id: <20220517184823.E743CC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: damon: use HPAGE_PMD_SIZE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-use-hpage_pmd_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-use-hpage_pmd_size.patch

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
@@ -443,7 +443,7 @@ static int damon_young_pmd_entry(pmd_t *
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

mm-damon-use-hpage_pmd_size.patch


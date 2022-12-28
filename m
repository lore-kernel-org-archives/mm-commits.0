Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2C2C5479D
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 22:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiL1WKt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 17:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiL1WKF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 17:10:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50208167FD
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 14:09:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 642566163C
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 22:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA269C433EF;
        Wed, 28 Dec 2022 22:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672265386;
        bh=mUAamFsEpvxptaEIBxkIAFCOz2E85wVOiMJTSmCmmHE=;
        h=Date:To:From:Subject:From;
        b=IxPtG32FNb+NhkgBnAeBUcVBPTPNe98WbSXWUi36KIYOz93EBEIiEYpmcevQPMw/o
         iT31UDbOHzj8NnJ/+2+1Gusq0HRY4g6gguJCf1hL90mK9+9wDeX17VE7jMtUP6jv51
         NWFTnunau0h5y/WAUfhmCdvq4rlNEJRSLAO8xGUg=
Date:   Wed, 28 Dec 2022 14:09:45 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-unneed-damon_get_page.patch added to mm-unstable branch
Message-Id: <20221228220946.BA269C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove unneeded damon_get_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-remove-unneed-damon_get_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-unneed-damon_get_page.patch

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
Subject: mm/damon: remove unneeded damon_get_page()
Date: Wed, 28 Dec 2022 19:34:12 +0800

After all damon_get_page() callers are converted to damon_get_folio(),
remove unneeded wrapper damon_get_page().

Link: https://lkml.kernel.org/r/20221228113413.10329-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/ops-common.h~mm-damon-remove-unneed-damon_get_page
+++ a/mm/damon/ops-common.h
@@ -8,13 +8,6 @@
 #include <linux/damon.h>
 
 struct folio *damon_get_folio(unsigned long pfn);
-static inline struct page *damon_get_page(unsigned long pfn)
-{
-	struct folio *folio = damon_get_folio(pfn);
-
-	/* when folio is NULL, return &(0->page) mean return NULL */
-	return &folio->page;
-}
 
 void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch
mm-page_idle-convert-page-idle-to-use-folios.patch
mm-damon-introduce-damon_get_folio.patch
mm-damon-convert-damon_ptep-pmdp_mkold-to-use-folios.patch
mm-damon-paddr-convert-damon_pa_-to-use-folios.patch
mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-folio.patch
mm-damon-remove-unneed-damon_get_page.patch
mm-damon-vaddr-convert-hugetlb-related-function-to-use-folios.patch


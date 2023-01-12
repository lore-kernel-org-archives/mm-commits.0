Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C00C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbjALVvi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbjALVtg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:49:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A672646E
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:44:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8FB462122
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08470C43398;
        Thu, 12 Jan 2023 21:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673559840;
        bh=LYlROkWzoDdzxA+E0fH9c8jkmJJ6TrE8dNd/iknf3XE=;
        h=Date:To:From:Subject:From;
        b=fY+8n+3GMinOwJGn1R499XCbyYr62Ro8Y3dUBJjjsrYuaL7ODmuwJgGg6y1R5xAKY
         Em/tioJN3CoEt9e7XsI5fMTltScwjXGDJjjw4DfUdeEgIuZSDARhBfyxXwdQobSMFH
         DoHeRscvHUQMxVeZae3iKPW6ksoTg38AVFGFb/hI=
Date:   Thu, 12 Jan 2023 13:43:59 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch added to mm-unstable branch
Message-Id: <20230112214400.08470C43398@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: madvise: use vm_normal_folio() in madvise_free_pte_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

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
Subject: mm: madvise: use vm_normal_folio() in madvise_free_pte_range()
Date: Thu, 12 Jan 2023 20:40:28 +0800

There is already a vm_normal_folio(), use it to make
madvise_free_pte_range() only use a folio.

Link: https://lkml.kernel.org/r/20230112124028.16964-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range
+++ a/mm/madvise.c
@@ -617,7 +617,6 @@ static int madvise_free_pte_range(pmd_t
 	spinlock_t *ptl;
 	pte_t *orig_pte, *pte, ptent;
 	struct folio *folio;
-	struct page *page;
 	int nr_swap = 0;
 	unsigned long next;
 
@@ -658,10 +657,9 @@ static int madvise_free_pte_range(pmd_t
 			continue;
 		}
 
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page || is_zone_device_page(page))
+		folio = vm_normal_folio(vma, addr, ptent);
+		if (!folio || folio_is_zone_device(folio))
 			continue;
-		folio = page_folio(page);
 
 		/*
 		 * If pmd isn't transhuge but the folio is large and
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch
mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch
mm-page_idle-convert-page-idle-to-use-a-folio.patch
mm-damon-introduce-damon_get_folio.patch
mm-damon-convert-damon_ptep-pmdp_mkold-to-use-a-folio.patch
mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch
mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-a-folio.patch
mm-damon-remove-unneeded-damon_get_page.patch
mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch


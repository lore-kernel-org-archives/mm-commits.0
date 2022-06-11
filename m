Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6120DC43334
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 21:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiFKVLS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 17:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiFKVLS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 17:11:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF59C50004
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 14:11:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A08F5B801BD
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 21:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF20C34116;
        Sat, 11 Jun 2022 21:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654981874;
        bh=esJuiZV/YMsp7wgDfkrbGjLDgsna28gxTrTs0cg2SWQ=;
        h=Date:To:From:Subject:From;
        b=TxIPplA5E93TWAICRhYcyXrt9w4U4B2LbZlLHnVytEOV+TzyAgMMLl6wToNxxgzI6
         Y/2xi5q3T2TUFsd4hcabXkqAeikHoH4nuY+5r+k6yOgfL4N2ubwyom1m6bd6g3i0ei
         oiWc2+VUlMWFFDI5o2Etux/ZZWor1e9USd2VH1gA=
Date:   Sat, 11 Jun 2022 14:11:13 -0700
To:     mm-commits@vger.kernel.org, joao.m.martins@oracle.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch added to mm-unstable branch
Message-Id: <20220611211114.4DF20C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: minor clean up for memmap_init_compound()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: minor clean up for memmap_init_compound()
Date: Sat, 11 Jun 2022 10:13:52 +0800

Since commit 5232c63f46fd ("mm: Make compound_pincount always available"),
compound_pincount_ptr is stored at first tail page now.  So we should call
prep_compound_head() after the first tail page is initialized to take
advantage of the likelihood of that tail struct page being cached given
that we will read them right after in prep_compound_head().

Link: https://lkml.kernel.org/r/20220611021352.13529-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-minor-clean-up-for-memmap_init_compound
+++ a/mm/page_alloc.c
@@ -6771,13 +6771,18 @@ static void __ref memmap_init_compound(s
 		set_page_count(page, 0);
 
 		/*
-		 * The first tail page stores compound_mapcount_ptr() and
-		 * compound_order() and the second tail page stores
-		 * compound_pincount_ptr(). Call prep_compound_head() after
-		 * the first and second tail pages have been initialized to
-		 * not have the data overwritten.
+		 * The first tail page stores compound_mapcount_ptr(),
+		 * compound_order() and compound_pincount_ptr(). Call
+		 * prep_compound_head() after the first tail page have
+		 * been initialized to not have the data overwritten.
+		 *
+		 * Note the idea to make this right after we initialize
+		 * the offending tail pages is trying to take advantage
+		 * of the likelihood of those tail struct pages being
+		 * cached given that we will read them right after in
+		 * prep_compound_head().
 		 */
-		if (pfn == head_pfn + 2)
+		if (unlikely(pfn == head_pfn + 1))
 			prep_compound_head(head, order);
 	}
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
lib-test_hmm-avoid-accessing-uninitialized-pages.patch
mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch


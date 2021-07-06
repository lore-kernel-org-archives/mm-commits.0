Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB82BC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F5D561C72
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhGFTNd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhGFTNc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF46861C74;
        Tue,  6 Jul 2021 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598653;
        bh=QcpLNN9WA/8GQUXjMN+AObX2ULtOGjYDjSazRKrTnAQ=;
        h=Date:From:To:Subject:From;
        b=wRvI0UxsZd1gGZzyzqRLafZwvmX1R4YcHpzK0UvAa8IeRYLp+fvP3G00dubZkF3Fr
         ZXWVFa93+lznFD5YOz8XE+48ZFfo1OgJM9pmlwWhvHsmlxKuZLMb0ENJkIse516ity
         sg+jIjcpo3ZAns8piL/+b+EcagAZngX6Fv15nBNI=
Date:   Tue, 06 Jul 2021 12:10:52 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, david@redhat.com, dennis@kernel.org,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        linmiaohe@huawei.com, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shy828301@gmail.com, tim.c.chen@linux.intel.com,
        willy@infradead.org, ying.huang@intel.com, yuzhao@google.com
Subject:  [merged]
 mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
 removed from -mm tree
Message-ID: <20210706191052.79z7mPQZ_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: remove confusing checking for non_swap_entry() in swap_ra_info()
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: remove confusing checking for non_swap_entry() in swap_ra_info()

The non_swap_entry() was used for working with VMA based swap readahead
via commit ec560175c0b6 ("mm, swap: VMA based swap readahead").  At that
time, the non_swap_entry() checking is necessary because the function is
called before checking that in do_swap_page().  Then it's moved to
swap_ra_info() since commit eaf649ebc3ac ("mm: swap: clean up swap
readahead").  After that, the non_swap_entry() checking is unnecessary,
because swap_ra_info() is called after non_swap_entry() has been checked
already.  The resulting code is confusing as the non_swap_entry() check
looks racy now because while we released the pte lock, somebody else might
have faulted in this pte.  So we should check whether it's swap pte first
to guard against such race or swap_type will be unexpected.  But the race
isn't important because it will not cause problem.  We would have enough
checking when we really operate the PTE entries later.  So we remove the
non_swap_entry() check here to avoid confusion.

Link: https://lkml.kernel.org/r/20210426123316.806267-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/swap_state.c~mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info
+++ a/mm/swap_state.c
@@ -721,7 +721,6 @@ static void swap_ra_info(struct vm_fault
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long ra_val;
-	swp_entry_t entry;
 	unsigned long faddr, pfn, fpfn;
 	unsigned long start, end;
 	pte_t *pte, *orig_pte;
@@ -739,11 +738,6 @@ static void swap_ra_info(struct vm_fault
 
 	faddr = vmf->address;
 	orig_pte = pte = pte_offset_map(vmf->pmd, faddr);
-	entry = pte_to_swp_entry(*pte);
-	if ((unlikely(non_swap_entry(entry)))) {
-		pte_unmap(orig_pte);
-		return;
-	}
 
 	fpfn = PFN_DOWN(faddr);
 	ra_val = GET_SWAP_RA_VAL(vma);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch


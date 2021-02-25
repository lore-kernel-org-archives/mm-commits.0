Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EE5C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8CE64F47
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhBYT2O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:28:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234282AbhBYTZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7C5164F75;
        Thu, 25 Feb 2021 19:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280500;
        bh=y9APxILmMMp7nfbHo6oErLLZIfXHt7HszSSKR1QOnmU=;
        h=Date:From:To:Subject:From;
        b=GiRnnUEvle0rO1kXgVmMdeVz5BqGonh8lb7MyE9HatoaSEzRN6V57e1McjVIAAm9b
         wtfYvVTeujnS797afkR4ZicbVF7sepD6+MvaWz8Nflv3GTZ3T5LFdLVn5SabekxIak
         EPKP9xV0zw3eFRkTGSMMzEFJly6Fj2+ix9dTUTsk=
Date:   Thu, 25 Feb 2021 11:14:59 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chrisw@sous-sol.org,
        ian.pratt@xensource.com, linmiaohe@huawei.com, mingo@elte.hu,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-memoryc-fix-potential-pte_unmap_unlock-pte-error.patch removed from -mm
 tree
Message-ID: <20210225191459.er9D43bm0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix potential pte_unmap_unlock pte error
has been removed from the -mm tree.  Its filename was
     mm-memoryc-fix-potential-pte_unmap_unlock-pte-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory.c: fix potential pte_unmap_unlock pte error

If all pte entry is none in 'non-create' case, we would break the loop with
pte unchanged.  Then the wrong pte - 1 would be passed to pte_unmap_unlock.
This is a theoretical issue which may not be a real bug. So it's not worth
cc stable.

Link: https://lkml.kernel.org/r/20210205081925.59809-1-linmiaohe@huawei.com
Fixes: aee16b3cee27 ("Add apply_to_page_range() which applies a function to a pte range")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ian Pratt <ian.pratt@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memoryc-fix-potential-pte_unmap_unlock-pte-error
+++ a/mm/memory.c
@@ -2394,18 +2394,18 @@ static int apply_to_pte_range(struct mm_
 				     pte_fn_t fn, void *data, bool create,
 				     pgtbl_mod_mask *mask)
 {
-	pte_t *pte;
+	pte_t *pte, *mapped_pte;
 	int err = 0;
 	spinlock_t *ptl;
 
 	if (create) {
-		pte = (mm == &init_mm) ?
+		mapped_pte = pte = (mm == &init_mm) ?
 			pte_alloc_kernel_track(pmd, addr, mask) :
 			pte_alloc_map_lock(mm, pmd, addr, &ptl);
 		if (!pte)
 			return -ENOMEM;
 	} else {
-		pte = (mm == &init_mm) ?
+		mapped_pte = pte = (mm == &init_mm) ?
 			pte_offset_kernel(pmd, addr) :
 			pte_offset_map_lock(mm, pmd, addr, &ptl);
 	}
@@ -2428,7 +2428,7 @@ static int apply_to_pte_range(struct mm_
 	arch_leave_lazy_mmu_mode();
 
 	if (mm != &init_mm)
-		pte_unmap_unlock(pte-1, ptl);
+		pte_unmap_unlock(mapped_pte, ptl);
 	return err;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch


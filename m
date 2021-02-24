Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA21DC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37E364F25
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbhBXUGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234718AbhBXUFy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A1D164F29;
        Wed, 24 Feb 2021 20:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197083;
        bh=AkQdFROiB4kD2nW5q7VH4tUqdd3BV6k+AP0uR4ayswc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e9XDXRGhwP0WHk4ljHoV9sgAL1d2A9TvarTG13j1TYLoItgmwP50tMTRsdD7dPFwz
         0g68dzJRBvX+iBTeOjS4tEIqW5rFT5YdvDhCxEdOkVE28KFzNb5g/JQvOeOkieTSKP
         Rn3xyBqUPXSrIO0o/XOfUCkQQW8IJNRaUtOF4wKI=
Date:   Wed, 24 Feb 2021 12:04:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chrisw@sous-sol.org,
        ian.pratt@xensource.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mingo@elte.hu, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 080/173] mm/memory.c: fix potential
 pte_unmap_unlock pte error
Message-ID: <20210224200442.Apg5eElaa%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB099C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C0A60F12
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347955AbhIBV70 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347683AbhIBV7V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3D1A60F12;
        Thu,  2 Sep 2021 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619903;
        bh=S9YjKxtcJFESm+xz/VkwLPcKBtuPlNLYGpGGjWla9lI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jGlyty/uJFPiSMPsB3BRC91dq954gfb52FkhchjAYskY2G5QGjvI9IQDm++V9/YiK
         RfxORc8zPKt2aP3HbFhZnOZVzFoCZ7UuGf7aFMxVpVFqxvh068jxTDop/e9cHZ90Qa
         +e5dIgYLq3Sjscm7DF8mqBRQKreuyKO1zloIC4gU=
Date:   Thu, 02 Sep 2021 14:58:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, torvalds@linux-foundation.org
Subject:  [patch 159/212] mm/hwpoison: fix potential
 pte_unmap_unlock pte error
Message-ID: <20210902215822.jKdOK27-5%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison: fix potential pte_unmap_unlock pte error

If the first pte is equal to poisoned_pfn, i.e.  check_hwpoisoned_entry()
return 1, the wrong ptep - 1 would be passed to pte_unmap_unlock().

Link: https://lkml.kernel.org/r/20210814105131.48814-3-linmiaohe@huawei.com
Fixes: ad9c59c24095 ("mm,hwpoison: send SIGBUS with error virutal address")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error
+++ a/mm/memory-failure.c
@@ -632,7 +632,7 @@ static int hwpoison_pte_range(pmd_t *pmd
 {
 	struct hwp_walk *hwp = (struct hwp_walk *)walk->private;
 	int ret = 0;
-	pte_t *ptep;
+	pte_t *ptep, *mapped_pte;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmdp, walk->vma);
@@ -645,14 +645,15 @@ static int hwpoison_pte_range(pmd_t *pmd
 	if (pmd_trans_unstable(pmdp))
 		goto out;
 
-	ptep = pte_offset_map_lock(walk->vma->vm_mm, pmdp, addr, &ptl);
+	mapped_pte = ptep = pte_offset_map_lock(walk->vma->vm_mm, pmdp,
+						addr, &ptl);
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		ret = check_hwpoisoned_entry(*ptep, addr, PAGE_SHIFT,
 					     hwp->pfn, &hwp->tk);
 		if (ret == 1)
 			break;
 	}
-	pte_unmap_unlock(ptep - 1, ptl);
+	pte_unmap_unlock(mapped_pte, ptl);
 out:
 	cond_resched();
 	return ret;
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74AD1C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56D626112E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhICVAu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350172AbhICVAr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8510E61131;
        Fri,  3 Sep 2021 20:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702787;
        bh=y5WqSshU0uz8bO01FJYecZzPYYm4mq7KRY0Q1uaEFWg=;
        h=Date:From:To:Subject:From;
        b=jP9azO6HdXawG73mIZ4f71vYCY35SzYGdvJ/6u07DrTiAz12KX6FGrFxEKUv3AbcP
         bhJJuJofwtjhxIEuAL+5vgX13hFA6lIN8DO2n+1tF4tv+ZjpBxuljMJJ06LkjnWFqc
         qEUyOK4nFnaIKKT711YsL4ZB1QNN1oHZiFyZ2QBE=
Date:   Fri, 03 Sep 2021 13:59:47 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com
Subject:  [merged]
 mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch removed from -mm
 tree
Message-ID: <20210903205947.qAR1ijYPu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix potential pte_unmap_unlock pte error
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch


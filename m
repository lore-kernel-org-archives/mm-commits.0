Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C7CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B36EF6125F
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345255AbhIXWpj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345479AbhIXWph (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8D9161250;
        Fri, 24 Sep 2021 22:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523444;
        bh=V8C691MMOp/rWW4+HTIKqi0ephg0nY4mpRWWs4qB8yU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t0pPPTwOGRfVJfY9ZeLSWafgvszfjIcAFXKPmMCCzkWppoQG2y4UQpT6I5B9SDHMy
         6PG+IViX3Q5SWW/lgsS5pLzqwW1y/zxJTGYSW5IHNVo//1rHt04VObA3uQOHS9pEWk
         N73QTqP4J98M/Mh1JzxArVlJWKllh7H+VEy5SNMI=
Date:   Fri, 24 Sep 2021 15:44:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        zhengqi.arch@bytedance.com
Subject:  [patch 15/16] mm/memory_failure: fix the missing
 pte_unmap() call
Message-ID: <20210924224403.3ZN1b5z2V%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm/memory_failure: fix the missing pte_unmap() call

The paired pte_unmap() call is missing before the
dev_pagemap_mapping_shift() returns.  So fix it.

Davidsaid "I guess this code never runs on 32bit / highmem, that's why we
didn't notice so far".

[akpm@linux-foundation.org: cleanup]
Link: https://lkml.kernel.org/r/20210923122642.4999-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-fix-the-missing-pte_unmap-call
+++ a/mm/memory-failure.c
@@ -306,6 +306,7 @@ static unsigned long dev_pagemap_mapping
 		struct vm_area_struct *vma)
 {
 	unsigned long address = vma_address(page, vma);
+	unsigned long ret = 0;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -329,11 +330,10 @@ static unsigned long dev_pagemap_mapping
 	if (pmd_devmap(*pmd))
 		return PMD_SHIFT;
 	pte = pte_offset_map(pmd, address);
-	if (!pte_present(*pte))
-		return 0;
-	if (pte_devmap(*pte))
-		return PAGE_SHIFT;
-	return 0;
+	if (pte_present(*pte) && pte_devmap(*pte))
+		ret = PAGE_SHIFT;
+	pte_unmap(pte);
+	return ret;
 }
 
 /*
_

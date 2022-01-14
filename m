Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333B6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiANVih (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:38:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiANVih (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:38:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 433CD61FB5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6405AC36AE9;
        Fri, 14 Jan 2022 21:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642196315;
        bh=2MkR1eGRRXzcJ91pAYU1X5wbooMwd2O5dEkzzqMf31k=;
        h=Date:From:To:Subject:From;
        b=vWznzRgYlADD4IDeqrxokBvvAxo3b3iWMmne745uQyDfOG6aNCGFmGcuWqy6AVL0w
         TtWO6kwQM937WFmhpARfqXfEa1/9wsBfe5bdA2uZ40MIHd1yLsRjydU0554sNgWBp3
         D2PnISXFZcjlDOLU8nM31/I+KotUkMjBkIZewL7k=
Date:   Fri, 14 Jan 2022 13:38:34 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        sfr@canb.auug.org.au, sj@kernel.org
Subject:  [folded-merged]
 mm-damon-add-access-checking-for-hugetlb-pages-fix.patch removed from -mm
 tree
Message-ID: <20220114213834.43ax_jODZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-add-access-checking-for-hugetlb-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-add-access-checking-for-hugetlb-pages-fix.patch

This patch was dropped because it was folded into mm-damon-add-access-checking-for-hugetlb-pages.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-damon-add-access-checking-for-hugetlb-pages-fix

> On i386:
>
> ../mm/damon/vaddr.c: In function `damon_hugetlb_mkold':
> ../mm/damon/vaddr.c:402:17: warning: unused variable `h' [-Wunused-variable]
>    struct hstate *h = hstate_vma(vma);

Link: https://lkml.kernel.org/r/1aaf9c11-0d8e-b92d-5c92-46e50a6e8d4e@linux.alibaba.com
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-add-access-checking-for-hugetlb-pages-fix
+++ a/mm/damon/vaddr.c
@@ -393,7 +393,6 @@ static void damon_hugetlb_mkold(pte_t *p
 				struct vm_area_struct *vma, unsigned long addr)
 {
 	bool referenced = false;
-	struct hstate *h = hstate_vma(vma);
 	pte_t entry = huge_ptep_get(pte);
 	struct page *page = pte_page(entry);
 
@@ -410,7 +409,7 @@ static void damon_hugetlb_mkold(pte_t *p
 	}
 
 #ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(mm, addr, addr + huge_page_size(h)))
+	if (mmu_notifier_clear_young(mm, addr, addr + huge_page_size(hstate_vma(vma))))
 		referenced = true;
 #endif /* CONFIG_MMU_NOTIFIER */
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-the-return-value-of-migrate_pages.patch
mm-migrate-correct-the-hugetlb-migration-stats.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch
mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch
mm-damon-add-access-checking-for-hugetlb-pages.patch
mm-damon-add-access-checking-for-hugetlb-pages-v3.patch


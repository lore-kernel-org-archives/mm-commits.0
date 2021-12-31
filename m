Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FE0C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Dec 2021 02:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbhLaCPg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Dec 2021 21:15:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57260 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhLaCPg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Dec 2021 21:15:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A559661767
        for <mm-commits@vger.kernel.org>; Fri, 31 Dec 2021 02:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7706C36AE7;
        Fri, 31 Dec 2021 02:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640916935;
        bh=gXZBppzeT9SQDdSG+kKwwYe+6I522fKFkN3vHDp983I=;
        h=Date:From:To:Subject:From;
        b=jgQKt7ovRT6bws1a+C9k/ZxQR+8CDATsc5OJGPhgRcsEAv7oUrxcojXGJD1UwxdNS
         NZPxEbD3yXD2RTcROknFOhOQOsu1UJKe8xwsJgpmVwdDT0Wfb+9742k476Ta6702uD
         WeKNItApK2h44fioYRWwP4puaxC6+QT8Y6L8Q6Zo=
Date:   Thu, 30 Dec 2021 18:15:34 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, baolin.wang@linux.alibaba.com
Subject:  + mm-damon-add-access-checking-for-hugetlb-pages-fix.patch
 added to -mm tree
Message-ID: <20211231021534.IkjJJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-add-access-checking-for-hugetlb-pages-fix
has been added to the -mm tree.  Its filename is
     mm-damon-add-access-checking-for-hugetlb-pages-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-add-access-checking-for-hugetlb-pages-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-add-access-checking-for-hugetlb-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-migrate-correct-the-hugetlb-migration-stats-fix.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch
mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch
mm-damon-add-access-checking-for-hugetlb-pages.patch
mm-damon-add-access-checking-for-hugetlb-pages-fix.patch


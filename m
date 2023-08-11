Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED083C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbjHKXAv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236764AbjHKW7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509A1268C;
        Fri, 11 Aug 2023 15:59:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA2E96492A;
        Fri, 11 Aug 2023 22:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3BBC433C8;
        Fri, 11 Aug 2023 22:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794780;
        bh=lftnlXyXqDouZySCb+ce6E6EBUqsUCZVDnbRpIZvy+k=;
        h=Date:To:From:Subject:From;
        b=bmSeA3gCJwYOyiAgM/srtJ/lTs6Oypk+Qk/2sBV/Avxi+Cf4I3skdLha2Ntm66dqa
         gm3+Z5DBEqe5oOaOE2lutvyKT+ET4MxdszVAwWZTEdXRjKz7e4H7viLkutFsLWQQ+r
         x0HmWIKYwF1x+rxyGgBwFrmLXumg9cYQLbHyKSH0=
Date:   Fri, 11 Aug 2023 15:59:39 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-fix-a-race-between-vmemmap-pmd-split.patch removed from -mm tree
Message-Id: <20230811225940.3E3BBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: fix a race between vmemmap pmd split
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-fix-a-race-between-vmemmap-pmd-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: fix a race between vmemmap pmd split
Date: Fri, 7 Jul 2023 11:38:59 +0800

The local variable @page in __split_vmemmap_huge_pmd() to obtain a pmd
page without holding page_table_lock may possiblely get the page table
page instead of a huge pmd page.

The effect may be in set_pte_at() since we may pass an invalid page
struct, if set_pte_at() wants to access the page struct (e.g. 
CONFIG_PAGE_TABLE_CHECK is enabled), it may crash the kernel.

So fix it.  And inline __split_vmemmap_huge_pmd() since it only has one
user.

Link: https://lkml.kernel.org/r/20230707033859.16148-1-songmuchun@bytedance.com
Fixes: d8d55f5616cf ("mm: sparsemem: use page table lock to protect kernel pmd operations")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-a-race-between-vmemmap-pmd-split
+++ a/mm/hugetlb_vmemmap.c
@@ -36,14 +36,22 @@ struct vmemmap_remap_walk {
 	struct list_head	*vmemmap_pages;
 };
 
-static int __split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
+static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
 {
 	pmd_t __pmd;
 	int i;
 	unsigned long addr = start;
-	struct page *page = pmd_page(*pmd);
-	pte_t *pgtable = pte_alloc_one_kernel(&init_mm);
+	struct page *head;
+	pte_t *pgtable;
+
+	spin_lock(&init_mm.page_table_lock);
+	head = pmd_leaf(*pmd) ? pmd_page(*pmd) : NULL;
+	spin_unlock(&init_mm.page_table_lock);
 
+	if (!head)
+		return 0;
+
+	pgtable = pte_alloc_one_kernel(&init_mm);
 	if (!pgtable)
 		return -ENOMEM;
 
@@ -53,7 +61,7 @@ static int __split_vmemmap_huge_pmd(pmd_
 		pte_t entry, *pte;
 		pgprot_t pgprot = PAGE_KERNEL;
 
-		entry = mk_pte(page + i, pgprot);
+		entry = mk_pte(head + i, pgprot);
 		pte = pte_offset_kernel(&__pmd, addr);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -65,8 +73,8 @@ static int __split_vmemmap_huge_pmd(pmd_
 		 * be treated as indepdenent small pages (as they can be freed
 		 * individually).
 		 */
-		if (!PageReserved(page))
-			split_page(page, get_order(PMD_SIZE));
+		if (!PageReserved(head))
+			split_page(head, get_order(PMD_SIZE));
 
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
@@ -80,20 +88,6 @@ static int __split_vmemmap_huge_pmd(pmd_
 	return 0;
 }
 
-static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
-{
-	int leaf;
-
-	spin_lock(&init_mm.page_table_lock);
-	leaf = pmd_leaf(*pmd);
-	spin_unlock(&init_mm.page_table_lock);
-
-	if (!leaf)
-		return 0;
-
-	return __split_vmemmap_huge_pmd(pmd, start);
-}
-
 static void vmemmap_pte_range(pmd_t *pmd, unsigned long addr,
 			      unsigned long end,
 			      struct vmemmap_remap_walk *walk)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DE1C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347553AbiATV3C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347624AbiATV3B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B08C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:29:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8411360A6C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C1EC340E0;
        Thu, 20 Jan 2022 21:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714140;
        bh=1giOYbFgU/iJt9OIsnnVDXk2eO14JGx39BD31uuQACY=;
        h=Date:From:To:Subject:From;
        b=ZQgoqL3hmeVQrHWfjAJTQExVkrbnvWofNiubvxrOy7pIPb/0R/tfnwhDUxWHlACet
         vR9FhpdDfO3ZIaDX6ViM1hOkk8VsgvBs1PCqPf80U4VEJDU2d+rDxSs4TIQMU/IuZG
         3nuJOG5/NdKrBwSYY81zT+54XnyIIkiDoivtWAKo=
Date:   Thu, 20 Jan 2022 13:28:59 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        sfr@canb.auug.org.au, sj@kernel.org
Subject:  [merged]
 mm-damon-add-access-checking-for-hugetlb-pages.patch removed from -mm tree
Message-ID: <20220120212859.n_69W6DjY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: add access checking for hugetlb pages
has been removed from the -mm tree.  Its filename was
     mm-damon-add-access-checking-for-hugetlb-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/damon: add access checking for hugetlb pages

The process's VMAs can be mapped by hugetlb page, but now the DAMON did
not implement the access checking for hugetlb pte, so we can not get the
actual access count like below if a process VMAs were mapped by hugetlb.

damon_aggregated: target_id=18446614368406014464 nr_regions=12 4194304-5476352: 0 545
damon_aggregated: target_id=18446614368406014464 nr_regions=12 140662370467840-140662372970496: 0 545
damon_aggregated: target_id=18446614368406014464 nr_regions=12 140662372970496-140662375460864: 0 545
damon_aggregated: target_id=18446614368406014464 nr_regions=12 140662375460864-140662377951232: 0 545
damon_aggregated: target_id=18446614368406014464 nr_regions=12 140662377951232-140662380449792: 0 545
damon_aggregated: target_id=18446614368406014464 nr_regions=12 140662380449792-140662382944256: 0 545
......

Thus this patch adds hugetlb access checking support, with this patch we
can see below VMA mapped by hugetlb access count.

damon_aggregated: target_id=18446613056935405824 nr_regions=12 140296486649856-140296489914368: 1 3
damon_aggregated: target_id=18446613056935405824 nr_regions=12 140296489914368-140296492978176: 1 3
damon_aggregated: target_id=18446613056935405824 nr_regions=12 140296492978176-140296495439872: 1 3
damon_aggregated: target_id=18446613056935405824 nr_regions=12 140296495439872-140296498311168: 1 3
damon_aggregated: target_id=18446613056935405824 nr_regions=12 140296498311168-140296501198848: 1 3
damon_aggregated: target_id=18446613056935405824 nr_regions=12 140296501198848-140296504320000: 1 3
damon_aggregated: target_id=18446613056935405824 nr_regions=12 140296504320000-140296507568128: 1 2
......


[baolin.wang@linux.alibaba.com: fix unused var warning]
  Link: https://lkml.kernel.org/r/1aaf9c11-0d8e-b92d-5c92-46e50a6e8d4e@linux.alibaba.com
[baolin.wang@linux.alibaba.com: v3]
  Link: https://lkml.kernel.org/r/486927ecaaaecf2e3a7fbe0378ec6e1c58b50747.1640852276.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/6afcbd1fda5f9c7c24f320d26a98188c727ceec3.1639623751.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   96 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-add-access-checking-for-hugetlb-pages
+++ a/mm/damon/vaddr.c
@@ -388,8 +388,65 @@ out:
 	return 0;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+				struct vm_area_struct *vma, unsigned long addr)
+{
+	bool referenced = false;
+	pte_t entry = huge_ptep_get(pte);
+	struct page *page = pte_page(entry);
+
+	if (!page)
+		return;
+
+	get_page(page);
+
+	if (pte_young(entry)) {
+		referenced = true;
+		entry = pte_mkold(entry);
+		huge_ptep_set_access_flags(vma, addr, pte, entry,
+					   vma->vm_flags & VM_WRITE);
+	}
+
+#ifdef CONFIG_MMU_NOTIFIER
+	if (mmu_notifier_clear_young(mm, addr,
+				     addr + huge_page_size(hstate_vma(vma))))
+		referenced = true;
+#endif /* CONFIG_MMU_NOTIFIER */
+
+	if (referenced)
+		set_page_young(page);
+
+	set_page_idle(page);
+	put_page(page);
+}
+
+static int damon_mkold_hugetlb_entry(pte_t *pte, unsigned long hmask,
+				     unsigned long addr, unsigned long end,
+				     struct mm_walk *walk)
+{
+	struct hstate *h = hstate_vma(walk->vma);
+	spinlock_t *ptl;
+	pte_t entry;
+
+	ptl = huge_pte_lock(h, walk->mm, pte);
+	entry = huge_ptep_get(pte);
+	if (!pte_present(entry))
+		goto out;
+
+	damon_hugetlb_mkold(pte, walk->mm, walk->vma, addr);
+
+out:
+	spin_unlock(ptl);
+	return 0;
+}
+#else
+#define damon_mkold_hugetlb_entry NULL
+#endif /* CONFIG_HUGETLB_PAGE */
+
 static const struct mm_walk_ops damon_mkold_ops = {
 	.pmd_entry = damon_mkold_pmd_entry,
+	.hugetlb_entry = damon_mkold_hugetlb_entry,
 };
 
 static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
@@ -484,8 +541,47 @@ out:
 	return 0;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
+				     unsigned long addr, unsigned long end,
+				     struct mm_walk *walk)
+{
+	struct damon_young_walk_private *priv = walk->private;
+	struct hstate *h = hstate_vma(walk->vma);
+	struct page *page;
+	spinlock_t *ptl;
+	pte_t entry;
+
+	ptl = huge_pte_lock(h, walk->mm, pte);
+	entry = huge_ptep_get(pte);
+	if (!pte_present(entry))
+		goto out;
+
+	page = pte_page(entry);
+	if (!page)
+		goto out;
+
+	get_page(page);
+
+	if (pte_young(entry) || !page_is_idle(page) ||
+	    mmu_notifier_test_young(walk->mm, addr)) {
+		*priv->page_sz = huge_page_size(h);
+		priv->young = true;
+	}
+
+	put_page(page);
+
+out:
+	spin_unlock(ptl);
+	return 0;
+}
+#else
+#define damon_young_hugetlb_entry NULL
+#endif /* CONFIG_HUGETLB_PAGE */
+
 static const struct mm_walk_ops damon_young_ops = {
 	.pmd_entry = damon_young_pmd_entry,
+	.hugetlb_entry = damon_young_hugetlb_entry,
 };
 
 static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are



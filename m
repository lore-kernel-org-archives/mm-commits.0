Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731E8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 22:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhLPWIS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbhLPWIR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 17:08:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F1BC061574
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 14:08:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 295DFB82651
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 22:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04ACC36AE8;
        Thu, 16 Dec 2021 22:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639692494;
        bh=67fI7wPlAfNTIv+ljN9oHRSfTTLewbgM/t0B+Li04HM=;
        h=Date:From:To:Subject:From;
        b=c6rL4KLCjhlGcuKxgq2hfiCfFZ3wfklikc+9kNRyGZ0k8YLyFVKvsdWz2fanii1yZ
         4UPktRXm0DC+MyUPNhS3pqISTNJTmbKIIMGpU2pe/jk0lCu/sFMHGFijta3lEJVkDa
         vBU5E+ksZaD81OlKiYtCk/uwqdFQ/zQEdoHgqBg4=
Date:   Thu, 16 Dec 2021 14:08:14 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, mike.kravetz@oracle.com,
        baolin.wang@linux.alibaba.com
Subject:  + mm-damon-add-access-checking-for-hugetlb-pages.patch
 added to -mm tree
Message-ID: <20211216220814.ku1lM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: add access checking for hugetlb pages
has been added to the -mm tree.  Its filename is
     mm-damon-add-access-checking-for-hugetlb-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-add-access-checking-for-hugetlb-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-add-access-checking-for-hugetlb-pages.patch

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
Subject: mm/damon: add access checking for hugetlb pages

The process's VMAs can be mapped by hugetlb page, but now the DAMON
did not implement the access checking for hugetlb pte, so we can not
get the actual access count like below if a process VMAs were mapped
by hugetlb.

damon_aggregated: target_id=18446614368406014464
nr_regions=12 4194304-5476352: 0 545
damon_aggregated: target_id=18446614368406014464
nr_regions=12 140662370467840-140662372970496: 0 545
damon_aggregated: target_id=18446614368406014464
nr_regions=12 140662372970496-140662375460864: 0 545
damon_aggregated: target_id=18446614368406014464
nr_regions=12 140662375460864-140662377951232: 0 545
damon_aggregated: target_id=18446614368406014464
nr_regions=12 140662377951232-140662380449792: 0 545
damon_aggregated: target_id=18446614368406014464
nr_regions=12 140662380449792-140662382944256: 0 545
......

Thus this patch adds hugetlb access checking support, with this patch
we can see below VMA mapped by hugetlb access count.

damon_aggregated: target_id=18446613056935405824
nr_regions=12 140296486649856-140296489914368: 1 3
damon_aggregated: target_id=18446613056935405824
nr_regions=12 140296489914368-140296492978176: 1 3
damon_aggregated: target_id=18446613056935405824
nr_regions=12 140296492978176-140296495439872: 1 3
damon_aggregated: target_id=18446613056935405824
nr_regions=12 140296495439872-140296498311168: 1 3
damon_aggregated: target_id=18446613056935405824
nr_regions=12 140296498311168-140296501198848: 1 3
damon_aggregated: target_id=18446613056935405824
nr_regions=12 140296501198848-140296504320000: 1 3
damon_aggregated: target_id=18446613056935405824
nr_regions=12 140296504320000-140296507568128: 1 2
......

Link: https://lkml.kernel.org/r/6afcbd1fda5f9c7c24f320d26a98188c727ceec3.1639623751.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
+	struct hstate *h = hstate_vma(vma);
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
+	if (mmu_notifier_clear_young(mm, addr, addr + huge_page_size(h)))
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
+#endif
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
+#endif
+
 static const struct mm_walk_ops damon_young_ops = {
 	.pmd_entry = damon_young_pmd_entry,
+	.hugetlb_entry = damon_young_hugetlb_entry,
 };
 
 static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-the-return-value-of-migrate_pages.patch
mm-migrate-correct-the-hugetlb-migration-stats.patch
mm-migrate-correct-the-hugetlb-migration-stats-fix.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch
mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch
mm-damon-add-access-checking-for-hugetlb-pages.patch


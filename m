Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546D9C432BE
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 19:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F28761090
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 19:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhHaTC7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 15:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233044AbhHaTC6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 15:02:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1941B61041;
        Tue, 31 Aug 2021 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630436523;
        bh=P5NqCso+n70RdwT1JHQq5WnXOKjlrUja3vVHKd+S3UI=;
        h=Date:From:To:Subject:From;
        b=hXJATrQfwmkK3hFbPudGmGzQEYzOkxVL9FAWK6DTQ/z/i4qE3Ttop2jZojDKMiwzR
         URSI+vrNnf+x2FR0IOPJ1dFimqjh6GDJ8GKLSNDJqt1bJZw2uLPJ1H3/edI3n0luWg
         m3DUrJSSeCw3IKpipi2QrwNMkyNnxJPYJko3Oyg8=
Date:   Tue, 31 Aug 2021 12:02:02 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject:  +
 =?US-ASCII?Q?mm-damon-implement-primitives-for-the-virtual-memory-addres?=
 =?US-ASCII?Q?s-spaces-fix-3.patch?= added to -mm tree
Message-ID: <20210831190202.1EQc7vgU6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: safely walk page table
has been added to the -mm tree.  Its filename is
     mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: mm/damon/vaddr: safely walk page table

Commit d7f647622761 ("mm/damon: implement primitives for the virtual
memory address spaces") of linux-mm[1] tries to find PTE or PMD for
arbitrary virtual address using 'follow_invalidate_pte()' without proper
locking[2].  This commit fixes the issue by using another page table walk
function for more general use case ('walk_page_range()') under proper
locking (holding mmap read lock).

[1] https://github.com/hnaz/linux-mm/commit/d7f647622761
[2] https://lore.kernel.org/linux-mm/3b094493-9c1e-6024-bfd5-7eca66399b7e@redhat.com

Link: https://lkml.kernel.org/r/20210831161800.29419-1-sj38.park@gmail.com
Fixes: d7f647622761 ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |  136 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 97 insertions(+), 39 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-3
+++ a/mm/damon/vaddr.c
@@ -8,10 +8,12 @@
 #define pr_fmt(fmt) "damon-va: " fmt
 
 #include <linux/damon.h>
+#include <linux/hugetlb.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/highmem.h>
 #include <linux/page_idle.h>
+#include <linux/pagewalk.h>
 #include <linux/random.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
@@ -441,22 +443,42 @@ static void damon_pmdp_mkold(pmd_t *pmd,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 }
 
-static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
+static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
 {
-	pte_t *pte = NULL;
-	pmd_t *pmd = NULL;
+	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (follow_invalidate_pte(mm, addr, NULL, &pte, &pmd, &ptl))
-		return;
-
-	if (pte) {
-		damon_ptep_mkold(pte, mm, addr);
-		pte_unmap_unlock(pte, ptl);
-	} else {
-		damon_pmdp_mkold(pmd, mm, addr);
+	if (pmd_huge(*pmd)) {
+		ptl = pmd_lock(walk->mm, pmd);
+		if (pmd_huge(*pmd)) {
+			damon_pmdp_mkold(pmd, walk->mm, addr);
+			spin_unlock(ptl);
+			return 0;
+		}
 		spin_unlock(ptl);
 	}
+
+	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+		return 0;
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte_present(*pte))
+		goto out;
+	damon_ptep_mkold(pte, walk->mm, addr);
+out:
+	pte_unmap_unlock(pte, ptl);
+	return 0;
+}
+
+static struct mm_walk_ops damon_mkold_ops = {
+	.pmd_entry = damon_mkold_pmd_entry,
+};
+
+static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
+{
+	mmap_read_lock(mm);
+	walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
+	mmap_read_unlock(mm);
 }
 
 /*
@@ -487,43 +509,79 @@ void damon_va_prepare_access_checks(stru
 	}
 }
 
-static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-			unsigned long *page_sz)
+struct damon_young_walk_private {
+	unsigned long *page_sz;
+	bool young;
+};
+
+static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
 {
-	pte_t *pte = NULL;
-	pmd_t *pmd = NULL;
+	pte_t *pte;
 	spinlock_t *ptl;
 	struct page *page;
-	bool young = false;
-
-	if (follow_invalidate_pte(mm, addr, NULL, &pte, &pmd, &ptl))
-		return false;
-
-	*page_sz = PAGE_SIZE;
-	if (pte) {
-		page = damon_get_page(pte_pfn(*pte));
-		if (page && (pte_young(*pte) || !page_is_idle(page) ||
-					mmu_notifier_test_young(mm, addr)))
-			young = true;
-		if (page)
-			put_page(page);
-		pte_unmap_unlock(pte, ptl);
-		return young;
-	}
+	struct damon_young_walk_private *priv = walk->private;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	page = damon_get_page(pmd_pfn(*pmd));
-	if (page && (pmd_young(*pmd) || !page_is_idle(page) ||
-			mmu_notifier_test_young(mm, addr)))
-		young = true;
-	if (page)
+	if (pmd_huge(*pmd)) {
+		ptl = pmd_lock(walk->mm, pmd);
+		if (!pmd_huge(*pmd)) {
+			spin_unlock(ptl);
+			goto regular_page;
+		}
+		page = damon_get_page(pmd_pfn(*pmd));
+		if (!page)
+			goto huge_out;
+		if (pmd_young(*pmd) || !page_is_idle(page) ||
+					mmu_notifier_test_young(walk->mm,
+						addr)) {
+			*priv->page_sz = ((1UL) << HPAGE_PMD_SHIFT);
+			priv->young = true;
+		}
 		put_page(page);
+huge_out:
+		spin_unlock(ptl);
+		return 0;
+	}
 
-	spin_unlock(ptl);
-	*page_sz = ((1UL) << HPAGE_PMD_SHIFT);
+regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
-	return young;
+	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+		return -EINVAL;
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte_present(*pte))
+		goto out;
+	page = damon_get_page(pte_pfn(*pte));
+	if (!page)
+		goto out;
+	if (pte_young(*pte) || !page_is_idle(page) ||
+			mmu_notifier_test_young(walk->mm, addr)) {
+		*priv->page_sz = PAGE_SIZE;
+		priv->young = true;
+	}
+	put_page(page);
+out:
+	pte_unmap_unlock(pte, ptl);
+	return 0;
+}
+
+static struct mm_walk_ops damon_young_ops = {
+	.pmd_entry = damon_young_pmd_entry,
+};
+
+static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
+		unsigned long *page_sz)
+{
+	struct damon_young_walk_private arg = {
+		.page_sz = page_sz,
+		.young = false,
+	};
+
+	mmap_read_lock(mm);
+	walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);
+	mmap_read_unlock(mm);
+	return arg.young;
 }
 
 /*
_

Patches currently in -mm which might be from sjpark@amazon.de are

mm-introduce-data-access-monitor-damon.patch
mm-damon-core-implement-region-based-sampling.patch
mm-damon-adaptively-adjust-regions.patch
mm-idle_page_tracking-make-pg_idle-reusable.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-2.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-2.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-3.patch
mm-damon-add-a-tracepoint.patch
mm-damon-implement-a-debugfs-based-user-space-interface.patch
mm-damon-dbgfs-export-kdamond-pid-to-the-user-space.patch
mm-damon-dbgfs-support-multiple-contexts.patch
documentation-add-documents-for-damon.patch
mm-damon-add-kunit-tests.patch
mm-damon-add-user-space-selftests.patch
maintainers-update-for-damon.patch


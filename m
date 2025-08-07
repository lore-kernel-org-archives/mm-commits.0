Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EDC524F
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754537868; cv=none; b=pxJOs1dJAKT240n0fv5kT8OIScx3rp9XAgDTq99hTwHHvy96khddIVAOXofzgAIsPwrl38N++2zqNKyz4Ey0PA9Xri19grtjMOnF7Kv3jrn6y6F5+fqKU7cEDq3mDsoTUxeSh1is4QxbaLTwGBypcyrRgqMiOzaaydgfxywjDNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754537868; c=relaxed/simple;
	bh=iwHHA7HzfPtadG/1BAdiLvC26EpPhTOJ5S52HymF8T4=;
	h=Date:To:From:Subject:Message-Id; b=PizlrDnXKdxh5ZeacpMkLfRlkbWxWK/nfQToLD7tAr18X6iLm2qBpyoIWmbEymVs6CiYyvOX50UYlIUW7kBVlTPjVw8tq57FnFWmn0e+DAYxINM77XXeLU5CvSV1NPbulMpmFkrNrAJLNKdKEZicJgZcx15Ey8um6kM4/SZMRqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RIn6BFg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RIn6BFg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B3BC4CEEB;
	Thu,  7 Aug 2025 03:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754537867;
	bh=iwHHA7HzfPtadG/1BAdiLvC26EpPhTOJ5S52HymF8T4=;
	h=Date:To:From:Subject:From;
	b=RIn6BFg2ccom5j9zPcbh7Iil3rzMiEIrTdvGTNyN8ADMGb4gAsWxTnnqYYP6vpmFF
	 shuBuAhtCc/BR2TAWX8pCzTb74wjsK5NuL9/ovt7J9zfGqeuNJ/himvaGrcyMgRSVc
	 4sDOq/SgAqGd+W+7iyIOgW42UHDvk0AEQwemBdjE=
Date: Wed, 06 Aug 2025 20:37:47 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,sj@kernel.org,pyyjason@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-support-stat-purpose-damos-filters.patch added to mm-new branch
Message-Id: <20250807033747.A1B3BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: support stat-purpose DAMOS filters
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-support-stat-purpose-damos-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-support-stat-purpose-damos-filters.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yueyang Pan <pyyjason@gmail.com>
Subject: mm/damon/vaddr: support stat-purpose DAMOS filters
Date: Sat, 2 Aug 2025 11:52:46 +0000

This patch extends DAMOS_STAT handling of the DAMON operations sets for
virtual address spaces for ops-level DAMOS filters.  It leverages the
walk_page_range to walk the page table and gets the folio from page table.
The last folio scanned is stored in damos->last_applied to prevent double
counting.

Link: https://lkml.kernel.org/r/264a4b5ea202fd73c01b349c9694d8bf9978c441.1754135312.git.pyyjason@gmail.com
Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |  103 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-support-stat-purpose-damos-filters
+++ a/mm/damon/vaddr.c
@@ -890,6 +890,107 @@ free_lists:
 	return applied * PAGE_SIZE;
 }
 
+struct damos_va_stat_private {
+	struct damos *scheme;
+	unsigned long *sz_filter_passed;
+};
+
+static inline bool damos_va_invalid_folio(struct folio *folio,
+		struct damos *s)
+{
+	return !folio || folio == s->last_applied;
+}
+
+static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	struct damos_va_stat_private *priv = walk->private;
+	struct damos *s = priv->scheme;
+	unsigned long *sz_filter_passed = priv->sz_filter_passed;
+	struct vm_area_struct *vma = walk->vma;
+	struct folio *folio;
+	spinlock_t *ptl;
+	pte_t *start_pte, *pte, ptent;
+	int nr;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (pmd_trans_huge(*pmd)) {
+		pmd_t pmde;
+
+		ptl = pmd_trans_huge_lock(pmd, vma);
+		if (!ptl)
+			return 0;
+		pmde = pmdp_get(pmd);
+		if (!pmd_present(pmde))
+			goto huge_unlock;
+
+		folio = vm_normal_folio_pmd(vma, addr, pmde);
+
+		if (damos_va_invalid_folio(folio, s))
+			goto huge_unlock;
+
+		if (!damos_va_filter_out(s, folio, vma, addr, NULL, pmd))
+			*sz_filter_passed += folio_size(folio);
+		s->last_applied = folio;
+
+huge_unlock:
+		spin_unlock(ptl);
+		return 0;
+	}
+#endif
+	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
+
+	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		nr = 1;
+		ptent = ptep_get(pte);
+
+		if (pte_none(ptent) || !pte_present(ptent))
+			continue;
+
+		folio = vm_normal_folio(vma, addr, ptent);
+
+		if (damos_va_invalid_folio(folio, s))
+			continue;
+
+		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
+			*sz_filter_passed += folio_size(folio);
+		nr = folio_nr_pages(folio);
+		s->last_applied = folio;
+	}
+	pte_unmap_unlock(start_pte, ptl);
+	return 0;
+}
+
+static unsigned long damos_va_stat(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+	struct damos_va_stat_private priv;
+	struct mm_struct *mm;
+	struct mm_walk_ops walk_ops = {
+		.pmd_entry = damos_va_stat_pmd_entry,
+		.walk_lock = PGWALK_RDLOCK,
+	};
+
+	priv.scheme = s;
+	priv.sz_filter_passed = sz_filter_passed;
+
+	if (!damos_ops_has_filter(s))
+		return 0;
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	mmap_read_lock(mm);
+	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
+	mmap_read_unlock(mm);
+	mmput(mm);
+	return 0;
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -916,7 +1017,7 @@ static unsigned long damon_va_apply_sche
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
-		return 0;
+		return damos_va_stat(t, r, scheme, sz_filter_passed);
 	default:
 		/*
 		 * DAMOS actions that are not yet supported by 'vaddr'.
_

Patches currently in -mm which might be from pyyjason@gmail.com are

mm-damon-paddr-move-filters-existence-check-function-to-ops-common.patch
mm-damon-vaddr-support-stat-purpose-damos-filters.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6045031690E
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 20:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779224399; cv=none; b=seNV5HAUcynOJj7Dc1MouRwbDSWPzD+fspef4MjOy9eU9SPQ0tSYcPRbH7fbMflV0AC3WQtznBVX8UfxvYCdNhFJ1DhWc/TRBBIWsh8cAvKcSlFvbEgwJTRFwTueltq2T1xLsJ5swlif0pFU3uYxGL2GzPVnfu7AqHr4+pAet7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779224399; c=relaxed/simple;
	bh=sPyLVGpGx8y/2iZPRgRZKl5xxCVbZWQWBBj4JBX/jbo=;
	h=Date:To:From:Subject:Message-Id; b=W2DgheNAGrVrPVIzLyYLqS04m9W6tIojXE4ynVQrzrfjxmNEvvyI8P9V2uSKF3qxEDiNecNVx9Oknh0cyE8gnX+kGCvzHn0r3l+TzjG40t1iR6jMOOiwvMsFUHA8oKNK/tV90ZqE4KXeMxns5uXMgzfAlvE4AiXVZv47jOQFTIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2KLRVJ/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2KLRVJ/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15611F000E9;
	Tue, 19 May 2026 20:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779224397;
	bh=EXlrZXvSRqFc/77m2NaKOnar1zua+LHmcwy8pG4jalw=;
	h=Date:To:From:Subject;
	b=2KLRVJ/dlJ/ewHr5COWabS0St8et83V2bsrSJ2Se18SbnqWxmYoDQirAWv7a3TW2f
	 pPlkc8G2pPnhIqpe7pIzMcA7K4ZjFJCIhtCWcMB9WBq+Byx+GqRi64mCKWHax/Xk0Q
	 +xX1F/UKxnOReCTIBAOR7QBXEtTAI4lElXQScJoA=
Date: Tue, 19 May 2026 13:59:57 -0700
To: mm-commits@vger.kernel.org,sunnanyong@huawei.com,sj@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-attempt-per-vma-lock-during-page-table-walk.patch added to mm-new branch
Message-Id: <20260519205957.D15611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: attempt per-vma lock during page table walk
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-attempt-per-vma-lock-during-page-table-walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-attempt-per-vma-lock-during-page-table-walk.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon/vaddr: attempt per-vma lock during page table walk
Date: Tue, 12 May 2026 23:15:23 +0800

Currently, DAMON virtual address operations use mmap_read_lock during page
table walks, which can cause unnecessary contention under high
concurrency.

Introduce damon_va_walk_page_range() to first attempt acquiring a per-vma
lock.  If the VMA is found and the range is fully contained within it, the
page table walk proceeds with the per-vma lock instead of mmap_read_lock.

This optimization is expected to be particularly effective for
damon_va_young() and damon_va_mkold(), which are frequently called and
typically operate within a single VMA.

Link: https://lore.kernel.org/20260512151523.2092638-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   69 ++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 26 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-attempt-per-vma-lock-during-page-table-walk
+++ a/mm/damon/vaddr.c
@@ -237,6 +237,35 @@ static void damon_va_update(struct damon
 	}
 }
 
+static void damon_va_walk_page_range(struct mm_struct *mm, unsigned long start,
+		unsigned long end, struct mm_walk_ops *ops, void *private)
+{
+	struct vm_area_struct *vma;
+
+	vma = lock_vma_under_rcu(mm, start);
+	if (!vma)
+		goto lock_mmap;
+
+	if (end > vma->vm_end) {
+		vma_end_read(vma);
+		goto lock_mmap;
+	}
+
+	if (!(vma->vm_flags & VM_PFNMAP)) {
+		ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
+		walk_page_range_vma(vma, start, end, ops, private);
+	}
+
+	vma_end_read(vma);
+	return;
+
+lock_mmap:
+	mmap_read_lock(mm);
+	ops->walk_lock = PGWALK_RDLOCK;
+	walk_page_range(mm, start, end, ops, private);
+	mmap_read_unlock(mm);
+}
+
 static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
@@ -315,17 +344,14 @@ out:
 #define damon_mkold_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static const struct mm_walk_ops damon_mkold_ops = {
-	.pmd_entry = damon_mkold_pmd_entry,
-	.hugetlb_entry = damon_mkold_hugetlb_entry,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
 static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
 {
-	mmap_read_lock(mm);
-	walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
-	mmap_read_unlock(mm);
+	struct mm_walk_ops damon_mkold_ops = {
+		.pmd_entry = damon_mkold_pmd_entry,
+		.hugetlb_entry = damon_mkold_hugetlb_entry,
+	};
+
+	damon_va_walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
 }
 
 /*
@@ -445,12 +471,6 @@ out:
 #define damon_young_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static const struct mm_walk_ops damon_young_ops = {
-	.pmd_entry = damon_young_pmd_entry,
-	.hugetlb_entry = damon_young_hugetlb_entry,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
 static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
 		unsigned long *folio_sz)
 {
@@ -459,9 +479,12 @@ static bool damon_va_young(struct mm_str
 		.young = false,
 	};
 
-	mmap_read_lock(mm);
-	walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);
-	mmap_read_unlock(mm);
+	struct mm_walk_ops damon_young_ops = {
+		.pmd_entry = damon_young_pmd_entry,
+		.hugetlb_entry = damon_young_hugetlb_entry,
+	};
+
+	damon_va_walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);
 	return arg.young;
 }
 
@@ -750,7 +773,6 @@ static unsigned long damos_va_migrate(st
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry = damos_va_migrate_pmd_entry,
 		.pte_entry = NULL,
-		.walk_lock = PGWALK_RDLOCK,
 	};
 
 	use_target_nid = dests->nr_dests == 0;
@@ -768,9 +790,7 @@ static unsigned long damos_va_migrate(st
 	if (!mm)
 		goto free_lists;
 
-	mmap_read_lock(mm);
-	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
-	mmap_read_unlock(mm);
+	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
 	mmput(mm);
 
 	for (int i = 0; i < nr_dests; i++) {
@@ -862,7 +882,6 @@ static unsigned long damos_va_stat(struc
 	struct mm_struct *mm;
 	struct mm_walk_ops walk_ops = {
 		.pmd_entry = damos_va_stat_pmd_entry,
-		.walk_lock = PGWALK_RDLOCK,
 	};
 
 	priv.scheme = s;
@@ -875,9 +894,7 @@ static unsigned long damos_va_stat(struc
 	if (!mm)
 		return 0;
 
-	mmap_read_lock(mm);
-	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
-	mmap_read_unlock(mm);
+	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
 	mmput(mm);
 	return 0;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-damon-vaddr-attempt-per-vma-lock-during-page-table-walk.patch


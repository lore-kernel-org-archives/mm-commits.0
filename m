Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F77221721
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 01:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784337052; cv=none; b=kr9NvFxOGdxFHhFeE3unYFFvCy583b0mGU07/G8psbZZmU+3hy5eANl6Kgje39akZ/mBjwYlaJMuqg2TXM+FJFgRdNqDwcKyE9lzZ+e8hbe/H7Fxicdfcj7dj2K2OsbCm+EB87NN8Cr1TzANePjJEAlRgftCR7NMYy3edRVY8k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784337052; c=relaxed/simple;
	bh=KZXSLqo2pQkX8mWdXv06M9VQ6SuAVOPo5XbuWI2YRwA=;
	h=Date:To:From:Subject:Message-Id; b=u8wrOVXh2NvwU/YsSRv/XvIw1suSr/SD8X/BrJN2Z+KtdYjS5DlXBPA0wau3A+cqHICE40ocyEZQ5GSbOEMTE7+aiF8rBB426LIqlzS17uzwrpAqnmKdRpPUFikih0Vm/sqGCj+e/M8pb3zBg9pe37JMUxPuwXvNKoWLBe7FFbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gw+jX/tE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gw+jX/tE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB401F000E9;
	Sat, 18 Jul 2026 01:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784337050;
	bh=9VplzdpCjclihtpdYGLE999cEWVJFI10rf2p0YD2ODY=;
	h=Date:To:From:Subject;
	b=Gw+jX/tECPwVfk6DNbA9i6gxvf/2y5sZQBmk3MRsDkKfssZ/9rve2JhBGZRz0aGFF
	 RTpTc+TKR1pFCyKcA3lljcWAM97lYQWXYKgriag/1b8rAsSbJiGgu0oOa0EirjpGBR
	 RliGiMHzS0N9SgZLcwVjEzT3nwlBQLii3N6iGYK0=
Date: Fri, 17 Jul 2026 18:10:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-improve-mincore_hugetlb.patch added to mm-new branch
Message-Id: <20260718011050.9EB401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: improve mincore_hugetlb()
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-improve-mincore_hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-improve-mincore_hugetlb.patch

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
Subject: mm: mincore: improve mincore_hugetlb()
Date: Fri, 17 Jul 2026 17:13:46 +0800

walk_hugetlb_range() always passes a non-NULL pte, so remove the dead NULL
check.  Replace the per-page iteration loop with memset() for better
performance.

Link: https://lore.kernel.org/20260717091347.1144789-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

--- a/mm/mincore.c~mm-mincore-improve-mincore_hugetlb
+++ a/mm/mincore.c
@@ -28,30 +28,17 @@ static int mincore_hugetlb(pte_t *pte, u
 			unsigned long end, struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	unsigned char present;
+	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	unsigned char *vec = walk->private;
+	unsigned char resident;
 	spinlock_t *ptl;
+	pte_t ptep;
 
 	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
-
-	/*
-	 * Hugepages under user process are always in RAM and never
-	 * swapped out, but theoretically it needs to be checked.
-	 */
-	if (!pte) {
-		present = 0;
-	} else {
-		const pte_t ptep = huge_ptep_get(walk->mm, addr, pte);
-
-		if (huge_pte_none(ptep) || pte_is_marker(ptep))
-			present = 0;
-		else
-			present = 1;
-	}
-
-	for (; addr != end; vec++, addr += PAGE_SIZE)
-		*vec = present;
-	walk->private = vec;
+	ptep = huge_ptep_get(walk->mm, addr, pte);
+	resident = !huge_pte_none(ptep) && !pte_is_marker(ptep);
+	memset(vec, resident, nr);
+	walk->private += nr;
 	spin_unlock(ptl);
 #else
 	BUG();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch
mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch
mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-refactor-mincore_page.patch


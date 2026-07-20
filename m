Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA243CF963
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 22:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784587271; cv=none; b=GSJMENzavq2OQR3CwtQNs0i0MCSWKpdGGVGFFM9oSZluWq2F9LV9VUG6JAnFfFA+bR6AGCssJAItcu4d4BqvIA3xZRCyp4JsRxZhHTyDApz4t8Zg7Ial0HltFwD7ECi3+El8xBhSwtfrVo7TGN8lWfGM6F+qbjP79Fd/gpVg9yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784587271; c=relaxed/simple;
	bh=4KX6bIYFlNTcYS0r4lxL3XnjsjpDaIafM8FeqtZ0HiM=;
	h=Date:To:From:Subject:Message-Id; b=nsRQLQd4Vj6+lW5KNzuJQ+kf03MEOLcMhD3UqbBgOvg5esssGuhDMqg88d7yEw1iFMMiK81oNm4dxGDCOQ33ad/g5x/OfuwiUK5P2no/84rlX6QiTquGy/LVXkIQJ7FG4ffIdtW84G+6CCNwujgTp6A5nczqGMkiEQQM3Vmt178=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BbDnIDOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BbDnIDOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1501F000E9;
	Mon, 20 Jul 2026 22:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784587269;
	bh=5OsaMjuy6piAm5O2zOhG8hkWVfnT4WbaTsbeMIxBaus=;
	h=Date:To:From:Subject;
	b=BbDnIDOEYEJg/4/7CGJddYyNoWtd/WrUT44uzo5aVbcm3ZWcZ8/9bBJqQ+G+PbMUn
	 hKAkwr9cF32C42Tl/UKAUIQzvvOVxhITmldkF6boIFPj0LpjpEVLT1Mh1eL5iraDy0
	 yWG8fJqDdmmqxBIHTrJQjUR/tdmrmjEnXvGAEifE=
Date: Mon, 20 Jul 2026 15:41:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-improve-mincore_hugetlb-fix.patch added to mm-unstable branch
Message-Id: <20260720224109.BC1501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: fixup improve mincore_hugetlb()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mincore-improve-mincore_hugetlb-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-improve-mincore_hugetlb-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm: mincore: fixup improve mincore_hugetlb()
Date: Mon, 20 Jul 2026 20:42:52 +0800

- change unsigned long nr to const
- remove a local vec variable

Link: https://lore.kernel.org/20260720124252.1483984-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/mincore.c~mm-mincore-improve-mincore_hugetlb-fix
+++ a/mm/mincore.c
@@ -28,8 +28,7 @@ static int mincore_hugetlb(pte_t *pte, u
 			unsigned long end, struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	unsigned long nr = (end - addr) >> PAGE_SHIFT;
-	unsigned char *vec = walk->private;
+	const unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	unsigned char resident;
 	spinlock_t *ptl;
 	pte_t ptep;
@@ -37,7 +36,7 @@ static int mincore_hugetlb(pte_t *pte, u
 	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
 	ptep = huge_ptep_get(walk->mm, addr, pte);
 	resident = !huge_pte_none(ptep) && !pte_is_marker(ptep);
-	memset(vec, resident, nr);
+	memset(walk->private, resident, nr);
 	walk->private += nr;
 	spin_unlock(ptl);
 #else
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
mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-improve-mincore_hugetlb-fix.patch
mm-mincore-refactor-mincore_page.patch


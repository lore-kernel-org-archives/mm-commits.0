Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039551D5CC9
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 01:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785893040; cv=none; b=SeKn082iJkwWtiq5BuqUiuUOXPmY7Vxkv2r1S5KsJsO4PdO+KjW/56h/N1TpCqvlcuC1+gb7e0fapidn7FWYLZgDAmkZiLfxFWSIK7HlEsmXFFartfsmWqMfxwbPQkWhjmCPTjTLF8RDpo0gQzalVDDPEYm2SB7ykdM3oGC/5wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785893040; c=relaxed/simple;
	bh=LQmqv7cO6O5y5J43AFkxVVbHE/kr69aSoYHqTrYLhdc=;
	h=Date:To:From:Subject:Message-Id; b=QedPsaHlt5BFsIc9P+g7lo9njqsaLnwSunN2ted5mI/xva0Tztx+S+huJfewqxzBweq8x8mSZV9OycjzDwA6dBaNuKr4PXKpgzgnjvlzYddYPFgpJhQZVc1O5sXVEnwNdLu+MV9w2+9ZhM68EgTHWkib9pu76AAxTroz86UWZp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jghD5x2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jghD5x2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E65B1F000E9;
	Wed,  5 Aug 2026 01:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785893038;
	bh=jb37iedGwvVx/Ov/aTUq1UQO8hR/EmQSNPO5cQ5ZoD4=;
	h=Date:To:From:Subject;
	b=jghD5x2iYLyxYNWSNQxonjbg7xlscygzOUZojkn/+cmVfdFkmKQEO6yc7pDQ+lGg3
	 Rkwx3u4kqUexeRPjImtfS+mhpwL8artcyMCaydRWevbYEt6sahrxwzG0tZ+w00b5rJ
	 8hQ8Out80t3nOfG6tW8KIs0EMPkEd1Icg+R6OZmQ=
Date: Tue, 04 Aug 2026 18:23:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mincore-improve-mincore_hugetlb-fix.patch removed from -mm tree
Message-Id: <20260805012358.5E65B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: fixup improve mincore_hugetlb()
has been removed from the -mm tree.  Its filename was
     mm-mincore-improve-mincore_hugetlb-fix.patch

This patch was dropped because it was folded into mm-mincore-improve-mincore_hugetlb.patch

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

mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-refactor-mincore_page.patch


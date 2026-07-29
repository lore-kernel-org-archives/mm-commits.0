Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334EF3909B5
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298428; cv=none; b=PTRn9HLUXYOpz2lEzQyugrL2t85JeEZ42qlNcn4XcRzinBY/87purULeQmw+SnhCvx1Q26qdccUQ+A8kGnjvzsCFCduCADhMbZNczFHhntpegxSRP5xT2TNVO1+GmQbBJb23tBTn/QBAuWeznTlUfzGq/oxeVyycJ0yv0fV8p8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298428; c=relaxed/simple;
	bh=U8z3a4XI72M48Urve8+s8IwcS6SxamikLVeKPbcmrV8=;
	h=Date:To:From:Subject:Message-Id; b=QmeOtQGHX+l0RZnY6L5Ak4Hb6+t3gtNIP/xbGV4s9dBejlCzBCdANoO5CNJUrhOxwJIuBPy3spYya33PZLKURBKwAJ+lhiYzJM0t8P3oXX3kW9pIqodUrC2H56Zp2o3RYQ2syOic/09tWQwL4rWCx3JA8tmPpVw31kJwphEGfk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o5Y9cgtv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o5Y9cgtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C961F000E9;
	Wed, 29 Jul 2026 04:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298427;
	bh=GigZ60KoiF8cnh9tZtGi7fokqc00xGpeipbuuWV8btM=;
	h=Date:To:From:Subject;
	b=o5Y9cgtvVXGqAjxXIQycEMELDyhqZB9af/KQxc7Fu6e/YG0vBSHcZSvZwV+e7Lbeq
	 ZLV9nx7UDENLN3frn6NFWLdJOLAkJwKSV8pxKP8+fAw/Rx/8J8hPnPkfmGqllWhO4T
	 KS7KEQav6PAiVxMcj5h6QpHjbiDjtfzXamwHp72E=
Date: Tue, 28 Jul 2026 21:13:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rakie.kim@sk.com,pfalcato@suse.de,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch removed from -mm tree
Message-Id: <20260729041346.E4C961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mprotect: use walk_page_range_vma() in mprotect_fixup()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mprotect: use walk_page_range_vma() in mprotect_fixup()
Date: Thu, 18 Jun 2026 17:28:43 +0800

In mprotect_fixup(), the PROT_NONE PFN permission check uses
walk_page_range() to walk the page table.  Fortunately, the caller always
passes start/end that falls within a single VMA, the do_mprotect_pkey()
iterates per-VMA via for_each_vma_range(), and setup_arg_pages() passes
the whole VMA.

Note, walk_page_test() isn't called in walk_page_range_vma(), however,
prot_none_test() in prot_none_walk_ops always return 0, so it's safe to
replace walk_page_range() with walk_page_range_vma() to eliminate an
unnecessary find_vma() lookup, also remove unneeded prot_none_test() too.

Link: https://lore.kernel.org/20260618092845.3905740-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup
+++ a/mm/mprotect.c
@@ -708,16 +708,9 @@ static int prot_none_hugetlb_entry(pte_t
 		0 : -EACCES;
 }
 
-static int prot_none_test(unsigned long addr, unsigned long next,
-			  struct mm_walk *walk)
-{
-	return 0;
-}
-
 static const struct mm_walk_ops prot_none_walk_ops = {
 	.pte_entry		= prot_none_pte_entry,
 	.hugetlb_entry		= prot_none_hugetlb_entry,
-	.test_walk		= prot_none_test,
 	.walk_lock		= PGWALK_WRLOCK,
 };
 
@@ -753,7 +746,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
-		error = walk_page_range(current->mm, start, end,
+		error = walk_page_range_vma(vma, start, end,
 				&prot_none_walk_ops, &new_pgprot);
 		if (error)
 			return error;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-improve-mincore_hugetlb-fix.patch
mm-mincore-refactor-mincore_page.patch


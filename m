Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BFB38F65C
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298424; cv=none; b=o2baFiPVMk9ctHYdw7zHJ5OhGNS9Q5l7f0rkdj+p0b/2mN51wR+Im9uKM5zdNnaKrHAvWtMUMY0k23+jrRyFH9NCD8WulsTviXGRKa+gNfolviqCBBCoEmRWofM1WQcLUdcMUs8NAIQC+f7GKnICQx+EIeds17DjFhfZKhNfdZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298424; c=relaxed/simple;
	bh=BFrz7Ef0Rkr8qUzzWkteImq9MyCYFdAicXArhUIGp74=;
	h=Date:To:From:Subject:Message-Id; b=R6HdR7J7+K4TdnsqA5Wb8A4vZL5HrcfzL0JKTd/tNyPde0Jpz14PVcEAh6qTwEm9I+bLQqT0tJBKRyE1z0d6Sd7+30hfn90oMqmhYy2sy1LmIkWlTOgtSNZkvQEQ3tV4AeT4XZCU+NxM1ZlAn6oCP7MLc3hnmHWR6X3zZKM3A80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ir0XTMB8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ir0XTMB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F681F00A3A;
	Wed, 29 Jul 2026 04:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298423;
	bh=oqoawlCH3RWRIBuDAhxstGluiu7f5ndtiWLUD/Al+zA=;
	h=Date:To:From:Subject;
	b=ir0XTMB8p6/DA1rri7Fh4D93GyvDHG7XALU4sTXoUNFsru0higDCpevVCHnC94xYZ
	 pHSpMu/Mw7aqvDZqb4jhvw0evexn0HQex788bcqzL6zMZ9Vy/dwYW+Gka9C2h3YULA
	 oDiH+d6KaiPONAfLpPF0Pzkzr9Spb9gUZQswIIH0=
Date: Tue, 28 Jul 2026 21:13:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rakie.kim@sk.com,pfalcato@suse.de,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-use-walk_page_range_vma-in-do_mincore.patch removed from -mm tree
Message-Id: <20260729041343.10F681F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: use walk_page_range_vma() in do_mincore()
has been removed from the -mm tree.  Its filename was
     mm-mincore-use-walk_page_range_vma-in-do_mincore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: use walk_page_range_vma() in do_mincore()
Date: Thu, 18 Jun 2026 17:28:42 +0800

Patch series "mm: convert to walk_page_range_vma() to eliminate
find_vma()", v2.

walk_page_range() performs a find_vma() lookup on each page table walk. 
For callers that already hold a valid VMA and operate on a known
single-VMA range, this lookup is redundant.  Replace walk_page_range()
with walk_page_range_vma() where the caller guarantees single-VMA
semantics.


This patch (of 4):

do_mincore() uses walk_page_range() to walk the page table.  Fortunately,
the caller always passes start/end that falls within a single VMA, so it's
safe to use the walk_page_range_vma() in do_mincore() to eliminate an
unnecessary find_vma() lookup.

Unlike walk_page_range(), walk_page_range_vma() does not call
walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole() to skip
the page table walk.  Without this check, PFNMAP PTEs would be treated as
present by mincore_pte_range(), changing the returned residency status. 
Handle VM_PFNMAP explicitly in do_mincore() to preserve the original
behavior.

[akpm@linux-foundation.org: simplify comment, per Pedro]
  Link: https://lore.kernel.org/ajP9bQhmvR9OX0VE@pedro-suse
Link: https://lore.kernel.org/20260618092845.3905740-1-wangkefeng.wang@huawei.com
Link: https://lore.kernel.org/20260618092845.3905740-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
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

 mm/mincore.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/mincore.c~mm-mincore-use-walk_page_range_vma-in-do_mincore
+++ a/mm/mincore.c
@@ -258,7 +258,16 @@ static long do_mincore(unsigned long add
 		memset(vec, 1, pages);
 		return pages;
 	}
-	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
+
+	/*
+	 * mincore historically reports PFNMAP mappings as non-resident.
+	 */
+	if (vma->vm_flags & VM_PFNMAP) {
+		__mincore_unmapped_range(addr, end, vma, vec);
+		return (end - addr) >> PAGE_SHIFT;
+	}
+
+	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
 	if (err < 0)
 		return err;
 	return (end - addr) >> PAGE_SHIFT;
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


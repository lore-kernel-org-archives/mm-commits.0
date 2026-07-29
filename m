Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2560390C90
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298431; cv=none; b=g3MbDzv2DEO4VH8JAsaqtL+8TNFomme4X5MmtFpwlCcRGGEGuFhzKWNgl89ygZhTmk5nNg3A7zzmr+CIG226k62PG2tt7VsIJCsPmC9AEWXVS66oYu1EwdxzneiXJAL9UMrLC8KFghRuLD2Wrbn7wWlSajBa1umuAnKCs922eQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298431; c=relaxed/simple;
	bh=SgNFvcTSAvKeLMyt/Id7n/uyN3epic0EGUL3DU2g9Zs=;
	h=Date:To:From:Subject:Message-Id; b=iyqooRL33akYpy7IjwH7UFJqZJ81/9qS/ZPHa+epMP/Vl5CEbkAa0W4N1QMi/0r0qfFyLcL2iEFlQp6bOCVRP8PTGYbnBx2RFRQKfm0K9IJZlzNPW4WewNK2r/VgFNOEQ8LppP1L+4KcEQcTnrEd9/eVt9N18oSQrun+uqg6A0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JbwPVO91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JbwPVO91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725E81F000E9;
	Wed, 29 Jul 2026 04:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298429;
	bh=jo7dvzb8Jyv8DcArKZrP7nPi72l8jvyRj5F3wTdqXbw=;
	h=Date:To:From:Subject;
	b=JbwPVO91sC67vQ1zJk+t/LDyZ4dxGb2ndHwWQhAYHi4RsgjPndY6ETkJpH/FHxYJw
	 pmBHJLWfpGmKrDD4ZcSCLATe9ClOwO8RuokvOlETMyyCWnP67Hy2RLbeeuABi1BJ3q
	 8ZWzPWJNsneVTy2N+bo2Ajq54Ywm1VrNucZTVgCQ=
Date: Tue, 28 Jul 2026 21:13:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rakie.kim@sk.com,pfalcato@suse.de,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch removed from -mm tree
Message-Id: <20260729041349.725E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate_device: use walk_page_range_vma() in migrate_vma_collect()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate_device: use walk_page_range_vma() in migrate_vma_collect()
Date: Thu, 18 Jun 2026 17:28:45 +0800

migrate_vma_collect() uses walk_page_range() to walk the page table. 
Fortunately, migrate_vma_setup() already validates that the entire range
falls within a single VMA.

Since there is no .test_walk in migrate_vma_walk_ops and VM_PFNMAP was
filtered by migrate_vma_setup(), it's safe to replace walk_page_range()
with walk_page_range_vma() to eliminate an unnecessary find_vma() lookup.

Link: https://lore.kernel.org/20260618092845.3905740-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
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

 mm/migrate_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect
+++ a/mm/migrate_device.c
@@ -514,7 +514,7 @@ static void migrate_vma_collect(struct m
 		migrate->pgmap_owner);
 	mmu_notifier_invalidate_range_start(&range);
 
-	walk_page_range(migrate->vma->vm_mm, migrate->start, migrate->end,
+	walk_page_range_vma(migrate->vma, migrate->start, migrate->end,
 			&migrate_vma_walk_ops, migrate);
 
 	mmu_notifier_invalidate_range_end(&range);
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


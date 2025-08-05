Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D42231845
	for <mm-commits@vger.kernel.org>; Tue,  5 Aug 2025 20:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754426371; cv=none; b=t2rJullMO3wX2ab1iH64pmlLpy9cR6ubNNA/qnwAiAZNMhprWN/y1NJ2QpBZoeFec9E1sIcP5EwLYcQMjr+MjU41u9nT0C6jKjMFa1Z6oE+XJCM6L3s/KVJEYXdgD5/+1U5EpZBZPCIwwXSWRsQeTxFHNM6MKf6093E2rnM655w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754426371; c=relaxed/simple;
	bh=1RGerIRCTs/SpUiIx1AqVoiA8+PoWA9DwutyWIjPCUM=;
	h=Date:To:From:Subject:Message-Id; b=hSt11hl4hVFf9tNVC+fYZcw4hymjEIc9n4JUq5qdFx2oVcXrKHgERNGJBaVM7FxfyN7eBORiViKatIA7/uT1Ufuvndnn20e3HwTrbM2guDqZiIncmIkf9LCJF5rGdLxriaWOS9XOroiFjKYvB/y0eiCzPmFzGOCXWq3RazvjrI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lJKXWgUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lJKXWgUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F950C4CEF0;
	Tue,  5 Aug 2025 20:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754426371;
	bh=1RGerIRCTs/SpUiIx1AqVoiA8+PoWA9DwutyWIjPCUM=;
	h=Date:To:From:Subject:From;
	b=lJKXWgUbapzKH8m5bmZqsTnrfTUIuslzuN6TRzVFX0xbgarbe3JddwEm8ZDbbJmw8
	 MKkR6tREU6pWWgSTmtj97MnF9DOx6Qn8dKn6pHnjHjGMMmiagCTPhFq2IX2jkKAecY
	 r4+9kW2YI15WX7dJxb/wBCJ6Ws1CqLvMWsk5v2lw=
Date: Tue, 05 Aug 2025 13:39:30 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,thiago.bauermann@linaro.org,ryan.roberts@arm.com,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,joern@logfs.org,hughd@google.com,dev.jain@arm.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,brahmajit.xyz@gmail.com,baolin.wang@linux.alibaba.com,avagin@gmail.com,andrii@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-task_mmu-hold-ptl-in-pagemap_hugetlb_range-and-gather_hugetlb_stats.patch removed from -mm tree
Message-Id: <20250805203931.4F950C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: hold PTL in pagemap_hugetlb_range and gather_hugetlb_stats
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-hold-ptl-in-pagemap_hugetlb_range-and-gather_hugetlb_stats.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: fs/proc/task_mmu: hold PTL in pagemap_hugetlb_range and gather_hugetlb_stats
Date: Thu, 24 Jul 2025 17:09:57 +0800

Hold PTL in pagemap_hugetlb_range() and gather_hugetlb_stats() to avoid
operating on stale page, as pagemap_pmd_range() and gather_pte_stats()
have done.

Link: https://lkml.kernel.org/r/20250724090958.455887-3-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-hold-ptl-in-pagemap_hugetlb_range-and-gather_hugetlb_stats
+++ a/fs/proc/task_mmu.c
@@ -2021,12 +2021,14 @@ static int pagemap_hugetlb_range(pte_t *
 	struct pagemapread *pm = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	u64 flags = 0, frame = 0;
+	spinlock_t *ptl;
 	int err = 0;
 	pte_t pte;
 
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
 
+	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, ptep);
 	pte = huge_ptep_get(walk->mm, addr, ptep);
 	if (pte_present(pte)) {
 		struct folio *folio = page_folio(pte_page(pte));
@@ -2054,11 +2056,12 @@ static int pagemap_hugetlb_range(pte_t *
 
 		err = add_to_pagemap(&pme, pm);
 		if (err)
-			return err;
+			break;
 		if (pm->show_pfn && (flags & PM_PRESENT))
 			frame++;
 	}
 
+	spin_unlock(ptl);
 	cond_resched();
 
 	return err;
@@ -3132,17 +3135,22 @@ static int gather_pte_stats(pmd_t *pmd,
 static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
-	pte_t huge_pte = huge_ptep_get(walk->mm, addr, pte);
+	pte_t huge_pte;
 	struct numa_maps *md;
 	struct page *page;
+	spinlock_t *ptl;
 
+	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
+	huge_pte = huge_ptep_get(walk->mm, addr, pte);
 	if (!pte_present(huge_pte))
-		return 0;
+		goto out;
 
 	page = pte_page(huge_pte);
 
 	md = walk->private;
 	gather_stats(page, md, pte_dirty(huge_pte), 1);
+out:
+	spin_unlock(ptl);
 	return 0;
 }
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch


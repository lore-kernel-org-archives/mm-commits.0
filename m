Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF9E171A5
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718133051; cv=none; b=CbypTfHYDl2mlcXAs4ds2O/qSQ353gIuGaUmaJCxlbDpFBc98FtNCr+kAuwzzEYDUH9dR6XFErItjnRDknd2nXtRZgwr+dohCPg1PPlC8jeUyM3gKXJS9yLpAiWhQPpH5ZYk+CxW22nEDXLZWIsBXO0BPbZ43/El4RfHTvQWWHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718133051; c=relaxed/simple;
	bh=o7rixn1S47mAa7sf6x5cCmegLorWtnkCz7rMo6qFuW8=;
	h=Date:To:From:Subject:Message-Id; b=tnzKlu5/GQJgkLzzBCb8Tw4GfIe4da/6iECfb7qX9gFOCqBvaCbHuwJLwYr8uw47XyKmJps6GhPEJxYH7kD1Im4li6i7VgwVTYfotgTZzl+NYUUcpROwFuBUaFqio82/+/v380loHTjhlleMVeeLox6fvkihhMR7TWB6WGz8UfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MkhfZxBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MkhfZxBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B588DC2BD10;
	Tue, 11 Jun 2024 19:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718133050;
	bh=o7rixn1S47mAa7sf6x5cCmegLorWtnkCz7rMo6qFuW8=;
	h=Date:To:From:Subject:From;
	b=MkhfZxBWOgLTFJ03KkzrkgYbMyJq4xqf3ltkKVH2C05cnuNsBswDWcS8qqVVl/obk
	 2B01YlymgKdS0O8Mkljfg/1kn21CMeFIDYkBC6fDH2B2L49I1wRg1OVHMamIoCrAKg
	 ADjYbwlGCEiZ2joys6dtTiouekgUNzDVRpWoGfsM=
Date: Tue, 11 Jun 2024 12:10:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-extend-finish_fault-to-support-large-folio.patch added to mm-unstable branch
Message-Id: <20240611191050.B588DC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory: extend finish_fault() to support large folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-extend-finish_fault-to-support-large-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-extend-finish_fault-to-support-large-folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: memory: extend finish_fault() to support large folio
Date: Tue, 11 Jun 2024 18:11:05 +0800

Patch series "add mTHP support for anonymous shmem", v5.

Anonymous pages have already been supported for multi-size (mTHP)
allocation through commit 19eaf44954df, that can allow THP to be
configured through the sysfs interface located at
'/sys/kernel/mm/transparent_hugepage/hugepage-XXkb/enabled'.

However, the anonymous shmem will ignore the anonymous mTHP rule
configured through the sysfs interface, and can only use the PMD-mapped
THP, that is not reasonable.  Many implement anonymous page sharing
through mmap(MAP_SHARED | MAP_ANONYMOUS), especially in database usage
scenarios, therefore, users expect to apply an unified mTHP strategy for
anonymous pages, also including the anonymous shared pages, in order to
enjoy the benefits of mTHP.  For example, lower latency than PMD-mapped
THP, smaller memory bloat than PMD-mapped THP, contiguous PTEs on ARM
architecture to reduce TLB miss etc.

As discussed in the bi-weekly MM meeting[1], the mTHP controls should
control all of shmem, not only anonymous shmem, but support will be added
iteratively.  Therefore, this patch set starts with support for anonymous
shmem.

The primary strategy is similar to supporting anonymous mTHP.  Introduce a
new interface '/mm/transparent_hugepage/hugepage-XXkb/shmem_enabled',
which can have almost the same values as the top-level
'/sys/kernel/mm/transparent_hugepage/shmem_enabled', with adding a new
additional "inherit" option and dropping the testing options 'force' and
'deny'.  By default all sizes will be set to "never" except PMD size,
which is set to "inherit".  This ensures backward compatibility with the
anonymous shmem enabled of the top level, meanwhile also allows
independent control of anonymous shmem enabled for each mTHP.

Use the page fault latency tool to measure the performance of 1G anonymous shmem
with 32 threads on my machine environment with: ARM64 Architecture, 32 cores,
125G memory:
base: mm-unstable
user-time    sys_time    faults_per_sec_per_cpu     faults_per_sec
0.04s        3.10s         83516.416                  2669684.890

mm-unstable + patchset, anon shmem mTHP disabled
user-time    sys_time    faults_per_sec_per_cpu     faults_per_sec
0.02s        3.14s         82936.359                  2630746.027

mm-unstable + patchset, anon shmem 64K mTHP enabled
user-time    sys_time    faults_per_sec_per_cpu     faults_per_sec
0.08s        0.31s         678630.231                 17082522.495

From the data above, it is observed that the patchset has a minimal impact
when mTHP is not enabled (some fluctuations observed during testing). 
When enabling 64K mTHP, there is a significant improvement of the page
fault latency.

[1] https://lore.kernel.org/all/f1783ff0-65bd-4b2b-8952-52b6822a0835@redhat.com/


This patch (of 6):

Add large folio mapping establishment support for finish_fault() as a
preparation, to support multi-size THP allocation of anonymous shmem pages
in the following patches.

Keep the same behavior (per-page fault) for non-anon shmem to avoid
inflating the RSS unintentionally, and we can discuss what size of mapping
to build when extending mTHP to control non-anon shmem in the future.

Link: https://lkml.kernel.org/r/cover.1718090413.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/3a190892355989d42f59cf9f2f98b94694b0d24d.1718090413.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   57 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-memory-extend-finish_fault-to-support-large-folio
+++ a/mm/memory.c
@@ -4825,9 +4825,12 @@ vm_fault_t finish_fault(struct vm_fault
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
+	struct folio *folio;
 	vm_fault_t ret;
 	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
 		      !(vma->vm_flags & VM_SHARED);
+	int type, nr_pages;
+	unsigned long addr = vmf->address;
 
 	/* Did we COW the page? */
 	if (is_cow)
@@ -4858,24 +4861,58 @@ vm_fault_t finish_fault(struct vm_fault
 			return VM_FAULT_OOM;
 	}
 
+	folio = page_folio(page);
+	nr_pages = folio_nr_pages(folio);
+
+	/*
+	 * Using per-page fault to maintain the uffd semantics, and same
+	 * approach also applies to non-anonymous-shmem faults to avoid
+	 * inflating the RSS of the process.
+	 */
+	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma))) {
+		nr_pages = 1;
+	} else if (nr_pages > 1) {
+		pgoff_t idx = folio_page_idx(folio, page);
+		/* The page offset of vmf->address within the VMA. */
+		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
+
+		/*
+		 * Fallback to per-page fault in case the folio size in page
+		 * cache beyond the VMA limits.
+		 */
+		if (unlikely(vma_off < idx ||
+			     vma_off + (nr_pages - idx) > vma_pages(vma))) {
+			nr_pages = 1;
+		} else {
+			/* Now we can set mappings for the whole large folio. */
+			addr = vmf->address - idx * PAGE_SIZE;
+			page = &folio->page;
+		}
+	}
+
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-				      vmf->address, &vmf->ptl);
+				       addr, &vmf->ptl);
 	if (!vmf->pte)
 		return VM_FAULT_NOPAGE;
 
 	/* Re-check under ptl */
-	if (likely(!vmf_pte_changed(vmf))) {
-		struct folio *folio = page_folio(page);
-		int type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
-
-		set_pte_range(vmf, folio, page, 1, vmf->address);
-		add_mm_counter(vma->vm_mm, type, 1);
-		ret = 0;
-	} else {
-		update_mmu_tlb(vma, vmf->address, vmf->pte);
+	if (nr_pages == 1 && unlikely(vmf_pte_changed(vmf))) {
+		update_mmu_tlb(vma, addr, vmf->pte);
 		ret = VM_FAULT_NOPAGE;
+		goto unlock;
+	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
+		update_mmu_tlb_range(vma, addr, vmf->pte, nr_pages);
+		ret = VM_FAULT_NOPAGE;
+		goto unlock;
 	}
 
+	folio_ref_add(folio, nr_pages - 1);
+	set_pte_range(vmf, folio, page, nr_pages, addr);
+	type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
+	add_mm_counter(vma->vm_mm, type, nr_pages);
+	ret = 0;
+
+unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch


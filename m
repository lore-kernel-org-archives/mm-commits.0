Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F9313CAA8
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711480279; cv=none; b=c648iKD/H9M7w+dyUNfHVGnMWG1Vj428qNmL4PIWs81KZfALvQbSXNPiCiEnhrAvfWr8BU+JlUcHR4ks9v9sOcSeTQn50EGMCGXHPSr7dIi2s8GDukeWC+mBTxEl4TrGere8EcoSTX7QifhBGT0PBr5CuMm0WwGgme9YlY3wMr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711480279; c=relaxed/simple;
	bh=R14tS06n/k7ufVvHlN8h2cjww+9IKgOpfnWBhV41LD4=;
	h=Date:To:From:Subject:Message-Id; b=aJTLmbnlR42G6J0z8jtNAFne7RSzbnUNhSa/+CmVtJ2nF4dwUxLMfx6ZVmNqxwzKiYS3y8cp5/JWH7Ame/h73YottviSYTRWXs9TlPTH044zvziiu8LkS51oc9apCFyVOoD1t496/2nofz8u9jMUKF6MdrdiqqxJ6/D/ae5YpGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bfuEF5Jm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bfuEF5Jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B563FC433F1;
	Tue, 26 Mar 2024 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711480278;
	bh=R14tS06n/k7ufVvHlN8h2cjww+9IKgOpfnWBhV41LD4=;
	h=Date:To:From:Subject:From;
	b=bfuEF5Jm0j7LqwiuT5+rWpvifMhGg2bVfWBr35gv0oMC1EAfpV8jTwP0h5UvrufgX
	 qRQp4Gx6PhuevpX5xVJfyWa2hT3XXW/T//y5Bk7TyKQHgGgXI7AHC2LdSCwNP73ljq
	 LWelmMbIolkpFJvj/ciOkro+a7Jmf4N1GP3bqeIU=
Date: Tue, 26 Mar 2024 12:11:18 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,mgorman@techsingularity.net,jhubbard@nvidia.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-multi-size-thp-numa-balancing.patch added to mm-unstable branch
Message-Id: <20240326191118.B563FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support multi-size THP numa balancing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-multi-size-thp-numa-balancing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-multi-size-thp-numa-balancing.patch

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
Subject: mm: support multi-size THP numa balancing
Date: Tue, 26 Mar 2024 19:51:25 +0800

Now the anonymous page allocation already supports multi-size THP (mTHP),
but the numa balancing still prohibits mTHP migration even though it is an
exclusive mapping, which is unreasonable.

Allow scanning mTHP:
Commit 859d4adc3415 ("mm: numa: do not trap faults on shared data section
pages") skips shared CoW pages' NUMA page migration to avoid shared data
segment migration. In addition, commit 80d47f5de5e3 ("mm: don't try to
NUMA-migrate COW pages that have other uses") change to use page_count()
to avoid GUP pages migration, that will also skip the mTHP numa scaning.
Theoretically, we can use folio_maybe_dma_pinned() to detect the GUP
issue, although there is still a GUP race, the issue seems to have been
resolved by commit 80d47f5de5e3. Meanwhile, use the folio_likely_mapped_shared()
to skip shared CoW pages though this is not a precise sharers count. To
check if the folio is shared, ideally we want to make sure every page is
mapped to the same process, but doing that seems expensive and using
the estimated mapcount seems can work when running autonuma benchmark.

Allow migrating mTHP:
As mentioned in the previous thread[1], large folios (including THP) are
more susceptible to false sharing issues among threads than 4K base page,
leading to pages ping-pong back and forth during numa balancing, which is
currently not easy to resolve. Therefore, as a start to support mTHP numa
balancing, we can follow the PMD mapped THP's strategy, that means we can
reuse the 2-stage filter in should_numa_migrate_memory() to check if the
mTHP is being heavily contended among threads (through checking the CPU id
and pid of the last access) to avoid false sharing at some degree. Thus,
we can restore all PTE maps upon the first hint page fault of a large folio
to follow the PMD mapped THP's strategy. In the future, we can continue to
optimize the NUMA balancing algorithm to avoid the false sharing issue with
large folios as much as possible.

Performance data:
Machine environment: 2 nodes, 128 cores Intel(R) Xeon(R) Platinum
Base: 2024-03-25 mm-unstable branch
Enable mTHP to run autonuma-benchmark

mTHP:16K
Base				Patched
numa01				numa01
224.70				137.23
numa01_THREAD_ALLOC		numa01_THREAD_ALLOC
118.05				50.57
numa02				numa02
13.45				9.30
numa02_SMT			numa02_SMT
14.80				7.43

mTHP:64K
Base				Patched
numa01				numa01
216.15				135.20
numa01_THREAD_ALLOC		numa01_THREAD_ALLOC
115.35				46.93
numa02				numa02
13.24				9.24
numa02_SMT			numa02_SMT
14.67				7.31

mTHP:128K
Base				Patched
numa01				numa01
205.13				140.41
numa01_THREAD_ALLOC		numa01_THREAD_ALLOC
112.93				44.78
numa02				numa02
13.16				9.19
numa02_SMT			numa02_SMT
14.81				7.39

[1] https://lore.kernel.org/all/20231117100745.fnpijbk4xgmals3k@techsingularity.net/
Link: https://lkml.kernel.org/r/dee4268f1797f31c6bb6bdab30f8ad3df9053d3d.1711453317.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |   56 +++++++++++++++++++++++++++++++++++++++++-------
 mm/mprotect.c |    3 +-
 2 files changed, 50 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-support-multi-size-thp-numa-balancing
+++ a/mm/memory.c
@@ -5068,16 +5068,55 @@ static void numa_rebuild_single_mapping(
 	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 }
 
+static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_struct *vma,
+				       struct folio *folio, pte_t fault_pte, bool ignore_writable)
+{
+	int nr = pte_pfn(fault_pte) - folio_pfn(folio);
+	unsigned long start = max(vmf->address - nr * PAGE_SIZE, vma->vm_start);
+	unsigned long end = min(start + folio_nr_pages(folio) * PAGE_SIZE, vma->vm_end);
+	pte_t *start_ptep = vmf->pte - (vmf->address - start) / PAGE_SIZE;
+	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
+	unsigned long addr;
+
+	/* Restore all PTEs' mapping of the large folio */
+	for (addr = start; addr != end; start_ptep++, addr += PAGE_SIZE) {
+		pte_t pte, old_pte;
+		pte_t ptent = ptep_get(start_ptep);
+		bool writable = false;
+
+		if (!pte_present(ptent) || !pte_protnone(ptent))
+			continue;
+
+		if (vm_normal_folio(vma, addr, ptent) != folio)
+			continue;
+
+		if (!ignore_writable) {
+			writable = pte_write(pte);
+			if (!writable && pte_write_upgrade &&
+			    can_change_pte_writable(vma, addr, pte))
+				writable = true;
+		}
+
+		old_pte = ptep_modify_prot_start(vma, addr, start_ptep);
+		pte = pte_modify(old_pte, vma->vm_page_prot);
+		pte = pte_mkyoung(pte);
+		if (writable)
+			pte = pte_mkwrite(pte, vma);
+		ptep_modify_prot_commit(vma, addr, start_ptep, old_pte, pte);
+		update_mmu_cache_range(vmf, vma, addr, start_ptep, 1);
+	}
+}
+
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct folio *folio = NULL;
 	int nid = NUMA_NO_NODE;
-	bool writable = false;
+	bool writable = false, ignore_writable = false;
 	int last_cpupid;
 	int target_nid;
 	pte_t pte, old_pte;
-	int flags = 0;
+	int flags = 0, nr_pages;
 
 	/*
 	 * The pte cannot be used safely until we verify, while holding the page
@@ -5107,10 +5146,6 @@ static vm_fault_t do_numa_page(struct vm
 	if (!folio || folio_is_zone_device(folio))
 		goto out_map;
 
-	/* TODO: handle PTE-mapped THP */
-	if (folio_test_large(folio))
-		goto out_map;
-
 	/*
 	 * Avoid grouping on RO pages in general. RO pages shouldn't hurt as
 	 * much anyway since they can be in shared cache state. This misses
@@ -5130,6 +5165,7 @@ static vm_fault_t do_numa_page(struct vm
 		flags |= TNF_SHARED;
 
 	nid = folio_nid(folio);
+	nr_pages = folio_nr_pages(folio);
 	/*
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
@@ -5146,6 +5182,7 @@ static vm_fault_t do_numa_page(struct vm
 	}
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	writable = false;
+	ignore_writable = true;
 
 	/* Migrate to the requested node */
 	if (migrate_misplaced_folio(folio, vma, target_nid)) {
@@ -5166,14 +5203,17 @@ static vm_fault_t do_numa_page(struct vm
 
 out:
 	if (nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, nid, 1, flags);
+		task_numa_fault(last_cpupid, nid, nr_pages, flags);
 	return 0;
 out_map:
 	/*
 	 * Make it present again, depending on how arch implements
 	 * non-accessible ptes, some can allow access by kernel mode.
 	 */
-	numa_rebuild_single_mapping(vmf, vma, writable);
+	if (folio && folio_test_large(folio))
+		numa_rebuild_large_mapping(vmf, vma, folio, pte, ignore_writable);
+	else
+		numa_rebuild_single_mapping(vmf, vma, writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	goto out;
 }
--- a/mm/mprotect.c~mm-support-multi-size-thp-numa-balancing
+++ a/mm/mprotect.c
@@ -129,7 +129,8 @@ static long change_pte_range(struct mmu_
 
 				/* Also skip shared copy-on-write pages */
 				if (is_cow_mapping(vma->vm_flags) &&
-				    folio_ref_count(folio) != 1)
+				    (folio_maybe_dma_pinned(folio) ||
+				     folio_likely_mapped_shared(folio)))
 					continue;
 
 				/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch


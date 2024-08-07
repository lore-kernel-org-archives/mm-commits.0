Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC38358203
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 19:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059470; cv=none; b=QwpsHyJ9SBWyz70wU18c9J4oA51V0U91HUvCJ+tENWWnHIVAEvN0RnidTrGKqCXMJxJj/08OoAp5vBKuwZOFIdjO238YiWiCerzqKV3ve98GYRl+GBVMIop2Mg63Kz18HYlsfJl5nIzjEdEeetTK1PAECOENCFBAjyGr83RnEuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059470; c=relaxed/simple;
	bh=R1uvIFQ+Bru2anGahIWvCfIGoNziFyd7sqbSGfximVo=;
	h=Date:To:From:Subject:Message-Id; b=Y8jPk9D5qJJ31ksHz2h8kHUBdGQkpts/Io2pScP7qYQzWs8JmRdlNiwJmkr9iIKvvJQBuQlgtFxeqgXgM75/f+BlA354Wo2JXkYGzAZTSKmAvieE7EvgmKLzc3tmx1l3BV9X4nRHZ2aEj9TerKRGk+NX0JycR9z6LJyh99ImdJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2N0x3C3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2N0x3C3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A08C32781;
	Wed,  7 Aug 2024 19:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723059470;
	bh=R1uvIFQ+Bru2anGahIWvCfIGoNziFyd7sqbSGfximVo=;
	h=Date:To:From:Subject:From;
	b=2N0x3C3NYdlDXKORE3KXa1ccfYDz8w/KST2hCFH5JXS5UTDskyBI1PyZICM/4DAWv
	 GzjZekGj8Ajxi+52cqZX4Ur1HOMzmMuNmv9G01X9+IcWpmP3QH9htsvyZbsHrRoJIw
	 wsjGmr+hnC2LLsv2IJ3mnuc/lCJwP9920DRSzR1I=
Date: Wed, 07 Aug 2024 12:37:49 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch added to mm-unstable branch
Message-Id: <20240807193750.42A08C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: move common code to numa_migrate_check (was numa_migrate_prep)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: move common code to numa_migrate_check (was numa_migrate_prep)
Date: Wed, 7 Aug 2024 14:47:30 -0400

do_numa_page() and do_huge_pmd_numa_page() share a lot of common code.  To
reduce redundancy, move common code to numa_migrate_prep() and rename the
function to numa_migrate_check() to reflect its functionality.

Now do_huge_pmd_numa_page() also checks shared folios to set TNF_SHARED
flag.

Link: https://lkml.kernel.org/r/20240807184730.1266736-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 +-------
 mm/internal.h    |    5 +-
 mm/memory.c      |   76 ++++++++++++++++++++++-----------------------
 3 files changed, 44 insertions(+), 51 deletions(-)

--- a/mm/huge_memory.c~mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep
+++ a/mm/huge_memory.c
@@ -1723,18 +1723,10 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	if (!folio)
 		goto out_map;
 
-	/* See similar comment in do_numa_page for explanation */
-	if (!writable)
-		flags |= TNF_NO_GROUP;
-
 	nid = folio_nid(folio);
-	/*
-	 * For memory tiering mode, cpupid of slow memory page is used
-	 * to record page access time.  So use default value.
-	 */
-	if (!folio_use_access_time(folio))
-		last_cpupid = folio_last_cpupid(folio);
-	target_nid = numa_migrate_prep(folio, vmf, haddr, nid, &flags);
+
+	target_nid = numa_migrate_check(folio, vmf, haddr, &flags, writable,
+					&last_cpupid);
 	if (target_nid == NUMA_NO_NODE)
 		goto out_map;
 	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
--- a/mm/internal.h~mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep
+++ a/mm/internal.h
@@ -1193,8 +1193,9 @@ void vunmap_range_noflush(unsigned long
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
-int numa_migrate_prep(struct folio *folio, struct vm_fault *vmf,
-		      unsigned long addr, int page_nid, int *flags);
+int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
+		      unsigned long addr, int *flags, bool writable,
+		      int *last_cpupid);
 
 void free_zone_device_folio(struct folio *folio);
 int migrate_device_coherent_page(struct page *page);
--- a/mm/memory.c~mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep
+++ a/mm/memory.c
@@ -5368,16 +5368,43 @@ static vm_fault_t do_fault(struct vm_fau
 	return ret;
 }
 
-int numa_migrate_prep(struct folio *folio, struct vm_fault *vmf,
-		      unsigned long addr, int page_nid, int *flags)
+int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
+		      unsigned long addr, int *flags,
+		      bool writable, int *last_cpupid)
 {
 	struct vm_area_struct *vma = vmf->vma;
 
+	/*
+	 * Avoid grouping on RO pages in general. RO pages shouldn't hurt as
+	 * much anyway since they can be in shared cache state. This misses
+	 * the case where a mapping is writable but the process never writes
+	 * to it but pte_write gets cleared during protection updates and
+	 * pte_dirty has unpredictable behaviour between PTE scan updates,
+	 * background writeback, dirty balancing and application behaviour.
+	 */
+	if (!writable)
+		*flags |= TNF_NO_GROUP;
+
+	/*
+	 * Flag if the folio is shared between multiple address spaces. This
+	 * is later used when determining whether to group tasks together
+	 */
+	if (folio_likely_mapped_shared(folio) && (vma->vm_flags & VM_SHARED))
+		*flags |= TNF_SHARED;
+	/*
+	 * For memory tiering mode, cpupid of slow memory page is used
+	 * to record page access time.  So use default value.
+	 */
+	if (folio_use_access_time(folio))
+		*last_cpupid = (-1 & LAST_CPUPID_MASK);
+	else
+		*last_cpupid = folio_last_cpupid(folio);
+
 	/* Record the current PID acceesing VMA */
 	vma_set_access_pid_bit(vma);
 
 	count_vm_numa_event(NUMA_HINT_FAULTS);
-	if (page_nid == numa_node_id()) {
+	if (folio_nid(folio) == numa_node_id()) {
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
 		*flags |= TNF_FAULT_LOCAL;
 	}
@@ -5442,13 +5469,13 @@ static void numa_rebuild_large_mapping(s
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	pte_t old_pte = vmf->orig_pte;
+	pte_t pte;
 	struct folio *folio = NULL;
 	int nid = NUMA_NO_NODE;
 	bool writable = false, ignore_writable = false;
 	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
-	int last_cpupid;
-	int target_nid;
-	pte_t pte, old_pte;
+	int target_nid, last_cpupid = (-1 & LAST_CPUPID_MASK);
 	int flags = 0, nr_pages;
 
 	/*
@@ -5456,10 +5483,7 @@ static vm_fault_t do_numa_page(struct vm
 	 * table lock, that its contents have not changed during fault handling.
 	 */
 	spin_lock(vmf->ptl);
-	/* Read the live PTE from the page tables: */
-	old_pte = ptep_get(vmf->pte);
-
-	if (unlikely(!pte_same(old_pte, vmf->orig_pte))) {
+	if (unlikely(!pte_same(old_pte, ptep_get(vmf->pte)))) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		goto out;
 	}
@@ -5479,35 +5503,11 @@ static vm_fault_t do_numa_page(struct vm
 	if (!folio || folio_is_zone_device(folio))
 		goto out_map;
 
-	/*
-	 * Avoid grouping on RO pages in general. RO pages shouldn't hurt as
-	 * much anyway since they can be in shared cache state. This misses
-	 * the case where a mapping is writable but the process never writes
-	 * to it but pte_write gets cleared during protection updates and
-	 * pte_dirty has unpredictable behaviour between PTE scan updates,
-	 * background writeback, dirty balancing and application behaviour.
-	 */
-	if (!writable)
-		flags |= TNF_NO_GROUP;
-
-	/*
-	 * Flag if the folio is shared between multiple address spaces. This
-	 * is later used when determining whether to group tasks together
-	 */
-	if (folio_likely_mapped_shared(folio) && (vma->vm_flags & VM_SHARED))
-		flags |= TNF_SHARED;
-
 	nid = folio_nid(folio);
 	nr_pages = folio_nr_pages(folio);
-	/*
-	 * For memory tiering mode, cpupid of slow memory page is used
-	 * to record page access time.  So use default value.
-	 */
-	if (folio_use_access_time(folio))
-		last_cpupid = (-1 & LAST_CPUPID_MASK);
-	else
-		last_cpupid = folio_last_cpupid(folio);
-	target_nid = numa_migrate_prep(folio, vmf, vmf->address, nid, &flags);
+
+	target_nid = numa_migrate_check(folio, vmf, vmf->address, &flags,
+					writable, &last_cpupid);
 	if (target_nid == NUMA_NO_NODE)
 		goto out_map;
 	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
@@ -5529,7 +5529,7 @@ static vm_fault_t do_numa_page(struct vm
 					       vmf->address, &vmf->ptl);
 		if (unlikely(!vmf->pte))
 			goto out;
-		if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+		if (unlikely(!pte_same(old_pte, ptep_get(vmf->pte)))) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			goto out;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-numa-no-task_numa_fault-call-if-page-table-is-changed.patch
memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch
mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch


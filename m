Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0203428E7
	for <mm-commits@vger.kernel.org>; Fri,  9 Aug 2024 03:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723173609; cv=none; b=DFpj7op68D92QpNnMXOn+678ajgReNjSfBJX878+li5QlF1AZkp0dQvUOo8Bs2ETRIp6nWc2vh2YCDg/ZCN7jQrkcLNhwYEKB7OMdygNR+Kaaj8eGMqZFmWEP410BxQevWheoO3D/pml+TbB7kS916QDMag8xyFJRnMxsEdmFdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723173609; c=relaxed/simple;
	bh=SdeKM2xXpSh+WXlbviMD/8ixVXIKB8e+KKeAQMUBVlg=;
	h=Date:To:From:Subject:Message-Id; b=tMEr4kxbP2g73oOiXgTfivrgv+/2IRGs8GkuH1VN/GyORdmAf3qi+MBKc3RCXtPSQonDOxvMSPwjwmoJNzeLz6yRPm0Rn2RJra8La0daamV9bR5gCImltBBw33Rbq6yM/RQcqY/N7zsNaxyNg27S6iCHWP+eu0dcHA3S/7++fwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6a4v1mg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6a4v1mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6766AC32782;
	Fri,  9 Aug 2024 03:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723173608;
	bh=SdeKM2xXpSh+WXlbviMD/8ixVXIKB8e+KKeAQMUBVlg=;
	h=Date:To:From:Subject:From;
	b=f6a4v1mgm+nxImuoighaVFput1PIMqTnq1fkC8PqqNj/Rw15Z3Mg11i7oI9iY+grV
	 t1UFL2JArQ3sE33am6gs/AqDZtiHVqTl2mdTrwdaCFm6GeI3WghW5Rrez5qIq3JXgz
	 nxgxgmpZdY7ekJe2pWmyCkuUdvjP/Ogd0Eyx3ZvQ=
Date: Thu, 08 Aug 2024 20:20:07 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch added to mm-unstable branch
Message-Id: <20240809032008.6766AC32782@smtp.kernel.org>
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
Date: Thu, 8 Aug 2024 19:37:28 -0400

do_numa_page() and do_huge_pmd_numa_page() share a lot of common code.  To
reduce redundancy, move common code to numa_migrate_prep() and rename the
function to numa_migrate_check() to reflect its functionality.

Now do_huge_pmd_numa_page() also checks shared folios to set TNF_SHARED
flag.

Link: https://lkml.kernel.org/r/20240808233728.1477034-1-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   29 +++++++-------------
 mm/internal.h    |    5 ++-
 mm/memory.c      |   63 +++++++++++++++++++++++----------------------
 3 files changed, 47 insertions(+), 50 deletions(-)

--- a/mm/huge_memory.c~mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep
+++ a/mm/huge_memory.c
@@ -1753,22 +1753,23 @@ static inline bool can_change_pmd_writab
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	pmd_t oldpmd = vmf->orig_pmd;
-	pmd_t pmd;
 	struct folio *folio;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	int nid = NUMA_NO_NODE;
-	int target_nid, last_cpupid = (-1 & LAST_CPUPID_MASK);
+	int target_nid, last_cpupid;
+	pmd_t pmd, old_pmd;
 	bool writable = false;
 	int flags = 0;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
+	old_pmd = pmdp_get(vmf->pmd);
+
+	if (unlikely(!pmd_same(old_pmd, vmf->orig_pmd))) {
 		spin_unlock(vmf->ptl);
 		return 0;
 	}
 
-	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
+	pmd = pmd_modify(old_pmd, vma->vm_page_prot);
 
 	/*
 	 * Detect now whether the PMD could be writable; this information
@@ -1783,18 +1784,10 @@ vm_fault_t do_huge_pmd_numa_page(struct
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
@@ -1812,7 +1805,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	} else {
 		flags |= TNF_MIGRATE_FAIL;
 		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-		if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
+		if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd))) {
 			spin_unlock(vmf->ptl);
 			return 0;
 		}
@@ -1820,7 +1813,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 
 out_map:
 	/* Restore the PMD */
-	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
+	pmd = pmd_modify(pmdp_get(vmf->pmd), vma->vm_page_prot);
 	pmd = pmd_mkyoung(pmd);
 	if (writable)
 		pmd = pmd_mkwrite(pmd, vma);
--- a/mm/internal.h~mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep
+++ a/mm/internal.h
@@ -1191,8 +1191,9 @@ void vunmap_range_noflush(unsigned long
 
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
@@ -5364,16 +5364,43 @@ static vm_fault_t do_fault(struct vm_fau
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
@@ -5475,35 +5502,11 @@ static vm_fault_t do_numa_page(struct vm
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
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-numa-no-task_numa_fault-call-if-page-table-is-changed.patch
mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix.patch
memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch
mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch


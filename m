Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F721474A5
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 23:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723159575; cv=none; b=iVS0mBs2PU1jQrAygJqHyXU8pxiD4U4kAbkujJAJ5iJ5AfLlJ1559Vi2WiLNJyNa+Mh78ZF9RLF0qrJA+slyc5m0xH0xjQCDeBerQg84dMdF8VVfEBjirvE53TbaqUCkW7HgC4u33qDpRuqzpdIpA1yQblBNowJ5DLe080RZytw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723159575; c=relaxed/simple;
	bh=g4PIgIwTxNfn8xJu9mDIlwKn7gQ8BcoBhjUfYwOR5x0=;
	h=Date:To:From:Subject:Message-Id; b=oxl30ANayf/zZOETYChEq/AVHqDEyavweoCH5E9OGXQv0xFijTJlTglcEjsEQSfySaTzVHebwf4PW+2J09ineMSOz+C5/eqAD9sk0PCmJIJpDwC7jXFWajKod0OWnAcXtj+zU0jr9mbqfc5XyirwJiK8KcruDwdZUxtZ/aasLIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GZvDB+Ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GZvDB+Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063F9C32782;
	Thu,  8 Aug 2024 23:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723159575;
	bh=g4PIgIwTxNfn8xJu9mDIlwKn7gQ8BcoBhjUfYwOR5x0=;
	h=Date:To:From:Subject:From;
	b=GZvDB+Ul/2TsgrIsFz85lMes74N/gwkGUv+QLpGw4yI0QyA656jjXhyeaXB0m6+2T
	 xyTDAaTFfgjvOua6B5MEZBIgiqnTFt4h0cAqvmErjW8M4efW+Ki6H7g618S1zMl22N
	 5/9AlSXcvL9otr4dC+AMo0YBmXxnlyf0TDJZOfjQ=
Date: Thu, 08 Aug 2024 16:26:14 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch removed from -mm tree
Message-Id: <20240808232615.063F9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: move common code to numa_migrate_check (was numa_migrate_prep)
has been removed from the -mm tree.  Its filename was
     mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch

This patch was dropped because an updated version will be issued

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
@@ -1699,18 +1699,10 @@ vm_fault_t do_huge_pmd_numa_page(struct
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
 		return 0;
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
@@ -5530,7 +5530,7 @@ static vm_fault_t do_numa_page(struct vm
 					       vmf->address, &vmf->ptl);
 		if (unlikely(!vmf->pte))
 			return 0;
-		if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+		if (unlikely(!pte_same(old_pte, ptep_get(vmf->pte)))) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return 0;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-numa-no-task_numa_fault-call-if-page-table-is-changed.patch
mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix.patch
memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch


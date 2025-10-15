Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC9F2FAC03
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 01:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760492224; cv=none; b=KcZKLvyluROseH8EJL41ozwL9AXUQuNBZetkbN1XGcdbe1D47Rxr6NFL7p9T8MOdLr1S1E6DFfknnK82OeTjZR0b9DYSTnDcs2t1KuFjnHxPpC2fieMuQn7wipdDA2XhD0nb39b2rUeST2TFITyCGCcgv5yoOWydMXovslf953U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760492224; c=relaxed/simple;
	bh=VvLsuUvbPSCv/pGJgGF7vovs6FXeC81JpdzXZXJ0+qM=;
	h=Date:To:From:Subject:Message-Id; b=iGu04TIUKwLDqLyHPpaSh8MphSf10HpiFsZEq4auSpgCph/bfaR78HrJUs5T2LiTqIkiSWDSI5NyM+QCN9qtna8ZOv8GPNzxSHET9ckFLBOO3AMFAfh5ciVqLPI4lxfgxG/+rn1oeyBZs+rIpHghnqUe4osnQo/EhYDDJphegL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fRGWpjuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fRGWpjuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D173C4CEE7;
	Wed, 15 Oct 2025 01:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760492223;
	bh=VvLsuUvbPSCv/pGJgGF7vovs6FXeC81JpdzXZXJ0+qM=;
	h=Date:To:From:Subject:From;
	b=fRGWpjuTn2M1R8EPUnbbVuLVl4PBOgw94QVtjoW9U/lIuTunB8rZxeu8nKbrW3veN
	 eXL5wAP9EVq/23WDx4GJcMrSg2th3RsSGZthXLV4saC6Q5wDhaE7CKZqpPNZraOWna
	 gM3wRJ6HzfzubgJ1i5sHofArDPVlP5WsvRcYwx4M=
Date: Tue, 14 Oct 2025 18:37:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio.patch added to mm-new branch
Message-Id: <20251015013703.7D173C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: use folio_skip_prot_numa() for pmd folio
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use folio_skip_prot_numa() for pmd folio
Date: Tue, 14 Oct 2025 19:33:49 +0800

Rename prot_numa_skip() to folio_skip_prot_numa(), and remove ret by
directly return value instead of goto style.

The folio skip checks for prot numa should be suitable for pmd folio too,
which helps to avoid unnecessary pmd change and folio migration attempts.

Link: https://lkml.kernel.org/r/20251014113349.2618158-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 +++++++--------------
 mm/internal.h    |    2 ++
 mm/mprotect.c    |   35 ++++++++++++++---------------------
 3 files changed, 23 insertions(+), 35 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio
+++ a/mm/huge_memory.c
@@ -2477,8 +2477,7 @@ int change_huge_pmd(struct mmu_gather *t
 #endif
 
 	if (prot_numa) {
-		struct folio *folio;
-		bool toptier;
+		int target_node = NUMA_NO_NODE;
 		/*
 		 * Avoid trapping faults against the zero page. The read-only
 		 * data is likely to be read-cached on the local CPU and
@@ -2490,19 +2489,13 @@ int change_huge_pmd(struct mmu_gather *t
 		if (pmd_protnone(*pmd))
 			goto unlock;
 
-		folio = pmd_folio(*pmd);
-		toptier = node_is_toptier(folio_nid(folio));
-		/*
-		 * Skip scanning top tier node if normal numa
-		 * balancing is disabled
-		 */
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-		    toptier)
-			goto unlock;
+		/* Get target node for single threaded private VMAs */
+		if (!(vma->vm_flags & VM_SHARED) &&
+		    atomic_read(&vma->vm_mm->mm_users) == 1)
+			target_node = numa_node_id();
 
-		if (folio_use_access_time(folio))
-			folio_xchg_access_time(folio,
-					       jiffies_to_msecs(jiffies));
+		if (folio_skip_prot_numa(pmd_folio(*pmd), vma, target_node))
+			goto unlock;
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
--- a/mm/internal.h~mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio
+++ a/mm/internal.h
@@ -1381,6 +1381,8 @@ void vunmap_range_noflush(unsigned long
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
+bool folio_skip_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		int target_node);
 int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int *flags, bool writable,
 		      int *last_cpupid);
--- a/mm/mprotect.c~mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio
+++ a/mm/mprotect.c
@@ -118,26 +118,21 @@ static int mprotect_folio_pte_batch(stru
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
 }
 
-static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
-		struct folio *folio)
+bool folio_skip_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		int target_node)
 {
-	bool ret = true;
-	bool toptier;
 	int nid;
 
-	if (!folio)
-		goto skip;
-
-	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
-		goto skip;
+	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+		return true;
 
 	/* Also skip shared copy-on-write folios */
 	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
-		goto skip;
+		return true;
 
 	/* Folios are pinned and can't be migrated */
 	if (folio_maybe_dma_pinned(folio))
-		goto skip;
+		return true;
 
 	/*
 	 * While migration can move some dirty pages,
@@ -145,7 +140,7 @@ static bool prot_numa_skip(struct vm_are
 	 * context.
 	 */
 	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
-		goto skip;
+		return true;
 
 	/*
 	 * Don't mess with PTEs if page is already on the node
@@ -153,23 +148,20 @@ static bool prot_numa_skip(struct vm_are
 	 */
 	nid = folio_nid(folio);
 	if (target_node == nid)
-		goto skip;
-
-	toptier = node_is_toptier(nid);
+		return true;
 
 	/*
 	 * Skip scanning top tier node if normal numa
 	 * balancing is disabled
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
-		goto skip;
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
+	    node_is_toptier(nid))
+		return true;
 
-	ret = false;
 	if (folio_use_access_time(folio))
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
-skip:
-	return ret;
+	return false;
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
@@ -314,7 +306,8 @@ static long change_pte_range(struct mmu_
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
 			 */
-			if (prot_numa & prot_numa_skip(vma, target_node, folio)) {
+			if (prot_numa & folio_skip_prot_numa(folio, vma,
+							     target_node)) {
 				/* determine batch to skip */
 				nr_ptes = mprotect_folio_pte_batch(folio,
 					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch
mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch
mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio.patch


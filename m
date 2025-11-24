Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFF42F7AC5
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025787; cv=none; b=StecoegQ/BUiHnwZ0x7XboM6e9JcClPnCv2JWIvHpKIbcb3HGolLn+ioBRpJi1t4DTBk1Lhf7DZSrNJSQeORi2cv0Mo7tJG2uUBPlBRUlKkOf2oa73XKReGAyDrnaqRj++tN3HGQsgIlhyoviLvMZRBNAJVXyaCLmJFEsumcjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025787; c=relaxed/simple;
	bh=Eegys77TZUPT9jO4RVu4ynhZ14Z5XkYBpvNuSDP7qsM=;
	h=Date:To:From:Subject:Message-Id; b=f65Zl2kOqW6XPw6ayeGuPelwM/zryailIDwWvhZNrThQ8F/G5sx/LItKP4E+1hf9IongaGSbswWHXROsgQ764dYJAIYnoU11jgDDcL+UzCAlxY2u9p0edHSZpNqAV/KVv35IZHbh2PZGpEECL657LLxDj7i7Y16iPZwgAqlWS+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rjw529kx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rjw529kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB054C4CEF1;
	Mon, 24 Nov 2025 23:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025787;
	bh=Eegys77TZUPT9jO4RVu4ynhZ14Z5XkYBpvNuSDP7qsM=;
	h=Date:To:From:Subject:From;
	b=rjw529kx0HLkiLbuq+BjwpDNhpXOPSri4D/g6+HVi/13R50CZbcWXJ4Whuy2Ulkv8
	 vJI2y6sZwgJY1X/J6NMpDBng4ETL0rNJgb/csyj4n1ULLwFFzy5WPcKGCj7XA9ttz2
	 rTfFRjAGVj6jo/Suu5ZED36FCu2VNBcMBn2KbBhQ=
Date: Mon, 24 Nov 2025 15:09:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch removed from -mm tree
Message-Id: <20251124230946.EB054C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory/fault: add THP fault handling for zone device private pages
has been removed from the -mm tree.  Its filename was
     mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm/memory/fault: add THP fault handling for zone device private pages
Date: Wed, 1 Oct 2025 16:56:59 +1000

Implement CPU fault handling for zone device THP entries through
do_huge_pmd_device_private(), enabling transparent migration of
device-private large pages back to system memory on CPU access.

When the CPU accesses a zone device THP entry, the fault handler calls the
device driver's migrate_to_ram() callback to migrate the entire large page
back to system memory.

Link: https://lkml.kernel.org/r/20251001065707.920170-9-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    7 +++++++
 mm/huge_memory.c        |   38 ++++++++++++++++++++++++++++++++++++++
 mm/memory.c             |    5 +++--
 3 files changed, 48 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages
+++ a/include/linux/huge_mm.h
@@ -481,6 +481,8 @@ static inline bool folio_test_pmd_mappab
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
+vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
+
 extern struct folio *huge_zero_folio;
 extern unsigned long huge_zero_pfn;
 
@@ -661,6 +663,11 @@ static inline vm_fault_t do_huge_pmd_num
 {
 	return 0;
 }
+
+static inline vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
+{
+	return 0;
+}
 
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
--- a/mm/huge_memory.c~mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages
+++ a/mm/huge_memory.c
@@ -1288,6 +1288,44 @@ release:
 
 }
 
+vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	vm_fault_t ret = 0;
+	spinlock_t *ptl;
+	swp_entry_t swp_entry;
+	struct page *page;
+	struct folio *folio;
+
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+
+	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd))) {
+		spin_unlock(ptl);
+		return 0;
+	}
+
+	swp_entry = pmd_to_swp_entry(vmf->orig_pmd);
+	page = pfn_swap_entry_to_page(swp_entry);
+	folio = page_folio(page);
+	vmf->page = page;
+	vmf->pte = NULL;
+	if (folio_trylock(folio)) {
+		folio_get(folio);
+		spin_unlock(ptl);
+		ret = page_pgmap(page)->ops->migrate_to_ram(vmf);
+		folio_unlock(folio);
+		folio_put(folio);
+	} else {
+		spin_unlock(ptl);
+	}
+
+	return ret;
+}
+
 /*
  * always: directly stall for all thp allocations
  * defer: wake kswapd and fail if not immediately available
--- a/mm/memory.c~mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages
+++ a/mm/memory.c
@@ -6345,8 +6345,9 @@ retry_pud:
 		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
 		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
-			VM_BUG_ON(thp_migration_supported() &&
-					  !is_pmd_migration_entry(vmf.orig_pmd));
+			if (is_pmd_device_private_entry(vmf.orig_pmd))
+				return do_huge_pmd_device_private(&vmf);
+
 			if (is_pmd_migration_entry(vmf.orig_pmd))
 				pmd_migration_entry_wait(mm, vmf.pmd);
 			return 0;
_

Patches currently in -mm which might be from balbirs@nvidia.com are



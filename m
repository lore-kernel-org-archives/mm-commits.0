Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7616245010
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 04:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757390443; cv=none; b=iPNxkHrkSoEJrI4ansgoDv/B4dYGmkYuNiBGjMX+pGIF5EgZWVhoAzczE6//zRotKVauT2k5OVPxJ8nqRlv3+0VKlQfbQUbjfHq4sYpYZSvwL6mplGkQ8z26kxiW55fSInTB7dLlxHUo12Q6iIdywYmwzeqt5nVehJwBNaK376Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757390443; c=relaxed/simple;
	bh=9MfsLLkLvyz3VYD8m5Yg+TFK2fNrJJM7k59jDBCw7Iw=;
	h=Date:To:From:Subject:Message-Id; b=FByNVSt0yN0PkRIFtYajiOAMHTCx1nkY3NJ0TUNct/MLOkawcwEIu8F/RK9O8ZGpx2CmpxUkBgvdTnLOCyUIeW8zM+j+VMV2ceHkNKEQ9zMPTWFjBs3wmPIKlrnWgN+NWD22GsBkrFS5NDJfA3lO7lyTNhwjmpz6/ydM1va3rGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mJEWpY2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mJEWpY2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E667C4CEF4;
	Tue,  9 Sep 2025 04:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757390443;
	bh=9MfsLLkLvyz3VYD8m5Yg+TFK2fNrJJM7k59jDBCw7Iw=;
	h=Date:To:From:Subject:From;
	b=mJEWpY2jZ15QwzK5S3XSb09mJsJ6f5ZJp8LKFvLOITUUryudPHm/4KSk1AFbS3b0X
	 jqV2D0e0ex5PADZNeADOT0zparSZvmiHGM6+W0wfLr6YOC6q2ffHx2bmApz9Y9Yhkx
	 vEjVm9jzIj+BBNo0CUKItrgKTEIWxmNwrsB6ZP9I=
Date: Mon, 08 Sep 2025 21:00:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch added to mm-new branch
Message-Id: <20250909040043.4E667C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory/fault: add THP fault handling for zone device private pages
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch

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
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm/memory/fault: add THP fault handling for zone device private pages
Date: Mon, 8 Sep 2025 10:04:40 +1000

Implement CPU fault handling for zone device THP entries through
do_huge_pmd_device_private(), enabling transparent migration of
device-private large pages back to system memory on CPU access.

When the CPU accesses a zone device THP entry, the fault handler calls the
device driver's migrate_to_ram() callback to migrate the entire large page
back to system memory.

Link: https://lkml.kernel.org/r/20250908000448.180088-8-balbirs@nvidia.com
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
 mm/huge_memory.c        |   36 ++++++++++++++++++++++++++++++++++++
 mm/memory.c             |    6 ++++--
 3 files changed, 47 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages
+++ a/include/linux/huge_mm.h
@@ -496,6 +496,8 @@ static inline bool folio_test_pmd_mappab
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
+vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
+
 extern struct folio *huge_zero_folio;
 extern unsigned long huge_zero_pfn;
 
@@ -670,6 +672,11 @@ static inline vm_fault_t do_huge_pmd_num
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
@@ -1287,6 +1287,42 @@ release:
 
 }
 
+vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	vm_fault_t ret = 0;
+	spinlock_t *ptl;
+	swp_entry_t swp_entry;
+	struct page *page;
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
+	vmf->page = page;
+	vmf->pte = NULL;
+	if (trylock_page(vmf->page)) {
+		get_page(page);
+		spin_unlock(ptl);
+		ret = page_pgmap(page)->ops->migrate_to_ram(vmf);
+		unlock_page(vmf->page);
+		put_page(page);
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
@@ -6303,8 +6303,10 @@ retry_pud:
 		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
 		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
-			VM_BUG_ON(thp_migration_supported() &&
-					  !is_pmd_migration_entry(vmf.orig_pmd));
+			if (is_device_private_entry(
+					pmd_to_swp_entry(vmf.orig_pmd)))
+				return do_huge_pmd_device_private(&vmf);
+
 			if (is_pmd_migration_entry(vmf.orig_pmd))
 				pmd_migration_entry_wait(mm, vmf.pmd);
 			return 0;
_

Patches currently in -mm which might be from balbirs@nvidia.com are

mm-zone_device-support-large-zone-device-private-folios.patch
mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch
mm-huge_memory-implement-device-private-thp-splitting.patch
mm-migrate_device-handle-partially-mapped-folios-during-collection.patch
mm-migrate_device-implement-thp-migration-of-zone-device-pages.patch
mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch
lib-test_hmm-add-zone-device-private-thp-test-infrastructure.patch
mm-memremap-add-driver-callback-support-for-folio-splitting.patch
mm-migrate_device-add-thp-splitting-during-migration.patch
lib-test_hmm-add-large-page-allocation-failure-testing.patch
selftests-mm-hmm-tests-new-tests-for-zone-device-thp-migration.patch
selftests-mm-hmm-tests-new-throughput-tests-including-thp.patch
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration.patch


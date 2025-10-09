Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F2D57C9F
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 03:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759979899; cv=none; b=EuNclXxtP7cCmVAekIyjwPwmuYq773zq5IS8T/QxC/ALnIUOwoSI3zRr+ttvyru8bO0f87QQEfoPu98AmqG45glF2TJMuxjJCKZ6xtXMVw5AcF+e2KOc/DUWjl3jW2mchYuedSLFyCAEhT06sxw6ptBlS+kXndCkwNeku91bL04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759979899; c=relaxed/simple;
	bh=WxDIsHFXkVjea8GrAuqj3b5scT/XF5zIrG1KqYLKAvs=;
	h=Date:To:From:Subject:Message-Id; b=kz90p3OisZ+Ysiy1hX7wm+X5vvGUVOZI6WgaiDedeHfV4Tz6dYvoXx+05TeTAShH9EY9EpSYqqqgphOAffJO71buDel3CihCRvaq5Z6cw8VyP/wWPM3byUYw8wDIh9XNqtMo3qJhpikOEY3RX7VCj0zFMyRz7Wzd4bY4b05pO4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MCfPiq0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MCfPiq0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA65C4CEE7;
	Thu,  9 Oct 2025 03:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759979898;
	bh=WxDIsHFXkVjea8GrAuqj3b5scT/XF5zIrG1KqYLKAvs=;
	h=Date:To:From:Subject:From;
	b=MCfPiq0sPzci1uYojShLOcZZ9DYqbPgKKRdD3DFtblpyWYTf42NPxn6qt5RVfg/5y
	 yE6SJxkMwxkHkcPq1IGoouZ1vTkcSS5Y4CdoCbZy/2fRmBQ9M/c0w26uCxQ+NMnaRO
	 Ybhyelt3z+IUnzNhiNH/Kaz05mrRrPrHLJscS/7A=
Date: Wed, 08 Oct 2025 20:18:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,maddy@linux.ibm.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,Felix.Kuehling@amd.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,christophe.leroy@csgroup.eu,christian.koenig@amd.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,alexander.deucher@amd.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zone_device-rename-page_free-callback-to-folio_free.patch added to mm-new branch
Message-Id: <20251009031818.BFA65C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zone_device: Rename page_free callback to folio_free
has been added to the -mm mm-new branch.  Its filename is
     mm-zone_device-rename-page_free-callback-to-folio_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zone_device-rename-page_free-callback-to-folio_free.patch

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
Subject: mm/zone_device: Rename page_free callback to folio_free
Date: Wed, 1 Oct 2025 16:56:53 +1000

Change page_free to folio_free to make the folio support for
zone device-private more consistent. The PCI P2PDMA callback
has also been updated and changed to folio_free() as a result.

For drivers that do not support folios (yet), the folio is
converted back into page via &folio->page and the page is used
as is, in the current callback implementation.

Link: https://lkml.kernel.org/r/20251001065707.920170-3-balbirs@nvidia.com
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
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/memory-model.rst        |    2 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c       |    5 +++--
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    5 +++--
 drivers/gpu/drm/drm_pagemap.c            |   10 +++++-----
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |    5 +++--
 drivers/pci/p2pdma.c                     |    5 +++--
 include/linux/memremap.h                 |    6 +++---
 lib/test_hmm.c                           |    5 +++--
 mm/memremap.c                            |   16 ++++++++--------
 9 files changed, 32 insertions(+), 27 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-zone_device-rename-page_free-callback-to-folio_free
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -1014,8 +1014,9 @@ static vm_fault_t kvmppc_uvmem_migrate_t
  * to a normal PFN during H_SVM_PAGE_OUT.
  * Gets called with kvm->arch.uvmem_lock held.
  */
-static void kvmppc_uvmem_page_free(struct page *page)
+static void kvmppc_uvmem_folio_free(struct folio *folio)
 {
+	struct page *page = &folio->page;
 	unsigned long pfn = page_to_pfn(page) -
 			(kvmppc_uvmem_pgmap.range.start >> PAGE_SHIFT);
 	struct kvmppc_uvmem_page_pvt *pvt;
@@ -1034,7 +1035,7 @@ static void kvmppc_uvmem_page_free(struc
 }
 
 static const struct dev_pagemap_ops kvmppc_uvmem_ops = {
-	.page_free = kvmppc_uvmem_page_free,
+	.folio_free = kvmppc_uvmem_folio_free,
 	.migrate_to_ram	= kvmppc_uvmem_migrate_to_ram,
 };
 
--- a/Documentation/mm/memory-model.rst~mm-zone_device-rename-page_free-callback-to-folio_free
+++ a/Documentation/mm/memory-model.rst
@@ -165,7 +165,7 @@ The users of `ZONE_DEVICE` are:
 * pmem: Map platform persistent memory to be used as a direct-I/O target
   via DAX mappings.
 
-* hmm: Extend `ZONE_DEVICE` with `->page_fault()` and `->page_free()`
+* hmm: Extend `ZONE_DEVICE` with `->page_fault()` and `->folio_free()`
   event callbacks to allow a device-driver to coordinate memory management
   events related to device-memory, typically GPU memory. See
   Documentation/mm/hmm.rst.
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-zone_device-rename-page_free-callback-to-folio_free
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -568,8 +568,9 @@ out:
 	return r < 0 ? r : 0;
 }
 
-static void svm_migrate_page_free(struct page *page)
+static void svm_migrate_folio_free(struct folio *folio)
 {
+	struct page *page = &folio->page;
 	struct svm_range_bo *svm_bo = page->zone_device_data;
 
 	if (svm_bo) {
@@ -1009,7 +1010,7 @@ out_mmput:
 }
 
 static const struct dev_pagemap_ops svm_migrate_pgmap_ops = {
-	.page_free		= svm_migrate_page_free,
+	.folio_free		= svm_migrate_folio_free,
 	.migrate_to_ram		= svm_migrate_to_ram,
 };
 
--- a/drivers/gpu/drm/drm_pagemap.c~mm-zone_device-rename-page_free-callback-to-folio_free
+++ a/drivers/gpu/drm/drm_pagemap.c
@@ -752,15 +752,15 @@ err_out:
 }
 
 /**
- * drm_pagemap_page_free() - Put GPU SVM zone device data associated with a page
- * @page: Pointer to the page
+ * drm_pagemap_folio_free() - Put GPU SVM zone device data associated with a folio
+ * @folio: Pointer to the folio
  *
  * This function is a callback used to put the GPU SVM zone device data
  * associated with a page when it is being released.
  */
-static void drm_pagemap_page_free(struct page *page)
+static void drm_pagemap_folio_free(struct folio *folio)
 {
-	drm_pagemap_zdd_put(page->zone_device_data);
+	drm_pagemap_zdd_put(folio->page.zone_device_data);
 }
 
 /**
@@ -788,7 +788,7 @@ static vm_fault_t drm_pagemap_migrate_to
 }
 
 static const struct dev_pagemap_ops drm_pagemap_pagemap_ops = {
-	.page_free = drm_pagemap_page_free,
+	.folio_free = drm_pagemap_folio_free,
 	.migrate_to_ram = drm_pagemap_migrate_to_ram,
 };
 
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-zone_device-rename-page_free-callback-to-folio_free
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -108,8 +108,9 @@ unsigned long nouveau_dmem_page_addr(str
 	return chunk->bo->offset + off;
 }
 
-static void nouveau_dmem_page_free(struct page *page)
+static void nouveau_dmem_folio_free(struct folio *folio)
 {
+	struct page *page = &folio->page;
 	struct nouveau_dmem_chunk *chunk = nouveau_page_to_chunk(page);
 	struct nouveau_dmem *dmem = chunk->drm->dmem;
 
@@ -220,7 +221,7 @@ done:
 }
 
 static const struct dev_pagemap_ops nouveau_dmem_pagemap_ops = {
-	.page_free		= nouveau_dmem_page_free,
+	.folio_free		= nouveau_dmem_folio_free,
 	.migrate_to_ram		= nouveau_dmem_migrate_to_ram,
 };
 
--- a/drivers/pci/p2pdma.c~mm-zone_device-rename-page_free-callback-to-folio_free
+++ a/drivers/pci/p2pdma.c
@@ -200,8 +200,9 @@ static const struct attribute_group p2pm
 	.name = "p2pmem",
 };
 
-static void p2pdma_page_free(struct page *page)
+static void p2pdma_folio_free(struct folio *folio)
 {
+	struct page *page = &folio->page;
 	struct pci_p2pdma_pagemap *pgmap = to_p2p_pgmap(page_pgmap(page));
 	/* safe to dereference while a reference is held to the percpu ref */
 	struct pci_p2pdma *p2pdma =
@@ -214,7 +215,7 @@ static void p2pdma_page_free(struct page
 }
 
 static const struct dev_pagemap_ops p2pdma_pgmap_ops = {
-	.page_free = p2pdma_page_free,
+	.folio_free = p2pdma_folio_free,
 };
 
 static void pci_p2pdma_release(void *data)
--- a/include/linux/memremap.h~mm-zone_device-rename-page_free-callback-to-folio_free
+++ a/include/linux/memremap.h
@@ -77,11 +77,11 @@ enum memory_type {
 
 struct dev_pagemap_ops {
 	/*
-	 * Called once the page refcount reaches 0.  The reference count will be
+	 * Called once the folio refcount reaches 0.  The reference count will be
 	 * reset to one by the core code after the method is called to prepare
-	 * for handing out the page again.
+	 * for handing out the folio again.
 	 */
-	void (*page_free)(struct page *page);
+	void (*folio_free)(struct folio *folio);
 
 	/*
 	 * Used for private (un-addressable) device memory only.  Must migrate
--- a/lib/test_hmm.c~mm-zone_device-rename-page_free-callback-to-folio_free
+++ a/lib/test_hmm.c
@@ -1374,8 +1374,9 @@ static const struct file_operations dmir
 	.owner		= THIS_MODULE,
 };
 
-static void dmirror_devmem_free(struct page *page)
+static void dmirror_devmem_free(struct folio *folio)
 {
+	struct page *page = &folio->page;
 	struct page *rpage = BACKING_PAGE(page);
 	struct dmirror_device *mdevice;
 
@@ -1438,7 +1439,7 @@ static vm_fault_t dmirror_devmem_fault(s
 }
 
 static const struct dev_pagemap_ops dmirror_devmem_ops = {
-	.page_free	= dmirror_devmem_free,
+	.folio_free	= dmirror_devmem_free,
 	.migrate_to_ram	= dmirror_devmem_fault,
 };
 
--- a/mm/memremap.c~mm-zone_device-rename-page_free-callback-to-folio_free
+++ a/mm/memremap.c
@@ -289,8 +289,8 @@ void *memremap_pages(struct dev_pagemap
 			WARN(1, "Missing migrate_to_ram method\n");
 			return ERR_PTR(-EINVAL);
 		}
-		if (!pgmap->ops->page_free) {
-			WARN(1, "Missing page_free method\n");
+		if (!pgmap->ops->folio_free) {
+			WARN(1, "Missing folio_free method\n");
 			return ERR_PTR(-EINVAL);
 		}
 		if (!pgmap->owner) {
@@ -299,8 +299,8 @@ void *memremap_pages(struct dev_pagemap
 		}
 		break;
 	case MEMORY_DEVICE_COHERENT:
-		if (!pgmap->ops->page_free) {
-			WARN(1, "Missing page_free method\n");
+		if (!pgmap->ops->folio_free) {
+			WARN(1, "Missing folio_free method\n");
 			return ERR_PTR(-EINVAL);
 		}
 		if (!pgmap->owner) {
@@ -453,9 +453,9 @@ void free_zone_device_folio(struct folio
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
 	case MEMORY_DEVICE_COHERENT:
-		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
+		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
 			break;
-		pgmap->ops->page_free(&folio->page);
+		pgmap->ops->folio_free(folio);
 		percpu_ref_put_many(&folio->pgmap->ref, nr);
 		break;
 
@@ -472,9 +472,9 @@ void free_zone_device_folio(struct folio
 		break;
 
 	case MEMORY_DEVICE_PCI_P2PDMA:
-		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
+		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
 			break;
-		pgmap->ops->page_free(folio_page(folio, 0));
+		pgmap->ops->folio_free(folio);
 		break;
 	}
 }
_

Patches currently in -mm which might be from balbirs@nvidia.com are

mm-zone_device-support-large-zone-device-private-folios.patch
mm-zone_device-rename-page_free-callback-to-folio_free.patch
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


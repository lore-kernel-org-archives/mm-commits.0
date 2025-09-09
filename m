Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC851B78F3
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 04:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757390425; cv=none; b=PVPJVRbDx4qWQ5l0qB9NdOrzcfQdGd1GY8tdAuybrbySCV6r5+6fLqdv9xFHjGSf374H0YAaKF7PsY3aVdqHvSN5AwVHoVJq/tkj/DZk73KWcNN+oSQuDcnxWBAxCrpLAGvMBSdHBspxLmrEz4FExkpgWc1TZjGqE5KP4KKdBKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757390425; c=relaxed/simple;
	bh=UR9zY9PcZ/syRDo2oXAWe+7qHcHo71IQ6xCbcnaAAGU=;
	h=Date:To:From:Subject:Message-Id; b=Ki8IHrUteZte3Y0Lic2sQReYu2+n7OpWQFqo32/6EFNLW2lSepOxUClwKthQJo2HUUgarMtSr8EX/Zn3vwo1Gzn2LU2sNrvkoUyZrC2nXrEvUnzAwCaudGTZgUhH7PLidesU85/ikCM987qIrCb9ESVTDFUjq60yKDGgcZ63s9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gHvkPS78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gHvkPS78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3129C4CEF4;
	Tue,  9 Sep 2025 04:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757390424;
	bh=UR9zY9PcZ/syRDo2oXAWe+7qHcHo71IQ6xCbcnaAAGU=;
	h=Date:To:From:Subject:From;
	b=gHvkPS78bUxnKTXgnGOi7lWFkEXMzXGLH/uG38fhFM/EV5MRGY49DIxb+s4QIhPuL
	 e1v0+HdxHJfSRM/5OucSQh466+uu3jeXdk619BqaTFRSw83iqHnEpYzMHBhrrCAaMF
	 25hcftCA2kC7I3AeVQ55eBDgKioRi8YeaoNbSyFg=
Date: Mon, 08 Sep 2025 21:00:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zone_device-support-large-zone-device-private-folios.patch added to mm-new branch
Message-Id: <20250909040024.A3129C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zone_device: support large zone device private folios
has been added to the -mm mm-new branch.  Its filename is
     mm-zone_device-support-large-zone-device-private-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zone_device-support-large-zone-device-private-folios.patch

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
Subject: mm/zone_device: support large zone device private folios
Date: Mon, 8 Sep 2025 10:04:34 +1000

Patch series "mm: support device-private THP", v5.

This series introduces support for Transparent Huge Page (THP) migration
in zone device-private memory.  The implementation enables efficient
migration of large folios between system memory and device-private memory

Background

Current zone device-private memory implementation only supports PAGE_SIZE
granularity, leading to:
- Increased TLB pressure
- Inefficient migration between CPU and GPU memory

This series extends the existing zone device-private infrastructure to
support THP, leading to:
- Reduced page table overhead
- Improved memory bandwidth utilization
- Seamless fallback to base pages when needed

In my local testing (using lib/test_hmm) and a throughput test, the series
shows a 350% improvement in data transfer throughput and a 80% improvement
in latency

These patches build on the earlier posts by Ralph Campbell [1]

Two new flags are added in vma_migration to select and mark compound
pages.  migrate_vma_setup(), migrate_vma_pages() and
migrate_vma_finalize() support migration of these pages when
MIGRATE_VMA_SELECT_COMPOUND is passed in as arguments.

The series also adds zone device awareness to (m)THP pages along with
fault handling of large zone device private pages.  page vma walk and the
rmap code is also zone device aware.  Support has also been added for
folios that might need to be split in the middle of migration (when the
src and dst do not agree on MIGRATE_PFN_COMPOUND), that occurs when src
side of the migration can migrate large pages, but the destination has not
been able to allocate large pages.  The code supported and used
folio_split() when migrating THP pages, this is used when
MIGRATE_VMA_SELECT_COMPOUND is not passed as an argument to
migrate_vma_setup().

The test infrastructure lib/test_hmm.c has been enhanced to support THP
migration.  A new ioctl to emulate failure of large page allocations has
been added to test the folio split code path.  hmm-tests.c has new test
cases for huge page migration and to test the folio split path.  A new
throughput test has been added as well.

The nouveau dmem code has been enhanced to use the new THP migration
capability.  

mTHP support:

The patches hard code, HPAGE_PMD_NR in a few places, but the code has been
kept generic to support various order sizes.  With additional refactoring
of the code support of different order sizes should be possible.

The future plan is to post enhancements to support mTHP with a rough
design as follows:

1. Add the notion of allowable thp orders to the HMM based test driver
2. For non PMD based THP paths in migrate_device.c, check to see if
   a suitable order is found and supported by the driver
3. Iterate across orders to check the highest supported order for migration
4. Migrate and finalize

The mTHP patches can be built on top of this series, the key design
elements that need to be worked out are infrastructure and driver support
for multiple ordered pages and their migration.


This patch (of 15):

Add routines to support allocation of large order zone device folios
and helper functions for zone device folios, to check if a folio is
device private and helpers for setting zone device data.

When large folios are used, the existing page_free() callback in
pgmap is called when the folio is freed, this is true for both
PAGE_SIZE and higher order pages.

Zone device private large folios do not support deferred split and
scan like normal THP folios.

Link: https://lkml.kernel.org/r/20250908000448.180088-1-balbirs@nvidia.com
Link: https://lkml.kernel.org/r/20250908000448.180088-2-balbirs@nvidia.com
Link: https://lore.kernel.org/linux-mm/20201106005147.20113-1-rcampbell@nvidia.com/ [1]
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

 include/linux/memremap.h |   10 ++++++++-
 mm/memremap.c            |   38 ++++++++++++++++++++++++-------------
 mm/rmap.c                |    6 ++++-
 3 files changed, 39 insertions(+), 15 deletions(-)

--- a/include/linux/memremap.h~mm-zone_device-support-large-zone-device-private-folios
+++ a/include/linux/memremap.h
@@ -206,7 +206,7 @@ static inline bool is_fsdax_page(const s
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-void zone_device_page_init(struct page *page);
+void zone_device_folio_init(struct folio *folio, unsigned int order);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
@@ -215,6 +215,14 @@ struct dev_pagemap *get_dev_pagemap(unsi
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
+
+static inline void zone_device_page_init(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	zone_device_folio_init(folio, 0);
+}
+
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
--- a/mm/memremap.c~mm-zone_device-support-large-zone-device-private-folios
+++ a/mm/memremap.c
@@ -416,20 +416,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
 void free_zone_device_folio(struct folio *folio)
 {
 	struct dev_pagemap *pgmap = folio->pgmap;
+	unsigned long nr = folio_nr_pages(folio);
+	int i;
 
 	if (WARN_ON_ONCE(!pgmap))
 		return;
 
 	mem_cgroup_uncharge(folio);
 
-	/*
-	 * Note: we don't expect anonymous compound pages yet. Once supported
-	 * and we could PTE-map them similar to THP, we'd have to clear
-	 * PG_anon_exclusive on all tail pages.
-	 */
 	if (folio_test_anon(folio)) {
-		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
-		__ClearPageAnonExclusive(folio_page(folio, 0));
+		for (i = 0; i < nr; i++)
+			__ClearPageAnonExclusive(folio_page(folio, i));
+	} else {
+		VM_WARN_ON_ONCE(folio_test_large(folio));
 	}
 
 	/*
@@ -453,11 +452,15 @@ void free_zone_device_folio(struct folio
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
+		percpu_ref_put_many(&folio->pgmap->ref, nr);
+		pgmap->ops->page_free(&folio->page);
+		folio->page.mapping = NULL;
+		break;
 	case MEMORY_DEVICE_COHERENT:
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
 			break;
-		pgmap->ops->page_free(folio_page(folio, 0));
-		put_dev_pagemap(pgmap);
+		pgmap->ops->page_free(&folio->page);
+		percpu_ref_put(&folio->pgmap->ref);
 		break;
 
 	case MEMORY_DEVICE_GENERIC:
@@ -480,14 +483,23 @@ void free_zone_device_folio(struct folio
 	}
 }
 
-void zone_device_page_init(struct page *page)
+void zone_device_folio_init(struct folio *folio, unsigned int order)
 {
+	struct page *page = folio_page(folio, 0);
+
+	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
+
 	/*
 	 * Drivers shouldn't be allocating pages after calling
 	 * memunmap_pages().
 	 */
-	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
-	set_page_count(page, 1);
+	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
+	folio_set_count(folio, 1);
 	lock_page(page);
+
+	if (order > 1) {
+		prep_compound_page(page, order);
+		folio_set_large_rmappable(folio);
+	}
 }
-EXPORT_SYMBOL_GPL(zone_device_page_init);
+EXPORT_SYMBOL_GPL(zone_device_folio_init);
--- a/mm/rmap.c~mm-zone_device-support-large-zone-device-private-folios
+++ a/mm/rmap.c
@@ -1769,9 +1769,13 @@ static __always_inline void __folio_remo
 	 * the folio is unmapped and at least one page is still mapped.
 	 *
 	 * Check partially_mapped first to ensure it is a large folio.
+	 *
+	 * Device private folios do not support deferred splitting and
+	 * shrinker based scanning of the folios to free.
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
-	    !folio_test_partially_mapped(folio))
+	    !folio_test_partially_mapped(folio) &&
+		!folio_is_device_private(folio))
 		deferred_split_folio(folio, true);
 
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
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


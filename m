Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F71626980F
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023284; cv=none; b=JMPM/O68Z1R/vSr4KarESDHMAzxoXkT3ePCiD2Ka85FyF2ksXJcILMXijVy6lO4nm5gvrOh0M3IcdnFEVlC6gPq8XDBQU59NYxpdjW2LjxWCzA+lUEeXlGmL0jP4po5OU0wk4+39O5TUNgVEWEJQlFgVlDyq7DzfZKMipfFJmy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023284; c=relaxed/simple;
	bh=nQgOlOCOqScKY0CM03yN/dI1M7o5R7pI10944+bhCxE=;
	h=Date:To:From:Subject:Message-Id; b=nZbtAUedGccVcvDZRE5MZ4+VtQb5+JG/Lp59WAFfCEhm/suw0cFoTpDi1KdWI6e6B6B7jOcuCryeYYcH4OOZmuZ0o919YZBgnALcZP2nJn0vJNrUx/5r409yJeCHHkvicHsHp0hW9EAnAo/8oivTBXNkeAVOV2cURMTC3+Tb09M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QEfIWPuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QEfIWPuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2F2C4CEF1;
	Mon, 24 Nov 2025 22:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023283;
	bh=nQgOlOCOqScKY0CM03yN/dI1M7o5R7pI10944+bhCxE=;
	h=Date:To:From:Subject:From;
	b=QEfIWPuVRuO+MkGVzY6v/gKK7ef4hkpsyMm3XJ7Vn274QpX1Nv2XRtiMQnnTgTj/x
	 iR2S7ZSdsjHNY2A/azqmuB3Q/WsSqAcbe26zF4L19rOrC89G9TYypVRwucDbV5Gaf8
	 Vnplzn8kVi02pCQrLEWUtCC5boTGKDU5E6RPqpPw=
Date: Mon, 24 Nov 2025 14:28:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix.patch removed from -mm tree
Message-Id: <20251124222803.CB2F2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix override of entry in remove_migration_pmd
has been removed from the -mm tree.  Its filename was
     mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix.patch

This patch was dropped because it was folded into mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch

------------------------------------------------------
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm/huge_memory: fix override of entry in remove_migration_pmd
Date: Fri, 14 Nov 2025 12:21:53 +1100

Recent changes exposed a BUG in remove_migration_pmd() where the
migration entry was being overridden when the folio is device private.

Use scope local entry for creating the device private pmde. Make the
pmde writable if the migration entry is writable by moving the check
is_migration_write() prior to creating the device private entry.

Link: https://lkml.kernel.org/r/20251114012153.2634497-2-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
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

 mm/huge_memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix
+++ a/mm/huge_memory.c
@@ -4637,7 +4637,12 @@ void remove_migration_pmd(struct page_vm
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
 
+	if (is_writable_migration_entry(entry))
+		pmde = pmd_mkwrite(pmde, vma);
+
 	if (folio_is_device_private(folio)) {
+		swp_entry_t entry;
+
 		if (pmd_write(pmde))
 			entry = make_writable_device_private_entry(
 							page_to_pfn(new));
@@ -4649,8 +4654,6 @@ void remove_migration_pmd(struct page_vm
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
-	if (is_writable_migration_entry(entry))
-		pmde = pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_mkuffd_wp(pmde);
 	if (!is_migration_entry_young(entry))
_

Patches currently in -mm which might be from balbirs@nvidia.com are

mm-zone_device-support-large-zone-device-private-folios.patch
mm-zone_device-rename-page_free-callback-to-folio_free.patch
mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix-2.patch
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
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix.patch


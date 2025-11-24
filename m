Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABEC2F692F
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023285; cv=none; b=iR013ut/J84MP0whBXTsk6VafoLdsKWDYB3c/trO2sxp8Dn+ZFfEiCXR2jC0xd+jHKxFFR88weM0fvZWpObELG6jTi5fftivVFaDriQD4+ojqGMmfU7b5Cprv5LaXWqXFjLRTkiKFNBeBzc0nFTVfVWZjp2Jf7ifdzXiWyX4luA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023285; c=relaxed/simple;
	bh=RLDNAoGJkkNY+T9Xzs6SLSq7fQmvLf0Iaej0mKo6Y8U=;
	h=Date:To:From:Subject:Message-Id; b=HX2aueiZplSb2ZDdPltvLhNYBUZaN1c/5w25VxVsC/MrLbONogXNpl8ago0JMWBNRgVaxzVH8C5+eTUf3PAVKW8WpF9EJMPH2stpGOTPsUQ3NoBdmEk+WDbBPi6+33dOmZIJuXJ9c3aSE2trCdgVRm4uwq6oNNxkKNeftgNv/PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v0LNlpEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v0LNlpEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E507BC4CEF1;
	Mon, 24 Nov 2025 22:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023285;
	bh=RLDNAoGJkkNY+T9Xzs6SLSq7fQmvLf0Iaej0mKo6Y8U=;
	h=Date:To:From:Subject:From;
	b=v0LNlpEjhnJtOitIapSJlNyd0CEtPpFZ9plv6WTXeQNErLc5g7sQdrAYhE+UcPUuD
	 kHhU5zEzMvoT+tkkVDDcFXAtew0MStRwMG/woHYwAsPDpRMbYUHeXIiWymhffzunxl
	 go/GhrvGxDudy47ZK1lt93EXTyNu0mfbkv0IJJmQ=
Date: Mon, 24 Nov 2025 14:28:04 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix-2.patch removed from -mm tree
Message-Id: <20251124222804.E507BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix-2
has been removed from the -mm tree.  Its filename was
     mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix-2.patch

This patch was dropped because it was folded into mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch

------------------------------------------------------
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix-2
Date: Sat, 15 Nov 2025 11:28:35 +1100

Follow the pattern used in remove_migration_pte() in
remove_migration_pmd(). Process the migration entries and if the entry
type is device private, override the pmde with a device private entry
and set the soft dirty and uffd_wp bits with the pmd_swp_mksoft_dirty
and pmd_swp_mkuffd_wp

Link: https://lkml.kernel.org/r/20251115002835.3515194-1-balbirs@nvidia.com
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

 mm/huge_memory.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-rmap-extend-rmap-and-migration-support-device-private-entries-fix-2
+++ a/mm/huge_memory.c
@@ -4637,8 +4637,17 @@ void remove_migration_pmd(struct page_vm
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
 
+	if (pmd_swp_soft_dirty(*pvmw->pmd))
+		pmde = pmd_mksoft_dirty(pmde);
 	if (is_writable_migration_entry(entry))
 		pmde = pmd_mkwrite(pmde, vma);
+	if (pmd_swp_uffd_wp(*pvmw->pmd))
+		pmde = pmd_mkuffd_wp(pmde);
+	if (!is_migration_entry_young(entry))
+		pmde = pmd_mkold(pmde);
+	/* NOTE: this may contain setting soft-dirty on some archs */
+	if (folio_test_dirty(folio) && is_migration_entry_dirty(entry))
+		pmde = pmd_mkdirty(pmde);
 
 	if (folio_is_device_private(folio)) {
 		swp_entry_t entry;
@@ -4650,17 +4659,12 @@ void remove_migration_pmd(struct page_vm
 			entry = make_readable_device_private_entry(
 							page_to_pfn(new));
 		pmde = swp_entry_to_pmd(entry);
-	}
 
-	if (pmd_swp_soft_dirty(*pvmw->pmd))
-		pmde = pmd_mksoft_dirty(pmde);
-	if (pmd_swp_uffd_wp(*pvmw->pmd))
-		pmde = pmd_mkuffd_wp(pmde);
-	if (!is_migration_entry_young(entry))
-		pmde = pmd_mkold(pmde);
-	/* NOTE: this may contain setting soft-dirty on some archs */
-	if (folio_test_dirty(folio) && is_migration_entry_dirty(entry))
-		pmde = pmd_mkdirty(pmde);
+		if (pmd_swp_soft_dirty(*pvmw->pmd))
+			pmde = pmd_swp_mksoft_dirty(pmde);
+		if (pmd_swp_uffd_wp(*pvmw->pmd))
+			pmde = pmd_swp_mkuffd_wp(pmde);
+	}
 
 	if (folio_test_anon(folio)) {
 		rmap_t rmap_flags = RMAP_NONE;
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
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix.patch


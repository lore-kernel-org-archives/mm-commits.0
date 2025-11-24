Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3A2F5321
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025784; cv=none; b=CPdqm0vLR0VKHO2TK/K0X1BfNfHV7qFRdQYdNwyTTi9TN17ntptwz07KKNuZDthJXsRvpBgu8HgcQY+bUqIA764Y60MqcfVKYAm0wsYZ+q958G7jnAlsKOnNw+El8YMQ45DvV3X1OMJayaq1G7TZPzSzycHDz5vUEdWNtW5rC6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025784; c=relaxed/simple;
	bh=mmOlsGDlmhX8d1KzfIkEIcSKYfGn0NGTUI+8qE2xsA4=;
	h=Date:To:From:Subject:Message-Id; b=dpqm+Gw+Gb3rImzVKxHggW6e4r/+VStxXBRg5wBc4/0LOFlUzknSH9XILFg4rZa1sfWN4/kV3LN94bzryaeCwL3nnNaG3VUi5aqpdtx4lB128tZSTF78ArovD/KyyVjb0pXHEZB++8c3YPCzCuWEfroB2DkHaIvuT0pNS0sQ2NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mFi/Mr4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mFi/Mr4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD771C4CEF1;
	Mon, 24 Nov 2025 23:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025784;
	bh=mmOlsGDlmhX8d1KzfIkEIcSKYfGn0NGTUI+8qE2xsA4=;
	h=Date:To:From:Subject:From;
	b=mFi/Mr4IzsCtMTgaUDKseH7dD87Hn+d4524sGpp3DVNiZbQpvUGO8YCxaWRkAhppz
	 muv6Lkrv9aaxiumJk5IBcwk6+aGcAnVMuEfI65XRprDlfK56uDwQW+CsyvKr2DrNC6
	 7dBQ0z60c3toI1LS1NP9TmTnUYeql4xXrm0i4tzM=
Date: Mon, 24 Nov 2025 15:09:43 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-handle-partially-mapped-folios-during-collection.patch removed from -mm tree
Message-Id: <20251124230943.DD771C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: handle partially mapped folios during collection
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-handle-partially-mapped-folios-during-collection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm/migrate_device: handle partially mapped folios during collection
Date: Wed, 1 Oct 2025 16:56:57 +1000

Extend migrate_vma_collect_pmd() to handle partially mapped large folios
that require splitting before migration can proceed.

During PTE walk in the collection phase, if a large folio is only
partially mapped in the migration range, it must be split to ensure the
folio is correctly migrated.

[matthew.brost@intel.com: handle partially mapped folios during split]
  Link: https://lkml.kernel.org/r/20251120230825.181072-1-matthew.brost@intel.com
Link: https://lkml.kernel.org/r/20251001065707.920170-7-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
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
Cc: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   70 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_device-handle-partially-mapped-folios-during-collection
+++ a/mm/migrate_device.c
@@ -54,6 +54,55 @@ static int migrate_vma_collect_hole(unsi
 	return 0;
 }
 
+/**
+ * migrate_vma_split_folio() - Helper function to split a THP folio
+ * @folio: the folio to split
+ * @fault_page: struct page associated with the fault if any
+ *
+ * Returns 0 on success
+ */
+static int migrate_vma_split_folio(struct folio *folio,
+				   struct page *fault_page)
+{
+	int ret;
+	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
+	struct folio *new_fault_folio = NULL;
+
+	if (folio != fault_folio) {
+		folio_get(folio);
+		folio_lock(folio);
+	}
+
+	ret = split_folio(folio);
+	if (ret) {
+		if (folio != fault_folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		return ret;
+	}
+
+	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
+
+	/*
+	 * Ensure the lock is held on the correct
+	 * folio after the split
+	 */
+	if (!new_fault_folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	} else if (folio != new_fault_folio) {
+		if (new_fault_folio != fault_folio) {
+			folio_get(new_fault_folio);
+			folio_lock(new_fault_folio);
+		}
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return 0;
+}
+
 static int migrate_vma_collect_pmd(pmd_t *pmdp,
 				   unsigned long start,
 				   unsigned long end,
@@ -107,10 +156,11 @@ again:
 		}
 	}
 
-	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
 	if (!ptep)
 		goto again;
 	arch_enter_lazy_mmu_mode();
+	ptep += (addr - start) / PAGE_SIZE;
 
 	for (; addr < end; addr += PAGE_SIZE, ptep++) {
 		struct dev_pagemap *pgmap;
@@ -171,6 +221,24 @@ again:
 					pgmap->owner != migrate->pgmap_owner)
 					goto next;
 			}
+			folio = page ? page_folio(page) : NULL;
+			if (folio && folio_test_large(folio)) {
+				int ret;
+
+				arch_leave_lazy_mmu_mode();
+				pte_unmap_unlock(ptep, ptl);
+				ret = migrate_vma_split_folio(folio,
+							  migrate->fault_page);
+
+				if (ret) {
+					if (unmapped)
+						flush_tlb_range(walk->vma, start, end);
+
+					return migrate_vma_collect_skip(addr, end, walk);
+				}
+
+				goto again;
+			}
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 		}
_

Patches currently in -mm which might be from balbirs@nvidia.com are



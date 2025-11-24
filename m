Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE2E33508C
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023451; cv=none; b=ULcEnm9gbnJGhRbPUcQHiRihUQUqUMMCppPQnj5ILuVRdf2iLadM0diOVCBXch2IbKUeftVsphTFCPRprQcfG0Hixqi4frSqlMrwtxBYNclNxdoQmNWHwk4jYm3Ci95IKUaYzomdByzpwBsckXRxxTEEE7Pb6d0wlM5a2uf+bgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023451; c=relaxed/simple;
	bh=lkb4X2i358xoQjgbf+M7opsS90gM17CSwZmLz0Q6MBs=;
	h=Date:To:From:Subject:Message-Id; b=XEyLAG5VMgk5kWUspjFNMAQPDfQHnHvxZvN1VRrAkzZiWqjw2bL0DE55340ScSaIexVPcQ86gI4Q0aTwd8JHuR5yRj4b7ho5XWcSgrERoqv/slBUAQ24J9Dv9vpWG7j48bGcdJfqHYNJODJLdBLJz1J1JlioFnn+ngwhjkXi7Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dFYIvnir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFYIvnir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1545C4CEF1;
	Mon, 24 Nov 2025 22:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023450;
	bh=lkb4X2i358xoQjgbf+M7opsS90gM17CSwZmLz0Q6MBs=;
	h=Date:To:From:Subject:From;
	b=dFYIvnirgW8JN1eIZj+ogbYWB1R1S6574StV+UGqQW4ED8bhjvxK5ttp1VWCQnHIA
	 1MOKxYKu4Lp7gQq4bmynpHLli8SupH+lj8POF57qf+Xaz1U9B7Xf5sNjJEAm65zTpA
	 L40AFTQfpNbIuciu/EmIG1+nsIlaiTUvPSIzNztU=
Date: Mon, 24 Nov 2025 14:30:50 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,airlied@gmail.com,matthew.brost@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate_device-add-thp-splitting-during-migration-fix.patch removed from -mm tree
Message-Id: <20251124223050.C1545C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: mm/migrate_device: add THP splitting during migration
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-add-thp-splitting-during-migration-fix.patch

This patch was dropped because it was folded into mm-migrate_device-add-thp-splitting-during-migration.patch

------------------------------------------------------
From: Matthew Brost <matthew.brost@intel.com>
Subject: fixup: mm/migrate_device: add THP splitting during migration
Date: Thu, 20 Nov 2025 15:08:25 -0800

Fix splitting a folio in PMD collection to collect a skip on folio split
failure and continue the loop at the current position on success.  This
fixes an issue where migration entries that had already been collected
could accidentally be left behind.

Link: https://lkml.kernel.org/r/20251120230825.181072-2-matthew.brost@intel.com
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
Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-add-thp-splitting-during-migration-fix
+++ a/mm/migrate_device.c
@@ -313,16 +313,18 @@ again:
 			if (folio_test_large(folio)) {
 				int ret;
 
+				arch_leave_lazy_mmu_mode();
 				pte_unmap_unlock(ptep, ptl);
 				ret = migrate_vma_split_folio(folio,
 							  migrate->fault_page);
 
 				if (ret) {
-					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-					goto next;
+					if (unmapped)
+						flush_tlb_range(walk->vma, start, end);
+
+					return migrate_vma_collect_skip(addr, end, walk);
 				}
 
-				addr = start;
 				goto again;
 			}
 
_

Patches currently in -mm which might be from matthew.brost@intel.com are

mm-migrate_device-add-thp-splitting-during-migration.patch
selftests-mm-hmm-tests-partial-unmap-mremap-and-anon_write-tests.patch


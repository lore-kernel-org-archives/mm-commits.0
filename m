Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364203358D7
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023373; cv=none; b=FXg2p5oxJrtQ7FudLh1s3fsD+XMYk0ApqQoPYyoPcZyAry00pc8rKSH22jTqzOvPp3WgYCyaXYgKrQcwpnxE0zXFnKNcpg4V99VlH7E8J1iF3147HwYWSDT+XqCYLZVVwrovzd69FiqJ4YqC3pz/4D47KBdlP9+VKIIjopR7LFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023373; c=relaxed/simple;
	bh=quYV2gqolF8c9iWwaSlI0/DPWfBzcu89XgSUfRMVBoc=;
	h=Date:To:From:Subject:Message-Id; b=V5yqETy2GlEAl+qhjvqwTj0tGgmw5pXzZKxZvhHNcPOwCe86HA1e50l5nFdNuAJG8jCYxV+/5oER6Ewfb5ffdtcsupYKWyGVFOXAiqd47oUQPukib6/Zi2uj+41uCSc6RBfhGiJzR1cGq/C+DF4/z5hcSjXmnFcoOaJltnnSCTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nXVYZGkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nXVYZGkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3D5C19421;
	Mon, 24 Nov 2025 22:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023371;
	bh=quYV2gqolF8c9iWwaSlI0/DPWfBzcu89XgSUfRMVBoc=;
	h=Date:To:From:Subject:From;
	b=nXVYZGkkHtvFwm+Ifvg83e4/nz11RRvZweZCY9EiXHCNwXd4hnXQWYuAbGWr54mgJ
	 mnYhxz1xBWIH2VoQJ+pmLHE8+zEkbdjBKFVTYDcuad9VxvjR3im7kPXrGG7uzVeT+g
	 vImBRxu91PghRhhFKpBGzkY2G8AAPGKBUSi0Cyzg=
Date: Mon, 24 Nov 2025 14:29:30 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,airlied@gmail.com,matthew.brost@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate_device-handle-partially-mapped-folios-during-collection-fix.patch removed from -mm tree
Message-Id: <20251124222931.BE3D5C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: mm/migrate_device: handle partially mapped folios during
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-handle-partially-mapped-folios-during-collection-fix.patch

This patch was dropped because it was folded into mm-migrate_device-handle-partially-mapped-folios-during-collection.patch

------------------------------------------------------
From: Matthew Brost <matthew.brost@intel.com>
Subject: fixup: mm/migrate_device: handle partially mapped folios during
Date: Thu, 20 Nov 2025 15:08:24 -0800

Splitting a partially mapped folio caused a regression in the Intel Xe
SVM test suite in the mremap section, resulting in the following stack
trace:

 NFO: task kworker/u65:2:1642 blocked for more than 30 seconds.
[  212.624286]       Tainted: G S      W           6.18.0-rc6-xe+ #1719
[  212.638288] Workqueue: xe_page_fault_work_queue xe_pagefault_queue_work [xe]
[  212.638323] Call Trace:
[  212.638324]  <TASK>
[  212.638325]  __schedule+0x4b0/0x990
[  212.638330]  schedule+0x22/0xd0
[  212.638331]  io_schedule+0x41/0x60
[  212.638333]  migration_entry_wait_on_locked+0x1d8/0x2d0
[  212.638336]  ? __pfx_wake_page_function+0x10/0x10
[  212.638339]  migration_entry_wait+0xd2/0xe0
[  212.638341]  hmm_vma_walk_pmd+0x7c9/0x8d0
[  212.638343]  walk_pgd_range+0x51d/0xa40
[  212.638345]  __walk_page_range+0x75/0x1e0
[  212.638347]  walk_page_range_mm+0x138/0x1f0
[  212.638349]  hmm_range_fault+0x59/0xa0
[  212.638351]  drm_gpusvm_get_pages+0x194/0x7b0 [drm_gpusvm_helper]
[  212.638354]  drm_gpusvm_range_get_pages+0x2d/0x40 [drm_gpusvm_helper]
[  212.638355]  __xe_svm_handle_pagefault+0x259/0x900 [xe]
[  212.638375]  ? update_load_avg+0x7f/0x6c0
[  212.638377]  ? update_curr+0x13d/0x170
[  212.638379]  xe_svm_handle_pagefault+0x37/0x90 [xe]
[  212.638396]  xe_pagefault_queue_work+0x2da/0x3c0 [xe]
[  212.638420]  process_one_work+0x16e/0x2e0
[  212.638422]  worker_thread+0x284/0x410
[  212.638423]  ? __pfx_worker_thread+0x10/0x10
[  212.638425]  kthread+0xec/0x210
[  212.638427]  ? __pfx_kthread+0x10/0x10
[  212.638428]  ? __pfx_kthread+0x10/0x10
[  212.638430]  ret_from_fork+0xbd/0x100
[  212.638433]  ? __pfx_kthread+0x10/0x10
[  212.638434]  ret_from_fork_asm+0x1a/0x30
[  212.638436]  </TASK>

The issue appears to be that migration PTEs are not properly removed
after a split due to incorrect retry handling after a split failure or
success. Upon failure, collect a skip, and upon success, continue the
collection from the current position in the sequence.

Also, while here, fix migrate_vma_split_folio to only lock the new fault
folio if it is different from the original fault folio (i.e., it's
possible the original fault folio is not the same as the one being
split).

Link: https://lkml.kernel.org/r/20251120230825.181072-1-matthew.brost@intel.com
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
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
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

 mm/migrate_device.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-handle-partially-mapped-folios-during-collection-fix
+++ a/mm/migrate_device.c
@@ -92,8 +92,10 @@ static int migrate_vma_split_folio(struc
 		folio_unlock(folio);
 		folio_put(folio);
 	} else if (folio != new_fault_folio) {
-		folio_get(new_fault_folio);
-		folio_lock(new_fault_folio);
+		if (new_fault_folio != fault_folio) {
+			folio_get(new_fault_folio);
+			folio_lock(new_fault_folio);
+		}
 		folio_unlock(folio);
 		folio_put(folio);
 	}
@@ -154,10 +156,11 @@ again:
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
@@ -222,16 +225,18 @@ again:
 			if (folio && folio_test_large(folio)) {
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
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
_

Patches currently in -mm which might be from matthew.brost@intel.com are

mm-migrate_device-handle-partially-mapped-folios-during-collection.patch
mm-migrate_device-add-thp-splitting-during-migration-fix.patch
selftests-mm-hmm-tests-partial-unmap-mremap-and-anon_write-tests.patch


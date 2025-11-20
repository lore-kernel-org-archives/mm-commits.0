Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033882D6E55
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 23:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763680449; cv=none; b=rxUX0KftxfZS3+Bg9xtAasoH2aWXV8ZMKbufKgBtCly5GNG/FovkbicNFPJrkXC4slWoHzWN2KVAVijq6AQoMf2ofEAdpqoZwwiqwpuWNoa7dyXnfK5qIToRndmnS2GWnW7bH0uDyCz1PUnrVCJqxWbVeAK/udmtHvhFkA/h6ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763680449; c=relaxed/simple;
	bh=QzyLZ/0m5eyxSdcxxrj3g/iAM30fRFpPmfGOnE9d/rQ=;
	h=Date:To:From:Subject:Message-Id; b=Y/PJ/Nyc2qBsbe+QYfm9rGMMEFBoMUlpoxI5/l1a79Je1vGV7LU6kyWhATPZf21yf2nImQuZQ7obWYLbzdZqSUlktdxkpLAxgirz+UqkjVzlR7065L1JwxtqaMshRF5XqQSpi/KzT2ycZnoEirvUVpvIdmYfuYzFG3pv8hTtwyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z8XPtylU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z8XPtylU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B97BC4CEF1;
	Thu, 20 Nov 2025 23:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763680446;
	bh=QzyLZ/0m5eyxSdcxxrj3g/iAM30fRFpPmfGOnE9d/rQ=;
	h=Date:To:From:Subject:From;
	b=Z8XPtylUtizx6NdBnSpyTY830285zqqHPPUTXaO7YcHgc8S3xjqJfA9zm3VNEXKDo
	 tT8qXiSEbzWibmDHqNMy6ZBWPzm4Q5ZH4FOkVQjDUrz5PeeQkvXRt4/S27V6S7h5rc
	 oH5LtTzVlTxqDoVTqdHI7s2pzfPsEvbAdTotDnP8=
Date: Thu, 20 Nov 2025 15:14:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,airlied@gmail.com,matthew.brost@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-add-thp-splitting-during-migration-fix.patch added to mm-unstable branch
Message-Id: <20251120231406.5B97BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: mm/migrate_device: add THP splitting during migration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-add-thp-splitting-during-migration-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-add-thp-splitting-during-migration-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-migrate_device-handle-partially-mapped-folios-during-collection-fix.patch
mm-migrate_device-add-thp-splitting-during-migration-fix.patch
selftests-mm-hmm-tests-partial-unmap-mremap-and-anon_write-tests.patch


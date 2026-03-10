Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FE53C5538
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 20:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773173769; cv=none; b=Ei6Z7Dk0os/jApxqtNrU0bVEs1xcW/Zqf/y0V8JAdiXoKBJ1J33wtA0HAGw9vfDvW/hgEy0rLxIoZcjyTsu+nGmjZdzDGXfnr5YlO8PMiWgANLVxOyPnXu21JhKbdEvgXwJzcdMlZVr2cgvFZZPEXtijA9zrpvZ4FDG8zsNv8+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773173769; c=relaxed/simple;
	bh=GwYo9+awRwSvr/1BTD4wEG72Cvqbw2p5T1L5XYAnFAU=;
	h=Date:To:From:Subject:Message-Id; b=Qo/MgNMuG88wW3gEk06zrGxEnFegnIH2J6Hdw0uKjbEtIk564PRr4LqPOLhvvR1Xh+w7wI3MmDteO31JWuyp6X/kKPRJ0lJKn4d/wGE6C2aI1TAsvncon3t/ovN2pBK7wiIUGbrcqB75nSYzHTBgWMnHPNy0iiCuT3riq+c3quk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NwTD2muW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NwTD2muW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F5AC19423;
	Tue, 10 Mar 2026 20:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773173769;
	bh=GwYo9+awRwSvr/1BTD4wEG72Cvqbw2p5T1L5XYAnFAU=;
	h=Date:To:From:Subject:From;
	b=NwTD2muWiVYkOLs4/imKETEIuiKgqYVPb1dakijsaTEiaUDyrrMBIX5B3jft+1M1s
	 eYh+b9kNHrKfLomvo7vkqebWgRapmyazfJOTLy+PVFjoLg/DRorsv1R6dPqXbN+Lh+
	 l5tASodIDwAlhdPEEUO1Gapdab6En1J23Ri0Ejgg=
Date: Tue, 10 Mar 2026 13:16:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,thomas.hellstrom@linux.intel.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch removed from -mm tree
Message-Id: <20260310201608.E6F5AC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()
Date: Wed, 11 Feb 2026 17:46:11 -0800

The softleaf_is_migration() check is unreachable as entries that are not
device_private are filtered out.  Similarly, the PTE-level equivalent in
migrate_vma_collect_pmd() skips migration entries.

This dead branch also contained a double spin_unlock(ptl) bug.

Link: https://lkml.kernel.org/r/20260212014611.416695-1-dave@stgolabs.net
Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd
+++ a/mm/migrate_device.c
@@ -175,12 +175,6 @@ static int migrate_vma_collect_huge_pmd(
 			return migrate_vma_collect_skip(start, end, walk);
 		}
 
-		if (softleaf_is_migration(entry)) {
-			migration_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
-			return -EAGAIN;
-		}
-
 		if (softleaf_is_device_private_write(entry))
 			write = MIGRATE_PFN_WRITE;
 	} else {
_

Patches currently in -mm which might be from dave@stgolabs.net are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B017F23393F;
	Fri, 22 May 2026 02:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415625; cv=none; b=Hv8AQNFBLhn8jgtcx61/iYTfMs6A5Fb9RbbL9pkXVAubCgNVg+3zXeQ9OvCDpkdPOYPJkS5fT3O/34ss0k3lKzTM75qg5S66WRmXFZLy6B1TzS+oIITLYxthp9FmggtHZMN94ul8c/wFpDKwwGrbyrHSR3nBJqSENC5lIeRR4HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415625; c=relaxed/simple;
	bh=tR5J228uT8stCRZYgt0EZw0z7D5p4iJml8gYdS7lkyw=;
	h=Date:To:From:Subject:Message-Id; b=ItCdhYAzonSHolpprizvbBTtoZ7snEu/5IxrBVZloCJj1yqhMm4z00uyitPuHznvIW4/s1QHZSM/lhitw8czEnQMkAHKMA97KYcD6uZD14iuXYcOil5S82gmwPdcfxklFQIaFbF+XzrVJD8LUddzcEvSlHl33MOrIoLhy/YRtf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pSSo+9LC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pSSo+9LC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5176B1F00A3D;
	Fri, 22 May 2026 02:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415624;
	bh=3GlUrVpYhAtx2bSFMxzm4STWLSexb2wc2Z9ZrVAj7UA=;
	h=Date:To:From:Subject;
	b=pSSo+9LCWDKucaGypZzS9NopfeR021RL3x123nnB/2V5x1fSmR8w5Dwt5x+GkFpMC
	 Cfu22MEKQP/nesWxp3fvC3a6t71ZLI9Wn5pWgE0eNXK/ngz3sVq/xPYyITTxx9PtTP
	 HZ6GqAAT3phBPT3WiicTeQWZ0WetGg/6aHixKTMI=
Date: Thu, 21 May 2026 19:07:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,nueralspacetech@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page.patch removed from -mm tree
Message-Id: <20260522020704.5176B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sunny Patel <nueralspacetech@gmail.com>
Subject: mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
Date: Fri, 1 May 2026 17:21:16 +0530

When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
to a PMD check failure, the pgtable allocated earlier via
pte_alloc_one() is never freed, causing a memory leak.

Added free_abort label to release the pgtable in error path.

Link: https://lore.kernel.org/20260501115122.23288-1-nueralspacetech@gmail.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_device-fix-pgtable-leak-in-migrate_vma_insert_huge_pmd_page
+++ a/mm/migrate_device.c
@@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_p
 	} else {
 		if (folio_is_zone_device(folio) &&
 		    !folio_is_device_coherent(folio)) {
-			goto abort;
+			goto free_abort;
 		}
 		entry = folio_mk_pmd(folio, vma->vm_page_prot);
 		if (vma->vm_flags & VM_WRITE)
@@ -893,6 +893,8 @@ static int migrate_vma_insert_huge_pmd_p
 
 unlock_abort:
 	spin_unlock(ptl);
+free_abort:
+	pte_free(vma->vm_mm, pgtable);
 abort:
 	for (i = 0; i < HPAGE_PMD_NR; i++)
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
_

Patches currently in -mm which might be from nueralspacetech@gmail.com are

mm-migrate_device-cleanup-up-pmd-checks-and-warnings.patch


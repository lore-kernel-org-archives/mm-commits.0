Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8A23BADAA
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360124; cv=none; b=mBTo125SN1LUvMtJv7vCkVFEbBCeGKL6X0WktP9cJJY7fVVbPrMvuYdzDa4det+dZxmRSNtIXV67jgt4B5l5KDWQVfK6ASjmAyTAwj/OY0DWBqEnV7QMF+fn2Oz/PEL0WlxQTcdFgi+Laz2bE8Bk+ot9GD4lTlPvxCvmib4yS20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360124; c=relaxed/simple;
	bh=jKt7TlfZ4VtLCaaJxVJnVTi3GiuC8pLMAUbibf/FGAE=;
	h=Date:To:From:Subject:Message-Id; b=ZkMARibgwLHA7i21S3Bhh0ISb27FLf0jRJ9rj2+lG+zeQ2wiEgJxUclwqCJLp34ipsGfWimCmZ52PeFVqQXJp4cgY4gRSSv+XWwj2buOwk0jkikGlHCbSCGS41DIKafzh+yF3pp7PNNlaj21EhMgTlQnzRp4EficyXytOQtPSl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zNmuBuXu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zNmuBuXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8231F00ACA;
	Mon,  6 Jul 2026 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360122;
	bh=TqUUr1luzx0mcYY+9uMd0/VcId3hYpTEcAgCSyQcX9E=;
	h=Date:To:From:Subject;
	b=zNmuBuXunb+Wz2QOeU4AKM3v3ztPL9yktXgxxOOGY7evFbiXm590Zrx+cpdL0rZx7
	 bC+Vt2oyg0QkKMuOUNzH8m2fEpwnBP0QH8RCiiCHMBi3T2iLO3hFti0oOgJ3FdFzaV
	 Dz1m5q8eVMbAYRSbgNi2JxpQGXcYslQVPX4i6etw=
Date: Mon, 06 Jul 2026 10:48:42 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch removed from -mm tree
Message-Id: <20260706174842.AF8231F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: use softleaf_has_pfn() in pagemap PMD walker
has been removed from the -mm tree.  Its filename was
     fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: fs/proc: use softleaf_has_pfn() in pagemap PMD walker
Date: Tue, 30 Jun 2026 09:34:40 -0700

pagemap_pmd_range_thp() assumes that every non-present PMD is a migration
entry and unconditionally calls softleaf_to_page().  This will crash on
any non-present PMD type that does not encode a PFN, such as the upcoming
PMD-level swap entries.

Guard the page lookup with softleaf_has_pfn(), matching how
pte_to_pagemap_entry() already handles non-present PTEs.

Link: https://lore.kernel.org/20260630164143.1595669-4-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker
+++ a/fs/proc/task_mmu.c
@@ -2129,7 +2129,8 @@ static int pagemap_pmd_range_thp(pmd_t *
 			flags |= PM_SOFT_DIRTY;
 		if (pmd_swp_uffd_wp(pmd))
 			flags |= PM_UFFD_WP;
-		page = softleaf_to_page(entry);
+		if (softleaf_has_pfn(entry))
+			page = softleaf_to_page(entry);
 	}
 
 	if (page) {
_

Patches currently in -mm which might be from usama.arif@linux.dev are

userfaultfd-wait-on-source-pmd-during-uffdio_move.patch
mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch


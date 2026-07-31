Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EA831715A
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465713; cv=none; b=rBnmWhs8GfXb2qoHJGFVfU5udhrS2B4qnCqHzBd272woIjPbqCdoQTMRPr9synS+Cjn8H+dHV2zx/AtXW9qgigYajNWAPdEoFQ3wvl8sD4Vx2bnMqofEkWzn/xaM8oOLdQzl269ZCXD4m5Veav0+S7+bFuxgVQCS8/Qg7bns19U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465713; c=relaxed/simple;
	bh=qtx9tql+6t1JhxbSwJAcrDcEr3uQ9r3Ud+qOd/zLV0g=;
	h=Date:To:From:Subject:Message-Id; b=hjSIOSu6MdhsM6bcuVMHbGYnh4Gahd2W1D02BBO1CvLTmC8NFbI8dpO22/7eXfBchbkcr9CcXgMDzhy/tuHsM5pEbMHdfkF1T74TD06KWYskH4CcwUh+cJlT+Kghg7lryFycISEIX9nt94Dj5oyPv7mdOPJCCNyVKsO2cDmvjj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H1p5C7AG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H1p5C7AG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3E61F00A3A;
	Fri, 31 Jul 2026 02:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465711;
	bh=FXANae0A8Tv3iWMP4BGMIjcFC2jIDS7C86z2rvVfink=;
	h=Date:To:From:Subject;
	b=H1p5C7AGKpYnpCCsWvCJoRj2C0prH88t45ksz2bZfhT5Oe2pFxMeLLGbcfHAEZiSI
	 giSJR/JjJkKELAK2mZ5PbtQOocgKd2Ko4mNnWMalQavHyar01UuKmMp0/0hYmX66C6
	 M6j6HZv4vNL6u/qZSFOd0zmiOdLSBYmJL11wdBZg=
Date: Thu, 30 Jul 2026 19:41:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,alex@ghiti.fr,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch removed from -mm tree
Message-Id: <20260731024151.AA3E61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: use softleaf_has_pfn() in pagemap PMD walker
has been removed from the -mm tree.  Its filename was
     fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: fs/proc: use softleaf_has_pfn() in pagemap PMD walker
Date: Mon, 6 Jul 2026 04:42:05 -0700

pagemap_pmd_range_thp() assumes that every non-present PMD is a migration
entry and unconditionally calls softleaf_to_page().  This will crash on
any non-present PMD type that does not encode a PFN, such as the upcoming
PMD-level swap entries.

Guard the page lookup with softleaf_has_pfn(), matching how
pte_to_pagemap_entry() already handles non-present PTEs.

Link: https://lore.kernel.org/20260706114320.1643046-4-usama.arif@linux.dev
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

mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch


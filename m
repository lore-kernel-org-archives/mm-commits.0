Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B45F376475
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622955; cv=none; b=QjE1JtjQAY69aDjxmqCKSrtOwFLIRTJqbHBnW278Wp5bnxXnSsmoUE4ae9ZFa0qx7wlGGMV1TDSny89zH1Ls3iAA8dd3hCpVLeDNmjJnpZoW3i0ah2Kf0LdprkH8Kq8BwGTZDOXd/AIZTLXUn3pNHTOWUlS5Ebx+ZNlxKlnWpJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622955; c=relaxed/simple;
	bh=eGILRggwJv46Q18j4I2pSGPfVmVQq46E4g4ZIBwv7Io=;
	h=Date:To:From:Subject:Message-Id; b=KrdsTULznjCt93QF4uuRv2VoJInb3fQmDIXiD+IRDy4+O7oEOccka80lqqY/aOXyk88iF5Z+BOKEuZs1pz7A2GdPdb8Z/RWkrL+BPZmdLiwE9oY00b+n8xC7E+MmNEVCDarN6Wkh7QD0i8K5caGvkf4XV5OMO7lx0UFtW9OKkB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2rDFMMUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2rDFMMUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BA51F00A3A;
	Tue, 25 Aug 2026 01:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622954;
	bh=33MkNU/t4jrw94U1t4FvJET+kgwI6UmuHtRR94svaWk=;
	h=Date:To:From:Subject;
	b=2rDFMMUdZDuWbsxsjgN+lBdmQDHjIKXax60EZ7b329BfxoMPDr9KxoNfcooBBPZJG
	 klwt4NvQRUXkLFLBej/PUDYMA/GldpTpgffZcgX1XyVHz2MeMPC0DEsBY7iSgrw7ge
	 HECaikjFABwFrwPOonryaXRASnR8P6OUJflZYpQ0=
Date: Mon, 24 Aug 2026 18:55:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,sh_def@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-fix-cache-flush-when-replacing-huge-zero-pmd.patch removed from -mm tree
Message-Id: <20260825015554.12BA51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: fix cache flush when replacing huge zero PMD
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-fix-cache-flush-when-replacing-huge-zero-pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/migrate_device: fix cache flush when replacing huge zero PMD
Date: Mon, 17 Aug 2026 14:08:46 +0800

migrate_vma_insert_huge_pmd_page() calls flush_cache_page() before
replacing an existing huge zero PMD.  However, the third argument to
flush_cache_page() is a PFN, while addr + HPAGE_PMD_SIZE is an end virtual
address.

More importantly, the mapping being invalidated is PMD-sized rather than
PAGE_SIZE-sized.  Flush the whole PMD range with flush_cache_range(),
matching other huge PMD invalidation paths.

There is no userspace-visible effect today.  The architectures that
currently enable ARCH_ENABLE_THP_MIGRATION use no-op implementations of
flush_cache_page()/flush_cache_range().  32-bit ARM has non-trivial
implementations, but does not enable ARCH_ENABLE_THP_MIGRATION.

So this appears to be a latent API misuse rather than a currently
observable bug, and I don't think a stable backport is necessary.

Link: https://lore.kernel.org/20260817060845.377800-2-sh_def@163.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_device-fix-cache-flush-when-replacing-huge-zero-pmd
+++ a/mm/migrate_device.c
@@ -882,7 +882,7 @@ static int migrate_vma_insert_huge_pmd_p
 
 	if (flush) {
 		pte_free(vma->vm_mm, pgtable);
-		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
+		flush_cache_range(vma, addr, addr + HPAGE_PMD_SIZE);
 		pmdp_invalidate(vma, addr, pmdp);
 	} else {
 		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
_

Patches currently in -mm which might be from sh_def@163.com are

mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios.patch


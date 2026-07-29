Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB127209F43
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297054; cv=none; b=DpaOoayV470JyIp6F2EpEQJGaozBfr9jA5N4JMB3stbv9/5zyUYo/Znhqqtxsl4xKpkHPgMGex7Ev6LJbBwlv6/2MyJzJS9RET3h3V79qwJdQ3nUPnVW7CbqbjZkaNeJoBHtNfC5J00Y4kkqzEzW1ip0RoVOm7q3EeMRK5XXx5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297054; c=relaxed/simple;
	bh=oDWJ1EwB6vZVy4hwNe4NCeE0MQDn52sPgN9bah25J6U=;
	h=Date:To:From:Subject:Message-Id; b=c/BsD56//f0RivUHA96Pd265dmbjgMUbt7Wysuni8E5fmUeZAPNuzEjHDI8wHDcfrDuhpIEZGx8nexfGyLPQXzCqr1vZLBVJOt6+htRcEeN4BQ9m673rwF9wuHrqRGBJVKnGk4Dzj9JXBgp7z4YbcVVGieNP6jHRoO26iIZC9tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RYsa9ZF/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RYsa9ZF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F941F000E9;
	Wed, 29 Jul 2026 03:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297052;
	bh=pFoDZvuMm5TvRw2A9nMQMsRCjcp9r1jnlKievBaCoFk=;
	h=Date:To:From:Subject;
	b=RYsa9ZF/vETSGIMOkh2xzBNNLcvfNwTKLeCckEK57fOsqZy0q9KInXK2msK5VA3gV
	 W3SwpQKMXCE7ru0QlDshjW4c21QrKRg95cEPlSnxrYRWKg1OqQ9uKRabvubolOtHwk
	 z75OhgFxPil+ypZMjHUZldHi0HanwEKwcNlw6SMg=
Date: Tue, 28 Jul 2026 20:50:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,rakie.kim@sk.com,pfalcato@suse.de,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch removed from -mm tree
Message-Id: <20260729035052.26F941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
has been removed from the -mm tree.  Its filename was
     mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch

This patch was dropped because it was folded into mm-mincore-use-walk_page_range_vma-in-do_mincore.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
Date: Wed Jun 24 07:35:43 PM PDT 2026

simplify comment, per Pedro

Link: https://lore.kernel.org/ajP9bQhmvR9OX0VE@pedro-suse
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/mincore.c~mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
+++ a/mm/mincore.c
@@ -260,12 +260,7 @@ static long do_mincore(unsigned long add
 	}
 
 	/*
-	 * walk_page_range_vma() does not call walk_page_test(), which
-	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
-	 * page table walk. Without this check, PFNMAP PTEs would be
-	 * treated as present by mincore_pte_range(), changing the returned
-	 * residency status from the historical "not resident" to "resident".
-	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
+	 * mincore historically reports PFNMAP mappings as non-resident.
 	 */
 	if (vma->vm_flags & VM_PFNMAP) {
 		__mincore_unmapped_range(addr, end, vma, vec);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

csky-implement-flush_cache_vmap-in-c.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


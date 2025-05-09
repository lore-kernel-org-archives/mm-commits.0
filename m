Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE57123816E
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 20:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746822538; cv=none; b=MDIwpR0f1w3tmRFGHE0GyIVWSzRQ8ulYWeGCkFYqv7fGjXBgpQ9iebudgKmAYHgqYjTa/CG86saB0HieUv478N/TXyOLKFKOD4cvEdLl3tzWYSRTtg97f5fw2hNFuC4QMIFURqVgw0fGdh8MYCbilZTnAgBI9SiNZN7RKSFRzOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746822538; c=relaxed/simple;
	bh=6CfzbH3HvS4yruaHrdVkiPMPCwNVX6PXtS/sHmP/8mc=;
	h=Date:To:From:Subject:Message-Id; b=hLSpd/vKVyrnB4STgi9RZ1WWGkvngcAyDX8I/zdkfBhi+yo/+G+fGnAO4NM/zH7aZe2cKP63UnjaTWoQwy7S1oOxy2z54d6dzydHE9HRoiMf3kQjx9YGe2zAaUD1R4Ekk63S3YO486sbu3EHhlxDxZVZon7dM/tEBFV8PDUbbT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u5TGN2C2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u5TGN2C2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAA2C4CEE4;
	Fri,  9 May 2025 20:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746822537;
	bh=6CfzbH3HvS4yruaHrdVkiPMPCwNVX6PXtS/sHmP/8mc=;
	h=Date:To:From:Subject:From;
	b=u5TGN2C2dbA73x4WdoKMjvN01ZzwrRH/J7Jq23fJaWscuLGd/WM+24KqHfe6g/izA
	 5aKw3FRr7YC9JJOdPYP5UtnTLtGVGgFtsEhAaoWSLrHhyuWhI2PdJ3mh3OmckwCVBs
	 Z8CrpYMQNkMDmX13dfAORganGB77Tm8eOU1jyOkc=
Date: Fri, 09 May 2025 13:28:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,minchan@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jyescas@google.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-config_page_block_order-to-select-page-block-order-fix.patch removed from -mm tree
Message-Id: <20250509202857.3DAA2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-config_page_block_order-to-select-page-block-order-fix
has been removed from the -mm tree.  Its filename was
     mm-add-config_page_block_order-to-select-page-block-order-fix.patch

This patch was dropped because it was folded into mm-add-config_page_block_order-to-select-page-block-order.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-config_page_block_order-to-select-page-block-order-fix
Date: Mon May  5 06:12:33 PM PDT 2025

tweak Kconfig text

Cc: David Hildenbrand <david@redhat.com>
Cc: Juan Yescas <jyescas@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/Kconfig~mm-add-config_page_block_order-to-select-page-block-order-fix
+++ a/mm/Kconfig
@@ -1016,10 +1016,10 @@ config PAGE_BLOCK_ORDER
 	  ARCH_FORCE_MAX_ORDER.
 
 	  This option allows overriding the default setting when the page
-	  block order requires to be smaller than ARCH_FORCE_MAX_ORDER.
+	  block order is required to be smaller than ARCH_FORCE_MAX_ORDER.
 
 	  Reducing pageblock order can negatively impact THP generation
-	  successful rate. If your workloads uses THP heavily, please use this
+	  success rate. If your workloads uses THP heavily, please use this
 	  option with caution.
 
 	  Don't change if unsure.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-config_page_block_order-to-select-page-block-order.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED84C1E47C7
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 20:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746824319; cv=none; b=QqFbFGuSsKQ3+qs7ynRd2BTFUtQIsbRotojPopGNq9GvckOWq+dUFD8cLfByhMe9Azj7BmiVEB+3mTAHim4/sGOVUCsjRCBTep1TbMPMwrDresvVasJ0QTSW2FCjqmB4eOGTfdqF5Af0il5A2vCpbfH1OY88b8Zums32HaozH8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746824319; c=relaxed/simple;
	bh=1i+t8PB3rXbUvVKzWUy1GBGlADnsw57f5CRRPz1zK+A=;
	h=Date:To:From:Subject:Message-Id; b=kXUdwZnD48xhiHpB5EPbCc47u8CI2jY3F9+deznkuT+n6DVHfV2eRtKrpSLgkJqPWc1BQm4ByZqiBvuJZemkF4TYpCL9IhBARF/OVLUZ8Y1Isdx5qTQTcGokOX8RsACC0fYH7hax3saw6bVutEUfGQwjTVomiHG9OHC5b25+TxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AfGsqzSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AfGsqzSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4893AC4CEE4;
	Fri,  9 May 2025 20:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746824318;
	bh=1i+t8PB3rXbUvVKzWUy1GBGlADnsw57f5CRRPz1zK+A=;
	h=Date:To:From:Subject:From;
	b=AfGsqzSs6LaC+wZAw/DNGInvO6EehfFDwpbH1Mrkwu8LLPWimqhbJlF9kKUP6rOSH
	 nPPPeboIK/ODsZyfb8p5qkSDCneeMp2zH2SB6Xn2Hz+ohI4ni5estgNqd5vybhAYlh
	 8m5yyBxCVtOOknj57aribfgr73OMTJpLWqxQHI2s=
Date: Fri, 09 May 2025 13:58:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch removed from -mm tree
Message-Id: <20250509205838.4893AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2
Date: Fri May  9 01:48:29 PM PDT 2025

fix build warnings

> >> mm/page_isolation.c:18:20: warning: function 'get_pageblock_isolate' is not needed and will not be emitted [-Wunneeded-internal-declaration]
>       18 | static inline bool get_pageblock_isolate(struct page *page)
>          |                    ^~~~~~~~~~~~~~~~~~~~~
>    mm/page_isolation.c:28:20: warning: unused function 'set_pageblock_isolate' [-Wunused-function]
>       28 | static inline void set_pageblock_isolate(struct page *page)
>          |                    ^~~~~~~~~~~~~~~~~~~~~
>    2 warnings generated.


Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505092126.yRGhLhg1-lkp@intel.com/
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2
+++ a/mm/page_isolation.c
@@ -15,22 +15,19 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/page_isolation.h>
 
+#ifdef CONFIG_DEBUG_VM
 static inline bool get_pageblock_isolate(struct page *page)
 {
 	return get_pfnblock_flags_mask(page, page_to_pfn(page),
 			PB_migrate_isolate_bit);
 }
+#endif
+
 static inline void clear_pageblock_isolate(struct page *page)
 {
 	set_pfnblock_flags_mask(page, 0, page_to_pfn(page),
 			PB_migrate_isolate_bit);
 }
-static inline void set_pageblock_isolate(struct page *page)
-{
-	set_pfnblock_flags_mask(page, PB_migrate_isolate_bit,
-			page_to_pfn(page),
-			PB_migrate_isolate_bit);
-}
 
 /*
  * This function checks whether the range [start_pfn, end_pfn) includes
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
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBEC1E47C7
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 20:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746824241; cv=none; b=CWp41qJWkOLQqoMavzH+1sE2/hB/79ano+S09CinNepDyT9xD2xJlnh+189n8H9b/8qY9oznJu3FC9zs05mZAoj2BWxnz3eNP/fdL0WR1bGxm4ugM8qf62rB7DELr2bJH9lyXOOi2vIqatDC/tUJiupb8jzlkGK542KS5wOx2v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746824241; c=relaxed/simple;
	bh=X82u4wS+2HytHrhzTGLg+ER4/9OxxpbqeUxcj+h/ol8=;
	h=Date:To:From:Subject:Message-Id; b=qZArIwwsRRWKh7JCWvx+zHGpz++761tMrH4z7R7OL0rj2I3qjuI9KYHLkiXD1WMOor+L5eyK2OIYJVrY6kTrPSFJd3blqjPwBktxAZtxTxMW11olpPMwGPbhW6+HmvNg3u4nD6HB6XfvWMh084SVT7sdHFO4xXFdZuOOcxS6iFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PgKGIaEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PgKGIaEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A566C4CEE4;
	Fri,  9 May 2025 20:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746824240;
	bh=X82u4wS+2HytHrhzTGLg+ER4/9OxxpbqeUxcj+h/ol8=;
	h=Date:To:From:Subject:From;
	b=PgKGIaEZdeg4xbbTUxxvmg89JCFGqur6Ol+v5shrHw2qN3RCE34xBBo1dlK+EBrdP
	 Ikrg6Ft11ZSrV4kxwKsVNySj2lyzDIErmsNAv/pJBPuHpCNOYNMszo0duE6lMO4O+K
	 LkxLUSMQ3A4jh31+dlrA02/xbB/Rqj+V7JIr4ZIo=
Date: Fri, 09 May 2025 13:57:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch added to mm-new branch
Message-Id: <20250509205720.6A566C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch


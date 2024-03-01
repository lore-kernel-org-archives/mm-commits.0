Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8585916A
	for <mm-commits@vger.kernel.org>; Fri,  1 Mar 2024 23:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709336406; cv=none; b=FR9bzjIoRu3wd6ywPybbSbfjU/Lvz0M+N7KiCTWa4jZGkrYJevW9YbE3MP0HoleeKv/WKofPUUtu3+whNFHu6olHnebiLOObv9yt1Mlg7Sx39DP3nBQ1cElSyypIjioP7zxdxgw3MzbaUhJjQH0Hw3Q6nVrv86KUpbx0TfNXbj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709336406; c=relaxed/simple;
	bh=yCZK7sdlEIgec/0gTY4q/qgfsuzE2/GDB4JaviJjxjE=;
	h=Date:To:From:Subject:Message-Id; b=rwTqag6oYwf0HZH4S7T/pQLiDOqPkrOvNg5U1ah7PFBbbbR/KiFEVxjLktg7bXMmNbEtxBBDAEgnJmbZhf7psc6IQwYb+KZEZJlE88deu1od7qhZa070pfTQTNTnhECWwyqGh2XUroamHIMUq7Lm0HOaJFfW04/Ryl7L5gNrCLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RibBkuem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RibBkuem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5182C433C7;
	Fri,  1 Mar 2024 23:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709336404;
	bh=yCZK7sdlEIgec/0gTY4q/qgfsuzE2/GDB4JaviJjxjE=;
	h=Date:To:From:Subject:From;
	b=RibBkuembJCoU/bH/99dmZAvPo2QZVvSy8nM66pWTWEcoSIhNXKAvsjfYSo6Pqpfl
	 2Ix86RkwqN7B/WjgUC3CCq/XmBg/GDiY2vHBlsgInACVae4mu2+/Omc/VPV86KyG4n
	 PLjFUgoVJOHY6G/GVXxRrlshGh66WENOp3yZwlr0=
Date: Fri, 01 Mar 2024 15:40:04 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,broonie@kernel.org,ardb@kernel.org,aishwarya.tcv@arm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-__dump_folio-fix-2.patch added to mm-unstable branch
Message-Id: <20240301234004.D5182C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Fix __dump_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-__dump_folio-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-__dump_folio-fix-2.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: Fix __dump_folio
Date: Fri, 1 Mar 2024 16:11:20 -0500

Ryan Roberts reports that (if you have CONFIG_CMA enabled), calling
__dump_folio() will panic as we call is_migrate_cma_page() with a stack
copy of struct page, which gets passed to page_to_pfn().

Link: https://lkml.kernel.org/r/ZeJJegP8zM7S9GTy@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 mm/debug.c             |    4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-add-__dump_folio-fix-2
+++ a/include/linux/mmzone.h
@@ -76,9 +76,12 @@ extern const char * const migratetype_na
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
 #  define is_migrate_cma_page(_page) (get_pageblock_migratetype(_page) == MIGRATE_CMA)
+#  define is_migrate_cma_folio(folio, pfn)	(MIGRATE_CMA ==		\
+	get_pfnblock_flags_mask(&folio->page, pfn, MIGRATETYPE_MASK))
 #else
 #  define is_migrate_cma(migratetype) false
 #  define is_migrate_cma_page(_page) false
+#  define is_migrate_cma_folio(folio, pfn) false
 #endif
 
 static inline bool is_migrate_movable(int mt)
--- a/mm/debug.c~mm-add-__dump_folio-fix-2
+++ a/mm/debug.c
@@ -55,7 +55,6 @@ static void __dump_folio(struct folio *f
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
-	bool page_cma;
 	int mapcount = 0;
 	char *type = "";
 
@@ -98,9 +97,8 @@ static void __dump_folio(struct folio *f
 	 * state for debugging, it should be fine to accept a bit of
 	 * inaccuracy here due to racing.
 	 */
-	page_cma = is_migrate_cma_page(page);
 	pr_warn("%sflags: %pGp%s\n", type, &folio->flags,
-		page_cma ? " CMA" : "");
+		is_migrate_cma_folio(folio, pfn) ? " CMA" : "");
 	pr_warn("page_type: %pGt\n", &folio->page.page_type);
 
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch
mm-use-folio-more-widely-in-__split_huge_page.patch
mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch


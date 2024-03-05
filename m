Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5F814288
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 20:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709671655; cv=none; b=N+P45618mZyKgC5vr1TAaO2xC6Rs1TEHuUp4GLBqu2oABvJe2qjjPcwRrx2v7k3dYylVyR7f/TNs0lqejq3nUEOHQv4zg3wbZ+L3k+pGx+Qb9jiEpKiqHizgpD9ZOC3Ocx5qWsqs5eKPAO7yrx+jLM9BKax1iybLMtFOT1sEjKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709671655; c=relaxed/simple;
	bh=SSPm5zJC3RGQDDeMyUh7CRZL4ShFtIi2vl8JRvpdopo=;
	h=Date:To:From:Subject:Message-Id; b=CGDpaiGwDPq3NVZNqN0TZ3+z+YOT6o8uvVncN4N1gBbi6UStCsZrRIGZdfYGt1ZR+aizQqdfbopq18cSl3lZBQy6jCon5sscS3OlGu8JaaN/ywK+m9Hj4bQbpu78TEX/g0Mg+iRExeswPRuDt4bpfFheF9+8uT5/3sK/b5hZIg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sRuuv+Tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sRuuv+Tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66A1C433C7;
	Tue,  5 Mar 2024 20:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709671654;
	bh=SSPm5zJC3RGQDDeMyUh7CRZL4ShFtIi2vl8JRvpdopo=;
	h=Date:To:From:Subject:From;
	b=sRuuv+Tjse2kIKdfo2mRGwQ1voizxTNIVCppVURCnaZNEov0FnmmHGQxYsZfimrBr
	 Kej0uJ0sJtVQJuH5rrCA9gmUJmgOd85YR+V21OzRNXNxXduIsPKrSsUcF2nfiDMQYF
	 ejf9yEaGpHBrrwHHili+QeJoc24WSvKVvbzmmGNI=
Date: Tue, 05 Mar 2024 12:47:34 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,broonie@kernel.org,ardb@kernel.org,aishwarya.tcv@arm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-__dump_folio-fix-2.patch removed from -mm tree
Message-Id: <20240305204734.B66A1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: Fix __dump_folio
has been removed from the -mm tree.  Its filename was
     mm-add-__dump_folio-fix-2.patch

This patch was dropped because it was folded into mm-add-__dump_folio.patch

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

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch


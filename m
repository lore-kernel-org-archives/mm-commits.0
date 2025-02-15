Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF02EACE
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 02:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739588068; cv=none; b=hSZt5uht6VqaRUfe4bjRhpYwmJueDW3oY7KTRPUHVbj38PxBZgk8RCLer8o8mr3o/069Lw2I8CAq7AkD/LSmE7I4hPhJT/M28Hkg4HKmCeGWIDSSklNTFiqXyuU8ydupSaJ+kjdABSKqVdWjw0crV3YQp7MOQt2uVRJ4wR5Gp68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739588068; c=relaxed/simple;
	bh=WtxIlrwE2Yohfr+0xSHOS5FcoKVPgPQpJWHjK1lCDDE=;
	h=Date:To:From:Subject:Message-Id; b=GjvSk+QsfP+O422QsxjgRnnJcaCZURfYOS6WdEBowKAdFK0aYjJfnxb8p9W1Uz/Ua5hmxCH/OtMPwXM2c0yW64zWjASsAaqALX9zCdoO6Nnw71zI6jSlWuIxpgP7QRfbABlZCLH9agHrq0BZVruZBAeKsZgtBLXXBCWrjuZhk08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G9yRduh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G9yRduh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA07BC4CED1;
	Sat, 15 Feb 2025 02:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739588067;
	bh=WtxIlrwE2Yohfr+0xSHOS5FcoKVPgPQpJWHjK1lCDDE=;
	h=Date:To:From:Subject:From;
	b=G9yRduh2aAtA+CUZlY25jy8p6MhdVTJBBLTymy2O8J+MOpOSlL8pPfilmpld65IO9
	 VqUogwI/IzJJG864MAXBx0UtIlpj/ia5rmh0h87Th2IkN5eGxr0jbA0Ic7QJDphX1a
	 9X2MtWO/ZFA7pdrGDkA4YsnnWSB24c2kLN20Ag3U=
Date: Fri, 14 Feb 2025 18:54:27 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch added to mm-unstable branch
Message-Id: <20250215025427.BA07BC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: do not drop the original folio during truncate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: do not drop the original folio during truncate
Date: Fri, 14 Feb 2025 16:18:24 -0500

The caller expects to handle the original folio itself.

Also make __split_unmapped_folio() never fail, per discussion with David
Hildenbrand.

Link: https://lkml.kernel.org/r/E2B8D781-01EE-4832-8587-4C5FF57F91B3@nvidia.com
Link: https://lore.kernel.org/all/67af65cb.050a0220.21dd3.004a.GAE@google.com/
Link: https://lore.kernel.org/linux-mm/db77d017-4a1e-4a47-9064-e335cb0313af@redhat.com/
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix
+++ a/mm/huge_memory.c
@@ -3386,16 +3386,12 @@ bool can_split_folio(struct folio *folio
  * It splits @folio into @new_order folios and copies the @folio metadata to
  * all the resulting folios.
  */
-static int __split_folio_to_order(struct folio *folio, int new_order)
+static void __split_folio_to_order(struct folio *folio, int new_order)
 {
-	int curr_order = folio_order(folio);
 	long nr_pages = folio_nr_pages(folio);
 	long new_nr_pages = 1 << new_order;
 	long index;
 
-	if (curr_order <= new_order)
-		return -EINVAL;
-
 	/*
 	 * Skip the first new_nr_pages, since the new folio from them have all
 	 * the flags from the original folio.
@@ -3490,8 +3486,6 @@ static int __split_folio_to_order(struct
 
 	if (!new_order)
 		ClearPageCompound(&folio->page);
-
-	return 0;
 }
 
 /*
@@ -3585,7 +3579,6 @@ static int __split_unmapped_folio(struct
 		int old_order = folio_order(folio);
 		struct folio *release;
 		struct folio *end_folio = folio_next(folio);
-		int status;
 
 		/* order-1 anonymous folio is not supported */
 		if (folio_test_anon(folio) && split_order == 1)
@@ -3618,12 +3611,7 @@ static int __split_unmapped_folio(struct
 		split_page_owner(&folio->page, old_order, split_order);
 		pgalloc_tag_split(folio, old_order, split_order);
 
-		status = __split_folio_to_order(folio, split_order);
-
-		if (status < 0) {
-			stop_split = true;
-			ret = -EINVAL;
-		}
+		__split_folio_to_order(folio, split_order);
 
 after_split:
 		/*
@@ -3661,8 +3649,10 @@ after_split:
 				     folio_test_swapcache(origin_folio)) ?
 					     folio_nr_pages(release) : 0));
 
-			if (release != origin_folio)
-				lru_add_page_tail(origin_folio, &release->page,
+			if (release == origin_folio)
+				continue;
+			
+			lru_add_page_tail(origin_folio, &release->page,
 						lruvec, list);
 
 			/* Some pages can be beyond EOF: drop them from page cache */
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch


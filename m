Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB9B1862
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 01:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784337054; cv=none; b=hcdZJJl3iWtYgKy7bywfo06eAKNDCpWhNtEljSDkAlBv+1o5v7PorezjBRETGWBTk5qCoiRxsmh7EZnsNI1OagJXl/4vi+SxEh9R54+f6GLBBJvtVXaqMoJs3MLAGNJ6oIUECaCskZWGlipvanuxufU8ZPUNFTjvMjq6PdDYeMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784337054; c=relaxed/simple;
	bh=mk0Epf5gVFxoYHEqu4zUmrS4ziJ4UYXPUwF/jdEFDI0=;
	h=Date:To:From:Subject:Message-Id; b=mwqTVboPcLiowTOum0+YSl8v65ljoakaoemE8ggUFt/Z6TJXiRzNelnkgA+ouas0Kkw3MsIFxK5P3Z4zuAliaEQBAypFINj7SBG9ffusF5UyAhTbxz9OI/UWhWbUgP2VTfpAvu/MRXsT13H93+dESAgGBYUNs8t0BVt6yiktlDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wieJZDpI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wieJZDpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB201F000E9;
	Sat, 18 Jul 2026 01:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784337052;
	bh=NW1f58/69thIIz+zdISgvFr12N3bHd8HPqEhER+VPIU=;
	h=Date:To:From:Subject;
	b=wieJZDpIsZw6G9zQl7/L8sS8Xqgle9bm5In4C+ta8214IdRUFcxjQ1RJMEl2NBqW/
	 36DqRGuLxQANMbKMblsTgcbYO/AGRHwIH0Nht53laVJJ8e09u9zGKPvrYncAOImhT8
	 YjSTKkZNFOhCqI87MiGyNb8uNPolEbp2Ey+q3Auo=
Date: Fri, 17 Jul 2026 18:10:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-refactor-mincore_page.patch added to mm-new branch
Message-Id: <20260718011052.8DB201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: refactor mincore_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-refactor-mincore_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-refactor-mincore_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: refactor mincore_page()
Date: Fri, 17 Jul 2026 17:13:47 +0800

Use early returns to reduce indentation and improve readability.

Link: https://lore.kernel.org/20260717091347.1144789-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/mincore.c~mm-mincore-refactor-mincore_page
+++ a/mm/mincore.c
@@ -94,7 +94,7 @@ static unsigned char mincore_swap(swp_en
  */
 static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 {
-	unsigned char present = 0;
+	unsigned char present;
 	struct folio *folio;
 
 	/*
@@ -104,17 +104,16 @@ static unsigned char mincore_page(struct
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
 	folio = filemap_get_entry(mapping, index);
-	if (folio) {
-		if (xa_is_value(folio)) {
-			if (shmem_mapping(mapping))
-				return mincore_swap(radix_to_swp_entry(folio),
-						    true);
-			else
-				return 0;
-		}
-		present = folio_test_uptodate(folio);
-		folio_put(folio);
+	if (!folio)
+		return 0;
+
+	if (xa_is_value(folio)) {
+		if (!shmem_mapping(mapping))
+			return 0;
+		return mincore_swap(radix_to_swp_entry(folio), true);
 	}
+	present = folio_test_uptodate(folio);
+	folio_put(folio);
 
 	return present;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch
mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch
mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-refactor-mincore_page.patch


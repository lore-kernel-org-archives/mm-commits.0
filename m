Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797E62652A6
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 19:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758484506; cv=none; b=jaeyGLspvdtVZ1iwtl8uRlUm9fk4viZCI4/cwWby58uN9XxN9RE31N5gO8+WBIQYc+de05M440JP73ydDAmu0EsKbgcYd9FamZYQ46kGeNMJ36Mao2SWkcG98tygf2K+swz7OZk3gbZXT2jymnHg4iy/mchXW9AW0nJ2CgCOk8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758484506; c=relaxed/simple;
	bh=sEUiQCnQ6fw2r38/3sYpWqEe6P2z1bK/7FwdMudh90c=;
	h=Date:To:From:Subject:Message-Id; b=gxCHJLENpVhVbLgeMGpI7VS+Uxs1EN2c1HC5ybYCvsyCl6h64m5+l4T7nfoiOlpcunacBkDC49fAFUL5tuSt/ZnKeN0Cbr/J6aFUDVEng9meeIB7nY2l5W0m2jJTyu3TAEfdQJsDCHaX71Cbedmv3/4UUkAVqqbIGEf8fwlwPYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TvkUGawL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TvkUGawL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFABC4CEE7;
	Sun, 21 Sep 2025 19:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758484506;
	bh=sEUiQCnQ6fw2r38/3sYpWqEe6P2z1bK/7FwdMudh90c=;
	h=Date:To:From:Subject:From;
	b=TvkUGawLrNEyZjhxqSCppm5Z/kusGl3kmlN+zfDfcR8qFyYKbxlqE384qJDn6a/tJ
	 N/U03diiiTMk5zB+khztAlqVElfDd6CiokXlSyqgs7/8ENqGhD/1aAaW8Obq+Q7ex5
	 nGmxs2eoKfFguMFivxGLDS+azHwAzVIh5my4Oz0Y=
Date: Sun, 21 Sep 2025 12:55:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sfr@canb.auug.org.au,rppt@kernel.org,lorenzo.stoakes@oracle.com,jcmvbkbc@gmail.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch removed from -mm tree
Message-Id: <20250921195506.1CFABC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
has been removed from the -mm tree.  Its filename was
     mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch

This patch was dropped because it was folded into mm-constify-highmem-related-functions-for-improved-const-correctness.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-constify-highmem-related-functions-for-improved-const-correctness-fix
Date: Wed Sep  3 07:51:59 PM PDT 2025

nastily "fix" folio_page()

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-constify-highmem-related-functions-for-improved-const-correctness-fix
+++ a/include/linux/page-flags.h
@@ -316,9 +316,9 @@ static __always_inline unsigned long _co
  * check that the page number lies within @folio; the caller is presumed
  * to have a reference to the page.
  */
-static inline struct page *folio_page(struct folio *folio, unsigned long n)
+static inline struct page *folio_page(const struct folio *folio, unsigned long n)
 {
-	return &folio->page + n;
+	return (struct page *)(&folio->page + n);
 }
 
 static __always_inline int PageTail(const struct page *page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-constify-highmem-related-functions-for-improved-const-correctness.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch


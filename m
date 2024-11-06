Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F59185B68
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854800; cv=none; b=m80crCmROlv6I0T5FZYIq6GQFmku08jVFnmvRlaMK2WbWG3Ha5xteFnm2fnEBuKazAZQ/YX2r/PkI4Jg5doxUkh8Dp5JkNYle53iOYGZ+hZ4bvF3cjy386H42Q22AoN7f540QBcfstUte2lBiMTomRjTIQ8ChSO3uBivMWKgeJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854800; c=relaxed/simple;
	bh=pwKMxCxoS676IYYUzfZ11p43S68Rp7fPzsC7kAqjgL8=;
	h=Date:To:From:Subject:Message-Id; b=lu8haQ9VdyopkaOTWjpHPAh2SuI9Yf/N579rvbZUkgHj80K2ui9kLrYkJ8TX6mOiRJLJjJ5zEWlmA4CA36QtIDfrEXLbSvy0SOZi5ZBDBE3v0BQzh583Q5w4vwDeTPKS0xjzJhFLc10SyT9RITncmLc2O3J5iznNICOt8NzqcXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FYzYY2Nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FYzYY2Nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8CBC4CECF;
	Wed,  6 Nov 2024 01:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854800;
	bh=pwKMxCxoS676IYYUzfZ11p43S68Rp7fPzsC7kAqjgL8=;
	h=Date:To:From:Subject:From;
	b=FYzYY2NfTPNKMxSWC92nyG7Tc5/HM/lxbkKPbSLm9R2oMtgljmNCZRajNG/ZE7yCL
	 Ag+IpYiwkCiB3zoaHPXd0/6PU7wa2rBeaPwEXNNTenNaeTzKVqArDN4RUJB1UJaQwg
	 CGYHWST/nhDVeme9k96YI3VVFO2vorHtagtr/oqU=
Date: Tue, 05 Nov 2024 17:00:00 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,ryan.roberts@arm.com,linmiaohe@huawei.com,keescook@chromium.org,jhubbard@nvidia.com,glider@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch removed from -mm tree
Message-Id: <20241106010000.8B8CBC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid zeroing user movable page twice with init_on_alloc=1
has been removed from the -mm tree.  Its filename was
     mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: avoid zeroing user movable page twice with init_on_alloc=1
Date: Fri, 11 Oct 2024 11:03:04 -0400

Commit 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and
init_on_free=1 boot options") forces allocated page to be zeroed in
post_alloc_hook() when init_on_alloc=1.

For order-0 folios, if arch does not define
vma_alloc_zeroed_movable_folio(), the default implementation again zeros
the page return from the buddy allocator.  So the page is zeroed twice. 
Fix it by passing __GFP_ZERO instead to avoid double page zeroing.  At the
moment, s390,arm64,x86,alpha,m68k are not impacted since they define their
own vma_alloc_zeroed_movable_folio().

For >0 order folios (mTHP and PMD THP), folio_zero_user() is called to
zero the folio again.  Fix it by calling folio_zero_user() only if
init_on_alloc is set.  All arch are impacted.

Add alloc_zeroed() helper to encapsulate the init_on_alloc check.

[ziy@nvidia.com: comment fixes, per David]
  Link: https://lkml.kernel.org/r/97DB52E1-C594-49B5-9736-89AC302FAB01@nvidia.com
Link: https://lkml.kernel.org/r/20241011150304.709590-1-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    8 +-------
 mm/huge_memory.c        |    8 +++++++-
 mm/internal.h           |    6 ++++++
 mm/memory.c             |   10 +++++++++-
 4 files changed, 23 insertions(+), 9 deletions(-)

--- a/include/linux/highmem.h~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1
+++ a/include/linux/highmem.h
@@ -224,13 +224,7 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct folio *folio;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio)
-		clear_user_highpage(&folio->page, vaddr);
-
-	return folio;
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr);
 }
 #endif
 
--- a/mm/huge_memory.c~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1
+++ a/mm/huge_memory.c
@@ -1165,7 +1165,13 @@ static struct folio *vma_alloc_anon_foli
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-	folio_zero_user(folio, addr);
+       /*
+	* When a folio is not zeroed during allocation (__GFP_ZERO not used),
+	* folio_zero_user() is used to make sure that the page corresponding
+	* to the faulting address will be hot in the cache after zeroing.
+	*/
+	if (!alloc_zeroed())
+		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
--- a/mm/internal.h~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1
+++ a/mm/internal.h
@@ -1276,6 +1276,12 @@ void touch_pud(struct vm_area_struct *vm
 void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	       pmd_t *pmd, bool write);
 
+static inline bool alloc_zeroed(void)
+{
+	return static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
+			&init_on_alloc);
+}
+
 enum {
 	/* mark page accessed */
 	FOLL_TOUCH = 1 << 16,
--- a/mm/memory.c~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1
+++ a/mm/memory.c
@@ -4719,7 +4719,15 @@ static struct folio *alloc_anon_folio(st
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			folio_zero_user(folio, vmf->address);
+			/*
+			 * When a folio is not zeroed during allocation
+			 * (__GFP_ZERO not used), folio_zero_user() is used
+			 * to make sure that the page corresponding to the
+			 * faulting address will be hot in the cache after
+			 * zeroing.
+			 */
+			if (!alloc_zeroed())
+				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
_

Patches currently in -mm which might be from ziy@nvidia.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E8C40869
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146754; cv=none; b=ofIEyLp/CT5QTnCHfpRBR2/K15FijstdsVjEp39+2fGuisST8P1+HT7Z/I2OrMGoljp5GGpsgktDC557QaAF59QrWUB+Z95GXUe47wpSvu66mVge4klIuHxadYpEyMZf0E98tsZw0lOxu/tSWSnoB8nGlMMwjv18VjamMYPyV8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146754; c=relaxed/simple;
	bh=5OqQfV5VOK80Buc9iQAGl4AkwCgst/jmVXdCrJfieVg=;
	h=Date:To:From:Subject:Message-Id; b=R9cmT1+X0ECduCeXvoEFinFMXAxLmV7gChxZ74D2xFwIFv2hCoryEfBjgN6piI/RFxp/uAtaay87iIVyUn021a6W776kF3+E7CeGo80o37XaR3+4rvqpbLtnRDxZFvmN+7Q5d1MjW+zRCyQRDvZdDDKMKrO40N2GDo9aD6hej/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IlVc5Jnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IlVc5Jnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC711C43390;
	Wed, 28 Feb 2024 18:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146752;
	bh=5OqQfV5VOK80Buc9iQAGl4AkwCgst/jmVXdCrJfieVg=;
	h=Date:To:From:Subject:From;
	b=IlVc5JnkFdt0IcgBPFqKf4iNsFaZH/W0JPiZFAdwJT5tXo805LHvtT/198oC0TKBM
	 G9/HahWK837ugaiN7B/z+NG4BmmyCIQLoabb/WMUWAN6xvdcl0y3wMYSCB5pgi17/Z
	 Ts71UE1EtWYvdjROQ54ZcamTm6EwUWtHJXCDEPoU=
Date: Wed, 28 Feb 2024 10:59:12 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-dump_page-take-a-const-argument.patch added to mm-unstable branch
Message-Id: <20240228185912.CC711C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make dump_page() take a const argument
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-dump_page-take-a-const-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-dump_page-take-a-const-argument.patch

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
Subject: mm: make dump_page() take a const argument
Date: Tue, 27 Feb 2024 19:23:32 +0000

Now that __dump_page() takes a const argument, we can make dump_page()
take a const struct page too.

Link: https://lkml.kernel.org/r/20240227192337.757313-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    2 +-
 mm/debug.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mmdebug.h~mm-make-dump_page-take-a-const-argument
+++ a/include/linux/mmdebug.h
@@ -10,7 +10,7 @@ struct vm_area_struct;
 struct mm_struct;
 struct vma_iterator;
 
-void dump_page(struct page *page, const char *reason);
+void dump_page(const struct page *page, const char *reason);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
 void vma_iter_dump_tree(const struct vma_iterator *vmi);
--- a/mm/debug.c~mm-make-dump_page-take-a-const-argument
+++ a/mm/debug.c
@@ -143,7 +143,7 @@ again:
 	__dump_folio(foliop, &precise, pfn, idx);
 }
 
-void dump_page(struct page *page, const char *reason)
+void dump_page(const struct page *page, const char *reason)
 {
 	if (PagePoisoned(page))
 		pr_warn("page:%p is uninitialized and poisoned", page);
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
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch


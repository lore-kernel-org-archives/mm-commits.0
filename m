Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827A513440E
	for <mm-commits@vger.kernel.org>; Thu, 29 Feb 2024 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709232599; cv=none; b=rAQoDFgOcJhjaf8e2nKtVpVgJUEyMrkSXSCoQi8RCzCKr3Y8z7OIsGbclfvpiP0PN6KgP+v4LKT3dptGjsW/tTyRoY/Dih/n3aJaYEcrFm4GsAEb0/3yxVuXCt1hZJ6NUnlNyVhbtON6u/AXqgjT/ZWOCjab38luNHnxuj0Ez50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709232599; c=relaxed/simple;
	bh=EQ888iZWcNy7BP2AyduLceKvA2TZK2nPvdBDSCn4ypQ=;
	h=Date:To:From:Subject:Message-Id; b=ntMJenUfKHkOaU6vn1ranOmFc8YtvIL7VN4ORKz44XEmiFFtDWIFtQQHSnBXu2Y89om1EKQn5DP+p9snurKvtvFadrayLm1Skku50wNxO2NXtqa1dNWOtnf6nH1IJ5f9gVvdjn76xapWj5z23YAKYCfRgVlptY4cHN1m1rgsNKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lHFGdEqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lHFGdEqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D892DC433C7;
	Thu, 29 Feb 2024 18:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709232599;
	bh=EQ888iZWcNy7BP2AyduLceKvA2TZK2nPvdBDSCn4ypQ=;
	h=Date:To:From:Subject:From;
	b=lHFGdEqEbFguY3E4PCL89QIteDbA99sQbZY3eOqPMGOpgq2DQPyMCGd7gXu5m8S9s
	 Z/EyCFFVIKK+U6LpZD3tXj2T33ZcxFihAkwH2vJTpCZ3aqJE+1zUsNEol8ZeH98fnZ
	 JRm9y5vpPAK19bPGA7j+8uZ/8fncPhRz1y+z0s3Q=
Date: Thu, 29 Feb 2024 10:49:57 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-__dump_folio-fix.patch added to mm-unstable branch
Message-Id: <20240229184958.D892DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-__dump_folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-__dump_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-__dump_folio-fix.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-add-__dump_folio-fix
Date: Thu, 29 Feb 2024 04:37:31 +0000

fix build issue

Link: https://lkml.kernel.org/r/ZeAKCyTn_xS3O9cE@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +++++++
 mm/debug.c         |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-add-__dump_folio-fix
+++ a/include/linux/mm.h
@@ -2066,6 +2066,13 @@ static inline long folio_nr_pages(struct
 #endif
 }
 
+/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
+#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
+#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
+#else
+#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
+#endif
+
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
--- a/mm/debug.c~mm-add-__dump_folio-fix
+++ a/mm/debug.c
@@ -125,7 +125,7 @@ again:
 	foliop = page_folio(&precise);
 	idx = folio_page_idx(foliop, page);
 	if (idx != 0) {
-		if (idx < (1UL << PUD_ORDER)) {
+		if (idx < MAX_FOLIO_NR_PAGES) {
 			memcpy(&folio, foliop, 2 * sizeof(struct page));
 			nr_pages = folio_nr_pages(&folio);
 		}
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
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBE32572
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 00:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198756; cv=none; b=rLZetiWNmXgQ8bSq/y/cVjeqR5SVfSmaZG57PZWulQcKFXeEAejfAA+4aGsx/lzknAbCGQl5wpjqzunSch8JevelPs2mCFGizh1d56mcKzFCVYRh2OVaFmJyj8Zmsf1B6sxSpnsd78ekAjBOnd8X1Og6bRkvM1pWdnleFXTNmrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198756; c=relaxed/simple;
	bh=dh1u7e8hWHqgjhYmVU5qtgMyMW9qU1v+R423q7S8Szo=;
	h=Date:To:From:Subject:Message-Id; b=klzxGF+JaKTS78tDl+AQ8+1o+Qh97Kaivl9rjgSVWLkzJUVs/Hl0u4fLKospbu5NtNBBt23TRY7aiLjOYINorTYDhWfX9NtDpiD8SS/gWCzHuNc0y8X9jQnzCtgqbJ9zeA1ogis30ydzMF39qjDq/B/BpW4B2P84uO1isKr0cL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzUihdQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzUihdQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B4EC4AF09;
	Wed, 21 Aug 2024 00:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724198756;
	bh=dh1u7e8hWHqgjhYmVU5qtgMyMW9qU1v+R423q7S8Szo=;
	h=Date:To:From:Subject:From;
	b=AzUihdQnv+JLFskc0NS5hyDOQBsZeRW4ZWmZaRLt24dngEUMjfwcsQQSFoC8LY1LM
	 nYOZjpqqTK+gkazUBgVNRGMso84w+TIyZ6xcSj3suS6Tzdc59nWDazp57t4yydsfyz
	 QpgwmdQ2ZDQeneKW8ZM51cfGrHGTOedCKYrFNfxk=
Date: Tue, 20 Aug 2024 17:05:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-support-shmem-mthp-copy.patch added to mm-unstable branch
Message-Id: <20240821000556.81B4EC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: support shmem mTHP copy
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-support-shmem-mthp-copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-support-shmem-mthp-copy.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: khugepaged: support shmem mTHP copy
Date: Tue, 20 Aug 2024 17:49:15 +0800

Iterate each subpage in the large folio to copy, as preparation for
supporting shmem mTHP collapse.

Link: https://lkml.kernel.org/r/222d615b7c837eabb47a238126c5fdeff8aa5283.1724140601.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-support-shmem-mthp-copy
+++ a/mm/khugepaged.c
@@ -2056,17 +2056,22 @@ xa_unlocked:
 	index = start;
 	dst = folio_page(new_folio, 0);
 	list_for_each_entry(folio, &pagelist, lru) {
+		int i, nr_pages = folio_nr_pages(folio);
+
 		while (index < folio->index) {
 			clear_highpage(dst);
 			index++;
 			dst++;
 		}
-		if (copy_mc_highpage(dst, folio_page(folio, 0)) > 0) {
-			result = SCAN_COPY_MC;
-			goto rollback;
+
+		for (i = 0; i < nr_pages; i++) {
+			if (copy_mc_highpage(dst, folio_page(folio, i)) > 0) {
+				result = SCAN_COPY_MC;
+				goto rollback;
+			}
+			index++;
+			dst++;
 		}
-		index++;
-		dst++;
 	}
 	while (index < end) {
 		clear_highpage(dst);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch
mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch
mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch
mm-khugepaged-support-shmem-mthp-copy.patch
mm-khugepaged-support-shmem-mthp-collapse.patch
selftests-mm-support-shmem-mthp-collapse-testing.patch


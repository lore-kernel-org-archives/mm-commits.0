Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF5F17F7
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 00:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198755; cv=none; b=ccgnfdjQV6762LpaDCsJQd6Ah1inZwFH2V5a1CpKaf70/5UBiOP7wNSm6tOaan091t1UP33+rNa3nf7/kJw8TxpiyFySw2ybdDinjwFg+3wUY3CQKMC5iv7t/NG5bg0WYP9y39W3ODJVWzTrB5HPJH5FUAI32sJ29k17qHBKhag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198755; c=relaxed/simple;
	bh=xZCubUXI6tXBy9YsbDtgwxrq8VrAc6S74B3362Dj19U=;
	h=Date:To:From:Subject:Message-Id; b=roZLu6fI3hV1rUPApTnc1rAUCVYar9F8n+cUH26CB4ReabEpXY4lzQLdzMK3lPh/PzBewDB3H5NU+Yl20Vy5OnTx2zz12q8/IGJqdNQxj9VDFwM7XAucoYb0a4PamymG7lPQgjvkiMpTRunoe1NhueAzke1qmk9JuUpscdb7arI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LkAh1tSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LkAh1tSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86362C4AF0B;
	Wed, 21 Aug 2024 00:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724198754;
	bh=xZCubUXI6tXBy9YsbDtgwxrq8VrAc6S74B3362Dj19U=;
	h=Date:To:From:Subject:From;
	b=LkAh1tSms9s9wEnn5kzpe35TF5K5l3Y/R6KcsDKglbg1/DKe/1WObRbbEFN1wxF52
	 EG3wcPadqljCxFhUnRYmQS9A7lz6UL7rm4CiHVzf1fOQKK+0MTw7v+JtTr7deuoEME
	 82ciZs5tGcgL9UzYNPNGHocBjykuHMyiQdu3qZWI=
Date: Tue, 20 Aug 2024 17:05:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch added to mm-unstable branch
Message-Id: <20240821000554.86362C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: use the number of pages in the folio to check the reference count
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch

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
Subject: mm: khugepaged: use the number of pages in the folio to check the reference count
Date: Tue, 20 Aug 2024 17:49:14 +0800

Use the number of pages in the folio to check the reference count as
preparation for supporting shmem mTHP collapse.

Link: https://lkml.kernel.org/r/9ea49262308de28957596cc6e8edc2d3a4f54659.1724140601.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count
+++ a/mm/khugepaged.c
@@ -1988,9 +1988,9 @@ static int collapse_file(struct mm_struc
 		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
 
 		/*
-		 * We control three references to the folio:
+		 * We control 2 + nr_pages references to the folio:
 		 *  - we hold a pin on it;
-		 *  - one reference from page cache;
+		 *  - nr_pages reference from page cache;
 		 *  - one from lru_isolate_folio;
 		 * If those are the only references, then any new usage
 		 * of the folio will have to fetch it from the page
@@ -1998,7 +1998,7 @@ static int collapse_file(struct mm_struc
 		 * truncate, so any new usage will be blocked until we
 		 * unlock folio after collapse/during rollback.
 		 */
-		if (folio_ref_count(folio) != 3) {
+		if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
 			result = SCAN_PAGE_COUNT;
 			xas_unlock_irq(&xas);
 			folio_putback_lru(folio);
@@ -2181,7 +2181,7 @@ immap_locked:
 		folio_clear_active(folio);
 		folio_clear_unevictable(folio);
 		folio_unlock(folio);
-		folio_put_refs(folio, 3);
+		folio_put_refs(folio, 2 + folio_nr_pages(folio));
 	}
 
 	goto out;
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


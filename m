Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122831366
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 00:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198753; cv=none; b=ZjnZ7KBgds+phwYA2bATDE6KxXRmaHxVFQ+77Gsqc8iiW2U8UUaBrHH89e1EfWxGVL3CrvxhwhPR7NOkkzvAS41XMjtdeDuuwPnXtCNFXKuI8026f2x5k/TCIdellUii59M6QIiboS7uloopH0LbToetTQQgTwbE32WEdILjUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198753; c=relaxed/simple;
	bh=Wtj4635KWNx2qfaCLfoNqHIGkSYac1Y+B+jBlJ1Q+fU=;
	h=Date:To:From:Subject:Message-Id; b=DpBBGeoir+QIASPa1ZBhxCARmN2J/A/x0eysksPsJfMVZ/oXlIy29qGD7dOvfi4KQm4ClhiWapEks+oh+VU4ke+belumSLffc8JVIjzwnD/OpNNhsrjWKo4eVKmtAwcT6V/ScwUT5In6dbBfn4ZT8T/hRxJWSrUvd9rNxJqBqIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qvuIbTb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qvuIbTb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CA6C4AF15;
	Wed, 21 Aug 2024 00:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724198752;
	bh=Wtj4635KWNx2qfaCLfoNqHIGkSYac1Y+B+jBlJ1Q+fU=;
	h=Date:To:From:Subject:From;
	b=qvuIbTb4rDPq+gIplbFbGDJks2rVeBoaZJJkLHJBr3+onJ1je4kO49ZhvVrMvOUQF
	 Bc70BsBYQ6leVc0JoAjGSyRzVJoGx2FL3eschj+xEPFm9T5EV9Ab1gJJdB9RlmMgXh
	 w2H9ihTPj4lD9aRoj5arU8mIeGOFGjRY9F72HdCE=
Date: Tue, 20 Aug 2024 17:05:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch added to mm-unstable branch
Message-Id: <20240821000552.74CA6C4AF15@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: expand the is_refcount_suitable() to support file folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch

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
Subject: mm: khugepaged: expand the is_refcount_suitable() to support file folios
Date: Tue, 20 Aug 2024 17:49:13 +0800

Patch series "support shmem mTHP collapse", v2.

Shmem already supports mTHP allocation[1], and this patchset adds support
for shmem mTHP collapse, as well as adding relevant test cases.


This patch (of 5):

Expand the is_refcount_suitable() to support reference checks for file
folios, as preparation for supporting shmem mTHP collapse.

Link: https://lkml.kernel.org/r/cover.1724140601.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/eae4cb3195ebbb654bfb7967cb7261d4e4e7c7fa.1724140601.git.baolin.wang@linux.alibaba.com
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

 mm/khugepaged.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios
+++ a/mm/khugepaged.c
@@ -546,12 +546,14 @@ static void release_pte_pages(pte_t *pte
 
 static bool is_refcount_suitable(struct folio *folio)
 {
-	int expected_refcount;
+	int expected_refcount = folio_mapcount(folio);
 
-	expected_refcount = folio_mapcount(folio);
-	if (folio_test_swapcache(folio))
+	if (!folio_test_anon(folio) || folio_test_swapcache(folio))
 		expected_refcount += folio_nr_pages(folio);
 
+	if (folio_test_private(folio))
+		expected_refcount++;
+
 	return folio_ref_count(folio) == expected_refcount;
 }
 
@@ -2285,8 +2287,7 @@ static int hpage_collapse_scan_file(stru
 			break;
 		}
 
-		if (folio_ref_count(folio) !=
-		    1 + folio_mapcount(folio) + folio_test_private(folio)) {
+		if (!is_refcount_suitable(folio)) {
 			result = SCAN_PAGE_COUNT;
 			break;
 		}
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


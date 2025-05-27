Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1C8215F4B
	for <mm-commits@vger.kernel.org>; Tue, 27 May 2025 23:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748388651; cv=none; b=qoW6XTDBNDADtOMg89YLVj4BJNFWtbA5SIkK+qdVHJDD5yPXGwJ3skfWlAgh/vWo9uSfWUfd6GuhXzttQufxPIikFQKr3PvYPl6HueRPD/GwqQaxHDYhQ/rLhg6q7a7tjna9JhLLT9EMIseWTpSQHOs2Hvuvxb7exglgkExRVoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748388651; c=relaxed/simple;
	bh=j0P7oRn/iHtP5fKq0NfcJ2fFXxwq9aplz4l6NGdW5eI=;
	h=Date:To:From:Subject:Message-Id; b=LWx7u1o9QBJdtpaoe3O8dUtlFOkAU4FJDufPDhPEL10+0D680SX3LOde3g2FBFDw5dPc7NgoYxbw1CL4NEnkiADvZwGreFkcawXdxHQnMyYdUhdmqfSa6wbfXjLLG+tQlyKNpakQWFDy4qvl2gsWJ55uxKrWyNotUp5SLO404VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YZfvomuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YZfvomuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF59C4CEE9;
	Tue, 27 May 2025 23:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748388650;
	bh=j0P7oRn/iHtP5fKq0NfcJ2fFXxwq9aplz4l6NGdW5eI=;
	h=Date:To:From:Subject:From;
	b=YZfvomuoHAyNyeXfHdNETS+kfjPCwHQ2pZYZ7uOitT9R6yqEA8liTZ5+Teyj+4dRl
	 DvXqwBpm5C85Kt2vg2TTwB/WGWXy9AJ/lm0lUtauc5oA6qWkA2ZWMj9lbXW5ICXV9b
	 X7oCjvcBS+Hnzl1SlKs5c+ooxzVJahDgbIPH1zjw=
Date: Tue, 27 May 2025 16:30:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,fengwei.yin@intel.com,dev.jain@arm.com,david@redhat.com,bharata@amd.com,baolin.wang@linux.alibaba.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-clean-up-refcount-check-using-folio_expected_ref_count.patch added to mm-new branch
Message-Id: <20250527233050.6DF59C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: clean up refcount check using folio_expected_ref_count()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-clean-up-refcount-check-using-folio_expected_ref_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-clean-up-refcount-check-using-folio_expected_ref_count.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: clean up refcount check using folio_expected_ref_count()
Date: Mon, 26 May 2025 18:28:20 +0000

Use folio_expected_ref_count() instead of open-coded logic in
is_refcount_suitable().  This avoids code duplication and improves
clarity.

Drop is_refcount_suitable() as it is no longer needed.

Link: https://lkml.kernel.org/r/20250526182818.37978-2-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Fengwei Yin <fengwei.yin@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-clean-up-refcount-check-using-folio_expected_ref_count
+++ a/mm/khugepaged.c
@@ -548,19 +548,6 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
-static bool is_refcount_suitable(struct folio *folio)
-{
-	int expected_refcount = folio_mapcount(folio);
-
-	if (!folio_test_anon(folio) || folio_test_swapcache(folio))
-		expected_refcount += folio_nr_pages(folio);
-
-	if (folio_test_private(folio))
-		expected_refcount++;
-
-	return folio_ref_count(folio) == expected_refcount;
-}
-
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
 					pte_t *pte,
@@ -652,7 +639,7 @@ static int __collapse_huge_page_isolate(
 		 * but not from this process. The other process cannot write to
 		 * the page, only trigger CoW.
 		 */
-		if (!is_refcount_suitable(folio)) {
+		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			folio_unlock(folio);
 			result = SCAN_PAGE_COUNT;
 			goto out;
@@ -1402,7 +1389,7 @@ static int hpage_collapse_scan_pmd(struc
 		 * has excessive GUP pins (i.e. 512).  Anyway the same check
 		 * will be done again later the risk seems low.
 		 */
-		if (!is_refcount_suitable(folio)) {
+		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
 			goto out_unmap;
 		}
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-fix-race-with-folio-split-free-using-temporary-reference.patch
mm-khugepaged-clean-up-refcount-check-using-folio_expected_ref_count.patch


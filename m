Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ECC156F28
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756871; cv=none; b=gROF2BRq1TNFVopHGR8jAB0KTG8/hF1nG6O/LIJQRPMIRkZx+SkdHxyljcBofneGwflX+CKhzyehXygFv6zKx0XFr5+VsRt1LZksC684npjSMytCHrapRIyg+zZqbgKifbovxQIET0kk/GVBkBe53wA/2zrGSj6NtGHvVNwmBuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756871; c=relaxed/simple;
	bh=g8kqWyVFXB3jV9aW/6ra1CyPs7iIpaOzBmfBQ6NsEvA=;
	h=Date:To:From:Subject:Message-Id; b=H16Fd0XaRP5f1glNb8sfGR0eFlHLMD8YOpzpgSCCHhoBtVHpVxAVW+q5J4tDYuQfvyGiL16FD4sH2G79lhiMQJ5Hanveu1BltT4Tik9UZuzi8Zsf0m5K5JfVoqnklMgCw/8xsuH56ewlGGV0k54HZHP2gzfbuGiiLvC85O0ImxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f5obafaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f5obafaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5A1C4CEED;
	Sun,  1 Jun 2025 05:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756871;
	bh=g8kqWyVFXB3jV9aW/6ra1CyPs7iIpaOzBmfBQ6NsEvA=;
	h=Date:To:From:Subject:From;
	b=f5obafaPZDyLqpWCOTBXba7H3iJ/cyLnsn2hKR+9UZWTUcPHjBFhVDN/KOAqA5tWN
	 UYHxZGRSYfzEh2RK2JI8foYxn+Kv8mVaMqv2bkfoxUoThSqB9cxzl0yzvS0lC6nchK
	 3yrBXOvGT8KNJn9jd2kE0cI3POEBIwx0wktnPa4c=
Date: Sat, 31 May 2025 22:47:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,fengwei.yin@intel.com,dev.jain@arm.com,david@redhat.com,bharata@amd.com,baolin.wang@linux.alibaba.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-clean-up-refcount-check-using-folio_expected_ref_count.patch removed from -mm tree
Message-Id: <20250601054751.4C5A1C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: clean up refcount check using folio_expected_ref_count()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-clean-up-refcount-check-using-folio_expected_ref_count.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



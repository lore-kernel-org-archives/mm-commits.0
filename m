Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB92A22089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957067; cv=none; b=g5rfw4jbuB2x+wAFfzv4/+puV4KzYNAmgm/Afq8Zm8rPmK4FqxMMsUWIK3Ot4DDglbmBkIDiHFGP5Q3imrqjZqe9eL2RXfutIY3Ne19/eJ9tFglR6RqVQawakotclkN5OieaXxIUuRbIv1zUsBmFtSimDhmbTSPKE0EZ3SZzMfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957067; c=relaxed/simple;
	bh=TAfYvEeLPdMXAyrxcOmASKKZALI3MaNME3x/kxEugVQ=;
	h=Date:To:From:Subject:Message-Id; b=Fy6YBYMtYn4qL2WgVFkE5Jk8ntZJwfCdkupFKkTmeIo9JZWp7HRnATAUKd0aEAS870RI2OLt38jNZWAFQ81d0+x6EOIP2Rzrcs6ejPwkYCi9h14LaH5BmevXYj19g2XAo1YmSUPOcy002oMy4yL+IEGcNwxwlsA1YMZD+4CLTR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GmC5Zrjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GmC5Zrjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F757C113CC;
	Mon,  6 May 2024 00:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957067;
	bh=TAfYvEeLPdMXAyrxcOmASKKZALI3MaNME3x/kxEugVQ=;
	h=Date:To:From:Subject:From;
	b=GmC5ZrjqQJVnyr4M4M1uWnjO9YBMhhqerTAd/1nvdWov2XabodYnKS4Vkhlqjm9bN
	 z0k6fLow714V3pio+zheWQcKFHcXBvBXRuC5Q7zuIsgZrtaCWjLqT8MQgiz9RZokHK
	 GYDp9i4lp9RbQlD7bBYquN9Jo+HAFuzNM+x5ZL9c=
Date: Sun, 05 May 2024 17:57:46 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch removed from -mm tree
Message-Id: <20240506005747.7F757C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: convert smaps_hugetlb_range() to work on folios
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: convert smaps_hugetlb_range() to work on folios
Date: Wed, 17 Apr 2024 11:23:13 +0200

Let's get rid of another page_mapcount() check and simply use
folio_likely_mapped_shared(), which is precise for hugetlb folios.

While at it, use huge_ptep_get() + pte_page() instead of ptep_get() +
vm_normal_page(), just like we do in pagemap_hugetlb_range().

No functional change intended.

Link: https://lkml.kernel.org/r/20240417092313.753919-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios
+++ a/fs/proc/task_mmu.c
@@ -730,19 +730,20 @@ static int smaps_hugetlb_range(pte_t *pt
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	struct page *page = NULL;
-	pte_t ptent = ptep_get(pte);
+	pte_t ptent = huge_ptep_get(pte);
+	struct folio *folio = NULL;
 
 	if (pte_present(ptent)) {
-		page = vm_normal_page(vma, addr, ptent);
+		folio = page_folio(pte_page(ptent));
 	} else if (is_swap_pte(ptent)) {
 		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
 		if (is_pfn_swap_entry(swpent))
-			page = pfn_swap_entry_to_page(swpent);
+			folio = pfn_swap_entry_folio(swpent);
 	}
-	if (page) {
-		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
+	if (folio) {
+		if (folio_likely_mapped_shared(folio) ||
+		    hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
_

Patches currently in -mm which might be from david@redhat.com are



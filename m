Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CBB2153D8
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 21:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761947472; cv=none; b=YjwnkUahAUaRtcxIxDbVINSpVLhVRgE2TD/kgacZyRkZEzN382tTr5VrEW96Oh2VVX/iVy/NMy9h5QkL33H5pTI56nZ67YkcSN7h2kdW2X0707HVUyDeSaQuxAHHfnRnvRImp6Fchf0TmxLR4HhrCIuybWRXTT0+8T1Qj0v5mOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761947472; c=relaxed/simple;
	bh=83ac0l0Ids1yudPOKRSkTcjdKSWv3MC+7ZqWYTGiPqw=;
	h=Date:To:From:Subject:Message-Id; b=ha1AtEIlYpaYYbjSvlGm77KfqkdpZu3rL36GAKtbcuHacXFCLQw7CxoV8rjeD9kaPhpBsohrRtEaGPm92DIhafzS5WG1xAYoxUNngTWtKPnFjAdqBWcjD6swGNcY51eT6ZpxKw6A32uhIpNyOMFXx57O87ixm0OZEbpB+/KMWDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i5RPwiMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i5RPwiMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05D6C4CEE7;
	Fri, 31 Oct 2025 21:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761947471;
	bh=83ac0l0Ids1yudPOKRSkTcjdKSWv3MC+7ZqWYTGiPqw=;
	h=Date:To:From:Subject:From;
	b=i5RPwiMRN9SvrMnELbyyOtQz0guHcVAsFA5rXQOHJ7Bk/Jd4V9BwDA2hpgXeGQR4p
	 Psumj1iFTQpm1qWCAURpCJGk4sivK13Hdfn8nPdQ0KomKI4DHYWDtcBwgwzw6mvINS
	 O6YwaHVnmvCxnCSmx0UurWZu3WDTYggwbbc/VsVk=
Date: Fri, 31 Oct 2025 14:51:10 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,david@redhat.com,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20251031215111.A05D6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: initialise the tags of the huge zero folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm/huge_memory: initialise the tags of the huge zero folio
Date: Fri, 31 Oct 2025 16:57:50 +0000

On arm64 with MTE enabled, a page mapped as Normal Tagged (PROT_MTE) in
user space will need to have its allocation tags initialised.  This is
normally done in the arm64 set_pte_at() after checking the memory
attributes.  Such page is also marked with the PG_mte_tagged flag to avoid
subsequent clearing.  Since this relies on having a struct page,
pte_special() mappings are ignored.

Commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero
folio special") maps the huge zero folio special and the arm64
set_pmd_at() will no longer zero the tags.  There is no guarantee that the
tags are zero, especially if parts of this huge page have been previously
tagged.

It's fairly easy to detect this by regularly dropping the caches to
force the reallocation of the huge zero folio.

Allocate the huge zero folio with the __GFP_ZEROTAGS flag.  In addition,
do not warn in the arm64 __access_remote_tags() when reading tags from the
huge zero page.

I bundled the arm64 change in here as well since they are both related to
the commit mapping the huge zero folio as special.

Link: https://lkml.kernel.org/r/20251031170133.280742-1-catalin.marinas@arm.com
Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/mte.c |    3 ++-
 mm/huge_memory.c        |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/mte.c~mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio
+++ a/arch/arm64/kernel/mte.c
@@ -476,7 +476,8 @@ static int __access_remote_tags(struct m
 
 		folio = page_folio(page);
 		if (folio_test_hugetlb(folio))
-			WARN_ON_ONCE(!folio_test_hugetlb_mte_tagged(folio));
+			WARN_ON_ONCE(!folio_test_hugetlb_mte_tagged(folio) &&
+				     !is_huge_zero_folio(folio));
 		else
 			WARN_ON_ONCE(!page_mte_tagged(page) && !is_zero_page(page));
 
--- a/mm/huge_memory.c~mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio
+++ a/mm/huge_memory.c
@@ -214,7 +214,8 @@ retry:
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
 		return true;
 
-	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
+	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
+				 ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
 	if (!zero_folio) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio.patch


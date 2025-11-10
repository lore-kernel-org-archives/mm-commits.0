Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEA52E6CD9
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 05:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752040; cv=none; b=QMVQ/1vx84VOCaPd34Hb8OMjha4wOsr+skdEuFpviYfyit0KYjGoVoscCLQs1Yq2HZIcMeJv1h4+a5ScunbJX/BOlGelYQPcGkCdsfE4InZ+rYl7+Hp1MmdmeCgkNaMdAlFlUALuq6AvXWis/XlAW3UwePIMMf6nIwfjSguRaio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752040; c=relaxed/simple;
	bh=0yR1Kte47JEv9po/+4QUMlBIzPHI6evgWLMht1+c4AI=;
	h=Date:To:From:Subject:Message-Id; b=W6U5/Jc7rV5hvFllQrWeHTb5qOxtyGVeBzdJff30D/clVVGA2dhq1IMdWELQ/Hi2G8qySUaAefEP+6Q5M8WWzu5L0zk43S6UrkgF/AMdTOcSh/VarfXh4EQjBRIQcciTN57eFhHV+/PsUsY5FDCCn2wQAs++x/5IgD25uWed2To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E6qImcL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E6qImcL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A7FC19421;
	Mon, 10 Nov 2025 05:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752039;
	bh=0yR1Kte47JEv9po/+4QUMlBIzPHI6evgWLMht1+c4AI=;
	h=Date:To:From:Subject:From;
	b=E6qImcL+zco7Ux1K49bya8fsgq+bcf/rrSy9udniypKD07p4DABrmJYa+lhMxe5f8
	 eq24nFO5XmU6wEmm4151Gh0bMCr0mBtm2ZSzt19sKEviCMmjcedSkk3T7ld7xrMeUZ
	 a2llOvcsbX9uxs88yjFIUvLO4mqJ3nz4x0IuFYKI=
Date: Sun, 09 Nov 2025 21:20:39 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,lance.yang@linux.dev,david@redhat.com,david@kernel.org,broonie@kernel.org,b-padhi@ti.com,aishwarya.tcv@arm.com,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio.patch removed from -mm tree
Message-Id: <20251110052039.C3A7FC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: initialise the tags of the huge zero folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[catalin.marinas@arm.com: handle arch mte_zero_clear_page_tags() code issuing MTE instructions]
  Link: https://lkml.kernel.org/r/aQi8dA_QpXM8XqrE@arm.com
Link: https://lkml.kernel.org/r/20251031170133.280742-1-catalin.marinas@arm.com
Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Beleswar Padhi <b-padhi@ti.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/mte.c |    3 ++-
 arch/arm64/mm/fault.c   |   10 ++++++++++
 mm/huge_memory.c        |    3 ++-
 3 files changed, 14 insertions(+), 2 deletions(-)

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
 
--- a/arch/arm64/mm/fault.c~mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio
+++ a/arch/arm64/mm/fault.c
@@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_f
 
 void tag_clear_highpage(struct page *page)
 {
+	/*
+	 * Check if MTE is supported and fall back to clear_highpage().
+	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
+	 * post_alloc_hook() will invoke tag_clear_highpage().
+	 */
+	if (!system_supports_mte()) {
+		clear_highpage(page);
+		return;
+	}
+
 	/* Newly allocated page, shouldn't have been tagged yet */
 	WARN_ON_ONCE(!try_page_mte_tagging(page));
 	mte_zero_clear_page_tags(page_address(page));
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



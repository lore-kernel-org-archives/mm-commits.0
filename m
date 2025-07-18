Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E9B18E20
	for <mm-commits@vger.kernel.org>; Fri, 18 Jul 2025 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752873146; cv=none; b=SOWZb12JCBAga6kpKFG2jvuQUMw+pU/wxYjhaO/2m++ILR3bSLyHeuGC5VTHyalhb+Qid9u1l1FBO0z/OQ0pvCMyVVC7ivJDpqEoOrobJ/NLdvoEkyJLKG74eBkkxPnTGWiixait6/He7Uj7X7BLGgjEoay3v1tGY3dLem6APBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752873146; c=relaxed/simple;
	bh=xBT05QTHurv8doJHyyd64jHCTUQoLPr2Cd/AVRBUZMM=;
	h=Date:To:From:Subject:Message-Id; b=LRt0Dd7jM1JblX77g1taXt4oeaInphkUTFWPsC+ulkpcn+qNOdadP0K9gX/7rilMETp2Yj9hUFX1cWbxUyi90HMhzF3ThYmPUUW6zTQFsZ11UMyU+SWm3toEEOqj4i8E7INImXHY+f1OK9RVGNDpy6FVoRVyDjluvHOy2PEn9t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E7/GqGnD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E7/GqGnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ED2C4CEEB;
	Fri, 18 Jul 2025 21:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752873145;
	bh=xBT05QTHurv8doJHyyd64jHCTUQoLPr2Cd/AVRBUZMM=;
	h=Date:To:From:Subject:From;
	b=E7/GqGnDPlCuVwVoMKAgTpN2czvOQYblZqb1+P4Its901AbHZuEOQXbYuhiih/M54
	 KwCO5lpdBkfjGK9iMlRa+x6Ingo9h8lJp2r08+znm9D7yBi87uc2DRzslQtiX469L+
	 dJPbcdesP6c31oGDjLTAk5aBU/xv7/l8ej82U1o0=
Date: Fri, 18 Jul 2025 14:12:25 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,antonio@mandelbit.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch added to mm-new branch
Message-Id: <20250718211225.A1ED2C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: remove after_split label in __split_unmapped_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: remove after_split label in __split_unmapped_folio()
Date: Fri, 18 Jul 2025 14:37:16 -0400

Check stop_split instead to avoid the goto statement.

Link: https://lkml.kernel.org/r/20250718183720.4054515-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio
+++ a/mm/huge_memory.c
@@ -3463,18 +3463,18 @@ static int __split_unmapped_folio(struct
 				if (xas_error(xas)) {
 					ret = xas_error(xas);
 					stop_split = true;
-					goto after_split;
 				}
 			}
 		}
 
-		folio_split_memcg_refs(folio, old_order, split_order);
-		split_page_owner(&folio->page, old_order, split_order);
-		pgalloc_tag_split(folio, old_order, split_order);
+		if (!stop_split) {
+			folio_split_memcg_refs(folio, old_order, split_order);
+			split_page_owner(&folio->page, old_order, split_order);
+			pgalloc_tag_split(folio, old_order, split_order);
 
-		__split_folio_to_order(folio, old_order, split_order);
+			__split_folio_to_order(folio, old_order, split_order);
+		}
 
-after_split:
 		/*
 		 * Iterate through after-split folios and update folio stats.
 		 * But in buddy allocator like split, the folio
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch
mm-huge_memory-deduplicate-code-in-__folio_split.patch
mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch
mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch
mm-huge_memory-refactor-after-split-page-cache-code.patch


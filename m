Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DA713C691
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291692; cv=none; b=UcZfl5oaOJOWK4Hb6ssDNe80lVB+mxwvHI987Cr1y53ht3uag6uxku2FjN3c23pD3qG6SKV7rciCRTB940vUchXRhF6lKIAgwDquPpo9xByMkvfkPu+swSCGkfXgzQb47M36OmFo3BIhNpKu1xve7BCnqBiX1J71WdPjTdXEvYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291692; c=relaxed/simple;
	bh=8oF2Mb6IwwRMujE4/jAWSs1o/X2Oqu0/U4askggKynA=;
	h=Date:To:From:Subject:Message-Id; b=odG1N+iv+xecqXEjYkh1DOzqvzhD8fGO0zkVmiH9Hpd/9H8XdIudJS3GapqzW0yI0Cq0Pi0GqX4tLf1gPdGFNUiV4RKpbS+/o0+v7hqFNOMKGL+mn27Y/jZ4//H9Rt6c+rh5R9T8H2wGajiC04H25aW42JUVqv5icUEsEAFrBFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tWl8bLsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tWl8bLsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B298C32782;
	Tue, 25 Jun 2024 05:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291692;
	bh=8oF2Mb6IwwRMujE4/jAWSs1o/X2Oqu0/U4askggKynA=;
	h=Date:To:From:Subject:From;
	b=tWl8bLsPNUhrxv0uCi4UWbleUKrOKtiaJLHiII/IdGOKJSVz1xnZdYCzRuVUOJEjv
	 BSGUDB5PmP9f7R7E4xMJULt5NhYZF33tW4cJWQozGE2HclHS/DGJ9STWKxOWPZhGmV
	 bUtuRDLSoG0yXUFx2FFRZ6jCIVbCOIxYZ4qkgT6Q=
Date: Mon, 24 Jun 2024 22:01:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,ryan.roberts@arm.com,libang.li@antgroup.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mlock-implement-folio_mlock_step-using-folio_pte_batch.patch removed from -mm tree
Message-Id: <20240625050132.1B298C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mlock: implement folio_mlock_step() using folio_pte_batch()
has been removed from the -mm tree.  Its filename was
     mm-mlock-implement-folio_mlock_step-using-folio_pte_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/mlock: implement folio_mlock_step() using folio_pte_batch()
Date: Tue, 11 Jun 2024 09:04:18 +0800

Let's make folio_mlock_step() simply a wrapper around folio_pte_batch(),
which will greatly reduce the cost of ptep_get() when scanning a range of
contptes.

Link: https://lkml.kernel.org/r/20240611010418.70797-1-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Barry Song <21cnbao@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Bang Li <libang.li@antgroup.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/mlock.c~mm-mlock-implement-folio_mlock_step-using-folio_pte_batch
+++ a/mm/mlock.c
@@ -307,26 +307,15 @@ void munlock_folio(struct folio *folio)
 static inline unsigned int folio_mlock_step(struct folio *folio,
 		pte_t *pte, unsigned long addr, unsigned long end)
 {
-	unsigned int count, i, nr = folio_nr_pages(folio);
-	unsigned long pfn = folio_pfn(folio);
+	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
+	unsigned int count = (end - addr) >> PAGE_SHIFT;
 	pte_t ptent = ptep_get(pte);
 
 	if (!folio_test_large(folio))
 		return 1;
 
-	count = pfn + nr - pte_pfn(ptent);
-	count = min_t(unsigned int, count, (end - addr) >> PAGE_SHIFT);
-
-	for (i = 0; i < count; i++, pte++) {
-		pte_t entry = ptep_get(pte);
-
-		if (!pte_present(entry))
-			break;
-		if (pte_pfn(entry) - pfn >= nr)
-			break;
-	}
-
-	return i;
+	return folio_pte_batch(folio, addr, pte, ptent, count, fpb_flags, NULL,
+			       NULL, NULL);
 }
 
 static inline bool allow_mlock_munlock(struct folio *folio,
_

Patches currently in -mm which might be from ioworker0@gmail.com are



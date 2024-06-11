Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263FC101E2
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 21:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718141227; cv=none; b=BFDWbDUBs+oAUc/9FWJWr1Q/AgPvpVnz4ufw+wpqC+DqBYL5TxtxUjxqYY1VRRxhOpymE34LEuILkgOuG/Vbp0ofrrP4dMVOKm0j2QR1Iyp+tiZzDZyAef55a+/cX7NO5CNhXjQe1PArEgXufQXBAkYk89555EOIrsTHV8HNats=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718141227; c=relaxed/simple;
	bh=Nj85QDTw8PzOTlT81Jx+rJ60rCXfpNWpLhmYHqbWV1M=;
	h=Date:To:From:Subject:Message-Id; b=rA/Ghc9tdKrSlvoJj86KxkAEfr0wXMtMVuSGr72qh5XDiHSi7HTZObNWmymGDnpeW6tzO/pEuwFGKvDjZh1NxW3w2mlremq666Zd5hOOWmcvrvs4Oo23HTNrKvf5OBTNMBleZgWvrh54pp50BitgGp82aVCR+tE7C7/iWTYFgGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XttcSLrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XttcSLrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5DEC2BD10;
	Tue, 11 Jun 2024 21:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718141226;
	bh=Nj85QDTw8PzOTlT81Jx+rJ60rCXfpNWpLhmYHqbWV1M=;
	h=Date:To:From:Subject:From;
	b=XttcSLrVtUEUtYHZPpqXW/Gc3faf/hSp/nFtPMt0MBEaUTbueRAGW7tMQD3EAmMN+
	 141hytPiPNSxJDwJ/5JAjsvzCU+mBEkRhf3nZqaufIXLKzPDAZqWXQZkK8H+3ecmoF
	 TRAKre/+NroaQIw6zlFpKtp11YLLFSTuwpAFeVD8=
Date: Tue, 11 Jun 2024 14:27:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,ryan.roberts@arm.com,libang.li@antgroup.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-implement-folio_mlock_step-using-folio_pte_batch.patch added to mm-unstable branch
Message-Id: <20240611212706.AB5DEC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mlock: implement folio_mlock_step() using folio_pte_batch()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-implement-folio_mlock_step-using-folio_pte_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-implement-folio_mlock_step-using-folio_pte_batch.patch

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

mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch
mm-rmap-add-helper-to-restart-pgtable-walk-on-changes.patch
mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch
mm-mlock-implement-folio_mlock_step-using-folio_pte_batch.patch


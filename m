Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D5553E1D
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970518; cv=none; b=D6s8tNPbtJ5hFlIvQ2kg7UJjBOMYjZWjIQNuHPhz7Nh9D9NPMbH1YxWpE+uXYpzulEv2gbRwSUT6DEiLeKQFZ9dLovQ5FCXTFWOVqGVqyRhWYjlQr4lgBQNfKbSayFD59+UAzJp/RTMx1CxMoRA5MPGNfFjudXAFyntbErSpZrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970518; c=relaxed/simple;
	bh=gTAMMvS0KdU0OixnCHHGpWy7HbIPpJI/O4KFXrX/uJM=;
	h=Date:To:From:Subject:Message-Id; b=sc+wxzULY3nwZatY10QrD6fZ6BtswevnmfO5RT97qDdoCb4YRAnw41S1y0fmwULfhpDuf8DmAS1sxxc+TybnqA/UMLvhgCOviPVaJx6xT0h0Rvm9wXX55OA6y5p/jscaFofc2i0+cV7sk618I0fp2mW5pwpPY99oCXc979jTE34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PBqluUdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PBqluUdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E42C43394;
	Tue, 23 Jan 2024 00:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970518;
	bh=gTAMMvS0KdU0OixnCHHGpWy7HbIPpJI/O4KFXrX/uJM=;
	h=Date:To:From:Subject:From;
	b=PBqluUdvu52wyz2CGZdoSx37ByrixvTrpiEfVmNekOawrnNcSDQI4EY551hWIfwOA
	 ds0ZF3WLBfs0en6ehAyCYdu5wM2pOmSvtqF0ii/Oj1isETCR4YzVz/W0hb5y9BEBbZ
	 E6ydQqaoUSVX/o+IWBDpTIL25UPneDneOsLH7iIU=
Date: Mon, 22 Jan 2024 16:41:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-folio_set_dirty-vs-folio_mark_dirty.patch added to mm-hotfixes-unstable branch
Message-Id: <20240123004157.B7E42C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix folio_set_dirty() vs. folio_mark_dirty()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-folio_set_dirty-vs-folio_mark_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-folio_set_dirty-vs-folio_mark_dirty.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: fix folio_set_dirty() vs. folio_mark_dirty()
Date: Mon, 22 Jan 2024 18:54:07 +0100

The correct folio replacement for "set_page_dirty()" is
"folio_mark_dirty()", not "folio_set_dirty()".  Using the latter won't
properly inform the FS using the dirty_folio() callback.

This has been found by code inspection, but likely this can result in some
real trouble.

Link: https://lkml.kernel.org/r/20240122175407.307992-1-david@redhat.com
Fixes: a8e61d584eda0 ("mm/huge_memory: page_remove_rmap() -> folio_remove_rmap_pmd()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-folio_set_dirty-vs-folio_mark_dirty
+++ a/mm/huge_memory.c
@@ -2437,7 +2437,7 @@ static void __split_huge_pmd_locked(stru
 			page = pmd_page(old_pmd);
 			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
-				folio_set_dirty(folio);
+				folio_mark_dirty(folio);
 			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
 				folio_set_referenced(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
@@ -3563,7 +3563,7 @@ int set_pmd_migration_entry(struct page_
 	}
 
 	if (pmd_dirty(pmdval))
-		folio_set_dirty(folio);
+		folio_mark_dirty(folio);
 	if (pmd_write(pmdval))
 		entry = make_writable_migration_entry(page_to_pfn(page));
 	else if (anon_exclusive)
_

Patches currently in -mm which might be from david@redhat.com are

uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch
mm-huge_memory-fix-folio_set_dirty-vs-folio_mark_dirty.patch
arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
risc-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch


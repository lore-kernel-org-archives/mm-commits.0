Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C6B36E46C
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776959908; cv=none; b=d7KKjjMgWHk6wNcyaL6e1ts1GllPAXwPOhd2n4DcQ3LpHDHGKIVWeWF0w7MowccOAK+ltB2I2x5s145WmknsnLDX+DBc3hhFoFsKXbcym3EkQ5rbaG9wDFNaUScmFfIk2G3pgORXwig9jvFonvTDtObVndlsZlUYAPYcf5RuGrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776959908; c=relaxed/simple;
	bh=v99z74wNhSvv/8tI4DFq3GRSaxlzkOsGzMBJMBNQrwk=;
	h=Date:To:From:Subject:Message-Id; b=W2rAETv6TSasW3UiJOVtPzzX/1GiG7oxxFl0UQV+Tn3j+V6g/aKH2p+VfI2QGUWJHCZlDhKTuPAJKMregY4o8yFn5LO43kIT+M75zY+dPmxA3xFO2NkuacnBH45v5GELIe+y/LSo2ahmrJpkua/reGngfaTP+ZbjQlfVUnq4mnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fLbCiq7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fLbCiq7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B8EC2BCAF;
	Thu, 23 Apr 2026 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776959907;
	bh=v99z74wNhSvv/8tI4DFq3GRSaxlzkOsGzMBJMBNQrwk=;
	h=Date:To:From:Subject:From;
	b=fLbCiq7dLXjdty3Ad+/2i84FwTHzK8sqL6lvIcfAEFRNF4qLNDR/HHPmFw4oSmhS7
	 3m7P20liiePGXRhdCOm8Tpjsz26020crwazdRODKbR36rbhud/og4uivpEVV4dBghU
	 rAyNDigPpcnFxq+ytlUigUDUVYhTY3g8pjhMWyIY=
Date: Thu, 23 Apr 2026 08:58:27 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,peterx@redhat.com,kevin.brodsky@arm.com,jhubbard@nvidia.com,jgg@ziepe.ca,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@kernel.org,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-cleanup-pgtable-entry-accessors.patch added to mm-new branch
Message-Id: <20260423155827.D9B8EC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: cleanup pgtable entry accessors
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-cleanup-pgtable-entry-accessors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-cleanup-pgtable-entry-accessors.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm/gup: cleanup pgtable entry accessors
Date: Tue, 21 Apr 2026 07:17:54 +0200

PMD and PUD entries revalidation has the same semantics as PTE entry
revalidation.  Convert the remaining direct entry dereferences to the
corresponding accessors.

The PTE validation in gup_fast_pte_range() is inconsistent with the prior
value acquisition in the sense that it drops the lockless access
semantics.

Use the lockless accessor not only for the PTE, but also for the PMD
validation, which is likewise inconsistent with the prior value
acquisition in gup_fast_pmd_range().

Link: https://lore.kernel.org/20260421051754.1691221-1-agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-cleanup-pgtable-entry-accessors
+++ a/mm/gup.c
@@ -2865,8 +2865,8 @@ static int gup_fast_pte_range(pmd_t pmd,
 		if (!folio)
 			goto pte_unmap;
 
-		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
-		    unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
+		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
+		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -2942,7 +2942,7 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 	if (!folio)
 		return 0;
 
-	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
+	if (unlikely(pmd_val(orig) != pmd_val(pmdp_get_lockless(pmdp)))) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2985,7 +2985,7 @@ static int gup_fast_pud_leaf(pud_t orig,
 	if (!folio)
 		return 0;
 
-	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
+	if (unlikely(pud_val(orig) != pud_val(pudp_get(pudp)))) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

mm-gup-cleanup-pgtable-entry-accessors.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414A430BF52;
	Thu, 25 Jun 2026 21:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782421769; cv=none; b=WIZS3qjNDFjDZRraNX0lMz3iJTvgtgmrKXZ6cu/xfJu7YeAu0g8UxdTevjkXZJenlRhH0IqjHsW6COAzM/m9HTO26By5Mb7kvw91W9Ae8b/at/lGdIPZpZqLNPppsoxP421DRyhyMYcMv9RTxnY80Jk91rBLfVhWnWfkbTEgjOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782421769; c=relaxed/simple;
	bh=x8lPMB9iFw3HKoEEo1iPkq9HS6NrGQdWyMDzsDYckdk=;
	h=Date:To:From:Subject:Message-Id; b=IMhOuwrwS2iwIGR52Qo5u/WbEYsDaa87DAIWgvDLhBPYjMLVf0m8ZgzShReewz9NQcq1HJyCXZmJottQTrGN3v8bOV5KzcSHpkEqUnv5J32oh9QkvUlhErtILmCHE3vTnGlLguURYwJrLzyrlvakL+Ul16jVOZifq8i3j8yk8zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L0d6gc63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L0d6gc63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AC41F000E9;
	Thu, 25 Jun 2026 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782421767;
	bh=a3En7h51SVTLY397zWxNCnhXgLxn2XCd8R1dGxgkZOc=;
	h=Date:To:From:Subject;
	b=L0d6gc63BYoVm/LAmI8BbVlbx+PMhyztbAPQLyTUkfXfXh+faa+6rd1DEKVlvX751
	 ENQ4FaC4HQwlvPRIykJvV64vmaDuEOB0rgApuI47mdMAySNF6c/z7YlLb/u+6Gr2uQ
	 kYzfaWQWHdQS92rsN5rjB0s0iRuRiwRXblriEs1Q=
Date: Thu, 25 Jun 2026 14:09:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,ljs@kernel.org,liam@infradead.org,kas@kernel.org,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch removed from -mm tree
Message-Id: <20260625210927.B8AC41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: use huge_ptep_get() in try_to_unmap_one()
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: use huge_ptep_get() in try_to_unmap_one()
Date: Thu, 25 Jun 2026 04:28:51 +0000

try_to_unmap_one() handles hugetlb folios when memory failure needs to
replace a poisoned hugetlb mapping with a hwpoison entry.  In that case
page_vma_mapped_walk() returns the hugetlb entry in pvmw.pte, but the code
reads it with ptep_get() before decoding the PFN.

That is wrong on architectures where hugetlb entries are not encoded as
regular PTEs.  On s390, for example, a raw huge RSTE must be converted by
huge_ptep_get() before helpers such as pte_pfn() can inspect it.  A raw
decode can select the wrong subpage, so try_to_unmap_one() can install a
hwpoison entry for the wrong PFN.

The userspace-visible result is that a later access to the poisoned
hugetlb subpage can miss the expected SIGBUS.  With DEBUG_VM, the wrong
subpage can also trip the PageHWPoison check.

Use huge_ptep_get() for hugetlb mappings before decoding the PFN.

Before c7ab0d2fdc84, the bug existed in the form of a plain dereference:
we would check the head page pfn of the hugetlb with pte_pfn(*pte), and
bail out on mismatch.  This would mean that the hwpoisoned entry will not
get installed.

Link: https://lore.kernel.org/20260625042853.2752898-1-dev.jain@arm.com
Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/rmap.c~mm-rmap-use-huge_ptep_get-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct foli
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
-		/*
-		 * Handle PFN swap PTEs, such as device-exclusive ones, that
-		 * actually map pages.
-		 */
-		pteval = ptep_get(pvmw.pte);
+		address = pvmw.address;
+		if (folio_test_hugetlb(folio)) {
+			pteval = huge_ptep_get(mm, address, pvmw.pte);
+		} else {
+			/*
+			 * Handle PFN swap PTEs, such as device-exclusive ones,
+			 * that actually map pages.
+			 */
+			pteval = ptep_get(pvmw.pte);
+		}
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
@@ -2110,7 +2115,6 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch
mm-mprotect-drop-sub-from-batching-context.patch


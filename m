Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B2237B017
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388660; cv=none; b=PwSiCfrplvelh5ltnP9No1mw+iw9EmcG6ZfEb7BkofmY4Jqpv1/Jc7ZTcgbLCMwGgPQLP6vM8xH5Qm38jiUp5PfajlnKipxFDcUzewEkwcXxHFK9EXbWuA9HjyazDu9WuvMZ5/LVT1VJq8Pc8bwS3n0aT0XosscJuRI0ekN+gOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388660; c=relaxed/simple;
	bh=GKa3vjl2FTVXFIFW8AqLwt9VsVO8toHPpiNWRXijupo=;
	h=Date:To:From:Subject:Message-Id; b=nv1ybh6cXRPXcsru1gXkS1Anj5pcM8pr5QbVh5JfJeN4zkacDcGU70MkZqsYnrSYOYkOkRq/PQEBHO7+5IhAbPyC/GJjgLngm3+lMIg17DCkthpGVZCEN7+jIrxSiAVe4cq0uvuHBjU9dyLHtnxDQzt4iNj+42yT9KFWmTKLFiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f4vTBXwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f4vTBXwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91965C19424;
	Tue, 24 Mar 2026 21:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388660;
	bh=GKa3vjl2FTVXFIFW8AqLwt9VsVO8toHPpiNWRXijupo=;
	h=Date:To:From:Subject:From;
	b=f4vTBXwuJ2cr91JNsZdoQTV6QWxwBHwrc4nucH5HAHdV5KU3qxOMfBC1XIId0NGai
	 5qoeDpCWSWwPozt6llC0DW7+eO3KxTKnBPGFdq9OM4tVBp81CDkSDnh2UyR4vwar/Q
	 T0sOgpXaMzMQgl3r+rpQtPQRDpGB3koo1ZOuYEek=
Date: Tue, 24 Mar 2026 14:44:20 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ryan.roberts@arm.com,david@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_vm_pgtable-replace-write_once-with-pxd_clear.patch removed from -mm tree
Message-Id: <20260324214420.91965C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug_vm_pgtable: replace WRITE_ONCE() with pxd_clear()
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-replace-write_once-with-pxd_clear.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: replace WRITE_ONCE() with pxd_clear()
Date: Fri, 27 Feb 2026 06:12:04 +0000

Replace WRITE_ONCE() with generic pxd_clear() to clear out the page table
entries as required.  Besides this does not cause any functional change as
well.

Link: https://lkml.kernel.org/r/20260227061204.2215395-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Ackeed-by: SeongJae Park <sj@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-replace-write_once-with-pxd_clear
+++ a/mm/debug_vm_pgtable.c
@@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct
 	 * X86 defined pmd_set_huge() verifies that the given
 	 * PMD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pmdp, __pmd(0));
+	pmd_clear(args->pmdp);
 	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
 	WARN_ON(!pmd_clear_huge(args->pmdp));
 	pmd = pmdp_get(args->pmdp);
@@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct
 	 * X86 defined pud_set_huge() verifies that the given
 	 * PUD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pudp, __pud(0));
+	pud_clear(args->pudp);
 	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
 	WARN_ON(!pud_clear_huge(args->pudp));
 	pud = pudp_get(args->pudp);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AAA1E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010981; cv=none; b=AG8cXzuloo8N2CX8jtAL5tx4tirjO4ERz65O8fIaXX+Cyq7Fs4AANa+pvngS6/BcOZCsOS7eVzibiYnbsdvE+zwpka2sugzt8DDFNWP3ZXc5JtdRktpT3FlhQxwevCf5SGxvFz0kVqp5aE+dL8l/Q6fzIPG7QTeDnjRdmBj1mt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010981; c=relaxed/simple;
	bh=8A/a/kEQLq56R9jJJJZseXJ6A8z2fkUn/Hni1tMnUuc=;
	h=Date:To:From:Subject:Message-Id; b=Brw9xIcoVSQfQcXcOB0ISEyaPHmOFiwH/sY8OuvRhwYXU1v5TlG19ylxVqXbs7Fx8KNbMtHqgeWdUmu3spZKQXsMHdY7KpxBCiXf5KXiHTNYDra+o6svjwd4xdeaRDzP+Bxkg+ZHWMFV4iWQi9r67WEwOLOKpM4YI8u6x9gSndU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fPUeTvvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fPUeTvvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F67DC4CEED;
	Mon, 12 May 2025 00:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010980;
	bh=8A/a/kEQLq56R9jJJJZseXJ6A8z2fkUn/Hni1tMnUuc=;
	h=Date:To:From:Subject:From;
	b=fPUeTvvdUbc3LY4gvpCo4Fkw9n8Llxrlb98Zi8eHvTK9lNrrCFw/h3xFuqcQ1S1Mz
	 F+G74xylIwIWqIXXF00HJs5F+NHYe/oKGEPNd48Q+DYMacs+nGsPLb8wRSLx2oncTi
	 jmEY6obFq1Pnj5QXcNY+D6F0E9ZXI2cd5AZVCeEM=
Date: Sun, 11 May 2025 17:49:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] um-remove-custom-definition-of-mk_pte.patch removed from -mm tree
Message-Id: <20250512004940.9F67DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: um: remove custom definition of mk_pte()
has been removed from the -mm tree.  Its filename was
     um-remove-custom-definition-of-mk_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: um: remove custom definition of mk_pte()
Date: Wed, 2 Apr 2025 19:16:59 +0100

Move the pfn_pte() definitions from the 2level and 4level files to the
generic pgtable.h and delete the custom definition of mk_pte() so that we
use the central definition.

Link: https://lkml.kernel.org/r/20250402181709.2386022-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/pgtable-2level.h |    1 -
 arch/um/include/asm/pgtable-4level.h |    9 ---------
 arch/um/include/asm/pgtable.h        |   18 ++++++++----------
 3 files changed, 8 insertions(+), 20 deletions(-)

--- a/arch/um/include/asm/pgtable-2level.h~um-remove-custom-definition-of-mk_pte
+++ a/arch/um/include/asm/pgtable-2level.h
@@ -37,7 +37,6 @@ static inline void pgd_mkuptodate(pgd_t
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
 
 #define pte_pfn(x) phys_to_pfn(pte_val(x))
-#define pfn_pte(pfn, prot) __pte(pfn_to_phys(pfn) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot) __pmd(pfn_to_phys(pfn) | pgprot_val(prot))
 
 #endif
--- a/arch/um/include/asm/pgtable-4level.h~um-remove-custom-definition-of-mk_pte
+++ a/arch/um/include/asm/pgtable-4level.h
@@ -102,15 +102,6 @@ static inline unsigned long pte_pfn(pte_
 	return phys_to_pfn(pte_val(pte));
 }
 
-static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
-{
-	pte_t pte;
-	phys_t phys = pfn_to_phys(page_nr);
-
-	pte_set_val(pte, phys, pgprot);
-	return pte;
-}
-
 static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
 	return __pmd((page_nr << PAGE_SHIFT) | pgprot_val(pgprot));
--- a/arch/um/include/asm/pgtable.h~um-remove-custom-definition-of-mk_pte
+++ a/arch/um/include/asm/pgtable.h
@@ -260,19 +260,17 @@ static inline int pte_same(pte_t pte_a,
 	return !((pte_val(pte_a) ^ pte_val(pte_b)) & ~_PAGE_NEEDSYNC);
 }
 
-/*
- * Conversion functions: convert a page and protection to a page entry,
- * and a page entry and page directory to the page they refer to.
- */
-
 #define __virt_to_page(virt) phys_to_page(__pa(virt))
 #define virt_to_page(addr) __virt_to_page((const unsigned long) addr)
 
-#define mk_pte(page, pgprot) \
-	({ pte_t pte;					\
-							\
-	pte_set_val(pte, page_to_phys(page), (pgprot));	\
-	pte;})
+static inline pte_t pfn_pte(unsigned long pfn, pgprot_t pgprot)
+{
+	pte_t pte;
+
+	pte_set_val(pte, pfn_to_phys(pfn), pgprot);
+
+	return pte;
+}
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
_

Patches currently in -mm which might be from willy@infradead.org are



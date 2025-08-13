Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F01A2F0C73
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 23:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755126387; cv=none; b=I6WRcVqu1zaZuGcAjtjXD7ZagulPN5PW5UjSQ75yv2x/qR5vl6zTs8bTvrG93RJ/iT4uNcwsSj9Bzohw26RSrgqxd6/PSWf4FnQ8N2tzxvOdNbIp14WzRoqcFkIEGDnmu/cb8p6TFBmEbWWGXwA4bOuuomWPgF5pDhwuKIwinck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755126387; c=relaxed/simple;
	bh=0dw/0iK+KAvyOrF6rhnLNB87rmMtdI4fTHxf9zLRhjI=;
	h=Date:To:From:Subject:Message-Id; b=mD17kBS6WHqPuAPtxhL9mMj7LaQ/OyGKKTUTWiaCGy8az0UTXEvvOJcrzSgpnQFqyVbKm/81PF8qMnsy3GmqojJfviCE8TeBHiFsOCnqL7WjgA8NVX5wk8+zD0cykli7AS1gh2ueOVTXYIp5IePeTB4GYBquWvfWIFW55i7NJjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=csg6IhjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="csg6IhjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5364CC4CEEB;
	Wed, 13 Aug 2025 23:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755126387;
	bh=0dw/0iK+KAvyOrF6rhnLNB87rmMtdI4fTHxf9zLRhjI=;
	h=Date:To:From:Subject:From;
	b=csg6IhjETQ8RrU8AVeWBMKLk9qCEHX3vlHyWpiPJ5vrN2PTWs0tdRFhiCJ61m9pBY
	 3+/j+YfSS0QaK7DwyaOvoxpE5D3OMJzRns/5I+atzVR0mvD7LyZW6IKx7IzB2Vjbz5
	 SoykdsfSzOj6JJctImXVXFwUCdkxRgY3wZ11R3vE=
Date: Wed, 13 Aug 2025 16:06:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,nicholas@linux.ibm.com,mingo@kernel.org,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch added to mm-new branch
Message-Id: <20250813230627.5364CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: mm: use set_pte_at_unchecked() for internal usages
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch

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
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: powerpc: mm: use set_pte_at_unchecked() for internal usages
Date: Wed, 13 Aug 2025 16:26:13 +1000

In the new set_ptes() API, set_pte_at() (a special case of set_ptes()) is
intended to be instrumented by the page table check facility.  There are
however several other routines that constitute the API for setting page
table entries, including set_pmd_at() among others.  Such routines are
themselves implemented in terms of set_ptes_at().

A future patch providing support for page table checking on powerpc must
take care to avoid duplicate calls to page_table_check_p{te,md,ud}_set(). 
Allow for assignment of pte entries without instrumentation through the
set_pte_at_unchecked() routine introduced in this patch.

Cause API-facing routines that call set_pte_at() to instead call
set_pte_at_unchecked(), which will remain uninstrumented by page table
check.  set_ptes() is itself implemented by calls to __set_pte_at(), so
this eliminates redundant code.

[ajd@linux.ibm.com: don't change to unchecked for early boot/kernel mappings]
Link: https://lkml.kernel.org/r/20250813062614.51759-13-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h       |    2 ++
 arch/powerpc/mm/book3s64/pgtable.c       |    6 +++---
 arch/powerpc/mm/book3s64/radix_pgtable.c |    6 +++---
 arch/powerpc/mm/pgtable.c                |    8 ++++++++
 4 files changed, 16 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-use-set_pte_at_unchecked-for-internal-usages
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -46,6 +46,8 @@ struct mm_struct;
 void set_ptes(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 		pte_t pte, unsigned int nr);
 #define set_ptes set_ptes
+void set_pte_at_unchecked(struct mm_struct *mm, unsigned long addr,
+			  pte_t *ptep, pte_t pte);
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
--- a/arch/powerpc/mm/book3s64/pgtable.c~powerpc-mm-use-set_pte_at_unchecked-for-internal-usages
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -127,7 +127,7 @@ void set_pmd_at(struct mm_struct *mm, un
 	WARN_ON(!(pmd_leaf(pmd)));
 #endif
 	trace_hugepage_set_pmd(addr, pmd_val(pmd));
-	return set_pte_at(mm, addr, pmdp_ptep(pmdp), pmd_pte(pmd));
+	return set_pte_at_unchecked(mm, addr, pmdp_ptep(pmdp), pmd_pte(pmd));
 }
 
 void set_pud_at(struct mm_struct *mm, unsigned long addr,
@@ -144,7 +144,7 @@ void set_pud_at(struct mm_struct *mm, un
 	WARN_ON(!(pud_leaf(pud)));
 #endif
 	trace_hugepage_set_pud(addr, pud_val(pud));
-	return set_pte_at(mm, addr, pudp_ptep(pudp), pud_pte(pud));
+	return set_pte_at_unchecked(mm, addr, pudp_ptep(pudp), pud_pte(pud));
 }
 
 static void do_serialize(void *arg)
@@ -549,7 +549,7 @@ void ptep_modify_prot_commit(struct vm_a
 	if (radix_enabled())
 		return radix__ptep_modify_prot_commit(vma, addr,
 						      ptep, old_pte, pte);
-	set_pte_at(vma->vm_mm, addr, ptep, pte);
+	set_pte_at_unchecked(vma->vm_mm, addr, ptep, pte);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-use-set_pte_at_unchecked-for-internal-usages
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1606,7 +1606,7 @@ void radix__ptep_modify_prot_commit(stru
 	    (atomic_read(&mm->context.copros) > 0))
 		radix__flush_tlb_page(vma, addr);
 
-	set_pte_at(mm, addr, ptep, pte);
+	set_pte_at_unchecked(mm, addr, ptep, pte);
 }
 
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
@@ -1617,7 +1617,7 @@ int pud_set_huge(pud_t *pud, phys_addr_t
 	if (!radix_enabled())
 		return 0;
 
-	set_pte_at(&init_mm, 0 /* radix unused */, ptep, new_pud);
+	set_pte_at_unchecked(&init_mm, 0 /* radix unused */, ptep, new_pud);
 
 	return 1;
 }
@@ -1664,7 +1664,7 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t
 	if (!radix_enabled())
 		return 0;
 
-	set_pte_at(&init_mm, 0 /* radix unused */, ptep, new_pmd);
+	set_pte_at_unchecked(&init_mm, 0 /* radix unused */, ptep, new_pmd);
 
 	return 1;
 }
--- a/arch/powerpc/mm/pgtable.c~powerpc-mm-use-set_pte_at_unchecked-for-internal-usages
+++ a/arch/powerpc/mm/pgtable.c
@@ -224,6 +224,14 @@ void set_ptes(struct mm_struct *mm, unsi
 	}
 }
 
+void set_pte_at_unchecked(struct mm_struct *mm, unsigned long addr,
+			  pte_t *ptep, pte_t pte)
+{
+	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
+	pte = set_pte_filter(pte, addr);
+	__set_pte_at(mm, addr, ptep, pte, 0);
+}
+
 void unmap_kernel_page(unsigned long va)
 {
 	pmd_t *pmdp = pmd_off_k(va);
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are

mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch
mm-provide-address-parameter-to-ptemdud_user_accessible_page.patch
powerpc-mm-add-pud_pfn-stub.patch
powerpc-mm-implement-_user_accessible_page-for-ptes.patch
powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch
powerpc-mm-support-page-table-check.patch


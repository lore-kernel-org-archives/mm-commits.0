Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991B52F5A2D
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 00:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768523145; cv=none; b=UUJ5Uys3npVRU5iRjSWbM/Zo7rr6XmdXZZ/Szwvw7mUpQULVFvrjDG/FneyI/AkhdZPyiGvSuwtaIwtUcRwEZS2AjVcB2pxe1auuWDNs9+yA0uUHV9hlmb6xCQSEt8I306SKdE9Qbt15tfn7UziU16XGCJe3oj3sS0vuTN7XANA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768523145; c=relaxed/simple;
	bh=EirXMh0Dn/kcARLP0UPtqiRZ2HLr9vuUlWUpRvh5huo=;
	h=Date:To:From:Subject:Message-Id; b=SnY38n0JkLAMPskwMtRKya3/l1XC+x1xUoN45JL+M0IwsiYc0aSWBFFkBKezI1i7pCU8HmQcTvunbycDl8HinUC4myKrlMhx5MX1XSBeyYl89ad3foD8PcDyXPpblYUaXOuSaxRVabw8gzhR61ymtYYEKT2HvGex0f16cH5i5Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gqifZg45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gqifZg45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE40C116D0;
	Fri, 16 Jan 2026 00:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768523145;
	bh=EirXMh0Dn/kcARLP0UPtqiRZ2HLr9vuUlWUpRvh5huo=;
	h=Date:To:From:Subject:From;
	b=gqifZg45WD7kkQeyQnPWiQ9qilqKMa2N+GIi+x2BzWc5Ogza9xpd4PrUqBQP+8hNQ
	 Zqw7e9gnCi1O/QhLo92qFufQuUYMCkd1RU37nVGNHUzO3WeISk9YkijvKDZBY7UQ/f
	 WoZFYEUu7lxQdw3xaRajXUgBnkHOnA5H1vrg9ZQk=
Date: Thu, 15 Jan 2026 16:25:44 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,ajd@linux.ibm.com,agordeev@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch added to mm-new branch
Message-Id: <20260116002545.1CE40C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: use set_pte_at_unchecked() for internal usages
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

The mm-new branch of mm.git is not included in linux-next

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
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: powerpc/mm: use set_pte_at_unchecked() for internal usages
Date: Fri, 19 Dec 2025 04:09:43 +1100

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
Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-11-755bc151a50b@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h       |    2 ++
 arch/powerpc/mm/book3s64/pgtable.c       |    6 +++---
 arch/powerpc/mm/book3s64/radix_pgtable.c |    6 +++---
 arch/powerpc/mm/pgtable.c                |    8 ++++++++
 4 files changed, 16 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-use-set_pte_at_unchecked-for-internal-usages
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -34,6 +34,8 @@ struct mm_struct;
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
@@ -550,7 +550,7 @@ void ptep_modify_prot_commit(struct vm_a
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
powerpc-mm-implement-_user_accessible_page-for-ptes.patch
powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch
powerpc-mm-support-page-table-check.patch


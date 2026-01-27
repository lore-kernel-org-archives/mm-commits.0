Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262701E5702
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486751; cv=none; b=Ii/vPAPhi3EV9uwSlyReEoaVWCWTpQlIscyCWo+YOHK2koSinrg7fCam0FZsnQ4aEOjqQZG4BWhE9gj7i2+f8XBO5nk8EwfF3TPy4qETIqV6YMTSNc5gSLDm7p0g4yauB64lPXcfNvsVztZvtCz+4Rf3J1jPVfscACFlOHZWT3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486751; c=relaxed/simple;
	bh=uOhdBI9Mleui8SqgUCnBvzmSUJNpsPoSfGXUReRyXVE=;
	h=Date:To:From:Subject:Message-Id; b=ei0yk0gB5lVie5Q4eYmD9sae1gSI9yO7CyVmcwDYQR4wEKxI+07vCbdsaRly8npYrLYyHfb7XU1L9znbffcSqlLm4l4/CVI4WohXlEec/Q+31/F5GY0/tQY3cRAV1wjsB6Jky5GQjJJHOnISYPiQBkvZapfU3dnGRUp/NXSc0Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sWtrIV2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sWtrIV2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA975C116C6;
	Tue, 27 Jan 2026 04:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486751;
	bh=uOhdBI9Mleui8SqgUCnBvzmSUJNpsPoSfGXUReRyXVE=;
	h=Date:To:From:Subject:From;
	b=sWtrIV2fhvFoDTtX8ULZRyBkQtCQsY1B+gp4HdY9RzVgm9iOMVy1bE/x2RGpuogv3
	 AwfwepYD8esiPVRccGMSNNUSl3jRC8C3XocZ+054/lqNZyo2ep+80utpp1plPzTthL
	 hMbG4A3vYisyaj6lBZSN/oABRr0k7NhzSUBljITs=
Date: Mon, 26 Jan 2026 20:05:50 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,ajd@linux.ibm.com,agordeev@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch removed from -mm tree
Message-Id: <20260127040550.EA975C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: use set_pte_at_unchecked() for internal usages
has been removed from the -mm tree.  Its filename was
     powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



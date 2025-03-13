Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97F81F8AE2
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741906106; cv=none; b=qs9Lg8UzUIpQ+KBTd0qezw/VY8ZfTxf1gRMdI+dlMFjncoTd7o6TPPnp9/jT+g7v6URdZWoehLkdh8ngkTHkfkFrJatnFdBoSNFoELefKGnwmt/boFzvKHhKuK9zJuPpyeoeBcunicIiIIX4kbJnTPeV4x7KWTsBrj1U88YuTrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741906106; c=relaxed/simple;
	bh=VZ/yFuoLR3Pp00TPYNxsnh8T/u/5cyIkGeOsnkcNphU=;
	h=Date:To:From:Subject:Message-Id; b=GQ2HRuvnsZipxxMh20N+e3Kp6EC08epYiMBu7+Bsb+y/xtm5wMJXU+tUZTZTM+AuCpqX1ty34dNZN3jW0DLVp7QwRzu4o1U16A/po3ySiWDcQzMmBSfDFLyFq7lAvDwsiSfEOeMWIuIEjSI7aCHAVvUmWgHHa1q+CALnCNBSr1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BiaJVqA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BiaJVqA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10869C4CEDD;
	Thu, 13 Mar 2025 22:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741906106;
	bh=VZ/yFuoLR3Pp00TPYNxsnh8T/u/5cyIkGeOsnkcNphU=;
	h=Date:To:From:Subject:From;
	b=BiaJVqA5KmPvd9UaCD9D0QgBBFGqONWImmrAI0pJOignlUSjkeElioVa150wL8daD
	 7QzeLMuhL8GTO3N0vcSn7HuaJRVmgv2W+Yo6cQbWTcrxGsthjTvEhebaPt5YAz8G7v
	 OF9PF0cJmguqEiGsPRRCJ9iJ/4HaZFHO7OumYpos=
Date: Thu, 13 Mar 2025 15:48:25 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,christophe.leroy@csgroup.eu,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch added to mm-unstable branch
Message-Id: <20250313224826.10869C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pte_clear()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch

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
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pte_clear()
Date: Wed, 12 Feb 2025 03:13:59 +1100

This reverts commit aa232204c468 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pte_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the page
in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase and fix additional occurrence]
Link: https://lkml.kernel.org/r/20250211161404.850215-7-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    4 ++--
 include/linux/page_table_check.h |   11 +++++++----
 include/linux/pgtable.h          |    4 ++--
 mm/page_table_check.c            |    7 ++++---
 6 files changed, 17 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1281,7 +1281,7 @@ static inline pte_t __ptep_get_and_clear
 {
 	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
 
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 
 	return pte;
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/arch/riscv/include/asm/pgtable.h
@@ -593,7 +593,7 @@ static inline pte_t ptep_get_and_clear(s
 {
 	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
 
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 
 	return pte;
 }
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1318,7 +1318,7 @@ static inline pte_t ptep_get_and_clear(s
 				       pte_t *ptep)
 {
 	pte_t pte = native_ptep_get_and_clear(ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 	return pte;
 }
 
@@ -1334,7 +1334,7 @@ static inline pte_t ptep_get_and_clear_f
 		 * care about updates and native needs no locking
 		 */
 		pte = native_local_ptep_get_and_clear(ptep);
-		page_table_check_pte_clear(mm, pte);
+		page_table_check_pte_clear(mm, addr, pte);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
--- a/include/linux/page_table_check.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/include/linux/page_table_check.h
@@ -14,7 +14,8 @@ extern struct static_key_true page_table
 extern struct page_ext_operations page_table_check_ops;
 
 void __page_table_check_zero(struct page *page, unsigned int order);
-void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
@@ -45,12 +46,13 @@ static inline void page_table_check_free
 	__page_table_check_zero(page, order);
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pte_clear(mm, pte);
+	__page_table_check_pte_clear(mm, addr, pte);
 }
 
 static inline void page_table_check_pmd_clear(struct mm_struct *mm,
@@ -121,7 +123,8 @@ static inline void page_table_check_free
 {
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/include/linux/pgtable.h
@@ -483,7 +483,7 @@ static inline pte_t ptep_get_and_clear(s
 {
 	pte_t pte = ptep_get(ptep);
 	pte_clear(mm, address, ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 	return pte;
 }
 #endif
@@ -542,7 +542,7 @@ static inline void ptep_clear(struct mm_
 	 * No need for ptep_get_and_clear(): page table check doesn't care about
 	 * any bits that could have been set by HW concurrently.
 	 */
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 }
 
 #ifdef CONFIG_GUP_GET_PXX_LOW_HIGH
--- a/mm/page_table_check.c~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/mm/page_table_check.c
@@ -145,7 +145,8 @@ void __page_table_check_zero(struct page
 	rcu_read_unlock();
 }
 
-void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte)
 {
 	if (&init_mm == mm)
 		return;
@@ -206,7 +207,7 @@ void __page_table_check_ptes_set(struct
 	page_table_check_pte_flags(pte);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
+		__page_table_check_pte_clear(mm, addr, ptep_get(ptep + i));
 	if (pte_user_accessible_page(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
@@ -264,7 +265,7 @@ void __page_table_check_pte_clear_range(
 		if (WARN_ON(!ptep))
 			return;
 		for (i = 0; i < PTRS_PER_PTE; i++) {
-			__page_table_check_pte_clear(mm, ptep_get(ptep));
+			__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
 			addr += PAGE_SIZE;
 			ptep++;
 		}
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are

mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch
mm-provide-address-parameter-to-ptemdud_user_accessible_page.patch
powerpc-mm-add-pud_pfn-stub.patch
powerpc-mm-implement-_user_accessible_page-for-ptes.patch
powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch
powerpc-mm-support-page-table-check.patch


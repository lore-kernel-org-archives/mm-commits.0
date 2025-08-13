Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C46E30149A
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 23:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755126371; cv=none; b=ANj8zEcLr3UksoY4Ar8ldXIM86JkwBXOWQeglnt8x/7EIFl5NXDxNr4PA29Ya4m6lG/cSzXs8lJbVrCjnG8LN2X5fwHdLe5uGHl/W/EDs6fwr9I5RXvmuPpSa4PiEMiIV4exhrAiiG0xUVwoyVBDHfp87YTxEciUur+3TT7JMBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755126371; c=relaxed/simple;
	bh=vAOn8dicHhGlQrIcf/aLfmsAdTPB5oeJi7xy9c3PkdM=;
	h=Date:To:From:Subject:Message-Id; b=OlKIGLQ5bgeWOxzfYpY7RCqef86EWYGYxVcue6keYZNK+S4LCYwBX03OgrfQcnTRjxPNqDNUFI1+pRAkRa4Meg8GO1Y7rVcZq8GJkD16ATPcBXZhN9Q67fLtb3Vq2FW/JMOL0t9nw4j6jOXBX+xnbhN7zsX9sa9BlRFdQu3OCe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AtzTdp09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AtzTdp09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D2FC4CEEB;
	Wed, 13 Aug 2025 23:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755126370;
	bh=vAOn8dicHhGlQrIcf/aLfmsAdTPB5oeJi7xy9c3PkdM=;
	h=Date:To:From:Subject:From;
	b=AtzTdp09tZj1Z0P0hvWvMRmzwKJgQECUTBrtC1Nqd98M6JjqAEyty6iFWGiWIVlWX
	 hEbCrfjM2JHB6ausmzpd7w2z88Ob3NXwoGjFcQWaTPOb+cfMrGe+EE5zC4IvXi4UTd
	 O7Dht6nW3jOI7L/tUBMZYbdFJIxW2V22l3FY4sug=
Date: Wed, 13 Aug 2025 16:06:10 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,nicholas@linux.ibm.com,mingo@kernel.org,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch added to mm-new branch
Message-Id: <20250813230610.A8D2FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd_clear()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch

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
Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd_clear()
Date: Wed, 13 Aug 2025 16:26:08 +1000

This reverts commit 1831414cd729 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pmd_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the page
in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase on arm64 changes]
Link: https://lkml.kernel.org/r/20250813062614.51759-8-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>	[x86]
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   11 +++++++----
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    5 +++--
 6 files changed, 14 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1370,7 +1370,7 @@ static inline pte_t __ptep_get_and_clear
 		page_table_check_pte_clear(mm, pte);
 		break;
 	case PMD_SIZE:
-		page_table_check_pmd_clear(mm, pte_pmd(pte));
+		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/arch/riscv/include/asm/pgtable.h
@@ -860,7 +860,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 {
 	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1318,7 +1318,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 {
 	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, addr, pmd);
 
 	return pmd;
 }
--- a/include/linux/page_table_check.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/include/linux/page_table_check.h
@@ -15,7 +15,8 @@ extern struct page_ext_operations page_t
 
 void __page_table_check_zero(struct page *page, unsigned int order);
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
-void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
+void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
+				  pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 				  pud_t pud);
 void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
@@ -52,12 +53,13 @@ static inline void page_table_check_pte_
 	__page_table_check_pte_clear(mm, pte);
 }
 
-static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+static inline void page_table_check_pmd_clear(struct mm_struct *mm,
+					      unsigned long addr, pmd_t pmd)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pmd_clear(mm, pmd);
+	__page_table_check_pmd_clear(mm, addr, pmd);
 }
 
 static inline void page_table_check_pud_clear(struct mm_struct *mm,
@@ -121,7 +123,8 @@ static inline void page_table_check_pte_
 {
 }
 
-static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+static inline void page_table_check_pmd_clear(struct mm_struct *mm,
+					      unsigned long addr, pmd_t pmd)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/include/linux/pgtable.h
@@ -648,7 +648,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 	pmd_t pmd = *pmdp;
 
 	pmd_clear(pmdp);
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
--- a/mm/page_table_check.c~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/mm/page_table_check.c
@@ -156,7 +156,8 @@ void __page_table_check_pte_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
 
-void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
+				  pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
@@ -231,7 +232,7 @@ void __page_table_check_pmds_set(struct
 	page_table_check_pmd_flags(pmd);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pmd_clear(mm, *(pmdp + i));
+		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
 	if (pmd_user_accessible_page(pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
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


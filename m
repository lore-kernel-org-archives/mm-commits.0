Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC7E1B4247
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741906097; cv=none; b=WQcnLgB4StbUx5ao5Nb4khcbs4rwM/5CNHQa/uA6oQFNYuHjUVmohxw2yEE20pWwFGPck8aYbR7sQyrj14rhFYKeoRG5ZMzwWjc5EqHleP999f/ovGfj8r5OPK7dMhH4m8rqqKJGa4dieYVu7FusBFJSSTB20IIzbMwIKM14AUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741906097; c=relaxed/simple;
	bh=CUDgSxxJibABfGatPQjBUd4WvgfLKP2YpwJUU43CVVM=;
	h=Date:To:From:Subject:Message-Id; b=fEeIC1dLXKOjCB4vZ38EEmILyCNdjarMeKHVj4qJdfmUXlJAaqeryFNP6JQZrfh39wjo5niFsw6j0RPrqIM6CY4Zli1Mq9WIz7TYkkN7dLemWPY++nRFRtNW42bCz+h4eYVTj2MJj7kAl20qt2ZEscFBqd8WIE+KyC6mUXQLkZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R+ekimSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R+ekimSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D2CC4CEDD;
	Thu, 13 Mar 2025 22:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741906097;
	bh=CUDgSxxJibABfGatPQjBUd4WvgfLKP2YpwJUU43CVVM=;
	h=Date:To:From:Subject:From;
	b=R+ekimSFo6u84zmQVHv5ca/N/Vgr3sQnF3AIrnLoHVmr5Hs/t8WlusOLeQQQdnNuW
	 LfTQF6bXAzSEX9iF1hAD2R5QfL6NeSKo4ac+BU0h7M9TsaBx9z85i8MPda1AQfgp06
	 0xkk+Lb2jePiKfSy7ud53EJ/hOw76/bDd9T7OcXs=
Date: Thu, 13 Mar 2025 15:48:16 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,christophe.leroy@csgroup.eu,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch added to mm-unstable branch
Message-Id: <20250313224816.F1D2CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pud_set()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch

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
Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pud_set()
Date: Wed, 12 Feb 2025 03:13:54 +1100

Patch series "Support page table check on PowerPC", v13.

Support page table check on all PowerPC platforms.  This works by
serialising assignments, reassignments and clears of page table entries at
each level in order to ensure that anonymous mappings have at most one
writable consumer, and likewise that file-backed mappings are not
simultaneously also anonymous mappings.

In order to support this infrastructure, a number of stubs must be defined
for all powerpc platforms.  Additionally, seperate set_pte_at() and
set_pte_at_unchecked(), to allow for internal, uninstrumented mappings.

(This series was written by Rohan McLure, who has left IBM and is no
longer working on powerpc - I've taken far too long to pick this up and
finally send it.)


This patch (of 11):

This reverts commit 6d144436d954 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pud_set").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the page
in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase on riscv changes, remove riscv commit message comment]
Link: https://lkml.kernel.org/r/20250211161404.850215-1-ajd@linux.ibm.com
Link: https://lkml.kernel.org/r/20250211161404.850215-2-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   11 +++++++----
 mm/page_table_check.c            |    3 ++-
 5 files changed, 12 insertions(+), 8 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -661,7 +661,7 @@ static inline void set_pmd_at(struct mm_
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, pudp, pud);
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	return __set_pte_at(mm, addr, (pte_t *)pudp, pud_pte(pud),
 						PUD_SIZE >> PAGE_SHIFT);
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -778,7 +778,7 @@ static inline void set_pmd_at(struct mm_
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, pudp, pud);
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	return __set_pte_at(mm, (pte_t *)pudp, pud_pte(pud));
 }
 
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/arch/x86/include/asm/pgtable.h
@@ -1287,7 +1287,7 @@ static inline void set_pmd_at(struct mm_
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, pudp, pud);
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	native_set_pud(pudp, pud);
 }
 
--- a/include/linux/page_table_check.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/include/linux/page_table_check.h
@@ -20,7 +20,8 @@ void __page_table_check_pud_clear(struct
 void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
 		unsigned int nr);
 void __page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd);
-void __page_table_check_pud_set(struct mm_struct *mm, pud_t *pudp, pud_t pud);
+void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
+				pud_t *pudp, pud_t pud);
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
 					unsigned long addr,
 					pmd_t pmd);
@@ -83,13 +84,14 @@ static inline void page_table_check_pmd_
 	__page_table_check_pmd_set(mm, pmdp, pmd);
 }
 
-static inline void page_table_check_pud_set(struct mm_struct *mm, pud_t *pudp,
+static inline void page_table_check_pud_set(struct mm_struct *mm,
+					    unsigned long addr, pud_t *pudp,
 					    pud_t pud)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pud_set(mm, pudp, pud);
+	__page_table_check_pud_set(mm, addr, pudp, pud);
 }
 
 static inline void page_table_check_pte_clear_range(struct mm_struct *mm,
@@ -134,7 +136,8 @@ static inline void page_table_check_pmd_
 {
 }
 
-static inline void page_table_check_pud_set(struct mm_struct *mm, pud_t *pudp,
+static inline void page_table_check_pud_set(struct mm_struct *mm,
+					    unsigned long addr, pud_t *pudp,
 					    pud_t pud)
 {
 }
--- a/mm/page_table_check.c~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/mm/page_table_check.c
@@ -233,7 +233,8 @@ void __page_table_check_pmd_set(struct m
 }
 EXPORT_SYMBOL(__page_table_check_pmd_set);
 
-void __page_table_check_pud_set(struct mm_struct *mm, pud_t *pudp, pud_t pud)
+void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
+				pud_t *pudp, pud_t pud)
 {
 	if (&init_mm == mm)
 		return;
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


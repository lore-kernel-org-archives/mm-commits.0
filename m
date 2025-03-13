Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F291B4247
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741906101; cv=none; b=RCzxyRf83z5QRwufHZlZbL7f+PZ3Bih0Q+wxb4YRacggI+DNWttxBPis13KswkichuTouNuW1z/UuZ7RYuJkKf4iMl55iqE2p3OTcGncKdz4tTAWAbW8JDP6O+29e3TpLfoGeh1jK722RqhSwstNG6vEA4PAI+d39Kk3TIHGUdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741906101; c=relaxed/simple;
	bh=tzOV7uFoyMmvsGUCDhLorZIoKRwmXpsTFZjG2v2uMTw=;
	h=Date:To:From:Subject:Message-Id; b=D406HzdahFiMpVqKZbgvpsPMmgUHFayzmrruwiNry9qqThhRgeNa889K5zKeV+5c6KHvH2+LdBYpdJssN2pQ9B3FETa8MXbNWB9yc/m64jDHSyIvUEktC6nZ37hZamNDGqk96QzcGeBGVFCUqBpPGKkq56pPF0qXNSet9brJTi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UGz1Odf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UGz1Odf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C26C4CEDD;
	Thu, 13 Mar 2025 22:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741906100;
	bh=tzOV7uFoyMmvsGUCDhLorZIoKRwmXpsTFZjG2v2uMTw=;
	h=Date:To:From:Subject:From;
	b=UGz1Odf4QAQiVy8hL+XOgh+HnC5d8AwhPYmD2VPlkn39pwykKmVZXcq6z/eXUc0Wy
	 CgEx0FnhfiuKfUcNVdOWPUT+mF7R1tHZTrWFuPFETuZZrRR+Jj+zVa4fL5VCugL/96
	 Xu/iy/9bIvjR3WWTM9xnNhRK4XvnxuA/JiYi/mng=
Date: Thu, 13 Mar 2025 15:48:20 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,christophe.leroy@csgroup.eu,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set.patch added to mm-unstable branch
Message-Id: <20250313224820.B7C26C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: provide addr parameter to page_table_check_pte_set()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set.patch

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
Subject: mm/page_table_check: provide addr parameter to page_table_check_pte_set()
Date: Wed, 12 Feb 2025 03:13:56 +1100

To provide support for powerpc platforms, provide an addr parameter to the
page_table_check_pte_set() routine.  This parameter is needed on some
powerpc platforms which do not encode whether a mapping is for user or
kernel in the pte.  On such platforms, this can be inferred form the addr
parameter.

[ajd@linux.ibm.com: rebase]
Link: https://lkml.kernel.org/r/20250211161404.850215-4-ajd@linux.ibm.com
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
 include/linux/page_table_check.h |   12 +++++++-----
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    4 ++--
 5 files changed, 12 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -424,7 +424,7 @@ static inline void __set_ptes(struct mm_
 			      unsigned long __always_unused addr,
 			      pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, ptep, pte, nr);
+	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 	__sync_cache_and_tags(pte, nr);
 
 	for (;;) {
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -562,7 +562,7 @@ static inline void __set_pte_at(struct m
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pteval, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, ptep, pteval, nr);
+	page_table_check_ptes_set(mm, addr, ptep, pteval, nr);
 
 	for (;;) {
 		__set_pte_at(mm, ptep, pteval);
--- a/include/linux/page_table_check.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set
+++ a/include/linux/page_table_check.h
@@ -17,8 +17,8 @@ void __page_table_check_zero(struct page
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
-void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
-		unsigned int nr);
+void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
+				 pte_t *ptep, pte_t pte, unsigned int nr);
 void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd);
 void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
@@ -68,12 +68,13 @@ static inline void page_table_check_pud_
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
-		pte_t *ptep, pte_t pte, unsigned int nr)
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_ptes_set(mm, ptep, pte, nr);
+	__page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 }
 
 static inline void page_table_check_pmd_set(struct mm_struct *mm,
@@ -129,7 +130,8 @@ static inline void page_table_check_pud_
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
-		pte_t *ptep, pte_t pte, unsigned int nr)
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, unsigned int nr)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set
+++ a/include/linux/pgtable.h
@@ -289,7 +289,7 @@ static inline pte_t pte_advance_pfn(pte_
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, ptep, pte, nr);
+	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 
 	for (;;) {
 		set_pte(ptep, pte);
--- a/mm/page_table_check.c~mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set
+++ a/mm/page_table_check.c
@@ -193,8 +193,8 @@ static inline void page_table_check_pte_
 		WARN_ON_ONCE(swap_cached_writable(pte_to_swp_entry(pte)));
 }
 
-void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
-		unsigned int nr)
+void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
+				 pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	unsigned int i;
 
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


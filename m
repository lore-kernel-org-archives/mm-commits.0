Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD521F8BAF
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741906111; cv=none; b=N+l3YKy1RMK866zFX61t+CnLk871wd72pFsD8IBRyftNoy/jBo2zBlg+yRXEu+vx+nYkhnXG6+nc+nYf2cfdX+Nxh1rO4UE+N39TwbQVvzGAz+FoR7DdDNgnmFOhgzC7gwSAMRdvVoh1PdL7eurHpyzFTiFteGTTkUeLJzOJXzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741906111; c=relaxed/simple;
	bh=piZFcHGYntW08iySUQq2ALaqZ2PI13xVzZOr9OeRccQ=;
	h=Date:To:From:Subject:Message-Id; b=GU0y8famoK5IvGpK3bR9cJth2tVa0UPblkp8sCJiHuJ9Up93XdtX1IGZp9WYC7XRBXvvcia5M6RZIkdeyMaygbn9HIyPDNVLBitftdEkiCV509cdaWcAmzvC3SGtKq6DqfovHh4hJ29Xk9X7zF/ZXBGMrT0XScJTesTG0rAtfy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hNSv1U6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hNSv1U6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1FEC4CEDD;
	Thu, 13 Mar 2025 22:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741906110;
	bh=piZFcHGYntW08iySUQq2ALaqZ2PI13xVzZOr9OeRccQ=;
	h=Date:To:From:Subject:From;
	b=hNSv1U6QC2KRlXumAnmQjGnPjgCsOxn4LkDHawcQXboub+9pJfASRajpfkXQWzs3G
	 sbXmuO8jNbBmRy5vaBa8dHB6Pt1I9gxmsUuAZM59vAm9NvWdt4kldjBnSPeOGogMfJ
	 9j+J3nrqye4VkdzJ1lXAuOYRy7IMfhEya0xg/YjQ=
Date: Thu, 13 Mar 2025 15:48:30 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,christophe.leroy@csgroup.eu,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-implement-_user_accessible_page-for-ptes.patch added to mm-unstable branch
Message-Id: <20250313224830.BE1FEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: mm: implement *_user_accessible_page() for ptes
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-implement-_user_accessible_page-for-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-implement-_user_accessible_page-for-ptes.patch

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
Subject: powerpc: mm: implement *_user_accessible_page() for ptes
Date: Wed, 12 Feb 2025 03:14:02 +1100

Page table checking depends on architectures providing an implementation
of p{te,md,ud}_user_accessible_page.  With refactorisations made on
powerpc/mm, the pte_access_permitted() and similar methods verify whether
a userland page is accessible with the required permissions.

Since page table checking is the only user of
p{te,md,ud}_user_accessible_page(), implement these for all platforms,
using some of the same preliminary checks taken by pte_access_permitted()
on that platform.

Since commit 8e9bd41e4ce1 ("powerpc/nohash: Replace pte_user() by
pte_read()") pte_user() is no longer required to be present on all
platforms as it may be equivalent to or implied by pte_read().  Hence
implementations of pte_user_accessible_page() are specialised.

[ajd@linux.ibm.com: rebase and fix commit message]
Link: https://lkml.kernel.org/r/20250211161404.850215-10-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/32/pgtable.h |    5 +++++
 arch/powerpc/include/asm/book3s/64/pgtable.h |   17 +++++++++++++++++
 arch/powerpc/include/asm/nohash/pgtable.h    |    5 +++++
 arch/powerpc/include/asm/pgtable.h           |    8 ++++++++
 4 files changed, 35 insertions(+)

--- a/arch/powerpc/include/asm/book3s/32/pgtable.h~powerpc-mm-implement-_user_accessible_page-for-ptes
+++ a/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -437,6 +437,11 @@ static inline bool pte_access_permitted(
 	return true;
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && !is_kernel_addr(addr);
+}
+
 /* Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  *
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-implement-_user_accessible_page-for-ptes
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -540,6 +540,11 @@ static inline bool pte_access_permitted(
 	return arch_pte_access_permitted(pte_val(pte), write, 0);
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && pte_user(pte);
+}
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
@@ -1431,5 +1436,17 @@ static inline bool is_pte_rw_upgrade(uns
 	return false;
 }
 
+#define pmd_user_accessible_page pmd_user_accessible_page
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
+{
+	return pmd_leaf(pmd) && pte_user_accessible_page(pmd_pte(pmd), addr);
+}
+
+#define pud_user_accessible_page pud_user_accessible_page
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
+{
+	return pud_leaf(pud) && pte_user_accessible_page(pud_pte(pud), addr);
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_BOOK3S_64_PGTABLE_H_ */
--- a/arch/powerpc/include/asm/nohash/pgtable.h~powerpc-mm-implement-_user_accessible_page-for-ptes
+++ a/arch/powerpc/include/asm/nohash/pgtable.h
@@ -243,6 +243,11 @@ static inline bool pte_access_permitted(
 	return true;
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && !is_kernel_addr(addr);
+}
+
 /* Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  *
--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-implement-_user_accessible_page-for-ptes
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -224,6 +224,14 @@ static inline int pud_pfn(pud_t pud)
 }
 #endif
 
+#ifndef pmd_user_accessible_page
+#define pmd_user_accessible_page(pmd, addr)	false
+#endif
+
+#ifndef pud_user_accessible_page
+#define pud_user_accessible_page(pud, addr)	false
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D101364D4
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 23:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710890753; cv=none; b=i5yd92n6yGCibOu/AYLbB8s1ukZEpzay983sFHm7xMa16uIrMwtvW6HhqPzW0+B903GxjHlJ96OrDTeel3li5rRHkCaSpl4S923P/bnB+cPdGi3R8n8ihzuygMuFP1bmg6YD+JELGl7TgbLhAYWNDblzRCqowOuP01auXWRTzrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710890753; c=relaxed/simple;
	bh=l+nIygyfgT722Q8EUocFWEsqvM3yqIeFpNJiAc7wZYw=;
	h=Date:To:From:Subject:Message-Id; b=qyFdeUTgzHkzs+eD4TytXCdLVcWIR0qtbbzB2DBmaBuRXiPUQITklJn0F0m/Lum7Z05V2GC0hrhOOcYaNxLuuZemGB+tSwRe0JbmGvN1sQ32l1Viqwjkz5JvbZlgNw1/1pe7MXf3HPL3SPR4KUPTfWYA7zdhs+ETVnfDs8sT31o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x0ujRCwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x0ujRCwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CF3C433F1;
	Tue, 19 Mar 2024 23:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710890752;
	bh=l+nIygyfgT722Q8EUocFWEsqvM3yqIeFpNJiAc7wZYw=;
	h=Date:To:From:Subject:From;
	b=x0ujRCwvSh3+grz0QsTnSTuwQiuFZuQRGr6e90WrjgQXogr1uNIJYzGFa93aV4JOQ
	 bY9NDwO7JpAj6lePibYnk0iifXmjPrRskPvlkBB6Gt+TdwG/YyJUEjYVD3jO6D8Oj8
	 rud59NuayU1++NXQQjO8/rpJ93r5JjMheHZ33yCA=
Date: Tue, 19 Mar 2024 16:25:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arm-remove-pmd_thp_or_huge.patch added to mm-unstable branch
Message-Id: <20240319232552.99CF3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/arm: remove pmd_thp_or_huge()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arm-remove-pmd_thp_or_huge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arm-remove-pmd_thp_or_huge.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/arm: remove pmd_thp_or_huge()
Date: Mon, 18 Mar 2024 16:04:03 -0400

ARM/ARM64 used to define pmd_thp_or_huge().  Now this macro is completely
redundant.  Remove it and use pmd_leaf().

Link: https://lkml.kernel.org/r/20240318200404.448346-14-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-2level.h |    1 -
 arch/arm/include/asm/pgtable-3level.h |    1 -
 arch/arm/lib/uaccess_with_memcpy.c    |    4 ++--
 arch/arm64/include/asm/pgtable.h      |    2 --
 4 files changed, 2 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-arm-remove-pmd_thp_or_huge
+++ a/arch/arm64/include/asm/pgtable.h
@@ -517,8 +517,6 @@ static inline pmd_t pmd_mkinvalid(pmd_t
 	return pmd;
 }
 
-#define pmd_thp_or_huge(pmd)	(pmd_leaf(pmd) || pmd_trans_huge(pmd))
-
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
 #define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
--- a/arch/arm/include/asm/pgtable-2level.h~mm-arm-remove-pmd_thp_or_huge
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -241,7 +241,6 @@ static inline pmd_t *pmd_offset(pud_t *p
  * define empty stubs for use by pin_page_for_write.
  */
 #define pmd_hugewillfault(pmd)	(0)
-#define pmd_thp_or_huge(pmd)	(0)
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/arm/include/asm/pgtable-3level.h~mm-arm-remove-pmd_thp_or_huge
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -190,7 +190,6 @@ static inline pte_t pte_mkspecial(pte_t
 #define pmd_dirty(pmd)		(pmd_isset((pmd), L_PMD_SECT_DIRTY))
 
 #define pmd_hugewillfault(pmd)	(!pmd_young(pmd) || !pmd_write(pmd))
-#define pmd_thp_or_huge(pmd)	(pmd_leaf(pmd) || pmd_trans_huge(pmd))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) && !pmd_table(pmd))
--- a/arch/arm/lib/uaccess_with_memcpy.c~mm-arm-remove-pmd_thp_or_huge
+++ a/arch/arm/lib/uaccess_with_memcpy.c
@@ -56,10 +56,10 @@ pin_page_for_write(const void __user *_a
 	 * to see that it's still huge and whether or not we will
 	 * need to fault on write.
 	 */
-	if (unlikely(pmd_thp_or_huge(*pmd))) {
+	if (unlikely(pmd_leaf(*pmd))) {
 		ptl = &current->mm->page_table_lock;
 		spin_lock(ptl);
-		if (unlikely(!pmd_thp_or_huge(*pmd)
+		if (unlikely(!pmd_leaf(*pmd)
 			|| pmd_hugewillfault(*pmd))) {
 			spin_unlock(ptl);
 			return 0;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch
mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch


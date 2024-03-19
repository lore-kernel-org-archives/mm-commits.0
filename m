Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B913BBD7
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710882981; cv=none; b=mYvTMWTKpazvaxcTcT8cFiJuZ39ufINtYaYEAqiV/8rjSZb3JwT7zyagfLoMq8KxH9EwvacecJhJCccXhFqAC9oMIawuoxEGYAccvc2JMdNgenAJin1P6lfcXCbBS4QMopiL/xDftIANQru1WT8eR69LGsTXGMm/0wW0OGXPghw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710882981; c=relaxed/simple;
	bh=2y8bdqZdGfdm7Yr0P5Jmlsl8/aChYtywcHGkOgJ1Ad0=;
	h=Date:To:From:Subject:Message-Id; b=nA40XBxA+lnc+XPNWnnqzSh4TaIfaxOiD9Z/K0mZFmm2AXrvqAQ+3llarzY2whj2l8TtPBuRuOSXTbrojB4XQD4fo78gW6BprqswsGBbb/lZBBM7mx1rB7xbiDZipHs5j4U9/42p9I3sG3r6Mu5f8IjjGEmelsFVLO9RVejPjfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aoXhS4fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aoXhS4fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0130FC433F1;
	Tue, 19 Mar 2024 21:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710882981;
	bh=2y8bdqZdGfdm7Yr0P5Jmlsl8/aChYtywcHGkOgJ1Ad0=;
	h=Date:To:From:Subject:From;
	b=aoXhS4fd00EwB8nSkTnfPMyxHH0dcsLMqi4UmF0qpcBltc18+lsMcUzdJmZ/VT3uo
	 r7LT72SVhVS+RSf0BtbCqGWv13Rv6M12iml+G5LhHX30cztnJdGwPHy2oagPjhSC1s
	 onmjb3HUDKzvEsSUJUqwoyGg6xzgeqJt7mG2XaFA=
Date: Tue, 19 Mar 2024 14:16:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arm-use-macros-to-define-pmd-pud-helpers.patch added to mm-unstable branch
Message-Id: <20240319211621.0130FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/arm: use macros to define pmd/pud helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arm-use-macros-to-define-pmd-pud-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arm-use-macros-to-define-pmd-pud-helpers.patch

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
Subject: mm/arm: use macros to define pmd/pud helpers
Date: Mon, 18 Mar 2024 16:03:56 -0400

It's already confusing that ARM 2-level v.s.  3-level defines SECT bit
differently on pmd/puds.  Always use a macro which is much clearer.

Link: https://lkml.kernel.org/r/20240318200404.448346-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-2level.h       |    4 ++--
 arch/arm/include/asm/pgtable-3level-hwdef.h |    1 +
 arch/arm/include/asm/pgtable-3level.h       |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/arch/arm/include/asm/pgtable-2level.h~mm-arm-use-macros-to-define-pmd-pud-helpers
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -213,8 +213,8 @@ static inline pmd_t *pmd_offset(pud_t *p
 
 #define pmd_pfn(pmd)		(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
 
-#define pmd_leaf(pmd)		(pmd_val(pmd) & 2)
-#define pmd_bad(pmd)		(pmd_val(pmd) & 2)
+#define pmd_leaf(pmd)		(pmd_val(pmd) & PMD_TYPE_SECT)
+#define pmd_bad(pmd)		pmd_leaf(pmd)
 #define pmd_present(pmd)	(pmd_val(pmd))
 
 #define copy_pmd(pmdpd,pmdps)		\
--- a/arch/arm/include/asm/pgtable-3level.h~mm-arm-use-macros-to-define-pmd-pud-helpers
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -112,7 +112,7 @@
 #ifndef __ASSEMBLY__
 
 #define pud_none(pud)		(!pud_val(pud))
-#define pud_bad(pud)		(!(pud_val(pud) & 2))
+#define pud_bad(pud)		(!(pud_val(pud) & PUD_TABLE_BIT))
 #define pud_present(pud)	(pud_val(pud))
 #define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
 						 PMD_TYPE_TABLE)
@@ -137,7 +137,7 @@ static inline pmd_t *pud_pgtable(pud_t p
 	return __va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);
 }
 
-#define pmd_bad(pmd)		(!(pmd_val(pmd) & 2))
+#define pmd_bad(pmd)		(!(pmd_val(pmd) & PMD_TABLE_BIT))
 
 #define copy_pmd(pmdpd,pmdps)		\
 	do {				\
--- a/arch/arm/include/asm/pgtable-3level-hwdef.h~mm-arm-use-macros-to-define-pmd-pud-helpers
+++ a/arch/arm/include/asm/pgtable-3level-hwdef.h
@@ -14,6 +14,7 @@
  * + Level 1/2 descriptor
  *   - common
  */
+#define PUD_TABLE_BIT		(_AT(pmdval_t, 1) << 1)
 #define PMD_TYPE_MASK		(_AT(pmdval_t, 3) << 0)
 #define PMD_TYPE_FAULT		(_AT(pmdval_t, 0) << 0)
 #define PMD_TYPE_TABLE		(_AT(pmdval_t, 3) << 0)
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2D63BBD7
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710882987; cv=none; b=IH3I61GFJxwR4kZqnpEZqD+01mTIdx1QV4wrqvYUiYgH5/F4VjsFAPqtLDj28HPSci3ArCu4TxhFzG/eRXGQzik8fEhRJhxAdgMIKAak55/bVm1TTyLHUI7z2s2NERciUh9JPuGTkhABmFtVW2tLX+dThYUOhOGl68a15hdS11Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710882987; c=relaxed/simple;
	bh=vLwQ9fwf0rUAdDhe8iwBncoOdYicwBLzCPVpeV59KEo=;
	h=Date:To:From:Subject:Message-Id; b=Iew1cdrPOcPo6lHZSM0lG1WzyfD/m+7xXiP93Yvtd3zPdXGcn7PQYJGBznQgcFj7xAySfwWJ/4U/z4oEeIwFJDVaDzm2GNNHVPjv6VGzf0dzKADNvHFySqI+xokxXmiDME/hcSBgd/FcFrOvxaUmuyE9CgoxGefKKPUwyGoqUT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SlTn+gSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SlTn+gSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57E3C433C7;
	Tue, 19 Mar 2024 21:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710882986;
	bh=vLwQ9fwf0rUAdDhe8iwBncoOdYicwBLzCPVpeV59KEo=;
	h=Date:To:From:Subject:From;
	b=SlTn+gSoVDodB/cwIn0aABAAwI3vtbUBGZEi826XIT7CzAglvlVxDbHNF55UvV0Nj
	 MD0i6fO7qHPVhE4w9eWWSk81cWR4Rh2yfVJ6rINrrcoxDOAZowIWd4f8LMAYMBg7nX
	 PKVyXCNz+oEr7/Xd+i7A54m26dvEyhUzwrOaVWT8=
Date: Tue, 19 Mar 2024 14:16:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch added to mm-unstable branch
Message-Id: <20240319211625.E57E3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/arm64: merge pXd_huge() and pXd_leaf() definitions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch

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
Subject: mm/arm64: merge pXd_huge() and pXd_leaf() definitions
Date: Mon, 18 Mar 2024 16:03:58 -0400

Unlike most archs, aarch64 defines pXd_huge() and pXd_leaf() slightly
differently.  Redefine the pXd_huge() with pXd_leaf().

There used to be two traps for old aarch64 definitions over these APIs that
I found when reading the code around, they're:

 (1) 4797ec2dc83a ("arm64: fix pud_huge() for 2-level pagetables")
 (2) 23bc8f69f0ec ("arm64: mm: fix p?d_leaf()")

Define pXd_huge() with the current pXd_leaf() will make sure (2) isn't a
problem (on PROT_NONE checks).  To make sure it also works for (1), we
move over the __PAGETABLE_PMD_FOLDED check to pud_leaf(), allowing it to
constantly returning "false" for 2-level pgtables, which looks even safer
to cover both now.

Link: https://lkml.kernel.org/r/20240318200404.448346-9-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    4 ++++
 arch/arm64/mm/hugetlbpage.c      |    8 ++------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions
+++ a/arch/arm64/include/asm/pgtable.h
@@ -709,7 +709,11 @@ static inline unsigned long pmd_page_vad
 #define pud_none(pud)		(!pud_val(pud))
 #define pud_bad(pud)		(!pud_table(pud))
 #define pud_present(pud)	pte_present(pud_pte(pud))
+#ifndef __PAGETABLE_PMD_FOLDED
 #define pud_leaf(pud)		(pud_present(pud) && !pud_table(pud))
+#else
+#define pud_leaf(pud)		false
+#endif
 #define pud_valid(pud)		pte_valid(pud_pte(pud))
 #define pud_user(pud)		pte_user(pud_pte(pud))
 #define pud_user_exec(pud)	pte_user_exec(pud_pte(pud))
--- a/arch/arm64/mm/hugetlbpage.c~mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -81,16 +81,12 @@ bool arch_hugetlb_migration_supported(st
 
 int pmd_huge(pmd_t pmd)
 {
-	return pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
+	return pmd_leaf(pmd);
 }
 
 int pud_huge(pud_t pud)
 {
-#ifndef __PAGETABLE_PMD_FOLDED
-	return pud_val(pud) && !(pud_val(pud) & PUD_TABLE_BIT);
-#else
-	return 0;
-#endif
+	return pud_leaf(pud);
 }
 
 static int find_num_contig(struct mm_struct *mm, unsigned long addr,
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


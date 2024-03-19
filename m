Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1613BBD7
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710882985; cv=none; b=gYh/c5ZGWLAikEaX90ut7yL2uwNMV+A78kiP4fplOUJaasqkZ4A5dneWf/CjVx14Uf5U0lM1ODecYtvtgww7CH5H0grhDkQ2Papd9Efou2sIyCaaxC9NVoahhAlrYgt5SCeDmLP1D4cMwM5ChGbBYshbfr72y3gmotN0axhiorI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710882985; c=relaxed/simple;
	bh=7NW2mnbHytjy5qlPXYULEOPRFIo90PCAq3wV9pn3GYM=;
	h=Date:To:From:Subject:Message-Id; b=TDIxp+kDD5mbIiXm1fTXU4TeOEIsVM/HpAZdGtwBHtgartXsAkJ0yxNGna+m6tzOk/MsfPfS3h5zZilH48o/Yzi76OxY1Jam2jG5MSdYLFg45F5Y6o+rbI5sQVI8TinG+Bc/TSmgcF3ZkANhFLocx27+mMvH1c3FO8adgcyudgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZncO8eBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZncO8eBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFECC433C7;
	Tue, 19 Mar 2024 21:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710882983;
	bh=7NW2mnbHytjy5qlPXYULEOPRFIo90PCAq3wV9pn3GYM=;
	h=Date:To:From:Subject:From;
	b=ZncO8eBRRm0knA14pfydBkFyMrPGLaajEa9zjG9IPKPGJ3jbngmNcz+hfU1ADnE5G
	 issvmgPBCXcFB2J8bKHZDyIYq6uXkw6pug28zgxobsxIKtwLVcZ0Tq6vMLFudwrP1o
	 m/4DVBtfjPeuUWJQnIaq90o3dYfMJwwPplVQEI80=
Date: Tue, 19 Mar 2024 14:16:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arm-redefine-pmd_huge-with-pmd_leaf.patch added to mm-unstable branch
Message-Id: <20240319211623.CBFECC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/arm: redefine pmd_huge() with pmd_leaf()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arm-redefine-pmd_huge-with-pmd_leaf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arm-redefine-pmd_huge-with-pmd_leaf.patch

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
Subject: mm/arm: redefine pmd_huge() with pmd_leaf()
Date: Mon, 18 Mar 2024 16:03:57 -0400

Most of the archs already define these two APIs the same way.  ARM is more
complicated in two aspects:

  - For pXd_huge() it's always checking against !PXD_TABLE_BIT, while for
    pXd_leaf() it's always checking against PXD_TYPE_SECT.

  - SECT/TABLE bits are defined differently on 2-level v.s. 3-level ARM
    pgtables, which makes the whole thing even harder to follow.

Luckily, the second complexity should be hidden by the pmd_leaf()
implementation against 2-level v.s. 3-level headers.  Invoke pmd_leaf()
directly for pmd_huge(), to remove the first part of complexity.  This
prepares to drop pXd_huge() API globally.

When at it, drop the obsolete comments - it's outdated.

Link: https://lkml.kernel.org/r/20240318200404.448346-8-peterx@redhat.com
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

 arch/arm/mm/hugetlbpage.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/arch/arm/mm/hugetlbpage.c~mm-arm-redefine-pmd_huge-with-pmd_leaf
+++ a/arch/arm/mm/hugetlbpage.c
@@ -18,11 +18,6 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
-/*
- * On ARM, huge pages are backed by pmd's rather than pte's, so we do a lot
- * of type casting from pmd_t * to pte_t *.
- */
-
 int pud_huge(pud_t pud)
 {
 	return 0;
@@ -30,5 +25,5 @@ int pud_huge(pud_t pud)
 
 int pmd_huge(pmd_t pmd)
 {
-	return pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
+	return pmd_leaf(pmd);
 }
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


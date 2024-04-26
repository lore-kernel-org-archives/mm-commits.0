Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26F278C83
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103853; cv=none; b=j75FI6nj9ab5m5yF6fagPC0WvlEDXZqawj9U0NdyKlv/Hb7dmy4PSsv0hixJKlzYOlHwQ/dLGPGiYBSaeyCiuL/wpsd0egg0qPClX+iy8+FwF+Vw0DQfoKXVWa3R76Pg3/ks0szx5E/BHhlIGrD/qWesrtKJjKmjnM0rYv3ZB9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103853; c=relaxed/simple;
	bh=EM6rVU/Um3l4yhvkklv1fZ5pUROv2iIqXnJXS9dDmZM=;
	h=Date:To:From:Subject:Message-Id; b=XbYNhGpdijvI5iLOvKM+P3XEPQZECqYz5NJ08KhqJrEJoptkQiDMIkqtq+g3MJWR56AWmqCBrhwqwTsqTl+y1VAMS706ywwPZRKnhMSP5gznxGV4rV6jop3tzkNbqRQnY6NYZeqsDlVHFuh4a9cEI++9QgS42/u0ylGj+1WOncQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ORgy4O+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ORgy4O+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71640C113CD;
	Fri, 26 Apr 2024 03:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103852;
	bh=EM6rVU/Um3l4yhvkklv1fZ5pUROv2iIqXnJXS9dDmZM=;
	h=Date:To:From:Subject:From;
	b=ORgy4O+9smuVAkxK4OzmFDWAj6D8fdFiXEhHP+XdnuqY/ztX/Om3i2NOJDXWWZ5IM
	 mhmUPlzVQvd0+l2HyFyY1prObyWnLJildowWqr1KrkN/afXd21cgcLt2qrPGwarsFe
	 gpmMnN8bFW4eIPTQG9XKw8joCXbeZwK1lnw52lqs=
Date: Thu, 25 Apr 2024 20:57:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch removed from -mm tree
Message-Id: <20240426035732.71640C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparc: change pXd_huge() behavior to exclude swap entries
has been removed from the -mm tree.  Its filename was
     mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/sparc: change pXd_huge() behavior to exclude swap entries
Date: Mon, 18 Mar 2024 16:03:55 -0400

Please refer to the previous patch on the reasoning for x86.  Now sparc is
the only architecture that will allow swap entries to be reported as
pXd_huge().  After this patch, all architectures should forbid swap
entries in pXd_huge().

[akpm@linux-foundation.org: s/;;/;/, per Muchun]
Link: https://lkml.kernel.org/r/20240318200404.448346-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/hugetlbpage.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/sparc/mm/hugetlbpage.c~mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -409,14 +409,12 @@ pte_t huge_ptep_get_and_clear(struct mm_
 
 int pmd_huge(pmd_t pmd)
 {
-	return !pmd_none(pmd) &&
-		(pmd_val(pmd) & (_PAGE_VALID|_PAGE_PMD_HUGE)) != _PAGE_VALID;
+	return pmd_leaf(pmd);
 }
 
 int pud_huge(pud_t pud)
 {
-	return !pud_none(pud) &&
-		(pud_val(pud) & (_PAGE_VALID|_PAGE_PUD_HUGE)) != _PAGE_VALID;
+	return pud_leaf(pud);
 }
 
 static void hugetlb_free_pte_range(struct mmu_gather *tlb, pmd_t *pmd,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

